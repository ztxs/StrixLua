---------- Print

print("AdvancedSettings has been loaded")

---------- Update

local CURRENTVERSION = "1.0"
local LATESTVERSION = http.Get("https://raw.githubusercontent.com/ztxs/updater/master/AdvancedSettings.txt")
local function Update() 
    if CURRENTVERSION ~= LATESTVERSION then
        currentScript = file.Open(GetScriptName(), "w")
        currentScript:Write(http.Get("https://raw.githubusercontent.com/ztxs/updater/master/AdvancedSettings.lua"))
        currentScript:Close()
        LoadScript(GetScriptName())
    end
end

---------- Tabs
local AdvancedSettings_TAB = gui.Tab(gui.Reference("Misc"), "advanced.settings", "Advanced Settings")

local AdvancedUpdate_TAB = gui.Tab(gui.Reference("Misc"), "advanced.update", "Advanced Update")


---------- Checkboxes etc
local Advanced_Update_UPDATER_GBOX = gui.Groupbox(AdvancedUpdate_TAB, "Updater", 10, 10, 160, 0)

local Advanced_Update_CHANGELOG_GBOX = gui.Groupbox(AdvancedUpdate_TAB, "Changelog", 190, 10, 290, 0)

-- Update su changelog
local AdvancedUpdate_CURRENTVERSION = gui.Text(Advanced_Update_UPDATER_GBOX, "Current version: v" .. CURRENTVERSION)

local Advanced_Update_LATESTVERSION = gui.Text(Advanced_Update_UPDATER_GBOX, "Latest version: v" .. LATESTVERSION)

local AdvancedUpdate_UPDATE = gui.Button(Advanced_Update_UPDATER_GBOX, "Update", Update)

local Advanced_Update_CHANGELOG_TEXT = gui.Text(Advanced_Update_CHANGELOG_GBOX, http.Get("https://raw.githubusercontent.com/ztxs/updater/master/changelog.txt"))

-- Advanced settings juodas langelis
local Advanced_Settings_GBOX = gui.Groupbox(AdvancedSettings_TAB, "Features", 10, 10, 180, 0)

-- Headwalk
local movement_ref = gui.Reference("MISC", "Advanced Settings", "Features")

local sync_movement = gui.Checkbox(movement_ref, "sync_movement_0.", "Head Movement", false)


function syncMovement(cmd, pos)
    local world_forward = {vector.Subtract( pos,  {entities.GetLocalPlayer():GetAbsOrigin().x, entities.GetLocalPlayer():GetAbsOrigin().y, entities.GetLocalPlayer():GetAbsOrigin().z} )}
    local ang_LocalPlayer = {engine.GetViewAngles().x, engine.GetViewAngles().y, engine.GetViewAngles().z }
    
    cmd.forwardmove = ( ( (math.sin(math.rad(ang_LocalPlayer[2]) ) * world_forward[2]) + (math.cos(math.rad(ang_LocalPlayer[2]) ) * world_forward[1]) ) * 200 ) -- mine
    cmd.sidemove = ( ( (math.cos(math.rad(ang_LocalPlayer[2]) ) * -world_forward[2]) + (math.sin(math.rad(ang_LocalPlayer[2]) ) * world_forward[1]) ) * 200 )
end

function is_movement_keys_down()
    return input.IsButtonDown( 87 ) or input.IsButtonDown( 65 ) or input.IsButtonDown( 83 ) or input.IsButtonDown( 68 ) or input.IsButtonDown( 32 )
end

function is_crouching(player)
    return player:GetProp('m_flDuckAmount') > 0.1
end



local is_synced = false

callbacks.Register("CreateMove", function(cmd)
    if not sync_movement:GetValue() then return end
    succ, err = pcall(function() is_movement_keys_down() is_synced = false end)
    if err or is_movement_keys_down() then return end
    
    local players = entities.FindByClass( "CCSPlayer" )
    
    for k, player in pairs(players) do
        local player_pos = {player:GetAbsOrigin().x, player:GetAbsOrigin().y, player:GetAbsOrigin().z}
        local distance = vector.Distance(player_pos, {entities.GetLocalPlayer():GetAbsOrigin().x, entities.GetLocalPlayer():GetAbsOrigin().y, entities.GetLocalPlayer():GetAbsOrigin().z})
        
        local z_dist = entities.GetLocalPlayer():GetAbsOrigin().z - player_pos[3]
        
        local d_min = 0
        local d_max = 0
        if not is_crouching(player) then
            d_min = 70
            d_max = 85
        else
            d_min = 50
            d_max = 64
        end
        if (distance > d_min and distance < d_max) and (z_dist > d_min and z_dist < d_max) then
            syncMovement(cmd, player_pos)
            is_synced = true
        else
            is_synced = false
        end
    end        
end)

