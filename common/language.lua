--- Creates a new Language object.
--- @class Language
local Language = {}
local _id, _code, _hdcode, _name, _languageDefs, _strings
_languageDefs = require('common/enum/language')

local function loadD2RStrings()
    --TODO load other json files from this directory
    if not abyss.fileExists('/data/local/lng/strings/ui.json') then
        return
    end
    local json = ReadJsonAsTable('/data/local/lng/strings/ui.json')
    for _, data in ipairs(json) do
        _strings[data.Key] = data[_hdcode]
    end
end

local function loadTblFile(path)
    for key, value in pairs(abyss.loadTbl(Language:i18nPath(path))) do
        _strings[key] = value
    end
end

local function loadTblStrings()
    loadTblFile(ResourceDefs.StringTable)
    loadTblFile(ResourceDefs.ExpansionStringTable)
    loadTblFile(ResourceDefs.PatchStringTable)
end

--- Sets the language based on the name.
--- @param languageName string # The language name
function Language:setLanguage(languageName)
    _id = 0x00
    _code = _languageDefs.LanguageCodes[_id]
    _hdcode = _languageDefs.LanguageHdCodes[_id]
    _name = _languageDefs.LanguageNames[_id]
    _strings = {}

    for langName, langId in pairs(_languageDefs.Languages) do
        if string.lower(langName) == string.lower(languageName) then
            _id = langId
            _code = _languageDefs.LanguageCodes[_id]
            _hdcode = _languageDefs.LanguageHdCodes[_id]
            _name = _languageDefs.LanguageNames[_id]
            loadTblStrings()
            loadD2RStrings()
            return
        end
    end

    abyss.log("warn", "Invalid language: " .. languageName .. ". Attempting to auto-detect.")
end

--- Auto detect the langauge based on files in the path
function Language:autoDetect()
    _id = 0x00
    for langName, langId in pairs(_languageDefs.Languages) do
        if abyss.fileExists("/data/local/ui/" .. _languageDefs.LanguageCodes[langId] .. "/2dsound.dc6") then
            Language:setLanguage(_languageDefs.LanguageNames[langId])
            return
        end
    end
end

function Language:id()
    return _id
end

function Language:name()
    return _name
end

function Language:code()
    return _code
end

-- Replaces takes "@foo @bar" and replaces @... with their translation
function Language:translate(str)
    return str:gsub('@(%w+)', function(code)
        return _strings[code]
    end):gsub('@(#%d+)', function(code)
        return _strings[code]
    end)
end

function Language:hdaudioPath(originalPath)
    if _id == 0x00 then
        return originalPath
    else
        return "/locales/audio/" .. _hdcode .. originalPath
    end
end

--- Converts a language-specific path to the actual path based on the current language.
--- @param originalPath string # The path to convert.
--- @return string # The converted path.
function Language:i18nPath(originalPath)
    local path =  originalPath:gsub("{LANG_FONT}", _languageDefs.LanguageFontNames[_id])
    path = path:gsub("{LANG}", _languageDefs.LanguageCodes[_id])
    return path
end

return Language
