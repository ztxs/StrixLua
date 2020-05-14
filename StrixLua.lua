-- StrixLua
-- Made by Zetix

-------------------------------------- Print

print("StrixLua has been successfully loaded")

------------------------------------ Auto Update



------------------------------------ Gui buttons etc

local StrixLua_TAB = gui.Tab(gui.Reference("Misc"), "strix.1", "StrixLua")


local StrixUpdate_TAB = gui.Tab(gui.Reference("Misc"), "strix.2", "StrixUpdate")

-------------- Update 1

local StrixLua_UPDATER_GBOX = gui.Groupbox(StrixUpdate_TAB, "Updater", 10, 10, 160, 0)


local StrixLua_CHANGELOG_GBOX = gui.Groupbox(StrixUpdate_TAB, "Changelog", 190, 10, 290, 0)
