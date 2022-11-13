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
	local active_hostages_mul = 1
	local killed_hostages_mul = 1
	if DWP.settings.hostagesbeta == true and self._hostage_headcount >= 3 then
		active_hostages_mul = 1.2
	end
	if DWP.settings.hostagesbeta == true and DWP.hostagekillcount and DWP.hostagekillcount >= 3 then
		killed_hostages_mul = 0.8
	end
	if DWP.settings.hostagesbeta == true and DWP.hostagekillcount and DWP.hostagekillcount >= 7 then
		killed_hostages_mul = 0.5
	end
		if self._spawning_groups and #self._spawning_groups >= 1 then
			for i=1, #self._spawning_groups do
				for _, sp in ipairs(self._spawning_groups[i].spawn_group.spawn_pts) do
					if DWP.grouptypecheck(self._spawning_groups[i].group) == false then
						if sp.interval then
							sp.interval = DWP.settings.respawns * active_hostages_mul * killed_hostages_mul
						end
					else
						if sp.interval then
							sp.interval = DWP.settings.respawns * 2 * active_hostages_mul * killed_hostages_mul
						end
					end
				end
			end
		end
	end )
	
	function GroupAIStateBesiege:_get_special_unit_type_count(special_type)
		if not self._special_units[special_type] then
			return 0
		end
		
		if special_type == "tank" then
			local tanks = table.size(self._special_units[special_type])

			if self._special_units["tank_mini"] then
				tanks = tanks + table.size(self._special_units["tank_mini"])
			end

			if self._special_units["tank_medic"] then
				tanks = tanks + table.size(self._special_units["tank_medic"])
			end

			return tanks
		else
			return table.size(self._special_units[special_type])
		end
	end
end