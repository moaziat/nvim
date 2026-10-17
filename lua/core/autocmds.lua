vim.filetype.add({
  extension = {
    cu = "cuda",
    cuh = "cuda",
    hpp = "cpp",
    hxx = "cpp",
    hip = "cpp",
    inl = "cpp",
    tpp = "cpp",
  },
})

local function set_indent(width, expandtab)
  vim.bo.tabstop = width
  vim.bo.shiftwidth = width
  vim.bo.softtabstop = expandtab and width or 0
  vim.bo.expandtab = expandtab
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Use four spaces for systems and Python code",
  pattern = { "python", "c", "cpp", "cuda", "rust", "cmake", "lua", "sh", "bash", "zsh" },
  callback = function()
    set_indent(4, true)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Use two spaces for web and data files",
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "yaml", "html", "css" },
  callback = function()
    set_indent(2, true)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Use real tabs for Makefiles",
  pattern = { "make" },
  callback = function()
    set_indent(4, false)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Create parent directories before writing a file",
  callback = function(event)
    if event.match == "" or event.match:match("^%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Trim trailing whitespace in code files",
  pattern = {
    "*.py",
    "*.c",
    "*.cc",
    "*.cpp",
    "*.cxx",
    "*.h",
    "*.hpp",
    "*.hxx",
    "*.cu",
    "*.cuh",
    "*.hip",
    "*.inl",
    "*.rs",
    "*.lua",
    "*.sh",
    "*.cmake",
    "CMakeLists.txt",
  },
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Reload files changed outside Neovim",
  command = "checktime",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to the last edit position",
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close utility windows with q",
  pattern = { "checkhealth", "help", "lspinfo", "man", "qf", "startuptime" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Comfortable terminal defaults",
  callback = function(event)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd.startinsert()
    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
      buffer = event.buf,
      silent = true,
      desc = "Terminal normal mode",
    })
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Keep split sizes balanced after resizing",
  command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions for the current buffer",
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- clangd remains available for C/C++ completion and navigation, but its
    -- diagnostics are intentionally hidden. Large Kokkos and generated-code
    -- projects often cannot be reproduced faithfully on the editing machine.
    if client and client.name == "clangd" then
      vim.diagnostic.enable(false, { bufnr = event.buf, ns_id = client.namespace })
    end

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
    end

    map("gd", function()
      Snacks.picker.lsp_definitions()
    end, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", function()
      Snacks.picker.lsp_references()
    end, "References")
    map("gI", function()
      Snacks.picker.lsp_implementations()
    end, "Go to implementation")
    map("gy", function()
      Snacks.picker.lsp_type_definitions()
    end, "Go to type definition")
    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("gK", vim.lsp.buf.signature_help, "Signature help")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>cs", function()
      Snacks.picker.lsp_symbols()
    end, "Document symbols")
    map("<leader>cS", function()
      Snacks.picker.lsp_workspace_symbols()
    end, "Workspace symbols")
    map("<leader>ci", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
    end, "Toggle inlay hints")
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 3, source = "if_many", prefix = "●" },
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})
