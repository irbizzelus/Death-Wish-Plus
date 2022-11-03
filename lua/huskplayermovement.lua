dofile(ModPath .. "lua/DWPbase.lua")

-- When a client starts interacting, send a cop to try and arrest them
if DWP.DWdifficultycheck == true then
	Hooks:PostHook(HuskPlayerMovement, "sync_interaction_anim_start", "huskinteract_sendcoptoarrest", function(self)
		-- Only the host should send cops
		if Network and Network:is_client() then
			return
		end
		DWPMod.CopUtils:SendCopToArrestPlayer(self._unit)
		
		if DWP.settings.arrestbeta then
			DelayedCalls:Add("delay_for_cuff_scan_husk", 1.05, function()
				DWPMod.CopUtils:NearbyCopAutoArrestCheck(self._unit, false)
			end)
		end
		
	end)
end
