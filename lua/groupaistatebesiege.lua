if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- respawn rate adjustments and hostage control mechanic stuff
Hooks:PostHook(GroupAIStateBesiege, "init", "DWP_spawngroups", function(self)
	if not DWP.DWdifficultycheck then
		return
	end
	self._MAX_SIMULTANEOUS_SPAWNS = 3
	if DWP.settings_config and DWP.settings_config.difficulty then
		if DWP.settings_config.difficulty == 2 then
			self._MAX_SIMULTANEOUS_SPAWNS = 4
		elseif DWP.settings_config.difficulty == 3 then
			self._MAX_SIMULTANEOUS_SPAWNS = 5
		elseif DWP.settings_config.difficulty == 4 then
			self._MAX_SIMULTANEOUS_SPAWNS = 6
		end
	end
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
	
	-- check tweak data surrender values, and update them if they dont match what we want. still got no clue why it sometimes resets, so just check for it ingame
	if DWP.settings_config and DWP.settings_config.difficulty then
		local surr_val_to_check = 0.2
		if DWP.settings_config.difficulty == 2 or DWP.settings_config.difficulty == 3 then
			surr_val_to_check = 0.15
		elseif DWP.settings_config.difficulty == 4 then
			surr_val_to_check = 0.1
		end
		if tweak_data.character.heavy_swat.surrender.base_chance ~= surr_val_to_check then
			DWP:update_dom_values(DWP.settings_config.difficulty)
		end
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
		delay = 1.5
	elseif DWP.settings_config.difficulty == 4 then
		delay = 0.25
	end
	
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
	
	if DWP.HostageControl.globalkillcount >= 8 then
		next_spawn_min = 30
		next_spawn_max = 80
	end
	
	-- put delayedcall that resets this loop on top so killing 6 hostages in stealth doesnt disable cloaker respawns, it will just loop untill stealth is broken
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
	
	local spawntarget_id = 1
	
	-- decide the winner for cloaker spawn, can call itself in case winner is dead/somehow else unavailable
	local function roll_the_dice()
		
		local valid_players = {peer_1 = false,peer_2 = false,peer_3 = false,peer_4 = false}
		if managers.player:player_unit() and managers.player:player_unit():position() then
			valid_players.peer_1 = true
		end
		for i=2,4 do
			local peer = managers.network:session():peer(i)
			local unit = peer and peer:unit() or nil
			if (unit and alive(unit)) then
				valid_players["peer_"..tostring(i)] = true
			end
		end
		
		-- cancel this spawn if everyone is dead, loop continues tho
		if not valid_players.peer_1 and not valid_players.peer_2 and not valid_players.peer_3 and not valid_players.peer_4 then
			return
		end
		
		local winner = math.random()
		
		if winner <= player_4_range[2] and valid_players.peer_4 then
			spawntarget_id = 4
		end
		if winner <= player_3_range[2] and valid_players.peer_3 then
			spawntarget_id = 3
		end
		if winner <= player_2_range[2] and valid_players.peer_2 then
			spawntarget_id = 2
		end
		if winner <= player_1_range[2] and valid_players.peer_1 then
			spawntarget_id = 1
		end
		
		-- on first call for this function we spawn cloaker on whoever killed the 5th hostage if possible, later it's random with higher priorities towards hostage killers
		if killer_id then
			spawntarget_id = killer_id
			killer_id = nil
			
			-- failsafe in case our first target managed to somehow die at the same tick they triggered this func
			if not valid_players["peer_"..tostring(spawntarget_id)] then
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