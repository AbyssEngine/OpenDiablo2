local function setLabelProperties(this, creditsLabel, index)
    creditsLabel:setPosition(400, index * 30)
    creditsLabel:setAlignment("middle", "start")
    creditsLabel:onUpdate(
        function(delta)
            local x, y = creditsLabel:getPosition()
            y = math.floor(y - delta * 15)
            creditsLabel:setPosition(x, y)
            if y < -30 then
                creditsLabel:setPosition(400, 600)
                if this.creditLineOffset <= #this.creditsLines then
                    local creditsline = this.creditsLines[this.creditLineOffset]
                    if string.find(creditsline, "*") then
                        -- red text without first * and last \n
                        creditsline = string.sub(creditsline, 2, -2)
                        setLabelColor(creditsLabel, TextColor.Red)
                    else
                        -- white text without first * and last \n
                        creditsline = string.sub(creditsline, 1, -2)
                        setLabelColor(creditsLabel, TextColor.Gold)
                    end
                    creditsLabel.caption = creditsline
                else
                    -- remove the label since there no more credits lines
                    abyss.getRootNode():removeChild(creditsLabel)
                    creditsLabel = nil
                end
                this.creditLineOffset = this.creditLineOffset + 1
            end
        end
    )
end
local Credits = {}
Credits.__index = Credits

function setLabelColor(label, color)
    return label:setColorMod(color.R, color.G, color.B)
end

function Credits:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

--default to 2 columns when possible otherwise center last name in section.
--header and section text seperated by one empty line

function Credits:initialize()
    local rootNode = abyss.getRootNode()
    rootNode:removeAllChildren()
    abyss.resetMouseState()

    self.btnExit =
        CreateButton(
        ButtonTypes.Medium,
        33,
        543,
        "Exit",
        function()
            SetScreen(Screen.MAIN_MENU)
        end
    )

    -- Main Background
    self.mainBg = CreateUniqueSpriteFromFile(ResourceDefs.CreditsBackground, ResourceDefs.Palette.Sky)
    self.mainBg:setCellSize(4, 3)

    rootNode:appendChild(self.mainBg)
    self.mainBg:appendChild(self.btnExit)

    -- Credits
    self.creditLineOffset = 1
    self.creditsLines = {}
    self.creditsLines = Split(abyss.utf16To8(abyss.loadString(Language:i18nPath(ResourceDefs.CreditsText))), "\n")
    self.labelPool = {}
    local this = self
    -- Populating the pool
    for i = 1, 21 do
        local creditsLabel = abyss.createLabel(SystemFonts.FntFormal10)
        setLabelProperties(this, creditsLabel, i)
        table.insert(self.labelPool, creditsLabel)
        rootNode:appendChild(creditsLabel)
    end
end

return Credits
