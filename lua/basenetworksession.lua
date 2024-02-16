-- this should never happen here
if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- its a bit better if we dont have duplication of our name in endstats to avoid this kind of shit: "player: player: 240(50)/2", tho clients will still see it, sadly there's no good way around it
local function DWP_statsmessage(message)
	if Network:is_server() then
		-- msg ourselves first, with a nice looking prefix
		managers.chat:_receive_message(1, "[DW+]", message, DWP.color)
		if DWP.settings.endstats_public then
			for i=2,4 do
				local peer = managers.network:session():peer(i)
				if peer then
					peer:send("send_chat_message", ChatManager.GAME, message)
				end
			end
		end
	end
end

Hooks:PostHook(BaseNetworkSession, "on_statistics_recieved", "DWP_endgamestats", function(self, peer_id, peer_kills, peer_specials_kills, peer_head_shots, accuracy, downs)
	-- if enabled, print stats in post game chat with customizable settings
	-- this part is the first message that creates a "header" explaining each column below
	if not DWP.end_stats_header_printed then
		DWP.end_stats_header_printed = true
		DelayedCalls:Add("DWP_endStatsAnnounce", 0.5, function()
			if DWP.settings.endstats_enabled then
				local specials = ""
				local headshoots = ""
				local acc = ""
				if DWP.settings.endstats_specials then specials = "(Specials)" end
				if DWP.settings.endstats_headshots then headshoots = " Headshots |" end
				if DWP.settings.endstats_accuracy then acc = " Accuracy |" end
				local message = "KDR: | Kills"..specials.." // Downs |"..headshoots..acc
				DWP_statsmessage(message)
			end
		end)
	end
	
	-- same as above, but print actual numerical values that we have for each existing player
	DelayedCalls:Add("DWP_endStatsForPeer_"..tostring(peer_id) , 1.25, function()
		if DWP.settings.endstats_enabled then
			local peer = managers.network:session():peer(peer_id)
			if peer and peer:has_statistics() then
				local specials = ""
				local headshoots = ""
				local acc = ""
				if DWP.settings.endstats_specials then specials = "(" .. peer_specials_kills .. ")" end
				if DWP.settings.endstats_headshots then headshoots = " " .. peer_head_shots .. " |" end
				if DWP.settings.endstats_accuracy then acc = " " .. accuracy .. "%" .. " |" end
				local message = peer:name()..": | "..peer_kills..specials.." // "..downs.." |"..headshoots..acc
				DWP_statsmessage(message)
			end
		end
	end)
end)