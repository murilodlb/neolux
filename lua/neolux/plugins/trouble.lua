local M = {}

function M.get(palette, opts)
    local transparent = opts and opts.transparent
    local bg = transparent and "NONE" or palette.bg

    return {
        TroubleNormal = { fg = palette.fg, bg = bg },
        TroubleNormalNC = { fg = palette.fg, bg = bg },
        TroubleText = { fg = palette.fg },
        TroubleCount = { fg = palette.pink, bg = palette.gray1, bold = true },
        TroubleCode = { fg = palette.gray3 },
        TroublePos = { fg = palette.gray3 },
        TroubleFilename = { fg = palette.fg },
        TroubleDirectory = { fg = palette.light_blue },
        TroubleSource = { fg = palette.gray3 },
        TroubleIndent = { fg = palette.gray2 },
        TroubleIndentFoldClosed = { fg = palette.gray3 },
        TroubleIndentFoldOpen = { fg = palette.gray2 },
        TroubleIconDirectory = { fg = palette.light_blue },
        TroublePreview = { bg = palette.gray2 },
    }
end

return M
