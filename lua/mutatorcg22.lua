Hooks:PostHook(MutatorCG22, "on_game_started", "DWP_xmas_mutator_start", function(self,mutator_manager)
	if DWP.settings.xmas_chaos == true then
		self._snowman_spawn_threshold = 3
		if DWP.DWdifficultycheck == true then
			tweak_data.group_ai.special_unit_spawn_limits.tank = 2 -- otherwise this would be a clusterfuck lmao
		end
	end
end)

Hooks:PostHook(MutatorCG22, "_server_on_present_collected", "DWP_xmas_mutator_updatebags", function(self,bag_unit)
	if DWP.settings.xmas_chaos == true and self._snowman_spawn_threshold >= 4 then
		self._snowman_spawn_threshold = 3
	end
end)