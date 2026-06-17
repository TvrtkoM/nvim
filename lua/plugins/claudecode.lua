-- claudecode.nvim: Claude Code inside Neovim. Speaks the same WebSocket/MCP
-- protocol as the official VSCode/JetBrains extensions, so you get editor-aware
-- context (send selections, @-mention files) and proposed edits open as a
-- native Neovim diff you accept/reject — not silent writes. Needs the `claude`
-- CLI on PATH (already installed).

return {
  "coder/claudecode.nvim",
  -- No snacks.nvim: the "native" provider uses Neovim's built-in :terminal,
  -- so we avoid pulling in the whole snacks dependency.
  opts = {
    terminal = { provider = "native" },
  },
  -- Lazy-load only when one of these commands or keys is used.
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  keys = {
    { "<leader>a", nil, desc = "ai (claude)" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
    -- Send the current visual selection as context.
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
    -- Add the file (or oil entry) under the cursor to Claude's context.
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file to context", ft = "oil" },
    -- Accept / reject a proposed-changes diff.
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
  },
}
