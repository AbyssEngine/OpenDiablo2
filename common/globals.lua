require ('common/util')
require ('screens/screens')

Language = require('common/language'):new()
MusicDefs = require('common/music-defs')
ResourceDefs = require("common/resource-defs")
BasePath = abyss.getConfig("#Abyss", "BasePath")
MPQRoot = abyss.getConfig("System", "MPQRoot")
ShowTrademarkScreen = true

function LoadGlobals()
    -- Load the fonts
    SystemFonts = {
         FntFormal12 = abyss.loadSpriteFont(Language:i18nPath(ResourceDefs.FontFormal12), ResourceDefs.Palette.Static),
         FntFormal10 = abyss.loadSpriteFont(Language:i18nPath(ResourceDefs.FontFormal10), ResourceDefs.Palette.Static),
         FntExocet10 = abyss.loadSpriteFont(Language:i18nPath(ResourceDefs.FontExocet10), ResourceDefs.Palette.Static),
         FntRidiculous = abyss.loadSpriteFont(Language:i18nPath(ResourceDefs.FontRidiculous), ResourceDefs.Palette.Static)
    }

    CursorSprite = abyss.loadSprite(ResourceDefs.CursorDefault, ResourceDefs.Palette.Sky)
    CursorSprite.blendMode = "blend"

    ButtonDefs = require("common/button-defs"):new()
end
