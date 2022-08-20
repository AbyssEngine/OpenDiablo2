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
require("string")
local jsonlib = require('common/json')

function Split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

--- Loads a tab seperated file into a table
--- @param filePath string # The path to the file
--- @param firstFieldIsHandle boolean # Whether the first field is the handle
--- @return table # The table containing the file contents
function LoadTsvAsTable(filePath, firstFieldIsHandle)
    local tsvData = abyss.loadString(filePath)

    local lines = {}

    for s in tsvData:gmatch("[^\r\n]+") do
        table.insert(lines, s .. "\t")
    end

    local fields = {}

    local fieldstart = 1
    repeat
        local nexti = lines[1]:find("\t", fieldstart)
        table.insert(fields, lines[1]:sub(fieldstart, nexti - 1))
        fieldstart = nexti + 1
    until fieldstart > lines[1]:len()

    local result = {}

    for i = 2, #lines do
        local line = lines[i]
        if line ~= nil and line:len() ~= 0 and line ~= '0' and line ~= 'expansion' and line ~= 'Expansion' then

            local fieldIdx = 0
            local item = {}

            fieldstart = 1
            repeat
                fieldIdx = fieldIdx + 1
                local nexti = line:find("\t", fieldstart)
                item[fields[fieldIdx]:gsub("%s+", "_")] = line:sub(fieldstart, nexti - 1)
                fieldstart = nexti + 1
            until fieldstart > line:len()

            if firstFieldIsHandle then
                result[item[fields[1]:gsub("%s+", "_")]] = item
            else
                table.insert(result, item)
            end
        end
    end

    return result
end

-- reads json file as lua table
function ReadJsonAsTable(path)
    local jsonstr = abyss.loadString(path)
    -- remove utf-8 bom
    if jsonstr:sub(1, 3) == '\xEF\xBB\xBF' then
        jsonstr = jsonstr:sub(4)
    end
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

function cond(c, a, b)
    if c then
        return a
    else
        return b
    end
end

function or_else(x, y)
    if x == nil then
        return y
    end
    return x
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
 end
 

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function dumplayout()
    local function output(node, offset)
        local x, y = node:getPosition()
        local line = node:nodeType() .. " X=" .. dump(x) .. " Y="..dump(y) .. " Active=" .. dump(node.active)
        if node.data.layout ~= nil then
            line = line .. " Layout type=" .. node.data.layout.type .. " name=" .. or_else(node.data.layout.name, "(nil)")
        end
        local label = node:castToLabel()
        if label ~= nil then
            line = line .. " text: " .. label.caption
        end
        for i = 1, offset do
            line = "    " .. line
        end
        abyss.log("info", line)
        local children = node:getChildren()
        for _, child in ipairs(children) do
            output(child, offset+1)
        end
    end
    output(abyss.getRootNode(), 0)
end
