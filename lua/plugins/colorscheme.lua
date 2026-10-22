return {
  "maxmx03/fluoromachine.nvim",
  dependencies = {
    { "projekt0n/github-nvim-theme", name = "github-theme" },
  },
  lazy = false,
  priority = 1100,
  config = function()
    local fluoromachine = require("fluoromachine")
    local mode = "dark"

    local palettes = {
      dark = {
        bg = "#17191f",
        bgdark = "#111318",
        editor = {
          currentline = "#20232b",
          selection = "#2a2f3a",
          separator = "#3b4252",
        },
      },
    }

    require("github-theme").setup({
      options = {
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = "italic",
          constants = "bold",
          keywords = "bold",
          types = "bold",
        },
        darken = {
          floats = true,
          sidebars = {
            enable = true,
            list = { "NvimTree", "qf", "help" },
          },
        },
      },
    })

    local function apply_theme(next_mode)
      if next_mode == "light" then
        vim.opt.background = "light"
        vim.cmd.colorscheme("github_light_default")
        mode = next_mode
        return
      end

      fluoromachine.setup({
        theme = "fluoromachine",
        brightness = 0.05,
        glow = false,
        transparent = false,
        colors = palettes.dark,
        styles = {
          comments = { italic = true },
          functions = {},
          variables = {},
          numbers = {},
          constants = { bold = true },
          parameters = { italic = true },
          keywords = { bold = true },
          types = { bold = true },
        },
        plugins = {
          bufferline = true,
          cmp = true,
          dashboard = true,
          editor = true,
          gitsign = true,
          ibl = true,
          lazy = true,
          lspconfig = true,
          notify = true,
          syntax = true,
          treesitter = true,
          tree = true,
          wk = true,
        },
        overrides = function(colors)
          return {
            -- Modern Tree-sitter captures. These are shared by C++, Python,
            -- Rust, and Lua and keep semantic categories visually distinct.
            ["@type"] = { fg = colors.cyan, bold = true },
            ["@type.builtin"] = { fg = colors.cyan, bold = true },
            ["@type.definition"] = { fg = colors.cyan, bold = true },
            ["@type.qualifier"] = { fg = colors.purple, bold = true },
            ["@constructor"] = { fg = colors.yellow, bold = true },
            ["@module"] = { fg = colors.purple },
            ["@module.builtin"] = { fg = colors.purple, bold = true },
            ["@function"] = { fg = colors.pink },
            ["@function.call"] = { fg = colors.pink },
            ["@function.method"] = { fg = colors.pink },
            ["@function.method.call"] = { fg = colors.pink },
            ["@function.decorator"] = { fg = colors.purple, bold = true },
            ["@variable.member"] = { fg = colors.cyan },
            ["@property"] = { fg = colors.cyan },
            ["@attribute"] = { fg = colors.yellow },
            ["@constant"] = { fg = colors.orange, bold = true },
            ["@constant.macro"] = { fg = colors.orange, bold = true },
            ["@keyword"] = { fg = colors.purple, bold = true },
            ["@keyword.type"] = { fg = colors.purple, bold = true },
            ["@operator"] = { fg = colors.yellow },

            -- LSP semantic tokens used by clangd/rust-analyzer. Language
            -- suffixes such as .cpp inherit from these groups.
            ["@lsp.type.class"] = { link = "@type" },
            ["@lsp.type.struct"] = { link = "@type" },
            ["@lsp.type.enum"] = { link = "@type" },
            ["@lsp.type.interface"] = { link = "@type" },
            ["@lsp.type.typeParameter"] = { link = "@type.definition" },
            ["@lsp.type.namespace"] = { link = "@module" },
            ["@lsp.type.function"] = { link = "@function" },
            ["@lsp.type.method"] = { link = "@function.method" },
            ["@lsp.type.decorator"] = { link = "@function.decorator" },
            ["@lsp.type.parameter"] = { link = "@variable.parameter" },
            ["@lsp.type.property"] = { link = "@property" },
            ["@lsp.type.macro"] = { link = "@constant.macro" },

            -- Give the explorer and floating UI a quieter surface so the neon
            -- syntax remains the visual focus.
            NormalFloat = { fg = colors.fg, bg = colors.bgdark },
            FloatBorder = { fg = colors.purple, bg = colors.bgdark },
            FloatTitle = { fg = colors.cyan, bg = colors.bgdark, bold = true },
            WinSeparator = { fg = colors.purple },
            NvimTreeNormal = { fg = colors.fg, bg = colors.bgdark },
            NvimTreeNormalNC = { fg = colors.fg, bg = colors.bgdark },
            NvimTreeEndOfBuffer = { fg = colors.bgdark, bg = colors.bgdark },
            NvimTreeWinSeparator = { fg = colors.purple, bg = colors.bgdark },
            NvimTreeCursorLine = { bg = colors.bg },
            NvimTreeRootFolder = { fg = colors.pink, bold = true },
            NvimTreeFolderName = { fg = colors.cyan },
            NvimTreeOpenedFolderName = { fg = colors.yellow, bold = true },
            NvimTreeIndentMarker = { fg = colors.purple },
            SnacksPickerBorder = { fg = colors.purple, bg = colors.bgdark },
            SnacksPickerInputBorder = { fg = colors.pink, bg = colors.bgdark },
            BlinkCmpMenu = { fg = colors.fg, bg = colors.bgdark },
            BlinkCmpMenuSelection = { fg = colors.bg, bg = colors.purple, bold = true },
          }
        end,
      })

      vim.opt.background = "dark"
      vim.cmd.colorscheme("fluoromachine")
      mode = next_mode
    end

    apply_theme(mode)

    local function toggle_theme()
      local next_mode = mode == "dark" and "light" or "dark"
      apply_theme(next_mode)
      local name = next_mode == "dark" and "Fluoromachine graphite" or "GitHub Light Default"
      vim.notify("Theme: " .. name)
    end

    vim.api.nvim_create_user_command("ThemeToggle", toggle_theme, {
      desc = "Toggle GitHub light / Fluoromachine dark",
    })
    vim.keymap.set("n", "<leader>ut", toggle_theme, {
      silent = true,
      desc = "Toggle GitHub light / Fluoromachine dark",
    })
  end,
}
