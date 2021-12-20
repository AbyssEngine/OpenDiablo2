Screen = {
    MAIN_MENU = 1,
    CREDITS = 2,
    MAP_ENGINE_TEST = 3,
    CHARACTER_SELECTION = 4
}

Screens = {
    [Screen.MAIN_MENU] = require("screens/main-menu"),
    [Screen.CREDITS] = require("screens/credits"),
    [Screen.MAP_ENGINE_TEST] = require("screens/map-engine-test"),
    [Screen.CHARACTER_SELECTION] = require("screens/character-selection"),
}

function SetScreen(screenType)
    abyss.getRootNode():removeAllChildren()
    abyss.resetMouseState()
    IsOnButton=false
    CurrentScreen = Screens[screenType]:new()
end
