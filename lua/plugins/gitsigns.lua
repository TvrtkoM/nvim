-- gitsigns: shows git add/change/delete markers in the sign column for tracked
-- files, plus per-hunk navigation, staging, preview, reset, and line blame.
-- (Only active inside a git repository.)

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- load when opening a real file
  opts = {
    -- Keymaps are buffer-local, set once gitsigns attaches to a buffer.
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigate between changed hunks.
      map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
      map("n", "[h", function() gs.nav_hunk("prev") end, "Prev git hunk")

      -- Hunk actions (under the <leader>g "git" group).
      map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
      map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selection")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("n", "<leader>gu", gs.stage_hunk, "Unstage hunk")
      map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("n", "<leader>gd", gs.diffthis, "Diff this file")
    end,
  },
}
