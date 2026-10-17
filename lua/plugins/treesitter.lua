local parsers = {
  "bash",
  "c",
  "cmake",
  "comment",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})
      vim.treesitter.language.register("json", "jsonc")
      vim.treesitter.language.register("cpp", "cuda")

      local installed = {}
      for _, language in ipairs(treesitter.get_installed("parsers")) do
        installed[language] = true
      end
      local missing = vim.tbl_filter(function(language)
        return not installed[language]
      end, parsers)
      if #missing > 0 then
        treesitter.install(missing)
      end

      local group = vim.api.nvim_create_augroup("user_treesitter", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
          if vim.bo[event.buf].filetype ~= "python" then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "tsx" },
    opts = {},
  },
}
