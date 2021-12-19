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
    self.startMouseX = 0
    self.startMouseY = 0
    self.lastMouseX = 0
    self.lastMouseY = 0
    self.curMapOffsetX = 400
    self.curMapOffsetY = 300
    self.isMouseDrag = false

    self.currentMap = 1
    self.currentPreset = 1
    self.selectedFile = 1
    self.RegionSpec = {
        -- Act 1
        { typeId = RegionDefs.Act1.Town,       startPreset =    1, endPreset =    3, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Wilderness, startPreset =    4, endPreset =   52, Palette = ResourceDefs.Palette.Act1, extra = {108,160,161,162,163,164} },
        { typeId = RegionDefs.Act1.Cave,       startPreset =   53, endPreset =  107, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Crypt,      startPreset =  109, endPreset =  159, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Monastary,  startPreset =  165, endPreset =  165, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Courtyard,  startPreset =  166, endPreset =  166, Palette = ResourceDefs.Palette.Act1, extra = {256} },
        { typeId = RegionDefs.Act1.Barracks,   startPreset =  167, endPreset =  205, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Jail,       startPreset =  206, endPreset =  255, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Cathedral,  startPreset =  257, endPreset =  257, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Catacombs,  startPreset =  258, endPreset =  299, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Tristram,   startPreset =  300, endPreset =  300, Palette = ResourceDefs.Palette.Act1, extra = {} },

        -- Act2
        { typeId = RegionDefs.Act2.Town,       startPreset =  301, endPreset =  301, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Sewer,      startPreset =  302, endPreset =  352, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Harem,      startPreset =  353, endPreset =  357, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Basement,   startPreset =  358, endPreset =  361, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Desert,     startPreset =  362, endPreset =  413, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Tomb,       startPreset =  414, endPreset =  481, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Lair,       startPreset =  482, endPreset =  509, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Arcane,     startPreset =  510, endPreset =  528, Palette = ResourceDefs.Palette.Act2, extra = {} },

        -- Act III
		{ typeId = RegionDefs.Act3.Town,       startPreset =  529, endPreset =  529, Palette = ResourceDefs.Palette.Act3, extra = {}},
		{ typeId = RegionDefs.Act3.Jungle,     startPreset =  530, endPreset =  604, Palette = ResourceDefs.Palette.Act3, extra = {}},
		{ typeId = RegionDefs.Act3.Kurast,     startPreset =  605, endPreset =  658, Palette = ResourceDefs.Palette.Act3, extra = {748, 749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769,770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791,792, 793, 794, 795, 796}},
		{ typeId = RegionDefs.Act3.Spider,     startPreset =  659, endPreset =  664, Palette = ResourceDefs.Palette.Act3, extra = {}},
		{ typeId = RegionDefs.Act3.Dungeon,    startPreset =  665, endPreset =  704, Palette = ResourceDefs.Palette.Act3, extra = {}},
		{ typeId = RegionDefs.Act3.Sewer,      startPreset =  705, endPreset =  747, Palette = ResourceDefs.Palette.Act3, extra = {}},

		-- Act IV
		{ typeId = RegionDefs.Act4.Town,       startPreset =  797, endPreset =  798, Palette = ResourceDefs.Palette.Act4, extra = {}},
		{ typeId = RegionDefs.Act4.Mesa,       startPreset =  799, endPreset =  835, Palette = ResourceDefs.Palette.Act4, extra = {}},
		{ typeId = RegionDefs.Act4.Lava,       startPreset =  836, endPreset =  862, Palette = ResourceDefs.Palette.Act4, extra = {}},

		-- Act V
		{ typeId = RegionDefs.Act5.Town,       startPreset =  863, endPreset =  864, Palette = ResourceDefs.Palette.Act5, extra = {}},
		{ typeId = RegionDefs.Act5.Siege,      startPreset =  865, endPreset =  879, Palette = ResourceDefs.Palette.Act5, extra = {}},
		{ typeId = RegionDefs.Act5.Barricade,  startPreset =  880, endPreset = 1002, Palette = ResourceDefs.Palette.Act5, extra = {}},
		{ typeId = RegionDefs.Act5.IceCaves,   startPreset = 1003, endPreset = 1041, Palette = ResourceDefs.Palette.Act5, extra = {}},
		{ typeId = RegionDefs.Act5.Temple,     startPreset = 1042, endPreset = 1052, Palette = ResourceDefs.Palette.Act5, extra = {}},
        { typeId = RegionDefs.Act5.Lava,       startPreset = 1053, endPreset = 1058, Palette = ResourceDefs.Palette.Act4, extra = {}},
		{ typeId = RegionDefs.Act5.Baal,       startPreset = 1059, endPreset = 1090, Palette = ResourceDefs.Palette.Act5, extra = {}},

    }

    abyss.playBackgroundMusic("")
    self.rootNode = abyss.getRootNode()

    self.zone = abyss.createZone()

    local paletteName = ""

    self.mapRenderer = abyss.createMapRenderer(self.zone)

    self.mapRenderer:setPosition(self.curMapOffsetX, self.curMapOffsetY)
    self.mapRenderer.showOuterBorder = true

    self.btnExit = CreateButton(ButtonTypes.Short, 0, 573, "Exit", function()
        SetScreen(Screen.MAIN_MENU)
    end)

    self.btnPrevious = CreateButton(ButtonTypes.Medium, 0, 0, "< Preset", function()
        self:previousMap()
    end)

    self.btnPreviousFile = CreateButton(ButtonTypes.Medium, 0, 35, "< File", function()
        self:previousFile()
    end)

    self.btnNext = CreateButton(ButtonTypes.Medium, 672, 0, "Preset >", function()
        self:nextMap()
    end)

    self.btnNextFile = CreateButton(ButtonTypes.Medium, 672, 35, "File >", function()
        self:nextFile()
    end)

    self.lblMapName = abyss.createLabel(SystemFonts.Fnt16)
    self.lblMapName:setPosition(400, 8)
    self.lblMapName:setColorMod(0xFF, 0xFF, 0x00)
    self.lblMapName:setAlignment("middle", "middle")
    self.lblMapName.caption = ""

    self.lblPreset = abyss.createLabel(SystemFonts.Fnt16)
    self.lblPreset:setPosition(400, 22)
    self.lblPreset:setColorMod(0xFF, 0xFF, 0xFF)
    self.lblPreset:setAlignment("middle", "middle")
    self.lblPreset.caption = ""

    self.inputListener = abyss.createInputListener()
    self.mapRenderer:appendChild(self.inputListener)
    self.inputListener:onMouseMove(function(x, y)
        self.lastMouseX = x
        self.lastMouseY = y

        if self.isMouseDrag then
            self.mapRenderer:setPosition(self.curMapOffsetX + (x - self.startMouseX), self.curMapOffsetY + (y - self.startMouseY))
        else
            self.startMouseX = x
            self.startMouseY = y
        end
    end)
    self.inputListener:onMouseButton(function(button, isPressed)
        if button == 1 then -- Left mouse button
            if isPressed then
                self.isMouseDrag = true
            else
                self.isMouseDrag = false
                self.curMapOffsetX, self.curMapOffsetY = self.mapRenderer:getPosition()
            end
        elseif button == 2 and isPressed then -- Right mouse button
            local mx, my = self.mapRenderer:getPosition()
            local tx, ty = abyss.orthoToWorld(self.lastMouseX - mx, self.lastMouseY - my)
            if (tx >= 0) and (ty >= 0) and (tx < self.zone.width) and (ty < self.zone.height) then
                local tiles = self.zone:getTileInfo(tx, ty)
                abyss.log("info", "Tiles at " .. tx .. ", " .. ty .. ":")
                for _, tile in ipairs(tiles) do
                    abyss.log("info", " -> " .. tile.type .. ", " .. tile.mainIndex .. ", " .. tile.subIndex)
                end


            end
        end
    end)

    self.rootNode:appendChild(self.mapRenderer)
    self.rootNode:appendChild(self.btnExit)
    self.rootNode:appendChild(self.btnPrevious)
    self.rootNode:appendChild(self.btnNext)
    self.rootNode:appendChild(self.lblMapName)
    self.rootNode:appendChild(self.lblPreset)
    self.rootNode:appendChild(self.btnPreviousFile)
    self.rootNode:appendChild(self.btnNextFile)

    self:updateMap()
