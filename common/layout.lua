local jsonlib = require('common/json')
local RESOLUTION_X = 800
local RESOLUTION_Y = 600
local LOWEND_HD = true

local LayoutLoader = {
}
LayoutLoader.__index = LayoutLoader

function LayoutLoader:new()
    local this = {}
    setmetatable(this, self)
    self:initialize()
    return this
end

local LAYOUTS_DIR = '/data/global/ui/layouts/'

function imageFilename(image, hd)
    if hd then
        if LOWEND_HD then
            return '/data/hd/global/ui/' .. image .. '.lowend.sprite'
        else
            return '/data/hd/global/ui/' .. image .. '.sprite'
        end
    else
        return '/data/global/ui/' .. image .. '.dc6'
    end
end

-- reads json file as lua table
function readRawJson(path)
    local jsonstr = abyss.loadString(path)
    -- remove comments
    local lines = {}
    for line in jsonstr:gmatch("([^\n]+)") do
        local quotes = false
        local new_line = line
        for i = 1, #line do
            if line:sub(i, i) == '"' then
                quotes = not quotes
            end
            if line:sub(i, i + 1) == '//' and not quotes then
                new_line = line:sub(1, i - 1)
                break
            end
        end
        table.insert(lines, new_line)
    end
    return jsonlib.decode(table.concat(lines, '\n'))
end

-- reads profile file as lua table, following the parents link and merging them
function readProfile(name)
    local start = readRawJson(LAYOUTS_DIR .. '_profile' .. name .. '.json')
    if start.basedOn == nil then
        return start
    end
    local parent = readProfile(start.basedOn)
    for key, value in pairs(start) do
        parent[key] = value
    end
    return parent
end

-- reads profile file as lua table and resolves all the variable names
function readResolvedProfile(name)
    local profile = readProfile(name)
    while resolveDataReferences(profile, profile) do
    end
    return profile
end

-- reads layout file as lua table, following the parents link and merging them
function readLayout(name)
    local data = readRawJson(LAYOUTS_DIR .. name)
    if data.basedOn ~= nil then
        local parent = readLayout(data.basedOn)
        -- TODO merge into data
    end
    return data
end

-- recursively replaces references to $variables in profile with their values
function resolveDataReferences(object, profile)
    local replace = {}
    local again = false
    for key, value in pairs(object) do
        if type(value) == 'table' then
            again = resolveDataReferences(value, profile) or again
        else
            if type(value) == 'string' and value:sub(1, 1) == '$' then
                replace[key] = profile[value:sub(2)]
                again = true
            end
        end
    end
    for key, value in pairs(replace) do
        object[key] = value
    end
    return again
end

function resolveReferences(layout, profile)
    if layout.fields ~= nil then
        resolveDataReferences(layout.fields, profile)
    end
    if layout.children ~= nil then
        for _, child in pairs(layout.children) do
            resolveReferences(child, profile)
        end
    end
end

function or_else(x, y)
    if x == nil then
        return y
    end
    return x
end

function move_by(node, rect)
    if rect == nil then
        return
    end
    local x, y = node:getPosition()
    local dx = or_else(rect.x, 0)
    local dy = or_else(rect.y, 0)
    if hd and LOWEND_HD then
        dx = math.floor(dx / 2)
        dy = math.floor(dy / 2)
    end
    node:setPosition(x + dx, y + dy)
end

local ALIGN_MAPPING = {
    fit = "middle", -- TODO
    center = "middle",
    left = "start",
    right = "end",
    top = "start",
    bottom = "end",
}

