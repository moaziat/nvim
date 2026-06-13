return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
  opts = {
    ui = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
  end,
}
