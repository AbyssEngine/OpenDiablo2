require ('common/util')
require ('common/ui')
require ('screens/screens')

Language = require('common/language'):new()
MusicDefs = require('common/music-defs')
RegionDefs = require('common/region-defs')
ResourceDefs = require("common/resource-defs")
BasePath = abyss.getConfig("#Abyss", "BasePath")
MPQRoot = abyss.getConfig("OpenDiablo2", "MPQRoot")
IsOnButton = false
ShowTrademarkScreen = true

function LoadGlobals()
    -- Load the fonts
    SystemFonts = {
         FntFormal12 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.FontFormal12), ResourceDefs.Palette.Static),
         FntFormal10 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.FontFormal10), ResourceDefs.Palette.Static),
         FntExocet10 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.FontExocet10), ResourceDefs.Palette.Static),
         FntRidiculous = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.FontRidiculous), ResourceDefs.Palette.Static),
         Fnt16 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.Font16), ResourceDefs.Palette.Static),
         Fnt24 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.Font24), ResourceDefs.Palette.Static),
         Fnt30 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.Font30), ResourceDefs.Palette.Static),
         Fnt42 = abyss.createSpriteFont(Language:i18nPath(ResourceDefs.Font42), ResourceDefs.Palette.Static),
    }

    CursorSprite = CreateUniqueSpriteFromFile(ResourceDefs.CursorDefault, ResourceDefs.Palette.Sky)
    CursorSprite.blendMode = "blend"

    LoadDatasets()

    InitUI()
end

function LoadSoundEffect(handle)
    local attempts = {}
    local redirect = SoundEffects[handle].Redirect
    if redirect ~= nil and redirect ~= "" then
        table.insert(attempts, SoundEffects[redirect].FileName)
        -- cursor_button_click redirects to cursor_button_hd_1 but only cursor_button_3_hd.flac actually exists
        local _, _, start, digit = redirect:find("(.*_)(%d)$")
        if digit then
            for _, i in ipairs({1, 2, 3, 4, 5}) do
                table.insert(attempts, SoundEffects[start .. i].FileName)
            end
        end
    end
    table.insert(attempts, SoundEffects[handle].FileName)
    for _, file in ipairs(attempts) do
        if abyss.fileExists("/data/hd/global/sfx/" .. file) then
            return abyss.createSoundEffect("/data/hd/global/sfx/" .. file)
        end
        if abyss.fileExists("/data/global/sfx/" .. file) then
            return abyss.createSoundEffect("/data/global/sfx/" .. file)
        end
    end
end

function LoadDatasets()
    -- ----------------------------------------------------------------------------------------------------------
    abyss.log("info", "Loading Sound Effects")
    -- ----------------------------------------------------------------------------------------------------------
    SoundEffects = LoadTsvAsTable(ResourceDefs.SoundSettings, true)


    -- ----------------------------------------------------------------------------------------------------------
    abyss.log("info", "Loading Level Types")
    -- ----------------------------------------------------------------------------------------------------------
    LevelTypes = {}
    local levelTypeDefs = LoadTsvAsTable(ResourceDefs.LevelType, true)
    for _, levelTypeRecord in pairs(levelTypeDefs) do
        if levelTypeRecord.Id ~= "" then
            local levelType = abyss.LevelType.new()
            levelType.id = tonumber(levelTypeRecord.Id)
            levelType.name = levelTypeRecord.Name
            levelType.act = tonumber(levelTypeRecord.Act)
            levelType.beta = tonumber(levelTypeRecord.Beta) == 0
            levelType.expansion = levelType.act > 4

            for i=1,32 do
                local fileName = levelTypeRecord["File_" .. i]
                levelType.files:add("/data/global/tiles/" .. fileName)
            end

            LevelTypes[levelType.id] = levelType
        end
    end

    -- ----------------------------------------------------------------------------------------------------------
    abyss.log("info", "Loading Level Presets")
    -- ----------------------------------------------------------------------------------------------------------
    LevelPresets = {}
    local levelPresetDefs = LoadTsvAsTable(ResourceDefs.LevelPreset, true)
    for _, levelPresetRecord in pairs(levelPresetDefs) do
        if levelPresetRecord.Def ~= nil and levelPresetRecord.Name ~= '' and levelPresetRecord.Name ~= 'Expansion' then
            local levelPreset = abyss.LevelPreset.new()
            levelPreset.name = levelPresetRecord.Name
            levelPreset.definitionId = tonumber(levelPresetRecord.Def)
            levelPreset.levelId = tonumber(levelPresetRecord.LevelId)
            levelPreset.populate = tonumber(levelPresetRecord.Populate) == 1
            levelPreset.logicals = tonumber(levelPresetRecord.Logicals) == 1
            levelPreset.outdoors = tonumber(levelPresetRecord.Outdoors) == 1
            levelPreset.animate = tonumber(levelPresetRecord.Animate) == 1
            levelPreset.killEdge = tonumber(levelPresetRecord.KillEdge) == 1
            levelPreset.fillBlanks = tonumber(levelPresetRecord.FillBlanks) == 1
            levelPreset.sizeX = tonumber(levelPresetRecord.SizeX)
            levelPreset.sizeY = tonumber(levelPresetRecord.SizeY)
            levelPreset.autoMap = tonumber(levelPresetRecord.AutoMap) == 1
            levelPreset.scan = tonumber(levelPresetRecord.Scan) == 1
            levelPreset.pops = tonumber(levelPresetRecord.Pops)
            levelPreset.popPad = tonumber(levelPresetRecord.PopPad)
            levelPreset.dt1Mask = tonumber(levelPresetRecord.Dt1Mask)
            levelPreset.beta = tonumber(levelPresetRecord.Beta) == 1

            for i=1,6 do
                local fileName = levelPresetRecord["File" .. i]
                if fileName ~= "0" then
                    levelPreset.files:add("/data/global/tiles/" .. fileName)
                end
            end

            table.insert(LevelPresets, levelPreset)
        end
    end


    abyss.log("info", "Finished loading definitions.")
end

function GetLevelPreset(levelId, presetId)
    for _, levelPreset in pairs(LevelPresets) do
        -- Town is special
        if (levelId == 1) and (levelPreset.levelId < 2) and (levelPreset.definitionId == presetId) then
            return levelPreset
        elseif levelPreset.definitionId == presetId then
            return levelPreset
        end
    end

    abyss.log("error", "Level Preset not found for level " .. levelId .. " and preset " .. presetId)
end
