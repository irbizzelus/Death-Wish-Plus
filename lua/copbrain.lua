-- HRT units sometimes spawn without a team set
-- this function is called to sync the units to late joiners and substitutes a default team if none is set
	Hooks:PreHook(CopBrain, "save", "setcopbrainteam", function(self, save_data)
		if not self._logic_data.team then

			local team = managers.groupai:state()._teams[tweak_data.levels:get_default_team_ID(self._unit:base():char_tweak().access == "gangster" and "gangster" or "combatant")]
			self._logic_data.team = team

			-- Avoid crashes when movement or movement function(???) is nil
			if not self.movement or not self:movement() then
				return
			end
			self:movement():set_team(team)
		end
	end)