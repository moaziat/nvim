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
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup({})
    mason_lspconfig.setup({
      ensure_installed = { "pyright", "clangd" },
      automatic_installation = true,
    })

    local function python_path()
      local python3 = vim.fn.exepath("python3")
      if python3 ~= "" then
        return python3
      end
      return vim.fn.exepath("python")
    end

    local nvim_venv = vim.fn.expand("$HOME") .. "/.nvim-venv"
    local pyright_cmd = nil
    if vim.fn.executable(nvim_venv .. "/bin/pyright-langserver") == 1 then
      pyright_cmd = { nvim_venv .. "/bin/pyright-langserver", "--stdio" }
    end

    lspconfig.pyright.setup({
      cmd = pyright_cmd,
      settings = {
        python = {
          pythonPath = python_path(),
        },
      },
    })

    lspconfig.clangd.setup({})
  end,
}
