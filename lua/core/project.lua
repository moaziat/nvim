local M = {}

local uv = vim.uv or vim.loop

function M.workspace()
  return vim.g.workspace_root or uv.cwd() or vim.fn.getcwd()
end

function M.root(bufnr, markers)
  bufnr = bufnr or 0
  markers = markers or { "uv.lock", "pyproject.toml", "compile_commands.json", ".git" }

  local name = vim.api.nvim_buf_get_name(bufnr)
  local start = name ~= "" and vim.fs.dirname(name) or M.workspace()
  local workspace = vim.fs.normalize(M.workspace())

  -- Never discover a project marker above the directory used to launch Nvim.
  if not vim.fs.relpath(workspace, start) then
    start = workspace
  end
  local found = vim.fs.find(markers, {
    path = start,
    upward = true,
    stop = vim.fs.dirname(workspace),
  })[1]

  if found then
    return vim.fs.dirname(found)
  end

  return workspace
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
