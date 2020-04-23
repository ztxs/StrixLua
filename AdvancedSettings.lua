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

-- Killsound
local menu = gui.Reference("Misc", "Advanced Settings", "Features")
local f12killsound = gui.Checkbox(menu, "killsound", "F12 Kill Sound", 0)
local currentTime = 0
local timer = 0
local enabled = true
local snd_time = 0.6 -- set sound file length default f12 sound = 0.6 .
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
if not enabled then
fl_val, flp_val = gui.GetValue("misc.fakelag.enable"), gui.GetValue("misc.fakelag.peek")
end
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

-- Autobuy
local ref = gui.Reference("Misc", "Advanced Settings")
local Group = gui.Groupbox(ref, "Autobuy", 220, 10, 230)
local checkbox_buybot = gui.Checkbox( Group, "Checkbox", "BuyBot Active",  false)
local primary_guns = gui.Combobox( Group, "primary", "Primary", "Off", "Scar-20 | G3SG1","AK47 | M4A1", "SSG-08", "AWP", "SG553 | AUG")
local secondary_guns = gui.Combobox( Group, "Secondary", "Secondary",  "Off", "Dual Berettas", "Deagle | Revolver", "P250","TEC-9 | CZ75-Auto" )
local k_armor = gui.Checkbox( Group, "k_armor", "Buy Kevlar + Armor", false)
local armor = gui.Checkbox( Group, "armor", "Buy Armor", false)
local nades = gui.Checkbox( Group, "nades", "Buy Nades", false)
local buybot_zeus = gui.Checkbox( Group, "zeus", "Buy Zeus",  false)
local defuser = gui.Checkbox( Group, "defuser", "Buy Defuser",  false)
local weapons_ = {"pistol", "revolver", "smg", "rifle", "shotgun", "scout", "autosniper", "sniper", "lmg"}
local hitboxes_ = {"head", "neck", "chest", "stomach", "pelvis", "arms", "legs"}
local primary_w = {"buy scar20", "buy m4a1", "buy ssg08", "buy awp", "buy aug"}
local secondary_w = {"buy elite", "buy deagle", "buy p250", "buy tec9"}
local function Events( event )
    if event:GetName() == "round_start" and checkbox_buybot:GetValue() then
        local needtobuy = ""
        local primary = primary_guns:GetValue()
        local secondary = secondary_guns:GetValue()

        if k_armor:GetValue() then needtobuy = "buy vesthelm;"  
        end
        if armor:GetValue() then needtobuy = "buy vest;"  
        end
        if nades:GetValue() then needtobuy = needtobuy.."buy hegrenade;buy molotov;buy smokegrenade;buy flashbang;buy flashbang;"
        end
        if buybot_zeus:GetValue() then needtobuy = needtobuy.."buy taser;"
        end       
        if defuser:GetValue() then needtobuy = needtobuy.."buy defuser;"
        end
        if primary > 0 then needtobuy = needtobuy..primary_w[primary]..";"  
        end       
        if secondary > 0 then needtobuy = needtobuy..secondary_w[secondary]..";"
        end


        client.Command(needtobuy, false)
  end
          end
callbacks.Register( "FireGameEvent", Events)
