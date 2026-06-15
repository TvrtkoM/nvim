-- lazydev.nvim: configures lua_ls specifically for editing your Neovim config.
-- It loads the Neovim API type definitions (and your plugins' types) on demand,
-- which both silences the "Undefined global `vim`" warning and gives you real
-- autocomplete/hover for vim.* and require()'d plugin modules.

return {
  "folke/lazydev.nvim",
  -- NOTE: no `ft = "lua"` here. lazydev is a dependency of nvim-lspconfig
  -- (see lua/plugins/lsp.lua) so it loads at startup, BEFORE lua_ls is enabled.
  -- That ordering is what prevents the transient "undefined global" warnings.
  opts = {
    library = {
      -- Add libuv type defs whenever `vim.uv` is referenced.
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
