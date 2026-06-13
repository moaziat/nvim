-- Compatibility shim for plugins that expect newer Neovim helpers.
if not vim.joinpath then
  vim.joinpath = function(...)
    return (table.concat({ ... }, "/"):gsub("//+", "/"))
  end
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_python_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

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

local function copy(lines, _)
  local s = table.concat(lines, "\n")
  local base64 = vim.fn.system("base64", s):gsub("\n", "")
  local osc = string.format("\27]52;c;%s\7", base64)
  io.stderr:write(osc)
end

vim.g.clipboard = {
  name = "osc52",
  copy = {
    ["+"] = copy,
    ["*"] = copy,
  },
  paste = {
    ["+"] = function()
      return { vim.fn.getreg("+"), vim.fn.getregtype("+") }
    end,
    ["*"] = function()
      return { vim.fn.getreg("*"), vim.fn.getregtype("*") }
    end,
  },
}

require("core.options")
require("core.autocmds")
require("core.keymaps")

require("lazy").setup("plugins", {
  checker = { enabled = false },
  change_detection = { notify = false },
  install = { missing = false },
})
