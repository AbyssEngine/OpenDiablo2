local Credits = {
}

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

    self.btnExit = CreateButton(ButtonTypes.Medium, 33, 543, "Exit", function()
        SetScreen(Screen.MAIN_MENU)
    end)

    -- Main Background
    self.mainBg = CreateUniqueSpriteFromFile(ResourceDefs.CreditsBackground, ResourceDefs.Palette.Sky)
    self.mainBg:setCellSize(4, 3)

    self.rootNode:appendChild(self.mainBg)
    self.mainBg:appendChild(self.btnExit)

end


return Credits
