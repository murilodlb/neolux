local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)

    return {
        BlinkCmpMenu = { fg = palette.fg, bg = bgs.float },
        BlinkCmpMenuBorder = { fg = palette.gray3, bg = bgs.float },
        BlinkCmpMenuSelection = { fg = palette.fg, bg = palette.gray2, bold = true },
        BlinkCmpScrollBarThumb = { bg = palette.gray3 },
        BlinkCmpScrollBarGutter = { bg = bgs.float },
        BlinkCmpLabel = { fg = palette.fg },
        BlinkCmpLabelDeprecated = { fg = palette.gray3, strikethrough = true },
        BlinkCmpLabelMatch = { fg = palette.green, bold = true },
        BlinkCmpLabelDetail = { fg = palette.gray3 },
        BlinkCmpLabelDescription = { fg = palette.gray3 },
        BlinkCmpDoc = { fg = palette.fg, bg = bgs.float },
        BlinkCmpDocBorder = { fg = palette.gray3, bg = bgs.float },
        BlinkCmpDocSeparator = { fg = palette.gray2, bg = bgs.float },
        BlinkCmpSignatureHelp = { fg = palette.fg, bg = bgs.float },
        BlinkCmpSignatureHelpBorder = { fg = palette.gray3, bg = bgs.float },
        BlinkCmpGhostText = { fg = palette.gray3, italic = true },

        BlinkCmpKindDefault = { fg = palette.light_blue },
        BlinkCmpKindFunction = { fg = palette.green },
        BlinkCmpKindMethod = { fg = palette.green },
        BlinkCmpKindConstructor = { fg = palette.light_blue },
        BlinkCmpKindClass = { fg = palette.light_blue },
        BlinkCmpKindInterface = { fg = palette.light_blue },
        BlinkCmpKindStruct = { fg = palette.light_blue },
        BlinkCmpKindModule = { fg = palette.purple },
        BlinkCmpKindProperty = { fg = palette.light_blue },
        BlinkCmpKindField = { fg = palette.light_blue },
        BlinkCmpKindVariable = { fg = palette.fg },
        BlinkCmpKindConstant = { fg = palette.purple },
        BlinkCmpKindEnum = { fg = palette.light_blue },
        BlinkCmpKindEnumMember = { fg = palette.purple },
        BlinkCmpKindKeyword = { fg = palette.pink },
        BlinkCmpKindOperator = { fg = palette.pink },
        BlinkCmpKindSnippet = { fg = palette.orange },
        BlinkCmpKindText = { fg = palette.beige },
        BlinkCmpKindFile = { fg = palette.fg },
        BlinkCmpKindFolder = { fg = palette.light_blue },
        BlinkCmpKindColor = { fg = palette.pink },
        BlinkCmpKindReference = { fg = palette.orange },
        BlinkCmpKindValue = { fg = palette.purple },
        BlinkCmpKindEvent = { fg = palette.yellow },
        BlinkCmpKindTypeParameter = { fg = palette.orange },
        BlinkCmpKindUnit = { fg = palette.purple },
    }
end

return M
