-- highlight enemy snipers that spawn as a part of the "Death_squad"
function DWP.sniper_highlighter(npc)
	if not npc then
		return
	end
	if not alive(npc._unit) then
		return
	end
	if not npc:can_request_actions() then
		return
	end
	if not DWP.settings.deathSquadSniperHighlight then
		return
	end
	npc._unit:contour():add( "mark_enemy_damage_bonus_distance" , true )
	DelayedCalls:Add("ContinueHighlightForSniper_"..tostring(npc._unit:id()), 2, function()
		if DWP then
			DWP.sniper_highlighter(npc)
		end
	end)
end

Hooks:PostHook(CopMovement, "action_request", "DWP_mark_sniper_units_red" , function(self,action_desc)
	if not Network:is_server() then
		return
	end
	if self._unit:base().mic_is_being_moved then
		return
	end
	if not DWP.DWdifficultycheck then
		return
	end
	
	if DWP.settings.deathSquadSniperHighlight and self._unit:base():char_tweak().access == "sniper" then
		-- fucking kill me
		if self._unit:base()._ext_movement and self._unit:base()._ext_movement._ext_brain and self._unit:base()._ext_movement._ext_brain._logic_data and self._unit:base()._ext_movement._ext_brain._logic_data.group and self._unit:base()._ext_movement._ext_brain._logic_data.group.type and self._unit:base()._ext_movement._ext_brain._logic_data.group.type == "Death_squad" then
			DWP.sniper_highlighter(self)
		end
	end
	
	if action_desc.variant == "tied_all_in_one" or action_desc.variant == "tied" then
		if not DWP.cop_hostages then
			DWP.cop_hostages = {}
		end
		DWP.cop_hostages[self._unit:id()] = true
	else
		if DWP.cop_hostages and DWP.cop_hostages[self._unit:id()] then
			DWP.cop_hostages[self._unit:id()] = nil
		end
	end
end)

-- self-explanatory - prevents a crash when info is missing
-- in DW+ this should only occur when we force a unit spawn, like cloakers in the hostage control penalty, otherwise we should not need it
Hooks:PreHook(CopMovement, "team", "DWP_setcopteamifnoteam", function(self)
	if not self._team then
		self:set_team(managers.groupai:state()._teams[tweak_data.levels:get_default_team_ID(self._unit:base():char_tweak().access == "gangster" and "gangster" or "combatant")])
	end
end)