local TYPES = {
    SDHeadsUpPanel = function(layout)
        local node = abyss.createNode()
        local bg_image = abyss.loadImage('/data/global/ui/' .. layout.fields.background800 .. '.dc6', ResourceDefs.Palette.Sky)
        local bg_pieces = {}
        for i, off in ipairs(layout.fields.background800Offsets) do
            local piece = abyss.createSprite(bg_image)
            piece.currentFrameIndex = i - 1
            local w, h = bg_image:getFrameSize(i - 1, 1)
            piece:setPosition(off, -h)
            table.insert(bg_pieces, piece)
            node:appendChild(piece)
        end
        node.data = {
            bg_pieces = bg_pieces,
            bg_image = bg_image,
        }
        return node, function()
            for _, child in pairs(node.data.children) do
                move_by(child, layout.fields.rect)
            end
            move_by(node.data.children.QuestAlert, layout.fields.questAlert800Offset)

            local _, y = node.data.children.Right:getPosition()
            node.data.children.Right:setPosition(RESOLUTION_X - node.data.children.Right.data.layout.fields.rect.width, y)

            move_by(node.data.children.Middle, { x = math.floor((RESOLUTION_X - node.data.children.Middle.data.layout.fields.rect.width) / 2) })

            --TODO use anchor
            node:setPosition(0, RESOLUTION_Y + 1)
        end
    end,

    HUDPanelHD = function(layout)
        local node = abyss.createNode()
        return node, function()
            --TODO use anchor
            node:setPosition(math.floor(RESOLUTION_X / 2 - layout.fields.rect.width / 4 + (layout.fields.rect.width + layout.fields.rect.x * 2)/4), RESOLUTION_Y + math.floor(layout.fields.rect.y / 2 ))
        end
    end,

    Widget = function(layout)
        return abyss.createNode()
    end,

    ImageWidget = function(layout, hd)
        return CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), ResourceDefs.Palette.Sky)
    end,

    AnimatedImageWidget = function(layout, hd)
        local sprite = CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), ResourceDefs.Palette.Sky)
        --TODO fps
        sprite.playMode = "forwards"
        return sprite
    end,

    LevelUpButtonWidget = function(layout, hd)
        local image = abyss.loadImage(imageFilename(layout.fields.filename, hd), ResourceDefs.Palette.Sky)
        local node = abyss.createButton(image)
        node.data = {
            image = image,
        }
        node:setSegments(1, 1)
        node:setFrameIndex("pressed", 1)
        node:setFrameIndex("disabled", layout.fields.disabledFrame)
        return node
    end,

    RunButtonWidget = function(layout, hd)
        local image = abyss.loadImage(imageFilename(layout.fields.filename, hd), ResourceDefs.Palette.Sky)
        local node = abyss.createButton(image)
        node.data = {
            image = image,
        }
        node:setSegments(1, 1)
        node:setFrameIndex("pressed", 1)
        return node
    end,

    TextBoxWidget = function(layout)
        local label = abyss.createLabel(SystemFonts.FntFormal12)
        label.caption = 'text'
        label.data = {}
        local align = or_else(layout.fields.style.alignment, {})
        local hAlign = or_else(align.h, "left")
        local vAlign = or_else(align.v, "top")
        label:setAlignment(ALIGN_MAPPING[hAlign], ALIGN_MAPPING[vAlign])
        if layout.fields.style.fontColor ~= nil then
            local color = layout.fields.style.fontColor
            label:setColorMod(color.r, color.g, color.b)
        end
        return label
    end,

    SkillSelectButtonWidget = function(layout, hd)
        local node = abyss.createNode()
        -- TODO which one? maybe create all of them and control the active one via active/visible prop
        local fname = layout.fields.skillIconFilenames[2]
        local image = abyss.loadImage(imageFilename(fname, hd), ResourceDefs.Palette.Sky)
        node.data = {
            image = image
        }
        local button = abyss.createButton(image)
        button:setSegments(1, 1)
        node.data.button = button
        node:appendChild(button)
        return node
    end,

    MiniMenuButtonWidget = function(layout, hd)
        local button = CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), ResourceDefs.Palette.Sky)
        -- TODO hoveredFrame statusUpdateNormalFrame etc
        return button
    end,

    AttributeBallWidget = function(layout, hd)
        if layout.fields.filename == nil then
            return abyss.createNode()
        end
        return CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), ResourceDefs.Palette.Sky)
    end,
}
TYPES.MiniMenuToggleWidget = TYPES.ImageWidget

function translate(layout, hd)
    local type = TYPES[layout.type]
    local node = nil
    local postprocess = nil
    if type ~= nil then
        node, postprocess = type(layout, hd)
    else
        abyss.log("warn", "Layout type not found: " .. layout.type)
        node = abyss.createNode()
    end
    node.data = or_else(node.data, {})
    node.data.layout = layout
    if layout.fields ~= nil and layout.fields.rect ~= nil then
        local rect = layout.fields.rect
        local x = or_else(rect.x, 0)
        local y = or_else(rect.y, 0)
        if hd and LOWEND_HD then
            x = math.floor(x / 2)
            y = math.floor(y / 2)
        end
        node:setPosition(x, y)
    end
    if layout.children ~= nil then
        node.data.children = {}
        node.data.anonymous_children = {}
        for _, child in ipairs(layout.children) do
            local childNode = translate(child, hd)
            if child.name ~= nil then
                node.data.children[child.name] = childNode
            else
                table.insert(node.data.anonymous_children, childNode)
            end
            node:appendChild(childNode)
        end
    end
    if postprocess ~= nil then
        postprocess()
    end
    return node
end

function LayoutLoader:load(name)
    if not self.supported then
        return nil
    end
    local layout = readLayout(name)
    local hd = name:match('hd.json$')
    resolveReferences(layout, cond(hd, self.profileHD, self.profileSD))
    return translate(layout, hd)
end

function LayoutLoader:initialize()
    if not abyss.fileExists('/data/global/ui/layouts/_profilehd.json') then
        self.supported = false
        return
    end
    self.supported = true
    self.profileSD = readResolvedProfile('sd')
    self.profileHD = readResolvedProfile('hd')
    --TODO 'asian', 'lv' profiles
    --TODO read globaldata and globaldatahd
end

return LayoutLoader
