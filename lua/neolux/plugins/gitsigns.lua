local M = {}

function M.get(palette, opts)
    local bg = (opts and opts.transparent) and "NONE" or palette.bg

    return {
        GitSignsAdd = { fg = palette.green, bg = bg },
        GitSignsChange = { fg = palette.yellow, bg = bg },
        GitSignsDelete = { fg = palette.pink, bg = bg },
        GitSignsAddNr = { fg = palette.green, bg = bg },
        GitSignsChangeNr = { fg = palette.yellow, bg = bg },
        GitSignsDeleteNr = { fg = palette.pink, bg = bg },
        GitSignsAddLn = { bg = palette.tint_green },
        GitSignsChangeLn = { bg = palette.tint_blue },
        GitSignsDeleteLn = { bg = palette.tint_pink },
        GitSignsAddInline = { bg = palette.tint_green },
        GitSignsChangeInline = { bg = palette.diff_text },
        GitSignsDeleteInline = { bg = palette.tint_pink },
        GitSignsAddPreview = { fg = palette.green, bg = palette.tint_green },
        GitSignsDeletePreview = { fg = palette.pink, bg = palette.tint_pink },
        GitSignsCurrentLineBlame = { fg = palette.gray3, italic = true },
    }
end

return M
