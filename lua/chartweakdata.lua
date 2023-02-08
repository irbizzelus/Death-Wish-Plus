if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- Change the surrender presets to harder ones
function DWP.setnewdoms()
	-- Easy surrender preset, used for guards and easier cops
	local surrender_preset_easy = {
		base_chance = 0.75,
		significant_chance = 0.15,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0.2,
				[0.99] = 0.9
			},
			weapon_down = 0.8,
			pants_down = 1,
			isolated = 0.1
		},
		factors = {
			flanked = 0.07,
			unaware_of_aggressor = 0.08,
			enemy_weap_cold = 0.15,
			aggressor_dis = {
				[1000] = 0.02,
				[300] = 0.15
			}
		}
	}
	
	-- Normal preset, used for most units
	local surrender_preset_normal = {
		base_chance = 0.2,
		significant_chance = 0.15,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0,
				[0.4] = 0.35
			},
			weapon_down = 0.1,
			pants_down = 0.1
		},
		factors = {
			isolated = 0.1,
			flanked = 0.1,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.1,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.1
			}
		}
	}
	
	-- Hardest preset, used for heavily armored cops
	local surrender_preset_hard = {
		base_chance = 0.01,
		significant_chance = 0.12,
		reasons = {
			health = {
				[1] = 0,
				[0.40] = 0.2
			},
			weapon_down = 0.1,
			pants_down = 0.1
		},
		factors = {
			isolated = 0.1,
			flanked = 0.1,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.1,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.1
			}
		}
	}
	
	if not tweak_data then
		DelayedCalls:Add("updateDomsAfterTweakdataHasLoaded", 0.1, function()
			DWP.setnewdoms()
		end)
	else
		if not DWP.newdomshook then
			-- Give the guards and light cops an "easy" preset
			tweak_data.character.security.surrender = surrender_preset_easy
			tweak_data.character.cop.surrender = surrender_preset_easy
			tweak_data.character.fbi.surrender = surrender_preset_easy
			
			-- Give most assault units the "normal" preset
			tweak_data.character.fbi_swat.surrender = surrender_preset_normal
			tweak_data.character.swat.surrender = surrender_preset_normal
			tweak_data.character.fbi_swat.surrender = surrender_preset_normal
			tweak_data.character.city_swat.surrender = surrender_preset_normal

			-- Give heavy assault units the "hard" preset
			tweak_data.character.heavy_swat.surrender = surrender_preset_hard
			tweak_data.character.fbi_heavy_swat.surrender = surrender_preset_hard
			DWP.newdomshook = true
			dofile(DWP._path .. "lua/chartweakdata.lua")
		end
	end
end

-- this is a dumb way of making sure that our doms are properly adjusted based on what difficulty we are on. should be reworked.
-- the whole problem comes out of the fact that enemy surrender presets dont change based on difficulty, but this mod should only affect DW difficulty, so let the pain begin
-- why is it so bad?
-- cuz we cant make a hook like down below without altering other difficulties, so we have to only tweak values when we are sure we are on DW difficulty using groupaitweakdata
-- P.S i actually think this post hook below is not even needed if you just set values once, like in the function above.
-- but while testing this mod on Custom Grounds, i noticed that they change their presets when you enter the arena
-- i dont care if all of this is unnesasary and only fixes custom grounds, it might prevent issues that i havent even seen yet, so keep it
if DWP.newdomshook then
	Hooks:PostHook(CharacterTweakData, "init", "DWP_newdoms", function(self)
		local surrender_preset_easy = {
			base_chance = 0.75,
			significant_chance = 0.15,
			violence_timeout = 2,
			reasons = {
				health = {
					[1] = 0.2,
					[0.99] = 0.9
				},
				weapon_down = 0.8,
				pants_down = 1,
				isolated = 0.1
			},
			factors = {
				flanked = 0.07,
				unaware_of_aggressor = 0.08,
				enemy_weap_cold = 0.15,
				aggressor_dis = {
					[1000] = 0.02,
					[300] = 0.15
				}
			}
		}
		
		local surrender_preset_normal = {
			base_chance = 0.2,
			significant_chance = 0.15,
			violence_timeout = 2,
			reasons = {
				health = {
					[1] = 0,
					[0.4] = 0.35
				},
				weapon_down = 0.1,
				pants_down = 0.1
			},
			factors = {
				isolated = 0.1,
				flanked = 0.1,
				unaware_of_aggressor = 0.1,
				enemy_weap_cold = 0.1,
				aggressor_dis = {
					[1000] = 0,
					[300] = 0.1
				}
			}
		}
		
		local surrender_preset_hard = {
			base_chance = 0.01,
			significant_chance = 0.12,
			reasons = {
				health = {
					[1] = 0,
					[0.40] = 0.2
				},
				weapon_down = 0.1,
				pants_down = 0.1
			},
			factors = {
				isolated = 0.1,
				flanked = 0.1,
				unaware_of_aggressor = 0.1,
				enemy_weap_cold = 0.1,
				aggressor_dis = {
					[1000] = 0,
					[300] = 0.1
				}
			}
		}
	
		tweak_data.character.security.surrender = surrender_preset_easy
		tweak_data.character.cop.surrender = surrender_preset_easy
		tweak_data.character.fbi.surrender = surrender_preset_easy
		
		tweak_data.character.fbi_swat.surrender = surrender_preset_normal
		tweak_data.character.swat.surrender = surrender_preset_normal
		tweak_data.character.fbi_swat.surrender = surrender_preset_normal
		tweak_data.character.city_swat.surrender = surrender_preset_normal

		tweak_data.character.heavy_swat.surrender = surrender_preset_hard
		tweak_data.character.fbi_heavy_swat.surrender = surrender_preset_hard
	end)
end
