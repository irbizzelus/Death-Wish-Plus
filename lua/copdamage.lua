-- hostage control now tracks killed intimidated cops, but only if they are killed in loud
Hooks:PostHook(CopDamage, "die", "DWP_copdie" , function(self,attack_data)
	
	if not Network:is_server() then
		return
	end
	
	if not DWP.settings_config.hostage_control or not DWP.DWdifficultycheck then
		return
	end
	
	if managers.groupai:state():whisper_mode() then
		if DWP.cop_hostages and DWP.cop_hostages[self._unit:id()] then
			-- if cop is killed in stealth after giving up, remove him from our track list
			DWP.cop_hostages[self._unit:id()] = nil
		end
		return
	end
	
	local was_hostage = false
	
	if DWP.cop_hostages and DWP.cop_hostages[self._unit:id()] then
		DWP.HostageControl.globalkillcount = DWP.HostageControl.globalkillcount + 0.5
		DWP.cop_hostages[self._unit:id()] = nil
		was_hostage = true
	end
	
	if not was_hostage then
		return
	end
	
	local killer_name = "Someone"
	local peer = 1
	local killer_id = 1
	
	if managers.player:player_unit() == attack_data.attacker_unit then
		killer_name = managers.network.account:username()
		DWP.HostageControl.PeerHostageKillCount[1] = DWP.HostageControl.PeerHostageKillCount[1] + 0.5
	else
		if managers.network:session():peer(2) and managers.network:session():peer(2):unit() and managers.network:session():peer(2):unit() == attack_data.attacker_unit then
			peer = managers.network:session():peer(2)
			killer_name = peer:name()
			killer_id = 2
			DWP.HostageControl.PeerHostageKillCount[2] = DWP.HostageControl.PeerHostageKillCount[2] + 0.5
		elseif managers.network:session():peer(3) and managers.network:session():peer(3):unit() and managers.network:session():peer(3):unit() == attack_data.attacker_unit then
			peer = managers.network:session():peer(3)
			killer_name = peer:name()
			killer_id = 3
			DWP.HostageControl.PeerHostageKillCount[3] = DWP.HostageControl.PeerHostageKillCount[3] + 0.5
		elseif managers.network:session():peer(4) and managers.network:session():peer(4):unit() and managers.network:session():peer(4):unit() == attack_data.attacker_unit then
			peer = managers.network:session():peer(4)
			killer_name = peer:name()
			killer_id = 4
			DWP.HostageControl.PeerHostageKillCount[4] = DWP.HostageControl.PeerHostageKillCount[4] + 0.5
		end
	end
	
	if DWP.HostageControl.globalkillcount < 6 or (DWP.HostageControl.globalkillcount < 11 and (DWP.HostageControl.globalkillcount ~= 6 or DWP.HostageControl.globalkillcount == 6.5 and DWP.CloakerReinforceEnabled)) then
		if peer == 1 then
			managers.hud:show_hint({text = "[DW+] You killed a surrendered officer! Hostages killed: "..tostring(DWP.HostageControl.globalkillcount)})
		else
			DWP.HostageControl:warn_peer(peer, killer_id, false)
			managers.hud:show_hint({text = "[DW+] "..tostring(killer_name).." killed a surrendered officer! Hostages killed: "..tostring(DWP.HostageControl.globalkillcount)})
		end
	elseif DWP.HostageControl.globalkillcount == 6 or DWP.HostageControl.globalkillcount == 6.5 and not DWP.CloakerReinforceEnabled then
		managers.chat:send_message(ChatManager.GAME, nil, "[DW+] 6 hostages killed. Enemy respawn rates are almost maxed out. And also cloakers learned how to teleport?..")
		DWP.CloakerReinforce(killer_id)
		DWP.CloakerReinforceEnabled = true
	elseif DWP.HostageControl.globalkillcount == 11 or DWP.HostageControl.globalkillcount == 11.5 and not DWP.HC11killpenalty then
		managers.chat:send_message(ChatManager.GAME, nil, "[DW+] 11 hostages are now dead. You can all blame "..killer_name.." for what's to come.")
		DWP:ActivateHostageControlDozerPenalty()
		DWP.HC11killpenalty = true
	end
	
end)