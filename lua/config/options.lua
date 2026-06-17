vim.opt.termguicolors = true
-- Colorscheme is now set by the tokyonight plugin (lua/plugins/colorscheme.lua).

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
-- vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.showmatch = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
-- vim.opt.lazyredraw = true -- do not redraw during macros
-- vim.opt.synmaxcol = 300 -- syntax highlighting limit
-- vim.opt.fillchars = { eob = " " } -- hide ~ on empty lines

local undodir = vim.fn.expand("~/.vim/undodir")

if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.updatetime = 300 -- faster completion
vim.opt.timeoutlen = 500 -- timeout duration
vim.opt.ttimeoutlen = 0 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of neovim
-- vim.opt.autowrite = false -- do not auto-save

vim.opt.hidden = true -- allow hidden buffer
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start" -- better autosave behavior
vim.opt.autochdir = false -- don't autochange directories
-- vim.opt.iskeyword:append("-") -- include - in words
-- vim.opt.path:append("**") -- include subdirs in search
-- vim.opt.selection = "inclusive" -- include last char in selection
-- vim.opt.mouse = "a" -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true -- allow buffer modifications
vim.opt.encoding = "UTF-8"

-- Folding: requires treesitter; safe fallback if not
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

vim.opt.splitbelow = true -- horizontal splits open below
vim.opt.splitright = true -- vertical splits open to the right

vim.opt.wildmenu = true -- tab completion
vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60") -- improve diff display
vim.opt.redrawtime = 10000 -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000 -- increase max memory

-- In any terminal buffer (Claude split included), <C-q> leaves insert/terminal
-- mode and enters Terminal-Normal mode for scrolling/yanking. We avoid <Esc>
-- here on purpose so Esc still passes through to programs that use it (Claude
-- uses Esc to interrupt). Press i/a to start typing again.
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { desc = "Terminal: enter Normal mode" })

-- Auto-reload files changed outside Neovim (e.g. by the Claude agent editing a
-- file). `autoread` (set above) only re-reads on a `:checktime`, which normally
-- fires only on focus/shell events — so we trigger it ourselves on these events.
-- CursorHold picks up changes while you sit in a buffer (after `updatetime`);
-- TermLeave catches edits made by the Claude terminal split.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("auto_reload_changed_files", { clear = true }),
  pattern = "*",
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
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk — buffer reloaded", vim.log.levels.INFO)
  end,
})
