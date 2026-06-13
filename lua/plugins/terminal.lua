return {
  "akinsho/toggleterm.nvim",
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    { "T", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
  },
  opts = {
    size = 15,
    direction = "horizontal",
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    close_on_exit = true,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    vim.keymap.set("t", "E", [[<C-\><C-n>]], { silent = true, desc = "Terminal normal mode" })
  end,
}
