local uv = vim.uv or vim.loop
local cache_home = vim.fn.tempname()
vim.fn.mkdir(cache_home, "p")

local function rm_rf(path)
    local st = uv.fs_stat(path)
    if not st then
        return
    end
    if st.type == "directory" then
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

local function run_child(lua_code)
    local out = vim.fn.system({
        "env",
        "XDG_CACHE_HOME=" .. cache_home,
        vim.v.progpath,
        "--clean",
        "--headless",
        "--cmd",
        "set rtp^=.",
        "-c",
        "lua " .. lua_code,
        "-c",
        "qa!",
    })
    assert(vim.v.shell_error == 0, "Child nvim failed: " .. tostring(out))
    local ms = tonumber(out:match("BENCH_MS=([%d%.]+)"))
    assert(ms ~= nil, "Missing BENCH_MS in output: " .. tostring(out))
    return ms
end

local function stats(samples)
    local sorted = {}
    for i = 1, #samples do
        sorted[i] = samples[i]
    end
    table.sort(sorted)
    local mid = math.ceil(#sorted / 2)
    return sorted[mid], sorted[1]
end

local RUNS = 5
local uncached = {}
local cold = {}
local warm = {}

for _ = 1, RUNS do
    uncached[#uncached + 1] = run_child(
        "local uv = vim.uv or vim.loop; "
            .. "require('neolux').setup({ cache = false }); "
            .. "local t0 = uv.hrtime(); "
            .. "vim.cmd('colorscheme neolux'); "
            .. "local t1 = uv.hrtime(); "
            .. "print(string.format('BENCH_MS=%.4f', (t1 - t0) / 1e6))"
    )
end

for _ = 1, RUNS do
    cold[#cold + 1] = run_child(
        "local uv = vim.uv or vim.loop; "
            .. "require('neolux').clean(); "
            .. "local t0 = uv.hrtime(); "
            .. "vim.cmd('colorscheme neolux'); "
            .. "local t1 = uv.hrtime(); "
            .. "print(string.format('BENCH_MS=%.4f', (t1 - t0) / 1e6))"
    )
end

-- Ensure cache is warm before measuring warm hits
run_child("vim.cmd('colorscheme neolux'); print('BENCH_MS=0')")

for _ = 1, RUNS do
    warm[#warm + 1] = run_child(
        "local uv = vim.uv or vim.loop; "
            .. "local t0 = uv.hrtime(); "
            .. "vim.cmd('colorscheme neolux'); "
            .. "local t1 = uv.hrtime(); "
            .. "print(string.format('BENCH_MS=%.4f', (t1 - t0) / 1e6))"
    )
end

local compiled_path = cache_home .. "/nvim/neolux/compiled.luac"
local st = uv.fs_stat(compiled_path)
local bytecode_size = st and st.size or 0

rm_rf(cache_home)

local u_med, u_min = stats(uncached)
local c_med, c_min = stats(cold)
local w_med, w_min = stats(warm)

print(string.format("Neolux Benchmark (%d fresh Neovim subprocesses per mode)", RUNS))
print(string.format("  Uncached (cache=false): median %.3f ms | min %.3f ms", u_med, u_min))
print(string.format("  Cold cache miss:        median %.3f ms | min %.3f ms", c_med, c_min))
print(string.format("  Warm cache hit:         median %.3f ms | min %.3f ms", w_med, w_min))
print(string.format("  Compiled bytecode size: %d bytes", bytecode_size))
print(string.format("  Speedup (uncached/warm): %.2fx", u_med / w_med))
