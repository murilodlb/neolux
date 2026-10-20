local M = {}

function M.get(palette, opts)
    palette = palette or require("neolux.palette")
    opts = opts or require("neolux.config").options
    local bg = opts.transparent and "NONE" or palette.bg

    return {
        -- 1. Base Editor UI
        Normal       = { fg = palette.fg, bg = bg },
        NormalNC     = { fg = palette.fg, bg = bg },
        NonText      = { fg = palette.gray3 },
        ColorColumn  = { bg = palette.gray2 },
        EndOfBuffer  = { fg = palette.bg, bg = bg },
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
        CursorLineNr = { fg = palette.yellow, bg = bg, bold = true },
        MatchParen   = { fg = palette.orange, bg = palette.gray2, bold = true },
        FieryYank    = { fg = palette.fg, bg = palette.orange, bold = true },
        IlluminatedWordText  = { reverse = true },
        IlluminatedWordRead  = { reverse = true },
        IlluminatedWordWrite = { reverse = true },
        LspReferenceText     = { reverse = true },
        LspReferenceRead     = { reverse = true },
        LspReferenceWrite    = { reverse = true },

        -- 4. Window Splits, Gutter & Status Lines
        SignColumn   = { fg = palette.gray3, bg = bg },
        FoldColumn   = { fg = palette.gray2, bg = bg },
        Folded       = { fg = palette.gray3, bg = palette.gray1 },
        VertSplit    = { fg = palette.gray3, bg = bg },
        WinSeparator = { fg = palette.gray3, bg = bg },
        StatusLine   = { fg = palette.fg, bg = opts.transparent and "NONE" or palette.gray1 },
        StatusLineNC = { fg = palette.gray3, bg = bg },
        WinBar       = { fg = palette.fg, bg = bg },
        WinBarNC     = { fg = palette.gray3, bg = bg },

        -- 5. Searching
        Search       = { fg = palette.bg, bg = palette.yellow },
        IncSearch    = { fg = palette.bg, bg = palette.orange, underline = true },
        CurSearch    = { link = "IncSearch" },

        -- 6. Pmenu (Popups like autocompletion)
        Pmenu         = { fg = palette.fg, bg = palette.gray1 },
        PmenuSel      = { fg = palette.fg, bg = palette.gray2, bold = true },
        PmenuKind     = { fg = palette.light_blue, bg = palette.gray1 },
        PmenuKindSel  = { fg = palette.light_blue, bg = palette.gray2, bold = true },
        PmenuExtra    = { fg = palette.gray3, bg = palette.gray1 },
        PmenuExtraSel = { fg = palette.fg, bg = palette.gray2 },
        PmenuMatch    = { fg = palette.orange, bg = palette.gray1, bold = true },
        PmenuMatchSel = { fg = palette.orange, bg = palette.gray2, bold = true },
        PmenuSbar     = { bg = palette.gray1 },
        PmenuThumb    = { bg = palette.gray3 },

        -- 7. Messages
        ErrorMsg     = { fg = palette.fg, bg = palette.pink },
        WarningMsg   = { fg = palette.pink, bold = true },
        MoreMsg      = { fg = palette.yellow, bold = true },
        ModeMsg      = { fg = palette.yellow, bold = true },
        Question     = { fg = palette.orange, bold = true },

        -- 8. Tabs
        TabLineSel   = { fg = palette.gray2, bg = palette.orange, bold = true },
        TabLine      = { fg = palette.fg, bg = palette.gray1 },
        TabLineFill  = { bg = palette.gray2 },

        -- 9. LSP Diagnostics
        DiagnosticError       = { fg = palette.pink },
        DiagnosticWarn        = { fg = palette.yellow },
        DiagnosticInfo        = { fg = palette.light_blue },
        DiagnosticHint        = { fg = palette.beige },
        DiagnosticOk          = { fg = palette.green },

        DiagnosticSignError   = { fg = palette.pink, bg = bg },
        DiagnosticSignWarn    = { fg = palette.yellow, bg = bg },
        DiagnosticSignInfo    = { fg = palette.light_blue, bg = bg },
        DiagnosticSignHint    = { fg = palette.beige, bg = bg },
        DiagnosticSignOk      = { fg = palette.green, bg = bg },

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

        -- 10. Diffs
        DiffAdd      = { fg = palette.green, bg = palette.tint_green },
        DiffChange   = { fg = palette.light_blue, bg = palette.tint_blue },
        DiffDelete   = { fg = palette.pink, bg = palette.tint_pink },
        DiffText     = { fg = palette.fg, bg = palette.diff_text, bold = true },
        Added        = { fg = palette.green },
        Changed      = { fg = palette.yellow },
        Removed      = { fg = palette.pink },

        -- 11. Spelling
        SpellBad     = { undercurl = true, sp = palette.pink },
        SpellCap     = { undercurl = true, sp = palette.yellow },
        SpellRare    = { undercurl = true, sp = palette.purple },
        SpellLocal   = { undercurl = true, sp = palette.light_blue },

        -- 12. Floating Windows
        NormalFloat  = { fg = palette.fg, bg = palette.gray1 },
        FloatBorder  = { fg = palette.gray3, bg = palette.gray1 },
        FloatTitle   = { fg = palette.orange, bg = palette.gray1, bold = true },
    }
end

function M.setup(palette, opts)
    local groups = M.get(palette, opts)
    for group, settings in pairs(groups) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end

return M
