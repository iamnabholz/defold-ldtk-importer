local strings = require "ldtk-import.utils.strings"

local L = {}

local function layer_to_string(layer, z_counter, visible, cells_data)
    local visibility = visible == true and "" or "is_visible: 0"
    local layer_data = string.format("layers {\n  id: %q\n  z: %.2f\n  %s\n  %s\n}\n",
        string.lower(layer.__identifier or ("layer_" .. z_counter)), z_counter, visibility, cells_data)

    return layer_data
end

local function cell_to_string(cell, x_value, y_value)
    local flip_values = ""

    if cell.f == 1 then
        flip_values = string.format("h_flip: %i", 1)
    elseif cell.f == 2 then
        flip_values = string.format("v_flip: %i", 1)
    elseif cell.f == 3 then
        flip_values = string.format("h_flip: %i \n v_flip: %i \n", 1, 1)
    end

    local cells_data = string.format("cell { \n x: %i \n y: %i \n tile: %i \n %s \n } \n", x_value, y_value, cell.t,
        flip_values)

    return cells_data
end

-- Function to format data in Lua-like style
function L.format_tilemap_data(level)
    -- Initialize the z counter
    local z_counter = 0.0000

    -- Initialize the tile_set_source as an empty string
    local tile_set_source = ""

    local level_height = level.pxHei


    -- Maybe we could change this so it automatically grabs a tilesource in the same folder the .ldtk file is
    -- If tile_set_source is nil then we automatically try to grab a tilesurce from the same path, if its also not available then leave empty

    -- Get fieldInstances and search for tile_set
    local field_instances = level.fieldInstances or {}
    for _, field in ipairs(field_instances) do
        if strings.find_tilesource_field(field.__identifier) then
            tile_set_source = strings.find_tilesource_path(field.__value)
            break -- Exit the loop once the value is found
        end
    end

    if tile_set_source == "" then
        print("Tilesource path not set on LDtk")
    end

    local layer_data = ""

    -- Process each layer
    for _, layer in ipairs(level.layerInstances or {}) do
        local cells_data = ""

        if layer["__type"] ~= "Entities" then
            -- Process each cell in autoLayerTiles
            for _, cell in ipairs(layer.autoLayerTiles or {}) do
                local x_value = math.floor(cell.px[1] / layer.__gridSize)
                local y_calculation = math.floor((cell.px[2] - level_height) / layer.__gridSize)
                local y_value = (math.floor(y_calculation / -1) - 1)

                cells_data = cells_data .. cell_to_string(cell, x_value, y_value)
            end

            -- Process each cell in gridTiles
            for _, cell in ipairs(layer.gridTiles or {}) do
                local x_value = math.floor(cell.px[1] / layer.__gridSize)
                local y_calculation = math.floor((cell.px[2] - level_height) / layer.__gridSize)
                local y_value = (math.floor(y_calculation / -1) - 1)

                cells_data = cells_data .. cell_to_string(cell, x_value, y_value)
            end

            layer_data = layer_data .. layer_to_string(layer, z_counter, layer.visible, cells_data)
            -- Increment the z counter for the next layer
            z_counter = z_counter + 0.00001
        end
    end

    local output_format = string.format("tile_set: %q \n%s \nmaterial: '/builtins/materials/tile_map.material'",
        tile_set_source, layer_data)

    return output_format
end

return L
