dofile(ModPath .. "lua/DWPbase.lua")

local function string_startswith(String, Start)
	return string.sub(String,1,string.len(Start))==Start
end

-- holdout check
local level = Global.level_data and Global.level_data.level_id
if level and string_startswith(level, "skm_") then
	return
end

local access_type_walk_only = {
	walk = true
}

local access_type_all = {
	acrobatic = true,
	walk = true
}

Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "DWPtweak_initunitcategories", function(self, difficulty_index)
	if difficulty_index == 7 then
		DWP.DWdifficultycheck = true
		DWP.setnewdoms()
		-- random missing halloween cop
			table.insert(self.unit_categories.CS_cop_C45_R870.unit_types.zombie, Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"))

		-- Overkill made yet another typo which crashes the game on Federales heists, evidently folder and unit names are too far away from each other for them to see
		-- But why would they care if those enemy types are not used by default?
		
		-- Fixed it by setting the Federales FBI groups to be identical to America
			self.unit_categories.FBI_suit_C45_M4.unit_types.federales = self.unit_categories.FBI_suit_C45_M4.unit_types.america
			self.unit_categories.FBI_suit_M4_MP5.unit_types.federales = self.unit_categories.FBI_suit_M4_MP5.unit_types.america
		-- Same with murkywater
			self.unit_categories.FBI_suit_C45_M4.unit_types.murkywater = self.unit_categories.FBI_suit_C45_M4.unit_types.america
			self.unit_categories.FBI_suit_M4_MP5.unit_types.murkywater = self.unit_categories.FBI_suit_M4_MP5.unit_types.america

		-- Re-add Benelli and UMP greys, green fbi swats and shields
			self.unit_categories.FBI_swat_M4.unit_types.america = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") -- added twice to hopefuly increase chances of this type appearing along the others
			}

			self.unit_categories.FBI_swat_R870.unit_types.america = {
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
			}
			
			self.unit_categories.FBI_shield.unit_types.america = {
				Idstring("units/payday2/characters/ene_shield_1/ene_shield_1"),
				Idstring("units/payday2/characters/ene_city_shield/ene_city_shield")
			}
			
			

		-- Change dozer types
		self.unit_categories.FBI_tank = {
			special_type = "tank",
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"),
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
				},
				russia = {
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga")
				},
				zombie = {
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"),
					Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"),
					Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_medic/ene_murkywater_bulldozer_medic"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga")
				}
			},
			access = access_type_all
		}
		if DWP.settings.DSdozer == true then
			self.unit_categories.FBI_tank.unit_types.america = {
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"),
				Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
				Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
			}
		end
		
		self.special_unit_spawn_limits = {
			shield = 6,
			medic = 5,
			taser = 6,
			tank = 4,
			spooc = 3
		}
		
		if DWP.settings.bAmMarsh == true then
			self.unit_categories.marshal_marksman.unit_types.america = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_2/ene_male_marshal_marksman_2")
			}
		end
		
		self.unit_categories.UnDeadHostageAvengers = {
			special_type = "tank",
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween")
				},
				russia = {
					Idstring("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween")
				},
				zombie = {
					Idstring("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween")
				},
				murkywater = {
					Idstring("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween")
				},
				federales = {
					Idstring("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween")
				}
			},
			access = access_type_all
		}
	
	else
		DWP.DWdifficultycheck = false
	end
end)


