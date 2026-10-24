# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.3] - 2026-10-24

### Added
- **Bytecode Compilation & Cache (`lua/neolux/compiler.lua`)**: Added a LuaJIT bytecode compiler (`string.dump`) with automatic SHA-256 cache invalidation (`stdpath("cache") .. "/neolux"`) and `:NeoluxCompile` / `:NeoluxClean` user commands for faster startup.
- **WezTerm Theme Extras (`extras/wezterm/`)**: Added standalone WezTerm colorscheme configurations in both Lua (`neolux.lua`) and TOML (`neolux.toml`) formats.
- **Documentation & Healthcheck**: Added comprehensive Portuguese Vimdoc (`doc/neolux.txt` for `:help neolux`) and a healthcheck module (`lua/neolux/health.lua` for `:checkhealth neolux`).
- **CI & Code Formatting**: Added GitHub Actions workflow (`.github/workflows/ci.yml`) and StyLua configuration (`.stylua.toml`).
- **Visual Assets**: Updated project logo (`media/logo.html`, `media/logo.png`) with Adwaita typography and refreshed the editor preview (`media/screenshot.png`).
- **Programmatic Version Tracking**: Added `require("neolux").version` (`"0.0.3"`) in `lua/neolux/init.lua`.

### Changed
- **Palette Refinements (`lua/neolux/palette.lua`)**: Tuned core accent and UI shades for sharper contrast on `#000000` (`light_blue` `#55efef`, `green` `#2fff73`, `pink` `#f84285`, `yellow` `#ffcc00`, `purple` `#723ec3`, `blue` `#2495ff`, `dark_blue` `#044b8b`, `orange` `#f98800`, and `gray2` `#3c3c3a`) and synchronized WezTerm extras.
- **Editor UI Tweaks (`lua/neolux/editor.lua`)**: Updated `PmenuMatch` and `PmenuMatchSel` to highlight matched completion characters in `palette.green`, and softened `TabLineFill` to `palette.gray1`.
- **Codebase Formatting**: Standardized formatting across all core, Lualine, and plugin modules via StyLua.

### Fixed
- **Tree-sitter Keyword Weights (`lua/neolux/syntax.lua`)**: Removed unintended bold styling from `@keyword.function` (`def`, `function`) and `@keyword.type` (`class`, `struct`).
- **Parameter Highlighting (`lua/neolux/syntax.lua`)**: Fixed `@variable.parameter` foreground color to use `palette.fg` (`#ffffff`).
- **Line Number Contrast (`lua/neolux/editor.lua`)**: Fixed `LineNr` to use muted `palette.gray2` instead of `palette.orange`, keeping focus on the active `CursorLineNr`.

## [0.0.2] - 2026-10-20

### Added
- **User Configuration API (`lua/neolux/config.lua`)**: Added `require("neolux").setup(opts)` supporting `transparent`, `italic_comments`, `styles`, `on_colors`, `on_highlights`, and automatic `lazy.nvim` plugin detection (`plugins = { auto = true }`).
- **Modular Plugin Architecture (`lua/neolux/plugins/`)**: Added dedicated plugin highlight modules for `blink.cmp`, `nvim-cmp`, `telescope.nvim`, `bufferline.nvim`, `gitsigns.nvim`, `neo-tree.nvim`, `lazy.nvim`, `mason.nvim`, `indent-blankline.nvim` / `mini.indentscope`, and `rainbow-delimiters.nvim`.
- **Core Editor & Diagnostic Groups (`lua/neolux/editor.lua`)**: Added full support for `Diff*`, `Added`/`Changed`/`Removed`, `Spell*` undercurls, `DiagnosticSign*`, `DiagnosticUnderline*`, `DiagnosticVirtualText*` dark background tints, `PmenuKind*`/`PmenuExtra*`/`PmenuMatch*`, `WinBar*`, `Folded`, and ANSI bright terminal colors (`terminal_color_8`–`15`).
- **Tree-sitter & LSP Semantic Tokens (`lua/neolux/syntax.lua`)**: Added dedicated Tree-sitter CSS captures (`@tag.css`, `@property.css`, `@variable.css`, etc.), JSX/TSX/Vue/Svelte punctuation captures, and LSP parameter semantic token modifiers (`@lsp.type.parameter`, `@lsp.typemod.parameter.*`).
- **Exported Palette**: Exposed `require("neolux").colors` for reuse in user configurations and Lualine.

### Fixed
- **Dark Blue Contrast**: Fixed unreadable `dark_blue` text on pure black backgrounds in `syntax.lua` and `lualine`.
- **Duplicate Highlight Overrides**: Removed redundant `Diff*`, `GitSigns*`, and `Diagnostic*` definitions from `syntax.lua` that previously overwrote `editor.lua`.

## [0.0.1] - 2026-09-03

### Added
- Initial release of **Neolux** (formerly *Murikai*), a pure-Lua high-contrast Neovim colorscheme built on a pure black (`#000000`) background.
- Core editor (`lua/neolux/editor.lua`), syntax/Tree-sitter (`lua/neolux/syntax.lua`), and Lualine (`lua/lualine/themes/neolux.lua`) theme modules.
- Installation guides in `README.md` for `lazy.nvim`, LazyVim, native Neovim packages, `packer.nvim`, and `vim-plug`.
