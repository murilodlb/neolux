local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)

    local hl = {
        NoiceCmdline = { fg = palette.fg, bg = bgs.float },
        NoiceCmdlinePopup = { fg = palette.fg, bg = bgs.float },
        NoiceCmdlinePopupBorder = { fg = palette.orange, bg = bgs.float },
        NoiceCmdlinePopupTitle = { fg = palette.orange, bg = bgs.float, bold = true },
        NoiceCmdlineIcon = { fg = palette.orange, bg = bgs.float },

        NoiceConfirm = { fg = palette.fg, bg = bgs.float },
        NoiceConfirmBorder = { fg = palette.orange, bg = bgs.float },
        NoicePopup = { fg = palette.fg, bg = bgs.float },
        NoicePopupBorder = { fg = palette.gray3, bg = bgs.float },
        NoicePopupmenu = { fg = palette.fg, bg = bgs.float },
        NoicePopupmenuSelected = { bg = palette.gray2, bold = true },
        NoicePopupmenuBorder = { fg = palette.gray3, bg = bgs.float },
        NoicePopupmenuMatch = { fg = palette.green, bold = true },
        NoiceMini = { fg = palette.fg, bg = bgs.float },

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
        hl["NoiceCmdlinePopupBorder" .. mode] = { fg = color, bg = bgs.float }
        hl["NoiceCmdlinePopupTitle" .. mode] = { fg = color, bg = bgs.float, bold = true }
        hl["NoiceCmdlineIcon" .. mode] = { fg = color, bg = bgs.float }
    end

    return hl
end

return M
