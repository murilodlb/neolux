local config = require("neolux.config")

local M = {}

M.CACHE_FORMAT_VERSION = 2
M.cache_dir = vim.fn.stdpath("cache") .. "/neolux"
M.compiled_path = M.cache_dir .. "/compiled.luac"
M.state_path = M.cache_dir .. "/state.txt"

local SOURCE_DIR = debug.getinfo(1, "S").source:sub(2):match("^(.*)[/\\]") or "."
local ok_bit, bit = pcall(require, "bit")
local str_byte = string.byte
local str_format = string.format

local function get_uv()
    return vim.uv or vim.loop
end

function M.hash_string(str, force_pure_lua)
    local len = #str
    if ok_bit and not force_pure_lua then
        local tobit, bxor, rol, tohex = bit.tobit, bit.bxor, bit.rol, bit.tohex
        local h1 = tobit(0x811c9dc5)
        local h2 = tobit(0x9e3779b9)
        for i = 1, len do
            local b = str_byte(str, i)
            h1 = tobit(rol(bxor(h1, b), 5) - h1 + b)
            h2 = tobit(rol(bxor(h2, b + i), 7) + h2)
        end
        h1 = bxor(h1, rol(h1, 16))
        h2 = bxor(h2, rol(h2, 13))
        return tohex(h1) .. tohex(h2)
    end

    local h1 = 2166136261
    local h2 = 2654435761
    for i = 1, len do
        local b = str_byte(str, i)
        h1 = (h1 * 33 + b + 1) % 4294967296
        h2 = (h2 * 131 + b + i) % 4294967296
    end
    return str_format("%08x%08x", h1, h2)
end

local function serialize_for_hash(value, out)
    local t = type(value)
    if t == "table" then
        out[#out + 1] = "{"
        local keys = {}
        for k in pairs(value) do
            keys[#keys + 1] = k
        end
        table.sort(keys, function(a, b)
            local ta, tb = type(a), type(b)
            if ta ~= tb then
                return ta < tb
            end
            return tostring(a) < tostring(b)
        end)
        for i = 1, #keys do
            local k = keys[i]
            serialize_for_hash(k, out)
            out[#out + 1] = "="
            serialize_for_hash(value[k], out)
            out[#out + 1] = ";"
        end
        out[#out + 1] = "}"
    elseif t == "function" then
        local ok, dumped = pcall(string.dump, value, true)
        out[#out + 1] = "f:" .. (ok and (#dumped .. ":" .. dumped) or tostring(value))
    elseif t == "string" then
        out[#out + 1] = "s:" .. #value .. ":" .. value
    else
        out[#out + 1] = t:sub(1, 1) .. ":" .. tostring(value)
    end
end

function M.get_source_fingerprint(dir)
    local uv = get_uv()
    local root = dir or SOURCE_DIR
    local max_sec, max_nsec, count = 0, 0, 0

    local function walk(d)
        local handle = uv.fs_scandir(d)
        if not handle then
            return
        end
        while true do
            local name, typ = uv.fs_scandir_next(handle)
            if not name then
                break
            end
            local path = d .. "/" .. name
            local st
            if not typ then
                st = uv.fs_stat(path)
                typ = st and st.type or nil
            end
            if typ == "directory" then
                walk(path)
            elseif name:sub(-4) == ".lua" then
                st = st or uv.fs_stat(path)
                if st and st.mtime then
                    count = count + 1
                    local sec = st.mtime.sec or 0
                    local nsec = st.mtime.nsec or 0
                    if sec > max_sec or (sec == max_sec and nsec > max_nsec) then
                        max_sec = sec
                        max_nsec = nsec
                    end
                end
            end
        end
    end

    walk(root)
    return str_format("%d:%d:%d", max_sec, max_nsec, count)
end

function M.hash(opts, colors)
    local has_lazy = package.loaded.lazy ~= nil
    local lazy_keys = {}
    if has_lazy then
        local ok, lazy_cfg = pcall(require, "lazy.core.config")
        local lazy_plugins = ok and lazy_cfg and lazy_cfg.plugins or nil
        if lazy_plugins then
            for i = 1, #config.plugin_repos do
                local repo = config.plugin_repos[i]
                if lazy_plugins[repo] then
                    lazy_keys[#lazy_keys + 1] = repo
                end
            end
        end
    end

    local state_table = {
        v = M.CACHE_FORMAT_VERSION,
        ver = require("neolux").version,
        transparent = opts.transparent,
        italic_comments = opts.italic_comments,
        styles = opts.styles,
        plugins = opts.plugins,
        has_lazy = has_lazy,
        lazy_keys = lazy_keys,
        colors = colors,
    }

    local parts = {}
    serialize_for_hash(state_table, parts)
    parts[#parts + 1] = "|"
    serialize_for_hash(opts.on_colors, parts)
    parts[#parts + 1] = "|"
    serialize_for_hash(opts.on_highlights, parts)
    parts[#parts + 1] = "|"
    parts[#parts + 1] = M.get_source_fingerprint()

    return M.hash_string(table.concat(parts))
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
