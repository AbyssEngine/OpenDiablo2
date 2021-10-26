-- Copyright (C) 2021 Tim Sarbin
-- This file is part of OpenDiablo2 <https://github.com/AbyssEngine/OpenDiablo2>.
--
-- OpenDiablo2 is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- OpenDiablo2 is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with OpenDiablo2.  If not, see <http://www.gnu.org/licenses/>.
--
require("util")
local resDefs = require("common/resource-defs")
local mainmenu = require("mainmenu")
local language = require("common/language")

-- Load global configuration values
basePath = getConfig("#Abyss", "BasePath")
mpqRoot = getConfig("System", "MPQRoot")
mpqs = split(getConfig("System", "MPQs"), ",")

-- Hide the OS Cursor
showSystemCursor(false)

-- Create load providers for all of the available MPQs
for i in pairs(mpqs) do
    mpqPath = basePath .. "/" .. mpqRoot .. "/" .. mpqs[i]
    loadStr = string.format("Loading Provider %s...", mpqPath)
    log("info", loadStr)
    setBootText("\\#FFFF00 " .. loadStr)
    addLoaderProvider("mpq", mpqPath)
end

-- Load in all of the palettes
for _, name in ipairs(resDefs.Palettes) do
    local lineLog = string.format("Loading Palette: %s...", name[1])
    setBootText(lineLog)
    log("info", lineLog)
    loadPalette(name[1], name[2])
end

-- Detect the language
local configLanguage = getConfig("System", "Language")

if configLanguage ~= "auto" then
    language.set(configLanguage)
else
    language.autoDetect()

    log("info", "Language automatically detected as " .. language.name())
end

-- Exit boot mode
exitBootMode()

-- Play the videos
if getConfig("System", "SkipStartupVideos") ~= "1" then
    playVideo("/data/local/video/New_Bliz640x480.bik", true)
    playVideo("/data/local/video/Eng/d2intro640x292.bik", true)
end

-- Set the cursor sprite
cursorSprite = loadSprite(resDefs.CursorDefault, resDefs.Palette.Sky)
setCursor(cursorSprite, 1, -24)

-- Start the main menu
mainMenu = mainmenu:new()
mainMenu:start()
