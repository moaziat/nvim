vim.cmd("filetype plugin indent on")

-- Editing feel
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.confirm = true
vim.opt.virtualedit = "block"
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.whichwrap:append("<,>,[,],h,l")

-- Appearance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.showtabline = 1
vim.opt.pumheight = 12
vim.opt.winborder = "rounded"
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldclose = ">",
  foldopen = "v",
  foldsep = " ",
}
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "·", nbsp = "+" }

-- Sensible defaults; project and filetype settings can override these.
vim.g.python_recommended_style = 0
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Navigation and splits
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.sidescroll = 1
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.jumpoptions = "view"

-- Search and completion
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.wildmode = "longest:full,full"
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Responsiveness and files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400
vim.opt.ttimeoutlen = 10
vim.opt.autoread = true

-- Terminal jobs contain transient PIDs and launcher paths. Never serialize
-- them into persistence.nvim sessions; tools such as Codex start fresh.
vim.opt.sessionoptions:remove("terminal")

-- Start unfolded, but keep folds available with zc/zo.
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.g.autoformat = true
