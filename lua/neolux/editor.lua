local M = {}

function M.get(palette, opts)
    palette = palette or require("neolux.palette")
    opts = opts or require("neolux.config").options
    local bgs = require("neolux.config").resolve_bgs(palette, opts)
    local bg = bgs.bg

    return {
        -- 1. Base Editor UI
        Normal = { fg = palette.fg, bg = bg },
        NormalNC = { fg = palette.fg, bg = bg },
        NonText = { fg = palette.gray3 },
        Conceal = { fg = palette.gray3 },
        Whitespace = { fg = palette.gray2 },
        SpecialKey = { fg = palette.gray3 },
        ColorColumn = { bg = palette.gray2 },
        EndOfBuffer = { fg = opts.transparent and palette.gray2 or palette.bg, bg = bg },
        Directory = { fg = palette.light_blue, bold = true },
        Title = { fg = palette.light_blue, bold = true },

        -- 2. Visual Selection
        Visual = { reverse = true },
        VisualNOS = { link = "Visual" },

        -- 3. Cursor & Lines
        Cursor = { fg = palette.bg, bg = palette.orange },
        lCursor = { link = "Cursor" },
        CursorIM = { link = "Cursor" },
        TermCursor = { fg = palette.bg, bg = palette.orange },
        TermCursorNC = { fg = palette.bg, bg = palette.gray3 },
        SnippetTabstop = { bg = palette.gray2 },
        CursorLine = { bg = palette.gray1 },
        CursorColumn = { link = "CursorLine" },
        LineNr = { fg = palette.gray2 },
        CursorLineNr = { fg = palette.yellow, bg = bg, bold = true },
        MatchParen = { fg = palette.orange, bg = palette.gray2, bold = true },
        FieryYank = { fg = palette.fg, bg = palette.orange, bold = true },
        IlluminatedWordText = { reverse = true },
        IlluminatedWordRead = { reverse = true },
        IlluminatedWordWrite = { reverse = true },
        LspReferenceText = { reverse = true },
        LspReferenceRead = { reverse = true },
        LspReferenceWrite = { reverse = true },
        LspInlayHint = { fg = palette.gray3, bg = palette.gray1 },
        LspSignatureActiveParameter = { fg = palette.orange, bold = true, underline = true },

        -- 4. Window Splits, Gutter & Status Lines
        SignColumn = { fg = palette.gray3, bg = bg },
        FoldColumn = { fg = palette.gray2, bg = bg },
        Folded = { fg = palette.gray3, bg = palette.gray1 },
        VertSplit = { fg = palette.gray3, bg = bg },
        WinSeparator = { fg = palette.gray3, bg = bg },
        StatusLine = { fg = palette.fg, bg = opts.transparent and "NONE" or palette.gray1 },
        StatusLineNC = { fg = palette.gray3, bg = bg },
        WinBar = { fg = palette.fg, bg = bg },
        WinBarNC = { fg = palette.gray3, bg = bg },

        -- 5. Searching
        Search = { fg = palette.bg, bg = palette.yellow },
        IncSearch = { fg = palette.bg, bg = palette.orange, underline = true },
        CurSearch = { link = "IncSearch" },
        Substitute = { fg = palette.bg, bg = palette.pink, bold = true },
        QuickFixLine = { bg = palette.gray2, bold = true },

        -- 6. Pmenu (Popups like autocompletion)
        Pmenu = { fg = palette.fg, bg = bgs.float },
        PmenuSel = { fg = palette.fg, bg = palette.gray2, bold = true },
        WildMenu = { link = "PmenuSel" },
        PmenuKind = { fg = palette.light_blue, bg = bgs.float },
        PmenuKindSel = { fg = palette.light_blue, bg = palette.gray2, bold = true },
        PmenuExtra = { fg = palette.gray3, bg = bgs.float },
        PmenuExtraSel = { fg = palette.fg, bg = palette.gray2 },
        PmenuMatch = { fg = palette.green, bg = bgs.float, bold = true },
        PmenuMatchSel = { fg = palette.green, bg = palette.gray2, bold = true },
        PmenuSbar = { bg = bgs.float },
        PmenuThumb = { bg = palette.gray3 },

        -- 7. Messages
        MsgArea = { fg = palette.fg, bg = bg },
        MsgSeparator = { fg = palette.gray3, bg = bg },
        ErrorMsg = { fg = palette.fg, bg = palette.pink },
        WarningMsg = { fg = palette.pink, bold = true },
        MoreMsg = { fg = palette.yellow, bold = true },
        ModeMsg = { fg = palette.yellow, bold = true },
        Question = { fg = palette.orange, bold = true },

        -- 8. Tabs
        TabLineSel = { fg = palette.bg, bg = palette.orange, bold = true },
        TabLine = { fg = palette.fg, bg = palette.gray1 },
        TabLineFill = { bg = palette.gray1 },

        -- 9. LSP Diagnostics
        DiagnosticError = { fg = palette.pink },
        DiagnosticWarn = { fg = palette.yellow },
        DiagnosticInfo = { fg = palette.light_blue },
        DiagnosticHint = { fg = palette.beige },
        DiagnosticOk = { fg = palette.green },
        DiagnosticDeprecated = { fg = palette.gray3, strikethrough = true },
        DiagnosticUnnecessary = { fg = palette.gray3 },

        DiagnosticSignError = { fg = palette.pink, bg = bg },
        DiagnosticSignWarn = { fg = palette.yellow, bg = bg },
        DiagnosticSignInfo = { fg = palette.light_blue, bg = bg },
        DiagnosticSignHint = { fg = palette.beige, bg = bg },
        DiagnosticSignOk = { fg = palette.green, bg = bg },

        DiagnosticUnderlineError = { undercurl = true, sp = palette.pink },
        DiagnosticUnderlineWarn = { undercurl = true, sp = palette.yellow },
        DiagnosticUnderlineInfo = { undercurl = true, sp = palette.light_blue },
        DiagnosticUnderlineHint = { undercurl = true, sp = palette.beige },
        DiagnosticUnderlineOk = { undercurl = true, sp = palette.green },

        -- Virtual text adjustments with subtle background tints
        DiagnosticVirtualTextError = { fg = palette.pink, bg = palette.tint_pink },
        DiagnosticVirtualTextWarn = { fg = palette.yellow, bg = palette.tint_yellow },
        DiagnosticVirtualTextInfo = { fg = palette.light_blue, bg = palette.tint_blue },
        DiagnosticVirtualTextHint = { fg = palette.beige, bg = palette.tint_beige },
        DiagnosticVirtualTextOk = { fg = palette.green, bg = palette.tint_green },

        -- 10. Diffs
        DiffAdd = { fg = palette.green, bg = palette.tint_green },
        DiffChange = { fg = palette.light_blue, bg = palette.tint_blue },
        DiffDelete = { fg = palette.pink, bg = palette.tint_pink },
        DiffText = { fg = palette.fg, bg = palette.diff_text, bold = true },
        Added = { fg = palette.green },
        Changed = { fg = palette.yellow },
        Removed = { fg = palette.pink },

        -- 11. Spelling
        SpellBad = { undercurl = true, sp = palette.pink },
        SpellCap = { undercurl = true, sp = palette.yellow },
        SpellRare = { undercurl = true, sp = palette.purple },
        SpellLocal = { undercurl = true, sp = palette.light_blue },

        -- 12. Floating Windows
        NormalFloat = { fg = palette.fg, bg = bgs.float },
        FloatBorder = { fg = palette.gray3, bg = bgs.float },
        FloatTitle = { fg = palette.orange, bg = bgs.float, bold = true },
        FloatFooter = { fg = palette.gray3, bg = bgs.float },
    }
end

return M
