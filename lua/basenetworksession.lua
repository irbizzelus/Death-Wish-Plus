DWP_stats_printed = false
Hooks:PostHook(BaseNetworkSession, "on_statistics_recieved", "DWP_endgamestats", function(self, peer_id, peer_kills, peer_specials_kills, peer_head_shots, accuracy, downs)
	-- if enabled print stats in post game chat, with customizable settings
	if DWP_stats_printed == false then
		DWP_stats_printed = true
		DelayedCalls:Add("DWP:endstatannounce", 0.5, function()
			if DWP.settings.endstattoggle == true then
				local specials = ""
				local headshoots = ""
				local acc = ""
				if DWP.settings.endstatSPkills == true then specials = "(Specials)" end
				if DWP.settings.endstatheadshots == true then headshoots = " Headshots |" end
				if DWP.settings.endstataccuarcy == true then acc = " Accuarcy |" end
				local message = string.format("KDR: | Kills%s // Downs |%s%s", specials, headshoots, acc)
				DWP:statsmessage(message)
			end
		end)
	end
	DelayedCalls:Add("DWP:endstatsforpeer" .. tostring(peer_id) , 1.5, function()
		if DWP.settings.endstattoggle == true then
			local peer = managers.network:session():peer(peer_id)
			if peer and peer:has_statistics() then
				local specials = ""
				local headshoots = ""
				local acc = ""
				if DWP.settings.endstatSPkills == true then specials = "(" .. peer_specials_kills .. ")" end
				if DWP.settings.endstatheadshots == true then headshoots = " " .. peer_head_shots .. " |" end
				if DWP.settings.endstataccuarcy == true then acc = " " .. accuracy .. "%" .. " |" end
				local message = string.format("%s: | %s%s // %s |%s%s",peer:name(), peer_kills, specials, downs, headshoots, acc)
				DWP:statsmessage(message)
			end
		end
	end)
end)