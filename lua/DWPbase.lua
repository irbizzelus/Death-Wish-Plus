if not DWP then
    _G.DWP = {}
end

-----------------------------------------------------------------------------
-- MAIN VARS, DEFAULT SETTINGS
-----------------------------------------------------------------------------

DWP._path = ModPath
DWP.DWdifficultycheck = false
DWP.version = "2.8.01"
DWP.version_num = 2.8 -- this one is used for comparing to the current save file. only update if the pop up message needs to include important patch info
DWP.settings = {
	-- gameplay
	difficulty = 1,
	assforce_pool = 400,
	hostage_control = true,
	ecm_feedback_chance = 0.5,
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
DWP.end_stats_printed = false
DWP.color = Color(255,217,0,217) / 255

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

-- prevent corrupt config issues
local configResult = pcall(function()
	DWP:Load()
end)
-- if something went wrong
if not configResult then
	Hooks:Add("MenuManagerOnOpenMenu", "DWP_configcorrupted", function(menu_manager, nodes)            
		QuickMenu:new("Death With + Error", "Your \"Death With +\" options file was corrupted, all the mod options have been reset to defaults.", {
			[1] = {
				text = "OK",
				is_cancel_button = true
			}
		}):show()
	end)
end
DWP:Save()

dofile(ModPath .. "lua/coputils.lua")

-----------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------

DWP.peers_with_mod = {}
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

-- info ON players
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
	
	if peer and peer:skills() then
		
		local skills_func_string = peer:skills()
		
		if type(skills_func_string) ~= "string" or skills_func_string == "" then
			return
		end
		
		local skills = string.split(string.split(skills_func_string, "-")[1], "_")
		local skill_count = 0
		for k,v in pairs(skills) do
			skill_count = skill_count + 1
			if skill_count > 15 or not v or type(tonumber(v)) ~= "number" then
				return
			end
		end
		if skill_count < 15 then
			return
		end
		
		local perk_deck = string.split(string.split(skills_func_string, "-")[2], "_")
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
				if Global.game_settings.single_player == false then
					managers.chat:_receive_message(1, "[DW+]", message, DWP.color)
				end
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
	
		local infamy = "."
		if DWP.settings.infamy then
			if peer and peer._rank then
				infamy = ", with level " .. tostring(peer._rank) .. " infamy."
			else
				-- we dont confirm hour print because it can cause false '0 infamy' messages, since the rank() func always exists for peers, but it can return default 0 if peer is not synced yet
				log("[DW+] NO peer._rank!!!!! hours function quits for peer: "..peer_id)
				return
			end
		end
		
		local hours = ""
		local message = ""
		
		if peer:account_type() == Idstring("EPIC") then
			message = tostring(peer:name()).." has an EPIC profile"..infamy
			if Global.game_settings.single_player == false then
				managers.chat:_receive_message(1, "[DW+]", message, DWP.color)
			end
		elseif peer:account_type() == Idstring("STEAM") then
			local steam_id = tostring(managers.network:session():peer(peer_id)._account_id)
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
					message = tostring(peer:name()).." has "..hrs_str.." hours"..infamy
					if Global.game_settings.single_player == false then
						managers.chat:_receive_message(1, "[DW+]", message, DWP.color)
					end
				end
			)
		end
		
		DWP.players[peer_id].hours_shown = true
	else
		DWP.players[peer_id].hours_shown = true
	end
end

