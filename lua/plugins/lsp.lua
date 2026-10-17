return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local project = require("core.project")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git" },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim", "Snacks" } },
            hint = { enable = true },
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      })

      vim.lsp.config("pyright", {
        root_markers = { "uv.lock", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "basic",
              useLibraryCodeForTypes = true,
            },
          },
        },
        before_init = function(_, config)
          config.settings.python.pythonPath = project.python_path(config.root_dir)
        end,
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--completion-style=detailed",
          "--header-insertion=never",
          "--pch-storage=memory",
          "--query-driver=/usr/bin/clang*,/usr/bin/g++*,/usr/bin/c++*,/opt/homebrew/bin/*,/opt/homebrew/opt/llvm/bin/clang*,/usr/local/bin/*,/usr/local/cuda/bin/nvcc,/opt/*/bin/*",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
        init_options = {
          clangdFileStatus = true,
          fallbackFlags = { "-std=c++17" },
        },
      })

      vim.lsp.config("neocmake", {
        root_markers = { "CMakePresets.json", "CMakeLists.txt", ".git" },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "clippy" },
            procMacro = { enable = true },
            inlayHints = {
              bindingModeHints = { enable = true },
              closureReturnTypeHints = { enable = "with_block" },
              lifetimeElisionHints = { enable = "skip_trivial" },
            },
          },
        },
      })

      vim.lsp.config("ts_ls", {
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      })

      vim.lsp.enable({
        "lua_ls",
        "pyright",
        "clangd",
        "neocmake",
        "rust_analyzer",
        "bashls",
        "jsonls",
        "yamlls",
        "ts_ls",
      })
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
