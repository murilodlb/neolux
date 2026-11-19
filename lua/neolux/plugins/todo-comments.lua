local M = {}

function M.get(palette, opts)
    local transparent = opts and opts.transparent
    local sign_bg = transparent and "NONE" or palette.bg

    local keywords = {
        TODO = { bg = palette.light_blue, fg = palette.bg },
        FIX = { bg = palette.pink, fg = palette.bg },
        WARN = { bg = palette.yellow, fg = palette.bg },
        HACK = { bg = palette.orange, fg = palette.bg },
        NOTE = { bg = palette.beige, fg = palette.bg },
        PERF = { bg = palette.purple, fg = palette.fg },
        TEST = { bg = palette.green, fg = palette.bg },
    }

    local hl = {}
    for kw, spec in pairs(keywords) do
        hl["TodoBg" .. kw] = { fg = spec.fg, bg = spec.bg, bold = true }
        hl["TodoFg" .. kw] = { fg = spec.bg }
        hl["TodoSign" .. kw] = { fg = spec.bg, bg = sign_bg }
    end

    return hl
end

return M
