local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)

    return {
        TroubleNormal = { fg = palette.fg, bg = bgs.sidebar },
        TroubleNormalNC = { fg = palette.fg, bg = bgs.sidebar },
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
