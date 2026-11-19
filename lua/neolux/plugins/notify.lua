local M = {}

function M.get(palette)
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
        hl["Notify" .. level .. "Border"] = { fg = color, bg = palette.gray1 }
        hl["Notify" .. level .. "Icon"] = { fg = color, bg = palette.gray1 }
        hl["Notify" .. level .. "Title"] = { fg = color, bg = palette.gray1, bold = true }
        hl["Notify" .. level .. "Body"] = { fg = palette.fg, bg = palette.gray1 }
    end

    return hl
end

return M
