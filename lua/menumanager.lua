if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

Hooks:Add('LocalizationManagerPostInit', 'DWP_option_loc', function(loc)--maybe translations will be added in the future, but i doubt it
	DWP:Load()
	loc:load_localization_file(DWP._path .. 'menu/DWPmenu_en.txt', false)
end)

-- all the setting that can be changes in the mod's settings in game
Hooks:Add('MenuManagerInitialize', 'DWP_init', function(menu_manager)

	MenuCallbackHandler.DWPsave = function(this, item)
		DWP:Save()
	end

	MenuCallbackHandler.DWPcb_donothing = function(this, item)
		--nothingness
	end
	
	MenuCallbackHandler.DWPcb_hostagesbeta = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_DSdozer = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_marshal_uniform = function(this, item)
		DWP.settings.marshal_uniform = tonumber(item:value())
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_difficulty = function(this, item)
		DWP.settings.difficulty = tonumber(item:value())
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_assforce_pool = function(this, item)
		DWP.settings.assforce_pool = tonumber(item:value())
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_assduration = function(this, item)
		DWP.settings.assduration = tonumber(item:value())
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_gameplay_defaults = function(this, item)	
		DWP.menu_node._items_list[3].selected = 2
		DWP.settings.hostagesbeta = false
		
		DWP.menu_node._items_list[4]._current_index = 1
		DWP.settings.difficulty = 1
		
		DWP.menu_node._items_list[5]._value = 400
		DWP.settings.assforce_pool = 400
		
		DWP.menu_node._items_list[6]._value = 330
		DWP.settings.assduration = 330
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(DWP.menu_node)
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_lobbyname = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_endstattoggle = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_endstatSPkills = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_endstatheadshots = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_endstataccuarcy = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_skillinfo = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
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
	
	MenuCallbackHandler.DWPcb_infomsgpublic = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_statsmsgpublic = function(this, item)
		DWP.settings[item:name()] = item:value() == 'on'
		DWP:Save()
	end
	
	MenuCallbackHandler.DWPcb_patch_notes = function(this, item)
		managers.network.account:overlay_activate("url", "https://github.com/irbizzelus/Death-Wish-Plus/releases")
	end
	
	-- any time host changes lobby attributes, update lobby name
	Hooks:PostHook(MenuCallbackHandler, "update_matchmake_attributes", "DWP_swapname_on_attributes_update", function()
		if DWP.settings.lobbyname then
			if DWP.curlobbyname ~= nil then
				DWP.change_lobby_name(DWP.curlobbyname)
			else
				DWP.change_lobby_name(managers.network.account:username_id())
			end
		end
	end)

	DWP:Load()

	MenuHelper:LoadFromJsonFile(DWP._path .. 'menu/DWPmenu.txt', DWP, DWP.settings)
end)

-- whenever a contract is bought, check for it's difficulty to apply welcome messages and lobby rename
Hooks:PostHook(MenuCallbackHandler, "start_job", "DWP_oncontractbought", function(self, job_data)
	if job_data.difficulty == "overkill_290" then
		DWP.DWdifficultycheck = true
		if DWP.settings.lobbyname then
			DWP.curlobbyname = "Death Wish +"
			DWP.change_lobby_name(DWP.curlobbyname)
		end
	else
		DWP.DWdifficultycheck = false
		if DWP.settings.lobbyname then
			DWP.curlobbyname = managers.network.account:username()
			DWP.change_lobby_name(DWP.curlobbyname)
		end
	end
end)

function DWP:infotopeers(message) -- if host with public messagin on, send whatever msg we get with a prefix
	if Network:is_server() and DWP.settings.infomsgpublic == true then
		for i=2,4 do
			local peer = managers.network:session():peer(i)
			if peer then
				peer:send("send_chat_message", ChatManager.GAME, DWP.statprefix .. ": " .. message)
			end
		end
	end
end

function DWP:infomessages(message, private) -- send ourselves a message
	if Global.game_settings.single_player == false then
		managers.chat:_receive_message(1, DWP.statprefix, message, DWP.color)
		if not private then
			DWP:infotopeers(message)
		end
	end
end

function DWP:statspublicmessage(message) -- quick fix before release, read below
	if Network:is_server() and DWP.settings.statsmsgpublic == true then
		for i=2,4 do
			local peer = managers.network:session():peer(i)
			if peer then
				peer:send("send_chat_message", ChatManager.GAME, message)
			end
		end
	end
end

