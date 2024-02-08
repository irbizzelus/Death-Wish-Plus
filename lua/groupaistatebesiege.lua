if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- respawn rate adjustments and hostage control mechanic stuff
Hooks:PostHook(GroupAIStateBesiege, "init", "DWP_spawngroups", function(self)
	if not DWP.DWdifficultycheck then
		return
	end
	self._MAX_SIMULTANEOUS_SPAWNS = 4
	-- add headless dozers to the tank limit so they dont spawn indefinetly
	if DWP.settings_config and DWP.settings_config.hostage_control then
		self._special_unit_types.tank_hw = true
	elseif not DWP.settings_config and DWP.settings.hostage_control then
		self._special_unit_types.tank_hw = true
	end
end)

Hooks:PostHook(GroupAIStateBesiege, "_upd_assault_task", "DWP_updassault", function(self, ...)
	if not DWP.DWdifficultycheck then
		return
	end

	-- respawn rate multipliers
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
		delay = 1.75
	elseif DWP.settings_config.difficulty == 4 then
		delay = 0.25
	end
	
	if self._spawning_groups and #self._spawning_groups >= 1 then
		for i=1, #self._spawning_groups do
			for _, sp in ipairs(self._spawning_groups[i].spawn_group.spawn_pts) do
				if sp.interval then
					-- because of the way this is calculated and invididual hostage multipliers above, killing hostages will always outweight kept hostages if #killed=#kept
					sp.interval = delay * active_hostages_mul * killed_hostages_mul
				end
				if sp.delay_t then
					sp.delay_t = sp.delay_t - (DWP.settings_config.difficulty * 7.5)
				end
			end
		end
	end
end)

-- add headless dozers to tank special limits
function GroupAIStateBesiege:_get_special_unit_type_count(special_type)
	
	if not self._special_units[special_type] then
		return 0
	end
	
	if special_type == "tank" and DWP.DWdifficultycheck then
		local tanks = table.size(self._special_units[special_type])
		if self._special_units["tank_hw"] then
			tanks = tanks + table.size(self._special_units["tank_hw"])
		end
		return tanks
	else
		return table.size(self._special_units[special_type])
	end
end

-- cloaker suprise after 6 civi kills from hostage control
function DWP.CloakerReinforce(killer_id)

	if not DWP.DWdifficultycheck then
		return
	end
	
	local next_spawn_min = 50
	local next_spawn_max = 130
	
	if DWP.HostageControl.globalkillcount >= 9 then
		next_spawn_min = 30
		next_spawn_max = 80
	end
	
	-- put delayedcall on top so killing 6 hostages in stealth doesnt disable cloaker respawns, it will just loop untill stealth is broken
	DelayedCalls:Add("DWP_respawn_cloaker", math.random(next_spawn_min,next_spawn_max) , function()
		DWP.CloakerReinforce()
	end)
	
	-- Stealth phase check
	if managers.groupai:state():whisper_mode() then
		return
	end
	
	-- Decide who gets the lucky cloaker spawn on top of them. More civi kills = higher the chance
	local single_kill_chance = 0.6 / DWP.HostageControl.globalkillcount
	local peer_kills = DWP.HostageControl.PeerHostageKillCount
	
	local player_1_chance = 0.1 + (single_kill_chance * peer_kills[1])
	local player_2_chance = 0.1 + (single_kill_chance * peer_kills[2])
	local player_3_chance = 0.1 + (single_kill_chance * peer_kills[3])
	local player_4_chance = 0.1 + (single_kill_chance * peer_kills[4])
	
	local player_1_range = {0,player_1_chance}
	local player_2_range = {player_1_chance, player_1_chance + player_2_chance}
	local player_3_range = {player_2_range[2], player_2_range[2] + player_3_chance}
	local player_4_range = {player_3_range[2], 1}
	
	-- decide which player cloaker will spawn on
	local spawntarget_id = 1
	
	-- decide the winner for cloaker spawn, can call itself in case winner is dead/somehow else unavailable
	local function roll_the_dice()
		local winner = math.random()
		
		if winner <= player_1_range[2] then
			spawntarget_id = 1
		elseif winner <= player_2_range[2] then
			spawntarget_id = 2
		elseif winner <= player_3_range[2] then
			spawntarget_id = 3
		elseif winner <= player_4_range[2] then
			spawntarget_id = 4
		end
		
		-- on first call for this function we spawn cloaker on whoever killed the 5th hostage if possible, later it's random with higher priorities towards hostage killers
		if killer_id then
			spawntarget_id = killer_id
			killer_id = nil
		end
		
		if spawntarget_id == 1 and not (managers.player:player_unit() and managers.player:player_unit():position()) then
			roll_the_dice()
		else
			local peer = managers.network:session():peer(spawntarget_id)
			local unit = peer and peer:unit() or nil
			if not (unit and alive(unit)) then
				roll_the_dice()
			end
		end
	end
	roll_the_dice()
	
	local posi = Vector3(0,0,0)
	local rot = Rotation(180 - (360 / 10) * 1, 0, 0)
	local peer = ""
	local unit = ""
	
	-- update our cloaker look depending on the current map
	local cloaker = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
	if tweak_data.levels[Global.level_data.level_id].ai_group_type == "russia" then
		cloaker = Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg")
	elseif tweak_data.levels[Global.level_data.level_id].ai_group_type == "zombie" then
		cloaker = Idstring("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1")
	elseif tweak_data.levels[Global.level_data.level_id].ai_group_type == "murkywater" then
		cloaker = Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker")
	elseif tweak_data.levels[Global.level_data.level_id].ai_group_type == "federales" then
		cloaker = Idstring("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale")
	end
	
	if spawntarget_id == 1 then
		if managers.player:player_unit() and managers.player:player_unit():position() then
			mvector3.set(posi,managers.player:player_unit():position())
			World:spawn_unit(cloaker, posi, rot)
		end
	else
		if managers.network:session():peer(spawntarget_id) then
			peer = managers.network:session():peer(spawntarget_id)
			unit = peer and peer:unit() or nil
			if not (unit and alive(unit)) then
				return
			end
			mvector3.set(posi,unit:position())
			World:spawn_unit(cloaker, posi, rot)
		end
	end
end