Hooks:PostHook(CopLogicPhalanxVip, "_chk_should_breakup", "DWP_PhalanxVip_chk_should_breakup_post", function(self)
	local flee_health_ratio = tweak_data.group_ai.phalanx.vip.health_ratio_flee
	local vip_health_ratio = self.unit:character_damage():health_ratio()

	if vip_health_ratio <= flee_health_ratio then
		managers.groupai:state():unregister_phalanx_vip()
		managers.groupai:state():set_assault_endless(false)
	end
end)