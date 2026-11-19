-- File explorer: edit directories as buffers, :w to apply.

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false, -- needed to replace netrw for directories

  opts = {
    view_options = { show_hidden = true },
    default_file_explorer = true,
    win_options = { signcolumn = "yes:2" }, -- for oil-git-status
  },

  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
    { "<leader>e", function() require("oil").open(vim.fn.getcwd()) end, desc = "File explorer (oil)" },
  },
}
