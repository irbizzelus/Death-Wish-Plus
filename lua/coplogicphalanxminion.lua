Hooks:PostHook(CopLogicPhalanxMinion, "chk_should_breakup", "DWP_PhalanxMinion_chk_should_breakup_post", function(self)
	local phalanx_minion_count = managers.groupai:state():get_phalanx_minion_count()
	local min_count_minions = tweak_data.group_ai.phalanx.minions.min_count
	
	if phalanx_minion_count > 0 and phalanx_minion_count <= min_count_minions then
		managers.groupai:state():unregister_phalanx_vip()
		managers.groupai:state():set_assault_endless(false)
	end
end)