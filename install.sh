#!/bin/sh

set -eu

program_name=${0##*/}
with_codex=0
backup_existing=0
assume_yes=0
dry_run=0

# Ubuntu's Neovim package can be older than this config supports. The fallback
# is an immutable official release with checksums taken from GitHub's release
# metadata, rather than a third-party repository or a remote install script.
linux_nvim_version=v0.12.5
linux_nvim_x86_64_sha256=bce0f56eda1f1b1db6eee8f4133d7a38813ea07933837dd1777411ca384c6875
linux_nvim_arm64_sha256=1aa5ca085249580ae0f91eb14f27ec0919773ff2d99a163d03f3d6c21ac29725

usage() {
  cat <<EOF
Usage: $program_name [--backup] [--with-codex] [--yes] [--dry-run]

Install this Neovim configuration on macOS or Ubuntu with minimal dependencies.

  --backup       Move an existing Neovim config to a timestamped backup
  --with-codex   Install the optional official Codex CLI npm package
  --yes          Accept the displayed package installation steps
  --dry-run      Print planned changes without making them
  -h, --help     Show this help
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

confirm() {
  if [ "$assume_yes" -eq 1 ]; then
    return 0
  fi
  if [ ! -t 0 ]; then
    fail "confirmation requires a terminal; rerun interactively or pass --yes"
  fi
  printf '%s [y/N] ' "$1"
  read -r answer
  case "$answer" in
  y | Y | yes | YES) return 0 ;;
  *) return 1 ;;
  esac
}

path_exists() {
  [ -e "$1" ] || [ -L "$1" ]
}

nvim_is_compatible() {
  command_path=$1
  NVIM_LOG_FILE=/dev/null "$command_path" -i NONE --clean --headless \
    "+lua if vim.fn.has('nvim-0.11') ~= 1 then vim.cmd('cquit 1') end" \
    +qa >/dev/null 2>&1
}

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    command -v sudo >/dev/null 2>&1 || fail "sudo is required to install Ubuntu packages"
    sudo "$@"
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
  --backup) backup_existing=1 ;;
  --with-codex) with_codex=1 ;;
  --yes) assume_yes=1 ;;
  --dry-run) dry_run=1 ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    fail "unknown option: $1"
    ;;
  esac
  shift
done

os_name=$(uname -s)
case "$os_name" in
Darwin)
  platform=macos
  ;;
Linux)
  [ -r /etc/os-release ] || fail "Linux was detected, but /etc/os-release is unavailable"
  linux_id=$(sed -n 's/^ID=//p' /etc/os-release | tr -d '"')
  [ "$linux_id" = "ubuntu" ] || fail "Linux support currently targets Ubuntu only"
  platform=ubuntu
  ;;
*)
  fail "unsupported operating system: $os_name"
  ;;
esac

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
config_base=${XDG_CONFIG_HOME:-"$HOME/.config"}
config_dir=$config_base/nvim
local_bin=$HOME/.local/bin
local_bin_was_on_path=0
local_bin_used=0
case ":$PATH:" in
*":$local_bin:"*) local_bin_was_on_path=1 ;;
*)
  PATH=$local_bin:$PATH
  export PATH
  ;;
esac

[ -f "$script_dir/init.lua" ] || fail "run this script from the cloned repository"
[ -f "$script_dir/lazy-lock.json" ] || fail "the repository's lazy-lock.json is missing"
[ -d "$script_dir/lua" ] || fail "the repository's lua directory is missing"

if [ "$script_dir" != "$config_dir" ] && path_exists "$config_dir" && [ "$dry_run" -ne 1 ]; then
  if [ "$backup_existing" -ne 1 ]; then
    fail "$config_dir already exists; rerun with --backup to preserve and replace it"
  fi
fi

install_macos_dependencies() {
  set --
  if ! command -v nvim >/dev/null 2>&1 || ! nvim_is_compatible "$(command -v nvim 2>/dev/null || printf nvim)"; then
    set -- "$@" neovim
  fi
  command -v git >/dev/null 2>&1 || set -- "$@" git
  command -v rg >/dev/null 2>&1 || set -- "$@" ripgrep
  command -v fd >/dev/null 2>&1 || set -- "$@" fd
  command -v curl >/dev/null 2>&1 || set -- "$@" curl
  command -v unzip >/dev/null 2>&1 || set -- "$@" unzip
  if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
    set -- "$@" node
  fi

  if [ "$#" -gt 0 ]; then
    printf 'Missing Homebrew formulae:'
    printf ' %s' "$@"
    printf '\n'
    if [ "$dry_run" -ne 1 ]; then
      command -v brew >/dev/null 2>&1 ||
        fail "Homebrew is required for missing packages; install it from https://brew.sh and rerun"
      confirm "Install the missing Homebrew formulae shown above?" || fail "installation cancelled"
      brew install "$@"
    fi
  else
    printf 'Required Homebrew dependencies are already available.\n'
  fi

  if ! command -v cc >/dev/null 2>&1; then
    if [ "$dry_run" -eq 1 ]; then
      printf 'Missing macOS component: Xcode Command Line Tools (install with xcode-select --install).\n'
    else
      fail "a C compiler is required; run 'xcode-select --install' and rerun afterward"
    fi
  fi
}

