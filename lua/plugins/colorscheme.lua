-- Every file in lua/plugins/ must `return` a plugin spec: a Lua table where
-- the first element is the GitHub "owner/repo" of the plugin. lazy.nvim reads
-- this table to know what to install and how/when to load it.
return {
  "folke/tokyonight.nvim",

  -- A colorscheme is part of the UI, so we want it available immediately at
  -- startup rather than lazy-loaded:
  lazy = false, -- load during startup, not on-demand
  priority = 1000, -- load before all other plugins so nothing renders unthemed

  -- `config` runs after the plugin is installed and loaded. This is where we
  -- configure and activate it.
  config = function()
    require("tokyonight").setup({
      style = "night", -- night | storm | moon | day
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
