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

local StrixLua_MOVEMENT_GBOX = gui.Groupbox(StrixLua_TAB, "Movement", 250, 10, 215, 0)
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


-------- skybox
local ref = gui.Reference("Visuals", "World", "Materials", "Skybox");
local skyboxes = {"Default", "cs_tibet", "embassy", "italy", "jungle", "office", "sky_cs15_daylight01_hdr",
"sky_csgo_cloudy01", "sky_csgo_night02", "sky_csgo_night02b", "sky_day02_05_hdr", "sky_day02_05", "sky_dust", "vertigo_hdr",
"vertigoblue_hdr", "vertigo", "vietnam", "space_1", "space_3", "space_4", "space_5", "space_6", "space_7", "space_8", "space_9",
"space_10", "******"};

local skyboxesMenu = {"Default", "Tibet", "Embassy", "Italy", "Jungle", "Office", "CS15 Daylight HDR",
"Cloudy 1", "Night 2", "Night 2B", "Day 2 5 HDR", "Day 2 5", "Dust", "Vertigo HDR", "Vertigoblue HDR",
"Vertigo", "Vietnam", "Space 1", "Space 2", "Space 3", "Space 4", "Space 5", "Space 6", "Space 7",
"Space 8", "Decent"};

ref:SetOptions(unpack(skyboxesMenu));
local set = client.SetConVar;
local last = ref:GetValue();




local function SkyBox()
    if last ~= ref:GetValue() then
        set("sv_skyname" , skyboxes[ref:GetValue() + 1], true);
        last = ref:GetValue();
    end
end
callbacks.Register("Draw", SkyBox)

---- movement
--Fake Scroll on JumpBug--
--by uvxxvu - https://aimware.net/forum/thread-128377.html--
local ui_checkbox = gui.Checkbox( gui.Reference("MISC","StrixLua", "Movement"),"misc.autojumpbug.scroll", "Fake Scroll On Jump-bug Miss", 1 )
ui_checkbox:SetDescription( "Fakes scroll input if Auto Jump-Bug fails." )

local function get_local_player( )

    local player = entities.GetLocalPlayer( )
   
    if player == nil then return end
   
    if ( not player:IsAlive( ) ) then
       
        player = player:GetPropEntity( "m_hObserverTarget" )
       
    end
   
    return player
   
end

local function JUMPBUG_SCROLL( UserCmd )

    local flags = get_local_player():GetPropInt( "m_fFlags" )
   
    if flags == nil then return end

    local onground = bit.band( flags, 1 ) ~= 0
   
    if onground and input.IsButtonDown( gui.GetValue("misc.autojumpbug" ) )then

        UserCmd:SetButtons( 4 )
        return   

    end
end


callbacks.Register( "CreateMove", JUMPBUG_SCROLL )
--END - JumpBug lua--

--HL Speed Indicator--
--by arpac - https://aimware.net/forum/thread-93805.html--
local ref_speed = gui.Reference("Misc", "StrixLua", "Movement")
local speed_check = gui.Checkbox(ref_speed, "hl2.speed.indicator", "HL2 Speed Indicator", false) 
local curspeed_color = gui.ColorPicker(speed_check, "hl2.speed.ind.color", 255,255,255,255)
local speed = 0
local last_onground_speed = 0
local last_flags = 0;

local fade_time = 0;
local old_onground_speed = 0;

    function testflag(set, flag)
      return set % (2*flag) >= flag
    end
    
function paint_traverse()
if speed_check:GetValue() then
   local x, y = draw.GetScreenSize()
   local centerX = x / 2
     if entities.FindByClass( "CBasePlayer" )[1] ~= nil then
    end;

    local font = draw.CreateFont( "Verdana", 30 );
  
   draw.SetFont( font );



   if entities.GetLocalPlayer() ~= nil then

       local Entity = entities.GetLocalPlayer();
       local Alive = Entity:IsAlive();
       local velocityX = Entity:GetPropFloat( "localdata", "m_vecVelocity[0]" );
       local velocityY = Entity:GetPropFloat( "localdata", "m_vecVelocity[1]" );
      
       local flags = Entity:GetPropInt( "m_fFlags" );
      
      
       local velocity = math.sqrt( velocityX^2 + velocityY^2 );
       local FinalVelocity = math.min( 9999, velocity ) + 0.2;
       if ( Alive == true ) then
         speed= math.floor(FinalVelocity) ;
        
        
       if(testflag(flags, 1) and not testflag(last_flags, 1)) then
       old_onground_speed = last_onground_speed;
       last_onground_speed = speed
       fade_time = 1;
       end
       last_flags = flags;
        
       else
         speed=0;
         last_onground_speed = 0;
       end
   end
    rw,rh =draw.GetTextSize(speed)
    
    if(fade_time > globals.FrameTime()) then
        fade_time = fade_time - globals.FrameTime();
    end
    
    local speed_delta = last_onground_speed - old_onground_speed;
    
    draw.Color(curspeed_color:GetValue());
    draw.Text(centerX -(rw/2), y - 170, speed);
    
    local r = 255;
    local g = 255;
    local b = 255;
    
    if(speed_delta > 0 and fade_time > 0.5) then
        r = 30
        g = 220
        b = 30
    end
    
    if(speed_delta < 0 and fade_time > 0.5) then
        r = 220
        g = 30
        b = 30
    end
    
    
    
    rw2,rh2 =draw.GetTextSize(last_onground_speed)
    draw.Color( r, g, b, 220 );
    draw.Text(centerX -(rw2/2), y - 200, last_onground_speed)

end
end

callbacks.Register("Draw", "paint_traverse", paint_traverse)
--End - HL Speed Indicator--
--End - LUA--
