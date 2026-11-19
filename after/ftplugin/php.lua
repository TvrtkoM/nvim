-- 4-space indent (PER-CS), unless .editorconfig sets indentation.
local ec = vim.b.editorconfig
if not (ec and (ec.indent_size or ec.indent_style)) then
  vim.bo.expandtab = true
  vim.bo.shiftwidth = 4
  vim.bo.tabstop = 4
  vim.bo.softtabstop = 4
end
