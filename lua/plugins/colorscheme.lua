return {
  "echasnovski/mini.base16",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.opt.background = "dark"

    local palette = {
      base00 = "#1d1f28",
      base01 = "#282a36",
      base02 = "#373844",
      base03 = "#414458",
      base04 = "#bebec1",
      base05 = "#fdfdfd",
      base06 = "#fdfdfd",
      base07 = "#ffffff",
      base08 = "#f37f97",
      base09 = "#f2a272",
      base0A = "#ffffb3",
      base0B = "#5adecd",
      base0C = "#79e6f3",
      base0D = "#8897f4",
      base0E = "#c574dd",
      base0F = "#f37f97",
    }

    require("mini.base16").setup({
      palette = palette,
      use_cterm = true,
    })

    vim.g.colors_name = "lovelace-base16"

    local ui = {
      NormalFloat = { bg = palette.base01 },
      FloatBorder = { fg = palette.base0D, bg = palette.base01 },
      Pmenu = { fg = palette.base05, bg = palette.base01 },
      PmenuSel = { fg = palette.base00, bg = palette.base0D, bold = true },
      CursorLine = { bg = palette.base01 },
      Visual = { bg = palette.base02 },
      Search = { fg = palette.base00, bg = palette.base0A },
      IncSearch = { fg = palette.base00, bg = palette.base09 },
      WinSeparator = { fg = palette.base02 },
      DiagnosticVirtualTextError = { fg = palette.base08 },
      DiagnosticVirtualTextWarn = { fg = palette.base09 },
      DiagnosticVirtualTextInfo = { fg = palette.base0C },
      DiagnosticVirtualTextHint = { fg = palette.base0B },
    }

    local cpp = {
      ["@type.cpp"] = { fg = palette.base0D },
      ["@type.builtin.cpp"] = { fg = palette.base0C, bold = true },
      ["@constructor.cpp"] = { fg = palette.base0A, bold = true },
      ["@function.cpp"] = { fg = palette.base0D },
      ["@function.method.cpp"] = { fg = palette.base0C },
      ["@constant.macro.cpp"] = { fg = palette.base08, bold = true },
      ["@keyword.directive.cpp"] = { fg = palette.base0E },
      ["@namespace.cpp"] = { fg = palette.base0E },
      ["@variable.parameter.cpp"] = { fg = palette.base05, italic = true },
      ["@lsp.type.class.cpp"] = { fg = palette.base0D },
      ["@lsp.type.struct.cpp"] = { fg = palette.base0C },
      ["@lsp.type.enum.cpp"] = { fg = palette.base0A },
      ["@lsp.type.function.cpp"] = { fg = palette.base0D },
      ["@lsp.type.method.cpp"] = { fg = palette.base0C },
      ["@lsp.type.macro.cpp"] = { fg = palette.base08, bold = true },
      ["@lsp.type.namespace.cpp"] = { fg = palette.base0E },
      ["@lsp.type.parameter.cpp"] = { fg = palette.base05, italic = true },
    }

    for group, spec in pairs(ui) do
      vim.api.nvim_set_hl(0, group, spec)
    end

    for group, spec in pairs(cpp) do
      vim.api.nvim_set_hl(0, group, spec)
    end
  end,
}
