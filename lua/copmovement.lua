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
	DelayedCalls:Add("ContinueHighlightForSniper_"..tostring(npc._unit:id()), 1, function()
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
	if not DWP.settings.deathSquadSniperHighlight then
		return
	end
	
	if self._unit:base():char_tweak().access == "sniper" then
		-- fucking kill me
		if self._unit:base()._ext_movement and self._unit:base()._ext_movement._ext_brain and self._unit:base()._ext_movement._ext_brain._logic_data and self._unit:base()._ext_movement._ext_brain._logic_data.group and self._unit:base()._ext_movement._ext_brain._logic_data.group.type and self._unit:base()._ext_movement._ext_brain._logic_data.group.type == "Death_squad" then
			DWP.sniper_highlighter(self)
		end
	end
end)