local M = {}

M.terminal_colors = {
    "bg", -- 0: Black
    "pink", -- 1: Red
    "green", -- 2: Green
    "yellow", -- 3: Yellow
    "blue", -- 4: Blue
    "purple", -- 5: Magenta
    "light_blue", -- 6: Cyan
    "fg", -- 7: White
    "gray3", -- 8: Bright Black (Dark Gray)
    "pink", -- 9: Bright Red
    "green", -- 10: Bright Green
    "yellow", -- 11: Bright Yellow
    "light_blue", -- 12: Bright Blue
    "purple", -- 13: Bright Magenta
    "light_blue", -- 14: Bright Cyan
    "fg", -- 15: Bright White
}

M.plugin_map = {
    ["neo-tree.nvim"] = "neo-tree",
    ["lazy.nvim"] = "lazy",
    ["mason.nvim"] = "mason",
    ["telescope.nvim"] = "telescope",
    ["nvim-cmp"] = "cmp",
    ["blink.cmp"] = "blink",
    ["gitsigns.nvim"] = "gitsigns",
    ["indent-blankline.nvim"] = "indent-blankline",
    ["mini.indentscope"] = "indent-blankline",
    ["mini.nvim"] = "indent-blankline",
    ["bufferline.nvim"] = "bufferline",
    ["rainbow-delimiters.nvim"] = "rainbow-delimiters",
}

M.plugin_repos = {
    "blink.cmp",
    "bufferline.nvim",
    "gitsigns.nvim",
    "indent-blankline.nvim",
    "lazy.nvim",
    "mason.nvim",
    "mini.indentscope",
    "mini.nvim",
    "neo-tree.nvim",
    "nvim-cmp",
    "rainbow-delimiters.nvim",
    "telescope.nvim",
}

M.plugin_modules = {
    "neo-tree",
    "lazy",
    "mason",
    "telescope",
    "cmp",
    "blink",
    "gitsigns",
    "indent-blankline",
    "bufferline",
    "rainbow-delimiters",
}

M.defaults = {
    cache = true,
    transparent = false,
    italic_comments = true,
    styles = {
        comments = { italic = true },
        keywords = { bold = true },
        functions = {},
        variables = {},
    },
    on_colors = function(colors) end,
    on_highlights = function(highlights, colors) end,
    plugins = {
        auto = true,
    },
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
    if opts and opts.italic_comments ~= nil then
        M.options.styles.comments.italic = opts.italic_comments
    end
end

return M
