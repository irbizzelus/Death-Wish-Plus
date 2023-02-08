dofile(ModPath .. "lua/DWPbase.lua")

if DWP.DWdifficultycheck == true then
	-- Cops arrest local player (mod user) if they are interacting with something when hit with a melee. sadly can not be applyied to clients because
	-- they handle recieved melee damage by themselves and only report on amount of damage recieved,
	-- not the fact that that dmg was from enemy melee. or maybe im just stupid and didnt find it, but i doubt it
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