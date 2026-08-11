local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance
local mvec3_dis_sq = mvector3.distance_sq
local tmp_vec1 = Vector3()

-- adjust enemy intimidation logic a bit, to make it a) make a bit more sense b) be as hard as intended
local dwp_orig_coplogicbase_evaluate_reason_to_surrender = CopLogicBase._evaluate_reason_to_surrender
Hooks:OverrideFunction(CopLogicBase, "_evaluate_reason_to_surrender", function (data, my_data, aggressor_unit)

	if not (Network:is_server() and DWP and DWP.DWdifficultycheck) then
		return dwp_orig_coplogicbase_evaluate_reason_to_surrender(data, my_data, aggressor_unit)
	end
	
	local surrender_tweak = data.char_tweak.surrender

	if not surrender_tweak then
		return
	end

	if surrender_tweak.base_chance >= 1 then
		return 0
	end

	local t = data.t

	if data.surrender_window and data.surrender_window.window_expire_t < t then
		data.unit:brain():on_surrender_chance()

		return
	end

	local hold_chance = 1
	local surrender_chk = {
		health = function (health_surrender)
			local health_ratio = data.unit:character_damage():health_ratio()

			if health_ratio < 1 then
				local min_setting, max_setting = nil

				for k, v in pairs(health_surrender) do
					if not min_setting or k < min_setting.k then
						min_setting = {
							k = k,
							v = v
						}
					end

					if not max_setting or max_setting.k < k then
						max_setting = {
							k = k,
							v = v
						}
					end
				end

				if health_ratio < max_setting.k then
					local health_ratio_multi = 1 - math.lerp(min_setting.v, max_setting.v, math.max(0, health_ratio - min_setting.k) / (max_setting.k - min_setting.k))
					hold_chance = hold_chance * health_ratio_multi
				end
			end
		end,
		aggressor_dis = function (agg_dis_surrender)
			local agg_dis = mvec3_dis(data.m_pos, aggressor_unit:movement():m_newest_pos())
			local min_setting, max_setting = nil

			for k, v in pairs(agg_dis_surrender) do
				if not min_setting or k < min_setting.k then
					min_setting = {
						k = k,
						v = v
					}
				end

				if not max_setting or max_setting.k < k then
					max_setting = {
						k = k,
						v = v
					}
				end
			end

			if agg_dis < max_setting.k then
				local aggro_distance_multi = 1 - math.lerp(min_setting.v, max_setting.v, math.max(0, agg_dis - min_setting.k) / (max_setting.k - min_setting.k))
				hold_chance = hold_chance * aggro_distance_multi
			end
		end,
		weapon_down = function (weap_down_surrender)
			local anim_data = data.unit:anim_data()

			if anim_data.reload then
				hold_chance = hold_chance * (1 - weap_down_surrender)
			elseif anim_data.hurt then
				hold_chance = hold_chance * (1 - weap_down_surrender)
			elseif data.unit:movement():stance_name() == "ntl" then
				hold_chance = hold_chance * (1 - weap_down_surrender)
			end

			local _, ammo = data.unit:inventory():equipped_unit():base():ammo_info()

			if ammo == 0 then
				hold_chance = hold_chance * (1 - weap_down_surrender)
			end
		end,
		flanked = function (flanked_surrender)
			local dis = mvec3_dir(tmp_vec1, data.m_pos, aggressor_unit:movement():m_newest_pos())

			if dis > 250 then
				local fwd_dot = mvec3_dot(data.unit:movement():m_fwd(), tmp_vec1)

				if fwd_dot < -0.5 then
					hold_chance = hold_chance * (1 - flanked_surrender)
				end
			end
		end,
		unaware_of_aggressor = function (unaware_of_aggressor_surrender)
			local att_info = data.detected_attention_objects[aggressor_unit:key()]

			if not att_info or not att_info.identified or t - att_info.identified_t < 1 then
				hold_chance = hold_chance * (1 - unaware_of_aggressor_surrender)
			end
		end,
		enemy_weap_cold = function (enemy_weap_cold_surrender)
			if not managers.groupai:state():enemy_weapons_hot() then
				hold_chance = hold_chance * (1 - enemy_weap_cold_surrender)
			end
		end,
		isolated = function (isolated_surrender)
			if data.group and data.group.has_spawned and data.group.initial_size > 1 then
				local has_support = nil
				local max_dis_sq = 722500

				for u_key, u_data in pairs(data.group.units) do
					if u_key ~= data.key and mvec3_dis_sq(data.m_pos, u_data.m_pos) < max_dis_sq then
						has_support = true

						break
					end

					if not has_support then
						hold_chance = hold_chance * (1 - isolated_surrender)
					end
				end
			end
		end,
		pants_down = function (pants_down_surrender)
			local not_cool_t = data.unit:movement():not_cool_t()

			if (not not_cool_t or t - not_cool_t < 1.5) and not managers.groupai:state():enemy_weapons_hot() then
				hold_chance = hold_chance * (1 - pants_down_surrender)
			end
		end
	}

	for reason, reason_data in pairs(surrender_tweak.reasons) do
		surrender_chk[reason](reason_data)
	end
	
	-- add base chance to the total, cause otherwise it's useless
	if surrender_tweak.base_chance > 0 and surrender_tweak.base_chance < 1 then
		hold_chance = hold_chance - surrender_tweak.base_chance
	end

	local significant_tipping = 1 - (surrender_tweak.significant_chance or 0)

	if hold_chance >= significant_tipping then
		return 1
	end

	for factor, factor_data in pairs(surrender_tweak.factors) do
		surrender_chk[factor](factor_data)
	end

	-- remove gradual increase to the chance when intimidating the same guy over and over again
	-- if data.surrender_window then
		-- local surrender_window_multi = 1 - data.surrender_window.chance_mul
		-- hold_chance = hold_chance * surrender_window_multi
	-- end

	if surrender_tweak.violence_timeout then
		local violence_t = data.unit:character_damage():last_suppression_t()

		if violence_t then
			local violence_dt = t - violence_t

			if violence_dt < surrender_tweak.violence_timeout then
				local violence_timeout_multi = 1 - violence_dt / surrender_tweak.violence_timeout
				hold_chance = hold_chance + (1 - hold_chance) * violence_timeout_multi
			end
		end
	end
	
	return hold_chance < 1 and hold_chance
end)

