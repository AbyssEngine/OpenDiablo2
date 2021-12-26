local CharacterSelection = {
}

function CharacterSelection:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

function CharacterSelection:initialize()
	local rootLabelOffsetX   = 115
	local rootLabelOffsetY   = 100
	local labelHeight        = 15

	local selectionBoxNumColumns   = 2
	local selectionBoxNumRows      = 4
	local selectionBoxWidth        = 272
	local selectionBoxHeight       = 92
	local selectionBoxOffsetX      = 37
	local selectionBoxOffsetY      = 86
	local selectionBoxImageOffsetX = 40
	local selectionBoxImageOffsetY = 50

	local newCharBtnX, newCharBtnY         = 33, 468
	local convertCharBtnX, convertCharBtnY = 233, 468
	local deleteCharBtnX, deleteCharBtnY   = 433, 468
	local okBtnX, okBtnY                   = 625, 537

    self.rootNode = abyss.getRootNode()
    self.rootNode:removeAllChildren()
    abyss.resetMouseState()

    self.deleteCharacterDialog = self:createDeleteCharacterWindow(self)

    -- create hero title and fill with sample value
    self.lblHeroTitle = abyss.createLabel(SystemFonts.Fnt42)
    self.lblHeroTitle:setAlignment("middle","")
    self.lblHeroTitle:setPosition(320, 23)
    self.lblHeroTitle:setColorMod(TextColor.LightBrown.R, TextColor.LightBrown.G, TextColor.LightBrown.B)
    self.lblHeroTitle.caption = "Selected Hero"

    -- new character button
    self.btnNewCharacter = CreateButton(ButtonTypes.Tall, newCharBtnX, newCharBtnY, "Create New\nCharacter", function()
        -- Todo
    end)

    -- convert character to expanson
    self.btnConvertCharacter = CreateButton(ButtonTypes.Tall, convertCharBtnX, convertCharBtnY, "Convert To\nExpansion", function()
        -- Todo
    end)
    self.btnConvertCharacter.disabled=true

    -- delete character button
    self.btnDeleteCharacter = CreateButton(ButtonTypes.Tall, deleteCharBtnX, deleteCharBtnY, "Delete\nCharacter", function()
        --self.deleteCharacterDialog.show()
        -- this is currently broken willfix laer
    end)
    self.btnDeleteCharacter.disabled=true

    -- ok button to enter game
    self.btnOk = CreateButton(ButtonTypes.Medium, okBtnX, okBtnY, "Ok", function()
        -- Todo
    end)

    -- exit button to return to main menu
    self.btnExit = CreateButton(ButtonTypes.Medium, 33, 543, "Exit", function()
        SetScreen(Screen.MAIN_MENU)
    end)

    -- Main Background
    self.mainBg = CreateUniqueSpriteFromFile(ResourceDefs.CharacterSelectionBackground, ResourceDefs.Palette.Sky)
    self.mainBg:setCellSize(4, 3)
    
    self.rootNode:appendChild(self.mainBg)
    self.mainBg:appendChild(self.btnExit)
    self.mainBg:appendChild(self.btnNewCharacter)
    self.mainBg:appendChild(self.btnConvertCharacter)
    self.mainBg:appendChild(self.btnDeleteCharacter)
    self.mainBg:appendChild(self.btnOk)
    self.mainBg:appendChild(self.lblHeroTitle)
    self.mainBg:appendChild(self.deleteCharacterDialog.window)

end

function CharacterSelection:createDeleteCharacterWindow(main)
    local result = {
        window = CreateUniqueSpriteFromFile(ResourceDefs.CinematicsBackground, ResourceDefs.Palette.Sky),
        main = main,
        buttons = {}
    }

    local deleteCancelX, deleteCancelY     = 282, 308
	local deleteOkX, deleteOkY             = 422, 308
	local exitBtnX, exitBtnY               = 33, 537

    result.window:setCellSize(2, 2)
    result.window:setPosition(237, 80)


    result.lblHeader = abyss.createLabel(SystemFonts.Fnt30)
    result.lblHeader.caption = "Temporary"
    result.lblHeader:setPosition(163, 10)
    result.lblHeader:setAlignment("middle", "start")

    result.btnCancel = CreateButton(ButtonTypes.Medium, deleteCancelX, deleteCancelY, "No", function()
        result:hide()
    end)

    result.window:appendChild(result.lblHeader)
    result.window:appendChild(result.btnCancel)
    result.window.active = false

    result.show = function()
        result.window.active = true
    end

    result.hide = function()
        result.window.active = false
    end

    return result
end


return CharacterSelection
