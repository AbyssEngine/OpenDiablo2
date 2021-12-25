function InitUI()
    local imgButtonTallBlank = abyss.loadImage(ResourceDefs.TallButtonBlank, ResourceDefs.Palette.Sky)
    local imgButtonWideBlank = abyss.loadImage(ResourceDefs.WideButtonBlank, ResourceDefs.Palette.Sky)
    local imgButtonShortBlank = abyss.loadImage(ResourceDefs.ShortButtonBlank, ResourceDefs.Palette.Sky)
    local imgButtonMediumBlank = abyss.loadImage(ResourceDefs.MediumButtonBlank, ResourceDefs.Palette.Sky)
    local imgCheckbox
    if abyss.fileExists("/data/hd/global/ui/lobby/creategame/creategame_advancedcheckbox.lowend.sprite") then
        imgCheckbox = abyss.loadImage("/data/hd/global/ui/lobby/creategame/creategame_advancedcheckbox.lowend.sprite", "")
    else
        -- TODO do something for non-D2R. Currently this is used only for D2R though.
        imgCheckbox = imgButtonShortBlank
    end

    TextColor = {
        --blackHalfOpacity = 0x0000007f
        LightBrown = { R = 188, G = 168, B = 140 },
        LightGreen = { R = 24, G = 255, B = 0 },
        White = { R = 255, G = 255, B = 255 },
        Red = { R = 255, G = 0, B = 0},
    }

    ButtonTypes = {
        Tall = {
            Font                = SystemFonts.FntExocet10,
            Image               = imgButtonTallBlank,
            Segments            = { X =   1, Y =   1 },
            FixedSize           = { X = 168, Y =  60 },
            TextOffset          = { X =   0, Y =  -5 },
            TextVerticalSpacing = 4,
            TextColor           = TextColor.White,
            LabelBlend          = "multiply",
            Uppercase           = true,
            FrameIndexes        = { ["normal"] = 0, ["pressed"] = 1 }
        },
        Wide = {
            Font                = SystemFonts.FntExocet10,
            Image               = imgButtonWideBlank,
            Segments            = { X =   2, Y =   1 },
            FixedSize           = { X = 272, Y =  35 },
            TextOffset          = { X =   0, Y =  -3 },
            TextColor           = TextColor.White,
            LabelBlend          = "multiply",
            Uppercase           = true,
            FrameIndexes        = { ["normal"] = 0, ["pressed"] = 2 }
        },
        Medium = {
            Font                = SystemFonts.FntExocet10,
            Image               = imgButtonMediumBlank,
            Segments            = { X =   1, Y =   1 },
            FixedSize           = { X = 128, Y =  35 },
            TextOffset          = { X =   0, Y =  -2 },
            TextColor           = TextColor.White,
            LabelBlend          = "multiply",
            Uppercase           = true,
            FrameIndexes        = { ["normal"] = 0, ["pressed"] = 1 }
        },
        Short = {
            Font                = SystemFonts.FntRidiculous,
            Image               = imgButtonShortBlank,
            Segments            = { X =   1, Y =   1 },
            FixedSize           = { X = 135, Y =  25 },
            TextOffset          = { X =   0, Y =  -5 },
            TextColor           = TextColor.White,
            LabelBlend          = "multiply",
            Uppercase           = true,
            FrameIndexes        = { ["normal"] = 0, ["pressed"] = 1 }
        },
        Checkbox = {
            Font                = SystemFonts.FntFormal12,
            Image               = imgCheckbox,
            Segments            = { X =   1, Y =   1 },
            FixedSize           = { X = 135, Y =  25 },
            TextOffset          = { X =  20, Y =  -5 },
            TextColor           = TextColor.White,
            LabelBlend          = "none",
            Uppercase           = false,
            FrameIndexes        = { normal = 0, hover = 3, pressed = 1, checkednormal = 4, checkedhover = 6, checkedpressed = 5, disabled = 2 }
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
    local label = abyss.createLabel(buttonSpec.Font)
    label:setAlignment("middle", "middle")
    label:setPosition(math.floor(buttonSpec.FixedSize.X / 2) + buttonSpec.TextOffset.X, math.floor(buttonSpec.FixedSize.Y / 2) + buttonSpec.TextOffset.Y)
    label:setColorMod(buttonSpec.TextColor.R, buttonSpec.TextColor.G, buttonSpec.TextColor.B)
    if buttonSpec.TextVerticalSpacing ~= nil then label.verticalSpacing = buttonSpec.TextVerticalSpacing end
    local result = abyss.createButton(buttonSpec.Image)
    result.data.label = label
    result:appendChild(label)
    result:setSegments(buttonSpec.Segments.X, buttonSpec.Segments.Y)
    result:setFixedSize(buttonSpec.FixedSize.X, buttonSpec.FixedSize.Y)
    if buttonSpec.Uppercase then
        label.caption = text:upper()
    else
        label.caption = text
    end
    label.blendMode = buttonSpec.LabelBlend
    result:setPosition(x, y)
    result:setPressedOffset(-2, 2)
    result:onActivate(onActivate)
    result:onPressed(function()
        ButtonPressedSfx:play()
    end)
    result:onMouseEnter(function()
        IsOnButton=true
    end)
    result:onMouseLeave(function()
        IsOnButton=false
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

function CreateUniqueSpriteFromFile(file, palette)
    local img = abyss.loadImage(file, palette)
    local spr = abyss.createSprite(img)
    spr.data.img = img
    return spr
end
