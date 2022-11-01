-- Allow cops to reload while moving
Hooks:PreHook(CopActionShoot, "update", "DWP_copsshootwhilemoving", function(self)
	if not self._ext_anim then
		return
	end

	self._ext_anim.base_no_reload = false
end)
