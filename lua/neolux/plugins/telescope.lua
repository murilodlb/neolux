local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)
    local bg = bgs.bg

    return {
        TelescopeNormal = { fg = palette.fg, bg = bgs.float },
        TelescopeBorder = { fg = palette.gray3, bg = bgs.float },
        TelescopeTitle = { fg = palette.orange, bg = bgs.float, bold = true },
        TelescopePromptNormal = { fg = palette.fg, bg = bgs.float },
        TelescopePromptBorder = { fg = palette.orange, bg = bgs.float },
        TelescopePromptTitle = { fg = palette.bg, bg = palette.orange, bold = true },
        TelescopePromptPrefix = { fg = palette.orange, bg = bgs.float },
        TelescopePromptCounter = { fg = palette.gray3, bg = bgs.float },
        TelescopeResultsNormal = { fg = palette.fg, bg = bgs.float },
        TelescopeResultsBorder = { fg = palette.gray3, bg = bgs.float },
        TelescopeResultsTitle = { fg = palette.light_blue, bg = bgs.float, bold = true },
        TelescopePreviewNormal = { fg = palette.fg, bg = bg },
        TelescopePreviewBorder = { fg = palette.gray3, bg = bg },
        TelescopePreviewTitle = { fg = palette.green, bg = bg, bold = true },
        TelescopeSelection = { fg = palette.fg, bg = palette.gray2, bold = true },
        TelescopeSelectionCaret = { fg = palette.pink, bg = palette.gray2, bold = true },
        TelescopeMultiSelection = { fg = palette.purple, bg = palette.gray2 },
        TelescopeMatching = { fg = palette.orange, bold = true },
    }
end

return M
