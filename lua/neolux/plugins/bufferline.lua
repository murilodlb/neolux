local M = {}

function M.get(palette)
    return {
        BufferLineFill                    = { bg = palette.bg },
        BufferLineBackground              = { fg = palette.gray3, bg = palette.gray1 },
        BufferLineBufferVisible           = { fg = palette.fg, bg = palette.gray1 },
        BufferLineBufferSelected          = { fg = palette.fg, bg = palette.bg, bold = true, italic = false },
        BufferLineTab                     = { fg = palette.gray3, bg = palette.gray1 },
        BufferLineTabSelected             = { fg = palette.bg, bg = palette.orange, bold = true },
        BufferLineTabClose                = { fg = palette.pink, bg = palette.gray1 },
        BufferLineTabSeparator            = { fg = palette.bg, bg = palette.gray1 },
        BufferLineTabSeparatorSelected    = { fg = palette.bg, bg = palette.orange },
        BufferLineSeparator               = { fg = palette.bg, bg = palette.gray1 },
        BufferLineSeparatorVisible        = { fg = palette.bg, bg = palette.gray1 },
        BufferLineSeparatorSelected       = { fg = palette.bg, bg = palette.bg },
        BufferLineIndicatorSelected       = { fg = palette.orange, bg = palette.bg },
        BufferLineIndicatorVisible        = { fg = palette.gray2, bg = palette.gray1 },
        BufferLineCloseButton             = { fg = palette.gray3, bg = palette.gray1 },
        BufferLineCloseButtonVisible      = { fg = palette.fg, bg = palette.gray1 },
        BufferLineCloseButtonSelected     = { fg = palette.pink, bg = palette.bg },
        BufferLineModified                = { fg = palette.yellow, bg = palette.gray1 },
        BufferLineModifiedVisible         = { fg = palette.yellow, bg = palette.gray1 },
        BufferLineModifiedSelected        = { fg = palette.yellow, bg = palette.bg },
        BufferLineDuplicate               = { fg = palette.gray3, bg = palette.gray1, italic = true },
        BufferLineDuplicateVisible        = { fg = palette.gray3, bg = palette.gray1, italic = true },
        BufferLineDuplicateSelected       = { fg = palette.fg, bg = palette.bg, italic = true },
        BufferLineError                   = { fg = palette.pink, bg = palette.gray1 },
        BufferLineErrorSelected           = { fg = palette.pink, bg = palette.bg, bold = true },
        BufferLineWarning                 = { fg = palette.yellow, bg = palette.gray1 },
        BufferLineWarningSelected         = { fg = palette.yellow, bg = palette.bg, bold = true },
        BufferLineInfo                    = { fg = palette.light_blue, bg = palette.gray1 },
        BufferLineInfoSelected            = { fg = palette.light_blue, bg = palette.bg, bold = true },
        BufferLineHint                    = { fg = palette.beige, bg = palette.gray1 },
        BufferLineHintSelected            = { fg = palette.beige, bg = palette.bg, bold = true },
        BufferLineOffsetSeparator         = { fg = palette.gray3, bg = palette.bg },
    }
end

return M
