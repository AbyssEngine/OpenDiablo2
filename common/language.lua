--- @class Language
--- Provides mechinisms for language-specific operations.
Language = {
        _id = 0x00,
        _name = "",
        _code = "",
        _hdcode = "",
        _languageDefs = require('common/language-defs')
}
Language.__index = Language

--- Creates a new Language object.
--- @return Language # A new Language object.
function Language:new()
    local this = {}
    self.__index = self
    setmetatable(this, self)
    return this
end

--- Sets the language based on the name.
--- @param languageName string # The language name
function Language:setLanguage(languageName)
    self._id = 0x00
    self._code = self._languageDefs.LanguageCodes[self._id]
    self._hdcode = self._languageDefs.LanguageHdCodes[self._id]
    self._name = self._languageDefs.LanguageNames[self._id]

    for langName, langId in pairs(self._languageDefs.Languages) do
        if string.lower(langName) == string.lower(languageName) then
            self._id = langId
            self._code = self._languageDefs.LanguageCodes[self._id]
            self._hdcode = self._languageDefs.LanguageHdCodes[self._id]
            self._name = self._languageDefs.LanguageNames[self._id]
            return
        end
    end

    abyss.log("warn", "Invalid language: " .. languageName .. ". Attempting to auto-detect.")
end

--- Auto detect the langauge based on files in the path
function Language:autoDetect()
    self._id = 0x00
    for langName, langId in pairs(self._languageDefs.Languages) do
        if abyss.fileExists("/data/local/ui/" .. self._languageDefs.LanguageCodes[langId] .. "/2dsound.dc6") then
            self:setLanguage(self._languageDefs.LanguageNames[langId])
            return
        end
    end
end

function Language:id()
    return self._id
end

function Language:name()
    return self._name
end

function Language:code()
    return self._code
end

function Language:hdaudioPath(originalPath)
    if self._id == 0x00 then
        return originalPath
    else
        return "/locales/audio/" .. self._hdcode .. originalPath
    end
end

--- Converts a language-specific path to the actual path based on the current language.
--- @param originalPath string # The path to convert.
--- @return string # The converted path.
function Language:i18nPath(originalPath)
    local path =  originalPath:gsub("{LANG_FONT}", self._languageDefs.LanguageFontNames[self._id])
    path = path:gsub("{LANG}", self._languageDefs.LanguageCodes[self._id])
    return path
end

return Language
