local function codex_executable()
  -- Prefer stable install locations over transient shell shims (for example,
  -- cmux shims under /var/folders) that cannot survive a restored session.
  local candidates = {
    "/opt/homebrew/bin/codex",
    "/usr/local/bin/codex",
    vim.fn.expand("~/.local/bin/codex"),
  }

  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  local discovered = vim.fn.exepath("codex")
  return discovered ~= "" and discovered or "codex"
end

return {
  {
    "nwiizo/codex.nvim",
    event = "VeryLazy",
    cmd = {
      "Codex",
      "CodexOpen",
      "CodexClose",
      "CodexFocus",
      "CodexResume",
      "CodexContinue",
      "CodexReview",
      "CodexPrompt",
      "CodexAsk",
      "CodexAskVisual",
      "CodexFollowUp",
      "CodexEdit",
      "CodexSendVisual",
      "CodexAddVisual",
      "CodexAdd",
      "CodexTreeAdd",
      "CodexInterrupt",
      "CodexStatus",
      "CodexStop",
      "CodexHealth",
    },
    init = function()
      local group = vim.api.nvim_create_augroup("codex_resilience", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "CodexExited",
        callback = function(event)
          local exit_code = event.data and event.data.exit_code
          if exit_code and exit_code ~= 0 then
            vim.notify(
              ("Codex exited with status %d. Its output was kept open; press <Space>aa to restart."):format(exit_code),
              vim.log.levels.WARN,
              { title = "Codex" }
            )
          end
        end,
      })
    end,
    opts = {
      -- The terminal backend keeps the full Codex transcript, commands, and
      -- approval flow visible. It is deliberately not a hidden auto-agent.
      backend = "terminal",
      -- Inline mode preserves the transcript after a crash; disabling the
      -- shared daemon isolates Neovim sessions from one another. Codex may
      -- edit the opened project, but must ask before leaving its sandbox.
      cmd = {
        codex_executable(),
        "--no-alt-screen",
        "--no-daemon",
        "--sandbox",
        "workspace-write",
        "--ask-for-approval",
        "on-request",
      },
      cwd = function()
        return require("core.project").workspace()
      end,
      focus_after_send = true,
      terminal = {
        layout = "split",
        split_side = "right",
        split_width_percentage = 0.38,
        auto_insert = true,
        -- Keep a failed process visible so its last error is not lost.
        auto_close = false,
        hide_keys = { "<C-/>", "<C-_>" },
        normal_mode_keys = { "<M-n>" },
        window_navigation = {
          left = "<M-h>",
          down = "<M-j>",
          up = "<M-k>",
          right = "<M-l>",
        },
      },
      selection = {
        enabled = true,
        hint = true,
        keymaps = { ask = "<leader>aq", edit = "<leader>ae" },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodexFocus<CR>", desc = "Focus or hide Codex" },
      { "<leader>aq", "<cmd>CodexAsk<CR>", desc = "Ask Codex about this file" },
      { "<leader>af", "<cmd>CodexAdd<CR>", desc = "Add current file to Codex" },
      { "<leader>ar", "<cmd>CodexResume<CR>", desc = "Resume a Codex session" },
      { "<leader>aR", "<cmd>CodexReview --uncommitted<CR>", desc = "Review uncommitted changes" },
      { "<leader>ai", "<cmd>CodexInterrupt<CR>", desc = "Interrupt Codex" },
      { "<leader>ax", "<cmd>CodexStop<CR>", desc = "Stop Codex" },
      { "<leader>ah", "<cmd>CodexHealth<CR>", desc = "Check Codex health" },
      { "<leader>aq", ":<C-U>CodexAskVisual<CR>", mode = "x", desc = "Ask Codex about selection" },
      { "<leader>ae", ":<C-U>CodexEdit<CR>", mode = "x", desc = "Ask Codex to edit selection" },
      { "<leader>as", ":<C-U>CodexSendVisual<CR>", mode = "x", desc = "Send selection to Codex" },
    },
  },
}
