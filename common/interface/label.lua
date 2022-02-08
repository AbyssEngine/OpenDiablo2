local Label = {}
local Node = require("common/interface/node")
Label.__index = Label


function Label:new(data)
    local this = Node:new(data)
    function this:setAlignment(alignment)
        alignment = alignment or {"start", "start"}
        self.node:setAlignment(alignment[1],alignment[2])
    end
    local parent = data.parent
    local font = data.font
    local caption = data.caption
    local alignment = data.alignment
    local position = data.position
    this.node = abyss.createLabel(font)
    this:setPosition{position[1], position[2]}
    this.node.caption = caption
    this:setAlignment{alignment[1], alignment[2]}
    table.insert(parent.data, this.node)
    parent:appendChild(this.node)
    setmetatable(Label, Label)
    return this
end

return Label