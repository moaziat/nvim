return {
  "neovim/nvim-lspconfig",
  -- This is the specific "Time Capsule" commit for Neovim 0.9.5
  commit = "54eb30b", 
  dependencies = { 
    "williamboman/mason.nvim", 
    "williamboman/mason-lspconfig.nvim" 
  },
  config = function()
    local lspconfig = require("lspconfig")
    local nvim_venv = vim.fn.expand("$HOME") .. "/.nvim-venv"

    lspconfig.pyright.setup({
      cmd = { nvim_venv .. "/bin/pyright-langserver", "--stdio" },
      on_init = function(client)
        local project_python = vim.fn.exepath("python3") or vim.fn.exepath("python")
        client.config.settings.python.pythonPath = project_python
      end,
    })
  end,
}
