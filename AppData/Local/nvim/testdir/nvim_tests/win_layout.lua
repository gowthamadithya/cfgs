local wins_list = { "row", { { "col", { { "row", { { "col", { { "leaf", 1071 }, { "leaf", 1070 } } }, { "leaf", 1069 } } }, { "leaf", 1068 } } }, { "leaf", 1000 } } }


-- local first_row = { { "col", { { "row", { { "col", { { "leaf", 1071 }, { "leaf", 1070 } } }, { "leaf", 1069 } } }, { "leaf", 1068 } } }, { "leaf", 1000 } }
--
-- local first_row_1 = { "col", { { "row", { { "col", { { "leaf", 1071 }, { "leaf", 1070 } } }, { "leaf", 1069 } } }, { "leaf", 1068 } } }
-- local first_row_2 = { "leaf", 1000 }

local function browse_wins(layout)
    if layout[1] == "leaf" then
        return layout
    end

    local split = layout[1]
    local children = layout[2]
    local subs = {}

    for _, child in ipairs(children) do
        table.insert(subs, tostring(browse_wins(child)[2]))
    end

    local result = table.concat(subs, ",")
    print("split", split, "subs", result)
    return {split, result}
end
browse_wins(wins_list)
