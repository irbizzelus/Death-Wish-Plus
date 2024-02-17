local dwp_ModPath = "mods/Death Wish Plus/"
if not DWP then
	dofile(dwp_ModPath .. "lua/DWPbase.lua")
end

-- clear existing ones every time we update our commands
DWP.CM.commands = {}

if Network:is_server() and DWP.DWdifficultycheck == true then
	
	DWP.CM:add_command("cops", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "All tactical units from other difficulties (like green FBI or blue SWAT) are included. Field snipers and Cpt. Winters' shileds can spawn along other units. Specials are more common. Green bulldozer is replaced by a medic bulldozer.")
			else
				DWP.CM:public_chat_message("All tactical units from other difficulties (like green FBI or blue SWAT) are included. Field snipers and Cpt. Winters' shileds can spawn along other units. Specials are more common. Green bulldozer is replaced by a medic bulldozer.")
			end
		end
	})

	DWP.CM:add_command("cuffs", {
		callback = function(sender)	
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "After you begin an inteaction, any enemy that gets close enough to you can handcuff you. All enemies are able do this. You have 2 ways to get out if you are cuffed: get uncuffed by a teammate, or uncuff yourself after 60 seconds.")
			else
				DWP.CM:public_chat_message("After you begin an inteaction, any enemy that gets close enough to you can handcuff you. All enemies are able do this. You have 2 ways to get out if you are cuffed: get uncuffed by a teammate, or uncuff yourself after 60 seconds.") 
			end
		end
	})

	DWP.CM:add_command("dom", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "All cops are harder to intimidate, but weaker enemies like street cops, will be intimidated easier then heavily armored units. Enemies also give up easier if you:\n- Get them to less then 40% hp\n- Catch them during a reload, or when they are incapacitated")
			else
				DWP.CM:public_chat_message("All cops are harder to intimidate, but weaker enemies like street cops, will be intimidated easier then heavily armored units. Enemies also give up easier if you:\n- Get them to less then 40% hp\n- Catch them during a reload, or when they are incapacitated")
			end
		end
	})
	
	DWP.CM:add_command("assault", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "Police assaults last almost 2x as long, but breaks in-between assaults also last 3x longer. Amount of enemies that can exist on the map at the same time is lower, but they respawn quicker, so they can hit this limit much faster.")
			else
				DWP.CM:public_chat_message("Police assaults last almost 2x as long, but breaks in-between assaults also last 3x longer. Amount of enemies that can exist on the map at the same time is lower, but they respawn quicker, so they can hit this limit much faster.")
			end
		end
	})

	DWP.CM:add_command("hostage", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "Both civilians and fully intimidated cops count towards this mechanic. Every hostage you kill or keep under control affects chances for special enemies to appear, enemy respawn speed, and how many cops can exist on the map at the same time.")
				DWP.CM:private_chat_message(sender:id(), "In addition, after 6 hostage casualties, cloakers will start to randomly teleport directly to players, prioritizing those that have most amount of hostages killed. After 9 total casualties, new enemies will come to finish the job.")
			else
				DWP.CM:public_chat_message("Both civilians and fully intimidated cops count towards this mechanic. Every hostage you kill or keep under control affects chances for special enemies to appear, enemy respawn speed, and how many cops can exist on the map at the same time.")
				DWP.CM:public_chat_message("In addition, after 6 hostage casualties, cloakers will start to randomly teleport directly to players, prioritizing those that have most amount of hostages killed. After 9 total casualties, new enemies will come to finish the job.")
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
			local msg = string.format("DW+ difficulty affects amount of cops on the map, their respawn speed, and amount of special units. Higher difficulty = harder parameters. List of all 4 difficulties from easiest to hardest: DW+ classic%s; DW++%s; Insanity%s; Suicidal%s.",fir,sec,thir,fou)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), msg)
			else
				DWP.CM:public_chat_message(msg)
			end
		end
	})
	
	DWP.CM:add_command("med", {
		in_game_only = true,
		callback = function(sender)
			local msg = " needs a MEDIC bag! Help your team."
			if sender:name() then
				if sender:id() == 1 then
					DWP.CM:public_chat_message(msg)
				else
					DWP.CM:public_chat_message(sender:name()..msg)
				end
			else
				DWP.CM:public_chat_message("Someone"..msg)
			end
		end
	})

	DWP.CM:add_command("ammo", {
		in_game_only = true,
		callback = function(sender)
			local msg = " ran out of AMMO! Help your team."
			if sender:name() then
				if sender:id() == 1 then
					DWP.CM:public_chat_message(msg)
				else
					DWP.CM:public_chat_message(sender:name()..msg)
				end
			else
				DWP.CM:public_chat_message("Someone"..msg)
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