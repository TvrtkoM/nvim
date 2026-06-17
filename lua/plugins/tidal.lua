-- tidal.nvim: live-code music with TidalCycles from Neovim. It boots a GHCi
-- session with Tidal loaded and sends code from your buffer to it.
--
-- NOTE: the upstream README lists `nvim-treesitter/nvim-treesitter` (the
-- ARCHIVED original) as a dependency to get the haskell parser. We deliberately
-- DROP that dep — our maintained fork (lua/plugins/treesitter.lua) already
-- installs the `haskell`/`supercollider` parsers. tidal.nvim itself sets
-- `.tidal` files to filetype=haskell, so our treesitter highlight autocmd (which
-- includes `haskell`) lights them up and the node-send feature gets its parser.
--
-- Prerequisites (system, install separately): GHC + the `tidal` Haskell package
-- (via cabal/ghcup), and SuperCollider + SuperDirt for actual sound. See README.

return {
  "grddavies/tidal.nvim",
  -- Load on the file pattern, NOT `ft`: tidal.nvim doesn't use a `tidal`
  -- filetype — it's the plugin's own autocmd that switches `.tidal` buffers to
  -- filetype=haskell. So an `ft = "tidal"` trigger would never fire. Loading on
  -- BufReadPre/BufNewFile of *.tidal runs setup() before BufWinEnter, so the
  -- plugin's autocmd then catches the buffer and sets ft + keymaps.
  event = { "BufReadPre *.tidal", "BufNewFile *.tidal" },
  -- NOTE: we intentionally do NOT load tidal.nvim for `supercollider` buffers.
  -- SuperCollider editing is handled by scnvim (lua/plugins/scnvim.lua); letting
  -- both grab .scd files would double up keymaps/interpreters.
  cmd = { "TidalLaunch", "TidalQuit" },
  -- Launch/quit the GHCi session. These are global (lazy loads the plugin on
  -- first use); the send/silence maps below are buffer-local in .tidal/.scd.
  keys = {
    { "<leader>tL", "<cmd>TidalLaunch<cr>", desc = "Tidal: launch" },
    { "<leader>tq", "<cmd>TidalQuit<cr>", desc = "Tidal: quit" },
  },
  opts = {
    -- Remap every default send/silence keymap under <leader>t. (Defaults were
    -- <S-CR>/<M-CR>/<leader><CR>/<leader>d/<leader><Esc>.) These are set
    -- buffer-local by tidal.nvim's autocmd in .tidal and .scd buffers.
    mappings = {
      send_line = { mode = "n", key = "<leader>tl" }, -- send current Line
      send_visual = { mode = "x", key = "<leader>ts" }, -- send Selection
      send_block = { mode = { "n", "x" }, key = "<leader>tb" }, -- send Block
      send_node = { mode = "n", key = "<leader>tn" }, -- send Treesitter Node
      send_silence = { mode = "n", key = "<leader>td" }, -- silence dN (count1)
      send_hush = { mode = "n", key = "<leader>th" }, -- Hush all patterns
    },
    -- Defaults otherwise sensible. Common things you might set later:
    -- boot = { tidal = { file = ..., args = ... }, sclang = { enabled = true } },
    -- split = "v", -- "v" vertical / "h" horizontal GHCi output split
  },
}
