local language = require("common/language")
local resDefs = require("common/resource-defs")

function globalsInit()
    -- Load the fonts
    systemFonts = {
        fntFormal12   = loadSpriteFont(language.i18nPath(resDefs.FontFormal12  ), resDefs.Palette.Static),
        fntFormal10   = loadSpriteFont(language.i18nPath(resDefs.FontFormal10  ), resDefs.Palette.Static),
        fntExocet10   = loadSpriteFont(language.i18nPath(resDefs.FontExocet10  ), resDefs.Palette.Static),
        fntRediculous = loadSpriteFont(language.i18nPath(resDefs.FontRediculous), resDefs.Palette.Static)
    }

    -- Set the cursor sprite
    cursorSprite = loadSprite(resDefs.CursorDefault, resDefs.Palette.Sky)
end

function globalsDestroy()
    return
    systemFonts.fntFormal12:destroy()
    systemFonts.fntFormal10:destroy()
    systemFonts.fntExocet10:destroy()
    systemFonts.fntRediculous:destroy()
    cursorSprite:destroy()
end