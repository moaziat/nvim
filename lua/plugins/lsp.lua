return {
  "neovim/nvim-lspconfig",
  tag = "v1.8.0",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local lspconfig = require("lspconfig")
    local project = require("core.project")
    local util = require("lspconfig.util")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    local function lsp_keymaps(_, bufnr)
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
      end

      map("gd", vim.lsp.buf.definition, "Go to definition")
      map("gD", vim.lsp.buf.declaration, "Go to declaration")
      map("gi", vim.lsp.buf.implementation, "Go to implementation")
      map("gr", vim.lsp.buf.references, "References")
      map("K", vim.lsp.buf.hover, "Hover")
      map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, "Format buffer")
    end

    local pyright = project.first_executable({
      project.mason_bin("pyright-langserver"),
      vim.fn.exepath("pyright-langserver"),
    })

    if pyright then
      lspconfig.pyright.setup({
        cmd = { pyright, "--stdio" },
        capabilities = capabilities,
        on_attach = lsp_keymaps,
        root_dir = util.root_pattern("uv.lock", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true,
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "basic",
              useLibraryCodeForTypes = true,
            },
          },
        },
        on_new_config = function(new_config, root_dir)
          local python = project.python_path(root_dir)
          new_config.settings.python.pythonPath = python
          if root_dir and project.executable(root_dir .. "/.venv/bin/python") then
            new_config.settings.python.venvPath = root_dir
            new_config.settings.python.venv = ".venv"
          end
        end,
      })
    end

    local clangd = project.first_executable({
      project.mason_bin("clangd"),
      vim.fn.exepath("clangd"),
    })

    if clangd then
      lspconfig.clangd.setup({
        cmd = {
          clangd,
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--pch-storage=memory",
          "--query-driver=/usr/bin/clang++,/usr/bin/g++,/usr/bin/c++,/usr/bin/mpicxx,/usr/bin/nvcc,/opt/*/bin/*",
        },
        capabilities = capabilities,
        on_attach = lsp_keymaps,
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".clangd", ".git"),
        init_options = {
          clangdFileStatus = true,
          fallbackFlags = { "-std=c++17" },
        },
      })
    end
  end,
}