-- info FOR players
function DWP:welcomemsg1(peer_id) -- welcome message for clients
	local diff_id = DWP.settings.difficulty or 1
	if Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.difficulty then
		diff_id = DWP.settings_config.difficulty
	end
	local ecm_chance = 0.8
	if Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.ecm_feedback_chance then
		ecm_chance = math.floor(DWP.settings_config.ecm_feedback_chance * 100)
	elseif DWP.settings.ecm_feedback_chance then
		ecm_chance = math.floor(DWP.settings.ecm_feedback_chance * 100)
	end
	local hostage_control = DWP.settings.hostage_control and 2 or 1
	if Utils:IsInGameState() and DWP.settings_config then
		if DWP.settings_config.hostage_control then
			hostage_control = 2
		else
			hostage_control = 1
		end
	end
	local settings_string = "|"..tostring(diff_id).."|"..tostring(ecm_chance).."|"..tostring(hostage_control).."|"
	if Network:is_server() and DWP.DWdifficultycheck then
		LuaNetworking:SendToPeersExcept(1, "DWP_sync", "Hello_"..tostring(DWP.version)..settings_string)
		DelayedCalls:Add("DWP:DWwelcomemsg1topeer" .. tostring(peer_id), 1.2, function()
			local peer = managers.network:session():peer(peer_id)
			
			if peer == managers.network:session():local_peer() then
				DWP.players[peer_id].welcome_msg1_shown = true
				return
			end
			
			if not DWP.players[peer_id].welcome_msg1_shown then
				if not peer then
					return
				end
				local message = "Welcome "..peer:name().."! This lobby runs \"Death Wish +\" mod (Ver. "..tostring(DWP.version)..") with some gameplay changes:"
				if managers.network:session() and managers.network:session():peers() then
					DWP.players[peer_id].welcome_msg1_shown = true
					if not DWP.peers_with_mod[peer_id] then
						peer:send("send_chat_message", ChatManager.GAME, message)
					end
				end
			end
		end)
	end
end

function DWP:welcomemsg2(peer_id)
	if Network:is_server() and DWP.DWdifficultycheck then
		DelayedCalls:Add("DWP:DWwelcomemsg2topeer" .. tostring(peer_id), 1.6, function()
			local peer = managers.network:session():peer(peer_id)
			
			if peer == managers.network:session():local_peer() then
				DWP.players[peer_id].welcome_msg2_shown = true
				return
			end
			
			if not DWP.players[peer_id].welcome_msg2_shown then
				if not peer then
					return
				end
				if managers.network:session() and managers.network:session():peers() and not DWP.peers_with_mod[peer_id] then
					local diff_strings = {
						[1] = "\"DW+ Classic\"",
						[2] = "\"DW++\"",
						[3] = "\"Insanity\"",
						[4] = "\"Suicidal\"",
					}
					local sett = DWP.settings.difficulty
					if DWP.settings_config and DWP.settings_config.difficulty then
						sett = DWP.settings_config.difficulty
					end
					local diff = diff_strings[sett]
					peer:send("send_chat_message", ChatManager.GAME, "Enemies can HANDCUFF YOU during interactions: /cuffs")
					peer:send("send_chat_message", ChatManager.GAME, "ECM feedback stun effect is nerfed: /ecm")
					peer:send("send_chat_message", ChatManager.GAME, "Enemies are now much harder to intimidate: /dom")
					peer:send("send_chat_message", ChatManager.GAME, "Enemy variety was tweaked: /cops")
					local prefer_FSS = FullSpeedSwarm and FullSpeedSwarm.settings.task_throughput >= 600
					if not (prefer_FSS or LIES) then
						peer:send("send_chat_message", ChatManager.GAME, "Enemy AI was sped up: /ai")
					end
					peer:send("send_chat_message", ChatManager.GAME, "Assault pacing was altered: /assault")
					if DWP.settings_config and DWP.settings_config.hostage_control then
						local hostage_control_msg = "Penalties(bonuses) for killing(controlling) hostages were added: /hostage; For hostage count use /hcstatus"
						if DWP.HostageControl and DWP.HostageControl.globalkillcount and DWP.HostageControl.globalkillcount >= 1 then
							hostage_control_msg = "Penalties(bonuses) for killing(controlling) hostages were added: /hostage. "..tostring(DWP.HostageControl.globalkillcount).." hostages were killed allready. For hostage count use /hcstatus"
						end
						peer:send("send_chat_message", ChatManager.GAME, hostage_control_msg)
					end
					peer:send("send_chat_message", ChatManager.GAME, "Current mod difficulty: "..diff..": /diff")
					peer:send("send_chat_message", ChatManager.GAME, "Use chat commands above to recieve personal messages with more info on said gameplay changes. Good luck and have fun!")
					if DWP and not MenuCallbackHandler:is_modded_client() then
						peer:send("send_chat_message", ChatManager.GAME, "Lastly, "..managers.network.account:username().." seems to have a hidden mod list, you can request their modlist using /hostmods.")
					end
					DWP.players[peer_id].welcome_msg2_shown = true
				end
			end
			
		end)
	end
