-- Gameover now happens after ~33 seconds instead of 10 seconds, allowing Stockholm Syndrome to function correctly
function GroupAIStateBase:check_gameover_conditions()
	if not Network:is_server() or managers.platform:presence() ~= "Playing" or setup:has_queued_exec() then
		return false
	end

	if game_state_machine:current_state().game_ended and game_state_machine:current_state():game_ended() then
		return false
	end

	if Global.load_start_menu or Application:editor() then
		return false
	end

	if not self:whisper_mode() and self._super_syndrome_peers and self:hostage_count() > 0 then
		for _, active in pairs(self._super_syndrome_peers) do
			if active then
				return false
			end
		end
	end

	local plrs_alive = false
	local plrs_disabled = true

	for u_key, u_data in pairs(self._player_criminals) do
		plrs_alive = true

		if u_data.status ~= "dead" and u_data.status ~= "disabled" then
			plrs_disabled = false

			break
		end
	end

	local ai_alive = false
	local ai_disabled = true

	for u_key, u_data in pairs(self._ai_criminals) do
		ai_alive = true

		if u_data.status ~= "dead" and u_data.status ~= "disabled" then
			ai_disabled = false

			break
		end
	end

	local gameover = false

	if not plrs_alive and not self:is_ai_trade_possible() then
		gameover = true
	elseif plrs_disabled and not ai_alive then
		gameover = true
	elseif plrs_disabled and ai_disabled then
		gameover = true
	end

	gameover = gameover or managers.skirmish:check_gameover_conditions()

	if gameover then
		if not self._gameover_clbk then
			self._gameover_clbk = callback(self, self, "_gameover_clbk_func")

			managers.enemy:add_delayed_clbk("_gameover_clbk", self._gameover_clbk, Application:time() + 33)
		end
	elseif self._gameover_clbk then
		managers.enemy:remove_delayed_clbk("_gameover_clbk")

		self._gameover_clbk = nil
	end

	return gameover
end

if DWP.settings.hostagesbeta == true then
Hooks:PostHook(GroupAIStateBase, "hostage_killed", "DWP_hostageKilled", function(self, killer_unit)
	if DWP.DWdifficultycheck == true then
	
		if not alive(killer_unit) then
			return
		end

		if killer_unit:base() and killer_unit:base().thrower_unit then
			killer_unit = killer_unit:base():thrower_unit()

			if not alive(killer_unit) then
				return
			end
		end

		local key = killer_unit:key()
		local criminal = self._criminals[key]

		if not criminal then
			return
		end
		
		local killer_name = "Someone"
		local peer = 1
		
		-- i have no idea how to get player's name from killer_unit so we will have this nasty looking mess
		if killer_unit:base().is_local_player then
			killer_name = managers.network:session():peer(killer_unit:base()._id):name()
		elseif managers.network:session():peer(2) and managers.network:session():peer(2):unit() == killer_unit then
			killer_name = managers.network:session():peer(2):name()
			peer = managers.network:session():peer(2)
		elseif managers.network:session():peer(3) and managers.network:session():peer(3):unit() == killer_unit then
			killer_name = managers.network:session():peer(3):name()
			peer = managers.network:session():peer(3)
		elseif managers.network:session():peer(4) and managers.network:session():peer(4):unit() == killer_unit then
			killer_name = managers.network:session():peer(4):name()
			peer = managers.network:session():peer(4)
		end
		DWP.hostagekillcount = self._hostages_killed
		
		if self._hostages_killed < 3 then
			if peer == 1 then
				managers.hud:show_hint({text = "You killed a civilian! Civilian kills: "..tostring(self._hostages_killed)})
			else
				managers.network:session():send_to_peer(peer, "send_chat_message", 1, "[DW+ Hostage Control] STOP KILLING CIVILIANS "..string.upper(killer_name).."! YOU THINK THEY'RE GONNA LET YOU GO WITH ALL THAT INNOCENT BLOOD ON YOUR HANDS?")
				managers.hud:show_hint({text = tostring(killer_name).." killed a civilian! Civilian kills: "..tostring(self._hostages_killed)})
			end	
		elseif self._hostages_killed == 3 then
			managers.chat:send_message(ChatManager.GAME, nil, "[DW+ Hostage Control] 3 civilians were killed! Enemy respawn rates were increased.")
		elseif self._hostages_killed == 4 then
			if peer == 1 then
				managers.hud:show_hint({text = "You killed a civilian! Civilian kills: "..tostring(self._hostages_killed)})
			else
				managers.network:session():send_to_peer(peer, "send_chat_message", 1, "[DW+ Hostage Control] STOP KILLING CIVILIANS "..string.upper(killer_name).."! YOU THINK THEY'RE GONNA LET YOU GO WITH ALL THAT INNOCENT BLOOD ON YOUR HANDS?")
				managers.hud:show_hint({text = tostring(killer_name).." killed a civilian! Civilian kills: "..tostring(self._hostages_killed)})
			end
		elseif self._hostages_killed == 5 then
			managers.chat:send_message(ChatManager.GAME, nil, "[DW+ Hostage Control] 5 civilians were killed. You've doomed us all "..killer_name.."...")
		elseif self._hostages_killed == 6 then
			if peer == 1 then
				managers.hud:show_hint({text = "You killed a civilian! Civilian kills: "..tostring(self._hostages_killed)})
			else
				managers.network:session():send_to_peer(peer, "send_chat_message", 1, "[DW+ Hostage Control] STOP KILLING CIVILIANS "..string.upper(killer_name).."! YOU THINK THEY'RE GONNA LET YOU GO WITH ALL THAT INNOCENT BLOOD ON YOUR HANDS?")
				managers.hud:show_hint({text = tostring(killer_name).." killed a civilian! Civilian kills: "..tostring(self._hostages_killed)})
			end
		elseif self._hostages_killed == 7 then
			managers.chat:send_message(ChatManager.GAME, nil, "[DW+ Hostage Control] 7 civilians killed. Enemy respawn rates are now doubled.")
		end
		
		if self._hostages_killed == 5 then
			tweak_data.group_ai.besiege.assault.groups.Undead = {
				0.42,
				0.42,
				0.42
			}
			tweak_data.group_ai.besiege.assault.groups.FBI_tanks = {
				0.1,
				0.1,
				0.1
			}
		end
	end
end)
end