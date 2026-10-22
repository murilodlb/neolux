local M = {}

local health = vim.health or require("health")
local start = health.start or health.report_start
local ok = health.ok or health.report_ok
local warn = health.warn or health.report_warn
local info = health.info or health.report_info

function M.check()
    start("neolux")

    if vim.fn.has("nvim-0.8.0") == 1 then
        ok("Neovim >= 0.8.0")
    else
        warn("Neovim < 0.8.0 detected; Neolux requires Neovim 0.8+ for full highlight support")
    end

    if vim.o.termguicolors then
        ok("`termguicolors` is enabled")
    else
        warn("`termguicolors` is disabled", {
            "Neolux is a truecolor theme and requires 24-bit RGB color support.",
            "Enable it in your configuration with `vim.opt.termguicolors = true`.",
        })
    end

    if vim.g.colors_name == "neolux" then
        ok("Active colorscheme is `neolux`")
    else
        info(
            string.format(
                "Current colorscheme is `%s` (run `:colorscheme neolux` to activate)",
                tostring(vim.g.colors_name or "default")
            )
        )
    end

    local config = require("neolux.config")
    local compiler = require("neolux.compiler")
    if config.options.cache ~= false then
        local uv = vim.uv or vim.loop
        local stat = uv and uv.fs_stat(compiler.compiled_path) or nil
        if stat then
            ok("Bytecode cache is enabled and compiled (" .. compiler.compiled_path .. ")")
        else
            info("Bytecode cache is enabled (will be generated on next `:colorscheme neolux` or `:NeoluxCompile`)")
        end
    else
        info("Bytecode cache is disabled (`cache = false`)")
    end
end

return M
