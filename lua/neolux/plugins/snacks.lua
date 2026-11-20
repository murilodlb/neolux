local M = {}

function M.get(palette, opts)
    local transparent = opts and opts.transparent
    local bg = transparent and "NONE" or palette.bg

    local hl = {
        -- Picker
        SnacksPicker = { fg = palette.fg, bg = palette.gray1 },
        SnacksPickerBorder = { fg = palette.gray3, bg = palette.gray1 },
        SnacksPickerTitle = { fg = palette.orange, bg = palette.gray1, bold = true },
        SnacksPickerInput = { fg = palette.fg, bg = palette.gray1 },
        SnacksPickerInputBorder = { fg = palette.orange, bg = palette.gray1 },
        SnacksPickerInputTitle = { fg = palette.orange, bg = palette.gray1, bold = true },
        SnacksPickerPrompt = { fg = palette.orange, bold = true },
        SnacksPickerList = { fg = palette.fg, bg = palette.gray1 },
        SnacksPickerListCursorLine = { bg = palette.gray2 },
        SnacksPickerPreview = { fg = palette.fg, bg = bg },
        SnacksPickerPreviewBorder = { fg = palette.gray3, bg = bg },
        SnacksPickerPreviewTitle = { fg = palette.green, bg = bg, bold = true },
        SnacksPickerMatch = { fg = palette.green, bold = true },
        SnacksPickerSelected = { fg = palette.purple, bold = true },
        SnacksPickerDir = { fg = palette.gray3 },
        SnacksPickerFile = { fg = palette.fg },
        SnacksPickerGitStatusAdded = { fg = palette.green },
        SnacksPickerGitStatusModified = { fg = palette.yellow },
        SnacksPickerGitStatusDeleted = { fg = palette.pink },
        SnacksPickerGitStatusUntracked = { fg = palette.orange },
        SnacksPickerGitStatusRenamed = { fg = palette.light_blue },

        -- Dashboard
        SnacksDashboardNormal = { fg = palette.fg, bg = bg },
        SnacksDashboardHeader = { fg = palette.light_blue, bold = true },
        SnacksDashboardTitle = { fg = palette.orange, bold = true },
        SnacksDashboardDesc = { fg = palette.fg },
        SnacksDashboardKey = { fg = palette.orange, bold = true },
        SnacksDashboardIcon = { fg = palette.light_blue },
        SnacksDashboardDir = { fg = palette.gray3 },
        SnacksDashboardFooter = { fg = palette.beige, italic = true },
        SnacksDashboardSpecial = { fg = palette.pink, bold = true },

        -- Indent
        SnacksIndent = { fg = palette.gray2 },
        SnacksIndentScope = { fg = palette.gray3 },
        SnacksIndentChunk = { fg = palette.gray3 },

        -- Input
        SnacksInputNormal = { fg = palette.fg, bg = palette.gray1 },
        SnacksInputBorder = { fg = palette.orange, bg = palette.gray1 },
        SnacksInputTitle = { fg = palette.orange, bg = palette.gray1, bold = true },
        SnacksInputIcon = { fg = palette.orange, bg = palette.gray1 },
    }

    local notifier_levels = {
        Info = palette.light_blue,
        Warn = palette.yellow,
        Error = palette.pink,
        Debug = palette.gray3,
        Trace = palette.purple,
    }
    for level, color in pairs(notifier_levels) do
        hl["SnacksNotifier" .. level] = { fg = palette.fg, bg = palette.gray1 }
        hl["SnacksNotifierBorder" .. level] = { fg = color, bg = palette.gray1 }
        hl["SnacksNotifierTitle" .. level] = { fg = color, bg = palette.gray1, bold = true }
        hl["SnacksNotifierIcon" .. level] = { fg = color, bg = palette.gray1 }
        hl["SnacksNotifierFooter" .. level] = { fg = palette.gray3, bg = palette.gray1 }
    end

    return hl
end

return M
