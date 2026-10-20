local M = {}
local palette = require("neolux.palette")

function M.setup()
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.opt.termguicolors = true

    vim.g.colors_name = "neolux"

    require("neolux.editor").setup()
    require("neolux.syntax").setup()
    -- require("neolux.plugins").setup()

    -- Terminal 16 Colors (ANSI Standard & Bright)
    vim.g.terminal_color_0  = palette.bg         -- Black
    vim.g.terminal_color_1  = palette.pink       -- Red
    vim.g.terminal_color_2  = palette.green      -- Green
    vim.g.terminal_color_3  = palette.yellow     -- Yellow
    vim.g.terminal_color_4  = palette.blue       -- Blue
    vim.g.terminal_color_5  = palette.purple     -- Magenta
    vim.g.terminal_color_6  = palette.light_blue -- Cyan
    vim.g.terminal_color_7  = palette.fg         -- White

    vim.g.terminal_color_8  = palette.gray3      -- Bright Black (Dark Gray)
    vim.g.terminal_color_9  = palette.pink       -- Bright Red
    vim.g.terminal_color_10 = palette.green      -- Bright Green
    vim.g.terminal_color_11 = palette.yellow     -- Bright Yellow
    vim.g.terminal_color_12 = palette.light_blue -- Bright Blue
    vim.g.terminal_color_13 = palette.purple     -- Bright Magenta
    vim.g.terminal_color_14 = palette.light_blue -- Bright Cyan
    vim.g.terminal_color_15 = palette.fg         -- Bright White
end

return M
