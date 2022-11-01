dofile(ModPath .. "lua/DWPbase.lua")

-- When a client starts interacting, send a cop to try and arrest them
if DWP.DWdifficultycheck == true then
	Hooks:PostHook(HuskPlayerMovement, "sync_interaction_anim_start", "huskinteract_sendcoptoarrest", function(self)
		-- Only the host should send cops
		if Network and Network:is_client() then
			return
		end
		DWPMod.CopUtils:SendCopToArrestPlayer(self._unit)
	end)
end
