return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      -- This character creates the "long line" look
      char = "│", 
      tab_char = "│",
    },
    scope = {
      enabled = true,
      show_start = true,  -- Shows where your "drawn line" starts
      show_end = true,    -- Shows where your "drawn line" ends
      highlight = { "Function", "Label" }, -- Makes the active block line pop
    },
    exclude = {
      filetypes = { "help", "nvim-tree", "lazy", "mason" },
    },
  },
}
