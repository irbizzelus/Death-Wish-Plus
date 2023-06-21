Hooks:Add("NetworkManagerOnPeerAdded", "DWP_onpeeradded", function(peer, peer_id)
	DWP:plyerjoin(peer_id)
	DWP.players[peer_id][2] = true
	if Network:is_server() then
		DelayedCalls:Add("DWP_updatelobbyname" .. tostring(peer_id), 0.1, function()
			local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
			if peer2 then
				peer2:send("request_player_name_reply", managers.network.account:username())
			end
		end)
	end
end)

Hooks:Add("BaseNetworkSessionOnPeerRemoved", "DWP_onpeerremoved", function(peer, peer_id, reason)
	for i=1,2 do
		DWP.players[peer_id][i] = 0
	end
	-- if hostage control is enabled, reset hostage kill count whenever player disconects
	if DWP.HostageControl.PeerHostageKillCount[peer_id] and DWP.HostageControl.PeerHostageKillCount[peer_id] >= 1 then
		DWP.HostageControl.PeerHostageKillCount[peer_id] = 0
	end
end)
	
Hooks:Add("BaseNetworkSessionOnLoadComplete", "DWP_onloadcomplete", function(peer, id) -- after loading into a game send to all allready synched clients skill information
	DWP.loadcomplete = true
	if managers.network.matchmake._lobby_attributes and managers.network.matchmake.lobby_handler then
		if managers.network.matchmake._lobby_attributes.difficulty == 7 then
			DWP.curlobbyname = "Death Wish +"
		else
			DWP.curlobbyname = managers.network.account:username_id()
		end
	end
	DelayedCalls:Add("DWP_skilsforpeer_" .. tostring(id), 0.5 , function()
		if managers.network._session and #managers.network:session():peers() > 0 then
			DWP:skills(id)
			for i=1,#DWP.synced do
				DWP:infomessages(DWP.synced[i])
			end
		end
	end)
end)

-- print skills when player joins. yes, it needs the outfit to load first idek anymore
Hooks:PostHook(NetworkPeer, "set_outfit_string", "DWP_on_outfitset", function(self, outfit_string, outfit_version, outfit_signature)
	DelayedCalls:Add("DWP_skills_for" .. tostring(self:id()), 0.5 , function()
		if managers.network._session and managers.network:session():peer(self:id()) then
			DWP:returnplayerhours(self:id(), managers.network:session():peer(self:id()):user_id())
		end
		DWP:skills(self:id())
	end)
end)

Hooks:PostHook(NetworkPeer, "set_loading", "DWP_onloaddone", function(self, state) -- print welcomemsg's to joined clients if in game
	if self._loaded == true then
		if Utils:IsInGameState() then
			DWP:welcomemsg1(self:id())
			DWP:welcomemsg2(self:id())
		end
	end
end)