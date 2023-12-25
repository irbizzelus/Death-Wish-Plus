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
				DWP.CM:private_chat_message(sender:id(), "You can use chat commands to get more info on gameplay changes of DW+ mod using /dom or other commands mentioned above, these messages are sent only to you, to prevent spam for other players. You can also use /med or /ammo in game to quickly ask for aid.")
			else
				DWP.CM:private_chat_message(sender:id(), "You can use /med and /ammo for quick aid requests. You can also use commands like /dom to print informative global messages in chat for everyone to read. Normally info commands are sent privately if requested by joined players.")
			end
		end
	})
	
	DWP.CM:add_command("assault", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "All tactical units from other difficulties (like green FBI or blue SWAT's) are included. Field snipers and Winters shileds are also present. Special unit limit is increased. Green bulldozer replaced with a medic bulldozer.")
			else
				DWP.CM:public_chat_message("All tactical units from other difficulties (like green FBI or blue SWAT's) are included. Field snipers and Winters shileds are also present. Special unit limit is increased. Green bulldozer replaced with a medic bulldozer.")
			end
		end
	})

	DWP.CM:add_command("cuffs", {
		callback = function(sender)	
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "While you are inteacting with anything any enemy that gets close enough to you can handcuff you. All enemies can do this. You have 2 ways to get out if you are cuffed - get uncuffed by a teammate or uncuff yourself after 60 seconds.")
			else
				DWP.CM:public_chat_message("While you are inteacting with anything any enemy that gets close enough to you can handcuff you. All enemies can do this. You have 2 ways to get out if you are cuffed - get uncuffed by a teammate or uncuff yourself after 60 seconds.") 
			end
		end
	})

	DWP.CM:add_command("dom", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "All cops are harder to intimidate, but weaker enemies like normal cops, will be intimidated easier then heavily armored units. Enemies also give up easier if you:\n- Get them to less then 40% hp\n- Catch them during a reload, or when they are incapacitated")
			else
				DWP.CM:public_chat_message("All cops are harder to intimidate, but weaker enemies like normal cops, will be intimidated easier then heavily armored units. Enemies also give up easier if you:\n- Get them to less then 40% hp\n- Catch them during a reload, or when they are incapacitated")
			end
		end
	})

	DWP.CM:add_command("civi", {
		callback = function(sender)
			if sender:id() ~= 1 then
				DWP.CM:private_chat_message(sender:id(), "Having hostages increases delay between assaults. Having more then 3 hostages reduces enemy respawn rates. Killing hostages increases respawn rates. Killing enough hostages will cause new enemies to appear.")
			else
				DWP.CM:public_chat_message("Having hostages increases delay between assaults. Having more then 3 hostages reduces enemy respawn rates. Killing hostages increases respawn rates. Killing enough hostages will cause new enemies to appear.")
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