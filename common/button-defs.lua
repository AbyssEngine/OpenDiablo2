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
local resDefs = require("common/resource-defs")

isButtonDefsLoaded = false

buttonSprites = {}

function loadButtonDefs()
    log("info", "Loading button definitions...")
    buttonSprites.sprButtonWideBlank = loadSprite(resDefs.WideButtonBlank, resDefs.Palette.Sky)
    buttonSprites.sprButtonShortBlank = loadSprite(resDefs.ShortButtonBlank, resDefs.Palette.Sky)
    buttonSprites.sprButtonMediumBlank = loadSprite(resDefs.MediumButtonBlank, resDefs.Palette.Sky)
end

if not isButtonDefsLoaded then
    isButtonDefsLoaded = true
    loadButtonDefs()
end

return {
    sprButtonWideBlank = buttonSprites.sprButtonWideBlank,
    sprButtonShortBlank = buttonSprites.sprButtonShortBlank,
    sprButtonMediumBlank = buttonSprites.sprButtonMediumBlank
}

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
