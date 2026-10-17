return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "+", package_pending = "~", package_uninstalled = "-" },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "clangd",
        "neocmake",
        "rust_analyzer",
        "bashls",
        "jsonls",
        "yamlls",
        "ts_ls",
      },
      automatic_enable = false,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "pyright",
        "bash-language-server",
        "json-lsp",
        "yaml-language-server",
        "typescript-language-server",
        "ruff",
        "stylua",
        "shfmt",
        "prettier",
        "clang-format",
        "neocmakelsp",
        "rust-analyzer",
        "tree-sitter-cli",
      },
      run_on_start = true,
      start_delay = 2000,
      debounce_hours = 24,
    },
  },
}
