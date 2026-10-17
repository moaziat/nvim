return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      heading = {
        sign = false,
        width = "block",
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      },
      bullet = { icons = { "-", "+", "*" } },
      code = { sign = false, width = "block", right_pad = 1, language_icon = false },
      quote = { icon = ">" },
      link = { enabled = false },
      checkbox = {
        unchecked = { icon = "[ ] " },
        checked = { icon = "[x] " },
        custom = { todo = { raw = "[-]", rendered = "[~] ", highlight = "RenderMarkdownTodo" } },
      },
    },
    keys = {
      {
        "<leader>um",
        "<cmd>RenderMarkdown toggle<CR>",
        desc = "Toggle rendered Markdown",
      },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "CMakeGenerate",
      "CMakeBuild",
      "CMakeRun",
      "CMakeDebug",
      "CMakeSelectBuildTarget",
      "CMakeSelectBuildType",
      "CMakeSelectConfigurePreset",
      "CMakeSelectBuildPreset",
      "CMakeClean",
    },
    opts = {
      cmake_use_preset = true,
      cmake_regenerate_on_save = false,
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
    },
    keys = {
      { "<leader>mc", "<cmd>CMakeGenerate<CR>", desc = "Configure CMake project" },
      { "<leader>mb", "<cmd>CMakeBuild<CR>", desc = "Build CMake target" },
      { "<leader>mr", "<cmd>CMakeRun<CR>", desc = "Run CMake target" },
      { "<leader>mt", "<cmd>CMakeSelectBuildTarget<CR>", desc = "Select CMake target" },
      { "<leader>mp", "<cmd>CMakeSelectConfigurePreset<CR>", desc = "Select CMake preset" },
    },
  },
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = { n_lines = 500 },
  },
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash syntax jump",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "+" },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]h", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Git hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[h", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous Git hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>gw", gs.toggle_word_diff, "Toggle word diff")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Review all changes" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close diff review" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    },
    opts = { use_icons = false },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Document symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP locations" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list" },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore last session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Do not save session",
      },
    },
  },
}
