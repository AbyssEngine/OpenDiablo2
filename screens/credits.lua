function stringToArray(arr, creditsString)
    for line in creditsString:gmatch("([^\n]*)\n?") do
        table.insert(arr, line)
    end
end

function setLabelProperties(this, creditsLabel, index)
    creditsLabel:setPosition(400, index * 30)
    creditsLabel:setAlignment("middle", "start")
    creditsLabel:onUpdate(
        function(delta)
            local x, y = creditsLabel:getPosition()
            y = math.round(y - delta * 15)
            creditsLabel:setPosition(x, y)
            if y < -30 then
                creditsLabel:setPosition(400, 600)
                if this.creditLineOffset <= #this.creditsLines then
                    local creditsline = this.creditsLines[this.creditLineOffset]
                    if string.find(creditsline, "*") then
                        -- red text without first * and last \n
                        creditsline = string.sub(creditsline, 2, -2)
                        creditsLabel:setColorMod(0xFF, 0x00, 0x00)
                    else
                        -- white text without first * and last \n
                        creditsline = string.sub(creditsline, 1, -2)
                        creditsLabel:setColorMod(0xFF, 0xFF, 0xFF)
                    end
                    creditsLabel.caption = creditsline
                else
                    -- remove the label since there no more credits lines
                    this.rootNode:removeChild(creditsLabel)
                    creditsLabel = nil
                end
                this.creditLineOffset = this.creditLineOffset + 1
            end
        end
    )
end
local Credits = {}
Credits.__index = Credits

function Credits:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

function Credits:initialize()
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

    -- Credits
    self.creditLineOffset = 1
    self.creditsLines = {}
    stringToArray(self.creditsLines, abyss.utf16To8(abyss.loadString(Language:i18nPath(ResourceDefs.CreditsText))))
    self.labelPool = {}
    local this = self
    -- Populating the pool
    for i = 1, 21 do
        local creditsLabel = abyss.createLabel(SystemFonts.FntFormal12)
        setLabelProperties(this, creditsLabel, i)
        table.insert(self.labelPool, creditsLabel)
        self.rootNode:appendChild(creditsLabel)
    end
end

return Credits
