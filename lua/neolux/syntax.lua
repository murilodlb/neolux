local M = {}

local function with_style(base, style)
    if type(style) == "table" and next(style) ~= nil then
        return vim.tbl_extend("force", base, style)
    end
    return base
end

function M.get(palette, opts)
    palette = palette or require("neolux.palette")
    opts = opts or require("neolux.config").options

    local styles = opts.styles or {}
    local comment_style = vim.tbl_extend("force", { italic = opts.italic_comments ~= false }, styles.comments or {})
    local keyword_style = vim.tbl_extend("force", { bold = true }, styles.keywords or {})
    local function_kw_style = vim.tbl_extend("force", styles.keywords or {}, {
        bold = false,
        -- italic = true,
    })
    local function_style = styles.functions or {}
    local variable_style = styles.variables or {}

    return {
        -- 1. SYNTAX GROUPS
        -- These act as a fallback and foundation.
        Comment = with_style({ fg = palette.beige }, comment_style),
        -- Constants
        Constant = { fg = palette.purple },
        String = { fg = palette.beige },
        Character = { fg = palette.beige },
        Number = { fg = palette.purple },
        Float = { fg = palette.purple },
        Boolean = { fg = palette.purple },
        -- Identifiers
        Identifier = with_style({ fg = palette.fg }, variable_style),
        Function = with_style({ fg = palette.green }, function_style),
        -- Statements
        Statement = { fg = palette.pink },
        Conditional = with_style({ fg = palette.pink }, keyword_style), -- if, then, else
        Repeat = with_style({ fg = palette.pink }, keyword_style), -- for, while
        Label = { fg = palette.pink },
        Operator = { fg = palette.pink },
        Keyword = with_style({ fg = palette.pink }, keyword_style),
        Exception = with_style({ fg = palette.pink }, keyword_style), -- try, catch
        -- Preprocessors
        PreProc = { fg = palette.light_blue }, -- import, from
        Include = { fg = palette.blue },
        Define = { fg = palette.purple },
        Macro = { fg = palette.light_blue },
        PreCondit = { fg = palette.light_blue },
        -- Types
        Type = { fg = palette.fg }, -- class, int, string
        StorageClass = { fg = palette.light_blue },
        Structure = { fg = palette.light_blue },
        Typedef = { fg = palette.light_blue },
        -- Special Characters & Tags
        Special = { fg = palette.blue },
        SpecialChar = { fg = palette.pink }, -- Special characters inside strings
        Tag = { fg = palette.pink },
        Delimiter = { fg = palette.yellow }, -- brackets (, [, {
        SpecialComment = { fg = palette.orange, bold = true },
        Debug = { fg = palette.beige },
        -- Text Markup & Alerts
        Underlined = { underline = true },
        Ignore = { fg = palette.bg }, -- Hidden text
        Error = { fg = palette.bg, bg = palette.pink, bold = true },
        Todo = { fg = palette.bg, bg = palette.yellow, bold = true },

        -- 2. TREE-SITTER GROUPS
        ["@variable"] = with_style({ fg = palette.fg }, variable_style), -- Normal variables
        ["@variable.builtin"] = { fg = palette.green }, -- 'self' or 'this'
        ["@variable.parameter"] = { fg = palette.orange }, -- Function arguments
        ["@variable.parameter.builtin"] = { link = "@variable.parameter" },
        ["@variable.member"] = { fg = palette.light_blue }, -- Attributes
        ["@function"] = { link = "Function" },
        ["@function.builtin"] = with_style({ fg = palette.light_blue }, function_style), -- print(), len()
        ["@function.macro"] = { link = "Macro" },
        ["@keyword"] = { link = "Keyword" },
        ["@keyword.function"] = with_style({ fg = palette.light_blue }, function_kw_style), -- 'def' or 'function'
        ["@keyword.return"] = with_style({ fg = palette.pink }, keyword_style), -- 'return'
        ["@keyword.conditional"] = { link = "Conditional" },
        ["@keyword.repeat"] = { link = "Repeat" },
        ["@keyword.exception"] = { link = "Exception" },
        ["@keyword.modifier"] = { link = "StorageClass" },
        ["@keyword.directive.define"] = { link = "Define" },
        ["@keyword.debug"] = { link = "Debug" },
        ["@type"] = { link = "Type" },
        ["@type.builtin"] = { fg = palette.light_blue }, -- built-in types
        ["@type.definition"] = { link = "@type" },
        ["@constant"] = { link = "Constant" },
        ["@constant.builtin"] = { fg = palette.purple }, -- 'None', 'NULL', 'True', 'False'
        ["@constant.macro"] = { link = "Define" },
        ["@constructor"] = { fg = palette.light_blue }, -- '__init__'
        ["@string"] = { link = "String" },
        ["@character"] = { link = "Character" },
        ["@character.special"] = { link = "SpecialChar" },
        ["@number"] = { link = "Number" },
        ["@number.float"] = { link = "Float" },
        ["@boolean"] = { link = "Boolean" },
        ["@comment"] = { link = "Comment" },
        ["@comment.documentation"] = with_style({ fg = palette.beige }, comment_style),
        ["@comment.error"] = { fg = palette.bg, bg = palette.pink, bold = true },
        ["@comment.warning"] = { fg = palette.bg, bg = palette.yellow, bold = true },
        ["@comment.todo"] = { fg = palette.bg, bg = palette.light_blue, bold = true },
        ["@comment.note"] = { fg = palette.bg, bg = palette.beige, bold = true },
        ["@diff.plus"] = { link = "Added" },
        ["@diff.minus"] = { link = "Removed" },
        ["@diff.delta"] = { link = "Changed" },
        ["@punctuation.delimiter"] = { fg = palette.beige }, -- Commas, colons
        ["@property"] = { link = "@variable.member" }, -- e.g., the 'name' in user.name
        ["@function.method"] = { link = "Function" }, -- Green for class methods
        ["@function.method.call"] = { link = "Function" },
        ["@module"] = { fg = palette.purple }, -- e.g., the 'numpy' in 'import numpy'
        ["@module.builtin"] = { link = "@module" },
        ["@string.escape"] = { fg = palette.purple, bold = true }, -- \n, \t
        ["@string.regexp"] = { fg = palette.blue }, -- Regex patterns
        ["@string.special"] = { fg = palette.blue },
        ["@string.special.symbol"] = { fg = palette.purple },
        ["@string.special.path"] = { fg = palette.light_blue, underline = true },
        ["@tag"] = { fg = palette.pink }, -- <div>, <MyComponent>
        ["@tag.attribute"] = { fg = palette.green, italic = true }, -- className, onClick
        ["@tag.delimiter"] = { fg = palette.yellow }, -- The < and > brackets
        ["@operator"] = { link = "Operator" }, -- +, -, =, ->
        ["@keyword.directive"] = { fg = palette.pink }, -- #include, #define in C
        ["@keyword.import"] = { link = "Include" }, -- import, require
        ["@attribute"] = { fg = palette.blue }, -- The 'dataclass' word
        ["@attribute.builtin"] = { fg = palette.blue }, -- Built-ins like property or staticmethod
        ["@tag.builtin"] = { fg = palette.pink }, -- Standard DOM tags (div, span, a, p)
        ["@tag.attribute.builtin"] = { fg = palette.green }, -- Standard attributes (class, id, href)
        ["@string.special.url"] = { fg = palette.blue, underline = true }, -- The actual URL string inside href="url"
        ["@constant.character"] = { fg = palette.purple }, -- HTML entities like &nbsp;, &amp;, &copy;
        ["@markup.heading"] = { fg = palette.orange, bold = true }, -- Text inside <h1>, <h2>, etc.
        ["@markup.strong"] = { fg = palette.fg, bold = true }, -- Text inside <b> or <strong>
        ["@markup.italic"] = { fg = palette.fg, italic = true }, -- Text inside <i> or <em>
        ["@tag.css"] = { fg = palette.pink }, -- body, div, span selectors
        ["@property.css"] = { fg = palette.light_blue }, -- background-color, margin, display
        ["@type.css"] = { link = "@tag.css" }, -- Fallback for element selectors
        ["@variable.css"] = { fg = palette.green }, -- Custom properties / variables (--primary-color)
        ["@string.css"] = { link = "String" },
        ["@number.css"] = { link = "Number" }, -- 10rem, 0.05em, 100vh
        ["@keyword.css"] = { link = "Keyword" }, -- !important, @media, @keyframes
        ["@constant.css"] = { fg = palette.purple }, -- CSS keywords (flex, bold, none, hidden)
        ["@punctuation.delimiter.css"] = { fg = palette.beige }, -- Colons, semicolons
        ["@punctuation.special.tsx"] = { fg = palette.orange },
        ["@punctuation.special.jsx"] = { fg = palette.orange },
        ["@punctuation.special"] = { fg = palette.yellow },
        ["@punctuation.special.python"] = { fg = palette.yellow },
        ["@punctuation.special.vue"] = { fg = palette.orange },
        ["@punctuation.special.svelte"] = { fg = palette.orange },
        ["@punctuation.bracket.tsx"] = { fg = palette.orange },
        ["@punctuation.bracket.jsx"] = { fg = palette.orange },
        ["@function.call"] = { link = "Function" },
        ["@method.call"] = { link = "Function" },
        ["@keyword.operator"] = { link = "Operator" }, -- e.g. 'and', 'or', 'in', 'sizeof'
        ["@keyword.coroutine"] = with_style({ fg = palette.pink }, keyword_style), -- async, await, yield
        ["@keyword.storage"] = { link = "StorageClass" }, -- static, const, mut, extern
        ["@keyword.type"] = with_style({ fg = palette.light_blue }, function_kw_style),
        ["@string.documentation"] = with_style({ fg = palette.beige }, comment_style), -- Python docstrings / JSDoc
        ["@label"] = { fg = palette.pink }, -- C/C++ goto labels, loop tags

        -- 3. BRACKETS
        ["@punctuation.bracket"] = { fg = palette.yellow }, -- Fallback for standard brackets
        ["@punctuation.bracket.delimiter"] = { link = "@punctuation.bracket" },

        -- 4. MARKUP (MARKDOWN & LATEX)
        ["@markup.heading.1"] = { fg = palette.pink, bold = true },
        ["@markup.heading.2"] = { fg = palette.orange, bold = true },
        ["@markup.heading.3"] = { fg = palette.yellow, bold = true },
        ["@markup.heading.4"] = { fg = palette.green, bold = true },
        ["@markup.heading.5"] = { fg = palette.light_blue, bold = true },
        ["@markup.heading.6"] = { fg = palette.purple, bold = true },
        ["@markup.link"] = { fg = palette.light_blue },
        ["@markup.link.url"] = { fg = palette.blue, underline = true },
        ["@markup.link.label"] = { fg = palette.green },
        ["@markup.raw"] = { fg = palette.orange }, -- Inline code blocks `code`
        ["@markup.raw.block"] = { fg = palette.fg }, -- Fenced code blocks ```
        ["@markup.list"] = { fg = palette.pink }, -- Markdown bullets (- / *)
        ["@markup.list.checked"] = { fg = palette.green }, -- [x] Checkboxes
        ["@markup.list.unchecked"] = { fg = palette.gray3 }, -- [ ] Checkboxes
        ["@markup.strikethrough"] = { fg = palette.gray3, strikethrough = true },
        ["@markup.underline"] = { underline = true },
        ["@markup.quote"] = { fg = palette.beige, italic = true },
        ["@markup.math"] = { fg = palette.light_blue },
        ["@markup.environment"] = { fg = palette.pink },
        ["@markup.environment.name"] = { fg = palette.light_blue, bold = true },

        -- 5. LSP SEMANTIC TOKENS
        -- Clear generic variable & comment semantic tokens so Tree-sitter captures shine through
        ["@lsp.type.variable"] = {},
        ["@lsp.type.comment"] = {},

        -- Semantic Token Types
        ["@lsp.type.boolean"] = { link = "@boolean" },
        ["@lsp.type.bracket"] = { link = "@punctuation.bracket" },
        ["@lsp.type.builtinType"] = { link = "@type.builtin" },
        ["@lsp.type.class"] = { link = "Type" },
        ["@lsp.type.decorator"] = { link = "@attribute" },
        ["@lsp.type.deriveHelper"] = { link = "@attribute" },
        ["@lsp.type.enum"] = { link = "@type" },
        ["@lsp.type.enumMember"] = { link = "@constant" },
        ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
        ["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
        ["@lsp.type.generic"] = { link = "@variable" },
        ["@lsp.type.interface"] = { fg = palette.light_blue },
        ["@lsp.type.keyword"] = { link = "@keyword" },
        ["@lsp.type.lifetime"] = { fg = palette.orange },
        ["@lsp.type.macro"] = { link = "@function.macro" },
        ["@lsp.type.method"] = { link = "@function.method" },
        ["@lsp.type.namespace"] = { link = "@module" },
        ["@lsp.type.number"] = { link = "@number" },
        ["@lsp.type.operator"] = { link = "@operator" },
        ["@lsp.type.parameter"] = { fg = palette.orange },
        ["@lsp.type.property"] = { link = "@variable.member" },
        ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
        ["@lsp.type.selfTypeKeyword"] = { link = "@variable.builtin" },
        ["@lsp.type.string"] = { link = "@string" },
        ["@lsp.type.struct"] = { link = "@type" },
        ["@lsp.type.typeAlias"] = { link = "@type.definition" },
        ["@lsp.type.typeParameter"] = { fg = palette.orange },
        ["@lsp.type.unresolvedReference"] = { undercurl = true, sp = palette.pink },

        -- Semantic Token Modifiers & Type+Modifier Combinations
        ["@lsp.mod.deprecated"] = { link = "DiagnosticDeprecated" },
        ["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" },
        ["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" },
        ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
        ["@lsp.typemod.function.defaultLibrary"] = { link = "Function" },
        ["@lsp.typemod.keyword.async"] = { link = "@keyword.coroutine" },
        ["@lsp.typemod.macro.defaultLibrary"] = { link = "@function.builtin" },
        ["@lsp.typemod.method.defaultLibrary"] = { link = "Function" },
        ["@lsp.typemod.operator.injected"] = { link = "@operator" },
        ["@lsp.typemod.parameter.declaration"] = { fg = palette.orange },
        ["@lsp.typemod.parameter.definition"] = { fg = palette.orange },
        ["@lsp.typemod.parameter.readonly"] = { fg = palette.orange },
        ["@lsp.typemod.string.injected"] = { link = "@string" },
        ["@lsp.typemod.struct.defaultLibrary"] = { link = "@type.builtin" },
        ["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },
        ["@lsp.typemod.typeAlias.defaultLibrary"] = { link = "@type.builtin" },
        ["@lsp.typemod.variable.callable"] = { link = "@function" },
        ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
        ["@lsp.typemod.variable.injected"] = { link = "@variable" },
        ["@lsp.typemod.variable.parameter"] = { fg = palette.orange },
        ["@lsp.typemod.variable.parameterScope"] = { fg = palette.orange },
        ["@lsp.typemod.variable.static"] = { link = "@constant" },
    }
end

return M
