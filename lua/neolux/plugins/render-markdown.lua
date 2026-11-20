local M = {}

function M.get(palette)
    local hl = {
        RenderMarkdownCode = { bg = palette.gray1 },
        RenderMarkdownCodeBorder = { fg = palette.gray2, bg = palette.gray1 },
        RenderMarkdownCodeInline = { fg = palette.orange, bg = palette.gray1 },
        RenderMarkdownCodeInfo = { fg = palette.light_blue, bg = palette.gray1 },

        RenderMarkdownBullet = { fg = palette.pink },
        RenderMarkdownDash = { fg = palette.gray3 },
        RenderMarkdownQuote = { fg = palette.beige, italic = true },
        RenderMarkdownLink = { fg = palette.blue, underline = true },
        RenderMarkdownWikiLink = { fg = palette.green },
        RenderMarkdownUnchecked = { fg = palette.gray3 },
        RenderMarkdownChecked = { fg = palette.green },
        RenderMarkdownTodo = { fg = palette.orange, bold = true },

        RenderMarkdownTableHead = { fg = palette.light_blue, bold = true },
        RenderMarkdownTableRow = { fg = palette.fg },
        RenderMarkdownTableFill = { fg = palette.gray2 },

        RenderMarkdownSuccess = { fg = palette.green },
        RenderMarkdownInfo = { fg = palette.light_blue },
        RenderMarkdownHint = { fg = palette.beige },
        RenderMarkdownWarn = { fg = palette.yellow },
        RenderMarkdownError = { fg = palette.pink },
    }

    local headings = {
        { palette.pink, palette.tint_pink },
        { palette.orange, palette.tint_yellow },
        { palette.yellow, palette.tint_beige },
        { palette.green, palette.tint_green },
        { palette.light_blue, palette.tint_blue },
        { palette.purple, palette.gray1 },
    }
    for i, colors in ipairs(headings) do
        hl["RenderMarkdownH" .. i] = { fg = colors[1], bold = true }
        hl["RenderMarkdownH" .. i .. "Bg"] = { bg = colors[2] }
    end

    return hl
end

return M
