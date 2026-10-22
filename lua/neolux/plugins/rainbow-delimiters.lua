local M = {}

function M.get(palette)
    return {
        RainbowDelimiterYellow = { fg = palette.pink },
        RainbowDelimiterOrange = { fg = palette.orange },
        RainbowDelimiterRed = { fg = palette.yellow },
        RainbowDelimiterCyan = { fg = palette.light_blue },
        RainbowDelimiterBlue = { fg = palette.blue },
        RainbowDelimiterViolet = { fg = palette.purple },
        RainbowDelimiterGreen = { fg = palette.green },
    }
end

return M
