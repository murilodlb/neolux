local M = {}

M.terminal_colors = {
    "gray1", -- 0: Black (#0c0c0c)
    "red", -- 1: Red (#c5003c)
    "green", -- 2: Green (#2fff73)
    "yellow", -- 3: Yellow (#ffcc00)
    "dark_blue", -- 4: Blue (#044b8b)
    "purple", -- 5: Magenta (#9c6de7)
    "light_blue", -- 6: Cyan (#55efef)
    "fg", -- 7: White (#ffffff)
    "gray2", -- 8: Bright Black (#3c3c3a)
    "pink", -- 9: Bright Red (#f84285)
    "bright_green", -- 10: Bright Green (#5cd85a)
    "bright_yellow", -- 11: Bright Yellow (#f3e600)
    "blue", -- 12: Bright Blue (#2495ff)
    "bright_purple", -- 13: Bright Magenta (#8b53fe)
    "bright_cyan", -- 14: Bright Cyan (#88dddd)
    "bright_white", -- 15: Bright White (#f5f1e8)
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
    ["bufferline.nvim"] = "bufferline",
    ["rainbow-delimiters.nvim"] = "rainbow-delimiters",
    ["snacks.nvim"] = "snacks",
    ["which-key.nvim"] = "which-key",
    ["noice.nvim"] = "noice",
    ["flash.nvim"] = "flash",
    ["trouble.nvim"] = "trouble",
    ["render-markdown.nvim"] = "render-markdown",
    ["fzf-lua"] = "fzf-lua",
    ["todo-comments.nvim"] = "todo-comments",
    ["nvim-tree.lua"] = "nvim-tree",
    ["mini.nvim"] = "mini",
    ["mini.indentscope"] = "mini",
    ["mini.files"] = "mini",
    ["mini.pick"] = "mini",
    ["mini.diff"] = "mini",
    ["mini.icons"] = "mini",
    ["mini.statusline"] = "mini",
    ["mini.tabline"] = "mini",
    ["mini.notify"] = "mini",
    ["mini.hipatterns"] = "mini",
    ["diffview.nvim"] = "diffview",
    ["nvim-notify"] = "notify",
}

M.plugin_repos = {}
M.plugin_modules = {}
do
    local seen_modules = {}
    for repo, mod in pairs(M.plugin_map) do
        M.plugin_repos[#M.plugin_repos + 1] = repo
        if not seen_modules[mod] then
            seen_modules[mod] = true
            M.plugin_modules[#M.plugin_modules + 1] = mod
        end
    end
    table.sort(M.plugin_repos)
    table.sort(M.plugin_modules)
end

M.defaults = {
    cache = true,
    transparent = false,
    italic_comments = true,
    styles = {
        comments = { italic = true },
        keywords = { bold = true },
        functions = {},
        variables = {},
        floats = "dark", -- "dark" | "transparent" | "normal"
        sidebars = "normal", -- "dark" | "transparent" | "normal"
    },
    on_colors = function(colors) end,
    on_highlights = function(highlights, colors) end,
    plugins = {
        auto = true,
    },
}

M.options = vim.deepcopy(M.defaults)

function M.resolve_bgs(palette, opts)
    opts = opts or M.options
    local styles = opts.styles or {}
    local normal_bg = opts.transparent and "NONE" or palette.bg

    local float_bg
    if styles.floats == "transparent" then
        float_bg = "NONE"
    elseif styles.floats == "normal" then
        float_bg = normal_bg
    else
        float_bg = palette.gray1
    end

    local sidebar_bg
    if styles.sidebars == "transparent" then
        sidebar_bg = "NONE"
    elseif styles.sidebars == "dark" then
        sidebar_bg = palette.gray1
    else
        sidebar_bg = normal_bg
    end

    return {
        bg = normal_bg,
        float = float_bg,
        sidebar = sidebar_bg,
    }
end

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
    if opts and opts.italic_comments ~= nil then
        M.options.styles.comments.italic = opts.italic_comments
    end
end

return M
