if not DWPMod then
    _G.DWPMod = {}
    dofile(ModPath .. "lua/coputils.lua")
end

if not DWP then
    _G.DWP = {}
    DWP._path = ModPath
    DWP._data_path = SavePath .. 'DWPsave_new.txt'
    DWP.DWdifficultycheck = nil
	DWP.curlobbyname = nil
	DWP.settings = {
		lobbyname = true,
		infomsgpublic = true,
		endstattoggle = true,
		endstatSPkills = true,
		endstatheadshots = false,
		endstataccuarcy = false,
		skillinfo = true,
		hourinfo = true,
		infamy = true,
		DSdozer = true,
		respawns = 4,
		assforce_pool = 400,
		assduration = 350,
		bAmMarsh = true,
		arrestbeta = true,
		hostagesbeta = false,
		statsmsgpublic = true,
		xmas_chaos = true
    }
	DWP.players = {}
	for i=1,4 do -- peer skills/hours prints
		DWP.players[i] = {}
		for j=1,2 do
			DWP.players[i][j] = 0
		end
	end
	DWP.synced = {}
	DWP.HostageControl = {}
	DWP.HostageControl.PeerHostageKillCount = {}
	DWP.color = Color(255,217,0,217) / 255
	DWP.statprefix = "[DWP_Stats]"

    function DWP:Save()
        local file = io.open(DWP._data_path, 'w+')
        if file then
            file:write(json.encode(DWP.settings))
            file:close()
        end
    end
    
    function DWP:Load()
        local file = io.open(DWP._data_path, 'r')
        if file then
            for k, v in pairs(json.decode(file:read('*all')) or {}) do
                DWP.settings[k] = v
            end
            file:close()
        end
    end
    
    -- Load the config in a pcall to prevent any corrupt config issues.
    local configResult = pcall(function()
        DWP:Load()
    end)

    -- Notify the user if something went wrong
    if not configResult then
        Hooks:Add("MenuManagerOnOpenMenu", "DWP_configcorrupted", function(menu_manager, nodes)            
            QuickMenu:new("Death With + Error", "Your 'Death With +' options file was corrupted, all the mod options have been reset to default.", {
                [1] = {
                    text = "OK",
                    is_cancel_button = true
                }
            }):show()
        end)
    end

    -- Generate save data even if nobody ever touches the mod options menu.
    -- This also regenerates a "fresh" config if it's corrupted.
    DWP:Save()

end
