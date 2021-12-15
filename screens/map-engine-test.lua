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
    self.currentMap = 1
    self.currentPreset = 1
    self.selectedFile = 1
    self.RegionSpec = {
        -- Act 1
        { typeId = RegionDefs.Act1.Town,       startPreset =   1, endPreset =  3,  Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Wilderness, startPreset =   4, endPreset =  52, Palette = ResourceDefs.Palette.Act1, extra = {108,160,161,162,163,164} },
        { typeId = RegionDefs.Act1.Cave,       startPreset =  53, endPreset = 107, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Crypt,      startPreset = 109, endPreset = 159, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Monastary,  startPreset = 165, endPreset = 165, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Courtyard,  startPreset = 166, endPreset = 166, Palette = ResourceDefs.Palette.Act1, extra = {256} },
        { typeId = RegionDefs.Act1.Barracks,   startPreset = 167, endPreset = 205, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Jail,       startPreset = 206, endPreset = 255, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Cathedral,  startPreset = 257, endPreset = 257, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Catacombs,  startPreset = 258, endPreset = 299, Palette = ResourceDefs.Palette.Act1, extra = {} },
        { typeId = RegionDefs.Act1.Tristram,   startPreset = 300, endPreset = 300, Palette = ResourceDefs.Palette.Act1, extra = {} },

        -- Act2
        { typeId = RegionDefs.Act2.Town,       startPreset = 301, endPreset = 301, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Sewer,      startPreset = 302, endPreset = 352, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Harem,      startPreset = 353, endPreset = 357, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Basement,   startPreset = 358, endPreset = 361, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Desert,     startPreset = 362, endPreset = 413, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Tomb,       startPreset = 414, endPreset = 481, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Lair,       startPreset = 482, endPreset = 509, Palette = ResourceDefs.Palette.Act2, extra = {} },
        { typeId = RegionDefs.Act2.Arcane,     startPreset = 510, endPreset = 528, Palette = ResourceDefs.Palette.Act2, extra = {} },
    }

    abyss.playBackgroundMusic("")
    self.rootNode = abyss.getRootNode()

    self.zone = abyss.createZone()

    local paletteName = ""

    self.mapRenderer = abyss.createMapRenderer(self.zone)

    self.mapRenderer:setPosition(400, 300)
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

end

return MapEngineTest
