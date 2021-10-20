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

showSystemCursor(true)
-- testing stuff...
basePath = getConfig("#Abyss", "BasePath")
mpqRoot = getConfig("System", "MPQRoot")
mpqs = split(getConfig("System", "MPQs"), ",")

for i in pairs(mpqs) do
    mpqPath = basePath .. "/" .. mpqRoot .. "/" .. mpqs[i]
    loadStr = string.format("Loading Provider %s...", mpqPath)
    log("info", loadStr)
    setBootText("\\#FFFF00 " .. loadStr)
    addLoaderProvider("mpq", mpqPath)
end

for _, name in ipairs(resDefs.Palettes) do
    local lineLog = string.format("Loading Palette: %s...", name[1])
    setBootText(lineLog)
    log("info", lineLog)
    loadPalette(name[1], name[2])
end

showSystemCursor(false)

cursorSprite = loadSprite(resDefs.CursorDefault, resDefs.Palette.Sky)
exitBootMode()
setCursor(cursorSprite, 1, -24)
-- mainMenu = mainmenu:new()
-- mainMenu:start()
