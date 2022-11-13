if DWPMod and DWPMod.CopUtils then
    return
end

dofile(ModPath .. "lua/DWPbase.lua")

DWPMod.CopUtils = {}

-- Search radius for interacing player
DWPMod.CopUtils._arrest_search_radius = 800
-- How far can a cop be to arrest a player
DWPMod.CopUtils._arrest_action_radius = 150

-- Checks if the local player should be arrested
function DWPMod.CopUtils:CheckLocalMeleeDamageArrest(player_unit, attacker_unit, is_melee)
	--dont get cuffed if we are a client, if host has the mod, he will tell us when we are cuffed anyway
	if Network and Network:is_client() then
        return nil, "not host, no cuffs"
    end
    -- Check if this is our own player unit
    if player_unit ~= managers.player:player_unit() then
        return nil, "not local player unit"
    end

    local state = player_unit:movement():current_state()
    -- Check if we're interacting
    local is_interacting = state._interacting and state:_interacting()
    if not is_interacting then
        return false, "not interacting"
    end

    -- Check if the cop isn't too far away to do this
    if not is_melee and attacker_unit and alive(attacker_unit) then
        local dist = mvector3.distance(player_unit:position(), attacker_unit:position())
        if dist > self._arrest_action_radius then
            return false, "cop too far away for arrest"
        end
    end

    return "arrested"
end

-- Check if another player should be arrested
function DWPMod.CopUtils:CheckClientMeleeDamageArrest(player_unit, attacker_unit, is_melee)
    if Network and Network:is_client() then
        return nil, "not host, no husk check"
    end

    if not player_unit or not player_unit.alive or not player_unit:alive() or not player_unit.movement or not player_unit:movement() or not player_unit:movement()._interaction_tweak then
		return false, "husk not interacting"
    end

    if not is_melee and attacker_unit and alive(attacker_unit) then
        local dist = mvector3.distance(player_unit:position(), attacker_unit:position())
        if dist > self._arrest_action_radius then
            return false, "cop too far away from husk"
        end
    end

    return "arrested"
end

function DWPMod.CopUtils:SendCopToArrestPlayer(player_unit)
    if Network and Network:is_client() then
        return
    end

    -- Stealth phase check
    if managers.groupai:state():whisper_mode() then
        return
    end

    -- Check if target is valid
    if not player_unit or not player_unit.alive or not player_unit:alive() then
        return
    end

    local enemies = World:find_units_quick(player_unit, "sphere", player_unit:position(), self._arrest_search_radius, managers.slot:get_mask("enemies"))
    if not enemies or #enemies <= 0 then
        return
    end

    local lowest_distance = 999999
    local closest_enemy = nil
    local playerpos = player_unit:position()

    local objective = {
        type = "free",
        haste = "run",
        pose = "stand",
        nav_seg = managers.navigation:get_nav_seg_from_pos(player_unit:position(), true),
        pos = mvector3.copy(player_unit:position()),
        forced = true,
        important = true
    }

-- Check every enemy in radius, make sure its actually an enemy, and pick closest one to come for player
    for i, enemy in pairs(enemies) do
        if self:AreUnitsEnemies(player_unit, enemy) then
            local enemy_chartweak = enemy:base():char_tweak()
            if enemy_chartweak.access ~= "gangster" then
                local dist = mvector3.distance(enemy:position(), playerpos)
                local is_available = enemy:brain():is_available_for_assignment(objective)

                if dist < lowest_distance and is_available then
                    lowest_distance = dist
                    closest_enemy = enemy
                end

            end
        end
    end

    -- If an enemy was found, send them to arrest the player
    if closest_enemy then
        objective = {
            type = "free",
            haste = "run",
            pose = "stand",
            nav_seg = managers.navigation:get_nav_seg_from_pos(player_unit:position(), true),
            pos = mvector3.copy(player_unit:position()),
            complete_clbk = callback(self, self, '_onCopArrivedAtArrestPosition', {cop = closest_enemy, target = player_unit}),
            forced = true,
            important = true
        }
        closest_enemy:brain():set_objective(objective)
        closest_enemy:brain():set_logic("travel")
        closest_enemy:movement():action_request({
            type = "idle",
            body_part = 1,
            sync = true
        })
    end
end

-- When the cop arrives at their arrest position
function DWPMod.CopUtils:_onCopArrivedAtArrestPosition(clbk_data)
    if Network and Network:is_client() then
        return
    end

    local cop = clbk_data.cop
    local player_unit = clbk_data.target

	-- check if targets are still valid
    if not alive(cop) or not alive(player_unit) then
        return
    end

    -- Check if player_unit is local player or a husk
    local result = nil
    if player_unit == managers.player:player_unit() then
        result = self:CheckLocalMeleeDamageArrest(player_unit, cop)
    else
        result = self:CheckClientMeleeDamageArrest(player_unit, cop)
    end

    if result == "arrested" then
        player_unit:movement():on_cuffed()
        -- Make cop say a line
        cop:sound():say("i03", true, false)
    end
end

-- Find out if unit A is an enemy of unit B
function DWPMod.CopUtils:AreUnitsEnemies(unit_a, unit_b)
    if not unit_a or not unit_b or not unit_a:movement() or not unit_b:movement() then
        return false
    end

	if unit_b:brain()._current_logic_name == "trade" then
		return false
	end

    return unit_a:movement():team().foes[unit_b:movement():team().id] and true or false
end

function DWPMod.CopUtils:NearbyCopAutoArrestCheck(player_unit, islocal)

	if Network and Network:is_client() then
        return
    end

    -- Stealth phase check
    if managers.groupai:state():whisper_mode() then
        return
    end

	function ContinuousInteractionCheck()
		-- Check if target is valid and interacting
		local is_interacting = true
		if islocal == true then
			local state = player_unit:movement():current_state()
			is_interacting = state._interacting and state:_interacting()
			if is_interacting then -- it's a timer, reset to value
				is_interacting = true
			end
		elseif not player_unit or not player_unit.alive or not player_unit:alive() or not player_unit.movement or not player_unit:movement() or not player_unit:movement()._interaction_tweak then
			is_interacting = false
		end

		if not is_interacting then
			return
		else
			DelayedCalls:Add("check_for_unit_interaction_and_arrest"..tostring(player_unit), 0.15, function()
				local enemies = World:find_units_quick(player_unit, "sphere", player_unit:position(), 125, managers.slot:get_mask("enemies"))
				if enemies and #enemies >= 1 then
					-- Check every enemy in radius, make sure its actually an enemy
					for i, enemy in pairs(enemies) do
						if self:AreUnitsEnemies(player_unit, enemy) then
							local enemy_chartweak = enemy:base():char_tweak()
							if enemy_chartweak.access ~= "gangster" then
								player_unit:movement():on_cuffed()
								enemy:sound():say("i03", true, false)
							end
						end
					end
				end
				ContinuousInteractionCheck()
			end)
		end
	end
	
	ContinuousInteractionCheck()
	
end
