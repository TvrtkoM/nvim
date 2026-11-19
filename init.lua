-- Leader must be set before plugins load, since they read it when mapping keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
