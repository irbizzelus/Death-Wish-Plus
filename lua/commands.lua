local dwp_ModPath = "mods/Death Wish Plus/"
if not DWP then
	dofile(dwp_ModPath .. "lua/DWPbase.lua")
end

-- clear existing ones every time we update our commands
DWP.CM.commands = {}

if Network:is_server() and DWP.DWdifficultycheck == true then
	
	DWP.CM:add_command("cops", {
		callback = function(sender)
			local msg = "Green FBI, blue SWAT, field sniper, Cpt. Winters' shields and medic bulldozer units were added to the mix. Special units spawn more often. All enemies have a wider variety of weapons. Bulldozers can sometimes wield the VD12 stun shotgun."
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), msg)
			else
				DWP.CM:public_chat_message(msg)
			end
		end
	})

	DWP.CM:add_command("cuffs", {
		callback = function(sender)	
			local msg = "After you begin an inteaction, any enemy that gets close enough to you can handcuff you. All enemies are able do this. You have 2 ways to get out if you are cuffed: get uncuffed by a teammate, or uncuff yourself after 60 seconds."
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), msg)
			else
				DWP.CM:public_chat_message(msg) 
			end
		end
	})

	DWP.CM:add_command("dom", {
		callback = function(sender)
			local light_stats = {base = 0.35, factors = 0.2}
			local heavy_stats = {base = 0.2, factors = 0.15}
			if (Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.difficulty == 2) or (not Utils:IsInGameState() and DWP.settings.difficulty == 2) then
				light_stats = {base = 0.25, factors = 0.2}
				heavy_stats = {base = 0.15, factors = 0.15}
			elseif (Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.difficulty == 3) or (not Utils:IsInGameState() and DWP.settings.difficulty == 3) then
				light_stats = {base = 0.2, factors = 0.1}
				heavy_stats = {base = 0.15, factors = 0}
			elseif (Utils:IsInGameState() and DWP.settings_config and DWP.settings_config.difficulty == 4) or (not Utils:IsInGameState() and DWP.settings.difficulty == 4) then
				light_stats = {base = 0.15, factors = 0.1}
				heavy_stats = {base = 0.1, factors = 0}
			end
			local msg_1 = "Street cops always give up instantly. Light swat surrender chances are set to "..tostring(light_stats.base * 100).."%. If you stun, flank or catch them during a reload, your chances are increased by "..tostring(light_stats.factors * 100).."% for each factor."
			local msg_2 = "Heavy swat surrender chances are set to "..tostring(heavy_stats.base * 100).."%. If you stun, flank or catch them during a reload, your chances are increased by "..tostring(heavy_stats.factors * 100).."% for each factor. Getting enemies to <40% hp doubles your intimidation chances."
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), msg_1)
				DWP.CM:private_chat_message(sender:id(), msg_2)
			else
				DWP.CM:public_chat_message(msg_1)
				DWP.CM:public_chat_message(msg_2)
			end
		end
	})
	
	DWP.CM:add_command("assault", {
		callback = function(sender)
			local msg = "Police assaults last longer. Breaks in-between assaults last longer and have lower enemy spawns. Amount of enemies that can exist on the map at the same time is lower, but they respawn quicker, so they can hit this limit much faster."
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), msg)
			else
				DWP.CM:public_chat_message(msg)
			end
		end
	})

	DWP.CM:add_command("hostage", {
		callback = function(sender)
			local msg_1 = "Both civilians and fully intimidated cops count towards this mechanic. Every hostage you kill or keep under control affects: chances for special enemies to appear, enemy respawn speed, and how many cops can exist on the map at the same time."
			local msg_2 = "In addition, after 6 hostage casualties, cloakers will start to randomly teleport directly to players, prioritizing those that have most amount of hostages killed. After 9 total casualties, new enemies will come to finish the job."
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), msg_1)
				DWP.CM:private_chat_message(sender:id(), msg_2)
			else
				DWP.CM:public_chat_message(msg_1)
				DWP.CM:public_chat_message(msg_2)
			end
		end
	})
	
	DWP.CM:add_command("diff", {
		callback = function(sender)
			-- add a current post fix to the diff name, does not work in the prelobby screen since the difficulty was not confirmed yet
			local fir = ""
			local sec = ""
			local thir = ""
			local fou = ""
			if DWP.settings_config and DWP.settings_config.difficulty == 1 then
				fir = " (Current)"
			elseif DWP.settings_config and DWP.settings_config.difficulty == 2 then
				sec = " (Current)"
			elseif DWP.settings_config and DWP.settings_config.difficulty == 3 then
				thir = " (Current)"
			elseif DWP.settings_config and DWP.settings_config.difficulty == 4 then
				fou = " (Current)"
			end
			local msg = string.format("DW+ difficulty affects enemy respawn speed, their amounts, special unit spawn frequency, and weapons enemies use. Higher difficulty = harder parameters. List of all 4 difficulties from easiest to hardest: DW+ classic%s; DW++%s; Insanity%s; Suicidal%s.",fir,sec,thir,fou)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), msg)
			else
				DWP.CM:public_chat_message(msg)
			end
		end
	})
	
	DWP.CM:add_command("ecm", {
		callback = function(sender)	
			local msg = "ECM vulnerability is using vanilla values, do not worry hacker player, you are okay :)"
			if (Utils:IsInGameState() and DWP.settings_config.ecm_feedback_mute and DWP.settings_config.ecm_feedback_mute >= 2) or (not Utils:IsInGameState() and DWP.settings.ecm_feedback_mute >= 2) then
				msg = "ECM stun effect both for Hacker perk and a standard deployable ECM have 20% chances to stun enemies, instead of vanilla chances of 80-100%. While ECM feedback is active, Hacker perk deck can still recieve dodge/heal bonuses, even if enemies are not stunned."
				if DWP.settings_config.ecm_feedback_mute == 3 or (not Utils:IsInGameState() and DWP.settings.ecm_feedback_mute == 3) then
					msg = "ECM stun effect both for Hacker perk and a standard deployable ECM have 0% chances to stun enemies. While ECM feedback is active, Hacker perk deck can still recieve dodge/heal bonuses, even if enemies are not visually stunned."
				end
			end
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), msg)
			else
				DWP.CM:public_chat_message(msg) 
			end
		end
	})
	
	-- if you are dicking around in here, it wouldnt take you long to figure out what this does, might as well save you 3 minutes of time
	-- this prints host's mods for clients who request them, but only once per client
	-- this command is hidden if host doesnt have a hidden mod list, but still can be activated, tho there's no reason for that, since you can see mods under player list tab
	-- however, if host's mod list is hidden, at the end of the welcome message clients will be informed of the hidden mod list, and would be given instruction on how to use this command
	-- if host uses this command, they will just recieve a random quote from the list bellow, to keep slimy mod hiders guessing what's happening
	DWP.CM:add_command("hostmods", {
		callback = function(sender)
			if sender:id() ~= 1 then
				if not DWP.players[sender:id()].requested_mods_1 then
					DWP.CM:private_chat_message(sender:id(), "This command will print all mods that lobby host has, printing every name as a seperate message, it may get really spammy if the list is really big. To confirm your request use /hostmodsconfirm")
					DWP.players[sender:id()].requested_mods_1 = true
				else
					if not DWP.players[sender:id()].requested_mods_2 then
						DWP.CM:private_chat_message(sender:id(), "As mentioned before, you can request host's mod list with /hostmodsconfirm")
					else
						DWP.CM:private_chat_message(sender:id(), "You have allready requested host's mod list.")
					end
				end
			else
				-- i know most of these, but i gotta be honest, i took a couple that i found funny from some quotes website (most of the top of this list)
				local random_message = {
					"You have died of dysentery.",
					"Praise the sun!",
					"Are you a boy or a girl?",
					"Does this unit have a soul?",
					"Stop right there, criminal scum!",
					"Do a barrel roll!",
					"Space. Space. I'm in space. SPAAAAAAACE!",
					"Grass grows, birds fly, sun shines, and brother, I hurt people.",
					"It's a-me, Mario!",
					"It's time to chew ass and kick bubblegum... and I'm all outta bubblegum.",
					"This is a bucket.",
					"There is nothing. Only warm, primordial blackness. Your conscience ferments in it — no larger than a single grain of malt. You don't have to do anything anymore. Ever. Never ever.",
					"The man does not know the bullet has entered his brain. He never will. Death comes faster than the realization.",
					-- is this a bit too dark of a quote for a small troll command that only host can see? maybe, but who cares?
					"This is real darkness. It's not death, or war, or child molestation. Real darkness has love for a face. The first death is in the heart, Harry.",
					"The pain of your absence is sharp and haunting, and I would give anything not to know it; anything but never knowing you at all (which would be worse).",
					"Science compels us to explode the sun.",
				}
				DWP.CM:private_chat_message(sender:id(), random_message[math.random(1,16)])
			end
		end
	})
	
	DWP.CM:add_command("hostmodsconfirm", {
		callback = function(sender)
			if sender:id() ~= 1 then
				if not DWP.players[sender:id()].requested_mods_2 then
					for i, mod in pairs(BLT.FindMods(BLT)) do
						DWP.CM:private_chat_message(sender:id(), tostring(mod))
					end
					DWP.players[sender:id()].requested_mods_2 = true
				else
					DWP.CM:private_chat_message(sender:id(), "You have allready requested host's mod list.")
				end
			else
				local random_message = {
					"You have died of dysentery.",
					"Praise the sun!",
					"Are you a boy or a girl?",
					"Does this unit have a soul?",
					"Stop right there, criminal scum!",
					"Do a barrel roll!",
					"Space. Space. I'm in space. SPAAAAAAACE!",
					"Grass grows, birds fly, sun shines, and brother, I hurt people.",
					"It's a-me, Mario!",
					"It's time to chew ass and kick bubblegum... and I'm all outta bubblegum.",
					"This is a bucket.",
					"There is nothing. Only warm, primordial blackness. Your conscience ferments in it — no larger than a single grain of malt. You don't have to do anything anymore. Ever. Never ever.",
					"The man does not know the bullet has entered his brain. He never will. Death comes faster than the realization.",
					-- is this a bit too dark of a quote for a small troll command that only host can see? maybe, but who cares?
					"This is real darkness. It's not death, or war, or child molestation. Real darkness has love for a face. The first death is in the heart, Harry.",
					"The pain of your absence is sharp and haunting, and I would give anything not to know it; anything but never knowing you at all (which would be worse).",
					"Science compels us to explode the sun.",
				}
				DWP.CM:private_chat_message(sender:id(), random_message[math.random(1,16)])
			end
		end
	})
	
	-- as for the constant checks bellow: they are requred in lobby/menu since user can move between contract difficultied while there, which affects what
	-- certain commands will do/print. if we are in game however, contract difficulty is set in stone, so we don't have to update our command list
	
	-- if we are a host, but not in game yet, check every 0.5 seconds that we still are a host - in case we leave our lobby
	if not Utils:IsInGameState() then
		DelayedCalls:Add("updatecommandfilewhenhost", 0.5, function()
			dofile(dwp_ModPath .. "lua/commands.lua")
		end)
	end

elseif not Utils:IsInGameState() then
	-- if we are a not a host, and not in game, recheck if we got into our own created lobby every 0.5 seconds
	DelayedCalls:Add("updatecommandfile", 0.5, function()
		dofile(dwp_ModPath .. "lua/commands.lua")
	end)
end