if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

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

-- units themselves
Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "DWPtweak_initunitcategories", function(self, difficulty_index)
	if difficulty_index == 7 then
		DWP.DWdifficultycheck = true
		DWP.setnewdoms()
		-- snapshot of our settings that are used for the current game
		if not DWP.settings_config then
			DWP.settings_config = clone(DWP.settings)
		end
		
		-- empty squads that we dont use. i dont think it matters for memory effiency, but this should help figure out if we still have these squads somewhere in the code for no reason
		self.unit_categories.CS_cop_C45_R870 = nil
		self.unit_categories.FBI_suit_M4_MP5 = nil
		self.unit_categories.FBI_swat_M4 = nil
		self.unit_categories.FBI_suit_stealth_MP5 = nil
		self.unit_categories.FBI_heavy_G36 = nil
		self.unit_categories.FBI_swat_R870 = nil
		self.unit_categories.FBI_suit_C45_M4 = nil
		self.unit_categories.FBI_heavy_G36_w = nil
		
		-- reworking quite a few squads. CS squads are the only ones unchanged now.
		
		-- new CS_cop_C45_R870
		self.unit_categories.cops_CQB = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
					Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
					Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
					Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"),
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"),
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"),
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
					Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02")
				}
			},
			access = access_type_walk_only
		}

		-- combined FBI_suit_C45_M4 and FBI_suit_M4_MP5
		self.unit_categories.FBI_suits = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"),
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"),
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"),
					Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02"),
					Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_03/ene_bex_security_suit_03")
				}
			},
			access = access_type_all
		}

		-- FBI greens m4
		self.unit_categories.FBI_swat_LR = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi")
				}
			},
			access = access_type_all
		}
		
		-- light greys g36
		self.unit_categories.FBI_city_swat_LR = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass/ene_akan_fbi_swat_dw_ak47_ass")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale")
				}
			},
			access = access_type_all
		}
		
		-- Grey CQB swat ump/benelli || smg's for others. sadly federales only have m4's
		self.unit_categories.FBI_city_CQB = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale")
				}
			},
			access = access_type_all
		}
		
		-- Both grey and green light shotgunners
		self.unit_categories.FBI_swat_870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870/ene_akan_fbi_swat_dw_r870")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870")
				}
			},
			access = access_type_all
		}
		
		-- heavy m4/g36
		self.unit_categories.FBI_heavy_LR = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
					Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36")
				}
			},
			access = access_type_all
		}

		-- heavy shotgunners
		self.unit_categories.FBI_heavy_R870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"),
					Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870")
				}
			},
			access = access_type_all
		}

		-- green + grey shields
		self.unit_categories.FBI_shield = {
			special_type = "shield",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1"),
					Idstring("units/payday2/characters/ene_city_shield/ene_city_shield")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9")
				}
			},
			access = access_type_walk_only
		}
		
		-- snipers
		self.unit_categories.FBI_sniper = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1"),
					Idstring("units/payday2/characters/ene_sniper_2/ene_sniper_2")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_sniper_svd_snp/ene_akan_cs_swat_sniper_svd_snp")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_sniper/ene_murkywater_sniper")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_sniper/ene_swat_policia_sniper")
				}
			},
			access = access_type_all
		}
		
		-- why the fuck would white house use normal US snipers instead of murkywater ones is somewhat understandable, but why would they remove the murky snipers
		-- from the map's load package is beyond me. it's only 1 unit in the memory, it wont help the awfull performance this map has
		-- either way, this fixes crashes with 'death squads' for the map
		if Global and Global.level_data and Global.level_data.level_id == "vit" then
			self.unit_categories.FBI_sniper.unit_types.murkywater = {
				Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1"),
				Idstring("units/payday2/characters/ene_sniper_2/ene_sniper_2")
			}
		end
		
		-- winter's shield but without winter's properties
		self.unit_categories.FBI_reinf_shield = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				},
				russia = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				},
				zombie = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				},
				federales = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				}
			},
			access = access_type_all
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
		
		if DWP.settings.marshal_uniform == 1 then
		
			self.unit_categories.marshal_marksman.unit_types.america = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_2/ene_male_marshal_marksman_2")
			}
			self.unit_categories.marshal_shield.unit_types.america = {
				Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_shield_2/ene_male_marshal_shield_2")
			}
			
		elseif DWP.settings.marshal_uniform == 2 then
		
			self.unit_categories.marshal_marksman.unit_types.america = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_1/ene_male_marshal_marksman_1"),
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_2/ene_male_marshal_marksman_2")
			}
			self.unit_categories.marshal_shield.unit_types.america = {
				Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_shield_1/ene_male_marshal_shield_1"),
				Idstring("units/pd2_dlc_usm2/characters/ene_male_marshal_shield_2/ene_male_marshal_shield_2")
			}
			
		else
			-- dont change them
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
		
		if DWP.settings.difficulty == 1 then
			self.special_unit_spawn_limits = {
				shield = 6,
				medic = 5,
				taser = 6,
				tank = 4,
				spooc = 3
			}
		elseif DWP.settings.difficulty == 2 then
			self.special_unit_spawn_limits = {
				shield = 6,
				medic = 5,
				taser = 6,
				tank = 5,
				spooc = 3
			}
		elseif DWP.settings.difficulty == 3 then
			self.special_unit_spawn_limits = {
				shield = 7,
				medic = 5,
				taser = 7,
				tank = 6,
				spooc = 4
			}
		elseif DWP.settings.difficulty == 4 then
			self.special_unit_spawn_limits = {
				shield = 8,
				medic = 6,
				taser = 8,
				tank = 7,
				spooc = 5
			}
		else
			log("DWP difficulty setting not found, special limits not adjusted properly.")
		end
	
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

	local squadmul = 1
	if DWP.settings.difficulty then
		if DWP.settings.difficulty == 3 then
			squadmul = 2
		elseif DWP.settings.difficulty == 4 then
			squadmul = 3
		end
	else
		log("[DW+] Respawn value doesn't exist, using defaults.")
	end
	
	-- lol
	self.enemy_spawn_groups.piggydozer = {
		amount = {
			1,
			1
		},
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "piggydozer",
				tactics = self._tactics.tank_rush
			}
		},
		spawn_point_chk_ref = table.list_to_set({
			"tac_bull_rush"
		})
	}
	
	self.enemy_spawn_groups.CS_defend_a = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "cops_CQB",
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
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			}
		}
	}
	
	self.enemy_spawn_groups.CS_shields = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_shield",
				freq = 1,
				amount_min = 2,
				amount_max = 2,
				tactics = self._tactics.CS_shield,
				rank = 3
			},
			{
				unit = "CS_swat_MP5",
				freq = 1,
				amount_min = 2,
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
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				tactics = self._tactics.FBI_shield,
				rank = 3
			},
			{
				unit = "FBI_heavy_LR",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			}
		}
	}
	if DWP.settings.difficulty <= 2 then
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
					freq = 0.75,
					amount_max = 1,
					tactics = self._tactics.CS_swat_shotgun,
					rank = 1
				},
				{
					unit = "CS_swat_MP5",
					freq = 0.5,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.CS_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.2,
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
					freq = 1,
					amount_max = 1,
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
	else
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
					freq = 1,
					amount_max = 1,
					amount_max = 2,
					tactics = self._tactics.CS_swat_shotgun,
					rank = 1
				},
				{
					unit = "CS_swat_MP5",
					freq = 0.5,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.CS_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.2,
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
					freq = 1,
					amount_max = 2,
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
	end
	
	
	if DWP.settings.difficulty <= 2 then
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
	else
		self.enemy_spawn_groups.FBI_tanks = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_tank,
					rank = 3
				},
				{
					unit = "CS_tazer",
					freq = 0.5,
					amount_max = 2,
					tactics = self._tactics.CS_tazer,
					rank = 2
				},
				{
					unit = "medic_R870",
					freq = 0.5,
					amount_max = 1,
					amount_max = 3,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 3
				}
			}
		}
	end
	
	self.enemy_spawn_groups.FBI_defend_a = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_suits",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit,
				rank = 2
			},
			{
				unit = "FBI_swat_LR",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.FBI_defend_b = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_suits",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit,
				rank = 2
			},
			{
				unit = "FBI_heavy_LR",
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
				unit = "FBI_suits",
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
				unit = "FBI_suits",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 1
			},
			{
				unit = "FBI_swat_LR",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.FBI_stealth_c = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_suits",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 1
			},
			{
				unit = "FBI_heavy_LR",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 1
			}
		}
	}
	if DWP.settings.difficulty <= 2 then
		self.enemy_spawn_groups.FBI_city_swats = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_city_swat_LR",
					freq = 1,
					amount_min = 4,
					amount_max = 5,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				-- techically not a 'city' (grays) type, but kinda needed for variety
				{
					unit = "FBI_swat_LR",
					freq = 1,
					amount_min = 4,
					amount_max = 5,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_city_CQB",
					freq = 0.8,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.25,
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
					unit = "FBI_heavy_LR",
					freq = 1,
					amount_min = 4,
					amount_max = 5,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.5,
					amount_max = 1,
					tactics = self._tactics.FBI_heavy_flank,
					rank = 2
				}
			}
		}
		self.enemy_spawn_groups.FBI_CQB_swats = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_swat_LR",
					freq = 1,
					amount_min = 3,
					amount_max = 3,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_city_CQB",
					freq = 1,
					amount_min = 3,
					amount_max = 4,
					tactics = self._tactics.FBI_heavy_flank,
					rank = 2
				},
				{
					unit = "FBI_swat_870",
					freq = 0.5,
					amount_max = 1,
					amount_max = 2,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 3
				}
			}
		}
	else
		self.enemy_spawn_groups.FBI_city_swats = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_city_swat_LR",
					freq = 1,
					amount_min = 4,
					amount_max = 5,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				-- techically not a 'city' (grays) type, but kinda needed for variety
				{
					unit = "FBI_swat_LR",
					freq = 1,
					amount_min = 4,
					amount_max = 5,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_city_CQB",
					freq = 1,
					amount_min = 3,
					amount_max = 4,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.5,
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
					unit = "FBI_heavy_LR",
					freq = 1,
					amount_min = 3,
					amount_max = 4,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_heavy_R870",
					freq = 1,
					amount_max = 1,
					amount_max = 2,
					tactics = self._tactics.FBI_heavy_flank,
					rank = 2
				}
			}
		}
		self.enemy_spawn_groups.FBI_CQB_swats = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_swat_LR",
					freq = 1,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_city_CQB",
					freq = 1,
					amount_min = 4,
					amount_max = 5,
					tactics = self._tactics.FBI_heavy_flank,
					rank = 2
				},
				{
					unit = "FBI_swat_870",
					freq = 1,
					amount_max = 1,
					amount_max = 2,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 3
				}
			}
		}
	end

	self.enemy_spawn_groups.FBI_shields = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_shield",
				freq = 1,
				amount_min = 2,
				amount_max = 2,
				tactics = self._tactics.FBI_shield,
				rank = 1
			},
			{
				unit = "FBI_swat_LR",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 2
			},
			{
				unit = "FBI_city_swat_LR",
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 2
			},
			{
				unit = "CS_tazer",
				freq = 0.5,
				amount_max = 1,
				tactics = self._tactics.CS_swat_heavy,
				rank = 2
			}
		}
	}
	
	-- snipers + winters shields aka Death Squad
	-- slaughterhouse forces all sniper units to never move/only make a single move after they spawn it seems
	-- or maybe just disalowws to move to/through certain pathways, which makes DSquad snipers get stuck
	if Global.level_data.level_id == "dinner" then
		self.enemy_spawn_groups.Death_squad = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_reinf_shield",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.FBI_shield,
					rank = 1
				}
			}
		}
	else
		self.enemy_spawn_groups.Death_squad = {
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_reinf_shield",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.FBI_shield,
					rank = 1
				},
				{
					unit = "FBI_sniper",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 2
				}
			}
		}
	end

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
	
	if DWP.settings.difficulty == 1 then
		self:init_taskdata_deathwish_1()
	elseif DWP.settings.difficulty == 2 then
		self:init_taskdata_deathwish_2()
	elseif DWP.settings.difficulty == 3 then
		self:init_taskdata_deathwish_3()
	elseif DWP.settings.difficulty == 4 then
		self:init_taskdata_deathwish_4()
	else
		log("DWP difficulty setting not found, unit spawn rates were not set correctly.")
	end
	
	
	self.besiege.assault.sustain_duration_min = {
		45,
		math.floor(DWP.settings.assduration),
		math.floor(DWP.settings.assduration)
	}
	self.besiege.assault.sustain_duration_max = {
		45,
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
			1,
			60,
			60
		}
	else
		self.besiege.assault.hostage_hesitation_delay = {
			1,
			15,
			15
		}
	end

	-- Base assault values, how many cops are allowed on the map at once, and how big is the spawnpool
	
	-- Max cop amount per map
	self.besiege.assault.force = {
		20,
		20,
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
	
	self.besiege.recon.groups.single_spooc = {
		0,
		0,
		0
	}
	
	self.besiege.assault.groups.Undead = {
		0,
		0,
		0
	}

	-- snowman, prob will be removed later. or not evidently
	self.besiege.assault.groups.snowman_boss = {
		0,
		0,
		0
	}
	
	-- we have this fella here as well now
	self.besiege.assault.groups.piggydozer = {
		0,
		0,
		0
	}
	
	-- twice
	self.besiege.recon.groups.piggydozer = {
		0,
		0,
		0
	}
	
	self.besiege.recon.groups.snowman_boss = {
		0,
		0,
		0
	}
	
	self.besiege.assault.delay = {
		4,
		35,
		35
	}

	-- Multiplier for assault pool
	self.besiege.assault.force_pool_balance_mul = {
		math.floor(DWP.settings.assforce_pool) / 200,
		math.floor(DWP.settings.assforce_pool) / 200,
		math.floor(DWP.settings.assforce_pool) / 200,
		math.floor(DWP.settings.assforce_pool) / 200
	}

	-- Wtf is this?
	self.street = deep_clone(self.besiege)
	self.safehouse = deep_clone(self.besiege)
	
	-- down bellow are a bunch of map specific cop pool changes, because some maps have fucked up respawn points/enemy damage/scripted spawns
	if Global and Global.level_data then
	
		-- BAIN
		-- tarantino
		if Global.level_data.level_id == "rvd1" or Global.level_data.level_id == "rvd2" then
			self.besiege.assault.force = {
				16,
				16,
				16
			}
		end
		
		-- alesso-хуессо
		if Global.level_data.level_id == "arena" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- transport
		-- crossroads
		if Global.level_data.level_id == "arm_cro" then
			self.besiege.assault.force = {
				16.5,
				16.5,
				16.5
			}
		end
		
		-- downtown
		if Global.level_data.level_id == "arm_hcm" then
			self.besiege.assault.force = {
				17.2,
				17.2,
				17.2
			}
		end
		
		-- harbor
		if Global.level_data.level_id == "arm_fac" then
			self.besiege.assault.force = {
				18,
				18,
				18
			}
		end
		
		-- train
		if Global.level_data.level_id == "arm_for" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- underpass
		if Global.level_data.level_id == "arm_und" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- CLASSICS
		-- FWB is good. in theory
		if Global.level_data.level_id == "red2" then
			self.besiege.assault.force = {
				17.5,
				17.5,
				17.5
			}
		end
		
		-- blue bridge
		if Global.level_data.level_id == "glace" then
			self.besiege.assault.force = {
				18,
				18,
				18
			}
		end
		
		-- dodge street
		if Global.level_data.level_id == "run" then
			self.besiege.assault.force = {
				18,
				18,
				18
			}
		end
		
		-- slaughterbuilding
		if Global.level_data.level_id == "dinner" then
			self.besiege.assault.force = {
				17.5,
				17.5,
				17.5
			}
		end
		
		-- overcover
		if Global.level_data.level_id == "man" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- mercy r34
		if Global.level_data.level_id == "nmh" then
			self.besiege.assault.force = {
				14.4,
				14.4,
				14.4
			}
		end
		
		-- EVENTS
		-- lab rats. ah yes, lets make a map that has no cover, horrible pathing, with zip lines as your main way to move around - those things that make you as vulnerable as level 60 player with ictv rogue on DS. oh and lets place headless dozers there. oh and yeah, lets keep the cops vanilla american faction instead of the zombies one. sooooo cooooooool
		if Global.level_data.level_id == "nail" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- JIMMY
		-- boiling wawtuh with stupid ak's
		if Global.level_data.level_id == "mad" then
			self.besiege.assault.force = {
				12,
				12,
				12
			}
		end
		
		-- JIU FENG
		-- vlad breakout
		if Global.level_data.level_id == "sand" then
			self.besiege.assault.force = {
				18,
				18,
				18
			}
		end
		
		-- LOCKE
		-- polar bear's home
		if Global.level_data.level_id == "wwh" then
			self.besiege.assault.force = {
				16.5,
				16.5,
				16.5
			}
		end
		
		-- beneath the everest
		if Global.level_data.level_id == "pbr" then
			self.besiege.assault.force = {
				15.5,
				15.5,
				15.5
			}
		end
		
		-- "WE NEED TO BUILD A WALL!" - most popular child molester of 2017
		if Global.level_data.level_id == "mex" then
			self.besiege.assault.force = {
				14.4,
				14.4,
				14.4
			}
		end
		
		-- this is the worst map design in this game after goat sim, and i am forced to tweak it. great.
		-- personal note: lab's location at the smaller warehouse is much better, if you get the big one, you should just restart. applies to vanilla as well tbh
		if Global.level_data.level_id == "mex_cooking" then
			self.besiege.assault.force = {
				15.6,
				15.6,
				15.6
			}
		end
		
		-- brooklyn the bank
		if Global.level_data.level_id == "brb" then
			self.besiege.assault.force = {
				17.5,
				17.5,
				17.5
			}
		end
		
		-- henry's cock
		if Global.level_data.level_id == "des" then
			self.besiege.assault.force = {
				15.2,
				15.2,
				15.2
			}
		end	
		
		-- black tablet
		if Global.level_data.level_id == "sah" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- the end
		if Global.level_data.level_id == "vit" then
			self.besiege.assault.force = {
				16.8,
				16.8,
				16.8
			}
		end
		
		-- BUTCHER
		-- Sosa сосёт ХААХААААААААААААААААААААА я смешной
		if Global.level_data.level_id == "friend" then
			self.besiege.assault.force = {
				18,
				18,
				18
			}
		end	
		
		-- CONTINENTAL
		-- 10-10
		if Global.level_data.level_id == "spa" then
			self.besiege.assault.force = {
				18,
				18,
				18
			}
		end
		
		-- DENTIST
		-- OG casino
		if Global.level_data.level_id == "kenaz" then
			self.besiege.assault.force = {
				13.6,
				13.6,
				13.6
			}
		end
		
		-- hot line
		if Global.level_data.level_id == "mia_1" or Global.level_data.level_id == "mia_2" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- hox_1, duh
		if Global.level_data.level_id == "hox_1" then
			self.besiege.assault.force = {
				18,
				18,
				18
			}
		end
		
		-- ELEPHANT
		-- wtf is this id lmao
		if Global.level_data.level_id == "welcome_to_the_jungle_2" then
			self.besiege.assault.force = {
				15,
				15,
				15
			}
		end
		
		if Global.level_data.level_id == "election_day_1" or Global.level_data.level_id == "election_day_2" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- VLAD
		-- SAFES BABY
		if Global.level_data.level_id == "jolly" then
			self.besiege.assault.force = {
				17.5,
				17.5,
				17.5
			}
		end
		
		-- buluc's clusterfuck of objectives
		if Global.level_data.level_id == "fex" then
			self.besiege.assault.force = {
				17,
				17,
				17
			}
		end
		
		-- goat sim day 2. day 1 is also really bad, but mostly because of snipers, not the other squads, so its ok.
		if Global.level_data.level_id == "peta2" then
			self.besiege.assault.force = {
				15,
				15,
				15
			}
		end
		
		-- at least i dont have to shave pubes anymore
		if Global.level_data.level_id == "shoutout_raid" then
			self.besiege.assault.force = {
				16,
				16,
				16
			}
		end
		
		-- san martin
		if Global.level_data.level_id == "bex" then
			self.besiege.assault.force = {
				18,
				18,
				18
			}
		end
		
		-- santa's workshop. holy shit is this bad
		if Global.level_data.level_id == "cane" then
			self.besiege.assault.force = {
				13.5,
				13.5,
				13.5
			}
		end
		
		-- ESCAPES
		-- AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		if Global.level_data.level_id == "escape_cafe" then
			self.besiege.assault.force = {
				16,
				16,
				16
			}
		end		
		
	end

	end
end)

