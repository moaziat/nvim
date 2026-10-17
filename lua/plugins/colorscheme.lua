return {
  "nyoom-engineering/oxocarbon.nvim",
  build = false,
  lazy = false,
  priority = 1000,
  config = function()
    local function apply_theme(mode)
      vim.opt.background = mode
      vim.cmd.colorscheme("oxocarbon")

      -- Oxocarbon predates Snacks and Blink, so connect their surfaces to
      -- standard highlight groups that the theme already styles well.
      vim.api.nvim_set_hl(0, "SnacksPickerBorder", { link = "FloatBorder" })
      vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { link = "DiagnosticInfo" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Pmenu" })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "PmenuSel" })
    end

    apply_theme("dark")

    local function toggle_daylight_theme()
      if vim.o.background == "dark" then
        apply_theme("light")
        vim.notify("Daylight theme: Oxocarbon Light")
      else
        apply_theme("dark")
        vim.notify("Dark theme: Oxocarbon")
      end
    end

    vim.api.nvim_create_user_command("ThemeToggle", toggle_daylight_theme, {
      desc = "Toggle daylight and dark themes",
    })
    vim.keymap.set("n", "<leader>ut", toggle_daylight_theme, {
      silent = true,
      desc = "Toggle daylight theme",
    })
  end,
}
