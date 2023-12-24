-- needs a difficulty check and a settings option
Hooks:PostHook(CopMovement, "action_request", "DWP_mark_sniper_units_red" , function(self,action_desc)
	if not Network:is_server() then
		return
	end
	if self._unit:base().mic_is_being_moved then
		return
	end
	
	if self._unit:base():char_tweak().access == "sniper" then
		-- fucking kill me
		if self._unit:base()._ext_movement and self._unit:base()._ext_movement._ext_brain and self._unit:base()._ext_movement._ext_brain._logic_data and self._unit:base()._ext_movement._ext_brain._logic_data.group and self._unit:base()._ext_movement._ext_brain._logic_data.group.type and self._unit:base()._ext_movement._ext_brain._logic_data.group.type == "Death_squad" then
			self._unit:contour():add( "mark_enemy_damage_bonus_distance" , true )
		end
	end
end)