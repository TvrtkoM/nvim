-- Fuzzy finder.

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
  },

  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep (project search)" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Open buffers" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
    { "<leader>fo", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
    { "<leader>fr", function() require("telescope.builtin").resume() end, desc = "Resume last picker" },
    { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document symbols" },
    { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
    { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Grep word under cursor" },
  },

  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
      },
      extensions = {
        fzf = {},
      },
    })
    telescope.load_extension("fzf")
  end,
}
