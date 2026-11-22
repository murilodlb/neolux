local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)

    return {
        FzfLuaNormal = { fg = palette.fg, bg = bgs.float },
        FzfLuaBorder = { fg = palette.gray3, bg = bgs.float },
        FzfLuaTitle = { fg = palette.bg, bg = palette.orange, bold = true },
        FzfLuaBackdrop = { bg = palette.bg },

        FzfLuaPreviewNormal = { fg = palette.fg, bg = bgs.float },
        FzfLuaPreviewBorder = { fg = palette.gray3, bg = bgs.float },
        FzfLuaPreviewTitle = { fg = palette.bg, bg = palette.green, bold = true },

        FzfLuaCursorLine = { bg = palette.gray2 },
        FzfLuaSearch = { fg = palette.bg, bg = palette.yellow, bold = true },

        FzfLuaHeaderBind = { fg = palette.orange, bold = true },
        FzfLuaHeaderText = { fg = palette.light_blue },
        FzfLuaPathColNr = { fg = palette.light_blue },
        FzfLuaPathLineNr = { fg = palette.green },
        FzfLuaBufName = { fg = palette.fg },
        FzfLuaBufNr = { fg = palette.beige },
        FzfLuaBufFlagCur = { fg = palette.orange, bold = true },
        FzfLuaBufFlagAlt = { fg = palette.light_blue },
        FzfLuaTabTitle = { fg = palette.light_blue, bold = true },
        FzfLuaTabMarker = { fg = palette.orange, bold = true },
        FzfLuaLivePrompt = { fg = palette.orange },
        FzfLuaLiveSym = { fg = palette.orange, bold = true },

        FzfLuaFzfMatch = { fg = palette.green, bold = true },
        FzfLuaFzfPointer = { fg = palette.pink, bold = true },
        FzfLuaFzfMarker = { fg = palette.purple, bold = true },
        FzfLuaFzfPrompt = { fg = palette.orange, bold = true },
        FzfLuaFzfInfo = { fg = palette.gray3 },
        FzfLuaFzfHeader = { fg = palette.gray3 },
        FzfLuaFzfBorder = { fg = palette.gray3, bg = bgs.float },
    }
end

return M
