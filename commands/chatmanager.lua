--dofile(ModPath .. "lua/DWPbase.lua")

-- process send messages to activate chat commands if prefix exists
local orig_send = ChatManager.send_message
function ChatManager:send_message(channel_id, sender, message)
	if channel_id ~= 1 then
		orig_send(self, channel_id, sender, message)
		return
	end
	
	if managers.network:session() then
		sender = managers.network:session():local_peer()
	end
	
	if not message then -- fix for sending messages to clients privately
		return
	end

	local CM = _G["DWP_CM"]
	if CM then
		if CM:validPrefix(message:sub(1, 1)) and sender then
			if Network:is_server() then
				CM:process_input(message, sender)
				return
			end
		end
	end

	orig_send(self, channel_id, sender, message)
end

-- same check for messages from other peers/players
local orig_receive = ChatManager.receive_message_by_peer
function ChatManager:receive_message_by_peer(channel_id, peer, message)
	if peer:id() == 1 and Network:is_client() then -- if host sends us a message starting with dwp_stats, we ignore it. why? to not have duplicated messages
		if message:sub(1, 11) == "[DWP_Stats]" then
			return
		end
	end
	orig_receive(self, channel_id, peer, message)

	local CM = _G["DWP_CM"]
	if CM then
		if peer:id() ~= CM:local_peer():id() then
			if CM:validPrefix(message:sub(1, 1)) then
				if Network:is_server() then
					CM:process_input(message, peer)
				end
			end
		end
	end
end