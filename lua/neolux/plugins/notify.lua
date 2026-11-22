local M = {}

function M.get(palette, opts)
    local bgs = require("neolux.config").resolve_bgs(palette, opts)

    local hl = {
        NotifyBackground = { bg = palette.bg },
    }

    local levels = {
        ERROR = palette.pink,
        WARN = palette.yellow,
        INFO = palette.light_blue,
        DEBUG = palette.gray3,
        TRACE = palette.purple,
    }
    for level, color in pairs(levels) do
        hl["Notify" .. level .. "Border"] = { fg = color, bg = bgs.float }
        hl["Notify" .. level .. "Icon"] = { fg = color, bg = bgs.float }
        hl["Notify" .. level .. "Title"] = { fg = color, bg = bgs.float, bold = true }
        hl["Notify" .. level .. "Body"] = { fg = palette.fg, bg = bgs.float }
    end

    return hl
end

return M
