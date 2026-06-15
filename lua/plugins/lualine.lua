-- lualine: the statusline at the bottom — mode, git branch/diff, LSP/ESLint
-- diagnostics, filename, filetype, and cursor position. Pulls git diff info
-- from gitsigns and diagnostics from the LSP layer automatically.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- icons (Nerd Font)
  event = "VeryLazy", -- statusline isn't needed during early startup
  opts = {
    options = {
      theme = "auto", -- match the active colorscheme (tokyonight)
      globalstatus = true, -- one statusline for the whole UI (sets laststatus=3)
    },
    -- Sections left at lualine's defaults: they already show mode | branch,
    -- diff, diagnostics | filename | filetype | progress | location.
  },
}
