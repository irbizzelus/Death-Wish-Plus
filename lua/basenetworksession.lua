if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

local function DWP_statsmessage(message)
	if Network:is_server() then
		managers.chat:_receive_message(1, "[DW+]", message, DWP.color)
		if DWP.settings.endstats_public then
			for i=2,4 do
				local peer = managers.network:session():peer(i)
				if peer then
					peer:send("send_chat_message", ChatManager.GAME, message)
				end
			end
		end
	end
end

Hooks:PostHook(BaseNetworkSession, "on_statistics_recieved", "DWP_endgamestats", function(self, peer_id, peer_kills, peer_specials_kills, peer_head_shots, accuracy, downs)
	-- if enabled, print stats in post game chat with customizable settings
	-- this part is the first message that creates a "header" explaining each column below
	if not DWP.end_stats_header_printed then
		DWP.end_stats_header_printed = true
		DelayedCalls:Add("DWP_endStatsAnnounce", 0.5, function()
			if DWP.settings.endstats_enabled then
				local specials = ""
				local headshoots = ""
				local acc = ""
				if DWP.settings.endstats_specials then specials = "(Specials)" end
				if DWP.settings.endstats_headshots then headshoots = " Headshots |" end
				if DWP.settings.endstats_accuracy then acc = " Accuracy |" end
				local message = "KDR: | Kills"..specials.." // Downs |"..headshoots..acc
				DWP_statsmessage(message)
			end
		end)
	end
	
	-- same as above, but print actual numerical values that we have for each existing player
	DelayedCalls:Add("DWP_endStatsForPeer_"..tostring(peer_id) , 1.25, function()
		if DWP.settings.endstats_enabled then
			local peer = managers.network:session():peer(peer_id)
			if peer and peer:has_statistics() then
				local specials = ""
				local headshoots = ""
				local acc = ""
				if DWP.settings.endstats_specials then specials = "(" .. peer_specials_kills .. ")" end
				if DWP.settings.endstats_headshots then headshoots = " " .. peer_head_shots .. " |" end
				if DWP.settings.endstats_accuracy then acc = " " .. accuracy .. "%" .. " |" end
				local message = "| "..peer_kills..specials.." // "..downs.." |"..headshoots..acc.." <- "..peer:name()
				DWP_statsmessage(message)
			end
		end
	end)
end)

-- only sync to clients as host, or as client only try to sync with host
Hooks:Add("BaseNetworkSessionOnLoadComplete", "DWP_send_hello", function(local_peer, id)
	
	if Network:is_server() and DWP and DWP.DWdifficultycheck then
		
		local diff_id = DWP.settings.difficulty
		if Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.difficulty then
			diff_id = DWP.settings_config.difficulty
		end
		
		local ecm_chance = math.floor(DWP.settings.ecm_feedback_chance * 100)
		if Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.ecm_feedback_chance then
			ecm_chance = math.floor(DWP.settings_config.ecm_feedback_chance * 100)
		end
		
		local hostage_control = DWP.settings.hostage_control and 2 or 1 -- ngl, prob should've made this just a true or false string instead of this 1 and 2 shit
		if Utils:IsInGameState() and DWP.settings_config then
			if DWP.settings_config.hostage_control then
				hostage_control = 2
			else
				hostage_control = 1
			end
		end
		
		local settings_string = "|"..tostring(diff_id).."|"..tostring(ecm_chance).."|"..tostring(hostage_control).."|"
		LuaNetworking:SendToPeersExcept(1, "DWP_sync", "Hello_"..tostring(DWP.version)..settings_string)
		
	elseif Network:is_client() then
		
		LuaNetworking:SendToPeer(1, "DWP_sync", "Hello!")
		
	end
	
end)

