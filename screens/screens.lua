Screen = {
    ERROR = -1,
    MAIN_MENU = 1,
    CREDITS = 2,
    MAP_ENGINE_TEST = 3,
    CHARACTER_SELECTION = 4,
    -- screens which exist in D2R should be implemented using common/layout.lua
    CHARACTER_CREATION = 5,
}

Screens = {
    [Screen.ERROR] = require("screens/internal-error"),
    [Screen.MAIN_MENU] = require("screens/main-menu"),
    [Screen.CREDITS] = require("screens/credits"),
    [Screen.MAP_ENGINE_TEST] = require("screens/map-engine-test"),
    [Screen.CHARACTER_SELECTION] = require("screens/character-selection"),
    [Screen.CHARACTER_CREATION] = require("screens/character-creation"),
}

local CurrentScreen

function SetScreen(screenType, arg)
    abyss.getRootNode():removeAllChildren()
    abyss.resetMouseState()
    IsOnButton=false
    if arg ~= nil then 
        CurrentScreen = Screens[screenType]:new(arg)
    else
        CurrentScreen = Screens[screenType]:new()
    end
end
