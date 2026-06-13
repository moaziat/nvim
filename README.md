neovim config

install
- backup existing config: `mv ~/.config/nvim ~/.config/nvim.bak`
- clone this repo: `git clone https://github.com/moaziat/nvim.git ~/.config/nvim`
- open nvim; if plugins are missing, run `:Lazy sync` once

python / uv
- run `uv sync` in a project so `.venv/bin/python` exists
- pyright uses the project `.venv` automatically; activating the venv before starting nvim is optional
- save-time lint uses `.venv/bin/ruff` first, then global `ruff`, then `pylint`; if none exists it quietly skips linting

c++ / kokkos
- install `clangd` with `:MasonInstall clangd` or through the system package manager
- generate compile commands for real Kokkos projects: `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ...`
- clangd is configured for background index, clang-tidy, CUDA filetypes, and common compiler wrappers

use
- save: `Ctrl+s` or `Space w`
- file tree: `Ctrl+n` or `Space e`
- terminal: `T` or `Space t t`; from terminal press `E` for normal mode
- diagnostics: `[d`, `]d`, `Space q`
- LSP once a server attaches: `gd`, `K`, `gr`, `Space rn`, `Space ca`, `Space l f`
- clipboard copy/paste: `Ctrl+C` / `Ctrl+V`

notes
- Mason no longer auto-installs tools at startup; use `:Mason` or `:MasonInstall pyright clangd` manually
- this config pins `nvim-lspconfig` to `v1.8.0` because the installed Neovim is 0.9.5
- when Neovim is upgraded to 0.10+ or 0.11+, the LSP pin can be relaxed
- treesitter: update with `:TSUpdate`
- plugins: `:Lazy sync`
