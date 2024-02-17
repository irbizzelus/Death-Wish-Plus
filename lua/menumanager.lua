if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

Hooks:Add('LocalizationManagerPostInit', 'DWP_option_loc', function(loc)--maybe translations will be added in the future, but i doubt it
	DWP:Load()
	loc:load_localization_file(DWP._path .. 'menu/DWPmenu_en.txt', false)
end)

-- all the setting that can be changes in the mod's settings in game
Hooks:Add('MenuManagerInitialize', 'DWP_init', function(menu_manager)

	-- menu backout
	MenuCallbackHandler.DWPsave = function(this, item)
		DWP:Save()
	end
	
	-- header buttons
	MenuCallbackHandler.DWPcb_donothing = function(this, item)
		--nothingness
	end
	
	-- gameplay
	MenuCallbackHandler.DWPcb_difficulty = function(this, item)
		DWP.settings.difficulty = tonumber(item:value())
		if not Utils:IsInGameState() and managers.network and managers.network.matchmake then
			DWP.change_lobby_name(DWP.DWdifficultycheck)
		end
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_assforce_pool = function(this, item)
		DWP.settings.assforce_pool = tonumber(item:value())
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_hostage_control = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_deathSquadSniperHighlight = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_gameplay_defaults = function(this, item)
		DWP.menu_node._items_list[3]._current_index = 1
		DWP.settings.difficulty = 1
		if not Utils:IsInGameState() and managers.network and managers.network.matchmake then
			DWP.change_lobby_name(DWP.DWdifficultycheck)
		end
		
		DWP.menu_node._items_list[4]._value = 400
		DWP.settings.assforce_pool = 400
		
		DWP.menu_node._items_list[5].selected = 1
		DWP.settings.hostage_control = true
		
		DWP.menu_node._items_list[6].selected = 1
		DWP.settings.deathSquadSniperHighlight = true
		
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(DWP.menu_node)
		DWP:Save()
	end
	
	-- visuals
	MenuCallbackHandler.DWPcb_DSdozer = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_marshal_uniform = function(this, item)
		DWP.settings.marshal_uniform = tonumber(item:value())
		DWP:Save()
	end
	
	-- info msg
	MenuCallbackHandler.DWPcb_skills_showcase = function(this, item)
		DWP.settings.skills_showcase = tonumber(item:value())
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_hourinfo = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_infamy = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	-- end score
	MenuCallbackHandler.DWPcb_endstattoggle = function(this, item)
		DWP.settings.endstats_enabled = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_statsmsgpublic = function(this, item)
		DWP.settings.endstats_public = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_endstatSPkills = function(this, item)
		DWP.settings.endstats_specials = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_endstatheadshots = function(this, item)
		DWP.settings.endstats_headshots = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_endstataccuarcy = function(this, item)
		DWP.settings.endstats_accuracy = item:value() == 'on'
		DWP:Save()
	end
	
	-- misc
	MenuCallbackHandler.DWPcb_lobbyname = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_patch_notes = function(this, item)
		managers.network.account:overlay_activate("url", "https://github.com/irbizzelus/Death-Wish-Plus/releases")
	end

	DWP:Load()

	MenuHelper:LoadFromJsonFile(DWP._path .. 'menu/DWPmenu.txt', DWP, DWP.settings)
end)

-- any time host changes lobby attributes, update lobby name
Hooks:PostHook(MenuCallbackHandler, "update_matchmake_attributes", "DWP_swapname_on_attributes_update", function()
	if DWP.settings.lobbyname then
		DWP.change_lobby_name(DWP.DWdifficultycheck)
	end
end)

-- whenever a contract is bought, check for it's difficulty to apply welcome messages and lobby rename
Hooks:PostHook(MenuCallbackHandler, "start_job", "DWP_oncontractbought", function(self, job_data)
	if job_data.difficulty == "overkill_290" then
		DWP.DWdifficultycheck = true
		if DWP.settings.lobbyname then
			DWP.change_lobby_name(true)
		end
	else
		DWP.DWdifficultycheck = false
		if DWP.settings.lobbyname then
			DWP.change_lobby_name(false)
		end
	end
end)

function DWP_linkchangelog()
	managers.network.account:overlay_activate("url", "https://github.com/irbizzelus/Death-Wish-Plus/releases/latest")
end

-- only pops up once in the main menu
function DWP:changelog_message()
	if not DWP.settings.changelog_msg_shown or DWP.settings.changelog_msg_shown < 2.5 then
		DelayedCalls:Add("DWP_showchangelogmsg_delayed", 1, function()
			local menu_options = {}
			menu_options[#menu_options+1] ={text = "Check full changelog", data = nil, callback = DWP_linkchangelog}
			menu_options[#menu_options+1] = {text = "Cancel", is_cancel_button = true}
			local message = "2.5 Changelog:\n- TBA."
			local menu = QuickMenu:new("Death Wish +", message, menu_options)
			menu:Show()
			DWP.settings.changelog_msg_shown = 2.5
			DWP:Save()
		end)
	end
end

Hooks:PostHook(MenuManager, "_node_selected", "DWP:Node", function(self, menu_name, node)
	-- clear peer's vars if we quit to main menu
	if type(node) == "table" and node._parameters.name == "main" then
		DWP.changelog_message()
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
		-- clear and warn about NGBTO incompatibility
		if NoobJoin then
			local plyrs = deep_clone(NoobJoin.Players)
			NoobJoin = {}
			NoobJoin.Players = plyrs
			function NoobJoin:Show_Update_message()
				DelayedCalls:Add("DWP_show_NGBTO_warning", 0.3, function()
					local menu_options = {}
					menu_options[1] = {text = "Ok", is_cancel_button = true}
					local menu = QuickMenu:new("Death Wish +", "Death Wish + is incompatible with NGBTO (newbies go back to overkill) and will cause crashes mid game. Remove NGBTO to avoid crashes and this message.\n\nIf you want to limit access to your lobby use TDLQ's 'Lobby settings' mod. You can find it on their web site, NOT modworkshop.", menu_options)
					menu:Show()
				end)
			end
		end
	end
	if type(node) == "table" and node._parameters.menu_id == "DWPmenu" then
		DWP.menu_node = node
	end
	if type(node) == "table" and node._parameters.name == "lobby" then
		-- whenever in the lobby as host make sure to set lobby name to whatever it should be, depending on current contract difficulty and such
		if DWP.settings.lobbyname then
			if managers.network.matchmake._lobby_attributes then
				if Network:is_server() then
					if managers.network.matchmake._lobby_attributes.job_id == 0 and managers.network.matchmake.lobby_handler then
						if managers.network.matchmake._lobby_attributes.owner_name ~= managers.network.account:username_id() then
							DWP.change_lobby_name(false)
						end
					else
						if managers.network.matchmake._lobby_attributes.difficulty == 7 then
							if managers.network.matchmake._lobby_attributes.owner_name == managers.network.account:username_id() then
								DWP.change_lobby_name(true)
							end
						else
							if managers.network.matchmake._lobby_attributes.owner_name ~= managers.network.account:username_id() then
								DWP.change_lobby_name(false)
							end
						end
					end
				end
			end
		end
	end
end)
