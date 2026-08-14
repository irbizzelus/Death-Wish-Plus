if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- respawn rate adjustments and hostage control mechanic stuff
Hooks:PostHook(GroupAIStateBesiege, "init", "DWP_spawngroups", function(self)
	if not DWP.DWdifficultycheck then
		return
	end
	local diff = DWP.settings.difficulty or 1
	if DWP.settings_config and DWP.settings_config.difficulty then
		diff = DWP.settings_config.difficulty
	end
	local spn_on_diff = {
		[1] = 3,
		[2] = 4,
		[3] = 5,
		[4] = 6,
	}
	self._MAX_SIMULTANEOUS_SPAWNS = spn_on_diff[diff]
	if (DWP.settings_config and DWP.settings_config.hostage_control) or DWP.settings.hostage_control then
		self._special_unit_types.tank_hw = true -- add headless dozers to the tank limit so they dont spawn indefinetly
	end
end)

-- global enemy respawn speed
local dwp_orig_besiege_queue_police_upd_task = GroupAIStateBesiege._queue_police_upd_task
Hooks:OverrideFunction(GroupAIStateBesiege, "_queue_police_upd_task", function (self)
	
	if not (Network:is_server() and DWP and DWP.DWdifficultycheck and DWP.settings_config) then
		dwp_orig_besiege_queue_police_upd_task(self)
		return
	end
	
	if self._police_upd_task_queued then
		if self._t < self._police_upd_task_queued then
			return
		end

		self:_upd_police_activity()
	end
	
	-- respawn rate multipliers
	local hostage_count = self._police_hostage_headcount + self._hostage_headcount
	local diff_muls = {
		[1] = 0.95,
		[2] = 0.9,
		[3] = 0.79,
		[4] = 0.65,
	}
	local update_mul = diff_muls[DWP.settings_config.difficulty] or 1
	
	-- hostage control setting bonuses and penalties
	if DWP.settings_config.hostage_control then
		if hostage_count >= 1 then
			update_mul = update_mul + (math.clamp(hostage_count, 1, 8) * 0.0525)
		end
		if DWP.HostageControl.globalkillcount >= 1 then
			update_mul = update_mul - (math.clamp(DWP.HostageControl.globalkillcount, 1, 8) * 0.0375)
		end
	end

	local next_upd_t = next(self._spawning_groups) and GroupAIStateBesiege._POLICE_ACTIVITY_DELAY_FAST or GroupAIStateBesiege._POLICE_ACTIVITY_DELAY

	self._police_upd_task_queued = self._t + (next_upd_t * update_mul)
end)

Hooks:PostHook(GroupAIStateBesiege, "_upd_assault_task", "DWP_updassault", function(self, ...)
	if not DWP.DWdifficultycheck then
		return
	end
	
	-- check tweak data surrender values, and update them if they dont match what we want. still got no clue why it sometimes resets, so just check for it ingame
	if DWP.settings_config and DWP.settings_config.difficulty then
		if tweak_data.character.heavy_swat.surrender.base_chance ~= DWP.IntimidationStats[DWP.settings_config.difficulty].heavies.base then
			DWP:update_dom_values(DWP.settings_config.difficulty)
		end
	end

	-- respawn point availability rate multipliers
	local active_hostages_mul = 1
	local killed_hostages_mul = 1
	local hostage_count = self._police_hostage_headcount + self._hostage_headcount
	local delay = 4
	
	if DWP.settings_config.hostage_control then
		-- alive hostages
		if hostage_count >= 1 then
			active_hostages_mul = active_hostages_mul + (math.clamp(hostage_count, 1, 8) * 0.07)
		end
		-- dead hostages
		if DWP.HostageControl.globalkillcount >= 1 then
			killed_hostages_mul = killed_hostages_mul - (math.clamp(DWP.HostageControl.globalkillcount, 1, 8) * 0.05)
		end
		-- update force value every assault task update, to make sure that HC bonuses/penalties for #cops on the map at the same time work
		-- in vanilla this value only gets updated once before assault begins
		self._task_data.assault.force = math.ceil(self:_get_difficulty_dependent_value(self._tweak_data.assault.force) * self:_get_balancing_multiplier(self._tweak_data.assault.force_balance_mul))
	end
	
	if DWP.settings_config.difficulty == 2 then
		delay = 3
	elseif DWP.settings_config.difficulty == 3 then
		delay = 1.5
	elseif DWP.settings_config.difficulty == 4 then
		delay = 0.25
	end
	
	-- update delays before spawn points could be used again
	if self._spawning_groups and #self._spawning_groups >= 1 then
		for i=1, #self._spawning_groups do
			for _, sp in ipairs(self._spawning_groups[i].spawn_group.spawn_pts) do
				if self._assault_number then
					if Global.level_data and Global.level_data.level_id == "nmh" and self._assault_number <= 2 then
						if self._task_data.assault.phase == "anticipation" then
							if sp.interval then
								sp.interval = 0
							end
							if sp.delay_t then
								sp.delay_t = 0
							end
						end
					else
						if self._hunt_mode then -- make cpt. Winters and scripted endless assaults more painful
							if sp.interval and sp.interval > 1 then
								sp.interval = delay * active_hostages_mul * killed_hostages_mul * 0.25
							end
						elseif not self._task_data.assault.phase or self._task_data.assault.phase == "fade" then -- disable spawns during fade and pre-anticipation nil phases
							if sp.interval and sp.interval < 10 then
								sp.interval = 10
							end
							if sp.delay_t then
								sp.delay_t = sp.delay_t + 20
							end
						elseif self._task_data.assault.phase == "anticipation" then -- spawn as much stuff as we can during anticipation
							if sp.interval and sp.interval > 1 then
								sp.interval = 0.5
							end
							if sp.delay_t then
								sp.delay_t = 0
							end
						else -- otherwise use standard delay calculations
							if sp.interval then
								-- because of the way this is calculated and invididual hostage multipliers above, killing hostages will always outweight kept hostages if #killed=#kept
								sp.interval = delay * active_hostages_mul * killed_hostages_mul
							end
						end
					end
				end
			end
		end
	end
end)

