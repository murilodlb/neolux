local colors = {
    bg         = "#000000", -- Black (Main Background)
    fg         = "#ffffff", -- White (Classes, vars, default text)
    gray1      = "#0c0c0c", -- formerly ui_bg (Darkest gray, for floats/statuslines)
    gray2      = "#3c3c3a", -- formerly ui_bg_alt (Mid gray, for line numbers/gutter)
    gray3      = "#57595B", -- formerly ui_bg_visual (Light gray, for visual selection/borders)
    orange     = "#f98800", -- Cursor, yank effect, args
    beige      = "#e6db74", -- Comments, docstrings
    light_blue = "#00ffff", -- Def, class, __init__, reserved words
    green      = "#01de82", -- Function names
    pink       = "#e20372", -- For, while, from, keywords
    yellow     = "#ffcc00", -- Brackets [, (, etc.
    purple     = "#8b53fe", -- None, NULL, inner brackets
    blue       = "#2495ff", -- Inner brackets
    dark_blue  = "#044b8b", -- Some text colors

    -- Dark subtle tints for diagnostics & diff backgrounds on pure black
    tint_pink   = "#2a0a16", -- Subtle red/pink tint (errors, deletions)
    tint_yellow = "#261e05", -- Subtle yellow tint (warnings, modifications)
    tint_blue   = "#091b2e", -- Subtle blue tint (info, diff changes)
    tint_green  = "#0d2614", -- Subtle green tint (ok, additions)
    tint_beige  = "#1f1d10", -- Subtle beige tint (hints)
    diff_text   = "#1a3b5c", -- Diff text inline change highlight
}

return colors
