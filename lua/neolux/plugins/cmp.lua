local M = {}

function M.get(palette)
    return {
        CmpItemAbbr              = { fg = palette.fg },
        CmpItemAbbrDeprecated    = { fg = palette.gray3, strikethrough = true },
        CmpItemAbbrMatch         = { fg = palette.orange, bold = true },
        CmpItemAbbrMatchFuzzy    = { fg = palette.orange, bold = true },
        CmpItemMenu              = { fg = palette.gray3 },

        CmpItemKindDefault       = { fg = palette.light_blue },
        CmpItemKindFunction      = { fg = palette.green },
        CmpItemKindMethod        = { fg = palette.green },
        CmpItemKindConstructor   = { fg = palette.light_blue },
        CmpItemKindClass         = { fg = palette.light_blue },
        CmpItemKindInterface     = { fg = palette.light_blue },
        CmpItemKindStruct        = { fg = palette.light_blue },
        CmpItemKindModule        = { fg = palette.purple },
        CmpItemKindProperty      = { fg = palette.light_blue },
        CmpItemKindField         = { fg = palette.light_blue },
        CmpItemKindVariable      = { fg = palette.fg },
        CmpItemKindConstant      = { fg = palette.purple },
        CmpItemKindEnum          = { fg = palette.light_blue },
        CmpItemKindEnumMember    = { fg = palette.purple },
        CmpItemKindKeyword       = { fg = palette.pink },
        CmpItemKindOperator      = { fg = palette.pink },
        CmpItemKindSnippet       = { fg = palette.orange },
        CmpItemKindText          = { fg = palette.beige },
        CmpItemKindFile          = { fg = palette.fg },
        CmpItemKindFolder        = { fg = palette.light_blue },
        CmpItemKindColor         = { fg = palette.pink },
        CmpItemKindReference     = { fg = palette.orange },
        CmpItemKindValue         = { fg = palette.purple },
        CmpItemKindEvent         = { fg = palette.yellow },
        CmpItemKindTypeParameter = { fg = palette.orange },
        CmpItemKindUnit          = { fg = palette.purple },
    }
end

return M
