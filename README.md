# Neovim on macOS

A fast, keyboard-first Neovim 0.12 setup for macOS, tuned for C++/Kokkos,
code porting, Python, Rust, Markdown, and a visible Codex CLI panel.

## First launch

Requirements:

- Neovim 0.12+
- Git, a C compiler, CMake, Ninja, ripgrep, and fd
  (`brew install neovim cmake ninja ripgrep fd`)
- Codex CLI (`codex`) for the AI panel

Install and launch:

```sh
git clone https://github.com/moaziat/nvim.git ~/.config/nvim
nvim
```

Lazy installs plugins automatically. Mason then installs the configured
language servers and formatters in the background. Use `:Lazy`, `:Mason`, and
`:checkhealth` to inspect them.

The UI uses readable text and restrained status signs. A Nerd Font is
recommended for the colored file and folder icons in the explorer.

## Daily keys

`<leader>` is Space. Press Space and pause to see the available groups.

| Key | Action |
| --- | --- |
| `Space Space` | Smart file picker |
| `Space f f` / `Space f g` | Find files / search project text |
| `Space e` or `Ctrl-n` | File explorer |
| `Space ,` | Switch buffer |
| `Shift-h` / `Shift-l` | Previous / next buffer |
| `Ctrl-h/j/k/l` | Move between windows |
| `Ctrl-s` | Save |
| `Space c a` / `Space c r` | LSP code action / rename |
| `g d` / `g r` / `K` | Definition / references / hover |
| `[d` / `]d` | Previous / next diagnostic |
| `Space x x` | Diagnostics panel |
| `Space c f` | Format buffer or selection |
| `Space u f` | Toggle format-on-save |
| `Space u m` | Toggle rendered Markdown |
| `Space u t` | Toggle GitHub light / Fluoromachine dark |
| `s` | Fast jump anywhere visible |
| `g s a` / `g s d` / `g s r` | Add / delete / replace surroundings |
| `Space t t` or `Ctrl-/` | Floating shell |
| `Space m c` / `Space m b` | Configure / build CMake project |
| `Space m r` / `Space m t` | Run / select CMake target |
| `Esc Esc` | Leave terminal input mode |

The sidebar uses theme-colored file icons, tree guides, current-file and Git
highlights, and always sorts folders above files. Inside it, use `Enter` or `l`
to open, `h` to close a folder, `v` for a vertical split, `s` for a horizontal
split, and `?` for the complete explorer help. It remains rooted at the
directory where Neovim was launched.

The default theme is Fluoromachine on a neutral graphite background, with
explicit Tree-sitter and LSP semantic colors for types, functions, methods,
members, macros, decorators, and parameters. `Space u t` switches between the
graphite Fluoromachine dark mode and GitHub Light Default for a polished,
high-readability daytime view.

Normal yanks and puts use the macOS system clipboard. In Terminal, iTerm2, or
Ghostty, Command-C and Command-V continue to work at the terminal level.

## Codex inside Neovim

This uses the community `nwiizo/codex.nvim` integration over the official
Codex CLI. The full Codex TUI opens in a right-hand split: prompts, tool calls,
approvals, and output remain visible while the code stays beside it.

Run `codex` once in a shell first and sign in if needed.

| Key | Action |
| --- | --- |
| `Space a a` | Open, focus, or hide Codex |
| `Space a q` | Ask about the current file |
| Visual `Space a q` | Draft a question with the exact selection |
| Visual `Space a e` | Request an edit to the selection |
| Visual `Space a s` | Send the selection immediately |
| `Space a f` | Add the current file to the conversation |
| `Space a r` | Resume a previous Codex session |
| `Space a R` | Ask Codex to review uncommitted changes |
| `Space a i` / `Space a x` | Interrupt / stop Codex |
| `Space a h` | Check the Codex integration and executable |

Codex edits are never staged automatically. Changed lines appear immediately
through Git signs. Use `Space g p` to preview one hunk or `Space g d` for a
side-by-side review of the whole working tree. Stage or reset hunks explicitly
with `Space g s` and `Space g r`.

The terminal backend is intentional: it is the stable, transparent workflow.
It launches the official CLI directly from a stable install path, gives each
Neovim instance its own process, and preserves the terminal transcript if the
process exits. Every Neovim Codex session starts in the `workspace-write`
sandbox with `on-request` approvals: it can work inside the project where
Neovim was launched, but must ask before accessing anything outside that
boundary. Terminal jobs are excluded from saved Neovim sessions so a restore
cannot revive a stale Codex PID or temporary launcher path. Press `Space a a`
to start a fresh process after an exit; use `Space a h` or `:CodexHealth` if
startup fails.

The plugin's native app-server UI can show application-managed diffs, but that
upstream protocol is still experimental.

Official references: [Codex CLI](https://learn.chatgpt.com/docs/codex/cli) and
[Codex IDE support](https://learn.chatgpt.com/docs/codex/ide).

## Languages and projects

The left file explorer opens automatically and stays rooted at the directory
where Neovim was launched. File search, text search, recent files, and Codex use
that same boundary, so a session opened in one project does not browse sibling
or parent directories.

Configured language servers: C/C++/CUDA/HIP through clangd, CMake, Python,
Rust, Lua, Bash, JSON, YAML, and JavaScript/TypeScript. Completion uses Blink
with VS Code-style Tab acceptance, snippets, signatures, documentation, paths,
and buffer words.

Python projects prefer `.venv/bin/python`, then `venv/bin/python`, then the
active environment. Ruff formats and lints Python. For C++ and CUDA, generate
`compile_commands.json` for accurate clangd completion:

```sh
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -S . -B build
```

For Kokkos, configure with the compiler/backend needed by that project. clangd
reads the resulting compile database, including Kokkos include paths and
backend defines:

```sh
cmake -S . -B build -G Ninja \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DKokkos_ENABLE_OPENMP=ON
```

Use a project `CMakePresets.json` for CUDA/HIP/cluster-specific toolchains;
`Space m p` selects a preset, and `Space m b` builds it.

clangd is used for completion and code navigation only. Its diagnostics are
always hidden, avoiding false errors in Kokkos, generated, and remotely built
code.

Format-on-save is enabled by default and uses StyLua, Ruff, shfmt,
clang-format, rustfmt, or Prettier according to filetype. Set `vim.b.disable_autoformat =
true` for one buffer, or use `Space u f` globally for the current session.

Useful maintenance commands:

- `:Lazy sync` — update plugins
- `:Mason` — inspect language tools
- `:TSUpdate` — update Tree-sitter parsers
- `:ConformInfo` — inspect formatting
- `:CodexHealth` — inspect Codex integration
- `:checkhealth` — inspect the full editor
