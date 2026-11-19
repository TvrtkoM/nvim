return {
  -- Auto-close brackets and quotes.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- not inside strings/comments
    },
  },

  -- Auto-close and auto-rename HTML/JSX tags.
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "xml",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "markdown",
      "vue",
      "htmlangular",
      "blade",
      "php",
    },
    opts = {},
  },
}
