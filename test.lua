require("util")

showSystemCursor(true)
-- testing stuff...
basePath = getConfig("#Abyss", "BasePath")
mpqRoot = getConfig("System", "MPQRoot")
mpqs = split(getConfig("System", "MPQs"), ",")

for i in pairs(mpqs) do
    mpqPath = basePath .. "/" .. mpqRoot .. "/" .. mpqs[i]
    loadStr = string.format("Loading Provider '%s'...", mpqPath)
    log("info", loadStr)
    setBootText("\\#FFFF00 " .. loadStr)
    addLoaderProvider("mpq", mpqPath)
end

setBootText("Finished loading MPQ providers...")

log("info", string.format("%s -> %d", "This is a test from Lua!", 123))
showSystemCursor(false)
