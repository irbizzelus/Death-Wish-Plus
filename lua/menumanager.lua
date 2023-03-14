-- whenever a contract is bought, check for it's difficulty to apply welcome messages and lobby rename
Hooks:PostHook(MenuCallbackHandler, "start_job", "DWP_oncontractbought", function(self, job_data)
	if job_data.difficulty == "overkill_290" then
		DWP.DWdifficultycheck = true
		if DWP.settings.lobbyname then
			DWP.curlobbyname = "Death Wish +"
			managers.network.matchmake:change_lobby_name(DWP.curlobbyname)
		end
	else
		DWP.DWdifficultycheck = false
		if DWP.settings.lobbyname then
			DWP.curlobbyname = managers.network.account:username()
			managers.network.matchmake:change_lobby_name(DWP.curlobbyname)
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

function DWP:statsmessage(message) -- send end game stats, but make sure that clients with mod recieve this message, by not adding the 'banned' prefix
	if Global.game_settings.single_player == false then
		managers.chat:_receive_message(1, "[DWP]", message, DWP.color)
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
				diff = "which includes a few "
			elseif DWP.settings.difficulty == 2 then
				diff = "running on 'DW++' difficulty. High DPS builds recommended. This mod includes some "
			elseif DWP.settings.difficulty == 3 then
				diff = "running on 'Insanity' difficulty. DS difficulty builds STRONGLY recommended. This mod includes some "
			elseif DWP.settings.difficulty == 4 then
				diff = "running on 'Suicidal' difficulty. Nothing will help you. This mod includes some "
			end
			local message = string.format("%s%s%s%s%s", "Welcome ", peer:name(), "!\nThis lobby is hosted with 'Death Wish +' (Ver. 2.4) mod installed, ", diff ,"gameplay changes:")
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
			local cuffs = "\n- Enemies CAN HANDCUFF YOU during interactions: /cuffs"
			local dominations = "\n- All cops are harder to intimidate: /dom"
			local hostages = ""
			if DWP.settings.hostagesbeta == true then
				hostages = "\n- New bonuses/penalties for having/killing hostages: /civi"
			end
			local message = string.format("\n- Enemies respawn quicker and have more variety: /assault%s%s%s\nMore info on chat commands: /help", cuffs, dominations, hostages)
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
	dohttpreq("http://steamcommunity.com/profiles/".. user_id .. "/?l=english",
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
end

-- only pops up once in the main menu
function DWP:changelog_message()
	DelayedCalls:Add("DWP_showchangelogmsg_delayed", 1, function()
		if not DWP.settings.changelog_msg_shown or DWP.settings.changelog_msg_shown < 2.4 then
			local menu_options = {}
			menu_options[#menu_options+1] ={text = "Check full changelog", data = nil, callback = DWP_linkchangelog}
			menu_options[#menu_options+1] = {text = "Cancel", is_cancel_button = true}
			local message = "2.4 update: \n- Enemy respawn delay setting removed\n- New difficulty presets setting was added\n- Medic spawn limit for default settings was reduced from 5 to 4\n\nRespawn delay setting was not as impactful/consistent for adjusting gameplay as some older settings did (like cop limit per map), so it was reworked into new difficulty presets to make 'die hard' players enjoy true chaos with some higher settings. Also makes it more consistent when joining other player lobbies."
			local menu = QuickMenu:new("Death Wish +", message, menu_options)
			menu:Show()
			DWP.settings.changelog_msg_shown = 2.4
			DWP:Save()
		end
	end)
end

function DWP_linkchangelog()
	Steam:overlay_activate("url", "https://github.com/irbizzelus/Death-Wish-Plus/releases/latest")
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
					if managers.network.matchmake._lobby_attributes.job_id == 0 then
						if managers.network.matchmake._lobby_attributes.owner_name ~= managers.network.account:username_id() then managers.network.matchmake._lobby_attributes.owner_name = managers.network.account:username_id() end
					else
						if managers.network.matchmake._lobby_attributes.difficulty == 7 then
							if managers.network.matchmake._lobby_attributes.owner_name ~= "Death Wish +" then managers.network.matchmake._lobby_attributes.owner_name = "Death Wish +" end
						else
							if managers.network.matchmake._lobby_attributes.owner_name ~= managers.network.account:username_id() then managers.network.matchmake._lobby_attributes.owner_name = managers.network.account:username_id() end
						end
					end
				end
			end
		end
	end
end)
