-- failsafe for cases where units have no team assgined, should never happen oustide of cloaker spanws from HC
Hooks:PreHook(CopBrain, "save", "DWP_setcopbrainteam", function(self, save_data)
	if not self._logic_data.team then

		local team = managers.groupai:state()._teams[tweak_data.levels:get_default_team_ID(self._unit:base():char_tweak().access == "gangster" and "gangster" or "combatant")]
		self._logic_data.team = team

		if not self.movement or not self:movement() then
			return
		end
		self:movement():set_team(team)
	end
end)