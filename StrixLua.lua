-- StrixLua
-- Made by Zetix

------------------------------------------------ Print

print("StrixLua has been successfully loaded")

------------------------------------------------ Auto Update

local CURRENTVERSION = "1.0"
local LATESTVERSION = http.Get("https://raw.githubusercontent.com/ztxs/updater/master/StrixLua.txt")
local function Update()
    if CURRENTVERSION ~= LATESTVERSION then
        currentScript = file.Open(GetScriptName(), "w")
        currentScript:Write(http.Get("https://raw.githubusercontent.com/ztxs/updater/master/StrixLua.lua"))
        currentScript:Close
        LoadScript(GetScriptName())
    end
end

--------------------------------------------- Gui buttons etc

