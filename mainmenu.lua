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
local MainMenu = {}

local resDefs = require("common/resource-defs")

function MainMenu:new(c)
    c = c or {}
    self.__index = self
    return setmetatable(c, self)
end

function MainMenu:start()
    self.rootNode = getRootNode()
    self:initResources()
end

function MainMenu:initResources()
    -- Trademark Screen
    self.trademarkBg = loadSprite(resDefs.TrademarkScreen, resDefs.Palette.Sky)
    self.trademarkBg:cellSize(4, 3)

    -- Main Background
    self.mainBg = loadSprite(resDefs.GameSelectScreen, resDefs.Palette.Sky)
    self.mainBg:cellSize(4, 3)
    self.mainBg:active(false)

    -- D2 Logo Left Black BG
    self.d2LogoLeftBlackBg = loadSprite(resDefs.Diablo2LogoBlackLeft, resDefs.Palette.Sky)
    self.d2LogoLeftBlackBg:position(400, 120)
    self.d2LogoLeftBlackBg:bottomOrigin(true)
    -- self.d2LogoLeftBlackBg:playForward()

    -- D2 Logo Right Black BG
    self.d2LogoRightBlackBg = loadSprite(resDefs.Diablo2LogoBlackRight, resDefs.Palette.Sky)
    self.d2LogoRightBlackBg:position(400, 120)
    self.d2LogoRightBlackBg:bottomOrigin(true)
    -- self.d2LogoRightBlackBg:playForward()

    -- D2 Logo Left
    self.d2LogoLeft = loadSprite(resDefs.Diablo2LogoFireLeft, resDefs.Palette.Sky)
    self.d2LogoLeft:position(400, 120)
    self.d2LogoLeft:blendMode("additive")
    self.d2LogoLeft:bottomOrigin(true)
    -- self.d2LogoLeft:playForward()

    -- D2 Logo Right
    self.d2LogoRight = loadSprite(resDefs.Diablo2LogoFireRight, resDefs.Palette.Sky)
    self.d2LogoRight:position(400, 120)
    self.d2LogoRight:blendMode("additive")
    self.d2LogoRight:bottomOrigin(true)
    -- self.d2LogoRight:playForward()

    -- Append all nodes to the scene graph
    self.rootNode:appendChild(self.trademarkBg)
    self.rootNode:appendChild(self.mainBg)
    self.rootNode:appendChild(self.d2LogoLeftBlackBg)
    self.rootNode:appendChild(self.d2LogoRightBlackBg)
    self.rootNode:appendChild(self.d2LogoLeft)
    self.rootNode:appendChild(self.d2LogoRight)

end

return MainMenu
