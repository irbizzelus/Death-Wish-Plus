Hooks:PostHook(MenuCallbackHandler, "start_job", "DWP_oncontractbought", function(self, job_data)-- whenever a contract is bought, check for it's difficulty to apply welcome messages and lobby rename
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

function DWP:statsmessage(message) -- send end game stats, but make sure that clients with mod recieve this message, by not adding the prefix
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
			local message = string.format("%s%s%s", "Welcome ", peer:name(), "!\nThis lobby is running on a modded (version 2.3.21) 'Death Wish +' difficulty with gameplay changes listed below:")
			if managers.network:session() and managers.network:session():peers() then
				local peer = managers.network:session():peer(peer_id)
				if peer then
					peer:send("send_chat_message", ChatManager.GAME, message)
				end
			end
		end)
	elseif Network:is_server() and DWP.settings.xmas_chaos == true then
		DelayedCalls:Add("DWP:DWwelcomemsg1topeer" .. tostring(peer_id), 2, function()
			local message = string.format("%s%s%s", "Welcome ", peer:name(), "!\nThis lobby is running 'Death Wish +' mod (version 2.3.21) with 'Christmas Chaos' setting enabled. For more info on what this gameplay setting does, type /xmas")
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
			local cuffs = "\n- Cops WILL TRY TO CUFF YOU during interactions: /cuffs"
			local dominations = "\n- Cops are harder to intimidate: /dom"
			local hostages = ""
			if DWP.settings.hostagesbeta == true and DWP.settings.xmas_chaos == false then
				hostages = "\n- Hostage control is enabled: /civi"
			end
			if DWP.settings.xmas_chaos == true then
				hostages = "\n- Christmas chaos is enabled: /xmas"
			end
			local message = string.format("\n- Enemies have quicker respawns and have more unit variety: /assault%s%s%s\n More info on chat commands: /help", cuffs, dominations, hostages)
			if managers.network:session() and managers.network:session():peers() then
				local peer = managers.network:session():peer(peer_id)
				if peer then
					peer:send("send_chat_message", ChatManager.GAME, message)
					if DWP.settings.respawns < 4 then
						DelayedCalls:Add("DWP:DWwelcomemsg3topeer" .. tostring(peer_id), 0.6, function()
							local msg = string.format("Also note that host is running 'Death Wish +' with quicker respawn rates compared to default DW+ settings. Enemies will overwhelm you quicker then in the base DW+. Host's respawn delay: %s",math.floor(DWP.settings.respawns*100) / 100)
							if peer then
								peer:send("send_chat_message", ChatManager.GAME, msg)
							end
						end)
					end
				end
			end
		end)
	end
end

function DWP:skills(peer_id) -- get peer's id, get their skills, print messages with info, only once pleeeease
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

function DWP:changelog_message()
	DelayedCalls:Add("DWP_showchangelogmsg_delayed", 1, function()
		if not DWP.settings.changelog_msg_shown or DWP.settings.changelog_msg_shown < 2.321 then
			local menu_options = {}
			menu_options[#menu_options+1] ={text = "Check full changelog", data = nil, callback = DWP_linkchangelog}
			menu_options[#menu_options+1] = {text = "Cancel", is_cancel_button = true}
			local message = "2.3.21 bug-fix: \n- Updated xmas chaos event description in settngs\n- Xmas chaos chat command now works on all difficulties\n- Xmas chaos no longer adjusts dozer limits on other difficulties then DW\n- Drama and dif changes from 2.3.2 no longer affect other difficulties then DW\n\n2.3.2 update: \n- Christmas event support was added. New 'christmas chaos' gameplay option was added, enabled by default\n- Changes to 'diff' and 'drama' that will change how assaults are played out, more info in the changelog\n- Bulldozer limit was reduced from 5 to 4\n- Removed smokes/flashes on 'No Mercy' heist. Might be reverted later"
			local menu = QuickMenu:new("Death Wish +", message, menu_options)
			menu:Show()
			DWP.settings.changelog_msg_shown = 2.321
			DWP:Save()
		end
	end)
end

function DWP_linkchangelog()
	Steam:overlay_activate("url", "https://github.com/irbizzelus/Death-Wish-Plus/releases/latest")
end

Hooks:PostHook(MenuManager, "_node_selected", "DWP:Node", function(self, menu_name, node) -- clear player's skill print check if in main menu
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
