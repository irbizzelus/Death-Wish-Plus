if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- process send_message to activate chat commands if prefix exists in our message
local orig_send = ChatManager.send_message
function ChatManager:send_message(channel_id, sender, message)
	-- channel 1 is text, others are network related
	if channel_id ~= 1 then
		orig_send(self, channel_id, sender, message)
		return
	end
	
	-- failsafe? idk why its in the base game's function, but might as well keep it
	if managers.network:session() then
		sender = managers.network:session():local_peer()
	end
	
	-- better safe then sorry
	if not message then
		return
	end

	-- proccessing
	if DWP.CM then
		if DWP.CM:validPrefix(message:sub(1, 1)) and sender then
			if Network:is_server() then
				DWP.CM:process_command(message, sender)
				-- if host types in a command there's no reason to have 2 messages in chat, 1 with command and another with that command's printed text
				return
			end
		end
	end

	orig_send(self, channel_id, sender, message)
end

-- same check for messages from other peers/players
local orig_receive = ChatManager.receive_message_by_peer
function ChatManager:receive_message_by_peer(channel_id, peer, message)
	-- if host sends us a message starting with dwp_stats, we ignore it. why? to not have duplicated player info messages
	-- this is legacy code at this point, since 2.5 these messages are always private
	-- will keep it for a bit to prevent duplicates in case host runs an outdated version of dw+
	if peer:id() == 1 and Network:is_client() then
		if message:sub(1, 11) == "[DWP_Stats]" then
			return
		end
	end
	orig_receive(self, channel_id, peer, message)

	-- proccessing requests if we are hosting
	if DWP.CM then
		if Network:is_server() then
			if peer:id() ~= DWP.CM:local_peer():id() then
				if DWP.CM:validPrefix(message:sub(1, 1)) then
					DWP.CM:process_command(message, peer)
				end
			end
		end
	end
end