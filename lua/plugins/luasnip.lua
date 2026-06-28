-- LuaSnip: the snippet engine. It expands snippet bodies and runs the tabstop
-- session (the placeholders you Tab through). blink.cmp delegates snippet
-- expansion + jumping to it (snippets.preset = "luasnip" in blink.lua) and
-- sources snippet completion items from it.
--
-- Why LuaSnip (and not mini.snippets or the built-in vim.snippet): LuaSnip edits
-- placeholders via select-mode (type-to-replace), which stays correct while the
-- completion popup is open. mini.snippets re-syncs the tabstop on every popup
-- change and threw the cursor backwards when typing on a placeholder; LuaSnip is
-- the engine the cmp/blink ecosystem is built around precisely to avoid that.
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*", -- track the stable 2.x line
  -- friendly-snippets: community VSCode-format snippet collection, loaded into
  -- LuaSnip below. (It used to hang off blink; LuaSnip owns it now.)
  dependencies = { "rafamadriz/friendly-snippets" },
  -- NOTE: LuaSnip has an optional `build = "make install_jsregexp"` step that
  -- compiles a regex helper for snippets with variable transforms. We omit it —
  -- friendly-snippets don't need it (you'd only see a warning if a snippet
  -- actually uses a transform). Add that build line if you ever want it.
  config = function()
    -- Parse and register all friendly-snippets, lazily per filetype.
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
