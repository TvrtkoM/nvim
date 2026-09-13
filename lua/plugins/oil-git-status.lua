-- Shows git status (staged/unstaged/untracked) as two sign columns in oil
-- buffers. Needs oil's win_options.signcolumn = "yes:2" (set in oil.lua).

return {
  "refractalize/oil-git-status.nvim",
  dependencies = { "stevearc/oil.nvim" },
  config = true, -- auto-attaches to oil buffers; refreshes on write/focus
}
