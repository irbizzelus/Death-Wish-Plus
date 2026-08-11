if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

local dwp_orig_drama = GroupAIStateBase._add_drama
Hooks:OverrideFunction(GroupAIStateBase, "_add_drama", function (self, amount)
	
	if not (Network:is_server() and DWP and DWP.DWdifficultycheck) then
		dwp_orig_drama(self, amount)
	end
	
	if Global.level_data and Global.level_data.level_id == "nmh" and self._assault_number <= 2 then
		-- scripted rules to make first 2 waves on no mercy heist faster 
		if self._task_data.assault.phase == "fade" and self._drama_data.amount > 0.01 then
			self._drama_data.amount = 0.01
			amount = 0
		elseif self._assault_number < 2 and self._drama_data.amount < 0.999 then
			self._drama_data.amount = 0.999
			amount = 0
		elseif self._assault_number == 2 and self._drama_data.amount + amount ~= 0.9 then
			if self._drama_data.amount + amount ~= 0.9 then
				self._drama_data.amount = 0.9
				amount = 0
			end
		end
	else
		-- prevent drama from goin over 95 so we never skip anticipation. reason: longer breaks
		-- also some music anticipation tracks are 11/10, yet i almost never hear them because of this useless (gameplay wise) mechanic
		-- oh and prevent drama from beeing too low to make fade last as long as possible; thanks to update 181, this is not exploitable and gives 1 minute of free time at best
		if self._drama_data.amount + amount ~= 0.9 then
			self._drama_data.amount = 0.9
			amount = 0
		end
	end
	
	dwp_orig_drama(self, amount)
	self:set_difficulty(1)
	
end)

-- disable smokes/flashes on 'No Mercy' for first 2 waves, since enemy swarm can get really bad there, additional visual clutter makes it unfun so avoid it for a bit
local dwp_detonate_world_smoke_grenade_orig = GroupAIStateBase.detonate_world_smoke_grenade
Hooks:OverrideFunction(GroupAIStateBase, "detonate_world_smoke_grenade", function (self, id)
	if DWP.DWdifficultycheck then
		if Global.level_data and Global.level_data.level_id == "nmh" and self._assault_number <= 2 then
			return
		end
	end
	dwp_detonate_world_smoke_grenade_orig(self,id)
end)

local dwp_orig_diff = GroupAIStateBase.set_difficulty
Hooks:OverrideFunction(GroupAIStateBase, "set_difficulty", function (self, value)
	
	if not (Network:is_server() and DWP and DWP.DWdifficultycheck) then
		dwp_orig_diff(self, value)
		return
	end
	
	-- track build phase start time for cpt. winters
	if self._task_data and self._task_data.assault and self._task_data.assault.phase == "build" then
		DWP.latest_assault_starting_time = Application:time()
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
	dwp_orig_diff(self, value)
end)

-- hostage control civs
Hooks:PostHook(GroupAIStateBase, "hostage_killed", "DWP_civ_hostage_killed", function(self, killer_unit)
	if Network:is_server() and DWP and DWP.DWdifficultycheck and DWP.settings_config and DWP.settings_config.hostage_control then
		DWP.HostageControl:hostage_killed(killer_unit)
	end
end)

-- max of 2 intimidated cops per map. remove player bonuses because that upgrade is default nowadays, and remove converts from being counted cause thats unimportant
local dwp_orig_GroupAIStateBase_has_room_for_police_hostage = GroupAIStateBase.has_room_for_police_hostage
Hooks:OverrideFunction(GroupAIStateBase, "has_room_for_police_hostage", function (self)
	if not (Network:is_server() and DWP and DWP.DWdifficultycheck) then
		return dwp_orig_GroupAIStateBase_has_room_for_police_hostage(self)
	else
		return self._police_hostage_headcount < 2
	end
end)