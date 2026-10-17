return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local function lsp_name()
      local names = {}
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if client.name ~= "copilot" then
          names[#names + 1] = client.name
        end
      end
      return table.concat(names, ",")
    end

    local function git_status()
      local status = vim.b.gitsigns_status_dict
      if not status or not status.head or status.head == "" then
        return ""
      end

      local parts = { "git:" .. status.head }
      if (status.added or 0) > 0 then
        parts[#parts + 1] = "+" .. status.added
      end
      if (status.changed or 0) > 0 then
        parts[#parts + 1] = "~" .. status.changed
      end
      if (status.removed or 0) > 0 then
        parts[#parts + 1] = "-" .. status.removed
      end
      return table.concat(parts, " ")
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        icons_enabled = false,
        section_separators = "",
        component_separators = "|",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { git_status, "diagnostics" },
        lualine_c = { { "filename", path = 1, symbols = { modified = " [+]", readonly = " [RO]" } } },
        lualine_x = { lsp_name, "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy", "mason", "quickfix", "trouble" },
    })
  end,
}
