local palette = require("neolux.palette")

local M = {}

function M.setup()
    -- local ui_bg        = "#0c0c0c" -- gray1
    -- local ui_bg_alt    = "#393e46" -- gray2
    -- local ui_bg_visual = "#57595B" -- gray3

    local groups = {
        -- 1. Base Editor UI
        Normal       = { fg = palette.fg, bg = palette.bg },
        NonText      = { fg = palette.gray3 },
        ColorColumn  = { bg = palette.gray2 },
        EndOfBuffer  = { fg = palette.bg },
        Directory    = { fg = palette.light_blue, bold = true },
        Title        = { fg = palette.light_blue, bold = true },

        -- 2. Visual Selection
        Visual       = { reverse = true },
        VisualNOS    = { link = "Visual" },

        -- 3. Cursor & Lines
        Cursor       = { fg = palette.bg, bg = palette.orange },
        CursorLine   = { bg = palette.gray1 },
        CursorColumn = { link = "CursorLine" },
        LineNr       = { fg = palette.gray2 },
        CursorLineNr = { fg = palette.yellow, bg = palette.bg, bold = true },
        MatchParen   = { fg = palette.orange, bg = palette.gray2, bold = true },
        FieryYank    = { fg = palette.fg, bg = palette.orange, bold = true },
        IlluminatedWordText  = { reverse = true },
        IlluminatedWordRead  = { reverse = true },
        IlluminatedWordWrite = { reverse = true },
        LspReferenceText     = { reverse = true },
        LspReferenceRead     = { reverse = true },
        LspReferenceWrite    = { reverse = true },

        -- 4. Window Splits, Gutter & Status Lines
        SignColumn   = { fg = palette.gray3, bg = palette.bg },
        FoldColumn   = { fg = palette.gray2, bg = palette.bg },
        Folded       = { fg = palette.gray3, bg = palette.gray1 },
        VertSplit    = { fg = palette.gray3, bg = palette.bg },
        WinSeparator = { fg = palette.gray3, bg = palette.bg },
        StatusLine   = { fg = palette.fg, bg = palette.gray1 },
        StatusLineNC = { fg = palette.gray3, bg = palette.bg },
        WinBar       = { fg = palette.fg, bg = palette.bg },
        WinBarNC     = { fg = palette.gray3, bg = palette.bg },

        -- 5. Searching
        Search       = { fg = palette.bg, bg = palette.yellow },
        IncSearch    = { fg = palette.bg, bg = palette.orange, underline = true },
        CurSearch    = { link = "IncSearch" },

        -- 6. Pmenu (Popups like autocompletion)
        Pmenu        = { fg = palette.fg, bg = palette.gray1 },
        PmenuSel     = { fg = palette.fg, bg = palette.gray2, bold = true },
        PmenuKind    = { fg = palette.light_blue, bg = palette.gray1 },
        PmenuKindSel = { fg = palette.light_blue, bg = palette.gray2, bold = true },
        PmenuExtra   = { fg = palette.gray3, bg = palette.gray1 },
        PmenuExtraSel= { fg = palette.fg, bg = palette.gray2 },
        PmenuMatch   = { fg = palette.orange, bg = palette.gray1, bold = true },
        PmenuMatchSel= { fg = palette.orange, bg = palette.gray2, bold = true },
        PmenuSbar    = { bg = palette.gray1 },
        PmenuThumb   = { bg = palette.gray3 },

        -- 7. Messages
        ErrorMsg     = { fg = palette.fg, bg = palette.pink },
        WarningMsg   = { fg = palette.pink, bold = true },
        MoreMsg      = { fg = palette.yellow, bold = true },
        ModeMsg      = { fg = palette.yellow, bold = true },
        Question     = { fg = palette.orange, bold = true },

        -- 8. Tabs and NeoTree
        TabLineSel   = { fg = palette.gray2, bg = palette.orange, bold = true },
        TabLine      = { fg = palette.fg, bg = palette.gray1 },
        TabLineFill  = { bg = palette.gray2 },
        NeoTreeDirIcon  = { fg = palette.gray3 },

        -- 9. LSP Diagnostics
        DiagnosticError       = { fg = palette.pink },
        DiagnosticWarn        = { fg = palette.yellow },
        DiagnosticInfo        = { fg = palette.light_blue },
        DiagnosticHint        = { fg = palette.beige },
        DiagnosticOk          = { fg = palette.green },

        DiagnosticSignError   = { fg = palette.pink, bg = palette.bg },
        DiagnosticSignWarn    = { fg = palette.yellow, bg = palette.bg },
        DiagnosticSignInfo    = { fg = palette.light_blue, bg = palette.bg },
        DiagnosticSignHint    = { fg = palette.beige, bg = palette.bg },
        DiagnosticSignOk      = { fg = palette.green, bg = palette.bg },

        DiagnosticUnderlineError = { undercurl = true, sp = palette.pink },
        DiagnosticUnderlineWarn  = { undercurl = true, sp = palette.yellow },
        DiagnosticUnderlineInfo  = { undercurl = true, sp = palette.light_blue },
        DiagnosticUnderlineHint  = { undercurl = true, sp = palette.beige },
        DiagnosticUnderlineOk    = { undercurl = true, sp = palette.green },

        -- Virtual text adjustments with subtle background tints
        DiagnosticVirtualTextError = { fg = palette.pink, bg = palette.tint_pink },
        DiagnosticVirtualTextWarn  = { fg = palette.yellow, bg = palette.tint_yellow },
        DiagnosticVirtualTextInfo  = { fg = palette.light_blue, bg = palette.tint_blue },
        DiagnosticVirtualTextHint  = { fg = palette.beige, bg = palette.tint_beige },
        DiagnosticVirtualTextOk    = { fg = palette.green, bg = palette.tint_green },

        -- 10. Diffs and Git
        DiffAdd      = { fg = palette.green, bg = palette.tint_green },
        DiffChange   = { fg = palette.light_blue, bg = palette.tint_blue },
        DiffDelete   = { fg = palette.pink, bg = palette.tint_pink },
        DiffText     = { fg = palette.fg, bg = palette.diff_text, bold = true },
        Added        = { fg = palette.green },
        Changed      = { fg = palette.yellow },
        Removed      = { fg = palette.pink },
        GitSignsAdd          = { fg = palette.green, bg = palette.bg },
        GitSignsChange       = { fg = palette.yellow, bg = palette.bg },
        GitSignsDelete       = { fg = palette.pink, bg = palette.bg },
        GitSignsAddInline    = { bg = palette.tint_green },
        GitSignsChangeInline = { bg = palette.diff_text },
        GitSignsDeleteInline = { bg = palette.tint_pink },

        -- 11. Spelling
        SpellBad     = { undercurl = true, sp = palette.pink },
        SpellCap     = { undercurl = true, sp = palette.yellow },
        SpellRare    = { undercurl = true, sp = palette.purple },
        SpellLocal   = { undercurl = true, sp = palette.light_blue },

        -- 12. Indentation Guides
        IblIndent = { fg = palette.gray2 }, -- For indent-blankline
        IblScope  = { fg = palette.gray3 },
        MiniIndentscopeSymbol = { fg = palette.gray2 }, -- For mini.indentscope

        -- 13. Floating Windows (Lazy, Mason, Hover Docs)
        NormalFloat  = { fg = palette.fg, bg = palette.gray1 },
        FloatBorder  = { fg = palette.gray3, bg = palette.gray1 },
        FloatTitle   = { fg = palette.orange, bg = palette.gray1, bold = true },

        -- 14. NeoTree UI
        -- Base & Windowing
        NeoTreeNormal             = { fg = palette.gray3, bg = palette.bg },
        NeoTreeNormalNC           = { fg = palette.gray3, bg = palette.bg },
        NeoTreeSignColumn         = { fg = palette.gray3, bg = palette.bg },
        NeoTreeWinSeparator       = { fg = palette.gray1, bg = palette.bg },
        NeoTreeEndOfBuffer        = { fg = palette.bg, bg = palette.bg },
        NeoTreeCursorLine         = { bg = palette.gray1 },
        -- Structural Elements
        NeoTreeRootName           = { fg = palette.pink, bold = true },
        NeoTreeDirectoryName      = { fg = palette.fg },
        NeoTreeDirectoryIcon      = { fg = palette.light_blue },
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

        -- Lazy.nvim Specifics (Lazy sometimes overrides standard floats)
        LazyNormal   = { fg = palette.fg, bg = palette.gray1 },
        LazyBorder   = { fg = palette.gray3, bg = palette.gray1 },

        -- Mason Specifics
        MasonNormal  = { link = "NormalFloat" },
        MasonHeader  = { fg = palette.bg, bg = palette.pink, bold = true },
    }

    for group, settings in pairs(groups) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end

return M
