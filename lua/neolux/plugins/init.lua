local M = {}

-- Map lazy.nvim plugin repository names to neolux plugin modules
M.plugins = {
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

-- All unique module names in lua/neolux/plugins/
M.modules = {
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

function M.get(palette, opts)
    opts = opts or require("neolux.config").options
    local plugin_opts = opts.plugins or { auto = true }
    local enabled = {}

    local has_lazy = package.loaded.lazy ~= nil
    local lazy_plugins = has_lazy and require("lazy.core.config").plugins or nil

    if plugin_opts.all or (plugin_opts.auto and not has_lazy) then
        for _, mod in ipairs(M.modules) do
            enabled[mod] = true
        end
    elseif plugin_opts.auto and lazy_plugins then
        for repo, mod in pairs(M.plugins) do
            if lazy_plugins[repo] then
                enabled[mod] = true
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
    opts = opts or require("neolux.config").options
    local groups = M.get(palette, opts)
    for group, settings in pairs(groups) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end

return M
