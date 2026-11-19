local config = require("neolux.config")

local M = {}

M.plugins = config.plugin_map
M.modules = config.plugin_modules

function M.get(palette, opts)
    opts = opts or config.options
    local plugin_opts = opts.plugins or { auto = true }
    local enabled = {}

    local has_lazy = package.loaded.lazy ~= nil

    if plugin_opts.all or (plugin_opts.auto and not has_lazy) then
        for _, mod in ipairs(M.modules) do
            enabled[mod] = true
        end
    elseif plugin_opts.auto and has_lazy then
        local ok, lazy_cfg = pcall(require, "lazy.core.config")
        local lazy_plugins = ok and lazy_cfg and lazy_cfg.plugins or nil
        if lazy_plugins then
            for repo, mod in pairs(M.plugins) do
                if lazy_plugins[repo] then
                    enabled[mod] = true
                end
            end
        end
    end

    -- Apply explicit user overrides (supports both module name and repo name)
    for k, v in pairs(plugin_opts) do
        if k ~= "auto" and k ~= "all" and type(v) == "boolean" then
            local mod = M.plugins[k] or k
            enabled[mod] = v
        end
    end

    local highlights = {}
    for _, mod in ipairs(M.modules) do
        if enabled[mod] then
            local ok, plugin_mod = pcall(require, "neolux.plugins." .. mod)
            if ok and plugin_mod and plugin_mod.get then
                local groups = plugin_mod.get(palette, opts)
                for group, settings in pairs(groups) do
                    highlights[group] = settings
                end
            end
        end
    end

    return highlights
end

function M.setup(palette, opts)
    palette = palette or require("neolux.palette")
    opts = opts or config.options
    local groups = M.get(palette, opts)
    for group, settings in pairs(groups) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end

return M
