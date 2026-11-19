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

      -- Hunk actions (under the <leader>g "git" group). stage_hunk is a TOGGLE:
      -- on an already-staged hunk it unstages it (undo_stage_hunk is deprecated).
      local function sel() return { vim.fn.line("."), vim.fn.line("v") } end
      map("n", "<leader>gs", gs.stage_hunk, "Stage/unstage hunk")
      map("v", "<leader>gs", function() gs.stage_hunk(sel()) end, "Stage/unstage selection")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>gr", function() gs.reset_hunk(sel()) end, "Reset selection")
      map("n", "<leader>gS", gs.stage_buffer, "Stage whole file")
      map("n", "<leader>gR", gs.reset_buffer, "Reset whole file")
      map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
      map("n", "<leader>gd", gs.diffthis, "Diff this file")

      -- `ih` text object = the hunk under the cursor: `vih` selects it,
      -- `dih` deletes it, `yih` yanks it.
      map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
    end,
  },
}
