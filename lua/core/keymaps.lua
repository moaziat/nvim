local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Files
map("n", "<leader>e", ":NvimTreeToggle<CR>", "Toggle file tree")
map("n", "<C-n>", ":NvimTreeToggle<CR>", "Toggle file tree")
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR>", "Save file")
map("n", "<leader>w", "<cmd>write<CR>", "Save file")

-- Clipboard-friendly copy/paste over SSH through OSC52.
map({ "n", "v" }, "<C-c>", '"+y', "Copy")
map({ "n", "v" }, "<C-v>", '"+p', "Paste")
map("i", "<C-v>", "<C-r>+", "Paste")

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics list")
