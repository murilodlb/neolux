local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)

    local hl = {
        WhichKeyNormal = { fg = palette.fg, bg = bgs.float },
        WhichKeyBorder = { fg = palette.gray3, bg = bgs.float },
        WhichKeyTitle = { fg = palette.orange, bg = bgs.float, bold = true },
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
