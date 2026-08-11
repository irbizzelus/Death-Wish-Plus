if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- Add every spawn group to the list, not just predefined ones.
-- Allows this mod to add custom squads and spawn groups.

-- If a spawngroup matches this list exactly, it's a "default" one and we can add our own spawngroups to it
local groupsNormal = {
	"tac_shield_wall_charge",
	"FBI_spoocs",
	"tac_tazer_charge",
	"tac_tazer_flanking",
	"tac_shield_wall",
	"tac_swat_rifle_flank",
	"tac_shield_wall_ranged",
	"tac_bull_rush",
	"marshal_squad",
	"snowman_boss",
	"piggydozer"
}

local groupsNoMarshal = {
	"tac_shield_wall_charge",
	"FBI_spoocs",
	"tac_tazer_charge",
	"tac_tazer_flanking",
	"tac_shield_wall",
	"tac_swat_rifle_flank",
	"tac_shield_wall_ranged",
	"tac_bull_rush",
	"snowman_boss",
	"piggydozer"
}

local groupsCustomMaps = {
	"tac_shield_wall_charge",
	"FBI_spoocs",
	"tac_tazer_charge",
	"tac_tazer_flanking",
	"tac_shield_wall",
	"tac_swat_rifle_flank",
	"tac_shield_wall_ranged",
	"tac_bull_rush",
	"single_spooc",
	"marshal_squad",
	"snowman_boss",
	"piggydozer"
}

-- Make the captain and single cloakers not spawn in weird places
local disallowed_groups = {
	Phalanx = true,
	single_spooc = true
}

-- Will break custom heists that dont have standard spawngroups. Replaces spawn groups to our own
Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "DWP_replacespawngroups", function(self)
	
	if not DWP.DWdifficultycheck then
		return
	end
	
	if not self._values.preferred_spawn_groups then
		return
	end
	
	local currentSpawnGroups = self._values.preferred_spawn_groups
	
	if #currentSpawnGroups == #groupsNormal and table.contains_all(currentSpawnGroups, groupsNormal) then
		-- standard groups, good.
	elseif #currentSpawnGroups == #groupsCustomMaps and table.contains_all(currentSpawnGroups, groupsCustomMaps) then
		log("[DW+] 'ElementSpawnEnemyGroup' detected and used a custom maps spawn groups list.")
	elseif #currentSpawnGroups == #groupsNoMarshal and table.contains_all(currentSpawnGroups, groupsNoMarshal) then
		log("[DW+] 'ElementSpawnEnemyGroup' detected and used a marshal-free spawn groups list.")
	else
		return
	end
	
	self._values.preferred_spawn_groups = {}
	for name,_ in pairs(tweak_data.group_ai.enemy_spawn_groups) do
		if not table.contains(self._values.preferred_spawn_groups, name) and not disallowed_groups[name] then
			table.insert(self._values.preferred_spawn_groups, name)
		end
	end
	
end)