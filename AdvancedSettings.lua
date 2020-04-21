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
