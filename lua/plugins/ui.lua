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
      explorer = { enabled = false, replace_netrw = false },
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
          require("nvim-tree.api").tree.toggle({
            path = require("core.project").workspace(),
            find_file = true,
            update_root = false,
            focus = true,
          })
        end,
        desc = "File explorer",
      },
      {
        "<C-n>",
        function()
          require("nvim-tree.api").tree.toggle({
            path = require("core.project").workspace(),
            find_file = true,
            update_root = false,
            focus = true,
          })
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
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      local api = require("nvim-tree.api")
      local workspace = require("core.project").workspace()

      local function on_attach(bufnr)
        api.config.mappings.default_on_attach(bufnr)

        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, {
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
            desc = "Explorer: " .. desc,
          })
        end

        map("l", api.node.open.edit, "Open")
        map("h", api.node.navigate.parent_close, "Close folder")
        map("v", api.node.open.vertical, "Open in vertical split")
        map("s", api.node.open.horizontal, "Open in horizontal split")
        map("?", api.tree.toggle_help, "Help")
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        reload_on_bufenter = true,
        root_dirs = { workspace },
        prefer_startup_root = true,
        sync_root_with_cwd = false,
        respect_buf_cwd = false,
        sort = {
          sorter = "name",
          folders_first = true,
          files_first = false,
        },
        view = {
          side = "left",
          width = 36,
          preserve_window_proportions = true,
          cursorline = true,
          signcolumn = "yes",
        },
        renderer = {
          group_empty = false,
          full_name = true,
          indent_width = 2,
          root_folder_label = function(path)
            return "  " .. vim.fn.fnamemodify(path, ":t")
          end,
          highlight_git = "icon",
          highlight_opened_files = "name",
          highlight_modified = "name",
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
          },
          icons = {
            web_devicons = {
              file = { enable = true, color = true },
              folder = { enable = true, color = true },
            },
            git_placement = "after",
            modified_placement = "after",
            padding = { icon = " ", folder_arrow = " " },
            glyphs = {
              folder = { arrow_closed = "▸", arrow_open = "▾" },
              git = {
                unstaged = "~",
                staged = "+",
                unmerged = "!",
                renamed = "→",
                untracked = "?",
                deleted = "-",
                ignored = "·",
              },
            },
          },
        },
        update_focused_file = {
          enable = true,
          update_root = { enable = false },
        },
        git = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          timeout = 1000,
        },
        diagnostics = { enable = false },
        modified = { enable = true, show_on_dirs = true },
        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = { "^\\.git$" },
        },
        live_filter = { always_show_folders = true },
        actions = {
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = true,
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Open the project tree without stealing editor focus",
        once = true,
        callback = function()
          if #vim.api.nvim_list_uis() == 0 or vim.o.diff or vim.g.started_by_firenvim then
            return
          end

          vim.schedule(function()
            api.tree.open({ path = workspace, focus = false })
          end)
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
        offsets = {
          { filetype = "NvimTree", text = "Project", highlight = "Directory", separator = true },
        },
      },
    },
  },
}
