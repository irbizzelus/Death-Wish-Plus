-- update enemy weapon usage
Hooks:PreHook(CopBase, "post_init", "DWP_CopBase_post_init", function(self)
	
	if not (DWP and DWP.DWdifficultycheck and DWP.settings_config) then
		return
	end
	
	if not DWP.cop_weapon_mapping then
		DWP.cop_weapon_mapping = {
			
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
			[("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = {"m4","mp5"},
			[("units/payday2/characters/ene_swat_2/ene_swat_2"):key()] = {"saiga"},
			-- HEAVY BLUE SWAT
			[("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = {"mp5_tactical","m4"},
			[("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = {"saiga"},
			-- LIGHT FBI GREEN
			[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = {"s552","m4_yellow","scar_murky"},
			[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = {"r870", "mp5_tactical"},
			-- HEAVY FBI GREEN
			[("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = {"scar_murky","sg417"},
			[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = {"r870", "benelli"},
			-- LIGHT GENSEC GREY
			[("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"):key()] = {"g36","raging_bull"},
			[("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"):key()] = {"benelli","mp5_tactical"},
			[("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"):key()] = {"ump","mp9"},
			[("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"):key()] = {"r870","mossberg"},
			-- HEAVY GENSEC GREY
			[("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"):key()] = {"g36","m249"},
			[("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = {"r870","benelli","mossberg"},
			-- FBI SUITS
			[("units/payday2/characters/ene_fbi_1/ene_fbi_1"):key()] = {"raging_bull","mp5"},
			[("units/payday2/characters/ene_fbi_2/ene_fbi_2"):key()] = {"raging_bull","mp5"},
			-- HRT'S
			[("units/payday2/characters/ene_fbi_3/ene_fbi_3"):key()] = {"beretta92","asval_smg"},
			-- MEDIC
			[("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = {"m4","ump","mp5_tactical"},
			[("units/payday2/characters/ene_medic_r870/ene_medic_r870"):key()] = {"r870","mossberg"},
			-- GREEN DOZER
			[("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = {"r870","sko12_conc","ak47"},
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
			[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass"):key()] = {"ak47","asval_smg"},
			[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870"):key()] = {"saiga"},
			-- HEAVY BLUE SWAT
			[("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass"):key()] = {"asval_smg","ak47_ass"},
			[("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870"):key()] = {"saiga"},
			-- LIGHT FBI GREEN
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"):key()] = {"ak47_ass","m4","sg417"},
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"):key()] = {"r870","asval_smg"},
			-- HEAVY FBI GREEN + HEAVY GENSEC GREY
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"):key()] = {"g36", "rpk_lmg", "scar_murky","s552"},
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870"):key()] = {"r870","benelli","r870","benelli","mossberg"},
			-- LIGHT GENSEC GREY
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass/ene_akan_fbi_swat_dw_ak47_ass"):key()] = {"g36","raging_bull","benelli","mp5_tactical"},
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870/ene_akan_fbi_swat_dw_r870"):key()] = {"sr2_smg","akmsu_smg","r870","mossberg"},
			-- FBI SUITS
			[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"):key()] = {"raging_bull","mp5"},
			-- HRT'S
			[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"):key()] = {"beretta92","asval_smg"},
			-- MEDIC
			[("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass"):key()] = {"asval_smg","ump","mp5_tactical"},
			[("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870"):key()] = {"r870","mossberg"},
			-- GREEN DOZER
			[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"):key()] = {"r870","sko12_conc","ak47"},
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
			[("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"):key()] = {"r870","ump","mp9"},
			[("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4"):key()] = {"ump","g36","benelli","raging_bull"},
			-- LIGHT BLUE SWAT
			[("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"):key()] = {"m4","mp5"},
			[("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2"):key()] = {"saiga"},
			-- HEAVY BLUE SWAT
			[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"):key()] = {"mp5_tactical","m4"},
			[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"):key()] = {"saiga"},
			-- LIGHT FBI GREEN - used as LIGHT GENSEC GREY squads as well
			[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"):key()] = {"s552","m4_yellow","scar_murky","g36","raging_bull"},
			[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"):key()] = {"r870","mp5_tactical","g36","benelli","raging_bull","mossberg"},
			-- HEAVY FBI GREEN - used as HEAVY GENSEC GREY squads as well
			[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1"):key()] = {"sg417","scar_murky","m249","g36"},
			[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870"):key()] = {"benelli","r870","r870","benelli","mossberg"},
			-- FBI SUITS
			[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"):key()] = {"raging_bull","mp5"},
			[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"):key()] = {"raging_bull","mp5"},
			-- HRT'S
			[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3"):key()] = {"beretta92","asval_smg"},
			-- MEDIC
			[("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"):key()] = {"m4","ump","mp5_tactical"},
			[("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870"):key()] = {"r870","mossberg"},
			-- GREEN DOZER
			[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"):key()] = {"r870","sko12_conc","ak47"},
			-- CLOAKER
			[("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1"):key()] = {"beretta92","mp5_tactical"},
			-- SHIELDS
			[("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1"):key()] = {"mac11","mp9","akmsu_smg"},
			[("units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2"):key()] = {"raging_bull"},
			
			
			------ MURKYWATER ------
			
			-- BEAT COPS
			-- same as american
			-- LIGHT BLUE SWAT + LIGHT FBI GREEN riflemen
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"):key()] = {"m4_yellow","mp5","scar_murky","s552","m4"},
			-- LIGHT BLUE SWAT shotgunner
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"):key()] = {"saiga"},
			-- LIGHT FBI GREEN shotgunner
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870"):key()] = {"r870", "mp5_tactical"},
			-- LIGHT GENSEC GREY
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city"):key()] = {"g36","raging_bull","r870","mac11"},
			[("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870"):key()] = {"ump","sr2_smg","benelli","mossberg"},
			-- HEAVY BLUE SWAT + HEAVY FBI GREEN + HEAVY GENSEC GREY riflemen
			[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36"):key()] = {"g36","scar_murky","sg417","m249","mac11","m4"},
			-- HEAVY BLUE SWAT r870 + HEAVY FBI GREEN r870 + HEAVY GENSEC GREY r870
			[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun"):key()] = {"saiga","r870","benelli","saiga","r870","benelli","mossberg"},
			-- FBI SUITS
			-- same as american
			-- HRT'S
			-- same as american
			-- MEDIC
			[("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"):key()] = {"m4","ump","mp5_tactical"},
			[("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870"):key()] = {"r870"},
			-- GREEN DOZER
			[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"):key()] = {"r870","sko12_conc","ak47"},
			-- CLOAKER
			[("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker"):key()] = {"deagle"},
			-- SHIELDS
			[("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield"):key()] = {"mp9","raging_bull","akmsu_smg"},
			
			
			------ FEDERALES ------
			
			-- BEAT COPS
			[("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"):key()] = {"c45","raging_bull"},
			[("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"):key()] = {"r870","ump"},
			-- LIGHT BLUE SWAT
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36"):key()] = {"akmsu_smg","m4"},
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870"):key()] = {"saiga"},
			-- HEAVY BLUE SWAT
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"):key()] = {"ump","m4_yellow"},
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870"):key()] = {"saiga"},
			-- LIGHT FBI GREEN
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"):key()] = {"sg417","m4","scar_murky"},
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"):key()] = {"r870", "asval_smg"},
			-- HEAVY FBI GREEN
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"):key()] = {"s552","scar_murky"},
			-- includes HEAVY GENSEC GREY r870
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"):key()] = {"r870", "benelli","r870","benelli","mossberg"},
			-- LIGHT GENSEC GREY
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"):key()] = {"g36","raging_bull","sr2_smg"},
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale"):key()] = {"benelli","mp5","akmsu_smg"},
			[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"):key()] = {"r870","mossberg"},
			-- HEAVY GENSEC GREY
			[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36"):key()] = {"ak47_ass","rpk_lmg"},
			-- FBI SUITS
			[("units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"):key()] = {"raging_bull","beretta92"},
			[("units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02"):key()] = {"raging_bull","beretta92"},
			-- HRT'S
			[("units/pd2_dlc_bex/characters/ene_bex_security_suit_03/ene_bex_security_suit_03"):key()] = {"asval_smg"},
			-- MEDIC
			[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale"):key()] = {"m4","ump","asval_smg"},
			[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870"):key()] = {"mossberg"},
			-- GREEN DOZER
			[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"):key()] = {"r870","sko12_conc","ak47"},
			-- CLOAKER
			[("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale"):key()] = {"mp5"},
			-- SHIELDS
			[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9"):key()] = {"mac11","akmsu_smg"}, -- grey+green
			[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45"):key()] = {"raging_bull"},
			
			-- The freak
			[("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"):key()] = {"saiga"}
		}
		
		if DWP.settings_config.difficulty >= 2 then
			-- remove m4's
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = {"mp5"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = {"s552","scar_murky"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"):key()] = {"ak47_ass","sg417"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"):key()] = {"s552","scar_murky","g36","raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"):key()] = {"mp5"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"):key()] = {"mp5_tactical","m4"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"):key()] = {"sg417","scar_murky"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36"):key()] = {"akmsu_smg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"):key()] = {"ump"}
			-- removed the rifle from green dozers to increase annoying stun shotgun chances
			local green_dozer = {"r870","sko12_conc"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = green_dozer
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"):key()] = green_dozer
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"):key()] = green_dozer
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"):key()] = green_dozer
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"):key()] = green_dozer
			-- The freak
			DWP.cop_weapon_mapping[("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"):key()] = {"saiga","m249"}
		end
		if DWP.settings_config.difficulty >= 3 then
			-- more high dps weapons
			-- US
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_cop_1/ene_cop_1"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_cop_2/ene_cop_2"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_cop_3/ene_cop_3"):key()] = {"saiga"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_cop_4/ene_cop_4"):key()] = {"saiga"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"):key()] = {"saiga"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"):key()] = {"saiga"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = {"s552"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_swat_2/ene_swat_2"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = {"s552"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = {"s552","g36"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = {"r870", "s552"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = {"ak47_ass"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = {"benelli","mossberg","m249"}
			local grey_light = {"g36","raging_bull","benelli","mossberg"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"):key()] = grey_light
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"):key()] = grey_light
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"):key()] = grey_light
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"):key()] = grey_light
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = {"m249","benelli","mossberg"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_1/ene_fbi_1"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_2/ene_fbi_2"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_3/ene_fbi_3"):key()] = {"asval_smg"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = {"g36"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_medic_r870/ene_medic_r870"):key()] = {"mossberg"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_shield_1/ene_shield_1"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_shield_2/ene_shield_2"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_city_shield/ene_city_shield"):key()] = {"raging_bull"}
			-- RUS
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"):key()] = {"saiga"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass"):key()] = {"ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass"):key()] = {"ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"):key()] = {"ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"):key()] = {"g36", "rpk_lmg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870"):key()] = {"mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"):key()] = {"asval_smg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass"):key()] = {"ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870"):key()] = {"mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg"):key()] = {"raging_bull"}
			-- ZOMB
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"):key()] = {"saiga"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4"):key()] = {"saiga"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"):key()] = {"s552","g36"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"):key()] = {"ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"):key()] = {"g36","benelli","mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1"):key()] = {"g36","m249"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3"):key()] = {"asval_smg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"):key()] = {"g36"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870"):key()] = {"benelli","mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2"):key()] = {"raging_bull"}
			-- MURK
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"):key()] = {"r870","g36"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun"):key()] = {"r870","benelli","mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city"):key()] = {"g36","g36","mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870"):key()] = {"g36","mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36"):key()] = {"g36","scar_murky","m249"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"):key()] = {"g36"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870"):key()] = {"mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker"):key()] = {"r870","deagle"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield"):key()] = {"raging_bull"}
			-- MEX
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"):key()] = {"saiga"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36"):key()] = {"g36"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"):key()] = {"s552","ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"):key()] = {"r870","ak47"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"):key()] = {"ak47_ass","g36"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"):key()] = {"r870", "benelli","mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"):key()] = {"g36"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale"):key()] = {"ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"):key()] = {"r870","mossberg","rpk_lmg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36"):key()] = {"m249","ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_bex_security_suit_01/ene_bex_security_suit_01"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_bex_security_suit_02/ene_bex_security_suit_02"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale"):key()] = {"ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870"):key()] = {"mossberg"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9"):key()] = {"raging_bull"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45"):key()] = {"raging_bull"}
			-- The freak
			DWP.cop_weapon_mapping[("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"):key()] = {"mini","m249"}
		end
		if DWP.settings_config.difficulty == 4 then
			-- replace weaker counterparts with lmgs and miniguns lmao
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = {"m249"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = {"g36"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = {"mini"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"):key()] = {"m249"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"):key()] = {"mini"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"):key()] = {"mini"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"):key()] = {"rpk_lmg","r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36"):key()] = {"m249","g36"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun"):key()] = {"mini"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker"):key()] = {"r870"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_g36/ene_swat_heavy_policia_federale_g36"):key()] = {"rpk_lmg","ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"):key()] = {"m249","ak47_ass"}
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"):key()] = {"mini","mossberg","rpk_lmg"}
			-- green dozer now only has the concus shotgun to make him even more annoying, even though dps is lower
			local green_dozer = {"sko12_conc"}
			DWP.cop_weapon_mapping[("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = green_dozer
			DWP.cop_weapon_mapping[("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"):key()] = green_dozer
			DWP.cop_weapon_mapping[("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"):key()] = green_dozer
			DWP.cop_weapon_mapping[("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"):key()] = green_dozer
			DWP.cop_weapon_mapping[("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"):key()] = green_dozer
			-- The freak
			DWP.cop_weapon_mapping[("units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"):key()] = {"mini"}
		end
	end
	
	local weapon_swap = DWP.cop_weapon_mapping[self._unit:name():key()]
	if weapon_swap then
		self._default_weapon_id = type(weapon_swap) == "table" and table.random(weapon_swap) or weapon_swap
	end
end)