local config = require("neolux.config")
local base_palette = require("neolux.palette")

local M = {}

M.version = "0.0.5"

local function copy_palette(src)
    local dst = {}
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

M.colors = copy_palette(base_palette)

function M.resolve_colors(opts)
    opts = opts or config.options
    local colors = copy_palette(base_palette)
    local on_colors = opts.on_colors
    if type(on_colors) == "function" and on_colors ~= config.defaults.on_colors then
        on_colors(colors)
    end
    return colors
end

local function register_commands()
    if M._commands_registered then
        return
    end
    M._commands_registered = true

    vim.api.nvim_create_user_command("NeoluxCompile", function()
        M.compile()
        vim.notify("Neolux: compiled highlights to bytecode cache", vim.log.levels.INFO)
    end, { desc = "Compile Neolux colorscheme highlights to bytecode" })

    vim.api.nvim_create_user_command("NeoluxClean", function()
        M.clean()
        vim.notify("Neolux: cleared bytecode cache", vim.log.levels.INFO)
    end, { desc = "Clear Neolux compiled bytecode cache" })
end

function M.setup(opts)
    config.setup(opts)
    M.colors = M.resolve_colors(config.options)
    register_commands()
end

function M.compile()
    local opts = config.options
    local colors = M.resolve_colors(opts)
    M.colors = colors
    return require("neolux.compiler").compile(opts, colors)
end

function M.clean()
    require("neolux.compiler").clean()
end

function M.load()
    register_commands()

    local opts = config.options
    local colors = M.resolve_colors(opts)
    M.colors = colors

    if opts.cache ~= false then
        require("neolux.compiler").load_or_compile(opts, colors)
        return
    end

    vim.cmd("hi clear")
    if vim.g.syntax_on then
        vim.cmd("syntax reset")
    end

    vim.o.background = "dark"
    vim.g.colors_name = "neolux"

    local highlights = require("neolux.compiler").resolve_highlights(opts, colors)

    for group, settings in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, settings)
    end

    for i = 1, #config.terminal_colors do
        vim.g["terminal_color_" .. (i - 1)] = colors[config.terminal_colors[i]]
    end
end

return M