end

-----------------------------------------------------------------------------
-- HOSTAGE CONTROL
-----------------------------------------------------------------------------

DWP.HostageControl = {
	cop_hostages = {}, -- units specifically
	globalkillcount = 0,
	PeerHostageKillCount = {
		0,
		0,
		0,
		0
	},
}
function DWP.HostageControl:warn_peer(peer, is_cop)
	
	if not peer then
		return
	end
	
	local peer_id = peer:id()
	local message = ""
	local messages = {
		[1] = "[DW+] Killing civilians inflicts gameplay penalties on you and your team! Use /hostage for more info.",
		[2] = "[DW+] Hostages are an asset, you kill them - they are gone. Info: /hostage",
		[3] = "[DW+] Your bloodlust won't make this job any easier.",
		[4] = "[DW+] Do you like hurting other people?",
	}
	if is_cop then
		messages[1] = "[DW+] Killing surrendered enemies inflicts gameplay penalties on you and your team! Use /hostage for more info."
		messages[2] = "[DW+] They will send heavier reinforsments if you continue. Info: /hostage"
		DWP.players[peer_id].HC_warning_messages.cop = DWP.players[peer_id].HC_warning_messages.cop + 1
	else
		DWP.players[peer_id].HC_warning_messages.civilian = DWP.players[peer_id].HC_warning_messages.civilian + 1
	end
	
	local warning_number = DWP.players[peer_id].HC_warning_messages.civilian
	if is_cop then
		warning_number = DWP.players[peer_id].HC_warning_messages.cop
	end
	
	if warning_number == 1 then
		message = messages[1]
	elseif warning_number == 2 then
		message = messages[2]
	elseif warning_number == 3 or warning_number == 5 then
		if not is_cop and math.random() <= 0.3 then
			message = messages[4]
		else
			message = messages[3]
		end
	end
	
	if managers.network:session():peer(peer_id) and message ~= "" then
		managers.network:session():send_to_peer(peer, "send_chat_message", 1, message)
	end
end

function DWP.HostageControl:hostage_killed(killer_unit, is_cop)
	
	self.globalkillcount = self.globalkillcount + 1
	
	if alive(killer_unit) and killer_unit:base() then
		if killer_unit:base().thrower_unit then
			killer_unit = killer_unit:base():thrower_unit()
		elseif killer_unit:base().sentry_gun then
			killer_unit = killer_unit:base():get_owner()
		end
	end
	
	local killer_name = "Someone"
	local peer = 1
	local killer_id = 1
	
	-- figure out who killed a hostage, then send message in chat to either tell them to stop, or to announce new penalties
	if managers.player:player_unit() == killer_unit then
		killer_name = managers.network.account:username()
	else
		peer = managers.network:session():peer_by_unit(killer_unit)
		if peer then
			killer_name = peer:name()
			killer_id = peer:id()
		end
	end
	self.PeerHostageKillCount[killer_id] = self.PeerHostageKillCount[killer_id] + 1
	
	local messages = {
		[1] = "[DW+] You killed a civilian! Hostages killed: "..tostring(self.globalkillcount),
		[2] = "[DW+] "..tostring(killer_name).." killed a civilian! Hostages killed: "..tostring(self.globalkillcount),
		[3] = "[DW+] 6 hostages killed. Enemy forces are almost maxed out. Also cloakers learned how to teleport?..",
		[4] = "[DW+] 9 hostages are now dead. You can all blame "..killer_name.." for what's to come.",
	}
	if is_cop then
		messages[1] = "[DW+] You killed a surrendered officer! Hostages killed: "..tostring(self.globalkillcount)
		messages[2] = "[DW+] "..tostring(killer_name).." killed a surrendered officer! Hostages killed: "..tostring(self.globalkillcount)
	end
	
	if self.globalkillcount == 9 then
		managers.chat:send_message(ChatManager.GAME, nil, messages[4])
		self:ActivateDozerPenalty()
	elseif self.globalkillcount == 6 then
		managers.chat:send_message(ChatManager.GAME, nil, messages[3])
		self:CloakerReinforce(killer_id)
	elseif self.globalkillcount < 9 then
		if peer == 1 then
			managers.hud:show_hint({text = messages[1]})
		elseif peer then
			self:warn_peer(peer, is_cop)
			managers.hud:show_hint({text = messages[2]})
		end
	end
	
