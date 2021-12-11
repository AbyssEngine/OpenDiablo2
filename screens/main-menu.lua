local MainMenu = {
}
MainMenu.__index = MainMenu

function MainMenu:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

function MainMenu:initialize()
    abyss.playBackgroundMusic(ResourceDefs.BGMTitle)
    self.rootNode = abyss.getRootNode()

    -- OpenDiablo Version Label
    self.lblVersion = abyss.createLabel(SystemFonts.FntFormal12)
    self.lblVersion:setPosition(790, 0)
    self.lblVersion.caption = "OpenDiablo II v0.01"
    self.lblVersion:setAlignment("end", "middle")

    -- Disclaimer Label
    self.lblDisclaimer = abyss.createLabel(SystemFonts.FntFormal10)
    self.lblDisclaimer.caption = "OpenDiablo II is neither developed by, nor endorsed by Blizzard or its parent company Activision"
    self.lblDisclaimer:setPosition(400, 580)
    self.lblDisclaimer:setAlignment("middle", "start")
    self.lblDisclaimer:setColorMod(0xFF, 0xFF, 0x8C)

    -- Trademark Screen
    self.trademarkBg = abyss.createSprite(ResourceDefs.TrademarkScreen, ResourceDefs.Palette.Sky)
    self.trademarkBg:setCellSize(4, 3)
    self.trademarkBg:onMouseButtonDown(function(buttons)
        abyss.resetMouseState();
        self.trademarkBg.active = false
        self.mainBg.active = true
        self = nil
    end)

    -- Main Background
    self.mainBg = abyss.createSprite(ResourceDefs.GameSelectScreen, ResourceDefs.Palette.Sky)
    self.mainBg:setCellSize(4, 3)
    self.mainBg.active = false

    -- D2 Logo Left Black BG
    self.d2LogoLeftBlackBg = abyss.createSprite(ResourceDefs.Diablo2LogoBlackLeft, ResourceDefs.Palette.Sky)
    self.d2LogoLeftBlackBg:setPosition(400, 120)
    self.d2LogoLeftBlackBg.bottomOrigin = true
    self.d2LogoLeftBlackBg.playMode = "forwards"

    -- D2 Logo Right Black BG
    self.d2LogoRightBlackBg = abyss.createSprite(ResourceDefs.Diablo2LogoBlackRight, ResourceDefs.Palette.Sky)
    self.d2LogoRightBlackBg:setPosition(400, 120)
    self.d2LogoRightBlackBg.bottomOrigin = true
    self.d2LogoRightBlackBg.playMode = "forwards"

    -- D2 Logo Left
    self.d2LogoLeft = abyss.createSprite(ResourceDefs.Diablo2LogoFireLeft, ResourceDefs.Palette.Sky)
    self.d2LogoLeft:setPosition(400, 120)
    self.d2LogoLeft.blendMode = "additive"
    self.d2LogoLeft.bottomOrigin = true
    self.d2LogoLeft.playMode = "forwards"

    -- D2 Logo Right
    self.d2LogoRight = abyss.createSprite(ResourceDefs.Diablo2LogoFireRight, ResourceDefs.Palette.Sky)
    self.d2LogoRight:setPosition(400, 120)
    self.d2LogoRight.blendMode = "additive"
    self.d2LogoRight.bottomOrigin = true
    self.d2LogoRight.playMode = "forwards"

    -- Cinematics Window
    self.cinematicsDialog = self:createCinematicsWindow(self)

    -- Menu Buttons
    self.btnSinglePlayer = CreateButton(ButtonTypes.Wide, 264, 290, "Single Player", function()
        -- TODO
    end)

    self.btnLocalNetplay = CreateButton(ButtonTypes.Wide, 264, 330, "Local NetPlay", function()
        -- TODO
    end)

    self.btnMapEngineDebug = CreateButton(ButtonTypes.Wide, 264, 400, "Map Engine Test", function()
        SetScreen(Screen.MAP_ENGINE_TEST)
    end)

    self.btnCredits = CreateButton(ButtonTypes.Short, 264, 472, "Credits", function()
         SetScreen(Screen.CREDITS)
    end)

    local this = self;

    self.btnCinematics = CreateButton(ButtonTypes.Short, 401, 472, "Cinematics", function()
        this.cinematicsDialog.show()
        this.btnSinglePlayer.active = false
        this.btnLocalNetplay.active = false
        this.btnExitGame.active = false
        this.btnCredits.active = false
        this.btnCinematics.active = false
        this.btnMapEngineDebug.active = false
    end)

    self.btnExitGame = CreateButton(ButtonTypes.Wide, 264, 500, "Exit to Desktop", function()
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

    self.rootNode:appendChild(self.cinematicsDialog.window)

    if ShowTrademarkScreen == false then
        self.trademarkBg.active = false
        self.mainBg.active = true
    else
        ShowTrademarkScreen = false
    end
end

function MainMenu:createCinematicsWindow(main)
    local result = {
        window = abyss.createSprite(ResourceDefs.CinematicsBackground, ResourceDefs.Palette.Sky),
        main = main
    }

    result.window:setCellSize(2, 2)
    result.window:setPosition(237, 80)

    result.lblHeader = abyss.createLabel(SystemFonts.Fnt30)
    result.lblHeader.caption = "Select Cinematics"
    result.lblHeader:setPosition(163, 20)
    result.lblHeader:setAlignment("middle", "start")

    result.btnSistersLament = CreateButton(ButtonTypes.Wide, 30, 70, "THE SISTER'S LAMENT", function()
        abyss.playVideo("/data/local/video/" .. Language:code() .. "/d2intro640x292.bik")
    end)

    result.btnDesertJourney = CreateButton(ButtonTypes.Wide, 30, 110, "DESERT JOURNEY", function()
        abyss.playVideo("/data/local/video/" .. Language:code() .. "/Act02start640x292.bik")
    end)

    result.btnMephistosJungle = CreateButton(ButtonTypes.Wide, 30, 150, "MEPHISTO'S JUNGLE", function()
        abyss.playVideo("/data/local/video/" .. Language:code() .. "/Act03start640x292.bik")
    end)

    result.btnEnterHell = CreateButton(ButtonTypes.Wide, 30, 190, "ENTER HELL", function()
        abyss.playVideo("/data/local/video/" .. Language:code() .. "/Act04start640x292.bik")
    end)

    result.btnTerrorsEnd = CreateButton(ButtonTypes.Wide, 30, 230, "TERROR'S END", function()
        abyss.playVideo("/data/local/video/" .. Language:code() .. "/Act04end640x292.bik")
    end)

    result.btnSearchForBaal = CreateButton(ButtonTypes.Wide, 30, 270, "SEARCH FOR BAAL", function()
        abyss.playVideo("/data/local/video/" .. Language:code() .. "/D2x_Intro_640x292.bik")
    end)

    result.btnDestructionsEnd = CreateButton(ButtonTypes.Wide, 30, 310, "DESTRUCTION'S END", function()
        abyss.playVideo("/data/local/video/" .. Language:code() .. "/D2x_Out_640x292.bik")
    end)

    result.btnCancel = CreateButton(ButtonTypes.Medium, 100, 375, "CANCEL", function()
        result.main.btnSinglePlayer.active = true
        result.main.btnLocalNetplay.active = true
        result.main.btnExitGame.active = true
        result.main.btnCredits.active = true
        result.main.btnCinematics.active = true
        result.main.btnMapEngineDebug.active = true
        result:hide()
    end)

    result.window:appendChild(result.lblHeader)
    result.window:appendChild(result.btnSistersLament)
    result.window:appendChild(result.btnDesertJourney)
    result.window:appendChild(result.btnMephistosJungle)
    result.window:appendChild(result.btnEnterHell)
    result.window:appendChild(result.btnTerrorsEnd)
    result.window:appendChild(result.btnSearchForBaal)
    result.window:appendChild(result.btnDestructionsEnd)
    result.window:appendChild(result.btnCancel)
    result.window.active = false

    result.show = function()
        abyss.playBackgroundMusic("")
        result.window.active = true
    end

    result.hide = function()
        abyss.playBackgroundMusic(ResourceDefs.BGMTitle)
        result.window.active = false
    end

    return result
end


return MainMenu
