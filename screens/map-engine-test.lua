local MapEngineTest = {
    seed = math.random(1, 9223372036854775807)
}
MapEngineTest.__index = MapEngineTest

function MapEngineTest:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

function MapEngineTest:initialize()
    abyss.playBackgroundMusic("")
    self.rootNode = abyss.getRootNode()
    self.mapRenderer = abyss.createMapRenderer()

    self.btnExit = CreateButton(ButtonTypes.Short, 0, 573, "Exit", function()
        SetScreen(Screen.MAIN_MENU)
    end)

    self.rootNode:appendChild(self.mapRenderer)
    self.rootNode:appendChild(self.btnExit)


    self.zone = abyss.createZone()
    self.zone:resetMap(LevelTypes[1], 500, 500, self.seed)
end


return MapEngineTest
