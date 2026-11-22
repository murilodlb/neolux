local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)
    local eob_fg = bgs.sidebar == "NONE" and palette.gray2 or bgs.sidebar

    return {
        -- Base & Windowing
        NeoTreeNormal = { fg = palette.fg, bg = bgs.sidebar },
        NeoTreeNormalNC = { fg = palette.fg, bg = bgs.sidebar },
        NeoTreeSignColumn = { fg = palette.gray3, bg = bgs.sidebar },
        NeoTreeWinSeparator = { fg = palette.gray2, bg = bgs.sidebar },
        NeoTreeEndOfBuffer = { fg = eob_fg, bg = bgs.sidebar },
        NeoTreeCursorLine = { bg = palette.gray2 },
        -- Structural Elements
        NeoTreeRootName = { fg = palette.orange, bold = true },
        NeoTreeDirectoryName = { fg = palette.light_blue },
        NeoTreeDirectoryIcon = { fg = palette.light_blue },
        NeoTreeDirIcon = { fg = palette.gray3 },
        NeoTreeExpander = { fg = palette.gray2 },
        NeoTreeIndentMarker = { fg = palette.gray2 },
        NeoTreeSymbolicLinkTarget = { fg = palette.purple },
        -- File Names & States
        NeoTreeFileName = { fg = palette.fg },
        NeoTreeFileNameOpened = { fg = palette.fg, bold = true },
        NeoTreeDimText = { fg = palette.gray2 },
        NeoTreeDotfile = { fg = palette.gray2 },
        NeoTreeHiddenByName = { fg = palette.gray2 },
        -- Git Status within File Explorer
        NeoTreeGitAdded = { fg = palette.green },
        NeoTreeGitModified = { fg = palette.yellow },
        NeoTreeGitDeleted = { fg = palette.pink },
        NeoTreeGitRenamed = { fg = palette.purple },
        NeoTreeGitUntracked = { fg = palette.orange },
        NeoTreeGitIgnored = { fg = palette.gray2 },
        NeoTreeGitConflict = { fg = palette.pink, bold = true },
        NeoTreeGitUnstaged = { fg = palette.yellow },
        NeoTreeGitStaged = { fg = palette.green },
        -- In-Tree Diagnostics & Badges
        NeoTreeFileStats = { fg = palette.gray2 },
        NeoTreeFileStatsHeader = { fg = palette.gray3, bold = true },
        NeoTreeFilterTerm = { fg = palette.green, bold = true },
        NeoTreeFloatTitle = { fg = palette.light_blue, bg = bgs.float, bold = true },
        NeoTreeFloatBorder = { fg = palette.gray3, bg = bgs.float },
    }
end

return M
