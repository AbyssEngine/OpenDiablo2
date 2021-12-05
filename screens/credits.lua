local Credits = {
}
Credits.__index = Credits

function Credits:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

function Credits:initialize()
    self.creditsLines = abyss.loadString(Language:i18nPath(ResourceDefs.CreditsText))

    self.rootNode = abyss.getRootNode()
    self.rootNode:removeAllChildren()
    abyss.resetMouseState()

    self.btnExit = self:createCreditsButton("Exit", 33, 543)
    self.btnExit:onActivate(function() SetScreen(Screen.MAIN_MENU) end)

    -- Main Background
    self.mainBg = abyss.loadSprite(ResourceDefs.CreditsBackground, ResourceDefs.Palette.Sky)
    self.mainBg:setCellSize(4, 3)

    self.rootNode:appendChild(self.mainBg)
    self.mainBg:appendChild(self.btnExit)

end

function Credits:createCreditsButton(text, x, y)
    local result = abyss.createButton(SystemFonts.FntExocet10, ButtonDefs.SprButtonMediumBlank)
    result:setSegments(1, 1)
    result:setFixedSize(128, 35)
    result.caption = text:upper()
    result:setPosition(x, y)
    result:setTextOffset(0, -2)
    result:setFrameIndex("normal", 0)
    result:setFrameIndex("pressed", 1)
    return result
end

return Credits
