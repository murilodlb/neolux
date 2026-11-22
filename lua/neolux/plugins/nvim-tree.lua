local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)
    local eob_fg = bgs.sidebar == "NONE" and palette.gray2 or bgs.sidebar

    return {
        NvimTreeNormal = { fg = palette.fg, bg = bgs.sidebar },
        NvimTreeNormalNC = { fg = palette.fg, bg = bgs.sidebar },
        NvimTreeSignColumn = { fg = palette.fg, bg = bgs.sidebar },
        NvimTreeWinSeparator = { fg = palette.gray2, bg = bgs.sidebar },
        NvimTreeEndOfBuffer = { fg = eob_fg, bg = bgs.sidebar },
        NvimTreeCursorLine = { bg = palette.gray2 },
        NvimTreeNormalFloat = { fg = palette.fg, bg = bgs.float },

        NvimTreeRootFolder = { fg = palette.orange, bold = true },
        NvimTreeFolderName = { fg = palette.light_blue },
        NvimTreeFolderIcon = { fg = palette.light_blue },
        NvimTreeOpenedFolderName = { fg = palette.light_blue, bold = true },
        NvimTreeEmptyFolderName = { fg = palette.gray3 },
        NvimTreeSymlinkFolderName = { fg = palette.light_blue, italic = true },
        NvimTreeIndentMarker = { fg = palette.gray2 },

        NvimTreeExecFile = { fg = palette.green, bold = true },
        NvimTreeOpenedFile = { fg = palette.orange, bold = true },
        NvimTreeModifiedFile = { fg = palette.yellow },
        NvimTreeSpecialFile = { fg = palette.pink, underline = true },
        NvimTreeImageFile = { fg = palette.purple },
        NvimTreeSymlink = { fg = palette.light_blue },
        NvimTreeBookmark = { fg = palette.pink },

        NvimTreeGitDirty = { fg = palette.yellow },
        NvimTreeGitStaged = { fg = palette.green },
        NvimTreeGitMerge = { fg = palette.orange },
        NvimTreeGitRenamed = { fg = palette.light_blue },
        NvimTreeGitNew = { fg = palette.green },
        NvimTreeGitDeleted = { fg = palette.pink },
        NvimTreeGitIgnored = { fg = palette.gray3 },

        NvimTreeLspDiagnosticsError = { fg = palette.pink },
        NvimTreeLspDiagnosticsWarning = { fg = palette.yellow },
        NvimTreeLspDiagnosticsInformation = { fg = palette.light_blue },
        NvimTreeLspDiagnosticsHint = { fg = palette.beige },
    }
end

return M
