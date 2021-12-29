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

-- Takes string such as "@foo","@bar#nnn" or "@#nnn" and replaces it with their translation
-- nnn is the number; mostly it's for compatibility with MPQs, as not all keys there are strings.
-- @text#nnn form uses text if available, and falls back to nnn
-- numeric code only uses tbl files, text code tries json file first, then tbl,
-- because the numeric code in json doesn't always match the numeric code in
-- tbl, and some strings are only accessible in tbl via number
--
-- TODO consider automaically mapping the code to json too.
-- So far, seems like numbers in the 5xxx range are the same, but numbers in
-- 2xxx range are prepended with another 2, turning e.g. 2519 into 22519 in
-- json
function Language:translate(str)
    local m, _, code, num = str:find('^@(%w+)(#%d+)$')
    if m == nil then
        m, _, num = str:find('^@(#%d+)$')
    end
    if m == nil then
        m, _, code = str:find('^@(%w+)$')
    end
    if m == nil then
        return str
    end
    local result = _strings[code]
    if result ~= nil then
        return result
    end
    result = _strings[num]
    if result ~= nil then
        return result
    end
    return str
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
