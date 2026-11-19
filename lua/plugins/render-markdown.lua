-- render-markdown: draws headings, code blocks, tables, checkboxes, etc. inline
-- in normal mode (raw markdown comes back on the line you're editing).

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" }, -- nothing to render anywhere else
  -- nvim-web-devicons: the same icon provider oil/lualine already use (it
  -- previously pulled in mini.icons, a second icon library, just for this).
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completions = { lsp = { enabled = true } },
    -- LaTeX rendering needs an external converter (`utftex` or `latex2text`)
    -- on PATH; neither is installed, so it was enabled but rendering nothing.
    -- Install one (e.g. python3Packages.pylatexenc for latex2text) and flip
    -- this back to true.
    latex = { enabled = false },
  },
}
