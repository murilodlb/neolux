-- Neolux colorscheme for WezTerm
-- Usage in wezterm.lua:
-- config.colors = dofile("/path/to/neolux/extras/wezterm/neolux.lua")

return {
    -- Default Colors
    foreground = "#ffffff",
    background = "#000000",

    -- Cursor Colors
    cursor_bg = "#f98800",
    cursor_fg = "#000000",
    cursor_border = "#f98800",

    -- Selection Colors
    selection_fg = "#000000",
    selection_bg = "#ffffff",

    -- UI Chrome
    scrollbar_thumb = "#57595B",
    split = "#57595B",

    -- Standard ANSI Colors (The base 8 colors)
    ansi = {
        "#0c0c0c", -- black   (gray1)
        "#D90000", -- red
        "#2fff73", -- green   (green)
        "#ffcc00", -- yellow  (yellow)
        "#044b8b", -- blue
        "#723EC3", -- magenta (purple)
        "#55efef", -- cyan    (light_blue)
        "#ffffff", -- white   (fg)
    },

    -- Bright ANSI Colors (The 8 bright/bold colors)
    brights = {
        "#3c3c3a", -- bright black   (gray2)
        "#f84285", -- bright red     (pink)
        "#08CB00", -- bright green   (green)
        "#e6db74", -- bright yellow  (beige - distinct from standard yellow)
        "#2495ff", -- bright blue    (blue)
        "#8b53fe", -- bright magenta (purple)
        "#92EEFF", -- bright cyan    (light_blue)
        "#ffffff", -- bright white   (fg)
    },

    -- Tab Bar
    tab_bar = {
        background = "#000000",
        active_tab = {
            bg_color = "#000000",
            fg_color = "#ffffff",
            intensity = "Bold",
        },
        inactive_tab = {
            bg_color = "#0c0c0c",
            fg_color = "#57595B",
        },
        inactive_tab_hover = {
            bg_color = "#3c3c3a",
            fg_color = "#ffffff",
        },
        new_tab = {
            bg_color = "#0c0c0c",
            fg_color = "#57595B",
        },
        new_tab_hover = {
            bg_color = "#f98800",
            fg_color = "#000000",
            intensity = "Bold",
        },
    },
}
