local CharacterCreation = {}

function CharacterCreation:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

function CharacterCreation:initialize()
    self.rootNode = abyss.getRootNode()
    self.layout = LayoutLoader:load('CharacterCreatePanel.json', ResourceDefs.Palette.Fechar)
    self.rootNode:appendChild(self.layout)
end


return CharacterCreation
