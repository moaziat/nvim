return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    vim.opt.splitbelow = true

    -- Nicer bash prompt for terminals inside Neovim (user@host:path git-branch)
    vim.env.PS1 =
      "\\[\\e[32m\\]\\u@\\h\\[\\e[0m\\]:\\[\\e[34m\\]\\w\\[\\e[0m\\] \\[\\e[33m\\]$(git rev-parse --abbrev-ref HEAD 2>/dev/null)\\[\\e[0m\\]$ "

    -- Use the same shell as the user's environment
    local shell = vim.env.SHELL
    if shell == nil or shell == "" then
      shell = vim.o.shell
    end
    if shell == nil or shell == "" then
      shell = "/bin/bash"
    end
    if shell:sub(1, 1) ~= "/" then
      shell = "/" .. shell
    end
    if vim.fn.executable(shell) ~= 1 then
      shell = "/bin/bash"
    end
    vim.o.shell = shell

    require("toggleterm").setup({
      size = 6,
      open_mapping = nil,
      direction = "horizontal",
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = false,
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local bottom_term = Terminal:new({
      cmd = vim.o.shell,
      direction = "horizontal",
      hidden = false,
      close_on_exit = false,
    })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.schedule(function()
          bottom_term:open(6)
        end)
      end,
    })

    local function focus_terminal()
      if bottom_term:is_open() then
        vim.cmd("wincmd j")
      else
        bottom_term:open(6)
      end
    end

    -- Simple switch between editor and bottom terminal
    vim.keymap.set("n", "T", focus_terminal, { silent = true })
    vim.keymap.set("t", "E", [[<C-\><C-n><C-w>k]], { silent = true })
  end,
}
