local RESOLUTION_X = 800
local RESOLUTION_Y = 600
local LOWEND_HD = true

local _profileSD
local _profileHD
local _globalDataSD
local _globalDataHD

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

local SD_FONTS = {
    ["10ptE"] = SystemFonts.FntExocet10,
    ["8ptE"]  = SystemFonts.FntExocet8,
    ["30pt"]  = SystemFonts.Fnt30,
    ["16pt"]  = SystemFonts.Fnt16,
    ["6pt"]  = SystemFonts.FntSucker,
    ["12ptF"] = SystemFonts.FntFormal12,
    ["11ptF"] = SystemFonts.FntFormal11,
}

local HD_FONT

local function loadFont(fontType, hd)
    if hd then
        if HD_FONT == nil then
            HD_FONT = abyss.createTtfFont('/data/hd/ui/fonts/Formal436bt.ttf', 16, 'none')
        end
        return HD_FONT
        -- TODO use LanguageFontRemapper from GlobalData
        -- /data/hd/ui/fonts/Formal436bt.ttf
        -- /data/hd/ui/fonts/ExocetBlizzardOT-Medium.otf
        -- /data/hd/ui/fonts/BlizzardGlobal-v5_81.ttf
        -- etc
    end
    return SD_FONTS[fontType]
end

local function defaultFontColor(fontType)
    if fontType == "30pt" then
        return { r = 199, g = 179, b = 119 }
    end
    return { r = 0xFF, g = 0xFF, b = 0xFF }
end

local function imageFilename(image, hd)
    if image:sub(1, 1) == '\\' then
        image = image:sub(2)
    end
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

-- http://lua-users.org/wiki/CopyTable
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- recursively replaces references to $variables in profile with their values
local function resolveDataReferences(object, profile)
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

-- reads profile file as lua table, following the parents link and merging them
local function readProfile(name)
    local start = ReadJsonAsTable(LAYOUTS_DIR .. '_profile' .. name .. '.json')
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
local function readResolvedProfile(name)
    local profile = readProfile(name)
    while resolveDataReferences(profile, profile) do
    end
    return profile
end

local function shallowMergeTables(overrides, parent)
    local merged = or_else(parent, {})
    for key, value in pairs(or_else(overrides, {})) do
        merged[key] = value
    end
    return merged
end

local function mergeFromParent(layout, parent)
    layout.fields = shallowMergeTables(layout.fields, parent.fields)
    if layout.children ~= nil and parent.children ~= nil then
        local otherChildren = {}
        for _, child in ipairs(parent.children) do
            if child.name ~= nil then
                otherChildren[child.name] = child
            end
        end
        for _, child in ipairs(layout.children) do
            if child.name ~= nil then
                local brother = otherChildren[child.name]
                if brother ~= nil then
                    mergeFromParent(child, brother)
                end
            end
        end
    end
end

-- reads layout file as lua table, following the parents link and merging them
local function readLayout(name)
    local data = ReadJsonAsTable(LAYOUTS_DIR .. name)
    if data.basedOn ~= nil then
        local parent = readLayout(data.basedOn)
        mergeFromParent(data, parent)
    end
    return data
end

local function resolveReferences(layout, profile)
    if layout.fields ~= nil then
        resolveDataReferences(layout.fields, profile)
    end
    if layout.children ~= nil then
        for _, child in pairs(layout.children) do
            resolveReferences(child, profile)
        end
    end
end

