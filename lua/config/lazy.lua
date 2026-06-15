-- Bootstrap lazy.nvim: if it isn't installed yet, clone it into Neovim's data dir.
-- stdpath("data") is ~/.local/share/nvim, so lazy.nvim lives outside this config.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
-- Put lazy.nvim at the front of the runtimepath so `require("lazy")` resolves.
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Auto-import every .lua file in lua/plugins/. Each one returns a plugin spec.
  spec = {
    { import = "plugins" },
  },

  -- Don't auto-check for plugin updates in the background; we'll do it via :Lazy.
  checker = { enabled = false },

  -- Watch config files and reload specs on save, but without the popup on every
  -- save (set enabled = false to turn the reload off entirely).
  change_detection = { enabled = true, notify = false },
})
