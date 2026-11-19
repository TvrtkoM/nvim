-- Haskell indentation. Treesitter has no haskell indent query, so this is a
-- heuristic: indent one level after a line that opens a block, otherwise keep
-- the previous line's indent. Also applies to .tidal files (filetype=haskell).

local function ends_with_opener(line)
  line = line:gsub("%s*%-%-.*$", "") -- ignore trailing comment
  return line:match("[=(%[{,]%s*$") -- = ( [ { ,
    or line:match("%->%s*$") -- ->
    or line:match("%f[%w]do%s*$")
    or line:match("%f[%w]where%s*$")
    or line:match("%f[%w]of%s*$")
    or line:match("%f[%w]let%s*$")
    or line:match("%f[%w]then%s*$")
    or line:match("%f[%w]else%s*$")
    or line:match("%f[%w]in%s*$")
end

-- Global so 'indentexpr' can call it.
function _G.HaskellIndent()
  local lnum = vim.v.lnum
  local prevnum = vim.fn.prevnonblank(lnum - 1)
  if prevnum == 0 then
    return 0
  end

  local prev = vim.fn.getline(prevnum)
  local indent = vim.fn.indent(prevnum)

  if ends_with_opener(prev) then
    return indent + vim.fn.shiftwidth()
  end

  return indent
end

-- haskell-tools keymaps (buffer-local)
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
-- Yank via register h so the system clipboard isn't overwritten.
rmap("n", "<leader>rp", function() vim.cmd('normal! "hyy') ht.repl.paste("h") end, "Send line to repl")
rmap("x", "<leader>rp", function() vim.cmd('normal! "hy') ht.repl.paste("h") end, "Send selection to repl")

rmap("n", "<leader>hh", ht.hoogle.hoogle_signature, "Hoogle signature (cword)")
rmap("n", "<leader>hH", function()
  vim.ui.input({ prompt = "Hoogle: " }, function(input)
    if input and input ~= "" then
      ht.hoogle.hoogle_signature({ search_term = input })
    end
  end)
end, "Hoogle search (free)")
rmap("n", "<leader>he", ht.lsp.buf_eval_all, "Eval all comments (-- >>>)")
rmap("n", "<leader>hs", function() vim.cmd("Haskell hls restart") end, "Restart HLS")

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    { "<leader>r", group = "repl", buffer = 0 },
    { "<leader>h", group = "haskell", buffer = 0 },
  })

  -- Tidal (.tidal files are filetype=haskell). tidal.nvim maps the send keys
  -- without descriptions, so label them here.
  if vim.api.nvim_buf_get_name(0):match("%.tidal$") then
    rmap("n", "<leader>tL", "<cmd>TidalLaunch<cr>", "Launch")
    rmap("n", "<leader>tq", "<cmd>TidalQuit<cr>", "Quit")
    wk.add({
      { "<leader>t", group = "tidal", buffer = 0 },
      { "<leader>tl", desc = "Send line", buffer = 0 },
      { "<leader>ts", desc = "Send selection", mode = "x", buffer = 0 },
      { "<leader>tb", desc = "Send block", mode = { "n", "x" }, buffer = 0 },
      { "<leader>tn", desc = "Send node", buffer = 0 },
      { "<leader>td", desc = "Silence dN", buffer = 0 },
      { "<leader>th", desc = "Hush all", buffer = 0 },
    })
  end
end

vim.bo.indentexpr = "v:lua.HaskellIndent()"
-- Re-indent only new lines. Keyword triggers (=where, =else, ...) would
-- re-indent the current line mid-typing, which this heuristic gets wrong.
vim.bo.indentkeys = "0{,0},0),0],!^F,o,O"
vim.bo.autoindent = true
