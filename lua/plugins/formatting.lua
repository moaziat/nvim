return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Format buffer or selection",
      },
      {
        "<leader>uf",
        function()
          vim.g.autoformat = not vim.g.autoformat
          vim.notify("Format on save " .. (vim.g.autoformat and "enabled" or "disabled"))
        end,
        desc = "Toggle format on save",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cuda = { "clang_format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if not vim.g.autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1500, lsp_format = "fallback" }
      end,
    },
  },
}
