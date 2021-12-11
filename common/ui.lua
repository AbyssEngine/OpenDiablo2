function InitUI()
    local sprButtonWideBlank = abyss.createSprite(ResourceDefs.WideButtonBlank, ResourceDefs.Palette.Sky)
    local sprButtonShortBlank = abyss.createSprite(ResourceDefs.ShortButtonBlank, ResourceDefs.Palette.Sky)
    local sprButtonMediumBlank = abyss.createSprite(ResourceDefs.MediumButtonBlank, ResourceDefs.Palette.Sky)

    ButtonTypes = {
        Wide = {
            Font         = SystemFonts.FntExocet10,
            Sprite       = sprButtonWideBlank,
            Segments     = { X =   2, Y =   1 },
            FixedSize    = { X = 272, Y =  35 },
            TextOffset   = { X =   0, Y =  -3 },
            FrameIndexes = { ["normal"] = 0, ["pressed"] = 2 }
        },
        Medium = {
            Font         = SystemFonts.FntExocet10,
            Sprite       = sprButtonMediumBlank,
            Segments     = { X =   1, Y =   1 },
            FixedSize    = { X = 128, Y =  35 },
            TextOffset   = { X =   0, Y =  -2 },
            FrameIndexes = { ["normal"] = 0, ["pressed"] = 1 }
        },
        Short = {
            Font         = SystemFonts.FntRidiculous,
            Sprite       = sprButtonShortBlank,
            Segments     = { X =   1, Y =   1 },
            FixedSize    = { X = 135, Y =  25 },
            TextOffset   = { X =   0, Y =  -5 },
            FrameIndexes = { ["normal"] = 0, ["pressed"] = 1 }
        }
    }

    ButtonPressedSfx = LoadSoundEffect("ESOUND_CURSOR_BUTTON_CLICK", "cursor_button_hd_3")
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
    result.caption = text:upper()
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
