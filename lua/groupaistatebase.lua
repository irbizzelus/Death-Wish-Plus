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

Hooks:PostHook(GroupAIStateBase, "_add_drama", "DWP_dramaUpdate", function(self, amount)
	if DWP.DWdifficultycheck == true and (Global.level_data and Global.level_data.level_id ~= "nmh") then
		-- prevent drama from goin over 95 so we never skip anticipation. reason: longer breaks are needed with this mod
		-- also i like when bain tells me it's 10 seconds before assaults starts (thx mods), but hate when assault immediately begins right after this voice line
		-- also some of my custom music's anticipation tracks are 11/10, yet i almost never hear them because of this (useless for this mod) mechanic 
		--
		-- also prevent drama from beeing to low to make fade last as long as possible. 
		-- thanks to update 181, this is not exploitable and gives 1 minute of free time at best
		if self._drama_data.amount > 0.55 or self._drama_data.amount < 0.55 then
			self._drama_data.amount = 0.55
		end
	elseif DWP.DWdifficultycheck == true then
		-- scripted rules for no mercy heist for first 2 waves
		-- <=1 because we dont need to skip anticipation for the 3rd wave, since the counter updates only after ancticipation ends and 3rd assault begins
		-- this does lead to increased fade after second wave is over, but it will create a perfect "they are regrouping" feeling
		if self._assault_number <= 1 then
			if (self._task_data and self._task_data.assault and self._task_data.assault.phase == "anticipation") and self._drama_data.amount < 0.999 then
				self._drama_data.amount = 0.999
			elseif (self._task_data and self._task_data.assault and self._task_data.assault.phase == "fade") and self._drama_data.amount > 0.01 then
				self._drama_data.amount = 0.01
			end
		else
			if self._drama_data.amount > 0.55 or self._drama_data.amount < 0.55 then
				self._drama_data.amount = 0.55
			end
		end
	end
	-- at the end of assault 2 on no mercy, play an overly dramatic warning in chat and a voice line from bain, cause why not
	if (Global.level_data and Global.level_data.level_id == "nmh") and self._assault_number == 2 and (self._task_data and self._task_data.assault and self._task_data.assault.phase == "fade") and not DWP.NoMercyThirdAssaultWarning then
		DWP.NoMercyThirdAssaultWarning = true
		DelayedCalls:Add("NoMercyThirdAssaultWarningCall", 40, function()
			managers.chat:send_message(ChatManager.GAME, nil, "[DW+] There is talk of reinforcements from other agencies coming your way. Prepare yourselves.")
			DelayedCalls:Add("NoMercyThirdAssaultWarningCall2", 55, function()
				managers.player:local_player():sound():say("Play_ban_p01",true,true)
			end)
		end)
	end
end)

local detonate_world_smoke_grenade_orig = GroupAIStateBase.detonate_world_smoke_grenade
function GroupAIStateBase:detonate_world_smoke_grenade(id)
	if DWP.DWdifficultycheck == true then
		-- disables smokes/flashes on 'No Mercy' for first 3 waves, since enemy swarm is so bad there, additional visual clutter will just make it unfun
		if Global.level_data and Global.level_data.level_id == "nmh" and self._assault_number <= 3 then
			return
		end
	end
	detonate_world_smoke_grenade_orig(self,id)
end

Hooks:PostHook(GroupAIStateBase, "set_difficulty", "DWP_difffffff", function(self, value)
	if DWP.DWdifficultycheck == true then
		if Global.level_data and Global.level_data.level_id == "nmh" and self._assault_number <= 1 then
			if value ~= 0.001 then
				self:set_difficulty(0.001)
			end
		elseif value > 0 and value < 1 then
			self:set_difficulty(1)
		end
	end
end)

