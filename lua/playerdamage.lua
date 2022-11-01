dofile(ModPath .. "lua/DWPbase.lua")

if DWP.DWdifficultycheck == true then
	-- Cops arrest local player if we are interacting with something
	local playerdamage_damagemelee_orig = PlayerDamage.damage_melee
	function PlayerDamage:damage_melee(attack_data)

		local result = DWPMod.CopUtils:CheckLocalMeleeDamageArrest(self._unit, attack_data.attacker_unit, true)

		if result == "arrested" then
			self._unit:movement():on_cuffed()
			attack_data.attacker_unit:sound():say("i03", true, false)
			return
		else
			return playerdamage_damagemelee_orig(self, attack_data)
		end
	end
end