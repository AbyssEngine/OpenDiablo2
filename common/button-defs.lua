-- local resDefs = require("common/resource-defs")

-- isButtonDefsLoaded = false

local ButtonDefs = {

}
ButtonDefs.__index = ButtonDefs

function ButtonDefs:new()
    local this = {}
    setmetatable(this, self)
    self:Initialize()
    return this
end

function ButtonDefs:Initialize()
    self.SprButtonWideBlank = abyss.loadSprite(ResourceDefs.WideButtonBlank, ResourceDefs.Palette.Sky)
    self.SprButtonShortBlank = abyss.loadSprite(ResourceDefs.ShortButtonBlank, ResourceDefs.Palette.Sky)
    self.SprButtonMediumBlank = abyss.loadSprite(ResourceDefs.MediumButtonBlank, ResourceDefs.Palette.Sky)
end


return ButtonDefs

-- local greyAlpha100 = 0x646464ff
-- local lightGreyAlpha75 = 0x808080c3
-- local whiteAlpha100 = 0xffffffff

-- local buttonNoFixedWidth = -1
-- local buttonNoFixedHeight = -1

-- local function defineButton(xSeg, ySeg, dframe, dColor, tOffX, tOffY, rName, pName, fPath, aFChange, hImage, fWidth,
--     fHeight, lColor)
--     result = buttonlayout.new()
--     result:xSegments(xSeg)
--     result:ySegments(ySeg)
--     result:disabledFrame(dframe)
--     result:disabledColor(dColor)
--     result:textOffset(tOffX, tOffY)
--     result:resourceName(rName)
--     result:paletteName(pName)
--     result:fontPath(fPath)
--     result:allowFrameChange(aFChange)
--     result:hasImage(hImage)
--     result:fixedWidth(fWidth)
--     result:fixedHeight(fHeight)
--     result:labelColor(lColor)

--     -- buttonTypeWide:baseFrame()

--     -- buttonTypeWide:toggleable()
--     -- buttonTypeWide:tooltip()
--     -- buttonTypeWide:tooltipXOffset()
--     -- buttonTypeWide:tooltipYOffset()

--     return result
-- end

-- local buttonTypeWide = defineButton(2, 1, -1, lightGreyAlpha75, 8, 1, resDefs.WideButtonBlank, resDefs.Palette.Sky,
--     resDefs.FontExocet10, true, true, buttonNoFixedWidth, buttonNoFixedHeight, greyAlpha100)

-- local buttonTypeShort = defineButton(1, 1, -1, lightGreyAlpha75, 0, -1, resDefs.ShortButtonBlank, resDefs.Palette.Sky,
--     resDefs.FontRediculous, true, true, buttonNoFixedWidth, buttonNoFixedHeight, greyAlpha100)

-- return {
--     ButtonTypeWide = buttonTypeWide,
--     ButtonTypeShort = buttonTypeShort,
--     createWideButton
-- }
