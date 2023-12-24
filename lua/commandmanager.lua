if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

if not DWP.CM then
	DWP.CM = {
		prefixes = {
			["/"] = true,
			["!"] = true
		},
		commands = {}
	}
	
	function DWP.CM:validPrefix(prefix)
		return self.prefixes[prefix]
	end

	function DWP.CM:is_playing()
		if BaseNetworkHandler then
			return BaseNetworkHandler._gamestate_filter.any_ingame_playing[game_state_machine:last_queued_state_name()]
		else
			return false
		end
	end

	function DWP.CM:message(text, title, color, sync)
		if sync then
			managers.chat:send_message(ChatManager.GAME, nil, text)
			return
		end

		if text and type(text) == "string" then
			color = not color and tweak_data.system_chat_color or color
			managers.chat:_receive_message(1, (title or "*"), text, color)
		end
	end

	function DWP.CM:send_message(peer_id, message)
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

	function DWP.CM:is_local(peer)
		return self:local_peer():id() == peer:id()
	end

	function DWP.CM:peer(id)
		return managers.network:session():peer(tonumber(id))
	end

	function DWP.CM:local_peer()
		return managers.network:session():local_peer()
	end

	function DWP.CM:peer_list()
		local peers = {}
		for _, peer in pairs(managers.network:session():peers()) do
			if peer then
				table.insert(peers, peer)
			end
		end

		return peers
	end

	function DWP.CM:process_command(input, sender)
		sender = sender or self:local_peer()

		local lower_cmd = string.match(input:sub(2):lower(), "(%w+)")

		local command = self.commands and self.commands[lower_cmd]
		if not command then
			if not Network:is_client() then 
				if sender:id() == 1 then
					DWP.CM:message(string.format("Such command doesn't exist."), "SYSTEM", Color(255,255,0,0) / 255, false)
					return false
				else
					self:send_message(sender:id(), "Such command doesn't exist.")
					return false
				end
			else
				DWP.CM:message(string.format("Such command doesn't exist."), "SYSTEM", Color(255,255,0,0) / 255, false)
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

		if command.host_only and Network:is_client() then
			self:message("Host only!", lower_cmd)
			return false
		end
		
		if command.in_game_only and not DWP.CM:is_playing() then
			self:send_message(sender:id(), "In game only command!")
			return false
		end
		

		if command.callback and type(command.callback) == "function" then
			self:message(command.callback(args, sender), lower_cmd, Color("1E90FF"), not self:is_local(sender))
		end

		return true
	end

	function DWP.CM:process_input(input, sender)
		if input == "" then
			return
		end

		if self:process_command(input, sender) then
			return
		end
	end

	function DWP.CM:add_command(command_name, cmd_data)
		self.commands[command_name] = cmd_data
	end

	dofile(ModPath .. "lua/commands.lua")
end