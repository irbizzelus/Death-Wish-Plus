Hooks:PostHook(MutatorCG22, "on_game_started", "DWP_xmas_mutator_start", function(self,mutator_manager)
	if DWP.settings.xmas_chaos == true then
		tweak_data.group_ai.special_unit_spawn_limits.tank = 0 -- otherwise this would be a clusterfuck lmao
		self._snowman_spawn_threshold = 1
	end
end)

Hooks:PostHook(MutatorCG22, "_server_on_present_collected", "DWP_xmas_mutator_updatebags", function(self,bag_unit)
	if DWP.settings.xmas_chaos == true and self._snowman_spawn_threshold >= 2 then
		self._snowman_spawn_threshold = 1
	end
end)

-- this doesnt create an infinite loop of dozer spawns, cuz this is a function that syncs hud pop up for clients after dozer gets spawned in via a different "scripted" dozer spawn after securing a bag. we spawn him seperately
Hooks:PostHook(MutatorCG22, "_server_on_snowman_spawned", "DWP_xmas_mutator_moresnowmen", function(self)
	if DWP.settings.xmas_chaos == true then
		managers.groupai:state():spawn_snowman_boss()
	end
end)