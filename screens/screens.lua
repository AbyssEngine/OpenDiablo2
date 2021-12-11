Screen = {
    MAIN_MENU = 1,
    CREDITS = 2,
    MAP_ENGINE_TEST = 3
}

Screens = {
    [Screen.MAIN_MENU] = require("screens/main-menu"),
    [Screen.CREDITS] = require("screens/credits"),
    [Screen.MAP_ENGINE_TEST] = require("screens/map-engine-test"),
}

function SetScreen(screenType)
    abyss.getRootNode():removeAllChildren()
    abyss.resetMouseState()
    CurrentScreen = Screens[screenType]:new()
end
