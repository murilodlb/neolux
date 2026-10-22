local M = {}

function M.get(palette)
    return {
        MasonNormal = { link = "NormalFloat" },
        MasonHeader = { fg = palette.bg, bg = palette.pink, bold = true },
        MasonHeaderSecondary = { fg = palette.bg, bg = palette.light_blue, bold = true },
        MasonHighlight = { fg = palette.light_blue },
        MasonHighlightBlock = { fg = palette.bg, bg = palette.light_blue },
        MasonHighlightBlockBold = { fg = palette.bg, bg = palette.light_blue, bold = true },
        MasonMuted = { fg = palette.gray3 },
        MasonMutedBlock = { fg = palette.fg, bg = palette.gray2 },
    }
end

return M
