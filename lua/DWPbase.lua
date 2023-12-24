-- Main global vars, default settings and utility functions
if not DWP then
    _G.DWP = {}
    DWP._path = ModPath
    DWP._data_path = SavePath .. 'DWPsave_new.txt'
    DWP.DWdifficultycheck = nil
	DWP.curlobbyname = nil
	DWP.settings = {
		lobbyname = true,
		infomsgpublic = false,
		endstattoggle = true,
		endstatSPkills = true,
		endstatheadshots = false,
		endstataccuarcy = false,
		skillinfo = true,
		hourinfo = true,
		infamy = true,
		DSdozer = true,
		difficulty = 1,
		assforce_pool = 400,
		assduration = 330,
		marshal_uniform = 2,
		hostagesbeta = false,
		statsmsgpublic = true
    }
	DWP.players = {}
	for i=1,4 do -- peer skills/hours prints
		DWP.players[i] = {}
		for j=1,2 do
			DWP.players[i][j] = 0
		end
	end
	DWP.synced = {}
	DWP.HostageControl = {}
	DWP.HostageControl.PeerHostageKillCount = {}
	DWP.color = Color(255,217,0,217) / 255
	DWP.statprefix = "[DWP_Stats]"

    function DWP:Save()
        local file = io.open(DWP._data_path, 'w+')
        if file then
            file:write(json.encode(DWP.settings))
            file:close()
        end
    end
    
    function DWP:Load()
        local file = io.open(DWP._data_path, 'r')
        if file then
            for k, v in pairs(json.decode(file:read('*all')) or {}) do
                DWP.settings[k] = v
            end
            file:close()
        end
    end
    
    -- Load the config in a pcall to prevent any corrupt config issues.
    local configResult = pcall(function()
        DWP:Load()
    end)

    -- Notify the user if something went wrong
    if not configResult then
        Hooks:Add("MenuManagerOnOpenMenu", "DWP_configcorrupted", function(menu_manager, nodes)            
            QuickMenu:new("Death With + Error", "Your 'Death With +' options file was corrupted, all the mod options have been reset to defaults.", {
                [1] = {
                    text = "OK",
                    is_cancel_button = true
                }
            }):show()
        end)
    end

    -- Generate save data even if nobody ever touches the mod options menu.
    -- This also regenerates a "fresh" config if it's corrupted.
    DWP:Save()

	if SystemInfo:distribution() == Idstring("STEAM") or SystemInfo:distribution() == Idstring("EPIC") then
		function DWP.change_lobby_name(lobby_name)
			if managers.network.matchmake._lobby_attributes and managers.network.matchmake.lobby_handler then
				managers.network.matchmake._lobby_attributes.owner_name = lobby_name
				managers.network.matchmake.lobby_handler:set_lobby_data(managers.network.matchmake._lobby_attributes)
			end
		end
	end
	
	dofile(ModPath .. "lua/coputils.lua")

	-- Change the surrender presets to harder ones
	function DWP:setnewdoms()	
		if not tweak_data then
			DelayedCalls:Add("updateDomsAfterTweakdataHasLoaded", 0.2, function()
				DWP:setnewdoms()
			end)
		else
			-- Easy surrender preset, used for guards and cops
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
			-- Normal preset, used for light swats
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
			-- Hardest preset, used for heavy swats
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
			-- Give the guards and light cops an "easy" preset
			tweak_data.character.security.surrender = surrender_preset_easy
			tweak_data.character.cop.surrender = surrender_preset_easy
			tweak_data.character.fbi.surrender = surrender_preset_easy
			
			-- Give most assault units the "normal" preset
			tweak_data.character.fbi_swat.surrender = surrender_preset_normal
			tweak_data.character.swat.surrender = surrender_preset_normal
			tweak_data.character.city_swat.surrender = surrender_preset_normal
			
			-- Give heavy assault units the "hard" preset
			tweak_data.character.heavy_swat.surrender = surrender_preset_hard
			tweak_data.character.fbi_heavy_swat.surrender = surrender_preset_hard
		end
	end
end