install_official_linux_neovim() {
  if command -v nvim >/dev/null 2>&1 && nvim_is_compatible "$(command -v nvim)"; then
    return 0
  fi

  machine_arch=$(uname -m)
  case "$machine_arch" in
  x86_64 | amd64)
    nvim_arch=x86_64
    nvim_checksum=$linux_nvim_x86_64_sha256
    ;;
  aarch64 | arm64)
    nvim_arch=arm64
    nvim_checksum=$linux_nvim_arm64_sha256
    ;;
  *)
    fail "the official Neovim fallback supports Ubuntu x86_64 and ARM64, not $machine_arch"
    ;;
  esac

  nvim_data_base=${XDG_DATA_HOME:-"$HOME/.local/share"}
  nvim_install_dir=$nvim_data_base/nvim-$linux_nvim_version-$nvim_arch
  nvim_binary=$nvim_install_dir/bin/nvim
  nvim_link=$local_bin/nvim

  if [ -x "$nvim_binary" ]; then
    nvim_is_compatible "$nvim_binary" || fail "existing local Neovim install is invalid: $nvim_install_dir"
  else
    path_exists "$nvim_install_dir" &&
      fail "refusing to replace unexpected path: $nvim_install_dir"
    confirm "Download verified Neovim $linux_nvim_version from the official GitHub release?" ||
      fail "Neovim installation cancelled"

    mkdir -p "$nvim_data_base" "$local_bin"
    nvim_temp_dir=$(mktemp -d "${TMPDIR:-/tmp}/nvim-install.XXXXXX")
    nvim_archive=$nvim_temp_dir/nvim-linux-$nvim_arch.tar.gz
    nvim_url=https://github.com/neovim/neovim/releases/download/$linux_nvim_version/nvim-linux-$nvim_arch.tar.gz

    printf 'Downloading %s\n' "$nvim_url"
    curl --fail --location --proto '=https' --tlsv1.2 --output "$nvim_archive" "$nvim_url"
    actual_checksum=$(sha256sum "$nvim_archive" | awk '{print $1}')
    if [ "$actual_checksum" != "$nvim_checksum" ]; then
      fail "Neovim checksum verification failed; the archive was not installed"
    fi

    tar -xzf "$nvim_archive" -C "$nvim_temp_dir"
    extracted_dir=$nvim_temp_dir/nvim-linux-$nvim_arch
    [ -x "$extracted_dir/bin/nvim" ] || fail "the verified Neovim archive has an unexpected layout"
    nvim_is_compatible "$extracted_dir/bin/nvim" || fail "the downloaded Neovim binary cannot run on this system"
    mv "$extracted_dir" "$nvim_install_dir"
    rm -f "$nvim_archive"
    rmdir "$nvim_temp_dir"
    printf 'Installed verified Neovim at %s\n' "$nvim_install_dir"
  fi

  if path_exists "$nvim_link"; then
    [ -L "$nvim_link" ] && [ "$(readlink "$nvim_link")" = "$nvim_binary" ] ||
      fail "refusing to replace existing path: $nvim_link"
  else
    mkdir -p "$local_bin"
    ln -s "$nvim_binary" "$nvim_link"
  fi
  local_bin_used=1
}

