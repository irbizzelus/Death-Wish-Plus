-- if cop is killed after giving up, apply hostage control penalties, but not in stealth
Hooks:PostHook(CopDamage, "die", "DWP_copdie" , function(self,attack_data)
	
	if not (Network:is_server() and DWP and DWP.DWdifficultycheck and DWP.settings_config and DWP.settings_config.hostage_control) then
		return
	end
	
	if DWP.HostageControl.cop_hostages[self._unit:id()] then
		DWP.HostageControl.cop_hostages[self._unit:id()] = nil
		if not managers.groupai:state():whisper_mode() then
			DWP.HostageControl:hostage_killed(attack_data.attacker_unit, true)
		end
	end
	
end)