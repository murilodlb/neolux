local M = {}

function M.get(palette)
    local hl = {
        WhichKeyNormal = { fg = palette.fg, bg = palette.gray1 },
        WhichKeyBorder = { fg = palette.gray3, bg = palette.gray1 },
        WhichKeyTitle = { fg = palette.orange, bg = palette.gray1, bold = true },
        WhichKey = { fg = palette.orange, bold = true },
        WhichKeyGroup = { fg = palette.light_blue },
        WhichKeyDesc = { fg = palette.fg },
        WhichKeySeparator = { fg = palette.gray3 },
        WhichKeyValue = { fg = palette.beige },
        WhichKeyIcon = { fg = palette.light_blue },
    }

    local icon_colors = {
        Azure = palette.light_blue,
        Blue = palette.blue,
        Cyan = palette.light_blue,
        Green = palette.green,
        Grey = palette.gray3,
        Orange = palette.orange,
        Purple = palette.purple,
        Red = palette.pink,
        Yellow = palette.yellow,
    }
    for name, color in pairs(icon_colors) do
        hl["WhichKeyIcon" .. name] = { fg = color }
    end

    return hl
end

return M