install_ubuntu_dependencies() {
  command -v apt-get >/dev/null 2>&1 || fail "Ubuntu was detected, but apt-get is unavailable"

  set --
  command -v git >/dev/null 2>&1 || set -- "$@" git
  command -v rg >/dev/null 2>&1 || set -- "$@" ripgrep
  if ! command -v fd >/dev/null 2>&1 && ! command -v fdfind >/dev/null 2>&1; then
    set -- "$@" fd-find
  fi
  command -v node >/dev/null 2>&1 || set -- "$@" nodejs
  command -v npm >/dev/null 2>&1 || set -- "$@" npm
  command -v cc >/dev/null 2>&1 || set -- "$@" build-essential
  command -v curl >/dev/null 2>&1 || set -- "$@" curl
  command -v tar >/dev/null 2>&1 || set -- "$@" tar
  command -v unzip >/dev/null 2>&1 || set -- "$@" unzip

  need_linux_nvim=0
  if ! command -v nvim >/dev/null 2>&1 || ! nvim_is_compatible "$(command -v nvim 2>/dev/null || printf nvim)"; then
    need_linux_nvim=1
    command -v sha256sum >/dev/null 2>&1 || set -- "$@" coreutils
    if ! dpkg-query -W -f='${Status}' ca-certificates 2>/dev/null | grep -q 'ok installed'; then
      set -- "$@" ca-certificates
    fi
  fi

  if [ "$#" -gt 0 ]; then
    printf 'Missing Ubuntu packages:'
    printf ' %s' "$@"
    printf '\n'
    if [ "$dry_run" -ne 1 ]; then
      confirm "Install the missing Ubuntu packages shown above with apt? This may invoke sudo." ||
        fail "installation cancelled"
      run_as_root apt-get update
      run_as_root apt-get install -y --no-install-recommends "$@"
    fi
  else
    printf 'Required Ubuntu packages are already available.\n'
  fi

  if [ "$need_linux_nvim" -eq 1 ]; then
    if [ "$dry_run" -eq 1 ]; then
      printf 'Neovim action: install verified official %s under ~/.local/share and link it in ~/.local/bin.\n' \
        "$linux_nvim_version"
    else
      install_official_linux_neovim
    fi
  fi

  if [ "$dry_run" -ne 1 ] && ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    mkdir -p "$local_bin"
    fd_link=$local_bin/fd
    if path_exists "$fd_link"; then
      [ -x "$fd_link" ] || fail "refusing to replace existing path: $fd_link"
    else
      ln -s "$(command -v fdfind)" "$fd_link"
      printf 'Linked Ubuntu fdfind as %s\n' "$fd_link"
    fi
    local_bin_used=1
  fi
}

printf 'Platform: %s\n' "$platform"
printf 'Neovim target: %s\n' "$config_dir"
case "$platform" in
macos) install_macos_dependencies ;;
ubuntu) install_ubuntu_dependencies ;;
esac

if [ "$with_codex" -eq 1 ]; then
  if command -v codex >/dev/null 2>&1; then
    printf 'Codex CLI is already available.\n'
  else
    printf 'Optional package to install: @openai/codex@latest (npm, under ~/.local).\n'
  fi
fi

if [ "$dry_run" -eq 1 ]; then
  if [ "$script_dir" = "$config_dir" ]; then
    printf 'Config action: already running from the target directory; no copy needed.\n'
  elif path_exists "$config_dir" && [ "$backup_existing" -eq 1 ]; then
    printf 'Config action: move the existing config to a timestamped backup, then install.\n'
  elif path_exists "$config_dir"; then
    printf 'Config action: stop safely because the target exists; --backup is required.\n'
  else
    printf 'Config action: install into a newly created directory.\n'
  fi
  printf 'Dry run complete; no changes were made.\n'
  exit 0
fi

if [ "$with_codex" -eq 1 ] && ! command -v codex >/dev/null 2>&1; then
  confirm "Install the optional Codex CLI package with npm under ~/.local?" ||
    fail "Codex installation cancelled"
  mkdir -p "$local_bin"
  npm install --global --prefix "$HOME/.local" @openai/codex@latest
  local_bin_used=1
fi

if [ "$script_dir" != "$config_dir" ]; then
  mkdir -p "$config_base"

  staging_dir=$(mktemp -d "$config_base/.nvim-install.XXXXXX")
  cp "$script_dir/init.lua" "$staging_dir/init.lua"
  cp "$script_dir/lazy-lock.json" "$staging_dir/lazy-lock.json"
  cp -R "$script_dir/lua" "$staging_dir/lua"

  if path_exists "$config_dir"; then
    timestamp=$(date '+%Y%m%d-%H%M%S')
    backup_dir=$config_dir.backup.$timestamp
    ! path_exists "$backup_dir" || fail "backup path already exists: $backup_dir"
    printf 'Moving existing config to %s\n' "$backup_dir"
    mv "$config_dir" "$backup_dir"
  fi

  mv "$staging_dir" "$config_dir"
  printf 'Installed the Neovim config at %s\n' "$config_dir"
else
  printf 'The repository is already installed at %s\n' "$config_dir"
fi

printf 'Installing pinned Neovim plugins...\n'
if ! NVIM_LOG_FILE=/dev/null nvim -i NONE --headless \
  "+Lazy! install" \
  "+lua if vim.v.errmsg ~= '' then vim.cmd('cquit 1') end" \
  +qa; then
  fail "plugin installation failed; the config is installed, so open Neovim and run :Lazy install to retry"
fi

printf '\nInstallation complete. Start Neovim with: nvim .\n'
printf 'Mason will finish installing editor tools after the first launch.\n'
if [ "$local_bin_used" -eq 1 ] && [ "$local_bin_was_on_path" -ne 1 ]; then
  printf 'Ensure %s is on PATH in future shells (Ubuntu normally adds it after the next login).\n' "$local_bin"
fi
if [ "$with_codex" -eq 1 ]; then
  printf 'Run codex once in a terminal to sign in before opening its Neovim panel.\n'
fi
