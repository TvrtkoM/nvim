-- Editor options. Only settings that DIFFER from Neovim's defaults live here;
-- Neovim already ships sane defaults for hidden, hlsearch, incsearch,
-- autoindent, backspace, encoding, undodir, etc. (see :h vim-differences).

vim.opt.termguicolors = true
-- Colorscheme is set by the gruvbox plugin (lua/plugins/colorscheme.lua).

-- Line numbers + layout
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.showmode = false -- lualine already shows the mode
vim.opt.splitbelow = true -- horizontal splits open below
vim.opt.splitright = true -- vertical splits open to the right
vim.o.equalalways = false -- don't resize every split when one opens/closes

-- Indentation: 2 spaces by default (ftplugins/.editorconfig override per file).
-- No `smartindent`: Treesitter / ftplugin indentexpr handle real indenting, and
-- smartindent's legacy C-style rules shove lines starting with `#` to column 0.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Search: case-insensitive unless the pattern contains a capital.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Popups. `winborder` (Neovim 0.11+) is the one switch that gives EVERY float a
-- border — LSP hover (K), signature help, diagnostic float — since 0.11's hover
-- no longer takes per-call border options.
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.o.winborder = "rounded"

-- Persistent undo (stored in Neovim's default ~/.local/state/nvim/undo/), and no
-- swap/backup files.
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.updatetime = 300 -- CursorHold delay (also drives auto-reload below)
vim.opt.timeoutlen = 500 -- wait for the next key of a mapping
vim.opt.ttimeoutlen = 0  -- don't wait after <Esc> for terminal key codes

-- Use the system clipboard for all yanks/deletes. Set after startup: the first
-- clipboard access probes for xclip/wl-copy, which would otherwise be paid
-- during startup.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Folding: Treesitter-based (no-op for buffers without a parser), all open.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldtext = "" -- show the folded line itself, syntax-highlighted

vim.opt.diffopt:append("linematch:60") -- better alignment of changed lines in diffs
vim.opt.redrawtime = 10000             -- don't give up highlighting big files
vim.opt.maxmempattern = 20000

-- Briefly flash the yanked region so you can see what was copied.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Auto-reload files changed outside Neovim (e.g. by the Claude agent editing a
-- file). `autoread` (on by default) only re-reads on a `:checktime`, which
-- normally fires only on focus/shell events — so we trigger it ourselves.
-- CursorHold picks up changes while you sit in a buffer (after `updatetime`);
-- TermLeave catches edits made by the Claude terminal split.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("auto_reload_changed_files", { clear = true }),
  callback = function()
    -- Don't run in command-line window or non-file buffers (avoids errors).
    if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

-- When a reload happens, let you know rather than silently swapping content.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = "auto_reload_changed_files",
  callback = function()
    vim.notify("File changed on disk — buffer reloaded", vim.log.levels.INFO)
  end,
})
