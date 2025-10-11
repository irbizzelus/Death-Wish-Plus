if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- When a client starts interacting, send a cop to arrest them + activate scan to enable cuffing from other units
Hooks:PostHook(HuskPlayerMovement, "sync_interaction_anim_start", "DWP_cuffing_on_husk_interaction_start", function(self,tweak)

	if not DWP.DWdifficultycheck then
		return
	end
	
	if Network and Network:is_client() then
		return
	end
	
	DWP.CopUtils:SendCopToArrestPlayer(self._unit)
	
	-- make cuffing checks for clients without DSBW installed only
	if not DWP.peers_with_mod[managers.network:session():peer_by_unit(self._unit):id()] then
		
		-- check starts slightly later for connected peers to prevent cuffing on players with high ping
		DWP.CopUtils.allowed_cuffing_time = DWP.CopUtils.allowed_cuffing_time or {0,0,0,0}
		
		if tweak == "revive" then
			DWP.CopUtils.allowed_cuffing_time[managers.network:session():peer_by_unit(self._unit):id()] = Application:time() + 3.4 -- should cover up to 300 ping, theoretically
		else
			DWP.CopUtils.allowed_cuffing_time[managers.network:session():peer_by_unit(self._unit):id()] = Application:time() + 1.4
		end
		
		DelayedCalls:Add("DWP_delay_for_cuff_scan_on_husk_"..tostring(self._unit), 1, function()
			DWP.CopUtils:NearbyCopAutoArrestCheck(self._unit, false)
		end)
		
	end
	
end)