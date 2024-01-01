if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- When local player starts interacting, send a cop to arrest them + activate scan to enable cuffing from other units
if DWP.DWdifficultycheck == true then
	Hooks:PostHook(PlayerStandard, "_start_action_interact", "DWP_cuffing_on_local_player_interaction_start", function(self)
	
		if Network and Network:is_client() then
			return
		end

		DWP.CopUtils:SendCopToArrestPlayer(self._unit)
		
		if self._unit:movement():current_state()._interact_params.tweak_data == "revive" then
			DelayedCalls:Add("delay_for_cuff_scan_on_local", 3, function()
				DWP.CopUtils:NearbyCopAutoArrestCheck(self._unit, true)
			end)
		else
			DelayedCalls:Add("delay_for_cuff_scan_on_local", 1, function()
				DWP.CopUtils:NearbyCopAutoArrestCheck(self._unit, true)
			end)
		end
	
	end)
end