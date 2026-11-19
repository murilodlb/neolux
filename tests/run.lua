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
        error(string.format("%s (expected %s, got %s)", msg or "assertion failed", tostring(expected), tostring(actual)))
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
    assert(type(h) == "string" and h:match("^[0-9a-f]+$") and #h == 16, "hash must be 16-char lowercase hex: " .. tostring(h))
    assert_eq(package.loaded["vim.inspect"], nil, "compiler.hash must not load vim.inspect")
end)

test("compiler.hash_string handles NUL bytes in both bit and pure-Lua paths", function()
    assert(type(compiler.hash_string) == "function", "compiler.hash_string missing")
    local b1 = compiler.hash_string("abc\0def")
    local b2 = compiler.hash_string("abc\0xyz")
    assert(#b1 == 16 and b1:match("^[0-9a-f]+$"), "bit hash format")
    assert(b1 ~= b2, "bit hash must not truncate at NUL byte")

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

    uv.fs_utime(dir .. "/a.lua", 1800000100, 1800000100.123)
    local fp3 = compiler.get_source_fingerprint(dir)
    assert(fp3 ~= fp2, "modifying mtime of a.lua must change fingerprint")

    uv.fs_unlink(dir .. "/sub/c.lua")
    local fp4 = compiler.get_source_fingerprint(dir)
    assert(fp4 ~= fp3, "deleting sub/c.lua must change fingerprint")
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

rm_rf(tmp_root)
set_cache_dir(orig_cache_dir)
compiler.compiled_path = orig_compiled_path
compiler.state_path = orig_state_path
neolux.setup({})

print(string.format("\nSummary: %d passed, %d failed", passed, failed))
if failed > 0 then
    vim.cmd("cq 1")
end
