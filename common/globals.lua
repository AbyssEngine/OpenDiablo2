require ('common/util')
require ('common/ui')
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
         FntFormal12 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.FontFormal12), ResourceDefs.Palette.Static),
         FntFormal10 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.FontFormal10), ResourceDefs.Palette.Static),
         FntExocet10 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.FontExocet10), ResourceDefs.Palette.Static),
         FntRidiculous = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.FontRidiculous), ResourceDefs.Palette.Static)
    }

    CursorSprite = abyss.createSprite(ResourceDefs.CursorDefault, ResourceDefs.Palette.Sky)
    CursorSprite.blendMode = "blend"

    SoundEffects = LoadTsvAsTable(ResourceDefs.SoundSettings, true)

    InitUI()
end

function LoadSoundEffect(handle)
    return abyss.createSoundEffect("/data/global/sfx/" .. SoundEffects[handle].FileName:gsub("\\+", "/"))
end
