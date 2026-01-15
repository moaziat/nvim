return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- Enable true colors
    vim.opt.termguicolors = true
    
    require("kanagawa").setup({
      compile = false,             -- Faster startup
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      theme = "wave",
      typeStyle = {},
      transparent = false,         -- Use the beautiful solid "Wave" background
      dimInactive = false,
      terminalColors = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none", -- Keeps the sidebar clean
            }
          }
        }
      },
    })

    -- load the colorscheme
    vim.cmd("colorscheme kanagawa-wave")
  end,
  }

  -- 2. LSP Config
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require('lspconfig')
      local nvim_venv = vim.fn.expand("$HOME") .. "/.nvim-venv"
      
      lspconfig.pyright.setup({
        cmd = { nvim_venv .. "/bin/pyright-langserver", "--stdio" },
      })
    end,
  },

  -- 3. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua" },
        highlight = { enable = true },
      })
    end,
  },

  -- 4. NvimTree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },
}
