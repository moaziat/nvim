# Neovim setup for macOS and Ubuntu

A fast, keyboard-first Neovim configuration with completion, formatting,
Tree-sitter highlighting, Git tools, a project-scoped file explorer, and an
optional Codex panel.

## Supported systems

- macOS with Homebrew and the Xcode Command Line Tools
- Ubuntu 24.04 or newer on x86_64 or ARM64

The installer adds only missing editor dependencies:

- Neovim 0.11 or newer
- Git
- ripgrep
- fd
- Node.js and npm, used by Mason-managed editor tools
- a C compiler for native plugins and Tree-sitter parsers
- standard archive/download tools used by the plugin and tool managers

On macOS, missing packages come from Homebrew. On Ubuntu, they come from the
standard Ubuntu repositories. If Ubuntu's Neovim is absent or older than 0.11,
the installer uses a pinned official Neovim release under `~/.local/share` and
verifies its SHA-256 checksum before running it.

The installer does not add third-party package repositories, install Homebrew,
modify shell startup files, delete an existing configuration, or pipe a remote
script into a shell. On Ubuntu, it asks before using `sudo` for a fixed list of
missing `apt` packages. macOS dependency installation does not use `sudo`.

## Install

### Fresh installation

```sh
git clone https://github.com/moaziat/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
"${XDG_CONFIG_HOME:-$HOME/.config}/nvim/install.sh"
nvim .
```

The installer downloads the pinned plugins. Mason installs the configured
editor tools in the background during the first Neovim launch.

### Replace an existing Neovim configuration

Clone this repository somewhere temporary and request an explicit backup:

```sh
git clone https://github.com/moaziat/nvim.git /tmp/moaziat-nvim
cd /tmp/moaziat-nvim
./install.sh --backup
```

The old configuration is moved to a timestamped sibling such as
`~/.config/nvim.backup.YYYYMMDD-HHMMSS`. Nothing is overwritten in place.

### Installer options

```text
./install.sh [--backup] [--with-codex] [--yes] [--dry-run]
```

- `--backup` preserves and replaces an existing Neovim configuration.
- `--with-codex` installs the optional official Codex CLI npm package under
  `~/.local`.
- `--yes` accepts the package and download confirmations. A sudo password may
  still be required on Ubuntu.
- `--dry-run` reports what would change without changing anything.

Codex is deliberately optional. After installing it, run `codex` once in a
terminal and complete sign-in. See the
[official Codex CLI documentation](https://developers.openai.com/codex/cli/).

### PATH on Ubuntu

Ubuntu normally adds `~/.local/bin` to `PATH` after the next login. If `nvim`
or `codex` is not found immediately, start a new login session or add this to
your shell configuration yourself:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

The installer reports this when it matters but never edits shell files.

## Manual dependency installation

### macOS

Install the Xcode Command Line Tools and the required Homebrew packages:

```sh
xcode-select --install
brew install neovim git ripgrep fd node
```

### Ubuntu

Install the system dependencies:

```sh
sudo apt update
sudo apt install --no-install-recommends git ripgrep fd-find nodejs npm \
  build-essential curl ca-certificates tar unzip
```

Ubuntu names the `fd` executable `fdfind`. The installer creates a user-local
`fd` symlink automatically. For Neovim itself, use version 0.11 or newer; the
[official Neovim installation page](https://neovim.io/doc/install/) provides
current Linux binaries if the Ubuntu package is older.

Then clone and start the configuration:

```sh
git clone https://github.com/moaziat/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim .
```

A Nerd Font is optional but recommended for file icons. Readable text labels
are used when one is unavailable.

## First launch

Use these commands if an automatic installation was interrupted:

```vim
:Lazy install
:MasonToolsInstall
:TSUpdate
:checkhealth
```

The file explorer, file search, text search, recent files, and Codex session
remain rooted at the directory where Neovim was launched. Start Neovim from the
project you want to work in:

```sh
cd /path/to/project
nvim .
```

## Essential keys

`<leader>` is `Space`. Press `Space` and pause to discover the available key
groups.

| Key | Action |
| --- | --- |
| `Space Space` | Smart file picker |
| `Space f f` / `Space f g` | Find files / search project text |
| `Space e` or `Ctrl-n` | Toggle the file explorer |
| `Space ,` | Switch buffers |
| `Ctrl-h/j/k/l` | Move between windows |
| `Ctrl-s` | Save |
| `Space c f` | Format the buffer or selection |
| `Space u f` | Toggle format-on-save |
| `Space u t` | Toggle GitHub light / Fluoromachine dark |
| `Space t t` or `Ctrl-/` | Open a floating terminal |
| `Space a a` | Open, focus, or hide Codex |
| Visual `Space a q` | Ask Codex about the selection |
| Visual `Space a e` | Request an edit to the selection |

Inside the explorer, use `Enter` or `l` to open, `h` to close a folder, `v`
for a vertical split, `s` for a horizontal split, and `?` for help. Folders
are always sorted above files.

## Update

For an installation cloned directly into the Neovim configuration directory:

```sh
git -C "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" pull --ff-only
nvim --headless "+Lazy! restore" +qa
```

`Lazy restore` follows the committed lockfile instead of unexpectedly updating
every plugin.

## Remove

The installer does not provide an uninstall command because deleting user
configuration should remain an explicit decision. Removing the configuration
does not remove Homebrew packages, Ubuntu packages, Mason tools, local Neovim
releases, Codex, or backups.
