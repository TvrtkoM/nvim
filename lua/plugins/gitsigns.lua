-- Git signs in the gutter, hunk navigation and actions.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
      map("n", "[h", function() gs.nav_hunk("prev") end, "Prev git hunk")

      local function sel() return { vim.fn.line("."), vim.fn.line("v") } end
      map("n", "<leader>gs", gs.stage_hunk, "Stage/unstage hunk") -- toggles
      map("v", "<leader>gs", function() gs.stage_hunk(sel()) end, "Stage/unstage selection")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>gr", function() gs.reset_hunk(sel()) end, "Reset selection")
      map("n", "<leader>gS", gs.stage_buffer, "Stage whole file")
      map("n", "<leader>gR", gs.reset_buffer, "Reset whole file")
      map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
      map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")
      map("n", "<leader>gd", gs.diffthis, "Diff this file")

      map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk") -- e.g. vih, dih
    end,
  },
}
