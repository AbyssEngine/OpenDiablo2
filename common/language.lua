--- Creates a new Language object.
--- @class Language
local Language = {}
local _languageDefs = require('common/enum/language')
local _code, _3code, _name, _strings

local function loadD2RStrings()
    --TODO load other json files from this directory
    if not abyss.fileExists('/data/local/lng/strings/ui.json') then
        return
    end
    local json = ReadJsonAsTable('/data/local/lng/strings/ui.json')
    for _, data in ipairs(json) do
        _strings[data.Key] = data[_code]
    end
end

local function loadTblFile(path)
    local filename = Language:i18nPath(path)
    if not abyss.fileExists(filename) then
        abyss.log("warn", "Classic translation file not found: " .. filename)
        return
    end
    for key, value in pairs(abyss.loadTbl(filename)) do
        _strings[key] = value
    end
end

local function loadTblStrings()
    loadTblFile(ResourceDefs.StringTable)
    loadTblFile(ResourceDefs.ExpansionStringTable)
    loadTblFile(ResourceDefs.PatchStringTable)
end

--- Sets the language based on the name.
--- @param code string # The language code, as used in D2R, e.g. "ruRU"
function Language:setLanguage(code)
    _code = code
    _3code = _languageDefs.Language3Codes[code]
    _name = _languageDefs.LanguageNames[code]
    _strings = {}

    if _name == nil then
        abyss.log("warn", "Invalid language: " .. code .. ".")
        return
    end

    loadTblStrings()
    loadD2RStrings()
end

--- Auto detect the langauge based on files in the path
function Language:autoDetect()
    for langCode, _ in pairs(_languageDefs.LanguageNames) do
        if abyss.fileExists("/data/local/ui/" .. _languageDefs.Language3Codes[langCode] .. "/2dsound.dc6") then
            Language:setLanguage(langCode)
            return
        end
    end
    Language:setLanguage("enUS")
end

function Language:code3()
    return _3code
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
    if _code == "enUS" then
        return originalPath
    else
        return "/locales/audio/" .. _code .. originalPath
    end
end

--- Converts a language-specific path to the actual path based on the current language.
--- @param originalPath string # The path to convert.
--- @return string # The converted path.
function Language:i18nPath(originalPath)
    local path =  originalPath:gsub("{LANG_FONT}", or_else(_languageDefs.LanguageFontNames[_code], 'LATIN'))
    path = path:gsub("{LANG}", or_else(_3code, 'eng'))
    return path
end

return Language
