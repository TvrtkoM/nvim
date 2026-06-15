-- Entry point. Keep this file tiny: it just loads modules from lua/.
-- `require("config.options")` loads lua/config/options.lua, and so on.

-- Leader keys MUST be set before lazy.nvim loads, because plugins read them
-- when they register their keymaps. Space is the common, ergonomic choice.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.lazy")
