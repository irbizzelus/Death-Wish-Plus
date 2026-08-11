Hooks:PostHook(CharacterTweakData, "_set_overkill_290", "DWP_reduce_ECM_bullshit", function(self)
	
	if not Network:is_server() then
		return
	end
	
	local enemies = {
		"tank",
		"tank_medic",
		"tank_mini",
		"tank_hw",
		"swat",
		"fbi_swat",
		"city_swat",
		"zeal_swat",
		"heavy_swat",
		"heavy_swat_sniper",
		"fbi_heavy_swat",
		"zeal_heavy_swat",
		"shield",
		"spooc",
		"sniper",
		"taser",
		"medic",
		"marshal_marksman",
		"marshal_shield",
		"marshal_shield_break",
		"phalanx_minion",
		"phalanx_vip"
	}
	
	for i=1, #enemies do
		local enemy = self[tostring(enemies[i])]
		if enemy and enemy.ecm_vulnerability then
			enemy.ecm_vulnerability = DWP.settings.ecm_feedback_chance
			if enemy.ecm_hurts and enemy.ecm_hurts.ears then
				enemy.ecm_hurts.ears = enemy.ecm_hurts.ears * 0.5
				if enemy.ecm_hurts.ears > 0 and enemy.ecm_hurts.ears < 2 then
					enemy.ecm_hurts.ears = 2
				end
			end
		end
	end
	
end)