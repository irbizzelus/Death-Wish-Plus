if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- Gameover now happens after ~31 seconds instead of 10 seconds, allowing Stockholm Syndrome to function correctly
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

			managers.enemy:add_delayed_clbk("_gameover_clbk", self._gameover_clbk, Application:time() + 31.5)
		end
	elseif self._gameover_clbk then
		managers.enemy:remove_delayed_clbk("_gameover_clbk")

		self._gameover_clbk = nil
	end

	return gameover
end

local orig_drama = GroupAIStateBase._add_drama
function GroupAIStateBase:_add_drama(amount)
	if DWP.DWdifficultycheck and (Global.level_data and Global.level_data.level_id ~= "nmh") then
		-- prevent drama from goin over 95 so we never skip anticipation. reason: longer breaks
		-- also some music anticipation tracks are 11/10, yet i almost never hear them because of this useless (gameplay wise) mechanic
		-- oh and prevent drama from beeing too low to make fade last as long as possible; thanks to update 181, this is not exploitable and gives 1 minute of free time at best
		if self._drama_data.amount + amount ~= 0.9 then
			self._drama_data.amount = 0.9
			amount = 0
		end
	elseif DWP.DWdifficultycheck == true then
		-- scripted rules for no mercy heist for first 2 waves
		-- <=1 because we dont need to skip anticipation for the 3rd wave, since the counter updates only after ancticipation ends and 3rd assault begins
		-- this does lead to increased fade after second wave is over, but it will create a perfect "they are regrouping" feeling
		if self._assault_number <= 1 then
			if (self._task_data and self._task_data.assault and (self._task_data.assault.phase == "anticipation" or self._task_data.assault.phase == "build")) and self._drama_data.amount < 0.999 then
				-- this specific part skips anticipation phase for 1 and 2nd waves, but with a tiny delay too avoid bain talking overhimself regarding the 30 second warning
				if not DWP.NMH_anticipation_skip and not DWP.NMH_delay_active then
					DWP.NMH_delay_active = true
					DelayedCalls:Add("NoMercyAnticipationSkipDelay", 5, function()
						DWP.NMH_anticipation_skip = true
					end)
				end
				if DWP.NMH_anticipation_skip then
					self._drama_data.amount = 0.999
					amount = 0
					DWP.NMH_delay_active = nil
				end
			elseif (self._task_data and self._task_data.assault and self._task_data.assault.phase == "fade") and self._drama_data.amount > 0.01 then
				self._drama_data.amount = 0.01
				amount = 0
				DWP.NMH_anticipation_skip = nil
			end
		else
			if self._drama_data.amount + amount ~= 0.9 then
				self._drama_data.amount = 0.9
				amount = 0
			end
		end
	end
	-- at the end of assault 2 on no mercy, play an overly dramatic warning in chat and a voice line from bain, cause why not
	if (Global.level_data and Global.level_data.level_id == "nmh") and self._assault_number == 2 and (self._task_data and self._task_data.assault and self._task_data.assault.phase == "fade") and not DWP.NoMercyThirdAssaultWarning then
		DWP.NoMercyThirdAssaultWarning = true
		DelayedCalls:Add("NoMercyThirdAssaultWarningCall", 30, function()
			DWP.nmh_2nd_assault_complete = true
			managers.chat:send_message(ChatManager.GAME, nil, "[DW+] Reinforcements from other agencies are regrouping outside.")
			DelayedCalls:Add("NoMercyThirdAssaultWarningCall2", 55, function()
				if managers.player:player_unit() then -- avoid crash if host is dead somehow after 2 pathetic waves
					managers.player:local_player():sound():say("Play_ban_p01",true,true)
				end
			end)
		end)
	end
	orig_drama(self, amount)
	if DWP and DWP.DWdifficultycheck then
		self:set_difficulty(1)
	end
end

local detonate_world_smoke_grenade_orig = GroupAIStateBase.detonate_world_smoke_grenade
function GroupAIStateBase:detonate_world_smoke_grenade(id)
	if DWP.DWdifficultycheck == true then
		-- disables smokes/flashes on 'No Mercy' for first 3 waves, since enemy swarm can get really bad there, additional visual clutter makes it unfun so avoid it for a bit
		if Global.level_data and Global.level_data.level_id == "nmh" and self._assault_number <= 3 then
			return
		end
	end
	detonate_world_smoke_grenade_orig(self,id)
end

