local Node = {}
Node.__index = Node

function Node:new(data)
    local this = {}
    function Node:setPosition(position)
        position = position or {0, 0}
        this.node:setPosition( math.floor(position[1]), math.floor(position[2]) )
    end
    if data.node ~= nil and type(data.node) == "userdata" then
        this.node = data.node
        return this
    end
    setmetatable(this, self)
    return this
end

return Node