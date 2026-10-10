# Personal Neovim configuration

Standalone Neovim with lazy.nvim, Solarized, nvim-tree, fzf-lua, Treesitter, native LSP, blink.cmp, Rails navigation and jj/Herdr review tools.

AI assistance and tests run in Herdr. Plugins, parsers and Mason tools are installed separately under ~/.local/share/nvim/personal, preserving the previous LazyVim runtime. Versions are pinned in the plugin specs and lazy-lock.json.

## Personal defaults

Comma leader; two-space indentation; relative numbers; displayed-line j/k, including counts; screen wrapping; textwidth 99 and a column-100 guide. Saving and clipboard copying are explicit. No formatting on save. Undo history persists with 10,000 levels. Whitespace markers, a global status line and save/discard/cancel confirmation are enabled. Ctrl-C and H/L retain native behavior. No custom split creation or Alt mappings.

## Shortcuts

Starting nvim without a file opens the Snacks dashboard, the same dashboard plugin used by LazyVim. Its keys are f (find files), n (new file), g (search text), r (recent files), p (recent projects), c (configuration), s (restore session), l (plugins), ? (Vim shortcuts), and q (quit). The homepage also shows a compact learning reminder. File/project choices use fzf-lua. Projects come from recently opened files in jj or Git repositories; choosing one changes directory and opens its file picker. Session restoration stays explicit.

Open the full [Vim field guide](doc/shortcuts.md) with ,h or :VimShortcuts from anywhere. It opens a read-only tab: / searches the guide, n/N move between matches, and q returns to your previous tab. It covers custom mappings, native motions, operators and text objects, registers, macros, splits, LSP, Rails and the Herdr review loop. Learn operator + motion first, then counts and the repeat command (.).

