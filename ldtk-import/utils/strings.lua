-- This is to format all strings from names for layers, files, etc.

local S = {}

function S.find_tilesource_field(string)
    local formatted_string = string:lower():gsub("%W", ""):gsub("%d", ""):gsub("%s", "")
    return formatted_string == "tilesource"
end

function S.find_tilesource_path(string)
    local formatted_string = string:gsub("[^%w./_]", "")
        :gsub("[%.%/_]+", "/")
        :gsub("^/", "")
        :gsub("/$", "")
        :gsub("/tilesource$", "")

    return "/" .. formatted_string .. ".tilesource"
end

return S
