-- oil.nvim: edit your filesystem like a normal buffer. Open a directory, then
-- rename/create/delete files by editing the text and `:w` to apply the changes.

return {
  "stevearc/oil.nvim",
  -- Icons in the listing (renders with your installed Nerd Font).
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Load at startup so oil (not netrw) handles directories you open.
  lazy = false,

  opts = {
    -- Show dotfiles too (toggle in-buffer with `g.`).
    view_options = { show_hidden = true },
    -- Let oil be the default handler when you open a directory.
    default_file_explorer = true,
  },

  keys = {
    -- Signature oil binding: open the parent directory of the current file.
    -- (Inside an oil buffer, `-` keeps going up; `<CR>` opens, `g?` shows help.)
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
    -- Open oil on your current working directory.
    { "<leader>e", function() require("oil").open(vim.fn.getcwd()) end, desc = "File explorer (oil)" },
  },
}
