return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local nvim_tree = require("nvim-tree")

    nvim_tree.setup({
      -- Enable Line Numbers
      view = {
        number = true,         -- This enables absolute line numbers
        relativenumber = true, -- Set to true if you prefer relative numbers
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
    })

    -- Open NvimTree automatically when opening Neovim
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 then
          require("nvim-tree.api").tree.open()
        end
      end,
    })
  end,
}
