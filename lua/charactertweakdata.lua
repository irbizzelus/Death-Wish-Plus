Hooks:PostHook(CharacterTweakData, "_set_overkill_290", "DWP_remove_ECM_bullshit", function(self)
	
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
	
	if DWP.settings.ecm_feedback_mute and DWP.settings.ecm_feedback_mute >= 2 then
		for i=1, #enemies do
			if self[tostring(enemies[i])] and self[tostring(enemies[i])].ecm_vulnerability then
				if DWP.settings.ecm_feedback_mute == 2 then
					self[tostring(enemies[i])].ecm_vulnerability = 0.2 -- chance
					if self[tostring(enemies[i])].ecm_hurts and self[tostring(enemies[i])].ecm_hurts.ears then
						self[tostring(enemies[i])].ecm_hurts.ears = self[tostring(enemies[i])].ecm_hurts.ears * 0.33 -- stun duration
					end
				elseif DWP.settings.ecm_feedback_mute == 3 then
					self[tostring(enemies[i])].ecm_vulnerability = nil
					if self[tostring(enemies[i])].ecm_hurts and self[tostring(enemies[i])].ecm_hurts.ears then
						self[tostring(enemies[i])].ecm_hurts.ears = nil
					end
				end
			end
		end
	end
	
end)