dofile(ModPath .. "lua/DWPbase.lua")
-- TODO: should improve this whole client arrest thing - cops only cuff players
-- if they are the ones chosen by the 'search nearby cops' function
-- which leads to situations where client can be melee'd and pushed out of his interaction
-- by another cop, before chosen cop comes close to arrest
-- Update: kinda fixed. implemented a new aggresive cuffing system that deals with this issue, but will keep it a setting for now, to make sure it doesnt cause issues
if DWP.DWdifficultycheck == true then
	-- Cops arrest clients if they happen to interact with something
	local huskplayerdamage_damagemelee_orig = HuskPlayerDamage.damage_melee
	function HuskPlayerDamage:damage_melee(attack_data)

		-- Should only run for the host
		if Network and Network:is_client() then
			return huskplayerdamage_damagemelee_orig(self, attack_data)
		end

		local result = DWPMod.CopUtils:CheckClientMeleeDamageArrest(self._unit, attack_data.attacker_unit, true)
		if result == "arrested" then
			self._unit:movement():on_cuffed()
			attack_data.attacker_unit:sound():say("i03", true, false)
			return
		else
			return huskplayerdamage_damagemelee_orig(self, attack_data)
		end
	end
end
