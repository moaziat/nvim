neovim config

install
- backup existing config: `mv ~/.config/nvim ~/.config/nvim.bak`
- clone this repo: `git clone https://github.com/moaziat/nvim.git ~/.config/nvim`
- open nvim and let lazy/mason install plugins and LSPs

use
- toggle bottom terminal: `T`
- back to editor from terminal: `E`
- nvimtree: `Ctrl+n` or `Space e`
- find files: `Space f f`
- live grep: `Space f g`
- clipboard copy/paste: `Ctrl+C` / `Ctrl+V`

notes
- terminal uses your current shell from `$SHELL`
- treesitter: update with `:TSUpdate`
- plugins: `:Lazy sync`
