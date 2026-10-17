vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Treat the directory Neovim was launched in as the workspace boundary. When
-- `nvim .` is used, resolve the directory argument instead. Pickers, the file
-- explorer, and Codex all share this value and will not wander into parents.
local launch_root = (vim.uv or vim.loop).cwd() or vim.fn.getcwd()
local first_arg = vim.fn.argv(0)
if vim.fn.argc() == 1 and first_arg ~= "" and vim.fn.isdirectory(first_arg) == 1 then
  launch_root = vim.fn.fnamemodify(first_arg, ":p")
end
vim.g.workspace_root = vim.fs.normalize(launch_root)

-- Cache Lua modules for a noticeably faster startup on modern Neovim.
if vim.loader then
  vim.loader.enable()
end

-- Providers we do not use only slow down :checkhealth and startup.
vim.g.loaded_python_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Mason-managed tools should be available to LSP, formatters, and parser
-- installers before any plugin is configured.
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

local nvim_python = vim.fn.expand("~/.nvim-venv/bin/python")
if vim.fn.executable(nvim_python) == 1 then
  vim.g.python3_host_prog = nvim_python
else
  local python3 = vim.fn.exepath("python3")
  if python3 ~= "" then
    vim.g.python3_host_prog = python3
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.autocmds")
require("core.keymaps")

require("lazy").setup("plugins", {
  checker = { enabled = false },
  change_detection = { notify = false },
  install = { missing = true, colorscheme = { "oxocarbon", "habamax" } },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
