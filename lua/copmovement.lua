-- Sometimes HRT's spawn without a team set which crashes the game
-- Set a default team for cop units if they dont have a team
Hooks:PreHook(CopMovement, "team", "setcopteamifnoteam", function(self)
	if not self._team then
		self:set_team(managers.groupai:state()._teams[tweak_data.levels:get_default_team_ID(self._unit:base():char_tweak().access == "gangster" and "gangster" or "combatant")])
	end
end)

function CopMovement:_override_weapons(primary, secondary)
	if primary then
		self._unit:inventory():add_unit_by_name(primary, true)
	end
	if secondary then
		self._unit:inventory():add_unit_by_name(secondary, true)
	end
end
