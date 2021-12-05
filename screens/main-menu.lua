local MainMenu = {
}
MainMenu.__index = MainMenu

function MainMenu:new(showSplash)
    local this = {}
    setmetatable(this, self)
    self:initialize(showSplash)
    return this
end

function MainMenu:initialize()
    self.rootNode = abyss.getRootNode()
    self.rootNode:removeAllChildren()
    abyss.resetMouseState()

    -- OpenDiablo Version Label
    self.lblVersion = abyss.loadLabel(SystemFonts.FntFormal12)
    self.lblVersion:setPosition(790, 0)
    self.lblVersion:setCaption("OpenDiablo II v0.01")
    self.lblVersion:setAlignment("end", "middle")

    -- Disclaimer Label
    self.lblDisclaimer = abyss.loadLabel(SystemFonts.FntFormal10)
    self.lblDisclaimer:setCaption("OpenDiablo II is neither developed by, nor endorsed by Blizzard or its parent company Activision")
    self.lblDisclaimer:setPosition(400, 580)
    self.lblDisclaimer:setAlignment("middle", "start")
    self.lblDisclaimer:setColorMod(0xFF, 0xFF, 0x8C)

    -- Trademark Screen
    self.trademarkBg = abyss.loadSprite(ResourceDefs.TrademarkScreen, ResourceDefs.Palette.Sky)
    self.trademarkBg:setCellSize(4, 3)
    self.trademarkBg:onMouseButtonDown(function(buttons)
        abyss.resetMouseState();
        self.trademarkBg.active = false
        self.mainBg.active = true
        self = nil
    end)

    -- Main Background
    self.mainBg = abyss.loadSprite(ResourceDefs.GameSelectScreen, ResourceDefs.Palette.Sky)
    self.mainBg:setCellSize(4, 3)
    self.mainBg.active = false

    -- D2 Logo Left Black BG
    self.d2LogoLeftBlackBg = abyss.loadSprite(ResourceDefs.Diablo2LogoBlackLeft, ResourceDefs.Palette.Sky)
    self.d2LogoLeftBlackBg:setPosition(400, 120)
    self.d2LogoLeftBlackBg.bottomOrigin = true
    self.d2LogoLeftBlackBg.playMode = "forwards"

    -- D2 Logo Right Black BG
    self.d2LogoRightBlackBg = abyss.loadSprite(ResourceDefs.Diablo2LogoBlackRight, ResourceDefs.Palette.Sky)
    self.d2LogoRightBlackBg:setPosition(400, 120)
    self.d2LogoRightBlackBg.bottomOrigin = true
    self.d2LogoRightBlackBg.playMode = "forwards"

    -- D2 Logo Left
    self.d2LogoLeft = abyss.loadSprite(ResourceDefs.Diablo2LogoFireLeft, ResourceDefs.Palette.Sky)
    self.d2LogoLeft:setPosition(400, 120)
    self.d2LogoLeft.blendMode = "additive"
    self.d2LogoLeft.bottomOrigin = true
    self.d2LogoLeft.playMode = "forwards"

    -- D2 Logo Right
    self.d2LogoRight = abyss.loadSprite(ResourceDefs.Diablo2LogoFireRight, ResourceDefs.Palette.Sky)
    self.d2LogoRight:setPosition(400, 120)
    self.d2LogoRight.blendMode = "additive"
    self.d2LogoRight.bottomOrigin = true
    self.d2LogoRight.playMode = "forwards"

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
    self.btnCredits:onActivate(function() SetScreen(Screen.CREDITS) end)

    self.btnCinematics = self:createMainMenuMinibutton("Cinematics", 401, 472)
    self.btnCinematics:onActivate(function()
        -- TODO
    end)

    self.btnExitGame = self:createMainMenuButton("Exit to Desktop", 264, 500)
    self.btnExitGame:onActivate(function()
        abyss.shutdown()
    end)

    -- Append all nodes to the scene graph
    self.mainBg:appendChild(self.lblVersion)
    self.mainBg:appendChild(self.lblDisclaimer)
    self.mainBg:appendChild(self.btnSinglePlayer)
    self.mainBg:appendChild(self.btnLocalNetplay)
    self.mainBg:appendChild(self.btnExitGame)
    self.mainBg:appendChild(self.btnCredits)
    self.mainBg:appendChild(self.btnCinematics)
    self.mainBg:appendChild(self.btnMapEngineDebug)
    self.rootNode:appendChild(self.trademarkBg)
    self.rootNode:appendChild(self.mainBg)
    self.rootNode:appendChild(self.d2LogoLeftBlackBg)
    self.rootNode:appendChild(self.d2LogoRightBlackBg)
    self.rootNode:appendChild(self.d2LogoLeft)
    self.rootNode:appendChild(self.d2LogoRight)

    if ShowTrademarkScreen == false then
        self.trademarkBg.active = false
        self.mainBg.active = true
    else
        ShowTrademarkScreen = false
    end
end

function MainMenu:createMainMenuButton(text, x, y)
    abyss.log("debug", "Loading button: " .. text)
    local result = abyss.createButton(SystemFonts.FntExocet10, ButtonDefs.SprButtonWideBlank)
    result:setSegments(2, 1)
    result:setFixedSize(272, 35)
    result.caption = text:upper()
    result:setPosition(x, y)
    result:setTextOffset(0, -3)
    result:setFrameIndex("normal", 0)
    result:setFrameIndex("pressed", 2)
    return result
end

function MainMenu:createMainMenuMinibutton(text, x, y)
    abyss.log("debug", "Loading mini button: " .. text)
    local result = abyss.createButton(SystemFonts.FntRidiculous, ButtonDefs.SprButtonShortBlank)
    result:setSegments(1, 1)
    result:setFixedSize(135, 25)
    result.caption = text:upper()
    result:setPosition(x, y)
    result:setTextOffset(0, -5)
    result:setFrameIndex("normal", 0)
    result:setFrameIndex("pressed", 1)
    return result
end

return MainMenu
