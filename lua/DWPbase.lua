-- Main global vars, default settings and utility functions
if not DWP then
    _G.DWP = {}
	DWP._path = ModPath
    DWP.DWdifficultycheck = false
	DWP.settings = {
		-- gameplay
		difficulty = 1,
		assforce_pool = 400,
		hostage_control = true,
		deathSquadSniperHighlight = true,
		-- visuals
		DSdozer = true,
		marshal_uniform = 2,
		-- info msg
		skills_showcase = 2,
		hourinfo = true,
		infamy = true,
		-- end score
		endstats_enabled = true,
		endstats_public = true,
		endstats_specials = true,
		endstats_headshots = false,
		endstats_accuracy = false,
		-- misc
		lobbyname = true,	
    }
	DWP.players = {}
	for i=1,4 do
		DWP.players[i] = {
			skills_shown = false,
			hours_shown = false,
			welcome_msg1_shown = false,
			welcome_msg2_shown = false,
			requested_mods_1 = false,
			requested_mods_2 = false,
			HC_warning_messages = {
				civilian = 0,
				cop = 0
			}
		}
	end
	DWP.color = Color(255,217,0,217) / 255
	DWP.end_stats_printed = false
	DWP.HostageControl = {
		globalkillcount = 0,
		PeerHostageKillCount = {
			0,
			0,
			0,
			0
		},
	}
	
	function DWP.HostageControl:warn_peer(peer, peer_id, civilian_killed)
		local message = ""
		
		if civilian_killed then
			DWP.players[peer_id].HC_warning_messages.civilian = DWP.players[peer_id].HC_warning_messages.civilian + 1
			
			if DWP.players[peer_id].HC_warning_messages.civilian == 1 then
				message = "[DW+] Killing civilians inflicts gameplay penalties on you and your team! Use /hostage for more info."
			elseif DWP.players[peer_id].HC_warning_messages.civilian == 3 then
				message = "[DW+] Hostages are an asset, you kill them - they are gone. Info: /hostage"
			elseif DWP.players[peer_id].HC_warning_messages.civilian == 5 then
				if math.random() >= 0.4 then
					message = "[DW+] Your bloodlust won't make this job any easier."
				else
					-- since its a bit rare lol
					log("[DW+] 'Do you like hurting other people?' was sent to peer "..tostring(peer_id))
					message = "[DW+] Do you like hurting other people?"
				end
			end
		else
			DWP.players[peer_id].HC_warning_messages.cop = DWP.players[peer_id].HC_warning_messages.cop + 1
			
			if DWP.players[peer_id].HC_warning_messages.cop == 1 then
				message = "[DW+] Killing surrendered enemies inflicts gameplay penalties on you and your team! Use /hostage for more info."
			elseif DWP.players[peer_id].HC_warning_messages.cop == 3 then
				message = "[DW+] They will send heavier reinforsments if you continue. Info: /hostage"
			elseif DWP.players[peer_id].HC_warning_messages.cop == 5 then
				message = "[DW+] Your bloodlust won't make this job any easier."
			end
		end
		
		if managers.network:session():peer(peer_id) and message ~= "" then
			managers.network:session():send_to_peer(peer, "send_chat_message", 1, message)
		end
	end
	
	DWP.DS_snipers = {}

    function DWP:Save()
        local file = io.open(SavePath .. 'DWPsave_new.txt', 'w+')
        if file then
            file:write(json.encode(DWP.settings))
            file:close()
        end
    end
    
    function DWP:Load()
        local file = io.open(SavePath .. 'DWPsave_new.txt', 'r')
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

	function DWP.change_lobby_name(is_DW)
		if managers.network.matchmake._lobby_attributes and managers.network.matchmake.lobby_handler then
			local cur_name = tostring(managers.network.matchmake._lobby_attributes.owner_name)
			local new_name = "Death Wish +"
			if is_DW then
				if (DWP.settings_config and DWP.settings_config.difficulty == 2) or (not DWP.settings_config and DWP.settings.difficulty == 2) then
					new_name = "Death Wish ++"
				elseif (DWP.settings_config and DWP.settings_config.difficulty == 3) or (not DWP.settings_config and DWP.settings.difficulty == 3) then
					new_name = "Death Wish +++"
				elseif (DWP.settings_config and DWP.settings_config.difficulty == 4) or (not DWP.settings_config and DWP.settings.difficulty == 4) then
					new_name = "Death Wish ++++"
				end
			else
				new_name = managers.network.account:username()
			end
			if cur_name ~= new_name then
				managers.network.matchmake._lobby_attributes.owner_name = new_name
				managers.network.matchmake.lobby_handler:set_lobby_data(managers.network.matchmake._lobby_attributes)
			end
		end
	end
	
	dofile(ModPath .. "lua/coputils.lua")

	-- Change the surrender presets to harder ones
	function DWP:update_tweak_data()
		if not tweak_data then
			DelayedCalls:Add("updateDomsAfterTweakdataHasLoaded", 0.2, function()
				DWP:update_tweak_data()
			end)
		else
			if not Network:is_server() then
				return
			end
			-- Easy surrender preset, used for guards and cops
			local surrender_preset_easy = {
				base_chance = 0.85,
				significant_chance = 0,
				reasons = {
					health = {
						[1] = 0,
						[0.99] = 0.2
					},
					weapon_down = 0,
					pants_down = 0,
					isolated = 0
				},
				factors = {
					flanked = 0,
					unaware_of_aggressor = 0,
					enemy_weap_cold = 0,
					aggressor_dis = {
						[1000] = 0,
						[300] = 0
					}
				}
			}
			-- Normal preset, used for light swats
			local surrender_preset_normal = {
				base_chance = 0.3,
				significant_chance = 0,
				reasons = {
					health = {
						[1] = 0,
						[0.4] = 0.3
					},
					weapon_down = 0.3,
					pants_down = 0.3
				},
				factors = {
					isolated = 0,
					flanked = 0.3,
					unaware_of_aggressor = 0,
					enemy_weap_cold = 0,
					aggressor_dis = {
						[500] = 0,
						[150] = 0.2
					}
				}
			}
			-- Hardest preset, used for heavy swats
			local surrender_preset_hard = {
				base_chance = 0.1,
				significant_chance = 0,
				reasons = {
					health = {
						[1] = 0,
						[0.40] = 0.1
					},
					weapon_down = 0.1,
					pants_down = 0.1
				},
				factors = {
					isolated = 0,
					flanked = 0,
					unaware_of_aggressor = 0,
					enemy_weap_cold = 0,
					aggressor_dis = {
						[500] = 0,
						[150] = 0.05
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
			
			tweak_data.weapon.swat_van_turret_module.AUTO_REPAIR = false
			tweak_data.weapon.aa_turret_module.AUTO_REPAIR = false
			tweak_data.weapon.crate_turret_module.AUTO_REPAIR = false
		end
	end
	
	function DWP:ActivateHostageControlDozerPenalty()
		if DWP.settings_config and DWP.settings_config.difficulty == 1 then
			tweak_data.group_ai.besiege.assault.groups.Undead = {
				0,
				0.18,
				0.18
			}
			tweak_data.group_ai.besiege.assault.groups.FBI_tanks = {
				0,
				0,
				0
			}
			tweak_data.group_ai.special_unit_spawn_limits.tank = 7
		elseif DWP.settings_config and DWP.settings_config.difficulty == 2 then
			tweak_data.group_ai.besiege.assault.groups.Undead = {
				0,
				0.22,
				0.22
			}
			tweak_data.group_ai.besiege.assault.groups.FBI_tanks = {
				0,
				0,
				0
			}
			tweak_data.group_ai.special_unit_spawn_limits.tank = 9
		elseif DWP.settings_config and DWP.settings_config.difficulty == 3 then
			tweak_data.group_ai.besiege.assault.groups.Undead = {
				0,
				0.32,
				0.32
			}
			tweak_data.group_ai.besiege.assault.groups.FBI_tanks = {
				0,
				0,
				0
			}
			tweak_data.group_ai.special_unit_spawn_limits.tank = 11
		elseif DWP.settings_config and DWP.settings_config.difficulty == 4 then
			tweak_data.group_ai.besiege.assault.groups.Undead = {
				0,
				0.42,
				0.42
			}
			tweak_data.group_ai.besiege.assault.groups.FBI_tanks = {
				0,
				0,
				0
			}
			tweak_data.group_ai.special_unit_spawn_limits.tank = 13
		end
	end
	
	function DWP:welcomemsg1(peer_id) -- welcome message for clients
		if Network:is_server() and DWP.DWdifficultycheck == true then
			DelayedCalls:Add("DWP:DWwelcomemsg1topeer" .. tostring(peer_id), 0.3, function()
				local peer = managers.network:session():peer(peer_id)
				
				if peer == managers.network:session():local_peer() then
					DWP.players[peer_id].welcome_msg1_shown = true
					return
				end
				
				if not DWP.players[peer_id].welcome_msg1_shown then
					if not peer then
						return
					end
					local message = "Welcome "..peer:name().."! This lobby runs 'Death Wish +' mod (Ver. 2.5.1) with some gameplay changes:"
					if managers.network:session() and managers.network:session():peers() then
						peer:send("request_player_name_reply", "DW+")
						peer:send("send_chat_message", ChatManager.GAME, message)
						DWP.players[peer_id].welcome_msg1_shown = true
					end
				end
			end)
		end
	end

	function DWP:welcomemsg2(peer_id)
		if Network:is_server() and DWP.DWdifficultycheck == true then
			DelayedCalls:Add("DWP:DWwelcomemsg2topeer" .. tostring(peer_id), 0.9, function()
				local peer = managers.network:session():peer(peer_id)
				
				if peer == managers.network:session():local_peer() then
					DWP.players[peer_id].welcome_msg2_shown = true
					return
				end
				
				if not DWP.players[peer_id].welcome_msg2_shown then
					if not peer then
						return
					end
					if managers.network:session() and managers.network:session():peers() then
						local diff = "'DW+ Classic'"
						if DWP.settings_config and DWP.settings_config.difficulty == 2 then
							diff = "'DW++'"
						elseif  DWP.settings_config and DWP.settings_config.difficulty == 3 then
							diff = "'Insanity'"
						elseif DWP.settings_config and DWP.settings_config.difficulty == 4 then
							diff = "'Suicidal'"
						-- if settings config wasnt created yet, take whatever host selected in options, even though its not yet confirmed
						elseif DWP.settings.difficulty == 2 then
							diff = "'DW++'"
						elseif DWP.settings.difficulty == 3 then
							diff = "'Insanity'"
						elseif DWP.settings.difficulty == 4 then
							diff = "'Suicidal'"
						end
						peer:send("send_chat_message", ChatManager.GAME, "Enemies CAN HANDCUFF YOU during interactions: /cuffs")
						peer:send("send_chat_message", ChatManager.GAME, "Enemies are harder to intimidate: /dom")
						peer:send("send_chat_message", ChatManager.GAME, "Enemy variety tweaks: /cops")
						peer:send("send_chat_message", ChatManager.GAME, "Police assault tweaks: /assault")
						if DWP.settings_config and DWP.settings_config.hostage_control then
							local hostage_control_msg = "Penalties(bonuses) for killing(controlling) hostages were added: /hostage"
							if DWP.HostageControl and DWP.HostageControl.globalkillcount and DWP.HostageControl.globalkillcount >= 1 then
								hostage_control_msg = "Penalties(bonuses) for killing(controlling) hostages were added: /hostage. "..tostring(DWP.HostageControl.globalkillcount).." hostages were killed allready."
							end
							peer:send("send_chat_message", ChatManager.GAME, hostage_control_msg)
						end
						peer:send("send_chat_message", ChatManager.GAME, "Current mod difficulty: "..diff..": /diff")
						peer:send("send_chat_message", ChatManager.GAME, "Use chat commands above to recieve personal messages with more info on said gameplay changes. You can also use /med and /ammo to ask for help.")
						if DWP and not MenuCallbackHandler:is_modded_client() then
							peer:send("send_chat_message", ChatManager.GAME, "Lastly, "..managers.network.account:username().." seems to have a hidden mod list, you can request their modlist using /hostmods.")
						end
						peer:send("request_player_name_reply", managers.network.account:username())
						DWP.players[peer_id].welcome_msg2_shown = true
					end
				end
				
			end)
		end
	end
	
	function DWP:infomessage(message)
		if Global.game_settings.single_player == false then
			managers.chat:_receive_message(1, "[DW+]", message, DWP.color)
		end
	end

	function DWP:return_skills(peer_id)

		if not peer_id then
			return
		end

		local peer = managers.network:session() and managers.network:session():peer(peer_id)
		if not peer then
			return
		end
		
		if peer == managers.network:session():local_peer() then
			DWP.players[peer_id].skills_shown = true
			return
		end
		
		if peer and peer:skills() and type(peer:skills()) == "string" then
			local skills = string.split(string.split(peer:skills(), "-")[1], "_")
			local perk_deck = string.split(string.split(peer:skills(), "-")[2], "_")
			local perk_deck_id = tonumber(perk_deck[1])
			local perk_deck_completion = tonumber(perk_deck[2])
			
			local skills_string = ""
			
			if DWP.settings.skills_showcase == 2 then
				local skillsum = 0
				for k,v in pairs(skills) do
					skillsum = skillsum + tonumber(v)
				end
				skills_string = "|"..tostring(skillsum).." skill points used|"
			elseif DWP.settings.skills_showcase == 3 then
				skills_string = "|Mas.: ("..skills[1]+skills[2]+skills[3].."); Enf.: ("..skills[4]+skills[5]+skills[6].."); Tec.: ("..skills[7]+skills[8]+skills[9].."); Gho.: ("..skills[10]+skills[11]+skills[12].."); Fug.: ("..skills[13]+skills[14]+skills[15]..")|"
			elseif DWP.settings.skills_showcase == 4 then
				skills_string = "|Mas.: ("..skills[1].." "..skills[2].." "..skills[3]..") Enf.: ("..skills[4].." "..skills[5].." "..skills[6]..") Tec.: ("..skills[7].." "..skills[8].." "..skills[9]..") Gho.: ("..skills[10].." "..skills[11].." "..skills[12]..") Fug.:("..skills[13].." "..skills[14].." "..skills[15]..")|"
			end
			
			local perk_name = managers.localization:text("menu_st_spec_" .. perk_deck_id)
			if perk_deck_id > 23 then -- update this when, if ever, a new perk is added
				perk_name = "Custom perk deck"
			end
			
			local message = peer:name()..": "..skills_string.." |"..perk_name.." "..tostring(perk_deck_completion).."/9|"
			
			if DWP.settings.skills_showcase ~= 1 then
				if not DWP.players[peer_id].skills_shown then
					DWP.players[peer_id].skills_shown = true
					DWP:infomessage(message)
				end
			end
		end
	end

	function DWP:returnplayerhours(peer_id)

		if not peer_id then
			return
		end
		
		local peer = managers.network:session() and managers.network:session():peer(peer_id)
		if not peer then
			return
		end
		if peer == managers.network:session():local_peer() then
			DWP.players[peer_id].hours_shown = true
			return
		end
		
		if DWP.settings.hourinfo and not DWP.players[peer_id].hours_shown then
		
			local hours
			local steam_id = tostring(managers.network:session():peer(peer_id)._account_id)
			
			local infamy = "."
			if DWP.settings.infamy then
				if peer and peer._rank then
					infamy = ", with level " .. tostring(peer._rank) .. " infamy."
				else
					-- we dont confirm hour print because it can cause false '0 infamy' messages, since the rank() func always exists for peers, but it can return default 0 if peer is not synced yet
					log("[DWP] NO peer._rank!!!!! hours function quits for peer: "..peer_id)
					return
				end
			end
			
			if peer:account_type() == Idstring("EPIC") then
				if DWP.settings.hourinfo == true then
					
					hours = "an EPIC profile"
					local message = tostring(peer:name()).." has "..hours..infamy
					
					if not DWP.players[peer_id].hours_shown then
						DWP.players[peer_id].hours_shown = true
						DWP:infomessage(message)
						return
					end
				end
			end
			
			if peer:account_type() == Idstring("STEAM") then
				dohttpreq('http://steamcommunity.com/profiles/' .. steam_id .. '/?xml=1',
					function (page)
						local hrs_str = "??"
						if type(page) ~= 'string' then
							log('[DW+] Error loading player hours for ' .. tostring(steam_id) .. ': no Steam reply')
						end
						
						hours = page:match('<mostPlayedGame>.-<gameLink>.-218620.-</gameLink>.-<hoursOnRecord>([%d,.]+)</hoursOnRecord>')
						hours = type(hours) == 'string' and hours:gsub(',' , '')
						if hours then
							hrs_str = hours
						end
						
						if DWP.settings.hourinfo then
							local message = tostring(peer:name()).." has "..hrs_str.." hours"..infamy
							DWP:infomessage(message)
						end
					end
				)
			end
			DWP.players[peer_id].hours_shown = true
		else
			DWP.players[peer_id].hours_shown = true
		end
	end
end