-- Bracket/tag editing ergonomics. Two related plugins in one file.

return {
  -- Auto-close pairs: typing ( { [ " ' ` inserts the closing char, and typing
  -- the closing char over an existing one just skips past it.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- only needed once you start typing
    opts = {
      check_ts = true, -- Treesitter-aware: don't add pairs inside strings/comments
    },
  },

  -- Auto-close and auto-rename HTML/JSX/TSX tags using Treesitter. Typing
  -- `<div>` adds `</div>`; editing one tag name updates its pair.
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "xml",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "markdown",
    },
    opts = {},
  },
}