-- whenever bots start a revive, trigger cuffing logic
Hooks:PostHook(CopLogicBase, "add_delayed_clbk", "DWP_post_CopLogicBase_add_delayed_clbk", function(internal_data, id, clbk, exec_t)
	
	if not (DWP and DWP.DWdifficultycheck and Network:is_server()) then
		return
	end
	
	if id and string.sub(id, 1, 22) == "TeamAILogicIdle_revive" and exec_t and exec_t > (TimerManager:game():time() + 1.4) and internal_data.unit and alive(internal_data.unit) then
		local target_unit = nil
		for u_key, u_data in pairs(managers.groupai:state()._ai_criminals) do
			if u_data.unit == internal_data.unit then
				target_unit = u_data.unit
			end
		end
		if target_unit then
			DWP.CopUtils:SendCopToArrestPlayer(target_unit, "revive")
			DelayedCalls:Add("DWP_delay_for_cuff_scan_on_bot_"..tostring(target_unit), 1.5, function()
				DWP.CopUtils:NearbyCopAutoArrestCheck(target_unit, "bot")
			end)
		end
	end
end)

-- give field snipers lasers
Hooks:PostHook(CopLogicBase, "enter", "DWP_CopLogicBase_enter_post", function(data, new_logic_name, enter_params)
    
	if not (DWP and DWP.DWdifficultycheck and Network:is_server()) then
		return
	end
	
	local snipers = {
		[("units/payday2/characters/ene_sniper_1/ene_sniper_1"):key()] = true,
		[("units/payday2/characters/ene_sniper_2/ene_sniper_2"):key()] = true,
		[("units/pd2_dlc_mad/characters/ene_akan_cs_swat_sniper_svd_snp/ene_akan_cs_swat_sniper_svd_snp"):key()] = true,
		[("units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2"):key()] = true,
		[("units/pd2_dlc_bph/characters/ene_murkywater_sniper/ene_murkywater_sniper"):key()] = true,
		[("units/pd2_dlc_bex/characters/ene_swat_policia_sniper/ene_swat_policia_sniper"):key()] = true
	}
	
	if snipers[data.unit:name():key()] then
		if new_logic_name == "inactive" and data.dwp_laser then
			data.dwp_laser = false
			data.unit:inventory():equipped_unit():base():set_laser_enabled(false)
			managers.network:session():send_to_peers_synched("sync_unit_event_id_16", data.unit, "brain", HuskCopBrain._NET_EVENTS.weapon_laser_off)	
		else
			data.dwp_laser = true
			data.unit:inventory():equipped_unit():base():set_laser_enabled(true)
			managers.network:session():send_to_peers_synched("sync_unit_event_id_16", data.unit, "brain", HuskCopBrain._NET_EVENTS.weapon_laser_on)
		end
	end
	
end)