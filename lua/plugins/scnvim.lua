-- SuperCollider: run sclang and send code to it. Needs `sclang` on PATH; run
-- :SCNvimGenerateAssets once after the first launch. Keys mirror tidal's.

return {
  "davidgranstrom/scnvim",
  ft = { "supercollider" },
  config = function()
    local scnvim = require("scnvim")
    local map = scnvim.map

    scnvim.setup({
      keymaps = {
        ["<leader>sl"] = map("editor.send_line", { "n" }),
        ["<leader>ss"] = map("editor.send_selection", "x"),
        ["<leader>sb"] = map("editor.send_block", { "n" }),
        ["<leader>sL"] = map("sclang.start"),
        ["<leader>sr"] = map("sclang.recompile"),
        ["<leader>sh"] = map("sclang.hard_stop", { "n", "x" }), -- stop all sound
        ["<leader>sp"] = map("postwin.toggle"),
        ["<leader>sP"] = map("postwin.clear"),
        ["<leader>si"] = map("signature.show", { "n", "i" }),
      },
      editor = {
        highlight = { color = "IncSearch" }, -- flash sent code
      },
      postwin = {
        float = { enabled = false }, -- output in a split
      },
    })
  end,
}