function DWP:statsmessage(message) -- send end game stats, but make sure that clients with DW+ mod recieve this message, by not adding the 'DWP_STATS' prefix that clients with DW+ mod ignore and dont recieve to avoid duplication of player info messages
	if Global.game_settings.single_player == false then
		managers.chat:_receive_message(1, "[DW+]", message, DWP.color)
		DWP:statspublicmessage(message)
	end
end

function DWP:plyerjoin(peer_id) -- print weclome msg for clients, when not in game
	local peer = managers.network:session():peer(peer_id)
	if peer then
		if Network:is_server() then
			if not Utils:IsInGameState() then
				DWP:welcomemsg1(peer_id)
				DWP:welcomemsg2(peer_id)
			end
		end
	end
end

function DWP:welcomemsg1(peer_id) -- welcome msg for clients
	local peer = managers.network:session():peer(peer_id)
	if Network:is_server() and DWP.DWdifficultycheck == true then
		DelayedCalls:Add("DWP:DWwelcomemsg1topeer" .. tostring(peer_id), 2, function()
			local diff
			if DWP.settings.difficulty == 1 then
				diff = "using high DPS builds is advised."
			elseif DWP.settings.difficulty == 2 then
				diff = "running on 'DW++' difficulty. High DPS builds STRONGLY recommended."
			elseif DWP.settings.difficulty == 3 then
				diff = "running on 'Insanity' difficulty. DS difficulty builds STRONGLY recommended."
			elseif DWP.settings.difficulty == 4 then
				diff = "running on 'Suicidal' difficulty. It CAN feel harder then DS difficulty."
			end
			local message = string.format("%s%s%s%s%s", "Welcome ", peer:name(), "!\nThis lobby is hosted with 'Death Wish +' (Ver. 2.4.4) mod installed, ", diff ," This mod includes following gameplay changes:")
			if managers.network:session() and managers.network:session():peers() then
				local peer = managers.network:session():peer(peer_id)
				if peer then
					peer:send("send_chat_message", ChatManager.GAME, message)
				end
			end
		end)
	end
end

function DWP:welcomemsg2(peer_id)
	local tosent = peer_id
	local peer = managers.network:session():peer(peer_id)
	if Network:is_server() and DWP.DWdifficultycheck == true then
		DelayedCalls:Add("DWP:DWwelcomemsg2topeer" .. tostring(peer_id), 2.5, function()
			local hostages = ""
			if DWP.settings.hostagesbeta == true then
				hostages = "\n- New bonuses/penalties for having/killing hostages: /civi"
			end
			local message = string.format("\n- Enemies respawn quicker and have more variety: /assault\n- All cops are harder to intimidate: /dom\n- Enemies CAN HANDCUFF YOU during interactions: /cuffs%s\nMore info on chat commands: /help", hostages)
			if managers.network:session() and managers.network:session():peers() then
				local peer = managers.network:session():peer(peer_id)
				if peer then
					peer:send("send_chat_message", ChatManager.GAME, message)
				end
			end
		end)
	end
end

function DWP:skills(peer_id) -- get peer's id, get their skills, print messages with info, only once
	if managers.network:session() and managers.network:session():peers() then
		local peer = managers.network:session():peer(peer_id)
		if peer then
			if peer:skills() ~= nil then
				local skills = string.split(string.split(peer:skills(), "-")[1], "_")
				local perk_deck = string.split(string.split(peer:skills(), "-")[2], "_")
				local perk_deck_id = tonumber(perk_deck[1])
				local perk_deck_completion = tonumber(perk_deck[2])
				local skillsum = 0
				for k,v in pairs(skills) do
					skillsum = skillsum + v
				end
				local message = string.format("%s: |%s skill points used| |%s %s/9|", peer:name(), skillsum, managers.localization:text("menu_st_spec_" .. perk_deck_id), perk_deck_completion)
				if perk_deck_id > 23 then -- update this when, if ever, a new perk is added
					message = string.format("%s: |%s skill points used| |%s %s/9|", peer:name(), skillsum, "Custom perk deck", perk_deck_completion)
				end
				if DWP.settings.skillinfo == true then
					if DWP.players[peer_id][1] ~= true then
						DWP:infomessages(message)
						if not DWP.loadcomplete then
							table.insert(DWP.synced, {message})
						end
						DWP.players[peer_id][1] = true
					end
				end
			end
		end
	end
end


