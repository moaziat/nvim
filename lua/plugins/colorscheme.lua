return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- Enable true colors
    vim.opt.termguicolors = true
    
    require("kanagawa").setup({
      compile = false,             -- Faster startup
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,         -- Use the beautiful solid "Wave" background
      dimInactive = false,
      terminalColors = true,
      theme = "wave",
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none", -- Keeps the sidebar clean
            }
          }
        }
      },
    })

    -- load the colorscheme
    vim.cmd("colorscheme kanagawa-dragon")
  end,
}