-- add headless dozers to tank special limits
local dwp_orig_get_special_unit_type_count = GroupAIStateBesiege._get_special_unit_type_count
Hooks:OverrideFunction(GroupAIStateBesiege, "_get_special_unit_type_count", function (self, special_type)
	if not self._special_units[special_type] then
		return 0
	end
	if special_type == "tank" and DWP and DWP.DWdifficultycheck then
		local tanks = table.size(self._special_units[special_type])
		if self._special_units["tank_hw"] then
			tanks = tanks + table.size(self._special_units["tank_hw"])
		end
		return tanks
	else
		return dwp_orig_get_special_unit_type_count(self, special_type)
	end
end)

-- cpt winters endless wave prevention
Hooks:PostHook(GroupAIStateBesiege, "_upd_police_activity", "DWP_upd_police_activity_post", function(self)
	
	-- should this check even exist? last time i checked he can break on any difficulty
	if not (DWP and DWP.DWdifficultycheck) then
		return
	end
	
	if self._phalanx_spawn_group and self._phalanx_spawn_group.has_spawned then
		local phalanx_vip = self:phalanx_vip()
		if phalanx_vip and alive(phalanx_vip) then
			self._winters_might_have_dissapeared_at = nil
			local dist = mvector3.distance(phalanx_vip:position(), self._phalanx_center_pos)
			if dist < 500 then
				local phalanx_minion_count = managers.groupai:state():get_phalanx_minion_count()
				local min_count_minions = tweak_data.group_ai.phalanx.minions.min_count
				if not (type(phalanx_minion_count) == "number" and phalanx_minion_count > min_count_minions) then
					managers.groupai:state():unregister_phalanx_vip()
					managers.groupai:state():set_assault_endless(false)
				end
			end
		else
			-- for some reason self:phalanx_vip() does not report on winter's unit untill he gets close enough to his objective, so we make manual scans instead
			local winters_found = false
			for u_key, u_data in pairs(managers.enemy:all_enemies()) do
				local unit = u_data.unit
				if unit and alive(unit) and unit:base() and unit:base():char_tweak() and unit:base():char_tweak().tags and table.contains(unit:base():char_tweak().tags, "phalanx_vip") then
					winters_found = true
				end
			end
			if not winters_found then
				if not self._winters_might_have_dissapeared_at then
					self._winters_might_have_dissapeared_at = Application:time()
				end
				if Application:time() - self._winters_might_have_dissapeared_at > 60 then
					log("[DW+] Force ended cpt. Winters' endless assault, because his unit was not detected during the \"_upd_police_activity\" function update.")
					managers.groupai:state():unregister_phalanx_vip()
					managers.groupai:state():set_assault_endless(false)
					self._winters_might_have_dissapeared_at = nil
				end
			end
		end
	else
		self._winters_might_have_dissapeared_at = nil
	end
end)

-- prevent cap spawn for the first x seconds of an assault
local dwp_orig_besiege_phalanx_spawn = GroupAIStateBesiege._spawn_phalanx
Hooks:OverrideFunction(GroupAIStateBesiege, "_spawn_phalanx", function (self)
	if DWP and DWP.DWdifficultycheck then
		if self._task_data and self._task_data.assault and ((self._task_data.assault.phase == "sustain" and DWP.latest_assault_starting_time and (DWP.latest_assault_starting_time + 240) > Application:time()) or (self._task_data.assault.phase == "build")) then
			return
		end
		dwp_orig_besiege_phalanx_spawn(self)
	else
		dwp_orig_besiege_phalanx_spawn(self)
	end
end)