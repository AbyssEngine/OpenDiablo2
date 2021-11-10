-- Copyright (C) 2021 Tim Sarbin
-- This file is part of OpenDiablo2 <https://github.com/AbyssEngine/OpenDiablo2>.
--
-- OpenDiablo2 is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- OpenDiablo2 is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with OpenDiablo2.  If not, see <http://www.gnu.org/licenses/>.
--
local languageDefs = require("common/language-defs")

languageSpec = {
    id = 0x00,
    name = "",
    code = ""
}

function set(languageCode)
    languageSpec.id = 0x00
    languageSpec.code = languageDefs.LanguageCodes[languageSpec.id]
    languageSpec.name = languageDefs.LanguageNames[languageSpec.id]

    for langName, langId in pairs(languageDefs.Languages) do
        if string.lower(langName) == string.lower(languageCode) then
            languageSpec.id = langId
            languageSpec.code = languageDefs.LanguageCodes[languageSpec.id]
            languageSpec.name = languageDefs.LanguageNames[languageSpec.id]
            return
        end
    end
end

function autoDetect()
    languageSpec.id = 0x00
    for langName, langId in pairs(languageDefs.Languages) do
        if fileExists("/data/local/ui/" .. languageDefs.LanguageCodes[langId] .. "/2dsound.dc6") then
            languageSpec.id = langId
            languageSpec.code = languageDefs.LanguageCodes[langId]
            languageSpec.name = languageDefs.LanguageNames[langId]
            return
        end
    end
end

function id()
    return languageSpec.id
end

function name()
    return languageSpec.name
end

function code()
    return languageSpec.code
end

function i18nPath(originalPath)
    newPath = originalPath:gsub("{LANG_FONT}", languageDefs.LanguageFontNames[languageSpec.id])
    newPath = newPath:gsub("{LANG}", languageDefs.LanguageCodes[languageSpec.id])
    return newPath
end

return {
    code = code,
    name = name,
    id = id,
    autoDetect = autoDetect,
    set = set,
    i18nPath = i18nPath
}
