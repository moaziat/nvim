return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Prevent crashing if plugin is not loaded yet
    local ok, ts = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    ts.setup({
      ensure_installed = { "lua", "python", "c", "cpp", "bash" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}