-- SPAWNGROUPS
Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "DWP_spawngroupstweak", function(self, difficulty_index)
	if difficulty_index == 7 then
	-- Change spawn groups to our own
	self.enemy_spawn_groups = {}
	
	-- Tactics
	self._tactics = {
		Phalanx_minion = {
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		Phalanx_vip = {
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		CS_cop = {
			"provide_coverfire",
			"provide_support",
			"ranged_fire"
		},
		CS_cop_stealth = {
			"flank",
			"provide_coverfire",
			"provide_support"
		},
		CS_swat_rifle = {
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"deathguard"
		},
		CS_swat_shotgun = {
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield_cover"
		},
		CS_swat_heavy = {
			"smoke_grenade",
			"charge",
			"flash_grenade",
			"provide_coverfire",
			"provide_support"
		},
		CS_shield = {
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		CS_swat_rifle_flank = {
			"flank",
			"flash_grenade",
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support"
		},
		CS_swat_shotgun_flank = {
			"flank",
			"flash_grenade",
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support"
		},
		CS_swat_heavy_flank = {
			"flank",
			"flash_grenade",
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield_cover"
		},
		CS_shield_flank = {
			"flank",
			"charge",
			"flash_grenade",
			"provide_coverfire",
			"provide_support",
			"shield"
		},
		CS_tazer = {
			"flank",
			"charge",
			"flash_grenade",
			"shield_cover",
			"murder"
		},
		CS_sniper = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support"
		},
		FBI_suit = {
			"flank",
			"ranged_fire",
			"flash_grenade"
		},
		FBI_suit_stealth = {
			"provide_coverfire",
			"provide_support",
			"flash_grenade",
			"flank"
		},
		FBI_swat_rifle = {
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"charge",
			"provide_support",
			"ranged_fire"
		},
		FBI_swat_shotgun = {
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support"
		},
		FBI_heavy = {
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield_cover",
			"deathguard"
		},
		FBI_shield = {
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		FBI_swat_rifle_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support"
		},
		FBI_swat_shotgun_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support"
		},
		FBI_heavy_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield_cover"
		},
		FBI_shield_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield"
		},
		FBI_tank = {
			"charge",
			"deathguard",
			"shield_cover",
			"smoke_grenade"
		},
		spooc = {
			"charge",
			"shield_cover",
			"smoke_grenade",
			"flash_grenade"
		},
		marshal_marksman = {
			"ranged_fire",
			"flank"
		},
		-- tactics for snowman specifically
		tank_rush = {
			"charge",
			"murder"
		},
	}
	-- commented are defualt marshal unit values we will buff em up a 'bit'
	if Global.level_data and Global.level_data.level_id == "trai" or Global.game_settings and Global.game_settings.level_id == "trai" then
		self.enemy_spawn_groups.marshal_squad = {
			spawn_cooldown = 20, -- 60
			max_nr_simultaneous_groups = 3, -- 2
			initial_spawn_delay = 30, -- 90
			amount = {
				1, -- 2
				3 -- 2
			},
			spawn = {
				{
					respawn_cooldown = 20, -- 30
					amount_min = 2, -- 1
					rank = 2,
					freq = 1,
					unit = "marshal_shield",
					tactics = self._tactics.marshal_shield
				},
				{
					respawn_cooldown = 20, -- 30
					amount_min = 2, -- 1
					rank = 1,
					freq = 1,
					unit = "marshal_marksman",
					tactics = self._tactics.marshal_marksman
				}
			},
			spawn_point_chk_ref = table.list_to_set({
				"tac_shield_wall",
				"tac_shield_wall_ranged",
				"tac_shield_wall_charge"
			})
		}
	elseif Global.level_data and Global.level_data.level_id == "ranc" or Global.game_settings and Global.game_settings.level_id == "ranc" then
		self.enemy_spawn_groups.marshal_squad = {
			spawn_cooldown = 20, -- 60
			max_nr_simultaneous_groups = 2, -- 1
			initial_spawn_delay = 30, -- 90
			amount = {
				1, -- 2
				3 -- 2
			},
			spawn = {
				{
					respawn_cooldown = 20, -- 30
					amount_min = 2,
					rank = 1,
					freq = 1,
					unit = "marshal_marksman",
					tactics = self._tactics.marshal_marksman
				}
			},
			spawn_point_chk_ref = table.list_to_set({
				"tac_swat_rifle_flank",
				"tac_swat_rifle"
			})
		}
	else
		self.enemy_spawn_groups.marshal_squad = {
			spawn_cooldown = 20, -- 60
			max_nr_simultaneous_groups = 2, -- 1
			initial_spawn_delay = 90, -- 480
			amount = {
				1, -- 2
				2 -- 2
			},
			spawn = {
				{
					respawn_cooldown = 20, -- 30
					amount_min = 3, -- 2
					rank = 1,
					freq = 1,
					unit = "marshal_marksman",
					tactics = self._tactics.marshal_marksman
				}
			},
			spawn_point_chk_ref = table.list_to_set({
				"tac_swat_rifle_flank",
				"tac_swat_rifle"
			})
		}
	end

	local squadmul = 1
	if DWP.settings.respawns then
		squadmul = 4 / DWP.settings.respawns
	else
		log("[DW+] Respawn value doesn't exists, using defaults.")
	end
	

	self.enemy_spawn_groups.CS_defend_a = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_cop_C45_R870",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.CS_cop,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.CS_defend_b = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_swat_MP5",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.CS_cop,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.CS_defend_c = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_heavy_M4",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.CS_cop,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.CS_swats = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_swat_MP5",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.CS_swat_rifle,
				rank = 2
			},
			{
				unit = "CS_swat_R870",
				freq = 0.5,
				amount_min = 1,
				amount_max = 2,
				tactics = self._tactics.CS_swat_shotgun,
				rank = 1
			},
			{
				unit = "CS_swat_MP5",
				freq = 0.33,
				amount_min = 2,
				amount_max = 2,
				tactics = self._tactics.CS_swat_rifle_flank,
				rank = 3
			},
			{
				unit = "medic_M4",
				freq = 0.15,
				amount_max = 1,
				tactics = self._tactics.CS_swat_rifle_flank,
				rank = 3
			}
		}
	}
	self.enemy_spawn_groups.CS_heavys = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_heavy_M4",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.CS_swat_rifle,
				rank = 2
			},
			{
				unit = "CS_heavy_R870",
				freq = 0.75,
				amount_min = 1,
				amount_max = 3,
				tactics = self._tactics.CS_swat_rifle_flank,
				rank = 3
			},
			{
				unit = "medic_R870",
				freq = 0.2,
				amount_max = 1,
				tactics = self._tactics.CS_swat_shotgun,
				rank = 3
			}
		}
	}
	self.enemy_spawn_groups.CS_shields = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_shield",
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				tactics = self._tactics.CS_shield,
				rank = 3
			},
			{
				unit = "CS_cop_stealth_MP5",
				freq = 0.75,
				amount_min = 1,
				amount_max = 2,
				tactics = self._tactics.CS_cop_stealth,
				rank = 1
			},
			{
				unit = "CS_heavy_M4_w",
				freq = 0.75,
				amount_min = 1,
				amount_max = 2,
				tactics = self._tactics.CS_swat_heavy,
				rank = 2
			}
		}
	}

		self.enemy_spawn_groups.CS_tazers = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "CS_tazer",
					freq = 1,
					amount_min = 1,
					amount_max = 2,
					tactics_ = self._tactics.CS_tazer,
					rank = 1
				},
				{
					unit = "FBI_shield",
					freq = 0.9,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.FBI_shield,
					rank = 3
				},
				{
					unit = "FBI_heavy_G36",
					freq = 1,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				}
			}
		}
	self.enemy_spawn_groups.FBI_defend_b = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_suit_M4_MP5",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit,
				rank = 2
			},
			{
				unit = "FBI_swat_M4",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.FBI_defend_c = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_swat_M4",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.FBI_defend_d = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_heavy_G36",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit,
				rank = 1
			}
		}
	}

		self.enemy_spawn_groups.FBI_stealth_a = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_suit_stealth_MP5",
					freq = 1,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 2
				},
				{
					unit = "CS_tazer",
					freq = 1,
					amount_max = 1,
					tactics = self._tactics.CS_tazer,
					rank = 1
				}
			}
		}


		self.enemy_spawn_groups.FBI_stealth_b = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_suit_stealth_MP5",
					freq = 1,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 1
				},
				{
					unit = "FBI_suit_M4_MP5",
					freq = 0.75,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 2
				}
			}
		}


		self.enemy_spawn_groups.FBI_stealth_c = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_suit_stealth_MP5",
					freq = 1,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 1
				},
				{
					unit = "FBI_suit_M4_MP5",
					freq = 0.75,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 2
				},
				{
					unit = "FBI_suit_C45_M4",
					freq = 0.75,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 3
				}
			}
		}


		self.enemy_spawn_groups.FBI_swats = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_swat_M4",
					freq = 1,
					amount_min = 4,
					amount_max = 5,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_suit_M4_MP5",
					freq = 1,
					amount_max = 1,
					tactics = self._tactics.FBI_swat_rifle_flank,
					rank = 2
				},
				{
					unit = "FBI_swat_R870",
					amount_min = 1,
					amount_max = 3,
					freq = 1,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 3
				},
				{
					unit = "spooc",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.spooc,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 3
				}
			}
		}


		self.enemy_spawn_groups.FBI_heavys = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 1,
					amount_min = 2,
					amount_max = 4,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_swat_M4",
					freq = 1,
					amount_min = 3,
					amount_max = 4,
					tactics = self._tactics.FBI_heavy_flank,
					rank = 2
				}
			}
		}


		self.enemy_spawn_groups.FBI_shields = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_shield",
					freq = 1,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.FBI_shield,
					rank = 3
				},
				{
					unit = "FBI_suit_stealth_MP5",
					freq = 1,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 1
				},
				{
					unit = "spooc",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.spooc,
					rank = 1
				},
				{
					unit = "CS_tazer",
					freq = 0.75,
					amount_max = 1,
					tactics = self._tactics.CS_swat_heavy,
					rank = 2
				}
			}
		}


		self.enemy_spawn_groups.FBI_tanks = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.FBI_tank,
					rank = 3
				},
				{
					unit = "CS_tazer",
					freq = 0.5,
					amount_max = 1,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 2
				},
				{
					unit = "medic_R870",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 3
				}
			}
		}
		
		self.enemy_spawn_groups.Undead = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "UnDeadHostageAvengers",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.FBI_tank,
					rank = 3
				}
			}
		}

	self.enemy_spawn_groups.single_spooc = {
		amount = {2 * squadmul, 2 * squadmul},
		spawn = {
			{
				unit = "spooc",
				freq = 1,
				amount_max = 1,
				tactics = self._tactics.spooc,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.FBI_spoocs = self.enemy_spawn_groups.single_spooc

	-- Winters
	self.enemy_spawn_groups.Phalanx = {
		amount = {
			self.phalanx.minions.amount + 1,
			self.phalanx.minions.amount + 1
		},
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 2,
				unit = "Phalanx_vip",
				tactics = self._tactics.Phalanx_vip
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "Phalanx_minion",
				tactics = self._tactics.Phalanx_minion
			}
		}
	}
	
	-- snowman, prob will be removed later, ovkl kept him for now
	self.enemy_spawn_groups.snowman_boss = {
		amount = {
			1,
			1
		},
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "snowman_boss",
				tactics = self._tactics.tank_rush
			}
		},
		spawn_point_chk_ref = table.list_to_set({
			"tac_bull_rush"
		})
	}
	