end

function DWP.HostageControl:CloakerReinforce(killer_id)

	if not DWP.DWdifficultycheck then
		return
	end
	
	local next_spawn_min = 50
	local next_spawn_max = 130
	
	if self.globalkillcount >= 8 then
		next_spawn_min = 30
		next_spawn_max = 80
	end
	
	-- put delayedcall that resets this loop on top so killing 6 hostages in stealth doesnt disable cloaker respawns, it will just loop untill stealth is broken
	DelayedCalls:Add("DWP_respawn_cloaker", math.random(next_spawn_min,next_spawn_max) , function()
		self:CloakerReinforce()
	end)
	
	-- Stealth phase check
	if managers.groupai:state():whisper_mode() then
		return
	end
	
	-- Decide who gets the lucky cloaker spawn on top of them. More civi kills = higher the chance
	local single_kill_chance = 0.6 / self.globalkillcount
	local peer_kills = self.PeerHostageKillCount
	
	local player_1_chance = 0.1 + (single_kill_chance * peer_kills[1])
	local player_2_chance = 0.1 + (single_kill_chance * peer_kills[2])
	local player_3_chance = 0.1 + (single_kill_chance * peer_kills[3])
	local player_4_chance = 0.1 + (single_kill_chance * peer_kills[4])
	
	local player_1_range = {0,player_1_chance}
	local player_2_range = {player_1_chance, player_1_chance + player_2_chance}
	local player_3_range = {player_2_range[2], player_2_range[2] + player_3_chance}
	local player_4_range = {player_3_range[2], 1}
	
	local spawntarget_id = 1
	
	-- decide the winner for cloaker spawn, can call itself in case winner is dead/somehow else unavailable
	local function roll_the_dice()
		
		local valid_players = {peer_1 = false,peer_2 = false,peer_3 = false,peer_4 = false}
		if managers.player:player_unit() and managers.player:player_unit():position() then
			valid_players.peer_1 = true
		end
		for i=2,4 do
			local peer = managers.network:session():peer(i)
			local unit = peer and peer:unit() or nil
			if (unit and alive(unit)) then
				valid_players["peer_"..tostring(i)] = true
			end
		end
		
		-- cancel this spawn if everyone is dead, loop continues tho
		if not valid_players.peer_1 and not valid_players.peer_2 and not valid_players.peer_3 and not valid_players.peer_4 then
			return
		end
		
		local winner = math.random()
		
		if winner <= player_4_range[2] and valid_players.peer_4 then
			spawntarget_id = 4
		end
		if winner <= player_3_range[2] and valid_players.peer_3 then
			spawntarget_id = 3
		end
		if winner <= player_2_range[2] and valid_players.peer_2 then
			spawntarget_id = 2
		end
		if winner <= player_1_range[2] and valid_players.peer_1 then
			spawntarget_id = 1
		end
		
		-- on first call for this function we spawn cloaker on whoever killed the 5th hostage if possible, later it's random with higher priorities towards hostage killers
		if killer_id then
			spawntarget_id = killer_id
			killer_id = nil
			
			-- failsafe in case our first target managed to somehow die at the same tick they triggered this func
			if not valid_players["peer_"..tostring(spawntarget_id)] then
				roll_the_dice()
			end
		end
		
	end
	roll_the_dice()
	
	local posi = Vector3(0,0,0)
	local rot = Rotation(180 - (360 / 10) * 1, 0, 0)
	local peer = ""
	local unit = ""
	
	-- update our cloaker look depending on the current map
	local cloaker = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
	if tweak_data.levels[Global.level_data.level_id].ai_group_type == "russia" then
		cloaker = Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg")
	elseif tweak_data.levels[Global.level_data.level_id].ai_group_type == "zombie" then
		cloaker = Idstring("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1")
	elseif tweak_data.levels[Global.level_data.level_id].ai_group_type == "murkywater" then
		cloaker = Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker")
	elseif tweak_data.levels[Global.level_data.level_id].ai_group_type == "federales" then
		cloaker = Idstring("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale")
	end
	
	local focus_unit = nil
	if spawntarget_id == 1 then
		if managers.player:player_unit() and managers.player:player_unit():position() then
			focus_unit = managers.player:player_unit()
			mvector3.set(posi,managers.player:player_unit():position())
		end
	else
		if managers.network:session():peer(spawntarget_id) then
			peer = managers.network:session():peer(spawntarget_id)
			unit = peer and peer:unit() or nil
			if not (unit and alive(unit)) then
				return
			end
			mvector3.set(posi,unit:position())
			focus_unit = unit
		end
	end
	
	local spook = World:spawn_unit(cloaker, posi, rot)
	local team_id = tweak_data.levels:get_default_team_ID("combatant")
	spook:movement():set_team(managers.groupai:state():team_data(team_id))
	managers.groupai:state():assign_enemy_to_group_ai(spook, team_id)
	
	call_on_next_update(function ()
		if alive(focus_unit) and alive(spook) then
			local objective = {
				type = "follow",
				follow_unit = focus_unit,
				scan = true,
				is_default = true
			}
			spook:brain():set_objective(objective)
		end
	end)
	
