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
        local tobit, bxor, rol, rshift, tohex = bit.tobit, bit.bxor, bit.rol, bit.rshift, bit.tohex
        local h1 = tobit(0x811c9dc5)
        local h2 = tobit(0x9e3779b9)
        for i = 1, len do
            local b = str_byte(str, i)
            h1 = tobit(rol(bxor(h1, b), 5) - h1 + b)
            h2 = tobit(rol(bxor(h2, b + i), 7) + h2)
        end
        h1 = bxor(h1, rshift(h1, 16))
        h1 = tobit(rol(h1, 11) + h1)
        h1 = bxor(h1, rshift(h1, 13))
        h2 = bxor(h2, rshift(h2, 16))
        h2 = tobit(rol(h2, 13) + h2)
        h2 = bxor(h2, rshift(h2, 15))
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

local COLOR_KEYS = { fg = true, bg = true, sp = true }

local function serialize_hl_value(key, val)
    local t = type(val)
    if t == "boolean" or t == "number" then
        return tostring(val)
    elseif t == "string" then
        if COLOR_KEYS[key] and #val == 7 and val:match("^#%x%x%x%x%x%x$") then
            return "0x" .. val:sub(2):lower()
        end
        return str_format("%q", val)
    elseif t == "table" then
        return M.serialize_hl(val)
    end
    return "nil"
end

function M.serialize_hl(spec)
    local keys = {}
    for k in pairs(spec) do
        keys[#keys + 1] = k
    end
    table.sort(keys, function(a, b)
        local ta, tb = type(a), type(b)
        if ta ~= tb then
            return ta < tb
        end
        return tostring(a) < tostring(b)
    end)

    local parts = {}
    for i = 1, #keys do
        local k = keys[i]
        local key_str
        if type(k) == "string" and k:match("^[%a_][%w_]*$") then
            key_str = k
        elseif type(k) == "number" then
            key_str = "[" .. tostring(k) .. "]"
        else
            key_str = "[" .. str_format("%q", tostring(k)) .. "]"
        end
        parts[#parts + 1] = key_str .. "=" .. serialize_hl_value(k, spec[k])
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

local function write_file_atomic(path, data)
    local uv = get_uv()
    local pid = uv and uv.os_getpid and uv.os_getpid() or vim.fn.getpid()
    local tmp = str_format("%s.%d.tmp", path, pid)

    local f = io.open(tmp, "wb")
    if not f then
        return false
    end

    local ok_w = f:write(data)
    local ok_c = f:close()
    if not ok_w or not ok_c then
        os.remove(tmp)
        return false
    end

    local renamed = false
    if uv and uv.fs_rename then
        local ok_r, res_r = pcall(uv.fs_rename, tmp, path)
        renamed = ok_r and (res_r ~= nil)
    end
    if not renamed then
        local ok_os = os.rename(tmp, path)
        renamed = ok_os and true or false
    end

    if not renamed then
        os.remove(tmp)
        return false
    end
    return true
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

function M.compile(opts, colors, precomputed_hash)
    opts = opts or config.options
    colors = colors or require("neolux").resolve_colors(opts)

    local highlights = M.resolve_highlights(opts, colors)

    local groups = {}
    for group in pairs(highlights) do
        groups[#groups + 1] = group
    end
    table.sort(groups)

    local group_specs = {}
    local spec_counts = {}
    for i = 1, #groups do
        local s = M.serialize_hl(highlights[groups[i]])
        group_specs[i] = s
        spec_counts[s] = (spec_counts[s] or 0) + 1
    end

    local shared_idx = {}
    local shared_list = {}
    for i = 1, #groups do
        local s = group_specs[i]
        if spec_counts[s] >= 2 and not shared_idx[s] then
            local idx = #shared_list + 1
            shared_idx[s] = idx
            shared_list[idx] = s
        end
    end

    local lines = {
        "local set_hl = vim.api.nvim_set_hl",
        'vim.cmd("hi clear")',
        'if vim.g.syntax_on then vim.cmd("syntax reset") end',
        'vim.o.background = "dark"',
        'vim.g.colors_name = "neolux"',
    }

    for i = 1, #config.terminal_colors do
        lines[#lines + 1] = str_format("vim.g.terminal_color_%d = %q", i - 1, colors[config.terminal_colors[i]])
    end

    if #shared_list > 0 then
        lines[#lines + 1] = "local s = {" .. table.concat(shared_list, ",") .. "}"
    end

    for i = 1, #groups do
        local s = group_specs[i]
        local idx = shared_idx[s]
        if idx then
            lines[#lines + 1] = str_format("set_hl(0,%q,s[%d])", groups[i], idx)
        else
            lines[#lines + 1] = str_format("set_hl(0,%q,%s)", groups[i], s)
        end
    end

    local src = table.concat(lines, "\n")
    local chunk, err = load(src, "=[neolux-compiled]")
    if not chunk then
        error("neolux compiler failed to generate chunk: " .. tostring(err))
    end

    local bytecode = string.dump(chunk, true)
    local mk_ok = pcall(vim.fn.mkdir, M.cache_dir, "p")
    if mk_ok then
        local current_hash = precomputed_hash or M.hash(opts, colors)
        if write_file_atomic(M.compiled_path, bytecode) then
            write_file_atomic(M.state_path, current_hash)
        end
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

    local chunk = M.compile(opts, colors, current_hash)
    chunk()
    return false
end

function M.clean()
    os.remove(M.compiled_path)
    os.remove(M.state_path)
end

return M
