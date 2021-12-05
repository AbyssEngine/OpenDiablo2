Screen = {
    MAIN_MENU = 1,
    CREDITS = 2,
}

Screens = {
    [Screen.MAIN_MENU] = require("screens/main-menu"),
    [Screen.CREDITS] = require("screens/credits"),
}

function SetScreen(screenType)
    CurrentScreen = Screens[screenType]:new()
end