end
end)


-- TASK DATA
-- Defines which group actually spawns when. It also defines assault delays etc.
Hooks:PostHook(GroupAITweakData, "_init_task_data", "DWP_taskdata_override", function(self, difficulty_index, difficulty)
	if difficulty_index == 7 then
	
	self:init_taskdata_deathwish(difficulty_index) -- it would be fun to rebalance other difficulties as well but thats for another mod
	
	self.besiege.assault.sustain_duration_min = {
		math.floor(DWP.settings.assduration),
		math.floor(DWP.settings.assduration),
		math.floor(DWP.settings.assduration)
	}
	self.besiege.assault.sustain_duration_max = {
		math.floor(DWP.settings.assduration),
		math.floor(DWP.settings.assduration),
		math.floor(DWP.settings.assduration)
	}
	self.besiege.assault.sustain_duration_balance_mul = {
		1,
		1,
		1,
		1
	}

	-- Make the assault breaks substantially longer if players have hostages
	if DWP.settings.hostagesbeta == true then
		self.besiege.assault.hostage_hesitation_delay = {
			60,
			60,
			60
		}
	else
		self.besiege.assault.hostage_hesitation_delay = {
			25,
			25,
			25
		}
	end

	-- Base assault values, how many cops are allowed on the map at once, and how big is the spawnpool
	
	-- Max cop amount per map
	self.besiege.assault.force = {
		16,
		18,
		20
	}
	-- Total max cop spawns per assault
	self.besiege.assault.force_pool = {
		200,
		200,
		200
	}

	-- Cloaker-specific spawns
	self.besiege.cloaker.groups = {
		single_spooc = {
			1,
			1,
			1
		}
	}

	-- Add winters
	self.besiege.assault.groups.Phalanx = {
		0,
		0,
		0
	}
	self.besiege.recon.groups.Phalanx = {
		0,
		0,
		0
	}
	-- Add marshals
	self.besiege.assault.groups.marshal_squad = {
		0,
		0,
		0
	}
	self.besiege.recon.groups.marshal_squad = {
		0,
		0,
		0
	}

	-- Wtf is this?
	self.street = deep_clone(self.besiege)
	self.safehouse = deep_clone(self.besiege)
	end
end)

