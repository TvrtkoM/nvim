-- which-key: shows a popup of possible next keys when you pause mid-keystroke.
-- It reads the `desc` labels we set on every keymap, so it documents itself.

return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- load after startup; it only reacts to keypresses
  opts = {
    -- Register prefix labels so the menu shows tidy group names instead of
    -- a flat list. (Individual mappings already carry their own `desc`.)
    spec = {
      { "<leader>f", group = "find" }, -- Telescope pickers
      { "<leader>c", group = "code" }, -- code action / format
      { "<leader>g", group = "git" }, -- gitsigns hunk actions
      { "<leader>a", group = "ai" }, -- Claude Code
      { "<leader>u", group = "ui" }, -- toggles (diagnostics display, …)
      -- TidalCycles (<leader>t*), SuperCollider (<leader>s*) and Haskell repl
      -- (<leader>r*) labels are registered buffer-local in
      -- after/ftplugin/{haskell,supercollider}.lua instead of here, so they only
      -- appear in their own buffers (.tidal files are filetype=haskell).
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer-local keymaps (which-key)",
    },
  },
}
