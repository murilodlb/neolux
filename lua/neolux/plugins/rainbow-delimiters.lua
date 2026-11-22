local M = {}

function M.get(palette)
    return {
        RainbowDelimiterRed = { fg = palette.pink },
        RainbowDelimiterYellow = { fg = palette.yellow },
        RainbowDelimiterBlue = { fg = palette.blue },
        RainbowDelimiterOrange = { fg = palette.orange },
        RainbowDelimiterGreen = { fg = palette.green },
        RainbowDelimiterViolet = { fg = palette.purple },
        RainbowDelimiterCyan = { fg = palette.light_blue },
    }
end

return M
