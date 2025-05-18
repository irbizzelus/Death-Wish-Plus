if not DWP then
	dofile(ModPath .. "lua/DWPbase.lua")
end

-- highlight lobby host's name using DWP default color if name is set to dwp's lobby name
local DWP_orig_criment_job_gui = CrimeNetGui._create_job_gui
function CrimeNetGui:_create_job_gui(data, type, fixed_x, fixed_y, fixed_location)
	local result = DWP_orig_criment_job_gui(self, data, type, fixed_x, fixed_y, fixed_location)
	
	if result.side_panel:child("host_name"):text() == "Death Wish +" or result.side_panel:child("host_name"):text() == "Death Wish ++" or result.side_panel:child("host_name"):text() == "Death Wish +++" or result.side_panel:child("host_name"):text() == "Death Wish ++++" then
		result.side_panel:child("host_name"):set_color(DWP.color)
	end
	
	return result
	
end