function GroupAITweakData:_init_enemy_spawn_groups_level(tweak_data, difficulty_index)
	local lvl_tweak_data = tweak_data.levels[Global.game_settings and Global.game_settings.level_id or Global.level_data and Global.level_data.level_id]

	if Global.level_data and Global.level_data.level_id == "deep" then
		-- ignore unit type overrides specifically for crude awakening, since only change here is to the marshal's uniform colour, which we change in DW+'s settings ourselves
		-- rest of the function is base game code, let's hope it wont break with new updates :)
	elseif lvl_tweak_data and lvl_tweak_data.ai_unit_group_overrides then
		local unit_types = nil

		for unit_type, faction_type_data in pairs(lvl_tweak_data.ai_unit_group_overrides) do
			unit_types = self.unit_categories[unit_type] and self.unit_categories[unit_type].unit_types

			if unit_types then
				for faction_type, override in pairs(faction_type_data) do
					if unit_types[faction_type] then
						unit_types[faction_type] = override
					end
				end
			end
		end
	end

	-- commented out values are base game values, for reference. rip tweaking shield amounts for the train heist, but tbh, after flashlight range buff they are ridiculously annoying
	if lvl_tweak_data and not lvl_tweak_data.ai_marshal_spawns_disabled then
		if lvl_tweak_data.ai_marshal_spawns_fast then
			self.enemy_spawn_groups.marshal_squad = {
				spawn_cooldown = 15, -- 60
				max_nr_simultaneous_groups = 2,
				initial_spawn_delay = 30, -- 90
				amount = {
					2,
					3 -- 2
				},
				spawn = {
					{
						respawn_cooldown = 15, -- 30
						amount_min = 1,
						amount_max = 2, -- nil
						rank = 2,
						freq = 1,
						unit = "marshal_shield",
						tactics = self._tactics.marshal_shield
					},
					{
						respawn_cooldown = 15, -- 30
						amount_min = 2, -- 1
						amount_max = 2, -- nil
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
		else
			self.enemy_spawn_groups.marshal_squad = {
				spawn_cooldown = 20, -- 60
				max_nr_simultaneous_groups = 2,
				initial_spawn_delay = 120, -- 480
				amount = {
					2,
					2
				},
				spawn = {
					{
						respawn_cooldown = 20, -- 30
						amount_min = 1,
						amount_max = 1, -- nil
						rank = 2,
						freq = 0.8, -- 1
						unit = "marshal_shield",
						tactics = self._tactics.marshal_shield
					},
					{
						respawn_cooldown = 20, -- 30
						amount_min = 1,
						amount_max = 2, -- nil
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
		end
	end
end

function GroupAITweakData:init_taskdata_deathwish_1()
	--50
	self.besiege.assault.force_balance_mul = {
		2.5,
		2.5,
		2.5,
		2.5
	}
	
	self.besiege.assault.groups = {
		FBI_city_swats = {
			0,
			0.3,
			0.3
		},
		FBI_heavys = {
			0,
			0.28,
			0.28
		},
		FBI_CQB_swats = {
			0,
			0.23,
			0.23
		},
		FBI_shields = {
			0,
			0.15,
			0.3
		},
		FBI_tanks = {
			0,
			0.15,
			0.3
		},
		CS_tazers = {
			0.15,
			0.18,
			0.35
		},
		CS_swats = {
			0.4,
			0.2,
			0.2
		},
		CS_heavys = {
			0.18,
			0.18,
			0.18
		},
		CS_shields = {
			0.18,
			0.09,
			0.18
		},
		Death_squad = {
			0,
			0.045,
			0.09
		},
		FBI_spoocs = {
			0,
			0.1,
			0.2
		},
		single_spooc = {
			0,
			0.05,
			0.1
		}
	}

	self.besiege.reenforce.groups = {
		FBI_defend_a = {
			0.6,
			0.6,
			0.6
		},
		FBI_defend_b = {
			0.6,
			0.6,
			0.6
		},
		CS_defend_a = {
			0.2,
			0.2,
			0.2
		},
		CS_defend_b = {
			0.2,
			0.2,
			0.2
		},
		CS_defend_c = {
			0.2,
			0.2,
			0.2
		}
	}

	self.besiege.recon.groups.FBI_stealth_a = {
		0.3,
		0.3,
		0.3
	}
	self.besiege.recon.groups.FBI_stealth_b = {
		0.4,
		0.4,
		0.4
	}
	self.besiege.recon.groups.FBI_stealth_c = {
		0.4,
		0.4,
		0.4
	}
end

function GroupAITweakData:init_taskdata_deathwish_2()
	--66
	self.besiege.assault.force_balance_mul = {
		3.3,
		3.3,
		3.3,
		3.3
	}
	
	self.besiege.assault.groups = {
		FBI_city_swats = {
			0,
			0.28,
			0.28
		},
		FBI_heavys = {
			0,
			0.28,
			0.28
		},
		FBI_CQB_swats = {
			0,
			0.25,
			0.25
		},
		FBI_shields = {
			0,
			0.14,
			0.28
		},
		FBI_tanks = {
			0,
			0.17,
			0.34
		},
		CS_tazers = {
			0,
			0.17,
			0.34
		},
		CS_swats = {
			0.4,
			0.2,
			0.2
		},
		CS_heavys = {
			0.18,
			0.18,
			0.18
		},
		CS_shields = {
			0.16,
			0.08,
			0.16
		},
		Death_squad = {
			0,
			0.06,
			0.12
		},
		FBI_spoocs = {
			0,
			0.1,
			0.2
		},
		single_spooc = {
			0,
			0.05,
			0.1
		}
	}

	self.besiege.reenforce.groups = {
		FBI_defend_a = {
			0.6,
			0.6,
			0.6
		},
		FBI_defend_b = {
			0.6,
			0.6,
			0.6
		},
		CS_defend_a = {
			0.2,
			0.2,
			0.2
		},
		CS_defend_b = {
			0.2,
			0.2,
			0.2
		},
		CS_defend_c = {
			0.2,
			0.2,
			0.2
		}
	}

	self.besiege.recon.groups.FBI_stealth_a = {
		0.3,
		0.3,
		0.3
	}
	self.besiege.recon.groups.FBI_stealth_b = {
		0.4,
		0.4,
		0.4
	}
	self.besiege.recon.groups.FBI_stealth_c = {
		0.4,
		0.4,
		0.4
	}
end

function GroupAITweakData:init_taskdata_deathwish_3()
	--80
	self.besiege.assault.force_balance_mul = {
		4,
		4,
		4,
		4
	}
	
	self.besiege.assault.groups = {
		FBI_city_swats = {
			0.2,
			0.2,
			0.2
		},
		FBI_heavys = {
			0,
			0.35,
			0.35
		},
		FBI_CQB_swats = {
			0,
			0.3,
			0.3
		},
		FBI_shields = {
			0,
			0.12,
			0.23
		},
		FBI_tanks = {
			0,
			0.15,
			0.3
		},
		CS_tazers = {
			0.15,
			0.17,
			0.34
		},
		CS_swats = {
			0.4,
			0.2,
			0.2
		},
		CS_heavys = {
			0.18,
			0.18,
			0.18
		},
		CS_shields = {
			0.13,
			0.07,
			0.13
		},
		Death_squad = {
			0,
			0.08,
			0.16
		},
		FBI_spoocs = {
			0,
			0.1,
			0.2
		},
		single_spooc = {
			0,
			0.05,
			0.1
		}
	}

	self.besiege.reenforce.groups = {
		FBI_defend_a = {
			0.6,
			0.6,
			0.6
		},
		FBI_defend_b = {
			0.6,
			0.6,
			0.6
		},
		CS_defend_a = {
			0.2,
			0.2,
			0.2
		},
		CS_defend_b = {
			0.2,
			0.2,
			0.2
		},
		CS_defend_c = {
			0.2,
			0.2,
			0.2
		}
	}

	self.besiege.recon.groups.FBI_stealth_a = {
		0.3,
		0.3,
		0.3
	}
	self.besiege.recon.groups.FBI_stealth_b = {
		0.4,
		0.4,
		0.4
	}
	self.besiege.recon.groups.FBI_stealth_c = {
		0.4,
		0.4,
		0.4
	}
end

function GroupAITweakData:init_taskdata_deathwish_4()
	--120
	self.besiege.assault.force_balance_mul = {
		6,
		6,
		6,
		6
	}
	
	self.besiege.assault.groups = {
		FBI_city_swats = {
			0,
			0.2,
			0.2
		},
		FBI_heavys = {
			0,
			0.35,
			0.35
		},
		FBI_CQB_swats = {
			0,
			0.3,
			0.3
		},
		FBI_shields = {
			0,
			0.1,
			0.2
		},
		FBI_tanks = {
			0,
			0.18,
			0.35
		},
		CS_tazers = {
			0.15,
			0.17,
			0.34
		},
		CS_swats = {
			0.4,
			0.2,
			0.2
		},
		CS_heavys = {
			0.18,
			0.18,
			0.18
		},
		CS_shields = {
			0.11,
			0.06,
			0.11
		},
		Death_squad = {
			0,
			0.1,
			0.2
		},
		FBI_spoocs = {
			0,
			0.1,
			0.2
		},
		single_spooc = {
			0,
			0.05,
			0.1
		}
	}

	self.besiege.reenforce.groups = {
		FBI_defend_a = {
			0.6,
			0.6,
			0.6
		},
		FBI_defend_b = {
			0.6,
			0.6,
			0.6
		},
		CS_defend_a = {
			0.2,
			0.2,
			0.2
		},
		CS_defend_b = {
			0.2,
			0.2,
			0.2
		},
		CS_defend_c = {
			0.2,
			0.2,
			0.2
		}
	}

	self.besiege.recon.groups.FBI_stealth_a = {
		0.3,
		0.3,
		0.3
	}
	self.besiege.recon.groups.FBI_stealth_b = {
		0.4,
		0.4,
		0.4
	}
	self.besiege.recon.groups.FBI_stealth_c = {
		0.4,
		0.4,
		0.4
	}
end