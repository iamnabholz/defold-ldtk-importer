local E = {}

function E.serialize_table(content, level_names)
    local result = {}
    table.insert(result, "local M = {}")

    for _, value in ipairs(content) do
        table.insert(result, ("M." .. level_names[_] .. " = {"))

        local function serialize(tbl, indent)
            indent = indent or ""
            local next_indent = indent .. "    "
            for k, v in pairs(tbl) do
                if type(v) == "table" then
                    if type(k) == "number" then
                        table.insert(result, indent .. "{")
                    else
                        table.insert(result, indent .. string.format("%s", k) .. " = {")
                    end
                    serialize(v, next_indent)
                    table.insert(result, indent .. "},")
                elseif type(v) == "string" then
                    table.insert(result, indent .. k .. " = " .. string.format("%q,", v))
                else
                    table.insert(result, indent .. k .. " = " .. tostring(v) .. ",")
                end
            end
        end

        serialize(value)
        table.insert(result, "}")
    end

    table.insert(result, "return M")

    return table.concat(result, "\n")
end

function E.collect_entity_layers(levels)
    local unique_identifiers = {}
    local result = {}

    for _, level in ipairs(levels) do
        for _, layer in ipairs(level.layerInstances or {}) do
            if layer["__type"] == "Entities" then
                local identifier = layer["__identifier"]
                if identifier and not unique_identifiers[identifier] then
                    -- Mark the identifier as seen
                    unique_identifiers[identifier] = true
                    -- Add the identifier to the result table
                    table.insert(result, identifier)
                end
            end
        end
    end

    return result
end

function E.generate_entities(levels, entity_layer)
    local level_entities = {}

    -- Write entities to an entity Lua module
    -- Process each cell in autoLayerTiles
    for _, level in ipairs(levels) do
        local layer_entities = {}

        for _, layer in ipairs(level.layerInstances or {}) do
            if layer["__type"] == "Entities" and layer["__identifier"] == entity_layer then
                for _, entity in ipairs(layer.entityInstances or {}) do
                    local y_calculation = math.floor((entity["px"][2] - level["pxHei"]) / layer.__gridSize)

                    local collected_properties = {}

                    for _, instance in ipairs(entity.fieldInstances or {}) do
                        local ins = {
                            id = instance["__identifier"],
                            value = instance["__value"] or nil,
                            tile = instance["__tile"]
                        }

                        table.insert(collected_properties, ins)
                    end

                    local new_entity = {
                        id = entity["__identifier"],
                        x = math.floor(entity["px"][1] / layer.__gridSize) + 1,
                        y = (math.floor(y_calculation / -1)),
                    }

                    if #collected_properties > 0 then
                        new_entity["properties"] = collected_properties
                    end

                    table.insert(layer_entities, new_entity)
                end
            end
        end

        table.insert(level_entities, layer_entities)
    end

    return level_entities
end

return E
