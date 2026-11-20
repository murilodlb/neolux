local M = {}

function M.get(palette)
    local hl = {
        NoiceCmdline = { fg = palette.fg, bg = palette.gray1 },
        NoiceCmdlinePopup = { fg = palette.fg, bg = palette.gray1 },
        NoiceCmdlinePopupBorder = { fg = palette.orange, bg = palette.gray1 },
        NoiceCmdlinePopupTitle = { fg = palette.orange, bg = palette.gray1, bold = true },
        NoiceCmdlineIcon = { fg = palette.orange, bg = palette.gray1 },

        NoiceConfirm = { fg = palette.fg, bg = palette.gray1 },
        NoiceConfirmBorder = { fg = palette.orange, bg = palette.gray1 },
        NoicePopup = { fg = palette.fg, bg = palette.gray1 },
        NoicePopupBorder = { fg = palette.gray3, bg = palette.gray1 },
        NoicePopupmenu = { fg = palette.fg, bg = palette.gray1 },
        NoicePopupmenuSelected = { bg = palette.gray2, bold = true },
        NoicePopupmenuBorder = { fg = palette.gray3, bg = palette.gray1 },
        NoicePopupmenuMatch = { fg = palette.green, bold = true },
        NoiceMini = { fg = palette.fg, bg = palette.gray1 },

        NoiceLspProgressTitle = { fg = palette.fg },
        NoiceLspProgressClient = { fg = palette.light_blue, bold = true },
        NoiceLspProgressSpinner = { fg = palette.orange },
        NoiceFormatProgressDone = { fg = palette.bg, bg = palette.green, bold = true },
        NoiceFormatProgressTodo = { fg = palette.fg, bg = palette.gray2 },
        NoiceVirtualText = { fg = palette.light_blue, bg = palette.tint_blue },
    }

    local cmdline_modes = {
        Search = palette.yellow,
        Lua = palette.light_blue,
        Filter = palette.purple,
        Help = palette.green,
    }
    for mode, color in pairs(cmdline_modes) do
        hl["NoiceCmdlinePopupBorder" .. mode] = { fg = color, bg = palette.gray1 }
        hl["NoiceCmdlinePopupTitle" .. mode] = { fg = color, bg = palette.gray1, bold = true }
        hl["NoiceCmdlineIcon" .. mode] = { fg = color, bg = palette.gray1 }
    end

    return hl
end

return M
