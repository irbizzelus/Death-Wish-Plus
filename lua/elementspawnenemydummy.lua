-- fix a crash on alaska specifically (for some reason?) where the safe_spawn_unit function crashes the game with acces violation.
-- idk if its caused by invalid unit or spawn vector, cause it happens rarely and completely randomly, so made checks for both
local dwp_orig_ElementSpawnEnemyDummy_produce = ElementSpawnEnemyDummy.produce
Hooks:OverrideFunction(ElementSpawnEnemyDummy, "produce", function (self, params)
	
	local vector_broken = false
	local function is_valid_vector(var)
		if type(var) == "userdata" and var.x and type(var.x) == "number" then
			return true
		end
		for i=1,5 do
			log("[DW+] PREVENTED AN INVALID SPAWN VECTOR CRASH IN ElementSpawnEnemyDummy, CAUSED BY: "..tostring(var))
		end
		vector_broken = true
		return false
	end
	
	local function is_valid_unit(unit)
		if PackageManager:has(Idstring("unit"), unit:id()) then
			return true
		end
		for i=1,5 do
			log("[DW+] PREVENTED AN INVALID UNIT SPAWN ATTEMPT IN ElementSpawnEnemyDummy, CAUSED BY: "..tostring(unit:id()))
		end
		return false
	end
	
	local function should_use_vanilla_func()
		if self.get_orientation and self:get_orientation() and is_valid_vector(self:get_orientation()) then
			if not (params and params.name) or (params and params.name and is_valid_unit(params.name)) then
				return true
			end
		end
		return false
	end
	
	if should_use_vanilla_func() then
		return dwp_orig_ElementSpawnEnemyDummy_produce(self, params)
	else
		
		-- re-do the function if shit goes wrong
		if not managers.groupai:state():is_AI_enabled() then
			return
		end

		local unit = nil
		
		-- fix?
		local position = Vector3(0,0,0)
		if vector_broken then
			-- try to spawn on other enemies
			for u_key, u_data in pairs(managers.enemy:all_enemies()) do
				if alive(u_data.unit) and u_data.unit:position() then
					position = u_data.unit:position()
					break
				end
			end
			-- or on a random player/bot if its real bad
			if position == Vector3(0,0,0) then
				for u_key, u_data in pairs(managers.groupai:state()._criminals) do
					if alive(u_data.unit) and u_data.unit:position() then
						position = u_data.unit:position()
						break
					end
				end
			end
		else
			-- if vector is fine but unit isnt
			position = self:get_orientation()
		end

		if params and params.name and is_valid_unit(params.name) then
			unit = safe_spawn_unit(params.name, position)
			local spawn_ai = self:_create_spawn_AI_parametric(params.stance, params.objective, self._values)

			unit:brain():set_spawn_ai(spawn_ai)
		else
			local enemy_name = self:value("enemy") or self._enemy_name or Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun") -- prob not the best solution as it adds to the pool of strong enemies, but i cba to check for other units that are always loaded
			unit = safe_spawn_unit(enemy_name, position)
			local objective = nil
			local action = self._create_action_data(CopActionAct._act_redirects.enemy_spawn[self._values.spawn_action])
			local stance = managers.groupai:state():enemy_weapons_hot() and "cbt" or "ntl"

			if action.type == "act" then
				objective = {
					type = "act",
					action = action,
					stance = stance
				}
			end

			local spawn_ai = {
				init_state = "idle",
				objective = objective
			}

			unit:brain():set_spawn_ai(spawn_ai)

			local team_id = params and params.team or self._values.team or tweak_data.levels:get_default_team_ID(unit:base():char_tweak().access == "gangster" and "gangster" or "combatant")

			if self._values.participate_to_group_ai then
				managers.groupai:state():assign_enemy_to_group_ai(unit, team_id)
			else
				managers.groupai:state():set_char_team(unit, team_id)
			end

			if self._values.voice then
				unit:sound():set_voice_prefix(self._values.voice)
			end
		end

		unit:base():hide_and_remove_collisions_for_a_few_frames()
		unit:base():add_destroy_listener(self._unit_destroy_clbk_key, callback(self, self, "clbk_unit_destroyed"))

		unit:unit_data().mission_element = self

		table.insert(self._units, unit)
		self:event("spawn", unit)

		if self._values.force_pickup and self._values.force_pickup ~= "none" then
			local pickup_name = self._values.force_pickup ~= "no_pickup" and self._values.force_pickup or nil

			unit:character_damage():set_pickup(pickup_name)
		end

		return unit
		
	end
	
end)