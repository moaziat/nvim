local M = {}

local uv = vim.uv or vim.loop

function M.root(bufnr, markers)
  bufnr = bufnr or 0
  markers = markers or { "uv.lock", "pyproject.toml", "compile_commands.json", ".git" }

  local name = vim.api.nvim_buf_get_name(bufnr)
  local start = name ~= "" and vim.fs.dirname(name) or uv.cwd()
  local found = vim.fs.find(markers, { path = start, upward = true })[1]

  if found then
    return vim.fs.dirname(found)
  end

  return start
end

function M.executable(path)
  return path and path ~= "" and vim.fn.executable(path) == 1
end

function M.first_executable(candidates)
  for _, candidate in ipairs(candidates) do
    if M.executable(candidate) then
      return candidate
    end
  end
  return nil
end

function M.mason_bin(name)
  return vim.fn.stdpath("data") .. "/mason/bin/" .. name
end

function M.project_bin(root, name)
  if not root or root == "" then
    return nil
  end

  return M.first_executable({
    root .. "/.venv/bin/" .. name,
    root .. "/venv/bin/" .. name,
  })
end

function M.python_path(root)
  local venv = vim.env.VIRTUAL_ENV
  local candidates = {
    root and (root .. "/.venv/bin/python") or nil,
    root and (root .. "/venv/bin/python") or nil,
    venv and (venv .. "/bin/python") or nil,
    vim.fn.exepath("python3"),
    vim.fn.exepath("python"),
  }

  return M.first_executable(candidates) or "python3"
end

return M
