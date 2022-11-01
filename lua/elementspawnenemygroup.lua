-- Add every spawn group to the list, not just predefined ones.
-- Allows this mod to add custom squads and spawn groups.

-- If a spawngroup matches this list exactly, it's a "default" one and we can add our own spawngroups to it
local groupsOLD = {
	"tac_shield_wall_charge",
	"FBI_spoocs",
	"tac_tazer_charge",
	"tac_tazer_flanking",
	"tac_shield_wall",
	"tac_swat_rifle_flank",
	"tac_shield_wall_ranged",
	"tac_bull_rush",
	"marshal_squad"
}

-- Make the captain and single cloakers not spawn in weird places
local disallowed_groups = {
	Phalanx = true,
	single_spooc = true
}

-- Will break custom heists that dont have standard spawngroups.
Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "elementspawnenemygroup_replacespawngroups", function(self)
	if self._values.preferred_spawn_groups and #self._values.preferred_spawn_groups == #groupsOLD and table.contains_all(self._values.preferred_spawn_groups, groupsOLD) then
		self._values.preferred_spawn_groups = {}
		for name,_ in pairs(tweak_data.group_ai.enemy_spawn_groups) do
			if not table.contains(self._values.preferred_spawn_groups, name) and not disallowed_groups[name] then
				table.insert(self._values.preferred_spawn_groups, name)
			end
		end
	end
end)