-- hostage control - on civi death 
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
		local killer_id = 1
		
		-- on first civi kill set player's kill count values to 0, otherwise just keep track of them
		DWP.HostageControl.PeerHostageKillCount[1] = DWP.HostageControl.PeerHostageKillCount[1] or 0
		DWP.HostageControl.PeerHostageKillCount[2] = DWP.HostageControl.PeerHostageKillCount[2] or 0
		DWP.HostageControl.PeerHostageKillCount[3] = DWP.HostageControl.PeerHostageKillCount[3] or 0
		DWP.HostageControl.PeerHostageKillCount[4] = DWP.HostageControl.PeerHostageKillCount[4] or 0
		
		-- i have no idea how to get player's name from killer_unit for PEERS so we will have this nasty looking mess
		-- basically checks who killed the hostage, adds that to their kill count and remembers their name for chat messages later
		if killer_unit:base().is_local_player then
			killer_name = managers.network:session():peer(killer_unit:base()._id):name()
			DWP.HostageControl.PeerHostageKillCount[1] = DWP.HostageControl.PeerHostageKillCount[1] + 1
		elseif managers.network:session():peer(2) and managers.network:session():peer(2):unit() == killer_unit then
			killer_name = managers.network:session():peer(2):name()
			peer = managers.network:session():peer(2)
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
		DWP.HostageControl.globalkillcount = self._hostages_killed
		
		if self._hostages_killed < 3 or self._hostages_killed == 4 or self._hostages_killed == 6 then
			if peer == 1 then
				managers.hud:show_hint({text = "You killed a civilian! Civilian kills: "..tostring(self._hostages_killed)})
			else
				local message_1 = "[DW+ Hostage Control] Stop killing civilians "..killer_name.."!"
				local message_2 = "[DW+ Hostage Control] They're gonna come down harder on us if you kill civilians "..killer_name.."!"
				local message_3 = "[DW+ Hostage Control] STOP KILLING CIVILIANS "..string.upper(killer_name).."! YOU THINK THEY'RE GONNA LET YOU GO WITH ALL THAT INNOCENT BLOOD ON YOUR HANDS?"
				
				-- creates different messages for clients depending on how many civis they have killed so far
				-- these messages only appear when there is no global message, and is only sent to the killer player
				if DWP.HostageControl.PeerHostageKillCount[killer_id] == 1 then
					managers.network:session():send_to_peer(peer, "send_chat_message", 1, message_1)
				elseif DWP.HostageControl.PeerHostageKillCount[killer_id] == 2 then
					managers.network:session():send_to_peer(peer, "send_chat_message", 1, message_2)
				elseif DWP.HostageControl.PeerHostageKillCount[killer_id] >= 3 then
					managers.network:session():send_to_peer(peer, "send_chat_message", 1, message_3)
				end
				
				managers.hud:show_hint({text = tostring(killer_name).." killed a civilian! Civilian kills: "..tostring(self._hostages_killed)})
			end
		-- global messages that dont care for who killed the hostage, except for the dooming one at the end
		elseif self._hostages_killed == 3 then
			managers.chat:send_message(ChatManager.GAME, nil, "[DW+ Hostage Control] 3 civilians murdered. Enemy respawn rates were increased.")
		elseif self._hostages_killed == 5 then
			managers.chat:send_message(ChatManager.GAME, nil, "[DW+ Hostage Control] 5 civilians murdered. Enemy respawn rates are now doubled. And watch out for cloakers...")
		elseif self._hostages_killed == 7 then
			managers.chat:send_message(ChatManager.GAME, nil, "[DW+ Hostage Control] 7 civilians murdered. You've doomed us all "..killer_name.."...")
		end
		
		-- activates special enemy mechanics after 5 and 7 civi kills
		if self._hostages_killed == 5 then
			DWP.CloakerReinforce(killer_id)
		end
		if self._hostages_killed == 7 then
			tweak_data.group_ai.besiege.assault.groups.Undead = {
				0.42,
				0.42,
				0.42
			}
			tweak_data.group_ai.besiege.assault.groups.FBI_tanks = {
				0.22,
				0.22,
				0.22
			}
			tweak_data.group_ai.special_unit_spawn_limits.tank = 14 -- LOL
		end
	end
end)
end