local config = require("neolux.config")
local base_palette = require("neolux.palette")

local M = {}

M.colors = vim.deepcopy(base_palette)

function M.setup(opts)
    config.setup(opts)
    local colors = vim.deepcopy(base_palette)
    if type(config.options.on_colors) == "function" then
        config.options.on_colors(colors)
    end
    M.colors = colors
end

function M.load()
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end

    vim.o.background = "dark"
    vim.g.colors_name = "neolux"

    local opts = config.options
    local colors = vim.deepcopy(base_palette)
    if type(opts.on_colors) == "function" then
        opts.on_colors(colors)
    end
    M.colors = colors

    local highlights = {}
    local modules = {
        require("neolux.editor").get(colors, opts),
        require("neolux.syntax").get(colors, opts),
        require("neolux.plugins").get(colors, opts),
    }

    for _, mod_hl in ipairs(modules) do
        for group, settings in pairs(mod_hl) do
            highlights[group] = settings
        end
    end

    if type(opts.on_highlights) == "function" then
        opts.on_highlights(highlights, colors)
    end

    for group, settings in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, settings)
    end

    -- Terminal 16 Colors (ANSI Standard & Bright)
    vim.g.terminal_color_0  = colors.bg         -- Black
    vim.g.terminal_color_1  = colors.pink       -- Red
    vim.g.terminal_color_2  = colors.green      -- Green
    vim.g.terminal_color_3  = colors.yellow     -- Yellow
    vim.g.terminal_color_4  = colors.blue       -- Blue
    vim.g.terminal_color_5  = colors.purple     -- Magenta
    vim.g.terminal_color_6  = colors.light_blue -- Cyan
    vim.g.terminal_color_7  = colors.fg         -- White

    vim.g.terminal_color_8  = colors.gray3      -- Bright Black (Dark Gray)
    vim.g.terminal_color_9  = colors.pink       -- Bright Red
    vim.g.terminal_color_10 = colors.green      -- Bright Green
    vim.g.terminal_color_11 = colors.yellow     -- Bright Yellow
    vim.g.terminal_color_12 = colors.light_blue -- Bright Blue
    vim.g.terminal_color_13 = colors.purple     -- Bright Magenta
    vim.g.terminal_color_14 = colors.light_blue -- Bright Cyan
    vim.g.terminal_color_15 = colors.fg         -- Bright White
end

return M
