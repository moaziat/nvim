return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local ok, ts = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    ts.setup({
      ensure_installed = { "lua", "python", "c", "cpp", "cuda", "bash", "cmake", "json", "toml", "yaml" },
      highlight = { enable = true },
      indent = {
        enable = true,
        disable = { "python", "c", "cpp", "cuda" },
      },
    })
  end,
}
