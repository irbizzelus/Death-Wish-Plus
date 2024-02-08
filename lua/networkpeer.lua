if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

Hooks:PostHook(NetworkPeer, "set_loading", "DWP_set_loading", function(self, state)
	if managers.network and managers.network._session and Network:is_server() and Utils:IsInGameState() then
		
		local peer_id = self:id()
		local peer = managers.network:session():peer(peer_id)
		if peer == managers.network:session():local_peer() then
			DWP.players[peer_id].welcome_msg1_shown = true
			DWP.players[peer_id].welcome_msg2_shown = true
			DWP.players[peer_id].skills_shown = true
			DWP.players[peer_id].hours_shown = true
			return
		end
		
		if state == false then
			DWP:welcomemsg1(peer_id)
			DWP:welcomemsg2(peer_id)
		end
	end
	
	if managers.network and managers.network._session and not Network:is_server() then
		local peer_id = self._id
		local peer = managers.network:session():peer(peer_id)
		if peer == managers.network:session():local_peer() then
			DWP.players[peer_id].welcome_msg1_shown = true
			DWP.players[peer_id].welcome_msg2_shown = true
			DWP.players[peer_id].skills_shown = true
			DWP.players[peer_id].hours_shown = true
		end
	end
	
end)

Hooks:PostHook(NetworkPeer, "set_outfit_string", "DWP_set_outfit_string", function(self)
	if not self or not self:id() then
		return
	end
	local peer_id = self:id()
	DelayedCalls:Add("DWP_stats_for_" .. tostring(peer_id), 1 , function()
		if managers.network and managers.network._session and managers.network:session():peer(peer_id) then
			DWP:returnplayerhours(peer_id)
			DWP:return_skills(peer_id)
		end
	end)
end)

Hooks:Add("BaseNetworkSessionOnLoadComplete", "DWP_onloadcomplete", function(peer, id)
	-- in case user restarts a match after changing difficulty, update lobby name to appropriate amount of +'s if DWdifficultycheck is true
	DelayedCalls:Add("DWP_updatelobbyname_after_lobby_start_or_restart", 5, function()
		if managers and managers.network and managers.network._session and managers.network.matchmake and Network:is_server() and Utils:IsInGameState() then
			DWP.change_lobby_name(DWP.DWdifficultycheck)
		end
	end)
end)

Hooks:Add("NetworkManagerOnPeerAdded", "DWP_onpeeradded", function(peer, peer_id)
	-- my name is username(), traveler
	if Network:is_server() then
		DelayedCalls:Add("DWP_updatelobbyname_and_info_for_" .. tostring(peer_id), 0.1, function()
			local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
			if peer2 then
				peer2:send("request_player_name_reply", managers.network.account:username())
			end
			DelayedCalls:Add("DWP_showstatsfor_" .. tostring(peer_id), 1, function()
				DWP:returnplayerhours(peer_id)
				DWP:return_skills(peer_id)
				
				-- greetings
				if not Utils:IsInGameState() and managers.network and managers.network._session and Network:is_server() and managers.network:session():peer(peer_id) then
					DWP:welcomemsg1(peer_id)
					DWP:welcomemsg2(peer_id)
				end
			end)
		end)
	end
end)

Hooks:Add("BaseNetworkSessionOnPeerRemoved", "DWP_onpeerremoved", function(peer, peer_id, reason)
	DWP.players[peer_id] = {
		skills_shown = false,
		hours_shown = false,
		welcome_msg1_shown = false,
		welcome_msg2_shown = false,
		requested_mods_1 = false,
		requested_mods_2 = false,
		HC_warning_messages = {
			civilian = 0,
			cop = 0
		}
	}
end)