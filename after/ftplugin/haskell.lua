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

vim.bo.indentexpr = "v:lua.HaskellIndent()"
-- Recompute on these keys. The defaults (o, O, and newlines in insert) are what
-- drive auto-indent as you type; the bracket/`=` entries let re-indent (==) and
-- typing closers nudge things into place too.
vim.bo.indentkeys = "0{,0},0),0],!^F,o,O,e,=where,=in,=then,=else"
vim.bo.autoindent = true
