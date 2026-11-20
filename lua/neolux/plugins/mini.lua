local M = {}

function M.get(palette, opts)
    local transparent = opts and opts.transparent
    local bg = transparent and "NONE" or palette.bg

    local hl = {
        -- mini.indentscope
        MiniIndentscopeSymbol = { fg = palette.gray2 },
        MiniIndentscopePrefix = { nocombine = true },

        -- mini.files
        MiniFilesNormal = { fg = palette.fg, bg = palette.gray1 },
        MiniFilesBorder = { fg = palette.gray3, bg = palette.gray1 },
        MiniFilesBorderModified = { fg = palette.yellow, bg = palette.gray1 },
        MiniFilesCursorLine = { bg = palette.gray2 },
        MiniFilesDirectory = { fg = palette.light_blue },
        MiniFilesFile = { fg = palette.fg },
        MiniFilesTitle = { fg = palette.gray3, bg = palette.gray1 },
        MiniFilesTitleFocused = { fg = palette.orange, bg = palette.gray1, bold = true },

        -- mini.pick
        MiniPickNormal = { fg = palette.fg, bg = palette.gray1 },
        MiniPickBorder = { fg = palette.gray3, bg = palette.gray1 },
        MiniPickBorderBusy = { fg = palette.orange, bg = palette.gray1 },
        MiniPickBorderText = { fg = palette.light_blue, bg = palette.gray1, bold = true },
        MiniPickHeader = { fg = palette.light_blue, bold = true },
        MiniPickMatchCurrent = { bg = palette.gray2, bold = true },
        MiniPickMatchMarked = { fg = palette.purple, bg = palette.gray2 },
        MiniPickMatchRanges = { fg = palette.green, bold = true },
        MiniPickPreviewLine = { bg = palette.gray2 },
        MiniPickPreviewRegion = { bg = palette.tint_blue },
        MiniPickPrompt = { fg = palette.orange, bg = palette.gray1, bold = true },

        -- mini.diff
        MiniDiffSignAdd = { fg = palette.green, bg = bg },
        MiniDiffSignChange = { fg = palette.yellow, bg = bg },
        MiniDiffSignDelete = { fg = palette.pink, bg = bg },
        MiniDiffOverAdd = { bg = palette.tint_green },
        MiniDiffOverChange = { bg = palette.tint_yellow },
        MiniDiffOverContext = { bg = palette.gray1 },
        MiniDiffOverDelete = { bg = palette.tint_pink },

        -- mini.statusline
        MiniStatuslineModeNormal = { fg = palette.dark_blue, bg = palette.light_blue, bold = true },
        MiniStatuslineModeInsert = { fg = palette.dark_blue, bg = palette.green, bold = true },
        MiniStatuslineModeVisual = { fg = palette.dark_blue, bg = palette.orange, bold = true },
        MiniStatuslineModeReplace = { fg = palette.dark_blue, bg = palette.pink, bold = true },
        MiniStatuslineModeCommand = { fg = palette.dark_blue, bg = palette.yellow, bold = true },
        MiniStatuslineModeOther = { fg = palette.dark_blue, bg = palette.blue, bold = true },
        MiniStatuslineDevinfo = { fg = palette.fg, bg = palette.gray2 },
        MiniStatuslineFileinfo = { fg = palette.fg, bg = palette.gray2 },
        MiniStatuslineFilename = { fg = palette.fg, bg = palette.gray1 },
        MiniStatuslineInactive = { fg = palette.beige, bg = palette.gray1 },

        -- mini.tabline
        MiniTablineCurrent = { fg = palette.fg, bg = palette.gray2, bold = true },
        MiniTablineVisible = { fg = palette.beige, bg = palette.gray1 },
        MiniTablineHidden = { fg = palette.gray3, bg = palette.bg },
        MiniTablineModifiedCurrent = { fg = palette.orange, bg = palette.gray2, bold = true },
        MiniTablineModifiedVisible = { fg = palette.orange, bg = palette.gray1 },
        MiniTablineModifiedHidden = { fg = palette.yellow, bg = palette.bg },
        MiniTablineFill = { bg = palette.bg },
        MiniTablineTabpagesection = { fg = palette.bg, bg = palette.light_blue, bold = true },

        -- mini.notify
        MiniNotifyNormal = { fg = palette.fg, bg = palette.gray1 },
        MiniNotifyBorder = { fg = palette.gray3, bg = palette.gray1 },
        MiniNotifyTitle = { fg = palette.orange, bg = palette.gray1, bold = true },

        -- mini.hipatterns
        MiniHipatternsFixme = { fg = palette.bg, bg = palette.pink, bold = true },
        MiniHipatternsHack = { fg = palette.bg, bg = palette.orange, bold = true },
        MiniHipatternsTodo = { fg = palette.bg, bg = palette.light_blue, bold = true },
        MiniHipatternsNote = { fg = palette.bg, bg = palette.beige, bold = true },
    }

    -- mini.icons
    local icon_colors = {
        Azure = palette.light_blue,
        Blue = palette.blue,
        Cyan = palette.light_blue,
        Green = palette.green,
        Grey = palette.gray3,
        Orange = palette.orange,
        Purple = palette.purple,
        Red = palette.pink,
        Yellow = palette.yellow,
    }
    for name, color in pairs(icon_colors) do
        hl["MiniIcons" .. name] = { fg = color }
    end

    return hl
end

return M
