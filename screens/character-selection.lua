local CharacterSelection = {
}
CharacterSelection.__index = CharacterSelection

local lblHeroTitle, deleteCharacterDialog, rootNode
local btnConvertCharacter, btnExit, btnNewCharacter, btnOk, btnDeleteCharacter

local function createDeleteCharacterWindow()
    local result = {
        window = CreateUniqueSpriteFromFile(ResourceDefs.CinematicsBackground, ResourceDefs.Palette.Sky),
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

-- Local functions must be declared before the exposed functions

local function initialize()
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

    rootNode = abyss.getRootNode()

    deleteCharacterDialog = createDeleteCharacterWindow()

    -- create hero title and fill with sample value
    lblHeroTitle = abyss.createLabel(SystemFonts.Fnt42)
    lblHeroTitle:setAlignment("middle","")
    lblHeroTitle:setPosition(320, 23)
    lblHeroTitle:setColorMod(TextColor.LightBrown.R, TextColor.LightBrown.G, TextColor.LightBrown.B)
    lblHeroTitle.caption = "Selected Hero"

    -- new character button
    -- TODO @strCreateNewCharacter#5273 when we can wrap words
    btnNewCharacter = CreateButton(ButtonTypes.Tall, newCharBtnX, newCharBtnY, "CREATE NEW\nCHARACTER", function()
        SetScreen(Screen.CHARACTER_CREATION)
        -- Todo
    end)

    -- convert character to expanson
    -- TODO @strlaunchconverttoexp#2742 when we can wrap words
    btnConvertCharacter = CreateButton(ButtonTypes.Tall, convertCharBtnX, convertCharBtnY, "CONVERT TO\nEXPANSION", function()
        -- Todo
    end)
    btnConvertCharacter.disabled=true

    -- delete character button
    -- TODO @strlaunchdeletecharexp#2744 when we can wrap words
    btnDeleteCharacter = CreateButton(ButtonTypes.Tall, deleteCharBtnX, deleteCharBtnY, "DELETE\nCHARACTER", function()
        --self.deleteCharacterDialog.show()
        -- this is currently broken willfix laer
    end)
    btnDeleteCharacter.disabled=true

    -- ok button to enter game
    btnOk = CreateButton(ButtonTypes.Medium, okBtnX, okBtnY, "@strOk#5102", function()
        -- Todo
    end)

    -- exit button to return to main menu
    btnExit = CreateButton(ButtonTypes.Medium, 33, 543, "@strExit#5101", function()
        SetScreen(Screen.MAIN_MENU)
    end)

    -- Main Background
    mainBg = CreateUniqueSpriteFromFile(ResourceDefs.CharacterSelectionBackground, ResourceDefs.Palette.Sky)
    mainBg:setCellSize(4, 3)

    rootNode:appendChild(mainBg)
    mainBg:appendChild(btnExit)
    mainBg:appendChild(btnNewCharacter)
    mainBg:appendChild(btnConvertCharacter)
    mainBg:appendChild(btnDeleteCharacter)
    mainBg:appendChild(btnOk)
    mainBg:appendChild(lblHeroTitle)
    mainBg:appendChild(deleteCharacterDialog.window)

end

function CharacterSelection:new()
    local this = {}
    setmetatable(this, self)
    initialize()
    return this
end

return CharacterSelection
