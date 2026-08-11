if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- process messages to activate chat commands from ourself
local dwp_orig_send = ChatManager.send_message
function ChatManager:send_message(channel_id, sender, message)
	-- channel 1 is text, others are network? related
	if channel_id ~= 1 then
		dwp_orig_send(self, channel_id, sender, message)
		return
	end
	
	if managers.network:session() then
		sender = managers.network:session():local_peer()
	end
	
	if not message then
		return
	end

	if Network:is_server() and sender and DWP.CM and DWP.CM:validPrefix(message:sub(1, 1)) then
		DWP.CM:process_command(message, sender)
		return -- if host types in a command there's no reason to have 2 messages in chat, 1 with command and another with that command's printed text
	end

	dwp_orig_send(self, channel_id, sender, message)
end

-- process messages to activate chat commands from other peers if we are hosting
Hooks:PostHook(ChatManager, "receive_message_by_peer", "DWP_ChatManager_receive_message_by_peer_post", function(self, channel_id, peer, message)
	if Network:is_server() and DWP.CM and DWP.DWdifficultycheck then
		if peer:id() ~= DWP.CM:local_peer():id() then
			if DWP.CM:validPrefix(message:sub(1, 1)) then
				DWP.CM:process_command(message, peer)
			end
		end
	end
end)