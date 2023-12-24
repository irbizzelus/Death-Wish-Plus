if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

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
	"marshal_squad",
	"snowman_boss",
	"piggydozer"
}

local groupsOLD_custom = {
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

-- hardware store cutsom heist fix
if Global.level_data and (Global.level_data.level_id == "hardware_store" or Global.level_data.level_id == "tj_htsb") then
	-- i deem these maps too hard due to scripted spawns (at least that's why i think there is so many more cops (85+ on dw+))
	
	if tweak_data and tweak_data.group_ai and tweak_data.group_ai.besiege.assault.force_balance_mul then
		if DWP.settings.difficulty == 4 then
			tweak_data.group_ai.besiege.assault.force_balance_mul = {
				4.5,
				4.5,
				4.5,
				4.5
			}
		elseif DWP.settings.difficulty == 3 then
			tweak_data.group_ai.besiege.assault.force_balance_mul = {
				2.8,
				2.8,
				2.8,
				2.8
			}
		elseif DWP.settings.difficulty == 2 then
			tweak_data.group_ai.besiege.assault.force_balance_mul = {
				1.9,
				1.9,
				1.9,
				1.9
			}
		else
			tweak_data.group_ai.besiege.assault.force_balance_mul = {
				1.4,
				1.4,
				1.4,
				1.4
			}
		end
	end
end

-- Make the captain and single cloakers not spawn in weird places
local disallowed_groups = {
	Phalanx = true,
	single_spooc = true
}

-- Will break custom heists that dont have standard spawngroups. Replaces spawn groups to our own
Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "DWP_replacespawngroups", function(self)
	if (self._values.preferred_spawn_groups and #self._values.preferred_spawn_groups == #groupsOLD and table.contains_all(self._values.preferred_spawn_groups, groupsOLD)) or (self._values.preferred_spawn_groups and #self._values.preferred_spawn_groups == #groupsOLD_custom and table.contains_all(self._values.preferred_spawn_groups, groupsOLD_custom)) then
		if self._values.preferred_spawn_groups and #self._values.preferred_spawn_groups == #groupsOLD_custom and table.contains_all(self._values.preferred_spawn_groups, groupsOLD_custom) then
			log("[Death With +] Attempting to use fix for no enemy spawns on custom maps.")
		end
		self._values.preferred_spawn_groups = {}
		for name,_ in pairs(tweak_data.group_ai.enemy_spawn_groups) do
			if not table.contains(self._values.preferred_spawn_groups, name) and not disallowed_groups[name] then
				table.insert(self._values.preferred_spawn_groups, name)
			end
		end
	end
end)