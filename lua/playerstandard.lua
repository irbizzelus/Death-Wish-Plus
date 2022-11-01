dofile(ModPath .. "lua/DWPbase.lua")

-- When local player starts interacting, send a cop to try and arrest them
if DWP.DWdifficultycheck == true then
	Hooks:PostHook(PlayerStandard, "_start_action_interact", "startinteract_arrestlocalplayer", function(self)
		if Network and Network:is_client() then
			return
		end

		DWPMod.CopUtils:SendCopToArrestPlayer(self._unit)
	end)
end
