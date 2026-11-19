-- TidalCycles live coding. Needs GHC + the `tidal` package, and SuperCollider +
-- SuperDirt for sound. The plugin sets .tidal files to filetype=haskell.

return {
  "grddavies/tidal.nvim",
  -- Not `ft`: there is no `tidal` filetype to trigger on.
  event = { "BufReadPre *.tidal", "BufNewFile *.tidal" },
  -- Launch/quit keys are buffer-local in after/ftplugin/haskell.lua.
  cmd = { "TidalLaunch", "TidalQuit" },
  opts = {
    mappings = {
      send_line = { mode = "n", key = "<leader>tl" },
      send_visual = { mode = "x", key = "<leader>ts" },
      send_block = { mode = { "n", "x" }, key = "<leader>tb" },
      send_node = { mode = "n", key = "<leader>tn" },
      send_silence = { mode = "n", key = "<leader>td" }, -- count = channel, e.g. 2<leader>td
      send_hush = { mode = "n", key = "<leader>th" },
    },
  },
}
