local uv = vim.uv or vim.loop
local neolux = require("neolux")
local compiler = require("neolux.compiler")
local config = require("neolux.config")

local orig_cache_dir = compiler.cache_dir
local orig_compiled_path = compiler.compiled_path
local orig_state_path = compiler.state_path

local tmp_root = vim.fn.tempname()
local test_cache_dir = tmp_root .. "/neolux-cache"

local function set_cache_dir(dir)
    compiler.cache_dir = dir
    compiler.compiled_path = dir .. "/compiled.luac"
    compiler.state_path = dir .. "/state.txt"
end

local function rm_rf(path)
    local st = uv.fs_stat(path)
    if not st then
        return
    end
    if st.type == "directory" then
        pcall(uv.fs_chmod, path, tonumber("755", 8))
        local handle = uv.fs_scandir(path)
        if handle then
            while true do
                local name = uv.fs_scandir_next(handle)
                if not name then
                    break
                end
                rm_rf(path .. "/" .. name)
            end
        end
        uv.fs_rmdir(path)
    else
        uv.fs_unlink(path)
    end
end

local function reset_neolux()
    package.loaded["lazy"] = nil
    package.loaded["lazy.core.config"] = nil
    set_cache_dir(test_cache_dir)
    rm_rf(test_cache_dir)
    neolux.setup({})
end

local function assert_eq(actual, expected, msg)
    if actual ~= expected then
        error(
            string.format("%s (expected %s, got %s)", msg or "assertion failed", tostring(expected), tostring(actual))
        )
    end
end

