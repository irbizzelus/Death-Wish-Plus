-- hostage control now tracks killed intimidated cops, but only if they are killed in loud
Hooks:PostHook(CopDamage, "die", "DWP_copdie" , function(self,attack_data)
	
	if not Network:is_server() then
		return
	end
	
	--
	if managers.player:player_unit() == attack_data.attacker_unit then
		log("local player killed a cop")
	else
		if managers.network:session():peer(2) and managers.network:session():peer(2):unit() and managers.network:session():peer(2):unit() == attack_data.attacker_unit then
			log("peer 2 killed a cop")
		elseif managers.network:session():peer(3) and managers.network:session():peer(3):unit() and managers.network:session():peer(3):unit() == attack_data.attacker_unit then
			log("peer 3 killed a cop")
		elseif managers.network:session():peer(4) and managers.network:session():peer(4):unit() and managers.network:session():peer(4):unit() == attack_data.attacker_unit then
			log("peer 4 killed a cop")
		end
	end
	--
	
	if not DWP.settings.hostagesbeta or not DWP.DWdifficultycheck then
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
		log("adding a hostage cop to hostage conrol kill count")
		DWP.HostageControl.globalkillcount = DWP.HostageControl.globalkillcount + 1
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
		log("local player killed a cop")
		killer_name = managers.network:session():peer(killer_unit:base()._id):name()
	else
		if managers.network:session():peer(2) and managers.network:session():peer(2):unit() and managers.network:session():peer(2):unit() == attack_data.attacker_unit then
			log("peer 2 killed a cop")
			peer = managers.network:session():peer(2)
			killer_name = peer:name()
			killer_id = 2
		elseif managers.network:session():peer(3) and managers.network:session():peer(3):unit() and managers.network:session():peer(3):unit() == attack_data.attacker_unit then
			log("peer 3 killed a cop")
			peer = managers.network:session():peer(3)
			killer_name = peer:name()
			killer_id = 3
		elseif managers.network:session():peer(4) and managers.network:session():peer(4):unit() and managers.network:session():peer(4):unit() == attack_data.attacker_unit then
			log("peer 4 killed a cop")
			peer = managers.network:session():peer(4)
			killer_name = peer:name()
			killer_id = 4
		end
	end
	
	if DWP.HostageControl.globalkillcount < 5 then
		if peer == 1 then
			managers.hud:show_hint({text = "You killed a hostage! Hostages killed: "..tostring(DWP.HostageControl.globalkillcount)})
		else
			managers.network:session():send_to_peer(peer, "send_chat_message", 1, "[DW+ Private message] Killing hostages inflicts penalties on you and your team. Use /civi for more info.")
			managers.hud:show_hint({text = tostring(killer_name).." killed a hostage! Hostages killed: "..tostring(DWP.HostageControl.globalkillcount)})
		end
	elseif DWP.HostageControl.globalkillcount == 5 then
		managers.chat:send_message(ChatManager.GAME, nil, "[DW+ Hostage Control] 5 hostages dead. Enemy respawn rates are maxed out. And also cloakers learned how to teleport?..")
		DWP.CloakerReinforce(killer_id)
	elseif DWP.HostageControl.globalkillcount == 7 then
		managers.chat:send_message(ChatManager.GAME, nil, "[DW+ Hostage Control] 7 hostages are now dead. You can all blame "..killer_name.." for what's to come.")
		DWP:ActivateHostageControl7KillsPenalty()
	end
	
end)