local orig_diff = GroupAIStateBase.set_difficulty
function GroupAIStateBase:set_difficulty(value)
	if not DWP or not DWP.DWdifficultycheck then
		orig_diff(self, value)
		return
	end
	
	-- everything here updated the diff value which affects the following in DW+: special enemy squad spawn chances, max amount of cops on the map at the same time, and enemy respawn speed
	-- no mercy uses lowest values for assault 1 and 2, but not break in between assault 2 and 3, thus the nmh_2nd_assault_complete value
	if Global.level_data and Global.level_data.level_id == "nmh" and self._assault_number <= 2 and not DWP.nmh_2nd_assault_complete then
		if value ~= 0.001 then
			value = 0.001
		end
	-- without hostage control enabled diff always stays at 0.8, groupaitweak data values look really weird because of it
	elseif not DWP.settings_config.hostage_control and value ~= 0.8 then
		value = 0.8
	elseif DWP.settings_config.hostage_control then
		local diff_ceil = 0.8
		local host_count = self._hostage_headcount or 0
		local diff_result
		
		-- for each hostage kill increase potential max diff value
		if DWP.HostageControl.globalkillcount >= 1 then
			diff_ceil = diff_ceil + (math.clamp(DWP.HostageControl.globalkillcount, 1, 8))  * (0.2 / 8)
		end
		
		-- calculate diff based on current max value and hostage count
		diff_result = diff_ceil - (math.clamp(host_count, 0, 8) * (0.2 / 8))
		
		if value ~= diff_result then
			value = diff_result
		end
		
		-- in case current diff value matches newly calculated one, dont bother using original function again to avoid unnecessary diff ratio calculations
		if self._difficulty_value == value then
			return
		end
	end
	orig_diff(self, value)
end

-- hostage control - on civi death 
Hooks:PostHook(GroupAIStateBase, "hostage_killed", "DWP_hostageKilled", function(self, killer_unit)
	
	if not DWP.settings_config.hostage_control or not DWP.DWdifficultycheck then
		return
	end
	
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
	local killer_id = 1
	
	-- i have no idea how to get player's name from killer_unit for PEERS so we will have this nasty looking mess
	-- basically checks who killed the hostage, adds that to their kill count and remembers their name for chat messages later
	if killer_unit:base().is_local_player then
		killer_name = managers.network:session():peer(killer_unit:base()._id):name()
		DWP.HostageControl.PeerHostageKillCount[1] = DWP.HostageControl.PeerHostageKillCount[1] + 1
	elseif managers.network:session():peer(2) and managers.network:session():peer(2):unit() == killer_unit then
		peer = managers.network:session():peer(2)
		killer_name = peer:name()
		DWP.HostageControl.PeerHostageKillCount[2] = DWP.HostageControl.PeerHostageKillCount[2] + 1
		killer_id = 2
	elseif managers.network:session():peer(3) and managers.network:session():peer(3):unit() == killer_unit then
		killer_name = managers.network:session():peer(3):name()
		peer = managers.network:session():peer(3)
		DWP.HostageControl.PeerHostageKillCount[3] = DWP.HostageControl.PeerHostageKillCount[3] + 1
		killer_id = 3
	elseif managers.network:session():peer(4) and managers.network:session():peer(4):unit() == killer_unit then
		killer_name = managers.network:session():peer(4):name()
		peer = managers.network:session():peer(4)
		DWP.HostageControl.PeerHostageKillCount[4] = DWP.HostageControl.PeerHostageKillCount[4] + 1
		killer_id = 4
	end
	DWP.HostageControl.globalkillcount = DWP.HostageControl.globalkillcount + 1
	
	if DWP.HostageControl.globalkillcount < 9 and DWP.HostageControl.globalkillcount ~= 6 then
		if peer == 1 then
			managers.hud:show_hint({text = "[DW+] You killed a civilian! Hostages killed: "..tostring(DWP.HostageControl.globalkillcount)})
		else
			DWP.HostageControl:warn_peer(peer, killer_id, true)
			managers.hud:show_hint({text = "[DW+] "..tostring(killer_name).." killed a civilian! Hostages killed: "..tostring(DWP.HostageControl.globalkillcount)})
		end
	elseif DWP.HostageControl.globalkillcount == 6 then
		managers.chat:send_message(ChatManager.GAME, nil, "[DW+] 6 hostages killed. Enemy forces are almost maxed out. Also cloakers learned how to teleport?..")
		DWP.CloakerReinforce(killer_id)
	elseif DWP.HostageControl.globalkillcount == 9 then
		managers.chat:send_message(ChatManager.GAME, nil, "[DW+] 9 hostages are now dead. You can all blame "..killer_name.." for what's to come.")
		DWP:ActivateHostageControlDozerPenalty()
	end
	
end)