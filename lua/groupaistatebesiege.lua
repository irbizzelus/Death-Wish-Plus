-- make all enemy squad spawns faster but keep dozer and cloakers at a normal rate
if DWP.DWdifficultycheck == true then
	GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS = 4
	function DWP.grouptypecheck(group)
		local limittypes = {
			"FBI_tanks",
			"FBI_spoocs",
			"single_spooc"
		}
		for i=1,#limittypes do
			if group.type == limittypes[i] then
				return true
			end
			return false
		end
	end

	Hooks:PostHook(GroupAIStateBesiege, "_upd_assault_task", "DWP_updassault", function(self, ...)
		if self._spawning_groups and #self._spawning_groups >= 1 then
			for i=1, #self._spawning_groups do
				for _, sp in ipairs(self._spawning_groups[i].spawn_group.spawn_pts) do
					if DWP.grouptypecheck(self._spawning_groups[i].group) == false then
						if sp.interval then
							sp.interval = DWP.settings.respawns
						end
					else
						if sp.interval then
							sp.interval = DWP.settings.respawns * 2
						end
					end
				end
			end
		end
	end )
end