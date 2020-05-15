-- StrixLua
-- Made by Zetix

-------------------------------------- Print

print("StrixLua has been successfully loaded")

------------------------------------ Auto Update

local CURRENTVERSION = "1.0"
local LATESTVERSION = http.Get("https://raw.githubusercontent.com/ztxs/updater/master/StrixLua.txt")
local function Update() 
    if CURRENTVERSION ~= LATESTVERSION then
        currentScript = file.Open(GetScriptName(), "w")
        currentScript:Write(http.Get("https://raw.githubusercontent.com/ztxs/updater/master/StrixLua.lua"))
        currentScript:Close()
        LoadScript(GetScriptName())
    end
end
------------------------------------ Gui buttons etc

local StrixLua_TAB = gui.Tab(gui.Reference("Misc"), "strix.1", "StrixLua")


local StrixUpdate_TAB = gui.Tab(gui.Reference("Misc"), "strix.2", "StrixUpdate")

-------------- Update 1

local StrixLua_UPDATER_GBOX = gui.Groupbox(StrixUpdate_TAB, "Updater", 10, 10, 160, 0)


local StrixLua_CHANGELOG_GBOX = gui.Groupbox(StrixUpdate_TAB, "Changelog", 190, 10, 290, 0)

--------------------------------- Update versions


local StrixLua_CURRENTVERSION = gui.Text(StrixLua_UPDATER_GBOX, "Current version: v" .. CURRENTVERSION)

local StrixLua_LATESTVERSION = gui.Text(StrixLua_UPDATER_GBOX, "Latest version: v" .. LATESTVERSION)

local StrixLua_UPDATE = gui.Button(StrixLua_UPDATER_GBOX, "Update", Update)

local StrixLua_CHANGELOG_TEXT = gui.Text(StrixLua_CHANGELOG_GBOX, http.Get("https://raw.githubusercontent.com/ztxs/updater/master/changelog.txt"))

-- black windows

local StrixLua_FUNCTIONS_GBOX = gui.Groupbox(StrixLua_TAB, "Features", 10, 10, 230, 0)

-- features/functions


-- grenade owner
local active = gui.Checkbox( gui.Reference( 'Misc', 'StrixLua', 'Features' ), 'esp.world.grenadeowner', 'Grenade Owner', 0 )
active:SetDescription('Shows owner of Smokes and Decoys')
local cb = gui.Combobox( gui.Reference( 'Misc', 'StrixLua', 'Features' ), 'esp.world.grenadeowner.types', 'Grenades', 'Decoys', 'Smokes', 'Both' )
cb:SetDescription('Choose which Grenades should be shown')
local FindByClass, GetLocalPlayer, Text, Color, WorldToScreen = entities.FindByClass, entities.GetLocalPlayer, draw.Text, draw.Color, client.WorldToScreen

local function draw_decoys(team, index)
    if (not active:GetValue() or GetLocalPlayer == nil or cb:GetValue() == 1) then return end
    local decoys = FindByClass('CDecoyProjectile')

    for i=1, #decoys do
        local decoy = decoys[i]
        local pX, pY, pZ = decoy:GetAbsOrigin()
        local tX, tY = WorldToScreen( pX, pY, pZ )
        if tX ~= nil then
            local thrower = decoy:GetPropEntity('m_hThrower')

            if thrower:GetIndex() == index then
                Color(255, 255, 255)
                Text(tX - 35, tY, 'Own Decoy')
            else
                local bX, bY = WorldToScreen( pX, pY, pZ )

                if thrower:GetTeamNumber() == team then
                    Color(0, 255, 42)
                    Text(bX, bY, 'Teammate '.. client.GetPlayerNameByIndex( thrower:GetIndex() ))
                    Text(tX - 20, tY, 'Decoy')
                else
                    Color(255, 0, 25)
                    Text(bX, bY, 'Enemy '.. client.GetPlayerNameByIndex( thrower:GetIndex() ))
                    Text(tX - 20, tY, 'Decoy')
                end
            end
        end
    end
end

local function draw_smokes(team, index)
    if (not active:GetValue() or GetLocalPlayer == nil or cb:GetValue() == 0)  then return end
    local smokes = FindByClass('CSmokeGrenadeProjectile')

    for i=1, #smokes do
        local smoke = smokes[i]
        local pX, pY, pZ = smoke:GetAbsOrigin()
        local tX, tY = WorldToScreen( pX, pY, pZ )
        if tX ~= nil then
            local thrower = smoke:GetPropEntity('m_hThrower')

            if thrower:GetIndex() == index then
                Color(255, 255, 255)
                Text(tX - 38, tY, 'Own Smoke')
            else
                local bX, bY = WorldToScreen( pX, pY, pZ )

                if thrower:GetTeamNumber() == team then
                    Color(0, 255, 42)
                    Text(bX, bY, 'Teammate '.. client.GetPlayerNameByIndex( thrower:GetIndex() ))
                    Text(tX - 22, tY, 'Smoke')
                else
                    Color(255, 0, 25)
                    Text(bX, bY, 'Enemy '.. client.GetPlayerNameByIndex( thrower:GetIndex() ))
                    Text(tX - 22, tY, 'Smoke')
                end
            end
        end
    end
end

callbacks.Register('Draw', function()
    local lp = GetLocalPlayer()
    local my_index = lp:GetIndex()
    local my_team = lp:GetTeamNumber()

    draw_decoys(my_team, my_index)
    draw_smokes(my_team, my_index)
end)

----------
