return {
  "nvim-tree/nvim-tree.lua",
  tag = "compat-nvim-0.9",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local nvim_tree = require("nvim-tree")

    nvim_tree.setup({
      view = {
        number = true,
        relativenumber = true,
        width = 30,
        side = "left",
      },
      sort_by = "case_sensitive",
      renderer = {
        highlight_git = true,
        highlight_opened_files = "all",
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
        },
      },
    })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 then
          require("nvim-tree.api").tree.open()
        end
      end,
    })
  end,
}
