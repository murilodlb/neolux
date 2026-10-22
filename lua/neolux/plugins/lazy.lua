local M = {}

function M.get(palette)
    return {
        LazyNormal = { fg = palette.fg, bg = palette.gray1 },
        LazyBorder = { fg = palette.gray3, bg = palette.gray1 },
        LazyButton = { fg = palette.fg, bg = palette.gray2 },
        LazyButtonActive = { fg = palette.bg, bg = palette.orange, bold = true },
        LazyH1 = { fg = palette.bg, bg = palette.orange, bold = true },
        LazyH2 = { fg = palette.light_blue, bold = true },
        LazySpecial = { fg = palette.light_blue },
        LazyProgressDone = { fg = palette.green, bold = true },
        LazyProgressTodo = { fg = palette.gray2, bold = true },
        LazyReasonPlugin = { fg = palette.light_blue },
        LazyReasonEvent = { fg = palette.yellow },
        LazyReasonStart = { fg = palette.green },
        LazyReasonCmd = { fg = palette.orange },
        LazyReasonFt = { fg = palette.purple },
        LazyReasonKeys = { fg = palette.pink },
    }
end

return M
