Hooks:PostHook(CopMovement, "action_request", "DWP_CopMovement_action_request_post" , function(self,action_desc)
	
	if not (Network:is_server() and DWP and DWP.DWdifficultycheck and DWP.settings_config and DWP.settings_config.hostage_control) then
		return
	end
	
	-- tracking enemies who give up, for hostage control penalties/bonuses
	if action_desc.variant == "tied_all_in_one" or action_desc.variant == "tied" then
		DWP.HostageControl.cop_hostages[self._unit:id()] = true
	else
		if DWP.HostageControl.cop_hostages[self._unit:id()] then
			DWP.HostageControl.cop_hostages[self._unit:id()] = nil
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