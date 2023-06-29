--[[      /$$$$$$                                /$$$$$$$  /$$           /$$       /$$                 /$$$$ /$$$$
         /$$__  $$                              | $$__  $$|__/          | $$      | $$                |_  $$| $$_/
        | $$  \ $$  /$$$$$$   /$$$$$$  /$$$$$$$ | $$  \ $$ /$$  /$$$$$$ | $$$$$$$ | $$  /$$$$$$         | $$| $$
        | $$  | $$ /$$__  $$ /$$__  $$| $$__  $$| $$  | $$| $$ |____  $$| $$__  $$| $$ /$$__  $$        | $$| $$
        | $$  | $$| $$  \ $$| $$$$$$$$| $$  \ $$| $$  | $$| $$  /$$$$$$$| $$  \ $$| $$| $$  \ $$        | $$| $$
        | $$  | $$| $$  | $$| $$_____/| $$  | $$| $$  | $$| $$ /$$__  $$| $$  | $$| $$| $$  | $$        | $$| $$
        |  $$$$$$/| $$$$$$$/|  $$$$$$$| $$  | $$| $$$$$$$/| $$|  $$$$$$$| $$$$$$$/| $$|  $$$$$$/       /$$$$| $$$$
         \______/ | $$____/  \_______/|__/  |__/|_______/ |__/ \_______/|_______/ |__/ \______/       |____/|____/
                  | $$                                                        OpenDiablo II - An Abyss Engine Game
                  | $$                                                  https://github.com/abyssengine/opendiablo2
                  |__/                                                                                                ]]


------------------------------------------------------------------------------------------------------------------------
-- OpenDiablo2 Bootstrap Script
------------------------------------------------------------------------------------------------------------------------

require 'common/globals'

------------------------------------------------------------------------------------------------------------------------
-- Create load providers for all of the available MPQs and CASCs
------------------------------------------------------------------------------------------------------------------------

local function loadGameData()
    local baseDataDir = abyss.getConfig("OpenDiablo2", "BASE_DATA_DIR")

    local casc, mpq

    local function loadBaseCASC()
        local errored = false
        local missingCASCs = {}
        local erroredCASCs = {}

        if abyss.fileExists(".disableCASC") then
            local missingText = "D2R CASC LOADING DISABLED BY FILE: .disableCASC"
            return { loaded = false, data={missing = {missingText}, errored = erroredCASCs} }
        end

        local cascs = Split(abyss.getConfig("OpenDiablo2", "CASCs"), ",")
        for _, _casc in ipairs(cascs) do
            abyss.log("info", string.format("Loading CASC %s...", baseDataDir .. "/"  .. _casc))
            local loaded = pcall(function()
                abyss.addLoaderProvider("casc", baseDataDir .. "/"  .. _casc)
            end)
            if not loaded then
                abyss.log("error", string.format("Possible corrupt or missing CASC: %s", baseDataDir .. "/" .. _casc))
                table.insert(erroredCASCs, baseDataDir .. "/" .. _casc)
                errored = true
            end
        end
        return {loaded = not errored, data={missing = missingCASCs, errored = erroredCASCs}}
    end

    local function loadBaseMPQs()
        local errored = false
        local toLoadMPQs = {}
        local missingMPQs = {}
        local erroredMPQs = {}

        if abyss.fileExists(".disableMPQ") then
            local missingText = "MPQ LOADING DISABLED BY FILE: .disableMPQ"
            return { loaded = false, data={missing = {missingText}, errored = erroredMPQs} }
        end

        local mpqFolderNames = Split(abyss.getConfig("OpenDiablo2", "MPQs"), ",")

        for i in pairs(mpqFolderNames) do
            local mpqPath = baseDataDir .. "/" .. mpqFolderNames[i]
            local mpqLoadOrderFileName = mpqPath .. "/" .. ".loadorder"
            local file = io.open (mpqLoadOrderFileName, "r")
            local fileData = file:read("*a")
            file:close()
            local mpqFiles = Split(fileData, ",")
            for _, mpqFile in ipairs(mpqFiles) do
                if file_exists(mpqPath .. "/" .. mpqFile) then
                    table.insert(toLoadMPQs,mpqPath .. "/" .. mpqFile)
                else
                    table.insert(missingMPQs, mpqPath .. "/" .. mpqFile)
                    errored = true
                end
            end
        end

        -- If no files are missing then really load them
        for _, _mpq in ipairs(toLoadMPQs) do
            local mpqPath = baseDataDir .. "/" .. _mpq
            local loadStr = string.format("Loading MPQ %s...", _mpq)
            abyss.log("info", loadStr)
            local loaded = pcall(function() abyss.addLoaderProvider("mpq", _mpq) end)
            if not loaded then
                table.insert(erroredMPQs, _mpq)
                abyss.log("error", string.format("Possible corrupt MPQ: %s", _mpq))
                errored = true
            end
        end
        local result = {loaded = not errored, data={ missing = missingMPQs, errored = erroredMPQs}}
        return result
    end

    casc = loadBaseCASC()
    mpq = loadBaseMPQs()
    abyss.addLoaderProvider("filesystem", "./DATA/FS-fallback")

    local resultData = { missing = {}, errored = {}}
    for _,obj in ipairs(casc.data.missing) do table.insert(resultData.missing, obj) end
    for _,obj in ipairs(casc.data.errored) do table.insert(resultData.errored, obj) end
    for _,obj in ipairs(mpq.data.missing) do table.insert(resultData.missing, obj) end
    for _,obj in ipairs(mpq.data.errored) do table.insert(resultData.errored, obj) end

    return casc.loaded or mpq.loaded, {message = resultData}
