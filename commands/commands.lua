dofile("mods/Death Wish Plus/lua/DWPbase.lua")

-- all chat commands with their propeties 

-- clear existing commands if we have them. Only used for host/client checks in the lobby. During testing this would help test command's code w/o restarting the game session, since we could just reload this file
DWP_CM.commands = {}

if Network:is_server() then
DWP_CM:add_command("help", {
	callback = function(args, sender)
		if sender:id() ~= 1 then
			if DWP.DWdifficultycheck == true then
				DWP_CM:send_message(sender:id(), string.format("You can use chat commands to get more info on gameplay changes of DW+ using '/dom' or other commands mentioned above, these messages are sent only to you, to prevent spam for other players. You can also use /med or /ammo in game to quickly ask for aid."))
			else
				DWP_CM:send_message(sender:id(), string.format("This lobby runs 'Death Wish +' mod which includes a few chat commands you can use like /med or /ammo to quickly ask for aid."))
			end
		else
			DWP_CM:send_message(sender:id(), string.format("DW+ includes chat commands for all players, for example /med and /ammo for quick aid requests. You can also use commands like /dom to print informative global messages in chat for everyone to read. Normally such commands are sent privately if requested."))
		end
	end,
})

if DWP.DWdifficultycheck == true then
DWP_CM:add_command("assault", {
	callback = function(args, sender)
		if sender:id() ~= 1 then
			DWP_CM:send_message(sender:id(), string.format("All tactical units from other difficulties (like green FBI or blue SWAT's) are included. Field snipers and Winters shileds are also present. Special unit limit is increased. Green bulldozer replaced with a medic bulldozer."))
		else -- print these messages publicly if host requests them
			DWP_CM:message(string.format("All tactical units from other difficulties (like green FBI or blue SWAT's) are included. Field snipers and Winters shileds are also present. Special unit limit is increased. Green bulldozer replaced with a medic bulldozer."), nil, nil, true)
		end
	end,
})

DWP_CM:add_command("cuffs", {
	callback = function(args, sender)	
		if sender:id() ~= 1 then
			DWP_CM:send_message(sender:id(), string.format("While you are inteacting with anything enemy closest to you will try to come and handcuff you. All enemies can do this. You have 2 ways to get out if you are cuffed - get uncuffed by a teammate or uncuff yourself after 60 seconds."))
		else
			DWP_CM:message(string.format("While you are inteacting with anything enemy closest to you will try to come and handcuff you. All enemies can do this. You have 2 ways to get out if you are cuffed - get uncuffed by a teammate or uncuff yourself after 60 seconds."), nil, nil, true) 
		end
	end,
})

DWP_CM:add_command("dom", {
	callback = function(args, sender)
		local percent = "%"
		if sender:id() ~= 1 then
			DWP_CM:send_message(sender:id(), string.format("All cops are harder to dominate, but weaker enemies like normal cops, will be dominated easier then heavily armored units. Enemies also give up easier if you:\n- Get them to less then 40%s hp\n- Catch them during a reload, or when they are incapacitated.",percent))
		else
			DWP_CM:message(string.format("All cops are harder to dominate, but weaker enemies like normal cops, will be dominated easier then heavily armored units. Enemies also give up easier if you:\n- Get them to less then 40%s hp\n- Catch them during a reload, or when they are incapacitated.",percent), nil, nil, true)
		end
	end,
})

DWP_CM:add_command("civi", {
	callback = function(args, sender)
		if sender:id() ~= 1 then
			DWP_CM:send_message(sender:id(), string.format("Having hostages increases delay between assaults. Having more then 3 hostages reduces enemy respawn rates. Killing hostages increases respawn rates. Killing enough hostages will cause new enemies to appear."))
		else
			DWP_CM:message(string.format("Having hostages increases delay between assaults. Having more then 3 hostages reduces enemy respawn rates. Killing hostages increases respawn rates. Killing enough hostages will cause new enemies to appear."), nil, nil, true)
		end
	end,
})
end
DWP_CM:add_command("med", {
	in_game_only = true,
	callback = function(args)
		DWP_CM:message(string.format("Someone needs a MEDIC bag. Help your team."), nil, nil, true) return 
	end,
})

DWP_CM:add_command("ammo", {
	in_game_only = true,
	callback = function(args,sender)
		DWP_CM:message(string.format("Someone ran out of AMMO. Help your team."), nil, nil, true) return 
	end,
})

DWP_CM:add_command("say", {
	private = true,
	callback = function(args)
		local text = (args and table.concat(args, " ")) or ""
		if text == "" then
			return string.format("Error: empty message")
		end

		for _, peer in pairs(DWP_CM:peer_list()) do
			DWP_CM:send_message(peer:id(), string.format("%s", text))
		end

		local lPeer = DWP_CM:local_peer()
		DWP_CM:message(text, lPeer:name(), tweak_data.chat_colors[lPeer:id()])
	end,
})

-- constant check for game state to prevent host/client commands getting mixed, since you cant do certain things as a client 
-- this is outdated, since client commands are now gone. might remove it later, but it doesnt hurt anything so let em be for now
if not Utils:IsInGameState() then
DelayedCalls:Add("updatecommandfilewhenhost", 0.5, function() -- if we are a host, and not in game, check every 0.5 seconds that we still are a host - in case you leave your lobby
	dofile(DWP_CM._path .. "commands.lua")
end)
end

elseif not Utils:IsInGameState() then
DelayedCalls:Add("updatecommandfile", 0.5, function() -- if we are a not a host, and not in game, recheck everything every 0.5 seconds
	dofile(DWP_CM._path .. "commands.lua")
end)
end