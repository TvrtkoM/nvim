-- Every file in lua/plugins/ must `return` a plugin spec: a Lua table where
-- the first element is the GitHub "owner/repo" of the plugin. lazy.nvim reads
-- this table to know what to install and how/when to load it.
--
-- Theme: gruvbox — a warm, earthy palette on a dark brown background (#282828),
-- with high-contrast foreground. The maintained Lua port (ellisonleao/gruvbox.nvim)
-- exposes `contrast` and per-group `overrides`, which we use to make window/panel
-- borders clearly visible.
return {
  "ellisonleao/gruvbox.nvim",

  -- A colorscheme is part of the UI, so we want it available immediately at
  -- startup rather than lazy-loaded:
  lazy = false,    -- load during startup, not on-demand
  priority = 1000, -- load before all other plugins so nothing renders unthemed

  config = function()
    -- gruvbox has a light and dark variant; pin dark (the brown base).
    vim.o.background = "dark"

    require("gruvbox").setup({
      -- "hard"  -> darkest bg (#1d2021), most contrast, least brown
      -- ""      -> medium bg (#282828), the classic warm dark brown  <- chosen
      -- "soft"  -> lighter bg (#32302f), warmest, least contrast
      contrast = "",

      -- Make panel boundaries obvious. WinSeparator is the line BETWEEN splits;
      -- by default gruvbox draws it in a dim gray that blends in. We brighten it
      -- to gruvbox's light-gray foreground so split/panel edges read clearly.
      overrides = {
        WinSeparator = { fg = "#a89984", bg = "#282828" },
        -- Floating windows (hover/diagnostic/which-key): give them a slightly
        -- lifted background + a warm border so they stand off the main editor.
        NormalFloat = { bg = "#32302f" },
        FloatBorder = { fg = "#d79921", bg = "#32302f" },
      },
    })

    vim.cmd.colorscheme("gruvbox")

    -- Use a solid vertical bar for split separators (the highlight above is what
    -- makes it visible; this picks a clean glyph for it).
    vim.opt.fillchars:append({ vert = "│" })
  end,
}
