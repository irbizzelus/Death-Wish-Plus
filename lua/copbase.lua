Hooks:PreHook(CopBase, "post_init", "DWP_CopBase_post_init", function(self)
	local weapon_mapping = {}
	if DWP and DWP.DWdifficultycheck and DWP.settings_config then
		weapon_mapping = {
			
			------ AMERICA ------
			
			-- BEAT COPS
			[("units/payday2/characters/ene_cop_1/ene_cop_1"):key()] = {"c45","raging_bull"},
			[("units/payday2/characters/ene_cop_2/ene_cop_2"):key()] = {"c45","raging_bull"},
			[("units/payday2/characters/ene_cop_3/ene_cop_3"):key()] = {"r870","ump"},
			[("units/payday2/characters/ene_cop_4/ene_cop_4"):key()] = {"r870","ump"},
			[("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"):key()] = {"c45","raging_bull"},
			[("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"):key()] = {"c45","raging_bull"},
			[("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"):key()] = {"r870","ump"},
			[("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"):key()] = {"r870","ump"},
			-- LIGHT BLUE SWAT
			[("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = {"s552","mp5"},
			[("units/payday2/characters/ene_swat_2/ene_swat_2"):key()] = {"r870"},
			-- HEAVY BLUE SWAT
			[("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = {"s552","m4"},
			[("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = {"saiga","r870"},
			-- LIGHT FBI GREEN
			[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = {"s552","m4_yellow","scar_murky"},
			[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = {"r870"},
			-- HEAVY FBI GREEN
			[("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = {"scar_murky","sg417"},
			[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = {"benelli"},
			-- LIGHT GENSEC GREY
			[("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"):key()] = {"g36","raging_bull"},
			[("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"):key()] = {"benelli","saiga"},
			[("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"):key()] = {"ump","g36"},
			[("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"):key()] = {"r870","mossberg"},
			-- HEAVY GENSEC GREY
			[("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"):key()] = {"g36","m249","ak47_ass","rpk_lmg"},
			[("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = {"r870","benelli"},
			-- FBI SUITS
			[("units/payday2/characters/ene_fbi_1/ene_fbi_1"):key()] = {"raging_bull","mp5"},
			[("units/payday2/characters/ene_fbi_2/ene_fbi_2"):key()] = {"raging_bull","mp5"},
			-- HRT'S
			[("units/payday2/characters/ene_fbi_3/ene_fbi_3"):key()] = {"beretta92","asval_smg"},
			-- MEDIC
			[("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = {"m4","ump","mp5_tactical"},
			[("units/payday2/characters/ene_medic_r870/ene_medic_r870"):key()] = {"r870","mossberg"},
			-- GREEN DOZER
			[("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = {"r870","sko12_conc","smoke"},
			-- CLOAKER
			[("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = {"beretta92","mp5_tactical"},
			-- SHIELDS
			[("units/payday2/characters/ene_shield_1/ene_shield_1"):key()] = {"mac11","mp9"},
			[("units/payday2/characters/ene_shield_2/ene_shield_2"):key()] = {"raging_bull"},
			[("units/payday2/characters/ene_city_shield/ene_city_shield"):key()] = {"akmsu_smg"},
			
			
			------ RUSSIA ------
			
			-- BEAT COPS
			[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"):key()] = {"saiga","raging_bull"},
			[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg"):key()] = {"c45","akmsu_smg"},
			-- LIGHT BLUE SWAT
			[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass"):key()] = {"s552","asval_smg"},
			[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870"):key()] = {"r870"},
			-- HEAVY BLUE SWAT
			[("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass"):key()] = {"s552","ak47_ass"},
			[("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870"):key()] = {"saiga","r870"},
			-- LIGHT FBI GREEN
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"):key()] = {"ak47_ass","m4","sg417"},
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"):key()] = {"r870"},
			-- HEAVY FBI GREEN + HEAVY GENSEC GREY
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"):key()] = {"m249","rpk_lmg"},
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870"):key()] = {"r870","benelli"},
			-- LIGHT GENSEC GREY
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass/ene_akan_fbi_swat_dw_ak47_ass"):key()] = {"g36"},
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870/ene_akan_fbi_swat_dw_r870"):key()] = {"mossberg"},
			-- FBI SUITS
			[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"):key()] = {"raging_bull","mp5"},
			-- HRT'S
			[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"):key()] = {"beretta92","asval_smg"},
			-- MEDIC
			[("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass"):key()] = {"asval_smg","ump","mp5_tactical"},
			[("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870"):key()] = {"r870","mossberg"},
			-- GREEN DOZER
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"):key()] = {"r870","sko12_conc","smoke"},
			-- CLOAKER
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg"):key()] = {"beretta92","asval_smg"},
			-- SHIELDS
			[("units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45"):key()] = {"raging_bull"},
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg"):key()] = {"akmsu_smg"},
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg"):key()] = {"sr2_smg"},
			
			
			------ ZOMBIE ------
			
			-- BEAT COPS
			[("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"):key()] = {"c45","raging_bull"},
			[("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"):key()] = {"c45","raging_bull"},
			-- used as part of grey lights
			[("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"):key()] = {"r870","ump","saiga"},
			[("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4"):key()] = {"r870","ump"},
			-- LIGHT BLUE SWAT
			[("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"):key()] = {"s552","mp5"},
			[("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2"):key()] = {"r870"},
			-- HEAVY BLUE SWAT
			[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"):key()] = {"s552","m4"},
			[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"):key()] = {"saiga","r870"},
			-- LIGHT FBI GREEN - used as LIGHT GENSEC GREY squads as well
			[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"):key()] = {"s552","m4_yellow","scar_murky","g36","raging_bull"},
			[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"):key()] = {"r870","mossberg"},
			-- HEAVY FBI GREEN - used as HEAVY GENSEC GREY squads as well
			[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1"):key()] = {"sg417","g36","m249","rpk_lmg"},
			[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870"):key()] = {"benelli","r870"},
			-- FBI SUITS
			[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"):key()] = {"raging_bull","mp5"},
			[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"):key()] = {"raging_bull","mp5"},
			-- HRT'S
			[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3"):key()] = {"beretta92","asval_smg"},
			-- MEDIC
			[("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"):key()] = {"m4","ump","mp5_tactical"},
			[("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870"):key()] = {"r870","mossberg"},
			-- GREEN DOZER
			[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"):key()] = {"r870","sko12_conc","smoke"},
			-- CLOAKER
			[("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1"):key()] = {"beretta92","mp5_tactical"},
			-- SHIELDS
			[("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1"):key()] = {"mac11","mp9","akmsu_smg"},
			[("units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2"):key()] = {"raging_bull"},
			
			
			------ MURKYWATER ------
			
			-- BEAT COPS
			-- same as american
			-- LIGHT BLUE SWAT
			[("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"):key()] = {"s552","m4"},
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"):key()] = {"r870"},
			-- HEAVY BLUE SWAT m4 + HEAVY FBI GREEN m4
			[("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy"):key()] = {"g36","s552","scar_murky","sg417"},
			-- HEAVY BLUE SWAT r870 + HEAVY FBI GREEN r870 + HEAVY GENSEC GREY r870
			[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun"):key()] = {"saiga","benelli"},
			-- LIGHT FBI GREEN
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"):key()] = {"m4_yellow","scar_murky"},
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870"):key()] = {"r870"},
			-- LIGHT GENSEC GREY
			-- g36 (but more) + ump
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city"):key()] = {"g36","g36","raging_bull","ump",},
			-- r870 + benelli
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870"):key()] = {"benelli"},
			-- HEAVY GENSEC GREY
			[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36"):key()] = {"g36","m249"},
			-- FBI SUITS
			-- same as american
			-- HRT'S
			-- same as american
			-- MEDIC
			[("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"):key()] = {"m4","ump","mp5_tactical"},
			[("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870"):key()] = {"r870"},
			-- GREEN DOZER
			[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"):key()] = {"r870","sko12_conc","smoke"},
			-- CLOAKER
			[("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker"):key()] = {"deagle"},
			-- SHIELDS
			[("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield"):key()] = {"mp9","raging_bull","akmsu_smg"},
			
			
			------ FEDERALES ------
			
			-- BEAT COPS
			[("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"):key()] = {"c45","raging_bull"},
			[("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"):key()] = {"r870","ump"},
			-- LIGHT BLUE SWAT
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36"):key()] = {"s552","m4"},
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870"):key()] = {"r870"},
			-- HEAVY BLUE SWAT
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"):key()] = {"s552","ak47_ass"},
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870"):key()] = {"saiga"},
			-- LIGHT FBI GREEN
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"):key()] = {"ak47_ass","m4"},
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"):key()] = {"r870"},
			-- HEAVY FBI GREEN
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"):key()] = {"ak47_ass","scar_murky"},
			-- includes HEAVY GENSEC GREY r870
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"):key()] = {"r870"},
			-- LIGHT GENSEC GREY
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"):key()] = {"g36","raging_bull"},
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale"):key()] = {"saiga","mp5"}, -- benelli + ump
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"):key()] = {"r870","mossberg"},
			-- HEAVY GENSEC GREY
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36"):key()] = {"g36","ak47_ass","rpk_lmg"},
			-- FBI SUITS
			[("units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"):key()] = {"raging_bull","beretta92"},
			[("units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02"):key()] = {"raging_bull","beretta92"},
			-- HRT'S
			[("units/pd2_dlc_bex/characters/ene_bex_security_suit_03/ene_bex_security_suit_03"):key()] = {"asval_smg"},
			-- MEDIC
			[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale"):key()] = {"m4","ump","asval_smg"},
			[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870"):key()] = {"mossberg"},
			-- GREEN DOZER
			[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"):key()] = {"r870","sko12_conc","smoke"},
			-- CLOAKER
			[("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale"):key()] = {"mp5"},
			-- SHIELDS
			[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9"):key()] = {"mac11","akmsu_smg"}, -- grey+green
			[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45"):key()] = {"raging_bull"},
			
			-- The freak
			[("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"):key()] = {"saiga"}
		}
		
		if DWP.settings_config.difficulty >= 2 then
			-- light greens get stronger weapons and heavy greys get zeal snipers (they are weak stats wise, but sound intimidating. ++ is not suppose to be much harder anyway)
			weapon_mapping[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = {"s552","g36"}
			weapon_mapping[("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = {"heavy_zeal_sniper","benelli"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"):key()] = {"ak47_ass","asval_smg"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870"):key()] = {"svdsil_snp","r870","benelli"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"):key()] = {"s552","g36","raging_bull"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870"):key()] = {"benelli","heavy_zeal_sniper"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"):key()] = {"ak47_ass","scar_murky"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870"):key()] = {"r870","heavy_zeal_sniper"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"):key()] = {"ak47_ass"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"):key()] = {"r870","r870","heavy_zeal_sniper"}
			-- removed the "smoke" weapon to make green dozer more annoying by increasing chances for the stun shotgun
			local green_dozer = {"r870","sko12_conc"}
			weapon_mapping[("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = green_dozer
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"):key()] = green_dozer
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"):key()] = green_dozer
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"):key()] = green_dozer
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"):key()] = green_dozer
			-- The freak
			weapon_mapping[("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"):key()] = {"saiga","m249"}
		end
		if DWP.settings_config.difficulty >= 3 then
			-- more high dps weapons and snipers for shotgunner units; cloaker now has r870 lmao
			-- US
			weapon_mapping[("units/payday2/characters/ene_cop_1/ene_cop_1"):key()] = {"raging_bull"}
			weapon_mapping[("units/payday2/characters/ene_cop_2/ene_cop_2"):key()] = {"raging_bull"}
			weapon_mapping[("units/payday2/characters/ene_cop_3/ene_cop_3"):key()] = {"saiga"}
			weapon_mapping[("units/payday2/characters/ene_cop_4/ene_cop_4"):key()] = {"saiga"}
			weapon_mapping[("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"):key()] = {"saiga"}
			weapon_mapping[("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"):key()] = {"saiga"}
			weapon_mapping[("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = {"heavy_zeal_sniper","r870"}
			weapon_mapping[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = {"s552","g36"}
			weapon_mapping[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = {"raging_bull"}
			weapon_mapping[("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = {"ak47_ass"}
			weapon_mapping[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = {"benelli","m14_sniper_npc"}
			local grey_light = {"g36","raging_bull","heavy_zeal_sniper"}
			weapon_mapping[("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"):key()] = grey_light
			weapon_mapping[("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"):key()] = grey_light
			weapon_mapping[("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"):key()] = grey_light
			weapon_mapping[("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"):key()] = grey_light
			weapon_mapping[("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"):key()] = {"m249","ak47_ass"}
			weapon_mapping[("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = {"m14_sniper_npc"}
			weapon_mapping[("units/payday2/characters/ene_fbi_1/ene_fbi_1"):key()] = {"raging_bull"}
			weapon_mapping[("units/payday2/characters/ene_fbi_2/ene_fbi_2"):key()] = {"raging_bull"}
			weapon_mapping[("units/payday2/characters/ene_fbi_3/ene_fbi_3"):key()] = {"asval_smg"}
			weapon_mapping[("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = {"g36"}
			weapon_mapping[("units/payday2/characters/ene_medic_r870/ene_medic_r870"):key()] = {"heavy_zeal_sniper"}
			weapon_mapping[("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = {"r870"}
			weapon_mapping[("units/payday2/characters/ene_shield_1/ene_shield_1"):key()] = {"raging_bull"}
			weapon_mapping[("units/payday2/characters/ene_shield_2/ene_shield_2"):key()] = {"raging_bull"}
			weapon_mapping[("units/payday2/characters/ene_city_shield/ene_city_shield"):key()] = {"raging_bull"}
			-- RUS
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"):key()] = {"saiga"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass"):key()] = {"ak47_ass","asval_smg"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870"):key()] = {"svdsil_snp"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass"):key()] = {"ak47_ass"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870"):key()] = {"svdsil_snp","r870"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"):key()] = {"ak47_ass"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"):key()] = {"svdsil_snp"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"):key()] = {"m249","ak47_ass"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870"):key()] = {"svd_snp"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"):key()] = {"asval_smg"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass"):key()] = {"ak47_ass"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870"):key()] = {"svdsil_snp"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg"):key()] = {"r870"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg"):key()] = {"raging_bull"}
			-- ZOMB
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"):key()] = {"saiga"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4"):key()] = {"saiga"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"):key()] = {"s552","g36"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"):key()] = {"ak47_ass"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"):key()] = {"m14_sniper_npc","r870"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"):key()] = {"r870","m14_sniper_npc"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1"):key()] = {"g36","m249"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3"):key()] = {"asval_smg"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"):key()] = {"g36"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870"):key()] = {"heavy_zeal_sniper"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1"):key()] = {"r870"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2"):key()] = {"raging_bull"}
			-- MURK
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"):key()] = {"s552","g36"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy"):key()] = {"g36","scar_murky"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun"):key()] = {"m14_sniper_npc","benelli"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city"):key()] = {"g36","g36","raging_bull"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870"):key()] = {"heavy_zeal_sniper"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36"):key()] = {"g36"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"):key()] = {"g36"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870"):key()] = {"heavy_zeal_sniper"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker"):key()] = {"r870","deagle"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield"):key()] = {"raging_bull"}
			-- MEX
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"):key()] = {"saiga"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36"):key()] = {"s552","g36"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"):key()] = {"s552","ak47_ass"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870"):key()] = {"saiga","svdsil_snp"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"):key()] = {"r870","svdsil_snp"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"):key()] = {"ak47_ass","g36"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"):key()] = {"r870","svd_snp"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"):key()] = {"g36","raging_bull"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale"):key()] = {"ak47_ass"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"):key()] = {"r870","svdsil_snp"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36"):key()] = {"m249","ak47_ass"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale"):key()] = {"ak47_ass"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870"):key()] = {"svdsil_snp"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale"):key()] = {"r870"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9"):key()] = {"raging_bull"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45"):key()] = {"raging_bull"}
			-- The freak
			weapon_mapping[("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"):key()] = {"mini","m249"}
		end
		if DWP.settings_config.difficulty == 4 then
			-- remove a few weaker counterparts
			weapon_mapping[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = {"g36"}
			weapon_mapping[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = {"m14_sniper_npc"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"):key()] = {"g36"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"):key()] = {"m14_sniper_npc"}
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"):key()] = {"m14_sniper_npc"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"):key()] = {"g36"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy"):key()] = {"g36"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun"):key()] = {"m14_sniper_npc"}
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker"):key()] = {"r870"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36"):key()] = {"g36","ak47_ass"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"):key()] = {"ak47_ass"}
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"):key()] = {"svdsil_snp"}
			-- green dozer now only has the concus shotgun to make him even more annoying, even though dps is lower
			local green_dozer = {"sko12_conc"}
			weapon_mapping[("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = green_dozer
			weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"):key()] = green_dozer
			weapon_mapping[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"):key()] = green_dozer
			weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"):key()] = green_dozer
			weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"):key()] = green_dozer
			-- The freak
			weapon_mapping[("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"):key()] = {"mini"}
		end
	end
	
	local weapon_swap = weapon_mapping[self._unit:name():key()]
	if weapon_swap then
		self._default_weapon_id = type(weapon_swap) == "table" and table.random(weapon_swap) or weapon_swap
	end
end)