-- Haskell auto-indentation.
--
-- WHY THIS EXISTS: our Treesitter fork ships an `indents.scm` query for almost
-- every language, but NOT for haskell — its layout rule (significant, context-
-- dependent whitespace) is too contextual to express as a tree-sitter indent
-- query, so upstream never shipped one. HLS/haskell-tools doesn't do indentation
-- either. Without this, .hs (and .tidal, which is filetype=haskell) buffers stay
-- flat. So we provide a small heuristic indentexpr.
--
-- The heuristic: after a line that "opens" a block, indent one level deeper;
-- otherwise keep the previous line's indentation (plain autoindent). It is not a
-- full layout-rule implementation (there is no perfect one), but it covers the
-- common cases and you can always adjust by hand with >> / << / <Tab>.
--
-- NOTE ON ORDERING: treesitter.lua's FileType autocmd only sets a Treesitter
-- indentexpr for languages that have an `indents` query, so it deliberately
-- leaves haskell alone and this file's `indentexpr` wins.

local function ends_with_opener(line)
  -- Strip a trailing line comment so `do  -- start` still counts as opening.
  line = line:gsub("%s*%-%-.*$", "")
  -- Lines that introduce a deeper block / continuation.
  return line:match("[=(%[{,]%s*$") -- ends with =  (  [  {  ,
    or line:match("%->%s*$") -- ends with ->
    or line:match("%f[%w]do%s*$") -- `do`
    or line:match("%f[%w]where%s*$") -- `where`
    or line:match("%f[%w]of%s*$") -- `case … of`
    or line:match("%f[%w]let%s*$") -- `let`
    or line:match("%f[%w]then%s*$") -- `then`
    or line:match("%f[%w]else%s*$") -- `else`
    or line:match("%f[%w]in%s*$") -- `… in`
end

-- Global so it can be referenced from 'indentexpr' (which is evaluated in a
-- restricted context). Returns the number of columns to indent vim.v.lnum.
function _G.HaskellIndent()
  local lnum = vim.v.lnum
  local prevnum = vim.fn.prevnonblank(lnum - 1)
  if prevnum == 0 then
    return 0 -- first non-blank line: column 0
  end

  local prev = vim.fn.getline(prevnum)
  local indent = vim.fn.indent(prevnum)

  if ends_with_opener(prev) then
    return indent + vim.fn.shiftwidth()
  end

  return indent -- maintain the previous line's indent (autoindent behaviour)
end

-- GHCi REPL keymaps (haskell-tools.nvim). These are buffer-local (only in
-- Haskell buffers) and their which-key labels are registered buffer-local too
-- (buffer = 0), so they don't leak into other filetypes' which-key menus.
local ht = require("haskell-tools")
local rmap = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
end
rmap("n", "<leader>rr", ht.repl.toggle, "Toggle repl")
rmap("n", "<leader>rf", function() ht.repl.toggle(vim.api.nvim_buf_get_name(0)) end, "Repl (load this file)")
rmap("n", "<leader>re", ht.repl.reload, "Reload repl (:r)")
rmap("n", "<leader>rq", ht.repl.quit, "Quit repl")
rmap("n", "<leader>rt", ht.repl.cword_type, "Type of word (:t)")
rmap("n", "<leader>ri", ht.repl.cword_info, "Info on word (:i)")
-- Send code to the repl: yank then paste into the GHCi session.
rmap("n", "<leader>rp", function() vim.cmd("normal! yy") ht.repl.paste() end, "Send line to repl")
rmap("x", "<leader>rp", function() vim.cmd("normal! y") ht.repl.paste() end, "Send selection to repl")

-- Other haskell-tools features (not repl), under <leader>h.
rmap("n", "<leader>hh", ht.hoogle.hoogle_signature, "Hoogle signature")
rmap("n", "<leader>he", ht.lsp.buf_eval_all, "Eval all comments (-- >>>)")
rmap("n", "<leader>hs", function() vim.cmd("Haskell hls restart") end, "Restart HLS")

-- which-key group label, buffer-local so "+repl" shows only in Haskell buffers.
local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    { "<leader>r", group = "repl", buffer = 0 },
    { "<leader>h", group = "haskell", buffer = 0 },
  })

  -- TidalCycles which-key labels. .tidal files are filetype=haskell (tidal.nvim
  -- switches them), so there is NO `tidal` ftplugin — this haskell ftplugin is
  -- where per-buffer tidal setup belongs, guarded to .tidal files. tidal.nvim
  -- sets its send/silence maps buffer-local but with no `desc`; we label them
  -- here (buffer-local) so they show only in .tidal buffers, not every haskell
  -- buffer. tL/tq are global maps (see tidal.lua) but re-grouped here for a tidy
  -- "+tidal" menu inside tidal buffers.
  if vim.api.nvim_buf_get_name(0):match("%.tidal$") then
    wk.add({
      { "<leader>t", group = "tidal", buffer = 0 },
      { "<leader>tl", desc = "Send line", buffer = 0 },
      { "<leader>ts", desc = "Send selection", mode = "x", buffer = 0 },
      { "<leader>tb", desc = "Send block", mode = { "n", "x" }, buffer = 0 },
      { "<leader>tn", desc = "Send node", buffer = 0 },
      { "<leader>td", desc = "Silence dN", buffer = 0 },
      { "<leader>th", desc = "Hush all", buffer = 0 },
      { "<leader>tL", desc = "Launch", buffer = 0 },
      { "<leader>tq", desc = "Quit", buffer = 0 },
    })
  end
end

vim.bo.indentexpr = "v:lua.HaskellIndent()"
-- Only auto-indent NEW lines (o/O = open line, !^F = explicit re-indent, and the
-- 0-prefixed bracket entries = a closer typed at column start). We deliberately
-- do NOT include keyword triggers (=where/=in/=then/=else) or a bare `e`: those
-- re-indent the line you're ALREADY on the instant you finish typing the word,
-- and HaskellIndent (which just copies the previous line's indent) gets that
-- wrong — e.g. typing space after `where` on a top-level line would pull it in
-- to the previous nested line's indent.
vim.bo.indentkeys = "0{,0},0),0],!^F,o,O"
vim.bo.autoindent = true
