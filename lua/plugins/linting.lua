return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      -- Define linters for your languages
      lint.linters_by_ft = {
        python = { "pylint" },
        javascript = { "eslint_d" },
      }

      -- Create an autocmd to lint whenever you save the file
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "pylint" }, -- Automatically install pylint
    },
  },
}
