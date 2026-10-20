local M = {}

M.cache_dir = vim.fn.stdpath("cache") .. "/neolux"
M.compiled_path = M.cache_dir .. "/compiled.luac"
M.state_path = M.cache_dir .. "/state.txt"

local function get_source_mtime()
    local src = debug.getinfo(1, "S").source:sub(2)
    local dir = vim.fn.fnamemodify(src, ":h")
    local max_mtime = 0

    local files = {
        dir .. "/init.lua",
        dir .. "/config.lua",
        dir .. "/palette.lua",
        dir .. "/editor.lua",
        dir .. "/syntax.lua",
        dir .. "/compiler.lua",
        dir .. "/plugins/init.lua",
        dir .. "/plugins/neo-tree.lua",
        dir .. "/plugins/lazy.lua",
        dir .. "/plugins/mason.lua",
        dir .. "/plugins/telescope.lua",
        dir .. "/plugins/cmp.lua",
        dir .. "/plugins/blink.lua",
        dir .. "/plugins/gitsigns.lua",
        dir .. "/plugins/indent-blankline.lua",
        dir .. "/plugins/bufferline.lua",
        dir .. "/plugins/rainbow-delimiters.lua",
    }

    for _, file in ipairs(files) do
        local stat = vim.uv.fs_stat(file)
        if stat and stat.mtime and stat.mtime.sec > max_mtime then
            max_mtime = stat.mtime.sec
        end
    end

    return tostring(max_mtime)
end

local function dump_fn(fn)
    if type(fn) == "function" then
        local ok, dumped = pcall(string.dump, fn, true)
        if ok then
            return dumped
        end
    end
    return ""
end

function M.hash(opts, colors)
    local lazy_keys = {}
    if package.loaded.lazy ~= nil then
        local ok, lazy_cfg = pcall(require, "lazy.core.config")
        if ok and lazy_cfg and lazy_cfg.plugins then
            for k in pairs(lazy_cfg.plugins) do
                table.insert(lazy_keys, k)
            end
            table.sort(lazy_keys)
        end
    end

    local state_table = {
        transparent = opts.transparent,
        italic_comments = opts.italic_comments,
        styles = opts.styles,
        plugins = opts.plugins,
        has_lazy = package.loaded.lazy ~= nil,
        lazy_keys = lazy_keys,
        colors = colors,
    }

    local payload = table.concat({
        vim.inspect(state_table),
        dump_fn(opts.on_colors),
        dump_fn(opts.on_highlights),
        get_source_mtime(),
    }, "|")

    return vim.fn.sha256(payload)
end

function M.resolve_highlights(opts, colors)
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

    return highlights
end

function M.compile(opts, colors)
    opts = opts or require("neolux.config").options
    if not colors then
        colors = vim.deepcopy(require("neolux.palette"))
        if type(opts.on_colors) == "function" then
            opts.on_colors(colors)
        end
    end

    local highlights = M.resolve_highlights(opts, colors)

    local lines = {
        "local set_hl = vim.api.nvim_set_hl",
        'vim.cmd("hi clear")',
        'if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end',
        'vim.o.background = "dark"',
        'vim.g.colors_name = "neolux"',
        string.format("vim.g.terminal_color_0  = %q", colors.bg),
        string.format("vim.g.terminal_color_1  = %q", colors.pink),
        string.format("vim.g.terminal_color_2  = %q", colors.green),
        string.format("vim.g.terminal_color_3  = %q", colors.yellow),
        string.format("vim.g.terminal_color_4  = %q", colors.blue),
        string.format("vim.g.terminal_color_5  = %q", colors.purple),
        string.format("vim.g.terminal_color_6  = %q", colors.light_blue),
        string.format("vim.g.terminal_color_7  = %q", colors.fg),
        string.format("vim.g.terminal_color_8  = %q", colors.gray3),
        string.format("vim.g.terminal_color_9  = %q", colors.pink),
        string.format("vim.g.terminal_color_10 = %q", colors.green),
        string.format("vim.g.terminal_color_11 = %q", colors.yellow),
        string.format("vim.g.terminal_color_12 = %q", colors.light_blue),
        string.format("vim.g.terminal_color_13 = %q", colors.purple),
        string.format("vim.g.terminal_color_14 = %q", colors.light_blue),
        string.format("vim.g.terminal_color_15 = %q", colors.fg),
    }

    local groups = vim.tbl_keys(highlights)
    table.sort(groups)

    for _, group in ipairs(groups) do
        local spec_str = vim.inspect(highlights[group]):gsub("%s+", " ")
        table.insert(lines, string.format("set_hl(0, %q, %s)", group, spec_str))
    end

    local src = table.concat(lines, "\n")
    local chunk, err = load(src, "=[neolux-compiled]")
    if not chunk then
        error("neolux compiler failed to generate chunk: " .. tostring(err))
    end

    local bytecode = string.dump(chunk, true)
    vim.fn.mkdir(M.cache_dir, "p")

    local f_bin = io.open(M.compiled_path, "wb")
    if f_bin then
        f_bin:write(bytecode)
        f_bin:close()
    end

    local current_hash = M.hash(opts, colors)
    local f_state = io.open(M.state_path, "w")
    if f_state then
        f_state:write(current_hash)
        f_state:close()
    end

    return chunk
end

function M.load_or_compile(opts, colors)
    local current_hash = M.hash(opts, colors)

    local f_state = io.open(M.state_path, "r")
    local cached_hash = nil
    if f_state then
        cached_hash = f_state:read("*a")
        f_state:close()
    end

    if cached_hash == current_hash then
        local ok, chunk = pcall(loadfile, M.compiled_path)
        if ok and type(chunk) == "function" then
            local run_ok = pcall(chunk)
            if run_ok then
                return true
            end
        end
    end

    local chunk = M.compile(opts, colors)
    chunk()
    return false
end

function M.clean()
    os.remove(M.compiled_path)
    os.remove(M.state_path)
end

return M
