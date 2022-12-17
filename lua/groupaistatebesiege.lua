-- make all enemy squad spawns faster but keep dozer and cloakers at a normal rate
if DWP.DWdifficultycheck == true then
	
	Hooks:PostHook(GroupAIStateBesiege, "init", "DWP_spawngroups", function(self)
		self._MAX_SIMULTANEOUS_SPAWNS = 4
		if DWP.settings.hostagesbeta == true and DWP.settings.xmas_chaos == false then
			--self._special_unit_types.tank_mini = true
			--self._special_unit_types.tank_medic = true
			self._special_unit_types.tank_hw = true
		end
	end)

	function DWP.grouptypecheck(group)
		local limittypes = {
			"FBI_tanks",
			"FBI_spoocs",
			"single_spooc"
		}
		for i=1,#limittypes do
			if group.type == limittypes[i] then
				return true
			end
			return false
		end
	end

	Hooks:PostHook(GroupAIStateBesiege, "_upd_assault_task", "DWP_updassault", function(self, ...)
	local active_hostages_mul = 1
	local killed_hostages_mul = 1
	if DWP.settings.hostagesbeta == true and DWP.settings.xmas_chaos == false and self._hostage_headcount >= 3 then
		active_hostages_mul = 1.2
	end
	if DWP.settings.hostagesbeta == true and DWP.settings.xmas_chaos == false and self._hostage_headcount >= 6 then
		active_hostages_mul = 1.4
	end
	if DWP.settings.hostagesbeta == true and DWP.settings.xmas_chaos == false and DWP.HostageControl.globalkillcount and DWP.HostageControl.globalkillcount >= 3 then
		killed_hostages_mul = 0.75
	end
	if DWP.settings.hostagesbeta == true and DWP.settings.xmas_chaos == false and DWP.HostageControl.globalkillcount and DWP.HostageControl.globalkillcount >= 5 then
		killed_hostages_mul = 0.5
	end
		if self._spawning_groups and #self._spawning_groups >= 1 then
			for i=1, #self._spawning_groups do
				for _, sp in ipairs(self._spawning_groups[i].spawn_group.spawn_pts) do
					if DWP.grouptypecheck(self._spawning_groups[i].group) == false then
						if sp.interval then
							sp.interval = DWP.settings.respawns * killed_hostages_mul * active_hostages_mul
						end
					else
						if sp.interval then
							sp.interval = DWP.settings.respawns * 2 * killed_hostages_mul * active_hostages_mul
						end
					end
					-- test for 2.3.1
					if sp.delay_t then
						local newdelay = (4 / DWP.settings.respawns) * 7.5
						--log("BEFORE: "..tostring(sp.delay_t))
						sp.delay_t = sp.delay_t - newdelay
						--log("AFTER: "..tostring(sp.delay_t))
					end
				end
			end
		end
	end )
	
	function GroupAIStateBesiege:_get_special_unit_type_count(special_type)
		
		if not self._special_units[special_type] then
			return 0
		end
		
		if special_type == "tank" then
			local tanks = table.size(self._special_units[special_type])

			if self._special_units["tank_mini"] then
				tanks = tanks + table.size(self._special_units["tank_mini"])
			end

			if self._special_units["tank_medic"] then
				tanks = tanks + table.size(self._special_units["tank_medic"])
			end
			
			if self._special_units["tank_hw"] then
				tanks = tanks + table.size(self._special_units["tank_hw"])
			end

			return tanks
		else
			return table.size(self._special_units[special_type])
		end
	end
	
	function DWP.CloakerReinforce(killer_id)
		-- put delayedcall on top so killing 5 hostages in stealth doesnt disable cloaker respawns
		local next_spawn_min = 40
		local next_spawn_max = 120
		
		if DWP.HostageControl.globalkillcount >= 7 then
			next_spawn_min = 25
			next_spawn_max = 75
		end
		
		DelayedCalls:Add("DWP_respawn_cloaker", math.random(next_spawn_min,next_spawn_max) , function()
			DWP.CloakerReinforce()
		end)
		
		-- Stealth phase check
		if managers.groupai:state():whisper_mode() then
			return
		end
		
		-- TODO: refactor this mess to be a bit more readable
		local player_1_weight = 25
		local player_2_weight = 25
		local player_3_weight = 25
		local player_4_weight = 25
		local subtractor = 0
		
		-- player 1 adjusts everyone including himself
		if DWP.HostageControl.PeerHostageKillCount[1] > 0 then
			player_1_weight = player_1_weight + DWP.HostageControl.PeerHostageKillCount[1]
			subtractor = DWP.HostageControl.PeerHostageKillCount[1] / 3
			player_2_weight = player_2_weight - subtractor
			player_3_weight = player_3_weight - subtractor
			player_4_weight = player_4_weight - subtractor
		end
		-- player 2 adjusts everyone including himself
		if DWP.HostageControl.PeerHostageKillCount[2] > 0 then
			player_2_weight = player_2_weight + DWP.HostageControl.PeerHostageKillCount[2]
			subtractor = DWP.HostageControl.PeerHostageKillCount[2] / 3
			player_1_weight = player_1_weight - subtractor
			player_3_weight = player_3_weight - subtractor
			player_4_weight = player_4_weight - subtractor
		end
		-- player 3 adjusts everyone including himself
		if DWP.HostageControl.PeerHostageKillCount[3] > 0 then
			player_3_weight = player_3_weight + DWP.HostageControl.PeerHostageKillCount[3]
			subtractor = DWP.HostageControl.PeerHostageKillCount[3] / 3
			player_2_weight = player_2_weight - subtractor
			player_1_weight = player_1_weight - subtractor
			player_4_weight = player_4_weight - subtractor
		end
		-- player 4 adjusts everyone including himself
		if DWP.HostageControl.PeerHostageKillCount[4] > 0 then
			player_4_weight = player_4_weight + DWP.HostageControl.PeerHostageKillCount[4]
			subtractor = DWP.HostageControl.PeerHostageKillCount[4] / 3
			player_2_weight = player_2_weight - subtractor
			player_3_weight = player_3_weight - subtractor
			player_1_weight = player_1_weight - subtractor
		end
		
		-- change weights into percentages, with their values beeing the last value they can take
		-- for example: if value for 1 is 20, for 2 is 30, for 3 is 20 and for 4 is 30,
		-- they will result in 1 = 0.2; 2 = 0.5; 3 = 0.7; and 4 = 1
		-- then we can use math.random to roll a number from 0 to 1 and decide the target
		player_1_weight = player_1_weight / 100
		player_2_weight = player_1_weight + (player_2_weight / 100)
		player_3_weight = player_2_weight + (player_3_weight / 100)
		player_4_weight = player_3_weight + (player_4_weight / 100)
			
		-- decide which player cloaker will spawn on
		local spawntarget_id = 1
		local winner = math.random()
		if winner <= player_1_weight then
			spawntarget_id = 1
		elseif winner <= player_2_weight then
			spawntarget_id = 2
		elseif winner <= player_3_weight then
			spawntarget_id = 3
		elseif winner <= player_4_weight then
			spawntarget_id = 4
		end
		
		-- on first call for this function we spawn cloaker on whoever killed the 5th hostage if possible, later it's random with higher priorities towards hostage killers
		if killer_id then
			spawntarget_id = killer_id
		end
		
		local posi = Vector3(0,0,0)
		local peer = ""
		local unit = ""
		
		if spawntarget_id == 1 then
			if managers.player:player_unit() and managers.player:player_unit():position() then -- make sure host ain't dead or inaccessible
				mvector3.set(posi,managers.player:player_unit():position())
			end
		else
			if managers.network:session():peer(spawntarget_id) then
				peer = managers.network:session():peer(spawntarget_id)
			else
				peer = nil
			end
		end
		
		local rot = Rotation(180 - (360 / 10) * 1, 0, 0)
		if spawntarget_id ~= 1 and peer then
			unit = peer and peer:unit() or nil
			if not (unit and alive(unit)) then
				return
			end
			mvector3.set(posi,unit:position())
			World:spawn_unit(Idstring("units/payday2/characters/ene_spook_1/ene_spook_1"), posi, rot)
		elseif spawntarget_id == 1 and managers.player:player_unit() and managers.player:player_unit():position() then -- make sure host ain't dead or inaccessible
			World:spawn_unit(Idstring("units/payday2/characters/ene_spook_1/ene_spook_1"), posi, rot)
		end
	end
end