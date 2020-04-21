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

---------- Checkboxes etc
local Advanced_Settings_UPDATER_GBOX = gui.Groupbox(AdvancedSettings_TAB, "Updater", 10, 10, 160, 0)


-- Update su changelog
local AdvancedSettings_CURRENTVERSION = gui.Text(Advanced_Settings_UPDATER_GBOX, "Current version: v" .. CURRENTVERSION)
