local M = {}

function M.get(palette)
    return {
        -- indent-blankline.nvim
        IblIndent = { fg = palette.gray2 },
        IblScope = { fg = palette.gray3 },
        IblWhitespace = { fg = palette.gray2 },

        -- mini.indentscope
        MiniIndentscopeSymbol = { fg = palette.gray2 },
        MiniIndentscopePrefix = { nocombine = true },
    }
end

return M
