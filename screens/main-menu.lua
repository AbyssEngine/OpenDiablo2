local MainMenu = {
}

function MainMenu:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

function MainMenu:initialize()
    if abyss.fileExists("/data/hd/global/music/introedit_hd.flac") then
        abyss.playBackgroundMusic("/data/hd/global/music/introedit_hd.flac")
    else
        abyss.playBackgroundMusic(ResourceDefs.BGMTitle)
    end
    self.rootNode = abyss.getRootNode()

    -- OpenDiablo Version Label
    self.lblVersion = abyss.createLabel(SystemFonts.FntFormal12)
    self.lblVersion:setPosition(790, 0)
    self.lblVersion.caption = "OpenDiablo II v0.01"
    self.lblVersion:setAlignment("end", "start")

    -- Disclaimer Labels
    self.lblDisclaimer1 = abyss.createLabel(SystemFonts.FntFormal12)
    --self.lblDisclaimer1.caption = Language:translate("@strcopyrightinfo#5104")
    self.lblDisclaimer1.caption = Language:translate("@strcopyrightinfoX#1882")
    self.lblDisclaimer1:setPosition(400, 470)
    self.lblDisclaimer1:setAlignment("middle", "start")
    self.lblDisclaimer1:setColorMod(0xE5, 0xC6, 0x9B)

    self.lblDisclaimer2 = abyss.createLabel(SystemFonts.FntFormal12)
    self.lblDisclaimer2.caption = Language:translate("@strallrightsreserved#5105")
    self.lblDisclaimer2.maxWidth = 500
    self.lblDisclaimer2:setPosition(400, 490)
    self.lblDisclaimer2:setAlignment("middle", "start")
    self.lblDisclaimer2:setColorMod(0xE5, 0xC6, 0x9B)

    self.lblDisclaimer3 = abyss.createLabel(SystemFonts.FntFormal12)
    self.lblDisclaimer3.caption = "OpenDiablo II is neither developed by,\nnor endorsed by Blizzard or its parent company Activision"
    self.lblDisclaimer3.maxWidth = 500
    self.lblDisclaimer3:setPosition(400, 540)
    self.lblDisclaimer3:setAlignment("middle", "start")
    self.lblDisclaimer3:setColorMod(0xFF, 0xFF, 0x8C)

    -- Trademark Screen
    self.trademarkBg = CreateUniqueSpriteFromFile(ResourceDefs.TrademarkScreen, ResourceDefs.Palette.Sky)
    self.trademarkBg:setCellSize(4, 3)
    self.trademarkBg:onMouseButtonDown(function(buttons)
        abyss.resetMouseState();
        self.trademarkBg.active = false
        self.mainBg.active = true
        self = nil
    end)

    -- Main Background
    self.mainBg = CreateUniqueSpriteFromFile(ResourceDefs.GameSelectScreen, ResourceDefs.Palette.Sky)
    self.mainBg:setCellSize(4, 3)
    self.mainBg.active = false

    -- D2 Logo Left Black BG
    self.d2LogoLeftBlackBg = CreateUniqueSpriteFromFile(ResourceDefs.Diablo2LogoBlackLeft, ResourceDefs.Palette.Sky)
    self.d2LogoLeftBlackBg:setPosition(400, 120)
    self.d2LogoLeftBlackBg.bottomOrigin = true
    self.d2LogoLeftBlackBg.playMode = "forwards"

    -- D2 Logo Right Black BG
    self.d2LogoRightBlackBg = CreateUniqueSpriteFromFile(ResourceDefs.Diablo2LogoBlackRight, ResourceDefs.Palette.Sky)
    self.d2LogoRightBlackBg:setPosition(400, 120)
    self.d2LogoRightBlackBg.bottomOrigin = true
    self.d2LogoRightBlackBg.playMode = "forwards"

    -- D2 Logo Left
    self.d2LogoLeft = CreateUniqueSpriteFromFile(ResourceDefs.Diablo2LogoFireLeft, ResourceDefs.Palette.Sky)
    self.d2LogoLeft:setPosition(400, 120)
    self.d2LogoLeft.blendMode = "additive"
    self.d2LogoLeft.bottomOrigin = true
    self.d2LogoLeft.playMode = "forwards"

    -- D2 Logo Right
    self.d2LogoRight = CreateUniqueSpriteFromFile(ResourceDefs.Diablo2LogoFireRight, ResourceDefs.Palette.Sky)
    self.d2LogoRight:setPosition(400, 120)
    self.d2LogoRight.blendMode = "additive"
    self.d2LogoRight.bottomOrigin = true
    self.d2LogoRight.playMode = "forwards"

    -- Cinematics Window
    self.cinematicsDialog = self:createCinematicsWindow(self)

    -- Menu Buttons
    self.btnSinglePlayer = CreateButton(ButtonTypes.Wide, 264, 290, "@strStartMenu1#5106", function()
        SetScreen(Screen.CHARACTER_SELECTION)
        -- TODO
    end)

    self.btnLocalNetplay = CreateButton(ButtonTypes.Wide, 264, 330, "LOCAL NETPLAY", function()
        dumplayout()
        -- TODO
    end)

    self.btnMapEngineDebug = CreateButton(ButtonTypes.Wide, 264, 400, "MAP ENGINE TEST", function()
        SetScreen(Screen.MAP_ENGINE_TEST)
    end)

    self.btnCredits = CreateButton(ButtonTypes.Short, 264, 472, "@strGameCredits#5110", function()
        SetScreen(Screen.CREDITS)
    end)

    local this = self;
    self.btnCinematics = CreateButton(ButtonTypes.Short, 401, 472, "@strGameCinematics#5111", function()
        this.cinematicsDialog.show()
        this.btnSinglePlayer.active = false
        this.btnLocalNetplay.active = false
        this.btnExitGame.active = false
        this.btnCredits.active = false
        this.btnCinematics.active = false
        this.btnMapEngineDebug.active = false
    end)

    self.btnExitGame = CreateButton(ButtonTypes.Wide, 264, 500, "@strexitentiregame#5109", function()
        abyss.shutdown()
    end)

    -- Append all nodes to the scene graph
    self.trademarkBg:appendChild(self.lblDisclaimer1)
    self.trademarkBg:appendChild(self.lblDisclaimer2)
    self.trademarkBg:appendChild(self.lblDisclaimer3)
    self.mainBg:appendChild(self.lblVersion)
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

    --local testLayout = LayoutLoader:load('HUDPanel.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('PlayerInventoryExpansionLayout.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('PlayerInventoryOriginalLayout.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('CharacterStatsPanel.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('CharacterCreatePanel.json', ResourceDefs.Palette.Fechar)
    --local testLayout = LayoutLoader:load('QuestLogPanelOriginal.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('QuestLogPanelExpansion.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('HirelingInventoryPanel.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('WaypointsPanelOriginal.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('WaypointsPanelExpansion.json', ResourceDefs.Palette.Sky)
    --local testLayout = LayoutLoader:load('VendorPanelLayout.json', ResourceDefs.Palette.Sky)
    --self.testLayout = testLayout
    --if testLayout then
    --    self.rootNode:appendChild(testLayout)
    --end

    if ShowTrademarkScreen == false then
        self.trademarkBg.active = false
        self.mainBg.active = true
    else
        ShowTrademarkScreen = false
    end
end

function MainMenu:createCinematicsWindow(main)
    local result = {
        window = CreateUniqueSpriteFromFile(ResourceDefs.CinematicsBackground, ResourceDefs.Palette.Sky),
        main = main,
        buttons = {}
    }

    result.window:setCellSize(2, 2)
    result.window:setPosition(237, 80)

    local showHD = false
    if abyss.fileExists("/data/hd/global/video/d2intro.webm") then
        showHD = true
    end

    result.lblHeader = abyss.createLabel(SystemFonts.Fnt30)
    result.lblHeader.caption = Language:translate("@strselectcinematics#5114")
    result.lblHeader:setPosition(163, cond(showHD, 10, 20))
    result.lblHeader:setAlignment("middle", "start")

    local files = {{
        name = "@act1X",
        bik = "d2intro640x292.bik",
        hd = "d2intro",
    }, {
        name = "@act2X",
        bik = "Act02start640x292.bik",
        hd = "act2/act02start",
    }, {
        name = "@act3X",
        bik = "Act03start640x292.bik",
        hd = "act3/act03start",
    }, {
        name = "@act4X",
        bik = "Act04start640x292.bik",
        hd = "act4/act04start",
    }, {
        name = "@strepilogueX",
        bik = "Act04end640x292.bik",
        hd = "act4/act04end",
    }, {
        name = "@act5X",
        bik = "D2x_Intro_640x292.bik",
        hd = "d2x_intro",
    }, {
        name = "@strlastcinematic",
        bik = "D2x_Out_640x292.bik",
        hd = "act5/d2x_out",
    }}

    local y = cond(showHD, 60, 70)

    for _, item in ipairs(files) do
        local btn = CreateButton(ButtonTypes.Wide, 30, y, item.name, function()
            if result.btnToggleHD.checked then
                abyss.playVideoAndAudio("/data/hd/global/video/" .. item.hd .. ".webm", Language:hdaudioPath("/data/hd/local/video/" .. item.hd .. ".flac"))
            else
                if abyss.fileExists("/data/global/video/" .. item.hd .. ".webm") then
                    abyss.playVideoAndAudio("/data/global/video/" .. item.hd .. ".webm", Language:hdaudioPath("/data/local/video/" .. item.hd .. ".flac"))
                else
                    abyss.playVideo("/data/local/video/" .. Language:code3() .. "/" .. item.bik)
                end
            end
        end)

        table.insert(result.buttons, btn)
        result.window:appendChild(btn)

        y = y + 40
    end

    result.btnToggleHD = CreateCheckbox(120, 343, "HD video")
    if showHD then
        result.btnToggleHD.checked = true
        result.window:appendChild(result.btnToggleHD)
    end

    result.btnCancel = CreateButton(ButtonTypes.Medium, 100, 375, "@strCancel#5103", function()
        result.main.btnSinglePlayer.active = true
        result.main.btnLocalNetplay.active = true
        result.main.btnExitGame.active = true
        result.main.btnCredits.active = true
        result.main.btnCinematics.active = true
        result.main.btnMapEngineDebug.active = true
        result:hide()
    end)

    result.window:appendChild(result.lblHeader)
    result.window:appendChild(result.btnCancel)
    result.window.active = false

    result.show = function()
        abyss.playBackgroundMusic("")
        result.window.active = true
    end

    result.hide = function()
        if abyss.fileExists("/data/hd/global/music/introedit_hd.flac") then
            abyss.playBackgroundMusic("/data/hd/global/music/introedit_hd.flac")
        else
            abyss.playBackgroundMusic(ResourceDefs.BGMTitle)
        end
        result.window.active = false
    end

    return result
end


return MainMenu
