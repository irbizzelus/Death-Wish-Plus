if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- When local player starts interacting, send a cop to arrest them + activate scan to enable cuffing from other units
Hooks:PostHook(PlayerStandard, "_start_action_interact", "DWP_cuffing_on_local_player_interaction_start", function(self)
	
	-- if we are a client and host has dsbw running, make cuffing checks fully client sided
	if Network and Network:is_client() then
		if DWP.peers_with_mod[1] then
			
			DWP.CopUtils.allowed_cuffing_time = DWP.CopUtils.allowed_cuffing_time or {0,0,0,0}
			local delay = 1.1
			local interaction_type = self._unit:movement():current_state()._interact_params.tweak_data
			if interaction_type == "revive" then
				delay = 3.1
			end
			DelayedCalls:Add("DWP_delay_for_cuff_scan_on_local", delay, function()
				DWP.CopUtils:NearbyCopAutoArrestCheck(self._unit, true)
			end)
			
		end
	elseif Network and Network:is_server() then -- if hosting make checks for self scan
		if not DWP.DWdifficultycheck then
			return
		end
		
		local interaction_type = self._unit:movement():current_state()._interact_params.tweak_data
		DWP.CopUtils:SendCopToArrestPlayer(self._unit, interaction_type)
		
		DWP.CopUtils.allowed_cuffing_time = DWP.CopUtils.allowed_cuffing_time or {0,0,0,0}
		
		if interaction_type == "revive" then
			DWP.CopUtils.allowed_cuffing_time[1] = Application:time() + 3.1
		else
			DWP.CopUtils.allowed_cuffing_time[1] = Application:time() + 1.1
		end
		DelayedCalls:Add("DWP_delay_for_cuff_scan_on_local", 1, function()
			DWP.CopUtils:NearbyCopAutoArrestCheck(self._unit, true)
		end)
	end

end)