| Keys | Action |
| --- | --- |
| Ctrl-h/j/k/l | Navigate Neovim splits and adjacent Herdr panes |
| Ctrl-w s / Ctrl-w v | Native horizontal / vertical split |
| ,y / ,Y | Copy selection or line to system clipboard |
| ,Space / ,bd | Clear search highlights / delete buffer |
| ,p in visual mode | Replace selection while retaining the yank register |
| ,e | Toggle nvim-tree |
| ,tt / ,tg | Find files / search text using the current file's project root |
| ,tb / ,tr / ,tp | Open buffers / recent files / recent projects |
| ,h / :VimShortcuts | Searchable Vim shortcut guide |
| gd / gr / K | Definition / references / documentation |
| ,ts / ,tS | File / project symbols |
| ,df / ,xx / ,xX | Line / project / buffer diagnostics |
| ,jd / ,jf / ,jm | JJ change / file against parent / changes since main |
| ,jl / ,js | JJ log / status |
| ,ac / ,ar / ,at | Ask about code / follow up / choose Herdr agent |
| ,aa / ,al / ,ap / ,aS | Queue / list / preview / send review comments |
| ]r / [r / ,ak | Next / previous tracked agent edit / mark reviewed |
| ,cf / ,cl | Format explicitly / run linters |
| ,ra / ,rr | Rails alternate / related file |
| ,rm / ,rc / ,rv | Rails model / controller / view lookup |
| sa / sd / sr | Add / delete / replace surrounding text |
| gcc / gc | Native comment line / selection |
| ]m / [m / af / if | Next / previous function / outer / inner function text |
| ,qs / ,qS / ,ql / ,qd | Restore / choose / last session / stop session saving |
| ,mp | Toggle Markdown rendering |
| ,tT / ,xt | Find TODOs / TODO diagnostic list |
| ,? | Show buffer keybindings |

:Mason is available at startup and manages the selected language servers. :InstallTools installs the selected standalone formatting/linting tools. Neovim's native LSP uses vim.lsp.config/vim.lsp.enable, with nvim-lspconfig supplying server definitions and mason-lspconfig installing/enabling them.

Formatting is explicit and follows repository tooling. Ruby uses project Bundler and its RuboCop rules. Web files use the local Biome binary when a biome.json/biome.jsonc exists; Biome itself determines whether formatting is enabled for the file. Unsupported or disabled formats do not fall back to another formatter. Prettier runs only where the repository supplies a local executable. ERB uses the local Herb formatter with .herb.yml. No LSP formatting fallback or automatic fixes on save are enabled.

| Project/files | Navigation and diagnostics | Explicit formatting |
| --- | --- | --- |
| Shirabe Ruby/Rails | Ruby LSP with project RuboCop diagnostics; vim-rails | Bundled RuboCop, including Rails Omakase rules |
| Shirabe HTML/ERB | Herb LSP plus Ruby LSP | Project Herb formatter |
| Shirabe JavaScript/JSON | vtsls / JSON LSP plus project Biome | Project Biome |
| Shirabe Markdown/YAML | Marksman / YAML LSP | Project Prettier |
| Nadeshiko TypeScript | vtsls plus project Biome | Project Biome |
| Nadeshiko Vue | Vue LSP, vtsls, Biome and Tailwind | Disabled by the repository's Biome setup |

vtsls prefers each workspace's TypeScript SDK and enables the Vue plugin with it. Biome and Herb start in their project directories even when Neovim was launched elsewhere. Java/Kotlin use the installed Homebrew Java 21 runtime when JAVA_HOME is unset. Other language tooling remains configured through lua/config/languages.lua and lua/config/tools.lua.

:ConformInfo shows formatter availability for the current file; :checkhealth vim.lsp shows language-server status. Diagnostics come from language servers and nvim-lint; Treesitter handles syntax highlighting, folding and text objects, with Solarized supplying colors. Mason installs tools; it does not itself run formatting or lint checks.

CodeDiff/jj review supports Git-backed jj repositories. Git staging/discard maps and jj.nvim push shortcuts are disabled; use the checked jj push alias in Herdr.

File and text search resolve the nearest jj or Git root from the current regular file, falling back to the working directory in special buffers or outside a repository. Search leaves the working directory unchanged. Dashboard searches use the same policy, with the configuration button explicitly searching this config.

CodeDiff is the visual old/new code viewer used by ,jd (current jj change), ,jf (current file against its parent) and ,jm (current work against main). Within it, ]c/[c navigate hunks, ]f/[f navigate files, t toggles inline/side-by-side, gf opens the real file for inspection or annotations, g? shows help and q closes the diff tab. Repository diffs include everyone's work; they are not an agent attribution mechanism.

The local david.review Herdr plugin adds Ctrl-a then r: open/reuse a checkout review beside the invoking pane, or return from review to that pane. In the managed editor, ,ab / :HerdrReviewReturn also return; q closing CodeDiff returns while retaining files, unsaved edits and comments. Narrow panes start inline. Questions and batch comments explicitly target the invoking agent; ,at selects another target or accepts a replacement session. No messages are sent just by opening or leaving review. The adapter lives in lua/config/herdr_review.lua and is activated only by the dedicated launcher. See [the review design](doc/herdr-review-proposal.md) for the current implementation and deferred checkpoints/agent attribution.

## Backup and validation

Migration backups remain local and are not included in this repository.

Run `python3 -B tests/check-config.py` after installing the pinned plugins. The
check starts Neovim headlessly with temporary state and cache directories. It
checks startup, editor defaults, review dependencies, project roots, the shortcut
guide, and preservation of unsaved edits without desktop or clipboard input.

Validated with Neovim 0.12.1: actual pinned plugin installs, 28 parsers, Rust blink and CodeDiff native libraries, startup in a background terminal, Ruby symbols, Vue/TypeScript and Lua definitions, Vue/Svelte comments, Rails file navigation, watched reload preserving unsaved edits, and explicit formatting. Actual Shirabe/Nadeshiko checks also pass from outside either project: Ruby/RuboCop, Biome and Herb diagnostics, repository formatting rules, Vue definition navigation, disabled Vue formatting and disabled Herb fixes on save. The dashboard was checked in background terminals: empty startup, all menu keys, real fzf project selection, explicit session behavior, restored status line and direct file startup. All 33 selected Mason packages are installed. Other language tools are configured but have not been checked against real projects. Herdr companion actions are registered and its configuration reloads cleanly. Live pane navigation and sending agent prompts were not exercised.
