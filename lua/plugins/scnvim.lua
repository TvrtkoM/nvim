-- scnvim: Neovim frontend for SuperCollider. Boots `sclang`, sends code from
-- your buffer to it, and shows interpreter output in a "post window".
--
-- Filetype: scnvim ships its own detection for `.scd`/`.sc` (-> filetype
-- `supercollider`); lazy sources that ftdetect because we set `ft` below, so
-- opening such a file loads the plugin. Our Treesitter fork already installs the
-- `supercollider` parser and highlights this filetype (lua/plugins/treesitter.lua).
--
-- Prerequisite: SuperCollider installed (`sclang` on PATH). After first launch,
-- run `:SCNvimGenerateAssets` once to build syntax/snippets from the class library.
--
-- Keymaps are laid out to MIRROR the tidal.nvim bindings, but under <leader>s:
--   tidal <leader>t* -> scnvim <leader>s*
--   tl/sl send line | ts/ss send selection | tb/sb send block
--   tL/sL launch     | th/sh stop sound     | (scnvim adds recompile / post window)
-- which-key labels for these live in lua/plugins/which-key.lua.

return {
  "davidgranstrom/scnvim",
  ft = { "supercollider" },
  config = function()
    local scnvim = require("scnvim")
    local map = scnvim.map

    scnvim.setup({
      keymaps = {
        -- Sending code (normal/visual only — a <leader> prefix in insert mode
        -- isn't practical, matching how we set up tidal).
        ["<leader>sl"] = map("editor.send_line", { "n" }), -- send current Line
        ["<leader>ss"] = map("editor.send_selection", "x"), -- send Selection
        ["<leader>sb"] = map("editor.send_block", { "n" }), -- send Block

        -- Interpreter control.
        ["<leader>sL"] = map("sclang.start"), -- Launch sclang (≈ tidal <leader>tL)
        ["<leader>sr"] = map("sclang.recompile"), -- Recompile class library
        ["<leader>sh"] = map("sclang.hard_stop", { "n", "x" }), -- stop all sound (≈ tidal hush)

        -- Post window (sclang output).
        ["<leader>sp"] = map("postwin.toggle"), -- toggle Post window
        ["<leader>sP"] = map("postwin.clear"), -- clear Post window

        -- Docs.
        ["<leader>si"] = map("signature.show", { "n", "i" }), -- show signature Info
      },
      editor = {
        -- Flash the text that gets sent to the interpreter (same idea as tidal).
        highlight = { color = "IncSearch" },
      },
      postwin = {
        -- Open output in a horizontal split (set float.enabled=true for a popup).
        float = { enabled = false },
      },
    })
  end,
}
