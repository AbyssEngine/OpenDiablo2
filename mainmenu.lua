local MainMenu = {}

local resDefs = require("common/resource-defs")

function MainMenu:new(c)
    c = c or {}
    self.__index = self
    return setmetatable(c, self)
end

function MainMenu:start()
    self.rootNode = getRootNode()
    self:initResources()
end

function MainMenu:initResources()
    -- Trademark Screen
    self.trademarkBg = loadSprite(resDefs.TrademarkScreen, resDefs.Palette.Sky)
    self.trademarkBg:cellSize(4, 3)

    self.rootNode:appendChild(self.trademarkBg)
end

return MainMenu
