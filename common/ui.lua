function InitUI()
    local sprButtonWideBlank = abyss.createSprite(ResourceDefs.WideButtonBlank, ResourceDefs.Palette.Sky)
    local sprButtonShortBlank = abyss.createSprite(ResourceDefs.ShortButtonBlank, ResourceDefs.Palette.Sky)
    local sprButtonMediumBlank = abyss.createSprite(ResourceDefs.MediumButtonBlank, ResourceDefs.Palette.Sky)
    local sprCheckbox
    if abyss.fileExists("/data/hd/global/ui/lobby/creategame/creategame_advancedcheckbox.lowend.sprite") then
        sprCheckbox = abyss.createSprite("/data/hd/global/ui/lobby/creategame/creategame_advancedcheckbox.lowend.sprite", "")
    else
        -- TODO do something for non-D2R. Currently this is used only for D2R though.
        sprCheckbox = sprButtonShortBlank
    end

    ButtonTypes = {
        Wide = {
            Font         = SystemFonts.FntExocet10,
            Sprite       = sprButtonWideBlank,
            Segments     = { X =   2, Y =   1 },
            FixedSize    = { X = 272, Y =  35 },
            TextOffset   = { X =   0, Y =  -3 },
            LabelBlend   = "multiply",
            Uppercase    = true,
            FrameIndexes = { ["normal"] = 0, ["pressed"] = 2 }
        },
        Medium = {
            Font         = SystemFonts.FntExocet10,
            Sprite       = sprButtonMediumBlank,
            Segments     = { X =   1, Y =   1 },
            FixedSize    = { X = 128, Y =  35 },
            TextOffset   = { X =   0, Y =  -2 },
            LabelBlend   = "multiply",
            Uppercase    = true,
            FrameIndexes = { ["normal"] = 0, ["pressed"] = 1 }
        },
        Short = {
            Font         = SystemFonts.FntRidiculous,
            Sprite       = sprButtonShortBlank,
            Segments     = { X =   1, Y =   1 },
            FixedSize    = { X = 135, Y =  25 },
            TextOffset   = { X =   0, Y =  -5 },
            LabelBlend   = "multiply",
            Uppercase    = true,
            FrameIndexes = { ["normal"] = 0, ["pressed"] = 1 }
        },
        Checkbox = {
            Font         = SystemFonts.FntFormal12,
            Sprite       = sprCheckbox,
            Segments     = { X =   1, Y =   1 },
            FixedSize    = { X = 135, Y =  25 },
            TextOffset   = { X =  20, Y =  -5 },
            LabelBlend   = "none",
            Uppercase    = false,
            FrameIndexes = { normal = 0, hover = 3, pressed = 1, checkednormal = 4, checkedhover = 6, checkedpressed = 5, disabled = 2 }
        }
    }

    ButtonPressedSfx = LoadSoundEffect("cursor_button_click")
end

-- Creates a button
-- @buttonType The type of button to create
-- @param x The x position of the button
-- @param y The y position of the button
-- @param text The text to display on the button
function CreateButton(buttonSpec, x, y, text, onActivate)
    local result = abyss.createButton(buttonSpec.Font, buttonSpec.Sprite)
    result:setSegments(buttonSpec.Segments.X, buttonSpec.Segments.Y)
    result:setFixedSize(buttonSpec.FixedSize.X, buttonSpec.FixedSize.Y)
    if buttonSpec.Uppercase then
        result.caption = text:upper()
    else
        result.caption = text
    end
    result.labelBlendMode = buttonSpec.LabelBlend
    result:setPosition(x, y)
    result:setTextOffset(buttonSpec.TextOffset.X, buttonSpec.TextOffset.Y)
    result:onActivate(onActivate)
    result:onPressed(function()
        ButtonPressedSfx:play()
    end)

    for k, v in pairs(buttonSpec.FrameIndexes) do
        result:setFrameIndex(k, v)
    end

    return result
end

function CreateCheckbox(x, y, text)
    local btn
    btn = CreateButton(ButtonTypes.Checkbox, x, y, text, function()
        btn.checked = not btn.checked
    end)

    return btn
end
