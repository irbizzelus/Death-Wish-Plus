dofile(ModPath .. "lua/DWPbase.lua")

if DWP.settings.lobbyname then
	if SystemInfo:distribution() == Idstring("STEAM") then
	function NetworkMatchMakingSTEAM:change_lobby_name(message)--the thing that does all the magic
		if self._lobby_attributes and self.lobby_handler then
			self._lobby_attributes.owner_name = message
			self.lobby_handler:set_lobby_data(self._lobby_attributes)
		end
	end
	
	
	--This fuckery is checking for current lobby name var, to switch lobby name to that var, or otherwise just use player's username
	--Why is it here? Whenever we buy a contract, lobbyname var changes to either username or 'death wish+' depending on contract difficulty
	--But if we buy a contract before we have created a lobby, function mentioned above is not used, because reasons.
	--This is just a workaround, that makes sure, that our lobby name is always appropriate to our contract difficulty.
	--Note: this workaround only causes 1 issue: if we created a DW lobby, then quit, and then created an empty lobby (vanila hud or other mods) lobby name will be "Death Wish+"
	--But honestly, its whatever, since after buying a contract name will change accoridingly
	Hooks:PostHook(NetworkMatchMakingSTEAM, "set_attributes", "DWP_swapname", function()
		if DWP.curlobbyname ~= nil then
			managers.network.matchmake:change_lobby_name(DWP.curlobbyname)
		else
			managers.network.matchmake:change_lobby_name(managers.network.account:username_id())
		end
	end)
	
	Hooks:Add("NetworkManagerOnPeerAdded", "changelobbyname", function(peer, peer_id) --Change host name for peers when they join
		if Network:is_server() then
			DelayedCalls:Add("updatelobbyname" .. tostring(peer_id), 0.1, function()
				local peer2 = managers.network:session() and managers.network:session():peer(peer_id)
				if peer2 then
					peer2:send("request_player_name_reply", managers.network.account:username())
				end
			end)
			
		end
	end)
	end
end