end

function MapEngineTest:nextMap()
    local region = self.RegionSpec[self.currentMap]
    if self.currentPreset < region.endPreset then
        self.currentPreset = self.currentPreset + 1
    else
        self.currentMap = self.currentMap + 1
        if self.currentMap > #self.RegionSpec then
            self.currentMap = 1
        end
        self.currentPreset = self.RegionSpec[self.currentMap].startPreset
    end
    self.selectedFile = 1

    self:updateMap()
end

function MapEngineTest:previousMap()
    local region = self.RegionSpec[self.currentMap]
    if self.currentPreset > region.startPreset then
        self.currentPreset = self.currentPreset - 1
    else
        self.currentMap = self.currentMap - 1
        if self.currentMap < 1 then
            self.currentMap = #self.RegionSpec
        end
        self.currentPreset = self.RegionSpec[self.currentMap].endPreset
    end
    self.selectedFile = 1

    self:updateMap()
end

function MapEngineTest:previousFile()
    local region = self.RegionSpec[self.currentMap]
    local levelType = LevelTypes[region.typeId]
    local preset = GetLevelPreset(levelType.id, self.currentPreset)

    if self.selectedFile > 1 then
        self.selectedFile = self.selectedFile - 1
    else
        self.selectedFile = #preset.files
    end

    self:updateMap()
end

function MapEngineTest:nextFile()
    local region = self.RegionSpec[self.currentMap]
    local levelType = LevelTypes[region.typeId]
    local preset = GetLevelPreset(levelType.id, self.currentPreset)

    if self.selectedFile < #preset.files then
        self.selectedFile = self.selectedFile + 1
    else
        self.selectedFile = 1
    end

    self:updateMap()
end

function MapEngineTest:updateMap()
    local region = self.RegionSpec[self.currentMap]
    local levelType = LevelTypes[region.typeId]
    local preset = GetLevelPreset(levelType.id, self.currentPreset)
    local fileCaption = preset.files[self.selectedFile]

    self.btnNextFile.visible = #preset.files > 1
    self.btnPreviousFile.visible = #preset.files > 1

    if #preset.files > 1 then
        fileCaption = fileCaption .. " (" .. self.selectedFile .. " of " .. #preset.files .. ")"
    end

    self.lblMapName.caption = preset.name
    self.lblPreset.caption = fileCaption

    local ds1 = abyss.loadDS1(preset.files[self.selectedFile])

    self.zone:resetMap(levelType, ds1.width, ds1.height, self.seed)
    self.zone:stamp(ds1, 0, 0)
    self.mapRenderer:compile(region.Palette)
    self.mapRenderer:setPosition(400, 300)
    self.curMapOffsetX = 400
    self.curMapOffsetY = 300
end

return MapEngineTest
