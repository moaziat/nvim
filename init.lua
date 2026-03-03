-- Fix for Neovim 0.9.5: Add missing vim.joinpath function
if not vim.joinpath then
    vim.joinpath = function(...)
        return (table.concat({...}, '/'):gsub('//+', '/'))
    end
end
if not vim.lsp.enable then
    vim.lsp.enable = function(server_name)
        -- In 0.9.5, we just let the standard start_client handle it
        return true
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

vim.opt.termguicolors = true
--- 1. GLOBAL SETTINGS (Fixes Line Numbers & Indentation)
vim.opt.number = true         -- Show line numbers in editor
vim.opt.relativenumber = false -- Relative numbers for easier jumping
vim.opt.tabstop = 2           -- 2 spaces for a tab
vim.opt.shiftwidth = 2        -- 2 spaces for indentation
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.autoindent = true     -- Copy indent from current line when starting new line
vim.opt.smartindent = true    -- Insert indents automatically
local function copy(lines, _)
  local s = table.concat(lines, '\n')
  local base64 = vim.fn.system('base64', s):gsub('\n', '')
  local osc = string.format('\27]52;c;%s\7', base64)
  io.stderr:write(osc)
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {
    ['+'] = copy,
    ['*'] = copy,
  },
  paste = {
    ['+'] = function() return {vim.fn.getreg('+'), vim.fn.getregtype('+')} end,
    ['*'] = function() return {vim.fn.getreg('*'), vim.fn.getregtype('*')} end,
  },
}

vim.opt.clipboard = "unnamedplus"
-- Lazy will load it automatically from your lua/plugins/ folder.
require("lazy").setup("plugins")

--- 3. KEYBINDINGS (Optional: Toggle NvimTree with Ctrl+n)
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })

-- Clipboard-friendly copy/paste
-- Note: This overrides block-visual on <C-v> in normal mode.
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y', { silent = true })
vim.keymap.set({ "n", "v" }, "<C-v>", '"+p', { silent = true })
vim.keymap.set("i", "<C-v>", "<C-r>+", { silent = true })
