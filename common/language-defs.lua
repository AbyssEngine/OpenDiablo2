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
return {
    Languages = {
        ["English"] = 0x00,
        ["Spanish"] = 0x01,
        ["German"] = 0x02,
        ["French"] = 0x03,
        ["Portuguese"] = 0x04,
        ["Italian"] = 0x05,
        ["Japanese"] = 0x06,
        ["Korean"] = 0x07,
        ["Chinese"] = 0x09,
        ["Polish"] = 0x0A,
        ["Russian"] = 0x0B
    },
    LanguageCodes = {
        [0x00] = "eng",
        [0x01] = "esp",
        [0x02] = "deu",
        [0x03] = "fra",
        [0x04] = "por",
        [0x05] = "ita",
        [0x06] = "jpn",
        [0x07] = "kor",
        [0x09] = "chi",
        [0x0A] = "pol",
        [0x0B] = "rus"
    },
    LanguageNames = {
        [0x00] = "English",
        [0x01] = "Spanish",
        [0x02] = "German",
        [0x03] = "French",
        [0x04] = "Portuguese",
        [0x05] = "Italian",
        [0x06] = "Japanese",
        [0x07] = "Korean",
        [0x09] = "Chinese",
        [0x0A] = "Polish",
        [0x0B] = "Russian"
    },
    LanguageFontNames = {
        [0x00] = "LATIN",
        [0x01] = "LATIN", -- TODO: Confirm for Spanish
        [0x02] = "LATIN", -- TODO: Confirm for German
        [0x03] = "LATIN", -- TODO: Confirm for French
        [0x04] = "LATIN", -- TODO: Confirm for Portuguese
        [0x05] = "LATIN", -- TODO: Confirm for Italian
        [0x06] = "LATIN", -- TODO: Confirm for Japanese
        [0x07] = "LATIN", -- TODO: Confirm for Korean
        [0x09] = "LATIN", -- TODO: Confirm for Chinese
        [0x0A] = "LATIN", -- TODO: Confirm for Polish
        [0x0B] = "LATIN" -- TODO: Confirm for Russian    
    }
}
