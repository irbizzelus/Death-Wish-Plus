function DWP_CM:is_playing()
	if not BaseNetworkHandler then 
		return false
	end
	return BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
end