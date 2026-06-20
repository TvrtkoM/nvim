-- Every file in lua/plugins/ must `return` a plugin spec: a Lua table where
-- the first element is the GitHub "owner/repo" of the plugin. lazy.nvim reads
-- this table to know what to install and how/when to load it.
--
-- Theme: everforest (sainnhe/everforest) — a low-saturation, natural green
-- forest palette. It's a Vimscript colorscheme, so it's configured through
-- `vim.g.*` globals that MUST be set BEFORE `:colorscheme everforest` runs.
return {
  "sainnhe/everforest",

  -- A colorscheme is part of the UI, so we want it available immediately at
  -- startup rather than lazy-loaded:
  lazy = false,    -- load during startup, not on-demand
  priority = 1000, -- load before all other plugins so nothing renders unthemed

  config = function()
    -- everforest ships a light + dark variant; pin dark.
    vim.o.background = "dark"

    -- 'hard' | 'medium' | 'soft' — darkest background + most contrast.
    vim.g.everforest_background = "hard"
    -- 'low' | 'high' — 'high' makes greyed UI elements (separators, line nums,
    -- sign column) brighter, so panel boundaries read clearly.
    vim.g.everforest_ui_contrast = "high"
    -- Recommended by the author: caches highlight groups for faster startup.
    vim.g.everforest_better_performance = 1
    -- Lift floating windows (hover/diagnostic/which-key) off the main bg.
    vim.g.everforest_float_style = "dim"
    vim.g.everforest_enable_italic = 1

    vim.cmd.colorscheme("everforest")

    -- Belt-and-suspenders for the panel-boundary complaint: brighten the line
    -- BETWEEN splits to everforest's light foreground so it can't blend in.
    -- (Runs after :colorscheme so it overrides the theme's default.)
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#9da9a0" })
    vim.opt.fillchars:append({ vert = "│" }) -- clean solid glyph for that line
  end,
}