end

------------------------------------------------------------------------------------------------------------------------
-- Load in all of the palettes
------------------------------------------------------------------------------------------------------------------------
local function loadPalettes()
    for _, name in ipairs(ResourceDefs.Palettes) do
        local lineLog = string.format("Loading Palette: %s...", name[1])
        abyss.log("info", lineLog)
        abyss.createPalette(name[1], name[2])
    end
end

------------------------------------------------------------------------------------------------------------------------
-- Detect the language
------------------------------------------------------------------------------------------------------------------------
local function detectLanguage()
    local configLanguageCode = abyss.getConfig("OpenDiablo2", "Language")

    if configLanguageCode ~= "auto" then
        Language:setLanguage(configLanguageCode)
    else
        Language:autoDetect()
    end

    abyss.log("info", "System language has been set to " .. Language:name() or '<invalid>' .. ".")
end

------------------------------------------------------------------------------------------------------------------------
-- Actually load everything
------------------------------------------------------------------------------------------------------------------------

local loaded, data = loadGameData()
if not loaded then
    local ErrorScreen = require("screens/internal-error")
    data.header = "Crash"
    data.errortype = "bootstrap"
    ErrorScreen:new(data)
    return
end
loaded = nil
data = nil

loadPalettes()
detectLanguage()

------------------------------------------------------------------------------------------------------------------------
-- Load the global objects
------------------------------------------------------------------------------------------------------------------------
LoadGlobals()


------------------------------------------------------------------------------------------------------------------------
-- Play Startup Videos
------------------------------------------------------------------------------------------------------------------------
local function StartGame()
    abyss.setCursor(CursorSprite, 1, -24)
    abyss.showSystemCursor(true)
    SetScreen(Screen.MAIN_MENU)
end

if abyss.getConfig("OpenDiablo2", "SkipStartupVideos") ~= "1" then
    if abyss.fileExists("/data/hd/global/video/blizzardlogos.webm") then
        abyss.playVideoAndAudio("/data/hd/global/video/blizzardlogos.webm", "/data/hd/local/video/blizzardlogos.flac", StartGame)
    else
        abyss.playVideo("/data/local/video/New_Bliz640x480.bik", function()
            abyss.playVideo("/data/local/video/BlizNorth640x480.bik", StartGame)
        end)
    end
else
    StartGame()
end


