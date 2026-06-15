-- Telescope: fuzzy finder for files, project-wide grep, buffers, and LSP
-- symbols/references/diagnostics. Type to filter; <CR> opens the selection.

return {
  "nvim-telescope/telescope.nvim",
  -- Loaded on first use (a keymap below or the :Telescope command).
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required Lua utility library
    {
      -- Compiled C sorter for faster, better fuzzy matching. `build = "make"`
      -- compiles it on install (needs make + a C compiler — both present).
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
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
    -- Word under cursor -> project grep
    { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Grep word under cursor" },
  },

  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        -- Open results with the prompt at the top.
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
      },
      extensions = {
        fzf = {}, -- use the compiled native sorter
      },
    })
    -- Activate the fzf-native extension built above.
    telescope.load_extension("fzf")
  end,
}
