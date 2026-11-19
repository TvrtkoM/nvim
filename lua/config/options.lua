-- Only non-default settings live here.

vim.opt.termguicolors = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.showmode = false -- lualine shows it
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.o.equalalways = false -- don't resize all splits when one opens/closes

-- Indentation (ftplugins and .editorconfig override per file)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Search: case-insensitive unless the pattern has a capital
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Popups
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.o.winborder = "rounded" -- border on all floats (hover, signature, diagnostics)

-- Persistent undo; no swap/backup files
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.updatetime = 300 -- CursorHold delay
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0

-- System clipboard. Deferred: the first access probes for a clipboard tool,
-- which would slow startup.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Treesitter folding, all folds open
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldtext = "" -- show the folded line, highlighted

vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Reload files changed outside Neovim (e.g. edited by Claude). `autoread` only
-- acts on :checktime, so trigger it on focus, buffer switch, idle and TermLeave.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("auto_reload_changed_files", { clear = true }),
  callback = function()
    if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = "auto_reload_changed_files",
  callback = function()
    vim.notify("File changed on disk — buffer reloaded", vim.log.levels.INFO)
  end,
})
