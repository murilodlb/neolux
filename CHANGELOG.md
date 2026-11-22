# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.6] - 2026-11-22

### Added
- **Granular Float & Sidebar Styles (`lua/neolux/config.lua`, `lua/neolux/editor.lua`, `lua/neolux/plugins/`)**: Added `styles.floats` (default: `"dark"`) and `styles.sidebars` (default: `"normal"`) accepting `"dark"`, `"transparent"`, or `"normal"`, powered by `config.resolve_bgs` across floating windows, popups, pickers, and sidebars while keeping `NotifyBackground` opaque.
- **Single-Source Extras Generator & New CLI Themes (`scripts/generate_extras.lua`, `extras/fzf/`, `extras/tmux/`)**: Added a headless generator that builds all 7 theme files under `extras/` directly from `palette.lua` and `config.lua` (with `NEOLUX_EXTRAS_CHECK=1` wired into CI to prevent drift), and introduced official `fzf` (`extras/fzf/neolux.sh`) and `tmux` (`extras/tmux/neolux.tmux`) extras.
- **Expanded Tree-sitter & LSP Semantic Token Coverage (`lua/neolux/syntax.lua`)**: Added modern Tree-sitter captures (`@comment.error`/`warning`/`todo`/`note`/`documentation`, `@diff.*`, `@markup.math`/`quote`/`strikethrough`/`environment`, `@function.macro`, `@number.float`, `@keyword.modifier`, `@string.special.*`), expanded `@lsp.type.*` / `@lsp.typemod.*` / `@lsp.mod.deprecated` definitions, and explicitly cleared `@lsp.type.variable` and `@lsp.type.comment` so semantic tokens do not flatten richer Tree-sitter highlights.
- **Core Neovim UI Groups (`lua/neolux/editor.lua`)**: Added `Conceal`, `Whitespace`, `SpecialKey`, `lCursor`, `CursorIM`, `TermCursor`, `TermCursorNC`, `SnippetTabstop`, `Substitute`, `QuickFixLine`, `WildMenu`, `MsgArea`, `MsgSeparator`, and `FloatFooter`.
- **Multi-Language Documentation (`README.md`, `README.en.md`, `README.es.md`)**: Expanded the README with full configuration options, supported plugins, terminal extras, and benchmark metrics, and added English and Spanish translations.
- **Regression Tests (`tests/run.lua`)**: Added tests covering closure upvalue hashing, older-`mtime`/size source fingerprinting, ANSI terminal parity, dangling link checks across `editor.lua` and `syntax.lua`, `styles.floats`/`styles.sidebars` modes, transparent surfaces, and generated `extras/` validation.

### Changed
- **Terminal ANSI Palette Sync (`lua/neolux/palette.lua`, `lua/neolux/config.lua`)**: Added `red`, `bright_green`, `bright_yellow`, `bright_purple`, `bright_cyan`, and `bright_white` to the palette and aligned `terminal_color_0`–`15` with the 16-color ANSI palette in `extras/`.
- **Source Fingerprinting & Cache Version (`lua/neolux/compiler.lua`)**: Replaced max-`mtime` tracking with a sorted hash of every `.lua` file's relative path, size, and `mtime` (catching branch switches and older restored timestamps), and bumped `CACHE_FORMAT_VERSION` to `3`.
- **Dynamic Plugin Registry & Cleanup (`lua/neolux/config.lua`, `lua/neolux/editor.lua`, `lua/neolux/syntax.lua`, `lua/neolux/plugins/init.lua`)**: Derived `plugin_repos` and `plugin_modules` dynamically from `plugin_map` and removed unused `M.setup` functions.
- **Statusline, Tabline & File Explorer Consistency (`lua/lualine/themes/neolux.lua`, `lua/neolux/editor.lua`, `lua/neolux/plugins/`)**: Switched active mode badge text in `lualine` and `mini.statusline` and `TabLineSel` foreground to `#000000` (`palette.bg`) for sharper contrast, and aligned `neo-tree.lua` colors and separators with `nvim-tree.lua`.

### Fixed
- **Bytecode Compiler Directory Scan & Closure Upvalues (`lua/neolux/compiler.lua`)**: Fixed `fs_scandir_next` return truncation that caused redundant `fs_stat` calls on every entry, and updated `serialize_for_hash` to inspect callback upvalues (with table cycle protection) so editing captured local variables properly invalidates the cache.
- **Transparent Mode Blind Spots (`lua/neolux/editor.lua`, `lua/lualine/themes/neolux.lua`, `lua/neolux/plugins/`)**: Cleared backgrounds in transparent mode for `TelescopePreview*`, `BufferLine*`, `MiniTabline*`, and `lualine`, and switched `EndOfBuffer` foreground to `palette.gray2` when transparent so `~` markers do not appear as harsh black glyphs.
- **Rainbow Delimiters Color Mapping (`lua/neolux/plugins/rainbow-delimiters.lua`)**: Fixed swapped `RainbowDelimiterYellow` and `RainbowDelimiterRed` assignments so each group matches its semantic color name.
- **Documentation & Asset Hex Drift (`doc/neolux.txt`, `media/logo.html`)**: Updated `purple` in Vimdoc (`#9c6de7`) and `.c-light-blue` in `media/logo.html` (`#55efef`) to match `palette.lua`, and documented `styles.floats` and `styles.sidebars` in `doc/neolux.txt`.

