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

local Advanced_Update_CHANGELOG_GBOX = gui.Groupbox(AdvancedUpdate_TAB, "Changelog", 200, 10, 290, 0)

local Advanced_Update_COMINGSOON_GBOX = gui.Groupbox(AdvancedUpdate_TAB, "Coming Soon:", 200, 160, 290, 0)

-- Update su changelog
local AdvancedUpdate_CURRENTVERSION = gui.Text(Advanced_Update_UPDATER_GBOX, "Current version: v" .. CURRENTVERSION)

local Advanced_Update_LATESTVERSION = gui.Text(Advanced_Update_UPDATER_GBOX, "Latest version: v" .. LATESTVERSION)

local AdvancedUpdate_UPDATE = gui.Button(Advanced_Update_UPDATER_GBOX, "Update", Update)

local Advanced_Update_CHANGELOG_TEXT = gui.Text(Advanced_Update_CHANGELOG_GBOX, http.Get("https://raw.githubusercontent.com/ztxs/updater/master/changelog.txt"))

local Advanced_Update_COMINGSOON_TEXT = gui.Text(Advanced_Update_COMINGSOON_GBOX, http.Get("https://raw.githubusercontent.com/ztxs/updater/master/comingsoon.txt"))

-- Advanced settings juodas langelis
local Advanced_Settings_GBOX = gui.Groupbox(AdvancedSettings_TAB, "Features", 10, 10, 180, 0)

local Advanced_Settings_GBOX = gui.Groupbox(AdvancedSettings_TAB, "Skybox Changer", 210, 10, 180, 0)

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


-- Skybox changer
local msc_ref = gui.Reference( "Misc", "Advanced Settings", "Skybox Changer" );
local lua_combobox = gui.Combobox( msc_ref, "lua_skyboxppicker", "Skybox picker",
                        "Default", "Bartuc Canyon", "Bartuc Grey",
                        "Galaxy", "Blue Two", "Blue Three", "Blue Four", "Blue Five", "Blue Six",
                        "Css Default",
                        "Dark One", "Dark Two", "Dark Three", "Dark Four", "Dark Five",
                        "Extreme Glaciation",
                        "Green One", "Green Two", "Green Three", "Green Four", "Green Five", "Green Screen",
                        "Grey Sky",
                        "Night One", "Night Two", "Night Three", "Night Four", "Night Five",
                        "Orange One", "Orange Two", "Orange Three", "Orange Four", "Orange Five", "Orange Six",
                        "Persistent Fog",
                        "Pink One", "Pink Two", "Pink Three", "Pink Four", "Pink Five",
                        "Polluted", "Toxic", "Water Sunset" );



