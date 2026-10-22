local M = {}

function M.get(palette)
    return {
        TelescopeNormal = { fg = palette.fg, bg = palette.gray1 },
        TelescopeBorder = { fg = palette.gray3, bg = palette.gray1 },
        TelescopeTitle = { fg = palette.orange, bg = palette.gray1, bold = true },
        TelescopePromptNormal = { fg = palette.fg, bg = palette.gray1 },
        TelescopePromptBorder = { fg = palette.orange, bg = palette.gray1 },
        TelescopePromptTitle = { fg = palette.bg, bg = palette.orange, bold = true },
        TelescopePromptPrefix = { fg = palette.orange, bg = palette.gray1 },
        TelescopePromptCounter = { fg = palette.gray3, bg = palette.gray1 },
        TelescopeResultsNormal = { fg = palette.fg, bg = palette.gray1 },
        TelescopeResultsBorder = { fg = palette.gray3, bg = palette.gray1 },
        TelescopeResultsTitle = { fg = palette.light_blue, bg = palette.gray1, bold = true },
        TelescopePreviewNormal = { fg = palette.fg, bg = palette.bg },
        TelescopePreviewBorder = { fg = palette.gray3, bg = palette.bg },
        TelescopePreviewTitle = { fg = palette.green, bg = palette.bg, bold = true },
        TelescopeSelection = { fg = palette.fg, bg = palette.gray2, bold = true },
        TelescopeSelectionCaret = { fg = palette.pink, bg = palette.gray2, bold = true },
        TelescopeMultiSelection = { fg = palette.purple, bg = palette.gray2 },
        TelescopeMatching = { fg = palette.orange, bold = true },
    }
end

return M
