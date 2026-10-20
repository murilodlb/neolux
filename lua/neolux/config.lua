local M = {}

M.defaults = {
    cache = true,
    transparent = false,
    italic_comments = true,
    styles = {
        comments = { italic = true },
        keywords = { bold = true },
        functions = {},
        variables = {},
    },
    on_colors = function(colors) end,
    on_highlights = function(highlights, colors) end,
    plugins = {
        auto = true,
    },
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
    if opts and opts.italic_comments ~= nil then
        M.options.styles.comments.italic = opts.italic_comments
    end
end

return M
