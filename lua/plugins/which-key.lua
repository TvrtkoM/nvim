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
      { "<leader>t", group = "tidal" }, -- TidalCycles send/silence
      -- SuperCollider (scnvim). scnvim's map() carries no `desc`, so we label
      -- the keys here; they only exist (buffer-local) in .scd/.sc buffers.
      { "<leader>s", group = "supercollider" },
      { "<leader>sl", desc = "Send line" },
      { "<leader>ss", desc = "Send selection", mode = "x" },
      { "<leader>sb", desc = "Send block" },
      { "<leader>sL", desc = "Launch sclang" },
      { "<leader>sr", desc = "Recompile class library" },
      { "<leader>sh", desc = "Stop sound (hard stop)" },
      { "<leader>sp", desc = "Toggle post window" },
      { "<leader>sP", desc = "Clear post window" },
      { "<leader>si", desc = "Show signature" },
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
