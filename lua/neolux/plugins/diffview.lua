local M = {}

function M.get(palette, opts)
    local transparent = opts and opts.transparent
    local bg = transparent and "NONE" or palette.bg

    return {
        DiffviewNormal = { fg = palette.fg, bg = bg },
        DiffviewWinSeparator = { fg = palette.gray2, bg = bg },
        DiffviewEndOfBuffer = { fg = palette.bg, bg = bg },
        DiffviewCursorLine = { bg = palette.gray2 },
        DiffviewDim1 = { fg = palette.gray3 },
        DiffviewPrimary = { fg = palette.orange },
        DiffviewSecondary = { fg = palette.green },
        DiffviewNonText = { fg = palette.gray2 },
        DiffviewFolderName = { fg = palette.light_blue },
        DiffviewFolderSign = { fg = palette.light_blue },

        DiffviewFilePanelTitle = { fg = palette.orange, bold = true },
        DiffviewFilePanelCounter = { fg = palette.purple, bold = true },
        DiffviewFilePanelFileName = { fg = palette.fg },
        DiffviewFilePanelSelected = { fg = palette.orange, bold = true },
        DiffviewFilePanelPath = { fg = palette.gray3 },
        DiffviewFilePanelRootPath = { fg = palette.light_blue, bold = true },
        DiffviewFilePanelInsertions = { fg = palette.green },
        DiffviewFilePanelDeletions = { fg = palette.pink },
        DiffviewFilePanelConflicts = { fg = palette.yellow },

        DiffviewStatusAdded = { fg = palette.green },
        DiffviewStatusUntracked = { fg = palette.green },
        DiffviewStatusModified = { fg = palette.yellow },
        DiffviewStatusRenamed = { fg = palette.light_blue },
        DiffviewStatusCopied = { fg = palette.light_blue },
        DiffviewStatusTypeChange = { fg = palette.yellow },
        DiffviewStatusUnmerged = { fg = palette.orange },
        DiffviewStatusUnknown = { fg = palette.purple },
        DiffviewStatusDeleted = { fg = palette.pink },
        DiffviewStatusBroken = { fg = palette.pink },
        DiffviewStatusIgnored = { fg = palette.gray3 },

        DiffviewDiffAdd = { bg = palette.tint_green },
        DiffviewDiffDelete = { fg = palette.gray3, bg = palette.tint_pink },
        DiffviewDiffDeleteDim = { fg = palette.gray2 },
        DiffviewDiffAddAsDelete = { bg = palette.tint_pink },
    }
end

return M
