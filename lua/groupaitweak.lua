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
		-- snapshot of our settings that are used for the current game
		if not DWP.settings_config then
			DWP.settings_config = clone(DWP.settings)
		end
		
		-- reworking a bunch of squads
		
		-- new CS_cop_C45_R870
		self.unit_categories.beat_cops = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
					Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
					Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
					Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"),
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"),
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"),
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
					Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
					Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
					Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
					Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02")
				}
			},
			access = access_type_walk_only
		}

		-- normally unused HRT's
		self.unit_categories.HRT = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3"),
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_03/ene_bex_security_suit_03")
				}
			},
			access = access_type_all
		}
		
		-- previously FBI_suit_C45_M4/FBI_suit_M4_MP5, now recon units that spawn every now and then
		self.unit_categories.FBI_suits_recon = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"),
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"),
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"),
					Idstring("units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02")
				}
			},
			access = access_type_all
		}

		-- Blue light mp5 - overrides federales for a seemingly unused unit, and murkywater because previous units dealt stupid high DS levels damage
		self.unit_categories.CS_swat_MP5 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36")
				}
			},
			access = access_type_all
		}
		
		-- Blue heavy m4 - overrides murkywater because previous units dealt stupid high DS levels damage
		self.unit_categories.CS_heavy_M4 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale")
				}
			},
			access = access_type_all
		}
		
		-- Green light m4
		self.unit_categories.FBI_light_green_m4 = {
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
		
		-- Green light shotgunner
		self.unit_categories.FBI_light_green_r870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870")
				}
			},
			access = access_type_all
		}
		
		-- Green heavy m4
		self.unit_categories.FBI_heavy_green_m4 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi")
				}
			},
			access = access_type_all
		}
		
		-- Green heavy shotgunner
		self.unit_categories.FBI_heavy_green_r870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870")
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
		
		-- Grey light g36
		self.unit_categories.GS_light_grey_g36 = {
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
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city")
				}
			},
			access = access_type_all
		}
		
		-- Grey light ump
		self.unit_categories.GS_light_grey_ump = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass/ene_akan_fbi_swat_dw_ak47_ass")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale")
				}
			},
			access = access_type_all
		}
		
		-- Grey light benelli 
		self.unit_categories.GS_light_grey_benelli = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale")
				}
			},
			access = access_type_all
		}
		
		-- Grey light shotgunners
		self.unit_categories.GS_light_grey_r870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870/ene_akan_fbi_swat_dw_r870")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870")
				}
			},
			access = access_type_all
		}
		
		-- Grey heavy g36
		self.unit_categories.GS_heavy_grey_g36 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36")
				}
			},
			access = access_type_all
		}
		
		-- Grey heavy shotgunner
		self.unit_categories.GS_heavy_grey_r870 = {
			unit_types = {
				america = {
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

		-- Green shields
		self.unit_categories.FBI_green_shield = {
			special_type = "shield",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg")
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
		
		-- Grey shields
		self.unit_categories.GS_grey_shield = {
			special_type = "shield",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_shield/ene_city_shield")
				},
				russia = {
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
		
		self.unit_categories.medic = {
			special_type = "medic",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
					Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"),
					Idstring("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870")
				}
			},
			access = access_type_all
		}
		
		-- death squad snipers
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
		
		-- why the fuck would white house use normal "america" snipers instead of murkywater ones? seems like they use have hard-coded spawns system for the drill objective,
		-- so they might be limited on what chars they can use
		-- but why would they remove the murky snipers from the map's load package is beyond me. it's only 1 unit in the memory, it wont help the awfull performance this map has
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
					Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"),
					Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"),
					Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249")
				}
			},
			access = access_type_all
		}
		self.unit_categories.FBI_tank_annoying = {
			special_type = "tank",
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
				},
				russia = {
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
				},
				zombie = {
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
				},
				murkywater = {
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1"),
					Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_medic/ene_murkywater_bulldozer_medic")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale")
				}
			},
			access = access_type_all
		}
		
		if DWP.settings.DSdozer == true then
			self.unit_categories.FBI_tank_annoying.unit_types.america = {
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
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
				shield = 5,
				medic = 4,
				taser = 5,
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
				medic = 6,
				taser = 7,
				tank = 6,
				spooc = 4
			}
		elseif DWP.settings.difficulty == 4 then
			self.special_unit_spawn_limits = {
				shield = 8,
				medic = 7,
				taser = 8,
				tank = 7,
				spooc = 5
			}
		else
			log("[DW+] difficulty setting not found, special limits not adjusted properly.")
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
		squadmul = DWP.settings.difficulty * 1
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
	
	self.enemy_spawn_groups.tac_tazer_charge = { -- CS_shields
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_shield",
				freq = 1,
				amount_min = 3,
				amount_max = 3,
				tactics = self._tactics.CS_shield,
				rank = 3
			},
			{
				unit = "CS_swat_MP5",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.CS_cop_stealth,
				rank = 1
			},
			{
				unit = "CS_heavy_M4_w",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.CS_swat_heavy,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.tac_tazer_flanking = { -- CS_tazers
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_tazer",
				freq = 1,
				amount_min = 2,
				amount_max = 3,
				tactics_ = self._tactics.CS_tazer,
				rank = 1
			},
			{
				unit = "FBI_light_green_m4",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			},
			{
				unit = "GS_light_grey_g36",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			},
			{
				unit = "CS_heavy_M4",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			},
			{
				unit = "beat_cops",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.CS_swat_rifle_flank,
				rank = 1
			},
		}
	}

	self.enemy_spawn_groups.CS_swats = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "CS_swat_MP5",
				freq = 1,
				amount_min = 2,
				amount_max = 2,
				tactics = self._tactics.CS_swat_rifle,
				rank = 2
			},
			{
				unit = "CS_swat_R870",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.CS_swat_shotgun,
				rank = 1
			},
			{
				unit = "CS_swat_MP5",
				freq = 1,
				amount_min = 1,
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
				amount_min = 3,
				amount_max = 3,
				tactics = self._tactics.CS_swat_rifle,
				rank = 2
			},
			{
				unit = "CS_heavy_R870",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.CS_swat_rifle_flank,
				rank = 3
			},
			{
				unit = "medic",
				freq = 0.8,
				amount_max = 1,
				amount_max = 1,
				tactics = self._tactics.CS_swat_rifle,
				rank = 3
			}
		}
	}
	
	-- dozers
	if DWP.settings.difficulty <= 2 then
		self.enemy_spawn_groups.tac_bull_rush = { -- FBI_tanks
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.FBI_tank,
					rank = 3
				},
				{
					unit = "FBI_tank_annoying",
					freq = 1,
					amount_min = 1,
					amount_max = 1 * DWP.settings.difficulty,
					tactics = self._tactics.FBI_tank,
					rank = 3
				}
			}
		}
	elseif DWP.settings.difficulty == 3 then
		self.enemy_spawn_groups.tac_bull_rush = { -- FBI_tanks
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.FBI_tank,
					rank = 3
				},
				{
					unit = "FBI_tank_annoying",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.FBI_tank,
					rank = 3
				}
			}
		}
	else
		self.enemy_spawn_groups.tac_bull_rush = { -- FBI_tanks
			amount = {3 * squadmul, 3 * squadmul},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.FBI_tank,
					rank = 3
				},
				{
					unit = "FBI_tank_annoying",
					freq = 1,
					amount_min = 2,
					amount_max = 3,
					tactics = self._tactics.FBI_tank,
					rank = 3
				}
			}
		}
	end
	
	-- this squad is almost never used ever since they gutted the reinforce phase
	self.enemy_spawn_groups.FBI_defence_squad = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_suits_recon",
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				tactics = self._tactics.FBI_suit,
				rank = 1
			},
			{
				unit = "beat_cops",
				freq = 0.75,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_suit,
				rank = 1
			},
		}
	}
	
	-- in-between assaults squad
	self.enemy_spawn_groups.FBI_HRT_squad = {
		amount = {4 * squadmul, 4 * squadmul},
		spawn = {
			{
				unit = "HRT",
				freq = 1,
				amount_min = 2,
				amount_max = 2,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 1
			},
			{
				unit = "FBI_light_green_r870",
				freq = 0.5,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 1
			}
		}
	}
	
	self.enemy_spawn_groups.FBI_light_greens = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_light_green_m4",
				freq = 1,
				amount_min = 2,
				amount_max = 2,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			},
			{
				unit = "FBI_light_green_r870",
				freq = 1,
				amount_min = 2,
				amount_max = 2,
				tactics = self._tactics.FBI_swat_shotgun,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.GS_light_greys = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "GS_light_grey_g36",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			},
			{
				unit = "GS_light_grey_benelli",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_shotgun,
				rank = 1
			},
			{
				unit = "GS_light_grey_ump",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_shotgun,
				rank = 1
			},
			{
				unit = "GS_light_grey_r870",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_shotgun,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.FBI_heavy_greens = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_heavy_green_m4",
				freq = 1,
				amount_min = 3,
				amount_max = 3,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			},
			{
				unit = "FBI_heavy_green_r870",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_heavy_flank,
				rank = 1
			},
			{
				unit = "medic",
				freq = 0.8,
				amount_max = 1,
				amount_max = 1,
				tactics = self._tactics.CS_swat_rifle,
				rank = 3
			}
		}
	}
	self.enemy_spawn_groups.tac_swat_rifle_flank = { -- GS_heavy_greys
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "GS_heavy_grey_g36",
				freq = 1,
				amount_min = 3,
				amount_max = 3,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			},
			{
				unit = "GS_heavy_grey_r870",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_heavy_flank,
				rank = 1
			},
			{
				unit = "medic",
				freq = 0.8,
				amount_max = 1,
				amount_max = 1,
				tactics = self._tactics.CS_swat_rifle,
				rank = 3
			}
		}
	}

	self.enemy_spawn_groups.tac_shield_wall = { -- FBI_shield_green
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "FBI_green_shield",
				freq = 1,
				amount_min = 3,
				amount_max = 3,
				tactics = self._tactics.FBI_shield,
				rank = 1
			},
			{
				unit = "FBI_light_green_m4",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 1
			},
			{
				unit = "FBI_heavy_green_m4",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.GS_shield_grey = {
		amount = {3 * squadmul, 3 * squadmul},
		spawn = {
			{
				unit = "GS_grey_shield",
				freq = 1,
				amount_min = 3,
				amount_max = 3,
				tactics = self._tactics.FBI_shield,
				rank = 1
			},
			{
				unit = "GS_light_grey_g36",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_suit_stealth,
				rank = 1
			},
			{
				unit = "GS_heavy_grey_g36",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.FBI_swat_rifle,
				rank = 1
			}
		}
	}
	
	-- snipers + winters shields aka Death Squad
	-- on some maps sniper units seem to never move/only make a single move after they spawn, so sniper part of the death squad will be disabled there
	-- maps affected: slaughterhouse, bomb:docks, breakfast in tihuana
	if Global.level_data.level_id == "dinner" or Global.level_data.level_id == "crojob2" or Global.level_data.level_id == "pex" then
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
	
		self.besiege.assault.build_duration = 5
		
		-- heist duration, smaller values are only used on no mercy for first 2 waves
		self.besiege.assault.sustain_duration_min = {
			25,
			335,
			335
		}
		self.besiege.assault.sustain_duration_max = {
			30,
			365,
			365
		}
		self.besiege.assault.sustain_duration_balance_mul = {
			1,
			1,
			1,
			1
		}
		
		-- self-explanatory
		if Global and Global.level_data and Global.level_data.level_id == "nmh" then
			self.besiege.assault.delay = {
				4,
				10,
				15
			}
		else
			self.besiege.assault.delay = {
				4,
				30,
				30
			}
		end
		
		-- if we have hostages increase delay by a few seconds. hostage control value here
		if Global and Global.level_data and Global.level_data.level_id == "nmh" then
			-- no mercy will be the only map where having hostages with HC enabled does not provide extra long delays, because its usually really easy to clear the map of enemies during the fade period
			if DWP.settings.hostage_control then
				self.besiege.assault.hostage_hesitation_delay = {
					1,
					17,
					17
				}
			else
				self.besiege.assault.hostage_hesitation_delay = {
					1,
					5,
					5
				}
			end
		elseif DWP.settings.hostage_control then
			self.besiege.assault.hostage_hesitation_delay = {
				35,
				35,
				35
			}
		else
			self.besiege.assault.hostage_hesitation_delay = {
				10,
				10,
				10
			}
		end
		
		-- Max cop amount on the map at the same time, depends on diff
		self.besiege.assault.force = {
			10,
			10,
			26.6
		}
		-- multiplier for cop amounts on the map, depends on player count
		self.besiege.assault.force_balance_mul = {
			2.5,
			2.5,
			2.5,
			2.5
		}
		
		-- Total max cop spawns per each assault
		if Global and Global.level_data and Global.level_data.level_id == "nmh" then
			self.besiege.assault.force_pool = {
				math.floor(DWP.settings.assforce_pool * 1.25),
				math.floor(DWP.settings.assforce_pool * 1.25),
				math.floor(DWP.settings.assforce_pool * 1.25)
			}
		else
			self.besiege.assault.force_pool = {
				math.floor(DWP.settings.assforce_pool),
				math.floor(DWP.settings.assforce_pool),
				math.floor(DWP.settings.assforce_pool)
			}
		end
		
		self.besiege.assault.force_pool_balance_mul = {
			1,
			1,
			1,
			1
		}

		-- Add cloaker specific group
		self.besiege.cloaker.groups = {
			single_spooc = {
				1,
				1,
				1
			}
		}
		
		-- down bellow are a bunch of map specific cop pool changes, because some maps have fucked up respawn points/enemy damage/scripted spawns
		if Global and Global.level_data then
		
			local level_balance_data = {
				
				-- note: default is 2.5
				
				------ BAIN
				-- diamonds
				family = 2.3,
				-- tarantino
				rvd1 = 2,
				rvd2 = 2,
				-- alesso-хуессо
				arena = 2.125,
				-- TRANSPORT
				-- crossroads
				arm_cro = 2,
				-- downtown
				arm_hcm = 2.1,
				-- harbor
				arm_fac = 2.1,
				-- park
				arm_par = 2,
				-- train
				arm_for = 2.125,
				-- underpass
				arm_und = 2.125,
				
				------ CLASSICS
				-- FWB is good. in theory
				red2 = 2.15,
				-- blue bridge
				glace = 2.25,
				-- dodge street
				run = 2.25,
				-- mercy r34
				nmh = 1.85,
				-- calm tent
				flat = 2.25,
				-- slaughterbuilding
				dinner = 2.15,
				-- overcover
				man = 2.1,
				
				------ EVENTS
				-- lab rats. ah yes, lets make a map that has no cover, horrible pathing, with zip lines as your main method of moving (things that make you as vulnerable as an ictv rogue on DS) oh and lets place headless dozers there. oh and yeah, lets keep the cops vanilla american faction instead of the zombies one. sooooo cooooooool
				nail = 2.125,
				
				------ JIMMY
				-- boiling wawtuh with stupid ak's
				mad = 1.75,
				
				------ JIU FENG
				-- vlad breakout
				sand = 2.25,
				
				------ LOCKE
				-- polar bear's home
				wwh = 2,
				-- beneath the everest
				pbr = 1.9,
				-- STIL BREATHIIIIIIIIIIINGGG
				pbr2 = 2.25,
				-- "WE NEED TO BUILD A WALL!" - most popular child molester of 2017
				mex = 1.7,
				-- this is the worst map design in this game after goat sim, and i am forced to tweak it. great.
				mex_cooking = 1.75,
				-- brooklyn the bank
				brb = 2.15,
				-- henry's cock
				des = 2,
				-- black tablet
				sah = 1.8,
				-- the end
				vit = 2.1,
				
				------ BUTCHER
				-- Sosa сосёт ХААХААААААААААААААААААААА я смешной
				friend = 2.2,
				-- world of warships
				crojob2 = 2.15,
				
				------ CONTINENTAL
				-- 10-10
				spa = 2.25,
				
				------ DENTIST
				-- OG casino
				kenaz = 1.7,
				-- hot line
				mia_1 = 2,
				mia_2 = 2,
				-- hox_1, duh
				hox_1 = 2.2,
				
				------ ELEPHANT
				-- wtf is this id lmao
				welcome_to_the_jungle_2 = 1.85,
				
				election_day_1 = 2.1,
				election_day_2 = 2.1,
				
				------ VLAD
				-- SAFES BABY WHOOOOOO
				jolly = 2.1,
				-- buluc's clusterfuck of objectives
				fex = 2.1,
				-- goat sim day 2. day 1 is also really bad, but mostly because of snipers, not the other squads, so its ok.
				peta2 = 1.85,
				-- at least i dont have to shave pubes anymore
				shoutout_raid = 2,
				-- san martin
				bex = 2.25,
				-- santa's workshop. holy shit is this bad
				cane = 1.65,
				
				------ ESCAPES
				-- AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
				escape_cafe = 1.9,
			}
			
			local lvl_id = Global.level_data.level_id
			if level_balance_data[lvl_id] then
				local mul = level_balance_data[lvl_id]
				self.besiege.assault.force_balance_mul = {
					mul,
					mul,
					mul,
					mul
				}
			end
			
		end
		
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
		
		-- Why tf is it this way?
		self.street = deep_clone(self.besiege)
		self.safehouse = deep_clone(self.besiege)
	
	end
	
	if NoobJoin or BLT.Mods:GetModByName("Newbies go back to overkill") then
		DWP:yoink_ngbto()
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

local function calculate_special_chance(base_value, position)
	-- default diff value is 0.8, calculations are based on that
	local second_pos = base_value / 2
	if position == 2 then
		return second_pos
	elseif position == 3 then
		return second_pos / 3 * 5 + second_pos
	end
end

--shields have more heavies then tazers
function GroupAITweakData:init_taskdata_deathwish_1()
	
	DWP:update_dom_values(1)
	
	--48
	self.besiege.assault.force = {
		9.6,
		9.6,
		25.6
	}
	-- 55/45
	self.besiege.assault.groups = {
		CS_swats = {
			0.4,
			0.1191,
			0.1191
		},
		FBI_light_greens = {
			0,
			0.1191,
			0.1191
		},
		GS_light_greys = {
			0,
			0.1191,
			0.1191
		},
		-- 65/35
		CS_heavys = {
			0.2,
			0.0641,
			0.0641
		},
		FBI_heavy_greens = {
			0,
			0.0641,
			0.0641
		},
		tac_swat_rifle_flank = { -- GS_heavy_greys
			0,
			0.0641,
			0.0641
		},
		-- shield: 27.5; tank: 20; tazer: 26; DS: 6.5; spook: 20
		tac_tazer_charge = { -- CS_shields
			0.2,
			calculate_special_chance(0.04125, 2),
			calculate_special_chance(0.04125, 3)
		},
		tac_shield_wall = { -- FBI_shield_green
			0,
			calculate_special_chance(0.04125, 2),
			calculate_special_chance(0.04125, 3)
		},
		GS_shield_grey = {
			0,
			calculate_special_chance(0.04125, 2),
			calculate_special_chance(0.04125, 3)
		},
		tac_bull_rush = { -- FBI_tanks
			0,
			calculate_special_chance(0.09, 2),
			calculate_special_chance(0.09, 3)
		},
		tac_tazer_flanking = { -- CS_tazers
			0.1,
			calculate_special_chance(0.117, 2),
			calculate_special_chance(0.117, 3)
		},
		Death_squad = {
			0,
			calculate_special_chance(0.02925, 2),
			calculate_special_chance(0.02925, 3)
		},
		FBI_spoocs = {
			0,
			calculate_special_chance(0.04, 2),
			calculate_special_chance(0.04, 3)
		},
		single_spooc = {
			0,
			calculate_special_chance(0.05, 2),
			calculate_special_chance(0.05, 3)
		},
		Phalanx = {
			0,
			0,
			0
		},
		marshal_squad = {
			0,
			0,
			0
		},
		Undead = {
			0,
			0,
			0
		},
		snowman_boss = {
			0,
			0,
			0
		},
		piggydozer = {
			0,
			0,
			0
		}
	}

	self.besiege.reenforce.groups = {
		FBI_defence_squad = {
			1,
			1,
			1
		}
	}
	
	self.besiege.recon.groups = {
		FBI_HRT_squad = {
			1,
			1,
			1
		},
		single_spooc = {
			0,
			0,
			0
		},
		Phalanx = {
			0,
			0,
			0
		},
		marshal_squad = {
			0,
			0,
			0
		},
		snowman_boss = {
			0,
			0,
			0
		},
		piggydozer = {
			0,
			0,
			0
		}
	}
end

function GroupAITweakData:init_taskdata_deathwish_2()
	
	DWP:update_dom_values(2)
	
	--60
	self.besiege.assault.force = {
		12,
		12,
		32
	}
	-- 50/50
	self.besiege.assault.groups = {
		CS_swats = {
			0.4,
			0.0916,
			0.0916
		},
		FBI_light_greens = {
			0,
			0.0916,
			0.0916
		},
		GS_light_greys = {
			0,
			0.0916,
			0.0916
		},
		-- 55/45
		CS_heavys = {
			0.2,
			0.075,
			0.075
		},
		FBI_heavy_greens = {
			0,
			0.075,
			0.075
		},
		tac_swat_rifle_flank = { -- GS_heavy_greys
			0,
			0.075,
			0.075
		},
		-- shield: 27.5; tank: 22; tazer: 24; DS: 8.5; spook: 18
		tac_tazer_charge = { -- CS_shields
			0.2,
			calculate_special_chance(0.04583, 2),
			calculate_special_chance(0.04583, 3)
		},
		tac_shield_wall = { -- FBI_shield_green
			0,
			calculate_special_chance(0.04583, 2),
			calculate_special_chance(0.04583, 3)
		},
		GS_shield_grey = {
			0,
			calculate_special_chance(0.04583, 2),
			calculate_special_chance(0.04583, 3)
		},
		tac_bull_rush = { -- FBI_tanks
			0,
			calculate_special_chance(0.11, 2),
			calculate_special_chance(0.11, 3)
		},
		tac_tazer_flanking = { -- CS_tazers
			0.1,
			calculate_special_chance(0.12, 2),
			calculate_special_chance(0.12, 3)
		},
		Death_squad = {
			0,
			calculate_special_chance(0.0425, 2),
			calculate_special_chance(0.0425, 3)
		},
		FBI_spoocs = {
			0,
			calculate_special_chance(0.04, 2),
			calculate_special_chance(0.04, 3)
		},
		single_spooc = {
			0,
			calculate_special_chance(0.05, 2),
			calculate_special_chance(0.05, 3)
		},
		Phalanx = {
			0,
			0,
			0
		},
		marshal_squad = {
			0,
			0,
			0
		},
		Undead = {
			0,
			0,
			0
		},
		snowman_boss = {
			0,
			0,
			0
		},
		piggydozer = {
			0,
			0,
			0
		}
	}

	self.besiege.reenforce.groups = {
		FBI_defence_squad = {
			1,
			1,
			1
		}
	}

	self.besiege.recon.groups = {
		FBI_HRT_squad = {
			1,
			1,
			1
		},
		single_spooc = {
			0,
			0,
			0
		},
		Phalanx = {
			0,
			0,
			0
		},
		marshal_squad = {
			0,
			0,
			0
		},
		snowman_boss = {
			0,
			0,
			0
		},
		piggydozer = {
			0,
			0,
			0
		}
	}
end

function GroupAITweakData:init_taskdata_deathwish_3()
	
	DWP:update_dom_values(3)
	
	--76
	self.besiege.assault.force = {
		15.2,
		15.2,
		40.53
	}
	-- 40/60
	self.besiege.assault.groups = {
		CS_swats = {
			0.4,
			0.0533,
			0.0533
		},
		FBI_light_greens = {
			0,
			0.0533,
			0.0533
		},
		GS_light_greys = {
			0,
			0.0533,
			0.0533
		},
		-- 40/60
		CS_heavys = {
			0.2,
			0.08,
			0.08
		},
		FBI_heavy_greens = {
			0,
			0.08,
			0.08
		},
		tac_swat_rifle_flank = { -- GS_heavy_greys
			0,
			0.08,
			0.08
		},
		-- shield: 26; tank: 26; tazer: 20; DS: 11; spook: 17
		tac_tazer_charge = { -- CS_shields
			0.2,
			calculate_special_chance(0.052, 2),
			calculate_special_chance(0.052, 3)
		},
		tac_shield_wall = { -- FBI_shield_green
			0,
			calculate_special_chance(0.052, 2),
			calculate_special_chance(0.052, 3)
		},
		GS_shield_grey = {
			0,
			calculate_special_chance(0.052, 2),
			calculate_special_chance(0.052, 3)
		},
		tac_bull_rush = { -- FBI_tanks
			0,
			calculate_special_chance(0.156, 2),
			calculate_special_chance(0.156, 3)
		},
		tac_tazer_flanking = { -- CS_tazers
			0.1,
			calculate_special_chance(0.12, 2),
			calculate_special_chance(0.12, 3)
		},
		Death_squad = {
			0,
			calculate_special_chance(0.066, 2),
			calculate_special_chance(0.066, 3)
		},
		FBI_spoocs = {
			0,
			calculate_special_chance(0.051, 2),
			calculate_special_chance(0.051, 3)
		},
		single_spooc = {
			0,
			calculate_special_chance(0.051, 2),
			calculate_special_chance(0.051, 3)
		},
		Phalanx = {
			0,
			0,
			0
		},
		marshal_squad = {
			0,
			0,
			0
		},
		Undead = {
			0,
			0,
			0
		},
		snowman_boss = {
			0,
			0,
			0
		},
		piggydozer = {
			0,
			0,
			0
		}
	}

	self.besiege.reenforce.groups = {
		FBI_defence_squad = {
			1,
			1,
			1
		}
	}

	self.besiege.recon.groups = {
		FBI_HRT_squad = {
			1,
			1,
			1
		},
		single_spooc = {
			0,
			0,
			0
		},
		Phalanx = {
			0,
			0,
			0
		},
		marshal_squad = {
			0,
			0,
			0
		},
		snowman_boss = {
			0,
			0,
			0
		},
		piggydozer = {
			0,
			0,
			0
		}
	}
end

function GroupAITweakData:init_taskdata_deathwish_4()
	
	DWP:update_dom_values(4)
	
	--100
	self.besiege.assault.force = {
		20,
		20,
		53.3
	}
	-- 30/70
	self.besiege.assault.groups = {
		CS_swats = {
			0.4,
			0.02,
			0.02
		},
		FBI_light_greens = {
			0,
			0.02,
			0.02
		},
		GS_light_greys = {
			0,
			0.02,
			0.02
		},
		-- 20/80
		CS_heavys = {
			0.2,
			0.08,
			0.08
		},
		FBI_heavy_greens = {
			0,
			0.08,
			0.08
		},
		tac_swat_rifle_flank = { -- GS_heavy_greys
			0,
			0.08,
			0.08
		},
		-- shield: 27; tank: 30; tazer: 15; DS: 13; spook: 15
		tac_tazer_charge = { -- CS_shields
			0.2,
			calculate_special_chance(0.063, 2),
			calculate_special_chance(0.063, 3)
		},
		tac_shield_wall = { -- FBI_shield_green
			0,
			calculate_special_chance(0.063, 2),
			calculate_special_chance(0.063, 3)
		},
		GS_shield_grey = {
			0,
			calculate_special_chance(0.063, 2),
			calculate_special_chance(0.063, 3)
		},
		tac_bull_rush = { -- FBI_tanks
			0,
			calculate_special_chance(0.21, 2),
			calculate_special_chance(0.21, 3)
		},
		tac_tazer_flanking = { -- CS_tazers
			0.1,
			calculate_special_chance(0.105, 2),
			calculate_special_chance(0.105, 3)
		},
		Death_squad = {
			0,
			calculate_special_chance(0.091, 2),
			calculate_special_chance(0.091, 3)
		},
		FBI_spoocs = {
			0,
			calculate_special_chance(0.053, 2),
			calculate_special_chance(0.053, 3)
		},
		single_spooc = {
			0,
			calculate_special_chance(0.052, 2),
			calculate_special_chance(0.052, 3)
		},
		Phalanx = {
			0,
			0,
			0
		},
		marshal_squad = {
			0,
			0,
			0
		},
		Undead = {
			0,
			0,
			0
		},
		snowman_boss = {
			0,
			0,
			0
		},
		piggydozer = {
			0,
			0,
			0
		}
	}

	self.besiege.reenforce.groups = {
		FBI_defence_squad = {
			1,
			1,
			1
		}
	}

	self.besiege.recon.groups = {
		FBI_HRT_squad = {
			1,
			1,
			1
		},
		single_spooc = {
			0,
			0,
			0
		},
		Phalanx = {
			0,
			0,
			0
		},
		marshal_squad = {
			0,
			0,
			0
		},
		snowman_boss = {
			0,
			0,
			0
		},
		piggydozer = {
			0,
			0,
			0
		}
	}
end