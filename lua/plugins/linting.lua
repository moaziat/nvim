return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local project = require("core.project")

    lint.linters_by_ft = {}

    local function python_linter(bufnr)
      local root = project.root(bufnr, { "uv.lock", "pyproject.toml", ".git" })
      local ruff = project.project_bin(root, "ruff") or vim.fn.exepath("ruff")
      if project.executable(ruff) then
        lint.linters.ruff.cmd = ruff
        return "ruff"
      end

      local pylint = project.project_bin(root, "pylint") or vim.fn.exepath("pylint")
      if project.executable(pylint) then
        lint.linters.pylint.cmd = pylint
        return "pylint"
      end

      return nil
    end

    local function javascript_linter()
      local eslint_d = vim.fn.exepath("eslint_d")
      if project.executable(eslint_d) then
        lint.linters.eslint_d.cmd = eslint_d
        return "eslint_d"
      end
      return nil
    end

    local function linters_for_buffer(bufnr)
      local ft = vim.bo[bufnr].filetype
      if ft == "python" then
        return python_linter(bufnr)
      end
      if ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
        return javascript_linter()
      end
      return nil
    end

    local group = vim.api.nvim_create_augroup("user_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = group,
      callback = function(args)
        local linter = linters_for_buffer(args.buf)
        if linter then
          lint.try_lint(linter)
        else
          vim.diagnostic.reset(nil, args.buf)
        end
      end,
    })
  end,
}
