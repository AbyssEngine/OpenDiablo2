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
local Credits = {}

local resDefs = require("common/resource-defs")
local language = require("common/language")

function Credits:new(c)
    c = c or {}
    self.__index = self
    return setmetatable(c, self)
end

function Credits:createCreditsButton(text, x, y)
    local result = createButton(systemFonts.fntExocet10, resDefs.MediumButtonBlank, resDefs.Palette.Sky)
    result:segments(1, 1)
    result:size(128, 35)
    result:caption(text:upper())
    result:position(x, y)
    result:textOffset(0, -2)
    result:frameIndex("normal", 0)
    result:frameIndex("pressed", 1)
    return result
end

function Credits:start()
    self.creditsLines = utf16to8(loadString(language.i18nPath(resDefs.CreditsText)))
    log("info", self.creditsLines)
    self.rootNode = getRootNode()
    self.rootNode:removeAllChildren()
    resetMouseState()

    self.btnExit = self:createCreditsButton("Exit", 33, 543)
    self.btnExit:onActivate(function()
        mainmenu = require("mainmenu"):new()
        mainmenu:start(false)
    end)

    -- Main Background
    self.mainBg = loadSprite(resDefs.CreditsBackground, resDefs.Palette.Sky)
    self.mainBg:cellSize(4, 3)

    self.rootNode:appendChild(self.mainBg)
    self.mainBg:appendChild(self.btnExit)

end

return Credits