-- same as above but for new joiners
Hooks:Add("BaseNetworkSessionOnPeerEnteredLobby", "DWP_send_hello_to_new_joiner", function(peer, peer_id)
	
	if Network:is_server() and DWP and DWP.DWdifficultycheck then
		
		local diff_id = DWP.settings.difficulty
		if Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.difficulty then
			diff_id = DWP.settings_config.difficulty
		end
		
		local ecm_chance = math.floor(DWP.settings.ecm_feedback_chance * 100)
		if Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.ecm_feedback_chance then
			ecm_chance = math.floor(DWP.settings_config.ecm_feedback_chance * 100)
		end
		
		local hostage_control = DWP.settings.hostage_control and 2 or 1
		if Utils:IsInGameState() and DWP.settings_config then
			if DWP.settings_config.hostage_control then
				hostage_control = 2
			else
				hostage_control = 1
			end
		end
		
		local settings_string = "|"..tostring(diff_id).."|"..tostring(ecm_chance).."|"..tostring(hostage_control).."|"
		LuaNetworking:SendToPeer(peer_id, "DWP_sync", "Hello_"..tostring(DWP.version)..settings_string)
		
	elseif Network:is_client() and peer_id == 1 then
		
		LuaNetworking:SendToPeer(1, "DWP_sync", "Hello!")
	
	end
	
end)

-- proccessing received data
Hooks:Add("NetworkReceivedData", "DWP_NetworkReceivedData", function(sender, messageType, data)
	if messageType == "DWP_sync" and string.sub(data, 1, 5) == "Hello" then
		DWP.peers_with_mod[sender] = true
		if sender == 1 and string.sub(data, 1, 6) == "Hello_" then
			if not DWP._is_client_in_DWP_lobby then
				DWP._is_client_in_DWP_lobby = true
				local splits = string.split(data, "|")
				local diff = "Incorrect diff setting sent by host;"
				local diff_names = {
					[1] = "DW+ Classic;",
					[2] = "DW++;",
					[3] = "Insanity;",
					[4] = "Suicidal;",
				}
				if type(tonumber(splits[2])) == "number" and diff_names[tonumber(splits[2])] then
					diff = diff_names[tonumber(splits[2])]
				end
				local ecm_str = "ECM feedback setting info was not received properly."
				if type(tonumber(splits[3])) == "number" then
					local ecm_sett = tonumber(splits[3])
					local old_ecm_settings = {
						[1] = "allowed.",
						[2] = "reduced.",
						[3] = "muted.",
					}
					if ecm_sett < 20 or ecm_sett > 80 then
						ecm_str = "Received ECM feedback setting info was invalid."
						if old_ecm_settings[ecm_sett] then
							ecm_str = "ECM feedback is using pre patch 2.8 preset, and is "..old_ecm_settings[ecm_sett]
						end
					else
						ecm_str = "ECM feedback stun chance: "..ecm_sett.."%"
					end
				end
				local HC = "Incorrect hostage control setting sent by host;"
				local HC_settings = {
					[1] = "disabled;",
					[2] = "enabled;",
				}
				if type(tonumber(splits[4])) == "number" and HC_settings[tonumber(splits[4])] then
					HC = HC_settings[tonumber(splits[4])]
				end
				local host_version = string.sub(splits[1], 7, -1)
				
				local msg_1 = "Host is running \"Death Wish +\" at version \""..tostring(host_version).."\", with following settings:\nDifficulty: "..diff.."\n"..ecm_str.."\nHostage control is "..HC
				local msg_2 = "If you want a reminder, you could use: /ai; /cops; /cuffs; /dom; /assault; /hostage; /hcstatus; /diff; /ecm; /rng; /hostmods. Good luck."
				DWP.CM:private_chat_message(managers.network:session():local_peer():id(), msg_1)
				DWP.CM:private_chat_message(managers.network:session():local_peer():id(), msg_2)
			end
		end
	end
end)

-- remove sync on peer leave
Hooks:Add("BaseNetworkSessionOnPeerRemoved", "DWP_BaseNetworkSessionOnPeerRemoved", function(peer, peer_id, reason)
	DWP.peers_with_mod[peer_id] = nil
end)