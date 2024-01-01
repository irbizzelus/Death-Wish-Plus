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
	
	function DWP.CM:add_command(command_name, cmd_data)
		self.commands[command_name] = cmd_data
	end

	function DWP.CM:is_playing()
		if BaseNetworkHandler then
			return BaseNetworkHandler._gamestate_filter.any_ingame_playing[game_state_machine:last_queued_state_name()]
		else
			return false
		end
	end

	function DWP.CM:local_peer()
		return managers.network:session():local_peer()
	end
	
	function DWP.CM:public_chat_message(text)
		if not text or (text == "") then
			return
		end
		managers.chat:send_message(ChatManager.GAME, nil, text)
	end
	
	-- preferably this message should have a [DW+ Private Message] prefix, but we don't actually always need it, so i'll just add it to messages manualy whenver needed
	function DWP.CM:private_chat_message(peer_id, message)
		if not message or (message == "") then
			return
		end
		
		local peer = managers.network:session():peer(peer_id)
		if peer_id == self:local_peer():id() then
			managers.chat:_receive_message(1, "[DW+]", message, tweak_data.system_chat_color or Color(255,255,0,0) / 255)
		else
			if managers.network:session():peer(peer_id) then
				managers.network:session():send_to_peer(peer, "send_chat_message", 1, message)
			end
		end
	end
	
	function DWP.CM:process_command(input, sender)
		sender = sender or self:local_peer()
		if not input or input == "" then
			return
		end
		local lower_cmd = string.match(input:sub(2):lower(), "(%w+)")
		local command = self.commands and self.commands[lower_cmd]
		
		if not command then
			if not Network:is_client() then
				if DWP.DWdifficultycheck then
					self:private_chat_message(sender:id(), "Such command doesn't exist.")
					return
				else
					self:private_chat_message(sender:id(), "Chats commands are disabled for non-DW difficulty contracts.")
					return
				end
			else
				self:private_chat_message(sender:id(), "Commands are disabled if you are not the lobby host.")
				return
			end
		end
		
		if command.in_game_only and not self:is_playing() then
			self:private_chat_message(sender:id(), "In game only command!")
			return
		end

		if command.callback and type(command.callback) == "function" then
			command.callback(sender)
		end
	end

	dofile(ModPath .. "lua/commands.lua")
end