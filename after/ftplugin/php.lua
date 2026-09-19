-- Default PHP indentation to @PER-CS (4 spaces, no tabs) — matches php-cs-fixer's
-- @PER-CS ruleset used for formatting. A project's .editorconfig still wins: if
-- it set indentation for this buffer, leave those values alone.
local ec = vim.b.editorconfig
if not (ec and (ec.indent_size or ec.indent_style)) then
  vim.bo.expandtab = true
  vim.bo.shiftwidth = 4
  vim.bo.tabstop = 4
  vim.bo.softtabstop = 4
end