function SkyBox()
    local skybox_old = client.GetConVar("sv_skyname");  
    local skybox_new = (lua_combobox:GetValue());
  
        if ( skybox_new == 0 ) then
            client.SetConVar("sv_skyname" , "sky_descent") --aimware.net censorship, check lua on pastebin
          
        elseif (skybox_new == 1 ) then
            client.SetConVar("sv_skyname" , "bartuc_canyon_")
          
        elseif (skybox_new == 2 ) then
            client.SetConVar("sv_skyname" , "bartuc_grey_sky_")      
          
        elseif (skybox_new == 3 ) then
            client.SetConVar("sv_skyname" , "amethystbk")
                              
        elseif (skybox_new == 4 ) then
            client.SetConVar("sv_skyname" , "blue2")
                                  
        elseif (skybox_new == 5 ) then
            client.SetConVar("sv_skyname" , "blue3")
                          
        elseif (skybox_new == 6 ) then
            client.SetConVar("sv_skyname" , "blue4")
                              
        elseif (skybox_new == 7 ) then
            client.SetConVar("sv_skyname" , "blue5")
                              
        elseif (skybox_new == 8 ) then
            client.SetConVar("sv_skyname" , "blue6")
                              
        elseif (skybox_new == 9 ) then
            client.SetConVar("sv_skyname" , "cssdefault")
                              
        elseif (skybox_new == 10 ) then
            client.SetConVar("sv_skyname" , "dark1")
                              
        elseif (skybox_new == 11 ) then
            client.SetConVar("sv_skyname" , "dark2")
                              
        elseif (skybox_new == 12 ) then
            client.SetConVar("sv_skyname" , "dark3")
                              
        elseif (skybox_new == 13 ) then
            client.SetConVar("sv_skyname" , "dark4")
                              
        elseif (skybox_new == 14 ) then
            client.SetConVar("sv_skyname" , "dark5")
                              
        elseif (skybox_new == 15 ) then
            client.SetConVar("sv_skyname" , "extreme_glaciation_")
                              
        elseif (skybox_new == 16 ) then
            client.SetConVar("sv_skyname" , "green1")
                              
        elseif (skybox_new == 17 ) then
            client.SetConVar("sv_skyname" , "green2")
                              
        elseif (skybox_new == 18 ) then
            client.SetConVar("sv_skyname" , "green3")
                              
        elseif (skybox_new == 19 ) then
            client.SetConVar("sv_skyname" , "green4")
                              
        elseif (skybox_new == 20 ) then
            client.SetConVar("sv_skyname" , "green5")
                              
        elseif (skybox_new == 21 ) then
            client.SetConVar("sv_skyname" , "greenscreen")
                              
        elseif (skybox_new == 22 ) then
            client.SetConVar("sv_skyname" , "greysky")
                              
        elseif (skybox_new == 23 ) then
            client.SetConVar("sv_skyname" , "night1")
                              
        elseif (skybox_new == 24 ) then
            client.SetConVar("sv_skyname" , "night2")
                              
        elseif (skybox_new == 25 ) then
            client.SetConVar("sv_skyname" , "night3")
                              
        elseif (skybox_new == 26 ) then
            client.SetConVar("sv_skyname" , "night4")
                              
        elseif (skybox_new == 27 ) then
            client.SetConVar("sv_skyname" , "night5")
                              
        elseif (skybox_new == 28 ) then
            client.SetConVar("sv_skyname" , "orange1")
                              
        elseif (skybox_new == 29 ) then
            client.SetConVar("sv_skyname" , "orange2")
                              
        elseif (skybox_new == 30 ) then
            client.SetConVar("sv_skyname" , "orange3")
                              
        elseif (skybox_new == 31 ) then
            client.SetConVar("sv_skyname" , "orange4")
                              
        elseif (skybox_new == 32 ) then
            client.SetConVar("sv_skyname" , "orange5")
                                  
        elseif (skybox_new == 33 ) then
            client.SetConVar("sv_skyname" , "orange6")
                              
        elseif (skybox_new == 34 ) then
            client.SetConVar("sv_skyname" , "persistent_fog_")
                              
        elseif (skybox_new == 35 ) then
            client.SetConVar("sv_skyname" , "pink1")
                              
        elseif (skybox_new == 36 ) then
            client.SetConVar("sv_skyname" , "pink2")
                              
        elseif (skybox_new == 37 ) then
            client.SetConVar("sv_skyname" , "pink3")
                              
        elseif (skybox_new == 38 ) then
            client.SetConVar("sv_skyname" , "pink4")
                              
        elseif (skybox_new == 39 ) then
            client.SetConVar("sv_skyname" , "pink5")
          
        elseif (skybox_new == 40 ) then
            client.SetConVar("sv_skyname" , "polluted_atm_")  
                              
        elseif (skybox_new == 41 ) then
            client.SetConVar("sv_skyname" , "toxic_atm_")
                              
        elseif (skybox_new == 42 ) then
            client.SetConVar("sv_skyname" , "water_sunset_")
              
                  
        end

end

callbacks.Register("Draw", "SkyBox", SkyBox)

-- Killsound
local menu = gui.Reference("Misc", "Advanced Settings", "Features")
local f12killsound = gui.Checkbox(menu, "killsound", "F12 Kill Sound", 0)
local currentTime = 0
local timer = 0
local enabled = true
local snd_time = 1.100 -- set sound file length default f12 sound = 1.100 .
local fl_val, flp_val = nil, nil

local function handler()
currentTime = globals.RealTime()
if currentTime >= timer then
timer = globals.RealTime() + snd_time
if enabled then
client.SetConVar("voice_loopback", 0, true)
client.SetConVar("voice_inputfromfile", 0, true)
client.Command("-voicerecord", true)
enabled = false
gui.SetValue("misc.fakelag.enable", fl_val)
gui.SetValue("misc.fakelag.peek", flp_val)
end
end
end
local function on_player_death(Event)
if f12killsound:GetValue() == false or Event:GetName() ~= "player_death" then
return
end
local INT_ATTACKER = Event:GetInt("attacker")
if INT_ATTACKER == nil then
return
end
local local_ent = client.GetLocalPlayerIndex()
local attacker_ent = entities.GetByUserID(INT_ATTACKER)
if local_ent == nil or attacker_ent == nil then
return
end
if (attacker_ent:GetIndex() == local_ent) then
fl_val, flp_val = gui.GetValue("misc.fakelag.enable"), gui.GetValue("misc.fakelag.peek")
gui.SetValue("misc.fakelag.enable", 0)
gui.SetValue("misc.fakelag.peek", 0)
client.SetConVar("voice_loopback", 1, true)
client.SetConVar("voice_inputfromfile", 1, true)
client.Command("+voicerecord", true)
timer, enabled = globals.RealTime() + snd_time, true
end
end
client.AllowListener("player_death")
callbacks.Register("FireGameEvent", on_player_death)
callbacks.Register("Draw", handler)
