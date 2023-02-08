dofile(ModPath .. "lua/DWPbase.lua")
if rawget(_G, "DWP_CM") then
	rawset(_G, "DWP_CM", nil)
end
-- Globals and utility functions
if not rawget(_G, "DWP_CM") then
	rawset(_G, "DWP_CM", {
		_path = ModPath .. "commands/",
		_prefixes = {
			["/"] = true,
			["!"] = true,
		},
		commands = {}
	})
	
	dofile(ModPath .. "commands/utils.lua")
	
	function DWP_CM:validPrefix(prefix)
		return self._prefixes[prefix]
	end


	function DWP_CM:message(text, title, color, sync)
		if sync then
			managers.chat:send_message(ChatManager.GAME, nil, text)

			return
		end

		if text and type(text) == "string" then
			color = not color and tweak_data.system_chat_color or color

			managers.chat:_receive_message(1, (title or "*"), text, color)
		end
	end

	function DWP_CM:send_message(peer_id, message)
		if not message or (message == "") then
			return
		end

		local peer = managers.network:session():peer(peer_id)
		if peer_id == managers.network:session():local_peer():id() then
			managers.chat:feed_system_message(ChatManager.GAME, message)
		else
			if peer then
				managers.network:session():send_to_peer(peer, "send_chat_message", 1, message)
			end
		end
	end

	function DWP_CM:is_local(peer)
		return self:local_peer():id() == peer:id()
	end

	function DWP_CM:peer(id)
		return managers.network:session():peer(tonumber(id))
	end

	function DWP_CM:local_peer()
		return managers.network:session():local_peer()
	end

	function DWP_CM:peer_list()
		local peers = {}
		for _, peer in pairs(managers.network:session():peers()) do
			if peer then
				table.insert(peers, peer)
			end
		end

		return peers
	end

	function DWP_CM:process_command(input, sender)
		sender = sender or self:local_peer()

		local lower_cmd = string.match(input:sub(2):lower(), "(%w+)")

		local command = self.commands and self.commands[lower_cmd]
		if not command then
			if not Network:is_client() then 
				if sender:id() == 1 then
					DWP_CM:message(string.format("Such command doesn't exist."), "SYSTEM", Color(255,255,0,0) / 255, false)
					return false
				else
					self:send_message(sender:id(), "Such command doesn't exist.")
					return false
				end
			else
				DWP_CM:message(string.format("Such command doesn't exist."), "SYSTEM", Color(255,255,0,0) / 255, false)
				return false
			end
		end

		local args = {}
		input:gsub("([^%s]+)", function(word)
			if not next(args) and word:sub(2) == lower_cmd then
				return
			end

			table.insert(args, word)
		end)
		
	--[[ 
		if command.private and not self:is_local(sender) then
			self:send_message(sender:id(), "You do not have permission to use this command.")
			return false
		end
	--]]
		if command.private and not self:is_local(sender) and not command.exceptions then
			if not Network:is_client() then 
				self:send_message(sender:id(), "You do not have permission to use this command.")
				return false
			else
				return false
			end
		elseif command.private and not self:is_local(sender) and command.exceptions then -- this is in case you want to overwrite command's private status and give access to another player with specified id. only tested it as a host, use at your own risk
			if managers.network:session():peer(sender:id()):user_id() == "this should be a long number of user's id" then -- this is only for 1 id exception, should add check for multiple id's
				--nothing, because we need to check all stuff below, like if command is blocked, in case they start abusing the godly priviliges they were given
			else 
				self:send_message(sender:id(), "This command has exceptions for some clients who may use it. You are not one of them.")
				return false
			end
		end
		
		-- leftover from an extremely old version of chat commands
		if command.command_lock then
			self:send_message(sender:id(), "Command temporarily disabled by host.")
			return false
		end

		if command.host_only and Network:is_client() then
			self:message("Host only!", lower_cmd)
			return false
		end
		
		if command.in_game_only and not DWP_CM:is_playing() then
			self:send_message(sender:id(), "In game only command!")
			return false
		end
		

		if command.callback and type(command.callback) == "function" then
			self:message(command.callback(args, sender), lower_cmd, Color("1E90FF"), not self:is_local(sender))
		end

		return true
	end

	function DWP_CM:process_input(input, sender)
		if input == "" then
			return
		end

		if self:process_command(input, sender) then
			return
		end
	end

	function DWP_CM:add_command(command_name, cmd_data)
		self.commands[command_name] = cmd_data
	end

	dofile(DWP_CM._path .. "commands.lua")
end