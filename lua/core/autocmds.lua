vim.filetype.add({
  extension = {
    cu = "cuda",
    cuh = "cuda",
    hpp = "cpp",
    hxx = "cpp",
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
  desc = "Use VS Code-style 4-space indentation for development buffers",
  pattern = { "python", "c", "cpp", "cuda", "cmake", "lua", "sh", "bash", "zsh" },
  callback = function()
    set_indent(4, true)
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
    local file = vim.loop.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Trim trailing whitespace in code files",
  pattern = { "*.py", "*.c", "*.cc", "*.cpp", "*.cxx", "*.h", "*.hpp", "*.hxx", "*.cu", "*.cuh", "*.lua", "*.sh", "*.cmake", "CMakeLists.txt" },
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