local function get_hl(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local passed = 0
local failed = 0

local function test(name, fn)
    reset_neolux()
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        print("PASS: " .. name)
    else
        failed = failed + 1
        print("FAIL: " .. name .. ": " .. tostring(err))
    end
end

test("exports palette and version", function()
    assert(type(neolux.colors) == "table", "neolux.colors must be a table")
    assert_eq(neolux.colors.bg, "#000000", "default bg color")
    assert(type(neolux.version) == "string" and #neolux.version > 0, "neolux.version must be a non-empty string")
end)

test("loads default colorscheme and terminal colors 0-15", function()
    vim.cmd("colorscheme neolux")
    assert_eq(vim.g.colors_name, "neolux", "colors_name")
    assert_eq(vim.o.background, "dark", "background")
    for i = 0, 15 do
        local tc = vim.g["terminal_color_" .. i]
        assert(type(tc) == "string" and #tc > 0, "terminal_color_" .. i .. " missing")
    end
    assert_eq(vim.g.terminal_color_0, "#0c0c0c", "terminal_color_0")
    assert_eq(vim.g.terminal_color_1, "#c5003c", "terminal_color_1")
    assert_eq(vim.g.terminal_color_4, "#044b8b", "terminal_color_4")
    assert_eq(vim.g.terminal_color_9, "#f84285", "terminal_color_9")
    assert_eq(vim.g.terminal_color_10, "#5cd85a", "terminal_color_10")
    assert_eq(vim.g.terminal_color_15, "#f5f1e8", "terminal_color_15")
end)

test("preserves core, diagnostic, lsp, and non-bold def/class highlights", function()
    vim.cmd("colorscheme neolux")

    local normal = get_hl("Normal")
    assert_eq(normal.fg, 0xffffff, "Normal fg")
    assert_eq(normal.bg, 0x000000, "Normal bg")

    local sign_col = get_hl("SignColumn")
    assert_eq(sign_col.bg, 0x000000, "SignColumn bg")

    local spell_bad = get_hl("SpellBad")
    assert_eq(spell_bad.undercurl, true, "SpellBad undercurl")
    assert(spell_bad.sp ~= nil, "SpellBad sp")

    local diag_err = get_hl("DiagnosticUnderlineError")
    assert_eq(diag_err.undercurl, true, "DiagnosticUnderlineError undercurl")
    assert(diag_err.sp ~= nil, "DiagnosticUnderlineError sp")

    local diag_dep = get_hl("DiagnosticDeprecated")
    assert_eq(diag_dep.strikethrough, true, "DiagnosticDeprecated strikethrough")

    local diag_unnec = get_hl("DiagnosticUnnecessary")
    assert(diag_unnec.fg ~= nil, "DiagnosticUnnecessary fg")

    local inlay = get_hl("LspInlayHint")
    assert(inlay.fg ~= nil and inlay.bg ~= nil, "LspInlayHint fg/bg")

    local sig = get_hl("LspSignatureActiveParameter")
    assert_eq(sig.bold, true, "LspSignatureActiveParameter bold")
    assert_eq(sig.underline, true, "LspSignatureActiveParameter underline")

    local ref = get_hl("LspReferenceText")
    assert_eq(ref.reverse, true, "LspReferenceText reverse")

    local pmenu_sel = get_hl("PmenuSel")
    assert(pmenu_sel.reverse ~= true, "PmenuSel must not have reverse=true")

    local diff_add = get_hl("DiffAdd")
    assert_eq(diff_add.bg, 0x0d2614, "DiffAdd bg")

    local param = get_hl("@variable.parameter")
    assert_eq(param.fg, 0xf98800, "@variable.parameter fg")

    local variable = get_hl("@variable")
    assert_eq(variable.fg, 0xffffff, "@variable fg")

    local kw_fn = get_hl("@keyword.function")
    assert(kw_fn.bold ~= true, "@keyword.function must not be bold")

    local kw_type = get_hl("@keyword.type")
    assert(kw_type.bold ~= true, "@keyword.type must not be bold")

    local kw = get_hl("Keyword")
    assert_eq(kw.bold, true, "Keyword bold")

    local h1 = get_hl("@markup.heading.1")
    assert_eq(h1.fg, 0xf84285, "@markup.heading.1 fg")

    local cmp_match = get_hl("CmpItemAbbrMatch")
    assert_eq(cmp_match.fg, 0x2fff73, "CmpItemAbbrMatch fg")

    local blink_match = get_hl("BlinkCmpLabelMatch")
    assert_eq(blink_match.fg, 0x2fff73, "BlinkCmpLabelMatch fg")
end)

test("applies setup options across colorscheme neolux", function()
    neolux.setup({
        transparent = true,
        italic_comments = false,
        styles = {
            keywords = { italic = true },
        },
        on_colors = function(c)
            c.pink = "#ff0055"
        end,
        on_highlights = function(hl, c)
            hl.NeoluxTestCustom = { fg = c.pink, bold = true }
        end,
        plugins = {
            auto = true,
            telescope = false,
        },
    })
    assert_eq(neolux.colors.pink, "#ff0055", "neolux.colors updated after setup")

    vim.cmd("colorscheme neolux")

    local normal = get_hl("Normal")
    assert_eq(normal.bg, nil, "Normal bg nil when transparent=true")

    local comment = get_hl("Comment")
    assert(comment.italic ~= true, "Comment italic=false when italic_comments=false")

    local kw = get_hl("Keyword")
    assert_eq(kw.italic, true, "Keyword italic=true")
    assert_eq(kw.bold, true, "Keyword bold=true")
    assert_eq(kw.fg, 0xff0055, "Keyword uses overridden pink")

    local custom = get_hl("NeoluxTestCustom")
    assert_eq(custom.fg, 0xff0055, "NeoluxTestCustom fg")
    assert_eq(custom.bold, true, "NeoluxTestCustom bold")

    local tele = get_hl("TelescopePromptBorder")
    assert(vim.tbl_isempty(tele), "Telescope disabled when plugins.telescope=false")
end)

test("cache hit loads without requiring editor, syntax, or plugins modules", function()
    vim.cmd("colorscheme neolux")
    assert(uv.fs_stat(compiler.compiled_path) ~= nil, "compiled.luac created")
    assert(uv.fs_stat(compiler.state_path) ~= nil, "state.txt created")

    package.loaded["neolux.editor"] = nil
    package.loaded["neolux.syntax"] = nil
    package.loaded["neolux.plugins"] = nil

    local hit = compiler.load_or_compile(config.options, neolux.colors)
    assert_eq(hit, true, "second load should hit cache")
    assert_eq(package.loaded["neolux.editor"], nil, "neolux.editor should stay unloaded")
    assert_eq(package.loaded["neolux.syntax"], nil, "neolux.syntax should stay unloaded")
    assert_eq(package.loaded["neolux.plugins"], nil, "neolux.plugins should stay unloaded")
end)

test("user commands NeoluxClean and NeoluxCompile work", function()
    vim.cmd("colorscheme neolux")
    assert(uv.fs_stat(compiler.compiled_path) ~= nil, "compiled.luac exists before clean")

    vim.cmd("NeoluxClean")
    assert_eq(uv.fs_stat(compiler.compiled_path), nil, "compiled.luac removed by NeoluxClean")
    assert_eq(uv.fs_stat(compiler.state_path), nil, "state.txt removed by NeoluxClean")

    vim.cmd("NeoluxCompile")
    assert(uv.fs_stat(compiler.compiled_path) ~= nil, "compiled.luac recreated by NeoluxCompile")
    assert(uv.fs_stat(compiler.state_path) ~= nil, "state.txt recreated by NeoluxCompile")
end)

test("health check runs without error", function()
    vim.cmd("colorscheme neolux")
    require("neolux.health").check()
end)

test("config exposes terminal_colors and plugin registries", function()
    local palette = require("neolux.palette")
    assert(type(config.terminal_colors) == "table", "config.terminal_colors missing")
    assert_eq(#config.terminal_colors, 16, "terminal_colors length")
    for i, key in ipairs(config.terminal_colors) do
        assert(palette[key] ~= nil, "invalid palette key at terminal_colors[" .. i .. "]: " .. tostring(key))
    end

    assert(type(config.plugin_map) == "table", "config.plugin_map missing")
    assert(type(config.plugin_repos) == "table", "config.plugin_repos missing")
    assert(type(config.plugin_modules) == "table", "config.plugin_modules missing")

    local map_keys = {}
    for k in pairs(config.plugin_map) do
        table.insert(map_keys, k)
    end
    table.sort(map_keys)
    assert(#config.plugin_repos == #map_keys, "plugin_repos count matches plugin_map")
    for i, repo in ipairs(config.plugin_repos) do
        assert_eq(repo, map_keys[i], "plugin_repos sorted at index " .. i)
    end

    local plugins = require("neolux.plugins")
    assert(plugins.plugins == config.plugin_map, "plugins.plugins shares config.plugin_map")
    assert(plugins.modules == config.plugin_modules, "plugins.modules shares config.plugin_modules")
end)

test("resolve_colors returns fresh copy without mutating base palette", function()
    local palette = require("neolux.palette")
    assert(type(neolux.resolve_colors) == "function", "neolux.resolve_colors missing")
    local orig_bg = palette.bg
    local resolved = neolux.resolve_colors({
        on_colors = function(c)
            c.bg = "#121212"
        end,
    })
    assert_eq(resolved.bg, "#121212", "resolved bg overridden")
    assert_eq(palette.bg, orig_bg, "base palette must not be mutated")
end)

test("plugins.get skips lazy.core.config when auto is false", function()
    package.loaded["lazy"] = true
    package.loaded["lazy.core.config"] = nil
    local palette = require("neolux.palette")
    local hl = require("neolux.plugins").get(palette, { plugins = { auto = false, telescope = true } })
    assert(hl.TelescopeNormal ~= nil, "TelescopeNormal should load with auto=false, telescope=true")
end)

test("syntax.get preserves style behavior for empty and non-empty styles", function()
    local palette = require("neolux.palette")
    local syntax = require("neolux.syntax")
    local hl_default = syntax.get(palette, config.options)
    assert_eq(hl_default["@variable"].fg, palette.fg, "@variable default fg")
    assert_eq(hl_default["Function"].fg, palette.green, "Function default fg")

    local hl_italic = syntax.get(palette, {
        italic_comments = true,
        styles = {
            keywords = { italic = true },
            functions = {},
            variables = {},
        },
    })
    assert_eq(hl_italic["Keyword"].italic, true, "Keyword italic when configured")
    assert_eq(hl_italic["@keyword.function"].italic, true, "@keyword.function inherits italic")
    assert(hl_italic["@keyword.function"].bold ~= true, "@keyword.function stays non-bold")
end)

test("compiler.hash returns 16-char hex without loading vim.inspect", function()
    package.loaded["vim.inspect"] = nil
    rawset(vim, "inspect", nil)
    local h = compiler.hash(config.options, neolux.colors)
    local is_hex16 = type(h) == "string" and h:match("^[0-9a-f]+$") ~= nil and #h == 16
    assert(is_hex16, "hash must be 16-char lowercase hex: " .. tostring(h))
    assert_eq(package.loaded["vim.inspect"], nil, "compiler.hash must not load vim.inspect")
end)

test("compiler.hash_string handles NUL bytes and preserves 64-bit entropy", function()
    assert(type(compiler.hash_string) == "function", "compiler.hash_string missing")
    local b1 = compiler.hash_string("abc\0def")
    local b2 = compiler.hash_string("abc\0xyz")
    local b_empty = compiler.hash_string("")
    local b_opt = compiler.hash_string("transparent=true")
    assert(#b1 == 16 and b1:match("^[0-9a-f]+$"), "bit hash format")
    assert(b1 ~= b2, "bit hash must not truncate at NUL byte")
    assert(b1:sub(1, 4) ~= b1:sub(5, 8), "h1 halves must not collapse on NUL input: " .. b1)
    assert(b_empty:sub(1, 4) ~= b_empty:sub(5, 8), "h1 halves must not collapse on empty input: " .. b_empty)
    assert(b_opt:sub(1, 4) ~= b_opt:sub(5, 8), "h1 halves must not collapse on option input: " .. b_opt)

    local p1 = compiler.hash_string("abc\0def", true)
    local p2 = compiler.hash_string("abc\0xyz", true)
    assert(#p1 == 16 and p1:match("^[0-9a-f]+$"), "pure-Lua hash format")
    assert(p1 ~= p2, "pure-Lua hash must not truncate at NUL byte")
end)

test("compiler.hash ignores unrelated lazy.nvim plugins", function()
    package.loaded["lazy"] = true
    package.loaded["lazy.core.config"] = {
        plugins = {
            ["telescope.nvim"] = {},
        },
    }
    local h1 = compiler.hash(config.options, neolux.colors)

    package.loaded["lazy.core.config"].plugins["unrelated-plugin.nvim"] = {}
    local h2 = compiler.hash(config.options, neolux.colors)
    assert_eq(h2, h1, "unrelated lazy plugin must not invalidate cache hash")

    package.loaded["lazy.core.config"].plugins["gitsigns.nvim"] = {}
    local h3 = compiler.hash(config.options, neolux.colors)
    assert(h3 ~= h1, "supported lazy plugin must change cache hash")
end)

test("get_source_fingerprint detects added, modified, and deleted lua files", function()
    assert(type(compiler.get_source_fingerprint) == "function", "compiler.get_source_fingerprint missing")
    local dir = tmp_root .. "/fp-test"
    uv.fs_mkdir(dir, tonumber("755", 8))
    uv.fs_mkdir(dir .. "/sub", tonumber("755", 8))

    local function write_txt(p, content)
        local fd = assert(io.open(p, "w"))
        fd:write(content)
        fd:close()
    end

    write_txt(dir .. "/a.lua", "return 1\n")
    write_txt(dir .. "/sub/b.lua", "return 2\n")
    local fp1 = compiler.get_source_fingerprint(dir)

    write_txt(dir .. "/sub/c.lua", "return 3\n")
    local fp2 = compiler.get_source_fingerprint(dir)
    assert(fp2 ~= fp1, "adding sub/c.lua must change fingerprint")

    local st_a = assert(uv.fs_stat(dir .. "/a.lua"))
    local next_sec = st_a.mtime.sec + 10
    uv.fs_utime(dir .. "/a.lua", next_sec, next_sec)
    local fp3 = compiler.get_source_fingerprint(dir)
    assert(fp3 ~= fp2, "modifying mtime sec of a.lua must change fingerprint")

    uv.fs_utime(dir .. "/a.lua", next_sec, next_sec + 0.5)
    local st_a_sub = assert(uv.fs_stat(dir .. "/a.lua"))
    if st_a_sub.mtime.nsec > 0 then
        local fp3_sub = compiler.get_source_fingerprint(dir)
        assert(fp3_sub ~= fp3, "modifying sub-second nsec of a.lua must change fingerprint")
        fp3 = fp3_sub
    end

    uv.fs_utime(dir .. "/a.lua", next_sec - 100, next_sec - 100)
    local fp_older = compiler.get_source_fingerprint(dir)
    assert(fp_older ~= fp3, "moving mtime backward must change fingerprint")

    write_txt(dir .. "/a.lua", "return 123456\n")
    local fp_size = compiler.get_source_fingerprint(dir)
    assert(fp_size ~= fp_older, "changing file size must change fingerprint")

    uv.fs_unlink(dir .. "/sub/c.lua")
    local fp4 = compiler.get_source_fingerprint(dir)
    assert(fp4 ~= fp_size, "deleting sub/c.lua must change fingerprint")
end)

test("get_source_fingerprint falls back to vim.loop when vim.uv is nil", function()
    local saved_uv = vim.uv
    local loop_tbl = vim.loop
    if loop_tbl then
        vim.uv = nil
        local ok, fp = pcall(compiler.get_source_fingerprint)
        vim.uv = saved_uv
        assert(ok, "get_source_fingerprint failed with vim.uv=nil: " .. tostring(fp))
        assert(type(fp) == "string" and #fp > 0, "fingerprint non-empty")
    end
end)

test("serialize_hl converts hex RGB without loading vim.inspect", function()
    assert(type(compiler.serialize_hl) == "function", "compiler.serialize_hl missing")
    package.loaded["vim.inspect"] = nil
    rawset(vim, "inspect", nil)

    local s1 = compiler.serialize_hl({ fg = "#55EFEF", bg = "NONE", bold = true })
    assert(s1:find("0x55efef", 1, true) ~= nil, "expected 0x55efef in: " .. s1)
    assert(s1:find('"NONE"', 1, true) ~= nil, 'expected "NONE" in: ' .. s1)
    assert(s1:find("bold=true", 1, true) ~= nil, "expected bold=true in: " .. s1)

    local s2 = compiler.serialize_hl({ fg = "Red", cterm = { bold = true, ["under-curl"] = true } })
    assert(s2:find('"Red"', 1, true) ~= nil, "expected named color Red preserved in: " .. s2)
    assert(s2:find('["under-curl"]=true', 1, true) ~= nil, "expected non-identifier key escaped in: " .. s2)

    local parsed = assert(load("return " .. s1))()
    assert_eq(parsed.fg, 0x55efef, "parsed fg integer")
    assert_eq(parsed.bg, "NONE", "parsed bg NONE")
    assert_eq(parsed.bold, true, "parsed bold")

    assert_eq(package.loaded["vim.inspect"], nil, "serialize_hl must not load vim.inspect")
end)

test("compile handles more than 200 shared specs without hitting local limit", function()
    neolux.setup({
        on_highlights = function(hl)
            for i = 1, 250 do
                local fg = string.format("#%06x", i)
                hl["NeoluxManyA" .. i] = { fg = fg, bold = true }
                hl["NeoluxManyB" .. i] = { fg = fg, bold = true }
            end
        end,
    })
    vim.cmd("colorscheme neolux")
    assert_eq(get_hl("NeoluxManyA250").fg, 250, "NeoluxManyA250 fg")
    assert_eq(get_hl("NeoluxManyB250").fg, 250, "NeoluxManyB250 fg")

    local hit = compiler.load_or_compile(config.options, neolux.colors)
    assert_eq(hit, true, "250+ shared specs cache hit")
    assert_eq(get_hl("NeoluxManyA123").fg, 123, "NeoluxManyA123 fg after cache hit")
end)

test("load_or_compile hashes only once on cache miss", function()
    local orig_hash = compiler.hash
    local calls = 0
    compiler.hash = function(opts, colors)
        calls = calls + 1
        return orig_hash(opts, colors)
    end
    local ok, hit = pcall(compiler.load_or_compile, config.options, neolux.colors)
    compiler.hash = orig_hash
    assert(ok, "load_or_compile failed: " .. tostring(hit))
    assert_eq(hit, false, "cold load_or_compile returns false")
    assert_eq(calls, 1, "compiler.hash should only be called once on cache miss")
end)

test("corrupted compiled.luac recovers automatically", function()
    vim.cmd("colorscheme neolux")
    local f = assert(io.open(compiler.compiled_path, "wb"))
    f:write("not-valid-bytecode")
    f:close()

    local hit = compiler.load_or_compile(config.options, neolux.colors)
    assert_eq(hit, false, "corrupted bytecode triggers recompile")
    assert_eq(get_hl("Normal").fg, 0xffffff, "Normal restored after recovery")

    local hit2 = compiler.load_or_compile(config.options, neolux.colors)
    assert_eq(hit2, true, "subsequent load hits repaired cache")
end)

test("read-only or unwritable cache dir falls back cleanly", function()
    local blocker = tmp_root .. "/blocker_file"
    local fd = assert(io.open(blocker, "w"))
    fd:write("block")
    fd:close()
    set_cache_dir(blocker .. "/nested")

    local ok1, err1 = pcall(vim.cmd, "colorscheme neolux")
    assert(ok1, "colorscheme failed when mkdir blocked: " .. tostring(err1))
    assert_eq(get_hl("Normal").fg, 0xffffff, "Normal applied despite mkdir failure")

    local ro_dir = tmp_root .. "/ro_cache"
    uv.fs_mkdir(ro_dir, tonumber("755", 8))
    uv.fs_chmod(ro_dir, tonumber("555", 8))
    set_cache_dir(ro_dir)

    local ok2, err2 = pcall(neolux.compile)
    local ok3, err3 = pcall(vim.cmd, "colorscheme neolux")
    pcall(uv.fs_chmod, ro_dir, tonumber("755", 8))
    assert(ok2, "neolux.compile failed on read-only cache_dir: " .. tostring(err2))
    assert(ok3, "colorscheme failed on read-only cache_dir: " .. tostring(err3))
    assert_eq(get_hl("Normal").bg, 0x000000, "Normal bg applied on read-only cache_dir")
end)

test("atomic writes leave no temporary files", function()
    vim.cmd("colorscheme neolux")
    local seen = {}
    local handle = uv.fs_scandir(compiler.cache_dir)
    if handle then
        while true do
            local name = uv.fs_scandir_next(handle)
            if not name then
                break
            end
            seen[#seen + 1] = name
        end
    end
    table.sort(seen)
    assert_eq(#seen, 2, "expected exactly 2 files in cache_dir, got: " .. table.concat(seen, ", "))
    assert_eq(seen[1], "compiled.luac", "first cache file")
    assert_eq(seen[2], "state.txt", "second cache file")
end)

test("pixel-for-pixel highlight parity between uncached and warm cache", function()
    neolux.setup({ cache = false })
    vim.cmd("colorscheme neolux")
    local uncached = vim.api.nvim_get_hl(0, {})
    local uncached_tc = {}
    for i = 0, 15 do
        uncached_tc[i] = vim.g["terminal_color_" .. i]
    end

    neolux.setup({ cache = true })
    vim.cmd("colorscheme neolux")
    local hit = compiler.load_or_compile(config.options, neolux.colors)
    assert_eq(hit, true, "warm cache hit for parity check")
    local cached = vim.api.nvim_get_hl(0, {})

    for name, spec in pairs(uncached) do
        assert(vim.deep_equal(cached[name], spec), "highlight mismatch for group: " .. name)
    end
    for name, spec in pairs(cached) do
        assert(vim.deep_equal(uncached[name], spec), "extra cached highlight group: " .. name)
    end
    for i = 0, 15 do
        assert_eq(vim.g["terminal_color_" .. i], uncached_tc[i], "terminal_color_" .. i .. " parity")
    end
end)

test("all 22 plugin modules load non-empty tables with valid link targets", function()
    assert_eq(#config.plugin_modules, 22, "expected 22 plugin modules")
    neolux.setup({ cache = false })
    vim.cmd("colorscheme neolux")

    for _, mod_name in ipairs(config.plugin_modules) do
        local ok, mod = pcall(require, "neolux.plugins." .. mod_name)
        assert_eq(ok, true, "require plugin module: " .. mod_name)
        local hls = mod.get(neolux.colors, config.options)
        assert(type(hls) == "table" and next(hls) ~= nil, "non-empty highlights for: " .. mod_name)

        for group, spec in pairs(hls) do
            if type(spec) == "table" and spec.link then
                local resolved = vim.api.nvim_get_hl(0, { name = spec.link, link = false })
                assert(next(resolved) ~= nil, string.format("dangling link %s -> %s in %s", group, spec.link, mod_name))
            end
        end
    end
end)

test("representative highlight groups for all 12 new plugins", function()
    neolux.setup({ cache = false })
    vim.cmd("colorscheme neolux")

    local cases = {
        { name = "SnacksPickerMatch", fg = 0x2fff73, bold = true },
        { name = "WhichKeyTitle", fg = 0xf98800, bold = true },
        { name = "NoiceCmdlinePopupBorder", fg = 0xf98800 },
        { name = "FlashLabel", fg = 0x000000, bg = 0xf84285, bold = true },
        { name = "TroubleCount", fg = 0xf84285, bold = true },
        { name = "RenderMarkdownH1Bg", bg = 0x2a0a16 },
        { name = "FzfLuaFzfMatch", fg = 0x2fff73, bold = true },
        { name = "TodoBgTODO", fg = 0x000000, bg = 0x55efef, bold = true },
        { name = "NvimTreeRootFolder", fg = 0xf98800, bold = true },
        { name = "MiniFilesNormal", fg = 0xffffff, bg = 0x0c0c0c },
        { name = "MiniIndentscopeSymbol", fg = 0x3c3c3a },
        { name = "DiffviewFilePanelTitle", fg = 0xf98800, bold = true },
        { name = "NotifyBackground", bg = 0x000000 },
    }

    for _, expected in ipairs(cases) do
        local hl = vim.api.nvim_get_hl(0, { name = expected.name, link = false })
        if expected.fg ~= nil then
            assert_eq(hl.fg, expected.fg, expected.name .. ".fg")
        end
        if expected.bg ~= nil then
            assert_eq(hl.bg, expected.bg, expected.name .. ".bg")
        end
        if expected.bold ~= nil then
            assert_eq(hl.bold, expected.bold, expected.name .. ".bold")
        end
    end
end)

test("lazy.nvim auto-detection on new plugins including standalone mini.files", function()
    local orig_lazy = package.loaded["lazy"]
    local orig_lazy_cfg = package.loaded["lazy.core.config"]

    package.loaded["lazy"] = {
        plugins = function()
            return {
                { name = "mini.files" },
                { name = "flash.nvim" },
            }
        end,
    }
    package.loaded["lazy.core.config"] = {
        plugins = {
            ["mini.files"] = {},
            ["flash.nvim"] = {},
        },
    }

    local ok, err = pcall(function()
        neolux.setup({ cache = false, plugins = { auto = true } })
        vim.cmd("colorscheme neolux")

        local mini_hl = vim.api.nvim_get_hl(0, { name = "MiniFilesNormal", link = false })
        local flash_hl = vim.api.nvim_get_hl(0, { name = "FlashLabel", link = false })
        local snacks_hl = vim.api.nvim_get_hl(0, { name = "SnacksPickerMatch", link = false })

        assert_eq(mini_hl.fg, 0xffffff, "mini.files detected via mini module")
        assert_eq(flash_hl.bg, 0xf84285, "flash.nvim detected via flash module")
        assert(next(snacks_hl) == nil, "uninstalled snacks.nvim skipped when lazy active")
    end)

    package.loaded["lazy"] = orig_lazy
    package.loaded["lazy.core.config"] = orig_lazy_cfg
    neolux.setup({ cache = false })
    vim.cmd("colorscheme neolux")
    assert(ok, err)
end)

test("transparent mode clears bg on sidebars/signs/dashboard while preserving NotifyBackground", function()
    neolux.setup({ transparent = true, cache = false })
    vim.cmd("colorscheme neolux")

    local cleared = {
        "TroubleNormal",
        "NvimTreeNormal",
        "DiffviewNormal",
        "MiniDiffSignAdd",
        "TodoSignTODO",
        "SnacksDashboardNormal",
        "TelescopePreviewNormal",
        "BufferLineBufferSelected",
        "MiniTablineHidden",
    }
    for _, name in ipairs(cleared) do
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        assert(next(hl) ~= nil, name .. " should be defined in transparent mode")
        assert_eq(hl.bg, nil, name .. ".bg should be cleared in transparent mode")
    end

    assert_eq(get_hl("BufferLineFill").bg, nil, "BufferLineFill.bg should be cleared in transparent mode")
    assert_eq(get_hl("MiniTablineFill").bg, nil, "MiniTablineFill.bg should be cleared in transparent mode")

    assert_eq(get_hl("EndOfBuffer").fg, 0x3c3c3a, "EndOfBuffer.fg should be gray2 in transparent mode")

    local notify_bg = vim.api.nvim_get_hl(0, { name = "NotifyBackground", link = false })
    assert_eq(notify_bg.bg, 0x000000, "NotifyBackground.bg preserved in transparent mode")

    package.loaded["lualine.themes.neolux"] = nil
    local lualine_t = require("lualine.themes.neolux")
    assert_eq(lualine_t.normal.c.bg, "NONE", "lualine normal.c.bg should be NONE in transparent mode")
    assert_eq(lualine_t.inactive.c.bg, "NONE", "lualine inactive.c.bg should be NONE in transparent mode")
    for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "terminal" }) do
        assert_eq(lualine_t[mode].a.fg, "#000000", "lualine " .. mode .. ".a.fg should be #000000")
    end

    neolux.setup({ transparent = false, cache = false })
    vim.cmd("colorscheme neolux")
    assert_eq(get_hl("EndOfBuffer").fg, 0x000000, "EndOfBuffer.fg should be bg when opaque")
end)

test("compiler.hash detects closure upvalues and handles cyclic table upvalues", function()
    local function make_on_colors(accent)
        return function(colors)
            colors.pink = accent
        end
    end

    neolux.setup({ on_colors = make_on_colors("#ff0055") })
    local h1 = compiler.hash(config.options, neolux.resolve_colors())

    neolux.setup({ on_colors = make_on_colors("#00ff88") })
    local h2 = compiler.hash(config.options, neolux.resolve_colors())
    assert(h1 ~= h2, "changing captured upvalue must invalidate compiler.hash")

    local cyclic = { a = 1 }
    cyclic.self_ref = cyclic
    neolux.setup({
        on_colors = function(colors)
            if cyclic.a == 2 then
                colors.pink = "#123456"
            end
        end,
    })
    local ok, h3 = pcall(compiler.hash, config.options, neolux.resolve_colors())
    assert(ok and type(h3) == "string" and #h3 > 0, "cyclic table upvalue must not overflow: " .. tostring(h3))
end)

test("contrast and rainbow-delimiters highlight fixes", function()
    neolux.setup({ cache = false })
    vim.cmd("colorscheme neolux")

    assert_eq(get_hl("TabLineSel").fg, 0x000000, "TabLineSel.fg")
    assert_eq(get_hl("MiniStatuslineModeNormal").fg, 0x000000, "MiniStatuslineModeNormal.fg")
    assert_eq(get_hl("RainbowDelimiterYellow").fg, 0xffcc00, "RainbowDelimiterYellow.fg")
    assert_eq(get_hl("RainbowDelimiterRed").fg, 0xf84285, "RainbowDelimiterRed.fg")
    assert_eq(get_hl("NeoTreeWinSeparator").fg, 0x3c3c3a, "NeoTreeWinSeparator.fg")
end)

test("no dangling link targets in editor and syntax modules", function()
    neolux.setup({ cache = false })
    vim.cmd("colorscheme neolux")

    local modules = {
        editor = require("neolux.editor").get(neolux.colors, config.options),
        syntax = require("neolux.syntax").get(neolux.colors, config.options),
    }

    for mod_name, hls in pairs(modules) do
        for group, spec in pairs(hls) do
            if type(spec) == "table" and spec.link then
                local resolved = vim.api.nvim_get_hl(0, { name = spec.link, link = false })
                assert(next(resolved) ~= nil, string.format("dangling link %s -> %s in %s", group, spec.link, mod_name))
            end
        end
    end
end)

test("expanded tree-sitter captures and comment documentation styles", function()
    neolux.setup({ cache = false })
    vim.cmd("colorscheme neolux")

    local err = get_hl("@comment.error")
    assert_eq(err.bg, 0xf84285, "@comment.error.bg")
    assert_eq(err.fg, 0x000000, "@comment.error.fg")
    assert_eq(err.bold, true, "@comment.error.bold")

    assert_eq(get_hl("@comment.warning").bg, 0xffcc00, "@comment.warning.bg")
    assert_eq(get_hl("@comment.todo").bg, 0x55efef, "@comment.todo.bg")
    assert_eq(get_hl("@comment.note").bg, 0xe6db74, "@comment.note.bg")

    assert_eq(get_hl("@diff.plus").fg, 0x2fff73, "@diff.plus.fg")
    assert_eq(get_hl("@diff.minus").fg, 0xf84285, "@diff.minus.fg")
    assert_eq(get_hl("@diff.delta").fg, 0xffcc00, "@diff.delta.fg")

    assert_eq(get_hl("@markup.math").fg, 0x55efef, "@markup.math.fg")
    assert_eq(get_hl("@markup.quote").italic, true, "@markup.quote.italic")
    assert_eq(get_hl("@markup.strikethrough").strikethrough, true, "@markup.strikethrough.strikethrough")
    assert_eq(get_hl("@markup.environment").fg, 0xf84285, "@markup.environment.fg")

    assert_eq(get_hl("@function.macro").fg, 0x55efef, "@function.macro.fg")
    assert_eq(get_hl("@number.float").fg, 0x9c6de7, "@number.float.fg")
    assert_eq(get_hl("@keyword.modifier").fg, 0x55efef, "@keyword.modifier.fg")
    assert_eq(get_hl("@keyword.conditional").bold, true, "@keyword.conditional.bold")

    assert_eq(get_hl("@comment.documentation").italic, true, "@comment.documentation italic by default")

    neolux.setup({ cache = false, italic_comments = false })
    vim.cmd("colorscheme neolux")
    assert(
        get_hl("@comment.documentation").italic ~= true,
        "@comment.documentation must not be italic when italic_comments = false"
    )
end)

test("LSP semantic token coverage and explicit clears", function()
    neolux.setup({ cache = false })
    vim.cmd("colorscheme neolux")

    assert(vim.tbl_isempty(get_hl("@lsp.type.variable")), "@lsp.type.variable must be cleared")
    assert(vim.tbl_isempty(get_hl("@lsp.type.comment")), "@lsp.type.comment must be cleared")
    assert_eq(get_hl("@lsp.typemod.variable.parameter").fg, 0xf98800, "@lsp.typemod.variable.parameter.fg")

    assert_eq(get_hl("@lsp.type.typeParameter").fg, 0xf98800, "@lsp.type.typeParameter.fg")
    assert_eq(get_hl("@lsp.type.interface").fg, 0x55efef, "@lsp.type.interface.fg")
    assert_eq(get_hl("@lsp.type.enumMember").fg, 0x9c6de7, "@lsp.type.enumMember.fg")
    assert_eq(get_hl("@lsp.mod.deprecated").strikethrough, true, "@lsp.mod.deprecated.strikethrough")
    assert_eq(get_hl("@lsp.type.unresolvedReference").undercurl, true, "@lsp.type.unresolvedReference.undercurl")
end)

test("new core editor UI groups and message transparency", function()
    neolux.setup({ cache = false, transparent = false })
    vim.cmd("colorscheme neolux")

    assert_eq(get_hl("Conceal").fg, 0x57595b, "Conceal.fg")
    assert_eq(get_hl("Whitespace").fg, 0x3c3c3a, "Whitespace.fg")
    assert_eq(get_hl("SpecialKey").fg, 0x57595b, "SpecialKey.fg")
    assert_eq(get_hl("QuickFixLine").bg, 0x3c3c3a, "QuickFixLine.bg")
    assert_eq(get_hl("Substitute").bg, 0xf84285, "Substitute.bg")
    assert_eq(get_hl("FloatFooter").bg, 0x0c0c0c, "FloatFooter.bg")
    assert_eq(get_hl("SnippetTabstop").bg, 0x3c3c3a, "SnippetTabstop.bg")
    assert_eq(get_hl("TermCursor").bg, 0xf98800, "TermCursor.bg")

    assert_eq(get_hl("MsgArea").bg, 0x000000, "MsgArea.bg when opaque")
    assert_eq(get_hl("MsgSeparator").bg, 0x000000, "MsgSeparator.bg when opaque")

    neolux.setup({ cache = false, transparent = true })
    vim.cmd("colorscheme neolux")
    assert_eq(get_hl("MsgArea").bg, nil, "MsgArea.bg cleared in transparent mode")
    assert_eq(get_hl("MsgSeparator").bg, nil, "MsgSeparator.bg cleared in transparent mode")
end)

test("styles.floats supports dark, normal, and transparent modes", function()
    neolux.setup({
        cache = false,
        transparent = false,
        styles = { floats = "transparent" },
    })
    vim.cmd("colorscheme neolux")

    local float_groups = {
        "NormalFloat",
        "FloatBorder",
        "Pmenu",
        "TelescopeNormal",
        "WhichKeyNormal",
        "NoiceCmdlinePopup",
        "SnacksPicker",
        "FzfLuaNormal",
        "BlinkCmpMenu",
        "LazyNormal",
        "MiniFilesNormal",
        "NotifyERRORBody",
    }
    for _, name in ipairs(float_groups) do
        assert_eq(get_hl(name).bg, nil, name .. ".bg should be cleared when floats='transparent'")
    end
    assert_eq(get_hl("NotifyBackground").bg, 0x000000, "NotifyBackground.bg remains opaque when floats='transparent'")

    neolux.setup({
        cache = false,
        transparent = false,
        styles = { floats = "normal" },
    })
    vim.cmd("colorscheme neolux")
    assert_eq(get_hl("NormalFloat").bg, 0x000000, "NormalFloat.bg matches normal bg when floats='normal'")
    assert_eq(get_hl("TelescopeNormal").bg, 0x000000, "TelescopeNormal.bg matches normal bg when floats='normal'")

    neolux.setup({
        cache = false,
        transparent = true,
        styles = { floats = "normal" },
    })
    vim.cmd("colorscheme neolux")
    assert_eq(get_hl("NormalFloat").bg, nil, "NormalFloat.bg clears when floats='normal' and transparent=true")
end)

test("styles.sidebars supports normal, dark, and transparent modes", function()
    neolux.setup({
        cache = false,
        transparent = false,
        styles = { sidebars = "dark" },
    })
    vim.cmd("colorscheme neolux")

    local sidebars = { "NeoTreeNormal", "NvimTreeNormal", "TroubleNormal", "DiffviewNormal" }
    for _, name in ipairs(sidebars) do
        assert_eq(get_hl(name).bg, 0x0c0c0c, name .. ".bg should be gray1 when sidebars='dark'")
    end
    assert_eq(get_hl("NeoTreeEndOfBuffer").fg, 0x0c0c0c, "NeoTreeEndOfBuffer.fg matches dark sidebar")

    neolux.setup({
        cache = false,
        transparent = false,
        styles = { sidebars = "transparent" },
    })
    vim.cmd("colorscheme neolux")
    assert_eq(get_hl("Normal").bg, 0x000000, "Normal.bg stays opaque when only sidebars='transparent'")
    for _, name in ipairs(sidebars) do
        assert_eq(get_hl(name).bg, nil, name .. ".bg should be cleared when sidebars='transparent'")
    end
    assert_eq(get_hl("NeoTreeEndOfBuffer").fg, 0x3c3c3a, "NeoTreeEndOfBuffer.fg is gray2 when sidebars='transparent'")
end)

test("compiler.hash invalidates when styles.floats or styles.sidebars changes", function()
    neolux.setup({ styles = { floats = "dark", sidebars = "normal" } })
    local h_default = compiler.hash(config.options, neolux.resolve_colors())

    neolux.setup({ styles = { floats = "transparent", sidebars = "normal" } })
    local h_float = compiler.hash(config.options, neolux.resolve_colors())
    assert(h_default ~= h_float, "changing styles.floats must change compiler.hash")

    neolux.setup({ styles = { floats = "dark", sidebars = "dark" } })
    local h_sidebar = compiler.hash(config.options, neolux.resolve_colors())
    assert(h_default ~= h_sidebar, "changing styles.sidebars must change compiler.hash")
end)

test("generated extras files exist and stay synced with palette", function()
    local expected_files = {
        "extras/wezterm/neolux.lua",
        "extras/wezterm/neolux.toml",
        "extras/ghostty/neolux",
        "extras/ghostty/neolux.conf",
        "extras/kitty/neolux.conf",
        "extras/fzf/neolux.sh",
        "extras/tmux/neolux.tmux",
    }
    for _, path in ipairs(expected_files) do
        assert(uv.fs_stat(path) ~= nil, "missing generated extra file: " .. path)
    end

    local t = dofile("extras/wezterm/neolux.lua")
    assert_eq(t.background, neolux.colors.bg, "wezterm background")
    assert_eq(t.cursor_bg, neolux.colors.orange, "wezterm cursor_bg")
    assert_eq(#t.ansi, 8, "wezterm ansi length")
    assert_eq(#t.brights, 8, "wezterm brights length")
    assert_eq(t.ansi[2], neolux.colors.red, "wezterm ansi[2] red")

    local function read_all(p)
        local fd = assert(io.open(p, "rb"))
        local data = fd:read("*a")
        fd:close()
        return data
    end

    for _, p in ipairs({ "extras/fzf/neolux.sh", "extras/tmux/neolux.tmux" }) do
        local content = read_all(p)
        assert(content:find(neolux.colors.orange, 1, true) ~= nil, p .. " missing orange hex")
        assert(content:find(neolux.colors.light_blue, 1, true) ~= nil, p .. " missing light_blue hex")
        assert(content:find(neolux.colors.bg, 1, true) ~= nil, p .. " missing bg hex")
    end
end)

rm_rf(tmp_root)
set_cache_dir(orig_cache_dir)
compiler.compiled_path = orig_compiled_path
compiler.state_path = orig_state_path
neolux.setup({})

print(string.format("\nSummary: %d passed, %d failed", passed, failed))
if failed > 0 then
    vim.cmd("cq 1")
end
