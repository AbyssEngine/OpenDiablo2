print = function (message) abyss.log("info", message); end;
require ('common/util')
require ('common/ui')
require ('screens/screens')

Language = require('common/language')
MusicDefs = require('common/enum/music')
RegionDefs = require('common/enum/region')
ResourceDefs = require("common/enum/resource")
BasePath = abyss.getConfig("#Abyss", "BasePath")
IsOnButton = false
ShowTrademarkScreen = true

function LoadGlobals()
    ResurrectedMode = abyss.fileExists('/data/local/lng/strings/ui.json')

    -- Load the fonts
    SystemFonts = {}
    SpriteFontIsActuallyTTF = false
    -- D2R doesn't have Cyrillic sprite font, so if Russian is selected, try sprite font, and fallback to TTF font (which looks more ugly on the old-style buttons).
    -- TODO use LanguageFontRemapper from GlobalData
    local function loadFormal(size)
        local filename = Language:i18nPath(ResourceDefs['FontFormal' .. tostring(size)])
        if abyss.fileExists(filename .. '.dc6') then
            return abyss.createSpriteFont(filename, ResourceDefs.Palette.Static, true, 'blend')
        end
        SpriteFontIsActuallyTTF = true
        return abyss.createTtfFont('/data/hd/ui/fonts/philosopher-bolditalic.ttf', math.floor(size * 1.2), 'slight')
    end
    local function loadFnt(size)
        local filename = Language:i18nPath(ResourceDefs['Font' .. tostring(size)])
        if abyss.fileExists(filename .. '.dc6') then
            return abyss.createSpriteFont(filename, ResourceDefs.Palette.Static, false, 'blend')
        end
        SpriteFontIsActuallyTTF = true
        return abyss.createTtfFont('/data/hd/ui/fonts/ExocetBlizzardOT-Medium.otf', math.floor(size * 0.8), 'none')
    end
    local function loadExocet(size)
        local filename = Language:i18nPath(ResourceDefs['FontExocet' .. tostring(size)])
        if abyss.fileExists(filename .. '.dc6') then
            return abyss.createSpriteFont(filename, ResourceDefs.Palette.Static, false, 'multiply')
        end
        SpriteFontIsActuallyTTF = true
        return abyss.createTtfFont('/data/hd/ui/fonts/ExocetBlizzardOT-Medium.otf', math.floor(size * 1.4), 'none')
    end
    local function loadSucker()
        local filename = Language:i18nPath(ResourceDefs.FontSucker)
        if abyss.fileExists(filename .. '.dc6') then
            return abyss.createSpriteFont(filename, ResourceDefs.Palette.Static, true, 'blend')
        end
        SpriteFontIsActuallyTTF = true
        return abyss.createTtfFont('/data/hd/ui/fonts/BlizzardGlobal-v5_81.ttf', 10, 'none')
        --return abyss.createTtfFont('/data/hd/ui/fonts/BlizzardGlobalTCUnicode.ttf', 8, 'none')
    end
    local function loadRidiculous()
        local filename = Language:i18nPath(ResourceDefs.FontRidiculous)
        if abyss.fileExists(filename .. '.dc6') then
            return abyss.createSpriteFont(filename, ResourceDefs.Palette.Static, false, 'multiply')
        end
        SpriteFontIsActuallyTTF = true
        return abyss.createTtfFont('/data/hd/ui/fonts/ExocetBlizzardOT-Medium.otf', 10, 'none')
    end
    SystemFonts.FntFormal10 = loadFormal(10)
    SystemFonts.FntFormal11 = loadFormal(11)
    SystemFonts.FntFormal12 = loadFormal(12)
    SystemFonts.FntSucker = loadSucker()
    SystemFonts.FntRidiculous = loadRidiculous()
    SystemFonts.FntExocet8 = loadExocet(8)
    SystemFonts.FntExocet10 = loadExocet(10)
    SystemFonts.Fnt16 = loadFnt(16)
    SystemFonts.Fnt24 = loadFnt(24)
    SystemFonts.Fnt30 = loadFnt(30)
    SystemFonts.Fnt42 = loadFnt(42)

    CursorSprite = CreateUniqueSpriteFromFile(ResourceDefs.CursorDefault, ResourceDefs.Palette.Sky)
    CursorSprite.blendMode = "blend"

    LayoutLoader = require('common/layout'):new()
    LoadDatasets()

    InitUI()
end

function LoadSoundEffect(handle)
    if SoundEffects[handle] == nil then
        return nil
    end
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
