if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- When a client starts interacting, send a cop to arrest them + activate scan to enable cuffing from other units
if DWP.DWdifficultycheck == true then
	Hooks:PostHook(HuskPlayerMovement, "sync_interaction_anim_start", "DWP_cuffing_on_husk_interaction_start", function(self,tweak)

		if Network and Network:is_client() then
			return
		end
		
		DWP.CopUtils:SendCopToArrestPlayer(self._unit)
		-- check starts slightly later to prevent cuffing on players with high ping
		if tweak == "revive" then
			DelayedCalls:Add("delay_for_cuff_scan_on_husk_"..tostring(self._unit), 3.1, function()
				DWP.CopUtils:NearbyCopAutoArrestCheck(self._unit, false)
			end)
		else
			DelayedCalls:Add("delay_for_cuff_scan_on_husk"..tostring(self._unit), 1.1, function()
				DWP.CopUtils:NearbyCopAutoArrestCheck(self._unit, false)
			end)
		end
		
	end)
end