end

function DWP.HostageControl:ActivateDozerPenalty()
	
	local diff_spawn_rng_values = {
		[1] = 0.18,
		[2] = 0.22,
		[3] = 0.32,
		[4] = 0.42,
	}
	local diff_limit_values = {
		[1] = 7,
		[2] = 9,
		[3] = 11,
		[4] = 13,
	}
	local diff = DWP.settings_config and DWP.settings_config.difficulty or 1
	
	tweak_data.group_ai.besiege.assault.groups.Undead = {
		0,
		diff_spawn_rng_values[diff],
		diff_spawn_rng_values[diff]
	}
	tweak_data.group_ai.besiege.assault.groups.FBI_tanks = {0,0,0}
	tweak_data.group_ai.special_unit_spawn_limits.tank = diff_limit_values[diff]
	
end

-----------------------------------------------------------------------------
-- INTIMIDATION
-----------------------------------------------------------------------------

DWP.IntimidationStats = {
	[1] = {
		lights = {base = 0.2, health = 0.2},
		heavies = {base = 0.1, health = 0.1}
	},
	[2] = {
		lights = {base = 0.15, health = 0.15},
		heavies = {base = 0.08, health = 0.08}
	},
	[3] = {
		lights = {base = 0.1, health = 0.1},
		heavies = {base = 0.06, health = 0.06}
	},
	[4] = {
		lights = {base = 0.05, health = 0.05},
		heavies = {base = 0.04, health = 0.04}
	},
}
-- Change the surrender presets to harder ones. also disables turret auto repairs, because its convenient to do so here
function DWP:update_dom_values(diff)
	if not tweak_data then
		DelayedCalls:Add("DWP_DomUpdateWaitOnTweakData", 0.2, function()
			DWP:update_dom_values(diff)
		end)
	else
		if not Network:is_server() then
			return
		end
		
		-- Instant surrender preset - used by guards and cops
		local surrender_preset_easy = {
			base_chance = 1,
			significant_chance = 0,
			reasons = {
				health = {
					[1] = 0,
					[0.69] = 0
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
					[100] = 0,
					[200] = 0
				}
			}
		}
		
		-- Light swat preset
		local surrender_preset_normal = {
			base_chance = DWP.IntimidationStats[diff].lights.base,
			significant_chance = 0,
			reasons = {
				health = {
					[0.4] = DWP.IntimidationStats[diff].lights.health,
					[0] = DWP.IntimidationStats[diff].lights.health
				},
				weapon_down = 0.1,
				pants_down = 0.05
			},
			factors = {
				isolated = 0.05,
				flanked = 0.05,
				unaware_of_aggressor = 0,
				enemy_weap_cold = 0,
				aggressor_dis = {
					[100] = 0,
					[200] = 0
				}
			}
		}
		
		-- Heavy swat preset
		local surrender_preset_hard = {
			base_chance = DWP.IntimidationStats[diff].heavies.base,
			significant_chance = 0,
			reasons = {
				health = {
					[0.40] = DWP.IntimidationStats[diff].heavies.health,
					[0] = DWP.IntimidationStats[diff].heavies.health
				},
				weapon_down = 0.1,
				pants_down = 0.05
			},
			factors = {
				isolated = 0.05,
				flanked = 0.05,
				unaware_of_aggressor = 0,
				enemy_weap_cold = 0,
				aggressor_dis = {
					[100] = 0,
					[200] = 0
				}
			}
		}
		
		-- Give the guards and light cops the "easy" preset
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
		
		-- fuck these things
		tweak_data.weapon.swat_van_turret_module.AUTO_REPAIR = false
		tweak_data.weapon.aa_turret_module.AUTO_REPAIR = false
		tweak_data.weapon.crate_turret_module.AUTO_REPAIR = false
	end
