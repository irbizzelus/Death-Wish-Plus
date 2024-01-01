local dwp_ModPath = "mods/Death Wish Plus/"
if not DWP then
	dofile(dwp_ModPath .. "lua/DWPbase.lua")
end

-- clear existing ones every time we update our commands
DWP.CM.commands = {}

if Network:is_server() and DWP.DWdifficultycheck == true then

	DWP.CM:add_command("help", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "You can use chat commands to get more info on gameplay changes of DW+ mod using /dom or other commands, these messages are sent only to you, to prevent spam for other players. You can also use /med or /ammo in game to quickly ask for aid.")
			else
				DWP.CM:private_chat_message(sender:id(), "You can use /med and /ammo for quick aid requests. You can also use commands like /dom to print informative global messages in chat for everyone to read. Normally info commands are sent privately if requested by joined players.")
			end
		end
	})
	
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
				DWP.CM:private_chat_message(sender:id(), "Police assaults last almost 2x longer, but breaks in-between assault also last 3x longer. Amount of enemies that can exist on the map at the same time is lower, but they respawn quicker, so they can hit this limit much faster.")
			else
				DWP.CM:public_chat_message("Police assaults last almost 2x longer, but breaks in-between assault also last 3x longer. Amount of enemies that can exist on the map at the same time is lower, but they respawn quicker, so they can hit this limit much faster.")
			end
		end
	})

	DWP.CM:add_command("hostage", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "Both civilians and fully intimidated cops count towards this mechanic. Every hostage you kill/control (up to 5 for both killed/controlled), speeds up/slows down enemy respawn rates, and increases/decreases chances for special enemies to appear.")
				DWP.CM:private_chat_message(sender:id(), "In addition, after 5 total casualties cloakers will sometimes teleport directly to players, prioritizing those that have most amount of hostages killed. After 7 total casualties, new enemies will come to finish the job.")
			else
				DWP.CM:public_chat_message("Both civiliands and fully intimidated cops count towards this mechanic. Every hostage you kill/control (up to 5 for both killed/controlled), speeds up/slows down enemy respawn rates, and increases/decreases chances for special enemies to appear.")
				DWP.CM:public_chat_message("In addition, after 5 hostage casualties cloakers will sometimes teleport directly to players, prioritizing those that have most amount of hostages killed. After 7 total casualties, new enemies will come to finish the job.")
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
			local msg = string.format("DW+ difficulty affects amount of cops on the map, their respawn speed, and amount of special units. Higher difficulty means harder parameters. List of difficulties from easiest to hardest: DW+ classic%s; DW++%s; Insanity%s; Suicidal%s.",fir,sec,thir,fou)
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
			local msg = " needs a MEDIC bag. Help your team."
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
			local msg = " ran out of AMMO. Help your team."
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