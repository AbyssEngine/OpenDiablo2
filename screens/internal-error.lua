local RESOLUTION_X = 800
local RESOLUTION_Y = 600

local Label = require("common/interface/label")

local ErrorScreen = {
}
ErrorScreen.__index = ErrorScreen
local rootNode, lblError


local function initialize(data)
    rootNode = abyss.getRootNode()
    local header = data.header or "UNSPECIFIED"
    local message = "\n"
    if type(data.message) == "table" then
        message = message .. "\tThe following are missing:\n"
        for _,v in ipairs(data.message.missing) do
            message = message .. "\t\t" .. v .. "\r\n"
        end
        message = message .. "\tThe following have failed to load:\n"
        for _,v in ipairs(data.message.errored) do
            message = message .. "\t\t" .. v .. "\n"
        end
    end
    --/abyss-embedded/Hack-Regular.ttf
    local f30 = abyss.createTtfFont('/abyss-embedded/Hack-Regular.ttf', math.floor(30 * 1.0), 'light')
    local f15 = abyss.createTtfFont('/abyss-embedded/Hack-Regular.ttf', math.floor(15 * 1.0), 'light')

    Label:new{
        parent = rootNode,
        font = f30,
        caption = header,
        alignment = {"middle","start"},
        position = {RESOLUTION_X/2, 15}
    }
    Label:new{
        parent = rootNode,
        font = f15,
        caption = message,
        alignment = {"start","start"},
        position = { 30 , 15 + 30 + 15}
    }
end

function ErrorScreen:new(data)
    local this = {}
    setmetatable(this, self)
    initialize(data)
    table.insert(rootNode.data, this)
    return this
end

return ErrorScreen