function GroupAITweakData:init_taskdata_deathwish(difficulty_index)
	self.besiege.assault.groups = {
		FBI_swats = {
			0.45,
			0.45,
			0.45
		},
		FBI_heavys = {
			0.5,
			0.5,
			0.5
		},
		FBI_shields = {
			0.35,
			0.35,
			0.35
		},
		FBI_tanks = {
			0.31,
			0.31,
			0.31
		},
		CS_tazers = {
			0.4,
			0.4,
			0.4
		},
		FBI_spoocs = {
			0.1,
			0.2,
			0.2
		},
		single_spooc = {
			0.1,
			0.1,
			0.1
		}
	}

	self.besiege.assault.groups.Undead = {
		0,
		0,
		0
	}

	-- snowman, prob will be removed later
	self.besiege.assault.groups.snowman_boss = {
		0,
		0,
		0
	}
	
	self.besiege.recon.groups.snowman_boss = {
		0,
		0,
		0
	}

	self.besiege.assault.groups.CS_swats = {
		0.18,
		0.18,
		0.18
	}
	self.besiege.assault.groups.CS_heavys = {
		0.22,
		0.22,
		0.22
	}
	self.besiege.assault.groups.CS_shields = {
		0.35,
		0.35,
		0.35
	}

	self.besiege.reenforce.groups = {
		FBI_defend_b = {
			1,
			1,
			1
		},
		FBI_defend_c = {
			1,
			1,
			1
		},
		FBI_defend_d = {
			1,
			1,
			1
		}
	}

	self.besiege.reenforce.groups.CS_defend_a = {
		0.2,
		0.2,
		0.2
	}
	self.besiege.reenforce.groups.CS_defend_b = {
		0.2,
		0.2,
		0.2
	}
	self.besiege.reenforce.groups.CS_defend_c = {
		0.2,
		0.2,
		0.2
	}

	self.besiege.recon.groups.FBI_stealth_a = {
		1,
		1,
		1
	}
	self.besiege.recon.groups.FBI_stealth_b = {
		0.5,
		0.5,
		0.5
	}
	self.besiege.recon.groups.FBI_stealth_c = {
		0.4,
		0.4,
		0.4
	}
	self.besiege.recon.groups.single_spooc = {
		0,
		0,
		0
	}
	

	self.besiege.assault.delay = {
		25,
		25,
		25
	}

	-- Multipliers for assault pools
	self.besiege.assault.force_balance_mul = {
		2.8,
		2.8,
		2.8,
		2.8
	}
	self.besiege.assault.force_pool_balance_mul = {
		math.floor(DWP.settings.assforce_pool) / 200,
		math.floor(DWP.settings.assforce_pool) / 200,
		math.floor(DWP.settings.assforce_pool) / 200,
		math.floor(DWP.settings.assforce_pool) / 200
	}
end