function DWP:returnplayerhours(peer_id, user_id) -- same as above, but for hours and only needs to be printed on first join
if DWP.players[peer_id][2] ~= 0 then
	local hours = nil
	local peer = managers.network:session():peer(peer_id)
	local steam_id = managers.network:session():peer(peer_id)._account_id
	--MenuCallbackHandler:is_steam()
	if peer:account_type() == Idstring("STEAM") then
		dohttpreq("http://steamcommunity.com/profiles/".. steam_id .. "/?l=english",
		function(page)
			local _, hours_start = string.find(page, '<div class="game_info_details">')
			if hours_start then
				local hours_ends = string.find(page, '<div class="game_name"><a', hours_start)
				if hours_ends then
					hours = (string.sub(page, hours_start, hours_ends))
					hours = string.gsub(hours, "	", "")
					hours = string.gsub(hours, "hrs on record<br>", "")
					hours = string.gsub(hours, "<", "")
					hours = string.gsub(hours, ">", "")
					hours = string.split(hours, "\n")
					hours = hours[2]
					hours = string.gsub(hours, ",", "")
					hours = (math.floor((hours + 1/2)/1) * 1)
					hours = tonumber(hours)
					if hours ~= nil then
						hours = (math.floor((hours + 1/2)/1) * 1)
					end
				end
			end
			if hours == nil then
				hours = "??"
			end
			if DWP.settings.hourinfo == true then
				local infamy = "."
				if DWP.settings.infamy == true then
					infamy = ", with level " .. tostring(peer:rank()) .. " infamy."
				end
				local message = string.format("%s has %s hours%s", peer:name(), hours, infamy)
				if DWP.players[peer_id][2] == true then
					if managers.network:session():local_peer():id() ~= peer:id() then -- dont send hours info about ourselves
						DWP:infomessages(message)
						DWP.players[peer_id][2] = 0
					end
				end
			end
		end)
	end
	-- we divide them, because we cant execute code bellow untill the steam page is loaded, or we get nil hours
	if peer:account_type() == Idstring("EPIC") then
		if DWP.settings.hourinfo == true then
			local infamy = "."
			if DWP.settings.infamy == true then
				infamy = ", with level " .. tostring(peer:rank()) .. " infamy."
			end
			hours = "Epic launcher"
			local message = string.format("%s is on %s account%s", peer:name(), hours, infamy)
			if DWP.players[peer_id][2] == true then
				if managers.network:session():local_peer():id() ~= peer:id() then
					DWP:infomessages(message)
					DWP.players[peer_id][2] = 0
				end
			end
		end
	end
end
end

-- only pops up once in the main menu
function DWP:changelog_message()
	DelayedCalls:Add("DWP_showchangelogmsg_delayed", 1, function()
		if not DWP.settings.changelog_msg_shown or DWP.settings.changelog_msg_shown < 2.441 then
			local menu_options = {}
			menu_options[#menu_options+1] ={text = "Check full changelog", data = nil, callback = DWP_linkchangelog}
			menu_options[#menu_options+1] = {text = "Cancel", is_cancel_button = true}
			local message = "2.4.41 Changelog:\n- Updated 'No Mercy' heist starting waves, and fixed a rare crash."
			local menu = QuickMenu:new("Death Wish +", message, menu_options)
			menu:Show()
			DWP.settings.changelog_msg_shown = 2.441
			DWP:Save()
		end
	end)
end

function DWP_linkchangelog()
	managers.network.account:overlay_activate("url", "https://github.com/irbizzelus/Death-Wish-Plus/releases/latest")
end

Hooks:PostHook(MenuManager, "_node_selected", "DWP:Node", function(self, menu_name, node)
	-- clear player's skill print check, if in main menu
	if type(node) == "table" and node._parameters.name == "main" then
		DWP.changelog_message()
		for i=1,4 do
			for j=1,2 do
				DWP.players[i][j] = 0
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
							managers.network.matchmake._lobby_attributes.owner_name = managers.network.account:username_id()
							managers.network.matchmake.lobby_handler:set_lobby_data(managers.network.matchmake._lobby_attributes)
						end
					else
						if managers.network.matchmake._lobby_attributes.difficulty == 7 then
							if managers.network.matchmake._lobby_attributes.owner_name ~= "Death Wish +" then
								managers.network.matchmake._lobby_attributes.owner_name = "Death Wish +"
								managers.network.matchmake.lobby_handler:set_lobby_data(managers.network.matchmake._lobby_attributes)
							end
						else
							if managers.network.matchmake._lobby_attributes.owner_name ~= managers.network.account:username_id() then
								managers.network.matchmake._lobby_attributes.owner_name = managers.network.account:username_id()
								managers.network.matchmake.lobby_handler:set_lobby_data(managers.network.matchmake._lobby_attributes)
							end
						end
					end
				end
			end
		end
	end
end)
