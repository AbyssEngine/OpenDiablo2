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

ResurrectedMode = abyss.getConfig("OpenDiablo2", "Resurrected") == "1"

require 'common/globals'

------------------------------------------------------------------------------------------------------------------------
-- Create load providers for all of the available MPQs and CASCs
------------------------------------------------------------------------------------------------------------------------

local cascs = Split(abyss.getConfig("OpenDiablo2", "CASCs"), ",")
for i in pairs(cascs) do
    abyss.log("info", string.format("Loading CASC %s...", cascs[i]))
    pcall(function()
        abyss.addLoaderProvider("casc", cascs[i])
    end)
end

local mpqs = Split(abyss.getConfig("OpenDiablo2", "MPQs"), ",")
for i in pairs(mpqs) do
    local mpqPath = MPQRoot .. "/" .. mpqs[i]
    local loadStr = string.format("Loading MPQ %s...", mpqPath)
    abyss.log("info", loadStr)
    pcall(function()
        abyss.addLoaderProvider("mpq", mpqPath)
    end)
end

------------------------------------------------------------------------------------------------------------------------
-- Load in all of the palettes
------------------------------------------------------------------------------------------------------------------------
for _, name in ipairs(ResourceDefs.Palettes) do
    local lineLog = string.format("Loading Palette: %s...", name[1])
    abyss.log("info", lineLog)
    abyss.createPalette(name[1], name[2]) end

------------------------------------------------------------------------------------------------------------------------
-- Detect the language
------------------------------------------------------------------------------------------------------------------------
local configLanguageName = abyss.getConfig("OpenDiablo2", "Language")

if configLanguageName ~= "auto" then
    Language:setLanguage(configLanguageName)
else
    Language:autoDetect()
end

local languageName = Language:name()
abyss.log("info", "System language has been set to " .. languageName .. ".")


------------------------------------------------------------------------------------------------------------------------
-- Load the global objects
------------------------------------------------------------------------------------------------------------------------
LoadGlobals()


------------------------------------------------------------------------------------------------------------------------
-- Play Startup Videos
------------------------------------------------------------------------------------------------------------------------

function StartGame()
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


