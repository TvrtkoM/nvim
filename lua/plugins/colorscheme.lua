return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000, -- load before other plugins

  config = function()
    vim.o.background = "dark"

    require("gruvbox").setup({
      contrast = "", -- "hard" | "" | "soft"
      -- Make split separators and floats stand out.
      overrides = {
        WinSeparator = { fg = "#a89984", bg = "#282828" },
        NormalFloat = { bg = "#32302f" },
        FloatBorder = { fg = "#d79921", bg = "#32302f" },
      },
    })

    vim.cmd.colorscheme("gruvbox")
    vim.opt.fillchars:append({ vert = "│" })
  end,
}
