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
local language = require("common/language")

function MainMenu:new(c)
    c = c or {}
    self.__index = self
    return setmetatable(c, self)
end

function MainMenu:start()
    self.rootNode = getRootNode()
    self:initResources()
end

function MainMenu:createMainMenuButton(text, x, y)
    local result = createButton(self.FontExocet10, resDefs.WideButtonBlank, resDefs.Palette.Sky)
    result:segments(2, 1)
    result:size(272, 45)
    result:caption(text:upper())
    result:position(x, y)
    result:textOffset(0, -6)
    return result
end

function MainMenu:createMainMenuMinibutton(text, x, y)
    local result = createButton(self.FontRediculous, resDefs.ShortButtonBlank, resDefs.Palette.Sky)
    result:segments(1, 1)
    result:size(135, 25)
    result:caption(text:upper())
    result:position(x, y)
    result:textOffset(0, -5)
    return result
end

function MainMenu:initResources()
    self.fntFormal12 = loadSpriteFont(language.i18nPath(resDefs.FontFormal12), resDefs.Palette.Static)
    self.fntFormal10 = loadSpriteFont(language.i18nPath(resDefs.FontFormal10), resDefs.Palette.Static)
    self.FontExocet10 = loadSpriteFont(language.i18nPath(resDefs.FontExocet10), resDefs.Palette.Static)
    self.FontRediculous = loadSpriteFont(language.i18nPath(resDefs.FontRediculous), resDefs.Palette.Static)

    -- OpenDiablo Version Label
    self.lblVersion = createLabel(self.fntFormal12)
    self.lblVersion:position(790, 0)
    self.lblVersion:caption("OpenDiablo II v0.01")
    self.lblVersion:hAlign("end")

    -- Disclaimer Label
    self.lblDisclaimer = createLabel(self.fntFormal10)
    self.lblDisclaimer:caption(
        "OpenDiablo II is neither developed by, nor endorsed by Blizzard or its parent company Activision")
    self.lblDisclaimer:position(400, 580)
    self.lblDisclaimer:hAlign("middle")
    self.lblDisclaimer:colorMod(0xFF, 0xFF, 0x8C)

    -- Trademark Screen
    self.trademarkBg = loadSprite(resDefs.TrademarkScreen, resDefs.Palette.Sky)
    self.trademarkBg:cellSize(4, 3)
    self.trademarkBg:onMouseButtonDown(function(buttons)
        self.trademarkBg:active(false)
        self.mainBg:active(true)
    end)

    -- Main Background
    self.mainBg = loadSprite(resDefs.GameSelectScreen, resDefs.Palette.Sky)
    self.mainBg:cellSize(4, 3)
    self.mainBg:active(false)

    -- D2 Logo Left Black BG
    self.d2LogoLeftBlackBg = loadSprite(resDefs.Diablo2LogoBlackLeft, resDefs.Palette.Sky)
    self.d2LogoLeftBlackBg:position(400, 120)
    self.d2LogoLeftBlackBg:bottomOrigin(true)
    self.d2LogoLeftBlackBg:playMode("forwards")

    -- D2 Logo Right Black BG
    self.d2LogoRightBlackBg = loadSprite(resDefs.Diablo2LogoBlackRight, resDefs.Palette.Sky)
    self.d2LogoRightBlackBg:position(400, 120)
    self.d2LogoRightBlackBg:bottomOrigin(true)
    self.d2LogoRightBlackBg:playMode("forwards")

    -- D2 Logo Left
    self.d2LogoLeft = loadSprite(resDefs.Diablo2LogoFireLeft, resDefs.Palette.Sky)
    self.d2LogoLeft:position(400, 120)
    self.d2LogoLeft:blendMode("additive")
    self.d2LogoLeft:bottomOrigin(true)
    self.d2LogoLeft:playMode("forwards")

    -- D2 Logo Right
    self.d2LogoRight = loadSprite(resDefs.Diablo2LogoFireRight, resDefs.Palette.Sky)
    self.d2LogoRight:position(400, 120)
    self.d2LogoRight:blendMode("additive")
    self.d2LogoRight:bottomOrigin(true)
    self.d2LogoRight:playMode("forwards")

    -- Menu Buttons
    self.btnSinglePlayer = self:createMainMenuButton("Single Player", 264, 290)
    self.btnLocalNetplay = self:createMainMenuButton("Local NetPlay", 264, 330)
    self.btnMapEngineDebug = self:createMainMenuButton("Map Engine Debug", 264, 400)
    self.btnExitGame = self:createMainMenuButton("Exit to Desktop", 264, 500)
    self.btnCredits = self:createMainMenuMinibutton("Credits", 264, 472)
    self.btnCinematics = self:createMainMenuMinibutton("Cinematics", 401, 472)

    -- Append all nodes to the scene graph
    self.rootNode:appendChild(self.trademarkBg)
    self.rootNode:appendChild(self.mainBg)
    self.rootNode:appendChild(self.d2LogoLeftBlackBg)
    self.rootNode:appendChild(self.d2LogoRightBlackBg)
    self.rootNode:appendChild(self.d2LogoLeft)
    self.rootNode:appendChild(self.d2LogoRight)
    self.mainBg:appendChild(self.lblVersion)
    self.mainBg:appendChild(self.lblDisclaimer)
    self.mainBg:appendChild(self.btnSinglePlayer)
    self.mainBg:appendChild(self.btnLocalNetplay)
    self.mainBg:appendChild(self.btnExitGame)
    self.mainBg:appendChild(self.btnCredits)
    self.mainBg:appendChild(self.btnCinematics)
    self.mainBg:appendChild(self.btnMapEngineDebug)

end

return MainMenu
