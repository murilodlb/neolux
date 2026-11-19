local M = {}

function M.get(palette)
    return {
        -- indent-blankline.nvim
        IblIndent = { fg = palette.gray2 },
        IblScope = { fg = palette.gray3 },
        IblWhitespace = { fg = palette.gray2 },
    }
end

return M