## [0.0.5] - 2026-11-19

### Added
- **Plugin Integrations (`lua/neolux/plugins/`)**: Added 12 new highlight modules, growing from 10 to 22 modules (31 mapped repositories): `snacks.nvim`, `which-key.nvim`, `noice.nvim`, `flash.nvim`, `trouble.nvim`, `render-markdown.nvim`, `fzf-lua`, `todo-comments.nvim`, `nvim-tree.lua`, `mini.nvim` (including standalone `mini.*` repositories), `diffview.nvim` and `nvim-notify`. Sidebar, gutter and dashboard groups respect `transparent`, and `NotifyBackground` always uses `palette.bg` so `nvim-notify` never warns.
- **Headless Regression Test Suite (`tests/run.lua`)**: Added 27 tests covering cached/uncached highlight parity, link target resolution, `lazy.nvim` auto-detection and `transparent = true` behavior. The suite now runs in CI (`.github/workflows/ci.yml`).
- **Benchmark Harness (`scripts/benchmark.lua`)**: Added load-time measurement for uncached, cold-cache and warm-cache scenarios.
- **Function Keyword Style (`lua/neolux/syntax.lua`)**: Added `function_kw_style`, with a commented-out `italic = true` attribute reserved for a future version.

### Changed
- **Cache Signature (`lua/neolux/compiler.lua`)**: Replaced `vim.fn.sha256` and `vim.inspect` with a LuaJIT 64-bit hash and a dynamic `mtime` scan of every `.lua` file under `lua/neolux/`, removing the Vimscript bridge.
- **Compiled Bytecode (`lua/neolux/compiler.lua`)**: Hex colors are emitted as 24-bit integer RGB values, repeated tables are deduplicated, `compiled.luac` is written atomically, and a read-only cache directory falls back gracefully.
- **Registry Refactor (`lua/neolux/config.lua`, `lua/neolux/init.lua`, `lua/neolux/plugins/init.lua`)**: Deduplicated plugin registries, terminal colors (now set in a loop from `config.terminal_colors`) and palette copies (`vim.deepcopy` replaced by a shallow copy through the shared `resolve_colors`). `vim.fn.exists("syntax_on")` became `vim.g.syntax_on`.
- **Indent Scope Groups**: Moved `MiniIndentscopeSymbol` and `MiniIndentscopePrefix` from `indent-blankline.lua` to `mini.lua`.
- **Documentation (`README.md`, `doc/neolux.txt`)**: Updated the cache section and the supported plugin list.

### Fixed
- **Keyword Weights (`lua/neolux/syntax.lua`)**: `@keyword.function` and `@keyword.type` (e.g. `def`, `class`) are no longer bold and still inherit user customizations from `styles.keywords`. `with_style` now ignores empty style tables.
- **Hash Finalizer (`lua/neolux/compiler.lua`)**: Fixed the avalanche of the 64-bit hash finalizer and a test that depended on a relative `mtime`.

## [0.0.4] - 2026-11-01

### Added
- **Ghostty Theme Extras (`extras/ghostty/`)**: Added official Ghostty colorscheme configuration files (`neolux` extensionless and `neolux.conf`) supporting the 16-color ANSI/Brights palette, `#000000` background, `#f98800` cursor, and `#57595b` split dividers.
- **Kitty Theme Extras (`extras/kitty/`)**: Added official Kitty theme (`neolux.conf`) supporting `color0`–`color15`, window borders, tab bar styling, and URL underline highlights.
- **Modern LSP Highlight Groups (`lua/neolux/editor.lua`)**: Added `LspInlayHint` for Neovim 0.10+ native inline hints, `LspSignatureActiveParameter` for parameter highlights in signature help popups, `DiagnosticDeprecated` for strikethrough deprecated APIs, and `DiagnosticUnnecessary` for dimmed unused imports/variables.

### Changed
- **Parameter Highlighting (`lua/neolux/syntax.lua`)**: Aligned `@variable.parameter` to `palette.orange` so function parameter definitions consistently match LSP parameter highlights, while general variables (`@variable`, `@lsp.type.variable`) remain clean white (`palette.fg`).
- **Autocomplete Match Colors (`cmp.lua`, `blink.lua`)**: Updated `CmpItemAbbrMatch`, `CmpItemAbbrMatchFuzzy`, and `BlinkCmpLabelMatch` to `palette.green`, standardizing with Neovim's native `PmenuMatch`.
- **WezTerm Palette Sync (`extras/wezterm/`)**: Synchronized 16-color ANSI and Brights palettes across `neolux.lua` and `neolux.toml`.

### Fixed
- **Tree-sitter Markdown Headings & Links (`lua/neolux/syntax.lua`)**: Fixed capture group names from `@markup.heading.*.markdown` to standard `@markup.heading.1` through `@markup.heading.6` (and `@markup.link.url`/`label`), restoring distinct multi-colored heading levels in Markdown documents.
- **Keyword Weights & Customization (`lua/neolux/syntax.lua`)**: `@keyword.function` and `@keyword.type` now default to `bold = false` while properly inheriting user customizations via `styles.keywords = { italic = true }`.
- **Invalid LSP Semantic Group (`lua/neolux/syntax.lua`)**: Removed malformed `@lsp.mod.declaration.parameter` group.

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
