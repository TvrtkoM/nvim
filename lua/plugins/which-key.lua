-- Popup of available keys. Filetype-specific groups (repl, haskell, tidal,
-- supercollider) are added in after/ftplugin/.

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>c", group = "code" },
      { "<leader>g", group = "git" },
      { "<leader>a", group = "ai" },
      { "<leader>u", group = "ui" },
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
