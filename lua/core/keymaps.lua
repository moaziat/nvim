local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Save and quit
map({ "n", "i", "x" }, "<C-s>", "<cmd>write<CR>", "Save file")
map("n", "<leader>w", "<cmd>write<CR>", "Save file")
map("n", "<leader>qq", "<cmd>qa<CR>", "Quit all")

-- Keep selections and the cursor where you expect them.
map("x", "<", "<gv", "Outdent selection")
map("x", ">", ">gv", "Indent selection")
map("x", "<Tab>", ">gv", "Indent selection")
map("x", "<S-Tab>", "<gv", "Outdent selection")
map("x", "J", ":move '>+1<CR>gv=gv", "Move selection down")
map("x", "K", ":move '<-2<CR>gv=gv", "Move selection up")
map("n", "J", "mzJ`z", "Join lines without moving cursor")

-- Window navigation and resizing.
map("n", "<C-h>", "<C-w>h", "Focus left window")
map("n", "<C-j>", "<C-w>j", "Focus lower window")
map("n", "<C-k>", "<C-w>k", "Focus upper window")
map("n", "<C-l>", "<C-w>l", "Focus right window")
map("n", "<C-Up>", "<cmd>resize +2<CR>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -2<CR>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Increase window width")

-- Buffers.
map("n", "<S-h>", "<cmd>bprevious<CR>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<CR>", "Next buffer")
map("n", "[b", "<cmd>bprevious<CR>", "Previous buffer")
map("n", "]b", "<cmd>bnext<CR>", "Next buffer")

-- Search and movement.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "n", "nzzzv", "Next search result")
map("n", "N", "Nzzzv", "Previous search result")
map("n", "<C-d>", "<C-d>zz", "Scroll down")
map("n", "<C-u>", "<C-u>zz", "Scroll up")

-- Paste without replacing the unnamed register.
map("x", "p", '"_dP', "Paste without overwriting register")

-- macOS terminals handle Command-C/Command-V themselves. Every regular
-- yank already reaches the system clipboard through `unnamedplus`.
map("x", "<C-c>", '"+y', "Copy selection")

-- Diagnostics
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, "Previous diagnostic")
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, "Next diagnostic")
map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
map("n", "<leader>cq", vim.diagnostic.setloclist, "Diagnostics to location list")

-- Quickfix navigation.
map("n", "[q", "<cmd>cprev<CR>", "Previous quickfix item")
map("n", "]q", "<cmd>cnext<CR>", "Next quickfix item")
