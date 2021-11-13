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

function MainMenu:start(showSplash)
    self.rootNode = getRootNode()
   	self.rootNode:removeAllChildren()
   	resetMouseState()
    self:initResources()
    
    if showSplash == false then
		self.trademarkBg:active(false)
		self.mainBg:active(true)
    end
end

function MainMenu:createMainMenuButton(text, x, y)
    local result = createButton(systemFonts.fntExocet10, resDefs.WideButtonBlank, resDefs.Palette.Sky)
    result:segments(2, 1)
    result:size(272, 35)
    result:caption(text:upper())
    result:position(x, y)
    result:textOffset(0, -2)
    result:frameIndex("normal", 0)
    result:frameIndex("pressed", 2)
    return result
end

function MainMenu:createMainMenuMinibutton(text, x, y)
    local result = createButton(systemFonts.fntRediculous, resDefs.ShortButtonBlank, resDefs.Palette.Sky)
    result:segments(1, 1)
    result:size(135, 25)
    result:caption(text:upper())
    result:position(x, y)
    result:textOffset(0, -5)
    result:frameIndex("normal", 0)
    result:frameIndex("pressed", 1)
    return result
end

function MainMenu:initResources()
    -- OpenDiablo Version Label
    self.lblVersion = createLabel(systemFonts.fntFormal12)
    self.lblVersion:position(790, 0)
    self.lblVersion:caption("OpenDiablo II v0.01")
    self.lblVersion:hAlign("end")

    -- Disclaimer Label
    self.lblDisclaimer = createLabel(systemFonts.fntFormal10)
    self.lblDisclaimer:caption(
        "OpenDiablo II is neither developed by, nor endorsed by Blizzard or its parent company Activision")
    self.lblDisclaimer:position(400, 580)
    self.lblDisclaimer:hAlign("middle")
    self.lblDisclaimer:colorMod(0xFF, 0xFF, 0x8C)

    -- Trademark Screen
    self.trademarkBg = loadSprite(resDefs.TrademarkScreen, resDefs.Palette.Sky)
    self.trademarkBg:cellSize(4, 3)
    self.trademarkBg:onMouseButtonDown(function(buttons)
	    resetMouseState()
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
    self.btnSinglePlayer:onActivate(function()
    	-- TODO
    end)
    
    self.btnLocalNetplay = self:createMainMenuButton("Local NetPlay", 264, 330)
    self.btnLocalNetplay:onActivate(function()
    	-- TODO
    end)
    
    self.btnMapEngineDebug = self:createMainMenuButton("Map Engine Debug", 264, 400)
    self.btnMapEngineDebug:onActivate(function()
    	-- TODO
    end)
            
    self.btnCredits = self:createMainMenuMinibutton("Credits", 264, 472)
    self.btnCredits:onActivate(function()
		credits = require("credits"):new()
		credits:start()
    end)
    
    self.btnCinematics = self:createMainMenuMinibutton("Cinematics", 401, 472)
    self.btnCinematics:onActivate(function()
    	-- TODO
    end)
    
    self.btnExitGame = self:createMainMenuButton("Exit to Desktop", 264, 500)
    self.btnExitGame:onActivate(function()
        globalsDestroy()
		shutdown()
    end)

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