end

-----------------------------------------------------------------------------
-- UTILITY
-----------------------------------------------------------------------------

function DWP.change_lobby_name(is_DW)
	if managers.network.matchmake._lobby_attributes and managers.network.matchmake.lobby_handler then
		local cur_name = tostring(managers.network.matchmake._lobby_attributes.owner_name)
		local diff = DWP.settings.difficulty
		if DWP.settings_config and DWP.settings_config.difficulty then
			diff = DWP.settings_config.difficulty
		end
		local lobby_names_on_diff = {
			[1] = "Death Wish +",
			[2] = "Death Wish ++",
			[3] = "Death Wish +++",
			[4] = "Death Wish ++++",
		}
		local new_name = managers.network.account:username()
		if is_DW then
			new_name = lobby_names_on_diff[diff].." ("..managers.network.account:username()..")"
		end
		if cur_name ~= new_name then
			managers.network.matchmake._lobby_attributes.owner_name = new_name
			managers.network.matchmake.lobby_handler:set_lobby_data(managers.network.matchmake._lobby_attributes)
		end
	end
end

function DWP:yoink_ngbto()
	DelayedCalls:Add("DWP_fuckoffngbto", 1, function()
		BLT.Mods:GetModByName("Newbies go back to overkill"):SetEnabled(false, true)
		DWP:yoink_ngbto()
	end)
end

-----------------------------------------------------------------------------
-- MENUS
-----------------------------------------------------------------------------

function DWP:linkchangelog()
	managers.network.account:overlay_activate("url", "https://github.com/irbizzelus/Death-Wish-Plus/releases")
end

-- only pops up once in the main menu
function DWP:changelog_popup()
	if not DWP.settings.changelog_msg_shown or DWP.settings.changelog_msg_shown < DWP.version_num then
		DelayedCalls:Add("DWP_showchangelogmsg_delayed", 1, function()
			local menu_options = {}
			menu_options[#menu_options+1] ={text = "Check full changelog", data = nil, callback = DWP.linkchangelog}
			menu_options[#menu_options+1] = {text = "Cancel", is_cancel_button = true}
			local message = "2.8 Changelog:\n\nThis update includes a decently large re-write of the mod's code, and along side it a major-ish balance change to a few mechanics, and as result to overall gameplay as well. If you have been playing DW+ for a long while, please comment on the mod's ModWorkShop page if this update made the mod too difficult or too easy on whichever difficulty you usually prefer to play.\n\nThe intention behind changes of this update were to reduce bulldozer spam, while making all enemies more aggressive. As to how difficulty presets should FEEL after this patch (note that the feel refers to overall difficulty, not moment to moment gameplay, as before a bulldozer squad could end your heist if you got an unlucky spawn, while otherwise gameplay was easy):\n- DW+ classic should feel slighlty easier than before\n- DW++ should feel about the same\n- Insanity should feel a bit harder\n- Suicidal should feel noticeably harder due to increased enemy aggression\n\nAs always, but arguably more importantly now, read the full changelog for the full list of changes."
			local menu = QuickMenu:new("Death Wish +", message, menu_options)
			menu:Show()
			DWP.settings.changelog_msg_shown = DWP.version_num
			DWP:Save()
		end)
	end
end