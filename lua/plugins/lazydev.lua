-- Neovim API types for lua_ls when editing this config.

return {
  "folke/lazydev.nvim",
  -- No `ft`: loaded as an lspconfig dependency so it's ready before lua_ls.
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
