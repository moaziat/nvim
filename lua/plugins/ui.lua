return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
     _   __                _
    / | / /__  ____ _   __(_)___ ___
   /  |/ / _ \/ __ \ | / / / __ `__ \
  / /|  /  __/ /_/ / |/ / / / / / / /
 /_/ |_/\___/\____/|___/_/_/ /_/ /_/
]],
          keys = {
            { icon = "", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
            {
              icon = "",
              key = "r",
              desc = "Recent files",
              action = ":lua Snacks.picker.recent({ cwd = require('core.project').workspace(), filter = { cwd = true } })",
            },
            { icon = "", key = "g", desc = "Search text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "", key = "c", desc = "Open Codex", action = ":CodexFocus" },
            { icon = "", key = "l", desc = "Plugin manager", action = ":Lazy" },
            { icon = "", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      explorer = { enabled = true, replace_netrw = true },
      indent = {
        enabled = true,
        animate = { enabled = false },
        char = "│",
        scope = { char = "│" },
      },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = {
        enabled = true,
        prompt = "> ",
        icons = {
          files = { enabled = false },
          git = {
            staged = "S",
            added = "A",
            deleted = "D",
            ignored = "I",
            modified = "M",
            renamed = "R",
            unmerged = "U",
            untracked = "?",
          },
          diagnostics = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " },
        },
        formatters = { file = { filename_first = true } },
        sources = {
          explorer = {
            hidden = true,
            auto_close = false,
            follow_file = true,
            -- Snacks' hierarchical `sort` key groups each directory before
            -- its sibling files, then orders both groups alphabetically.
            sort = { fields = { "sort" } },
            layout = {
              preset = "sidebar",
              preview = false,
              layout = { position = "left", width = 34, min_width = 28 },
            },
          },
          files = { hidden = true },
          recent = { filter = { cwd = true } },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart({ cwd = require("core.project").workspace() })
        end,
        desc = "Smart file picker",
      },
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Switch buffer",
      },
      {
        "<leader>e",
        function()
          Snacks.explorer({ cwd = require("core.project").workspace() })
        end,
        desc = "File explorer",
      },
      {
        "<C-n>",
        function()
          Snacks.explorer({ cwd = require("core.project").workspace() })
        end,
        desc = "File explorer",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ cwd = require("core.project").workspace() })
        end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep({ cwd = require("core.project").workspace() })
        end,
        desc = "Search project text",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find buffers",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent({ cwd = require("core.project").workspace(), filter = { cwd = true } })
        end,
        desc = "Recent files",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find config file",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.lines()
        end,
        desc = "Search current buffer",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help pages",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sr",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume last picker",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Delete other buffers",
      },
      {
        "<leader>tt",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle terminal",
      },
      {
        "<C-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle terminal",
      },
      {
        "<C-_>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle terminal",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss notifications",
      },
      {
        "<leader>nh",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification history",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Open the workspace file explorer on the left",
        once = true,
        callback = function()
          if #vim.api.nvim_list_uis() == 0 or vim.o.diff or vim.g.started_by_firenvim then
            return
          end

          vim.schedule(function()
            local main_window = vim.api.nvim_get_current_win()
            Snacks.explorer({ cwd = require("core.project").workspace() })
            vim.schedule(function()
              if vim.api.nvim_win_is_valid(main_window) then
                vim.api.nvim_set_current_win(main_window)
              end
            end)
          end)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          vim.print = _G.dd
        end,
      })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 350,
      icons = { mappings = false, rules = false, breadcrumb = ">", separator = "->", group = "+" },
      spec = {
        { "<leader>a", group = "AI / Codex" },
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>m", group = "CMake / build" },
        { "<leader>n", group = "Notifications" },
        { "<leader>q", group = "Quit / session" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Terminal" },
        { "<leader>u", group = "UI toggles" },
        { "<leader>x", group = "Diagnostics" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
      },
    },
  },
}
