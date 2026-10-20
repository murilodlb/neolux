local M = {}

function M.get(palette, opts)
    local bg = (opts and opts.transparent) and "NONE" or palette.bg

    return {
        -- Base & Windowing
        NeoTreeNormal             = { fg = palette.gray3, bg = bg },
        NeoTreeNormalNC           = { fg = palette.gray3, bg = bg },
        NeoTreeSignColumn         = { fg = palette.gray3, bg = bg },
        NeoTreeWinSeparator       = { fg = palette.gray1, bg = bg },
        NeoTreeEndOfBuffer        = { fg = palette.bg, bg = bg },
        NeoTreeCursorLine         = { bg = palette.gray1 },
        -- Structural Elements
        NeoTreeRootName           = { fg = palette.pink, bold = true },
        NeoTreeDirectoryName      = { fg = palette.fg },
        NeoTreeDirectoryIcon      = { fg = palette.light_blue },
        NeoTreeDirIcon            = { fg = palette.gray3 },
        NeoTreeExpander           = { fg = palette.gray2 },
        NeoTreeIndentMarker       = { fg = palette.gray1 },
        NeoTreeSymbolicLinkTarget = { fg = palette.purple },
        -- File Names & States
        NeoTreeFileName           = { fg = palette.fg },
        NeoTreeFileNameOpened     = { fg = palette.fg, bold = true },
        NeoTreeDimText            = { fg = palette.gray2 },
        NeoTreeDotfile            = { fg = palette.gray2 },
        NeoTreeHiddenByName       = { fg = palette.gray2 },
        -- Git Status within File Explorer
        NeoTreeGitAdded           = { fg = palette.green },
        NeoTreeGitModified        = { fg = palette.yellow },
        NeoTreeGitDeleted         = { fg = palette.pink },
        NeoTreeGitRenamed         = { fg = palette.purple },
        NeoTreeGitUntracked       = { fg = palette.orange },
        NeoTreeGitIgnored         = { fg = palette.gray2 },
        NeoTreeGitConflict        = { fg = palette.pink, bold = true },
        NeoTreeGitUnstaged        = { fg = palette.yellow },
        NeoTreeGitStaged          = { fg = palette.green },
        -- In-Tree Diagnostics & Badges
        NeoTreeFileStats          = { fg = palette.gray2 },
        NeoTreeFileStatsHeader    = { fg = palette.gray3, bold = true },
        NeoTreeFilterTerm         = { fg = palette.green, bold = true },
        NeoTreeFloatTitle         = { fg = palette.light_blue, bg = palette.gray1, bold = true },
        NeoTreeFloatBorder        = { fg = palette.gray3, bg = palette.gray1 },
    }
end

return M
