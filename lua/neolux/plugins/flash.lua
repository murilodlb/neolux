local M = {}

function M.get(palette)
    return {
        FlashBackdrop = { fg = palette.gray2 },
        FlashLabel = { fg = palette.bg, bg = palette.pink, bold = true },
        FlashMatch = { fg = palette.bg, bg = palette.orange, bold = true },
        FlashCurrent = { fg = palette.bg, bg = palette.green, bold = true },
        FlashPrompt = { link = "NormalFloat" },
        FlashPromptIcon = { fg = palette.orange, bold = true },
        FlashCursor = { link = "Cursor" },
    }
end

return M
