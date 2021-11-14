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
local language = require("common/language")
local resDefs = require("common/resource-defs")

function globalsInit()
    -- Load the fonts
    systemFonts = {
        fntFormal12 = loadSpriteFont(language.i18nPath(resDefs.FontFormal12), resDefs.Palette.Static),
        fntFormal10 = loadSpriteFont(language.i18nPath(resDefs.FontFormal10), resDefs.Palette.Static),
        fntExocet10 = loadSpriteFont(language.i18nPath(resDefs.FontExocet10), resDefs.Palette.Static),
        fntRediculous = loadSpriteFont(language.i18nPath(resDefs.FontRediculous), resDefs.Palette.Static)
    }

    -- Set the cursor sprite
    cursorSprite = loadSprite(resDefs.CursorDefault, resDefs.Palette.Sky)
end

function globalsDestroy()
    getRootNode():removeAllChildren()
    systemFonts.fntFormal12:destroy()
    systemFonts.fntFormal10:destroy()
    systemFonts.fntExocet10:destroy()
    systemFonts.fntRediculous:destroy()
    cursorSprite:destroy()
end