local function move_by(node, rect)
    if rect == nil then
        return
    end
    local x, y = node:getPosition()
    local dx = or_else(rect.x, 0)
    local dy = or_else(rect.y, 0)
    if hd and LOWEND_HD then
        -- TODO debug this
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
    SDHeadsUpPanel = function(layout, hd, palette)
        local node = abyss.createNode()
        local bg_image = abyss.loadImage(imageFilename(layout.fields.background800, hd), palette)
        local bg_pieces = {}
        for i, off in ipairs(layout.fields.background800Offsets) do
            local piece = abyss.createSprite(bg_image)
            piece.bottomOrigin = true
            piece.currentFrameIndex = i - 1
            piece:setPosition(off, layout.fields.rect.height)
            table.insert(bg_pieces, piece)
            node:appendChild(piece)
        end
        node.data.bg_pieces = bg_pieces
        node.data.bg_image = bg_image
        if layout.fields.rect.x == nil then
            layout.fields.rect.x = math.floor(-RESOLUTION_X / 2)
        end
        return node, function()
            move_by(node.data.children.QuestAlert, layout.fields.questAlert800Offset)

            --TODO use anchor
            local _, y = node.data.children.Right:getPosition()
            node.data.children.Right:setPosition(RESOLUTION_X - node.data.children.Right.data.layout.fields.rect.width, y)

            move_by(node.data.children.Middle, { x = math.floor((RESOLUTION_X - node.data.children.Middle.data.layout.fields.rect.width) / 2) })
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

    ImageWidget = function(layout, hd, palette)
        return CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), palette)
    end,

    AnimatedImageWidget = function(layout, hd, palette)
        local sprite = CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), palette)
        --TODO fps
        sprite.playMode = "forwards"
        sprite.bottomOrigin = true
        local num = sprite.data.img:getNumberOfFrames()
        local maxh = 0
        for i = 0, num-1 do
            local w, h = sprite.data.img:getFrameSize(0, 1)
            maxh = math.max(maxh, h)
        end
        if layout.fields.blendMode == "black" then
            sprite.blendMode = "additive"
        end
        return sprite, function()
            move_by(sprite, {y=maxh})
        end
    end,

    LevelUpButtonWidget = function(layout, hd, palette)
        local image = abyss.loadImage(imageFilename(layout.fields.filename, hd), palette)
        local node = abyss.createButton(image)
        node.data.image = image
        node:setSegments(1, 1)
        node:setFrameIndex("pressed", 1)
        node:setFrameIndex("disabled", layout.fields.disabledFrame)
        local w, h = image:getFrameSize(0, 1)
        node:setFixedSize(w, h)
        return node
    end,

    RunButtonWidget = function(layout, hd, palette)
        local image = abyss.loadImage(imageFilename(layout.fields.filename, hd), palette)
        local node = abyss.createButton(image)
        node.data.image = image
        node:setSegments(1, 1)
        node:setFrameIndex("pressed", 1)
        local w, h = image:getFrameSize(0, 1)
        node:setFixedSize(w, h)
        return node
    end,

    TextBoxWidget = function(layout)
        local fontType = or_else(layout.fields.fontType, "16pt")
        local label = abyss.createLabel(loadFont(fontType))
        label.caption = Language:translate(or_else(layout.fields.text, 'text'))
        if or_else(layout.fields.style.options, {}).lineWrap then
            label.maxWidth = layout.fields.rect.width
        end
        local align = or_else(layout.fields.style.alignment, {})
        local hAlign = or_else(align.h, "left")
        local vAlign = or_else(align.v, "top")
        label:setAlignment(ALIGN_MAPPING[hAlign], ALIGN_MAPPING[vAlign])
        local color = layout.fields.style.fontColor
        if color == nil then
            color = defaultFontColor(fontType)
        end
        label:setColorMod(color.r, color.g, color.b)
        return label, function()
            if align.h == "center" then
                move_by(label, {x=math.floor(layout.fields.rect.width/2)})
            end
            if align.v == "center" then
                move_by(label, {y=math.floor(layout.fields.rect.height/2)})
            end
        end
    end,

    SkillSelectButtonWidget = function(layout, hd, palette)
        local node = abyss.createNode()
        -- TODO which one? maybe create all of them and control the active one via active/visible prop
        local fname = layout.fields.skillIconFilenames[2]
        local image = abyss.loadImage(imageFilename(fname, hd), palette)
        node.data.image = image
        local button = abyss.createButton(image)
        button:setSegments(1, 1)
        local w, h = image:getFrameSize(0, 1)
        button:setFixedSize(w, h)
        node.data.button = button
        node:appendChild(button)
        return node
    end,

    ButtonWidget = function(layout, hd, palette)
        if layout.fields.filename == 'PANEL\\buysellbtn' or layout.fields.filename == 'FrontEnd\\XLMediumButtonBlank' then
            -- TODO this file throws an exception in dc6 parsing now
            return abyss.createNode()
        end
        local image = abyss.loadImage(imageFilename(layout.fields.filename, hd), palette)
        local button = abyss.createButton(image)
        button.data.image = image
        local normalFrame = or_else(layout.fields.normalFrame, 0)
        button:setFrameIndex("normal", normalFrame)
        button:setFrameIndex("pressed", or_else(layout.fields.pressedFrame, 1))
        button:setSegments(1, 1)
        local w, h = image:getFrameSize(normalFrame, 1)
        button:setFixedSize(w, h)
        if layout.fields.textString ~= nil then
            local w, h = image:getFrameSize(normalFrame, 1)
            local label = abyss.createLabel(loadFont(layout.fields.fontType, hd))
            label:setPosition(math.floor(w/2), math.floor(h/2))
            if SpriteFontIsActuallyTTF then
                label.caption = '<b>' .. Language:translate(layout.fields.textString) .. '</b>'
            else
                label.caption = Language:translate(layout.fields.textString)
            end
            label:setAlignment("middle", "middle")
            button:appendChild(label)
            local color = layout.fields.textColor
            if color ~= nil then
                if SpriteFontIsActuallyTTF then
                    -- TODO figure something out
                    label:setColorMod(0, 0, 0)
                else
                    label:setColorMod(color.r, color.g, color.b)
                end
            end
            button.data.label = label
            button:setPressedOffset(-2, 2)
        end
        return button
    end,

    MiniMenuButtonWidget = function(layout, hd, palette)
        local button = CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), palette)
        -- TODO hoveredFrame statusUpdateNormalFrame etc
        return button
    end,

    AttributeBallWidget = function(layout, hd, palette)
        if layout.fields.filename == nil then
            return abyss.createNode()
        end
        return CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), palette)
    end,

    GridImageWidget = function(layout, hd, palette)
        local sprite = CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), palette)
        sprite.currentFrameIndex = or_else(layout.fields.frame, 0)
        sprite:setCellSize(math.floor(layout.fields.frames / layout.fields.rows), layout.fields.rows)
        return sprite
    end,

    InventorySlotWidget = function(layout, hd, palette)
        local sprite = CreateUniqueSpriteFromFile(imageFilename(layout.fields.backgroundFilename, hd), palette)
        sprite.currentFrameIndex = or_else(layout.fields.backgroundFrame, 0)
        return sprite, function()
            move_by(sprite, layout.fields.backgroundOffset)
            --TODO skip this if the first set is selected
            move_by(sprite, layout.fields.swappedOffset)
        end
    end,

    CharacterCreateWidget = function(layout, hd, palette)
        local character = abyss.createNode()
        local states = {'base', 'onHover', 'onSelect', 'onUnselect', 'selected'}
        for _, name in ipairs(states) do
            local animDesc = layout.fields.stateAnimations[name]
            local fullImage = abyss.createNode()
            local base = CreateUniqueSpriteFromFile(imageFilename(animDesc.basePath, hd), palette)
            fullImage:appendChild(base)
            fullImage.data.base = base
            base.playMode = "forwards"
            base.bottomOrigin = true
            if name == 'onSelect' or name == 'onUnselect' then
                base.loopAnimation = false
            end
            if animDesc.overlayPath ~= nil then
                local overlay = CreateUniqueSpriteFromFile(imageFilename(animDesc.overlayPath, hd), palette)
                fullImage:appendChild(overlay)
                fullImage.data.overlay = overlay
                overlay.playMode = "forwards"
                overlay.bottomOrigin = true
                if animDesc.overlayBlendMode == "black" then
                    overlay.blendMode = "additive"
                end
                if name == 'onSelect' or name == 'onUnselect' then
                    overlay.loopAnimation = false
                end
            end
            -- TODO: use speedMultiplier field
            character.data[name] = fullImage
            character:appendChild(fullImage)
            fullImage.active = false
            character.data.state = 'base'
        end
        local function setState(state)
            character.data.state = state
            for _, name in ipairs(states) do
                if name == state then
                    character.data[name].active = true
                    character.data[name].data.base.currentFrameIndex = 0
                    if character.data[name].data.overlay ~= nil then
                        character.data[name].data.overlay.currentFrameIndex = 0
                    end
                else
                    character.data[name].active = false
                end
            end
        end
        local sfxSelect = LoadSoundEffect('cursor_' .. layout.name:lower() .. '_select')
        local sfxUnselect = LoadSoundEffect('cursor_' .. layout.name:lower() .. '_deselect')
        -- druid and assassin didn't have the sounds.txt records before d2r
        if sfxSelect == nil then
            sfxSelect = abyss.createSoundEffect("/data/global/sfx/Cursor/intro/" .. layout.name:lower() .. " select.wav")
        end
        if sfxUnselect == nil then
            sfxUnselect = abyss.createSoundEffect("/data/global/sfx/Cursor/intro/" .. layout.name:lower() .. " deselect.wav")
        end
        local finishAnimationCb = function() end
        character.data.onSelect.data.base:onAnimationFinished(function()
            setState('selected')
            finishAnimationCb()
            finishAnimationCb = function() end
        end)
        character.data.onUnselect.data.base:onAnimationFinished(function()
            setState('base')
            finishAnimationCb()
            finishAnimationCb = function() end
        end)
        character.data.base.active = true
        character.data.gotoSelect = function(cb)
            if character.data.state == 'base' then
                finishAnimationCb = cb
                sfxSelect:play()
                setState('onSelect')
            else
                cb()
            end
        end
        character.data.gotoUnselect = function(cb)
            if character.data.state == 'base' then
                cb()
            else
                finishAnimationCb = cb
                sfxUnselect:play()
                setState('onUnselect')
            end
        end
        return character
    end,

    CharacterCreateContainerWidget = function(layout, hd, palette)
        local input = abyss.createInputListener()
        input.data.onUpdateSelected = function() end
        input.data.onUpdateHover = function() end
        return input, function()
            local classes = {}
            for name, child in pairs(input.data.children) do
                table.insert(classes, name)
            end
            table.sort(classes, function(a, b)
                local ax = input.data.children[a].data.layout.fields.rect.x
                local bx = input.data.children[b].data.layout.fields.rect.x
                return ax < bx
            end)
            local selectedClass
            local overClass
            input:onMouseMove(function(x, y)
                -- FIXME inputlistener should do the X Y offset
                x = x - RESOLUTION_X / 2
                -- every stated number is somewhere in middle of character
                x = x + RESOLUTION_X / #classes / 2
                overClass = nil
                if y > RESOLUTION_Y / 3 and y < RESOLUTION_Y * 2 / 3 then
                    for i = #classes, 1, -1 do
                        -- TODO this logic makes all the right of the druid to be druid
                        if x > input.data.children[classes[i]].data.layout.fields.rect.x then
                            overClass = classes[i]
                            break
                        end
                    end
                end
                for i = 1, #classes do
                    local overThis = overClass == classes[i]
                    if input.data.children[classes[i]].data.state == 'base' then
                        input.data.children[classes[i]].data.base.active = not overThis
                        input.data.children[classes[i]].data.onHover.active = overThis
                    end
                end
                input.data.onUpdateHover(overClass)
            end)
            local inputBlocked = 0
            input:onMouseButton(function(button, isPressed)
                if not isPressed then return end
                -- only left button
                if button ~= 1 then return end
                if overClass == nil then return end
                if inputBlocked > 0 then return end
                for i = 1, #classes do
                    if overClass == classes[i] then
                        if selectedClass == overClass then
                            selectedClass = nil
                            input.data.onUpdateSelected(selectedClass)
                            inputBlocked = inputBlocked + 1
                            input.data.children[classes[i]].data.gotoUnselect(function()
                                inputBlocked = inputBlocked - 1
                            end)
                        else
                            selectedClass = overClass
                            input.data.onUpdateSelected(selectedClass)
                            inputBlocked = inputBlocked + 1
                            input.data.children[classes[i]].data.gotoSelect(function()
                                inputBlocked = inputBlocked - 1
                            end)
                        end
                    else
                        inputBlocked = inputBlocked + 1
                        input.data.children[classes[i]].data.gotoUnselect(function()
                            inputBlocked = inputBlocked - 1
                        end)
                    end
                end
            end)
        end
    end,

    CharacterCreatePanel = function(layout, hd, palette)
        local node = abyss.createNode()
        return node, function()
            local descriptions = {
                Amazon = '@strAmazonDesc#5128',
                Necromancer = '@strNecroDesc#5129',
                Barbarian = '@strBarbDesc#5130',
                Sorceress = '@strSorcDesc#5131',
                Paladin = '@strPalDesc#5132',
                Druid = '@strDruDesc#2518',
                Assassin = '@strAssDesc#2519',
            }
            local selectedClass
            local function onHover(class)
                local detailsClass = or_else(selectedClass, class)
                if detailsClass == nil then
                    node.data.children.ClassTitle.caption = ''
                    node.data.children.ClassDescription.caption = ''
                else
                    node.data.children.ClassTitle.caption = Language:translate('@' .. detailsClass)
                    node.data.children.ClassDescription.caption = Language:translate(descriptions[detailsClass])
                end
            end
            local function onUpdate(class)
                selectedClass = class
                onHover(class)
                if class ~= nil then
                    local names = layout.fields[class:lower() .. 'Names']
                    node.data.children.InputText.caption = names[math.random(#names)]
                end
                local showOk = selectedClass ~= nil
                for _, name in ipairs({'ToGame', 'HardcoreLabel', 'HardcoreCheckbox', 'ExpansionLabel', 'ExpansionCheckbox', 'LadderLabel', 'LadderToggle', 'NameLabel', 'InputBackground', 'InputText'}) do
                    if node.data.children[name] ~= nil then
                        node.data.children[name].active = showOk
                    end
                end
            end
            onUpdate(nil)
            -- TODO send message the other way around, without the panel reaching into the child
            node.data.children.CharacterContainer.data.onUpdateSelected = onUpdate
            node.data.children.CharacterContainer.data.onUpdateHover = onHover
            node.data.children.ToMainMenu:onActivate(function()
                SetScreen(Screen.CHARACTER_SELECTION)
            end)
        end
    end,

    InputTextBoxWidget = function(layout, hd, palette)
        -- TODO make it editable, use various fields from layout
        local label = abyss.createLabel(loadFont(layout.fields.fontType, hd))
        local align = or_else(layout.fields.fontStyle.alignment, {})
        local hAlign = or_else(align.h, "left")
        local vAlign = or_else(align.v, "top")
        label:setAlignment(ALIGN_MAPPING[hAlign], ALIGN_MAPPING[vAlign])
        return label
    end,

    ToggleButtonWidget = function(layout, hd, palette)
        local image = abyss.loadImage(imageFilename(layout.fields.filename, hd), palette)
        local button = abyss.createButton(image)
        button.data.image = image
        local toggledFrame = layout.fields.toggledFrame
        button:setFrameIndex("checkednormal", toggledFrame)
        button:setFrameIndex("checkedhover", toggledFrame)
        button:setFrameIndex("checkedpressed", toggledFrame)
        button.checked = or_else(layout.fields.isToggled, false)
        button:onActivate(function()
            button.checked = not button.checked
        end)
        button:setSegments(1, 1)
        local w, h = image:getFrameSize(0, 1)
        button:setFixedSize(w, h)
        return button
    end,

    QuestLogButtonWidget = function(layout, hd, palette)
        local sprite = CreateUniqueSpriteFromFile(imageFilename(layout.fields.filename, hd), palette)
        return sprite, function()
            move_by(sprite, {
                -- +1 because lua arrays index from 1
                x = layout.gridColumnPositions[layout.fields.gridPosition.x + 1],
                y = layout.gridRowPositions[layout.fields.gridPosition.y + 1],
            })
        end
    end,

    QuestLogPanel = function(layout, hd, palette)
        local function recurse(spec)
            if spec.type == 'QuestLogButtonWidget' then
                spec.gridColumnPositions = layout.fields.gridColumnPositions
                spec.gridRowPositions = layout.fields.gridRowPositions
            end
            if spec.children ~= nil then
                for _, child in ipairs(spec.children) do
                    recurse(child)
                end
            end
        end
        recurse(layout)
        panel = abyss.createNode()
        return panel, function()
            -- Let's have Quest15 be selected for now
            local x, y = panel.data.children.Tab2.data.children.Quest15:getPosition()
            move_by(panel.data.children.TemplateSocket, {x = x, y = y})
        end
    end,

    TabBarWidget = function(layout, hd, palette)
        -- TODO make only the selected tab active
        local image = abyss.loadImage(imageFilename(layout.fields.filename, hd), palette)
        local bar = abyss.createNode()
        local x = 0
        bar.data.image = image
        bar.data.tabs = {}
        local activeTab = 3 -- why not; TODO
        for i = 1, layout.fields.tabCount do
            -- TODO some of these aren't active yet
            local tab = abyss.createSprite(image)
            table.insert(bar.data.tabs, tab)
            bar:appendChild(tab)
            if i == activeTab then
                tab.currentFrameIndex = layout.fields.activeFrames[i]
            else
                tab.currentFrameIndex = layout.fields.inactiveFrames[i]
            end
            if layout.fields.textStrings ~= nil then
                -- TODO verify font
                local label = abyss.createLabel(SystemFonts.FntFormal12)
                label.caption = layout.fields.textStrings[i]
                label:setAlignment('middle', 'end')
                label:setPosition(math.floor(layout.fields.tabSize.x/2), math.floor(layout.fields.tabSize.y/2))
                tab.data.label = label
                tab:appendChild(label)
            end
            tab:setPosition(x, 0)
            x = x + layout.fields.tabSize.x + layout.fields.tabPadding.x
        end
        return bar
    end,

    -- Not real widgets
    GlobalData = function() return abyss.createNode() end,
    LanguageFontRemapper = function() return abyss.createNode() end,
    SpriteColoringHelper = function() return abyss.createNode() end,
    ShowItemsParameters = function() return abyss.createNode() end,
}
TYPES.MiniMenuToggleWidget = TYPES.ImageWidget

local function translate(layout, hd, palette, parent)
    local outer = abyss.createNode()
    local type = TYPES[layout.type]
    local node = nil
    local postprocess = nil
    if type ~= nil then
        node, postprocess = type(layout, hd, palette)
    else
        abyss.log("warn", "Layout type not found: " .. layout.type)
        node = abyss.createNode()
    end
    outer.data.node = node
    outer:appendChild(node)
    node.data.layout = layout
    outer.data.layout = layout
    if layout.fields ~= nil then
        if layout.fields.anchor ~= nil then
            local anchor = layout.fields.anchor
            --TODO anchors for non-root
            if parent == nil then
                outer:setPosition(
                    math.floor(or_else(anchor.x, 0) * RESOLUTION_X),
                    math.floor(or_else(anchor.y, 0) * RESOLUTION_Y))
            else
                abyss.log("warn", "TODO anchor on non-root layout")
            end
        end
        if layout.fields.rect ~= nil then
            local rect = layout.fields.rect
            local x = or_else(rect.x, 0)
            local y = or_else(rect.y, 0)
            if hd and LOWEND_HD then
                x = math.floor(x / 2)
                y = math.floor(y / 2)
            end
            node:setPosition(x, y)
        end
    end
    if layout.children ~= nil then
        node.data.children = {}
        node.data.anonymous_children = {}
        local children = {}
        for _, child in ipairs(layout.children) do
            local childNode = translate(child, hd, palette, node)
            if child.name ~= nil then
                node.data.children[child.name] = childNode
            else
                table.insert(node.data.anonymous_children, childNode)
            end
            table.insert(children, childNode)
            node:appendChild(childNode)
        end
        -- add references to grandchildren
        -- Conflicts are resolved in this way:
        -- 1. name of direct child overrides everything
        -- 2. name of first grandchild found with this name (perhaps it should be last instead?)
        -- Grandgrandchild of first child overrides grandchild of second child
        -- I don't know whether this is the right order
        for _, child in ipairs(children) do
            if child.data.children ~= nil then
                for name, grandchild in pairs(child.data.children) do
                    if node.data.children[name] == nil then
                        node.data.children[name] = grandchild
                    end
                end
            end
        end
    end
    if postprocess ~= nil then
        postprocess()
    end
    outer.data.children = node.data.children
    if layout.fields ~= nil and layout.fields.anchor ~= nil then
        return outer
    end
    -- TODO: don't create outer node in the first place if not necessary
    return node
end

function TYPES.WaypointsPanel(layout, hd, palette)
    local node = abyss.createNode()
    local function find_child(layout, name)
        for i, child in ipairs(layout.children) do
            if child.name == name then
                table.remove(layout.children, i)
                return child
            end
        end
        error('child ' .. name .. ' not found')
    end
    local templates = find_child(layout, 'Templates')
    local Unselectable = find_child(templates, 'UnselectableButtonTemplate')
    local SelectableButton = find_child(templates, 'SelectableButton')
    local CurrentButton = find_child(templates, 'CurrentButton')
    SelectableButton.fields = shallowMergeTables(SelectableButton.fields, deepcopy(Unselectable.fields))
    CurrentButton.fields = shallowMergeTables(CurrentButton.fields, deepcopy(Unselectable.fields))
    Unselectable.fields = shallowMergeTables(Unselectable.fields, deepcopy(SelectableButton.fields))
    return node, function()
        local current_button = math.random(5)
        local buttons_enabled = 7 -- TODO
        local y = 0
        node.data.buttons = {}
        for i = 1, 9 do
            local template = Unselectable
            if i < buttons_enabled then
                template = SelectableButton
            end
            if i == current_button then
                template = CurrentButton
            end
            local row = translate(template, hd, palette, node)
            -- TODO verify font
            local label = abyss.createLabel(SystemFonts.FntFormal12)
            label.caption = 'Waypoint N ' .. i
            label:setAlignment('start', 'middle')
            row:appendChild(label)
            row.data.label = label
            local textRect = deepcopy(template.fields['text/rect'])
            textRect.x = textRect.x - template.fields.rect.x
            move_by(label, textRect)
            local color
            if i < buttons_enabled then
                if i == current_button then
                    row.currentFrameIndex = 0 -- TODO
                    color = layout.fields.currentFontColor
                else
                    row.currentFrameIndex = layout.fields.selectableFrames[1]
                    color = layout.fields.selectableFontColor
                end
            else
                color = template.fields.textColor
            end
            label:setColorMod(color.r, color.g, color.b)
            move_by(row, {y=y})
            y = y + layout.fields.buttonOffset
            node:appendChild(row)
            table.insert(node.data.buttons, row)
        end
    end
end

function LayoutLoader:getProfileSD() return _profileSD end
function LayoutLoader:getProfileHD() return _profileHD end

function LayoutLoader:load(name, palette)
    local layout = readLayout(name)
    local hd = name:lower():match('hd.json$')
    resolveReferences(layout, cond(hd, _profileHD, _profileSD))
    return translate(layout, hd, palette)
end

function LayoutLoader:initialize()
    _profileSD = readResolvedProfile('sd')
    _profileHD = readResolvedProfile('hd')
    --TODO 'asian', 'lv' profiles
    _globalDataSD = self:load('GlobalData.json')
    _globalDataHD = self:load('GlobalDataHD.json')
end

return LayoutLoader
