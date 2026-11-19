-- Leave terminal mode. Not <Esc>, so Esc still reaches terminal apps (e.g. Claude).
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { desc = "Terminal: enter Normal mode" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Copy a Claude file reference (@path#L12 or @path#L12-L34), path relative to cwd.
local function yank_claude_ref(visual)
  local path = vim.fn.expand("%:.")
  if path == "" then
    vim.notify("No file in this buffer", vim.log.levels.WARN)
    return
  end
  local ref
  if visual then
    local a, b = vim.fn.line("v"), vim.fn.line(".")
    if a > b then a, b = b, a end
    ref = a == b and string.format("@%s#L%d", path, a)
        or string.format("@%s#L%d-L%d", path, a, b)
  else
    ref = string.format("@%s#L%d", path, vim.fn.line("."))
  end
  vim.fn.setreg("+", ref)
  vim.fn.setreg('"', ref)
  vim.notify(ref)
end

vim.keymap.set("n", "<leader>ay", function() yank_claude_ref(false) end,
  { desc = "Yank @file#L ref" })
vim.keymap.set("x", "<leader>ay", function() yank_claude_ref(true) end,
  { desc = "Yank @file#L range ref" })

-- Font zoom (Neovide only).
if vim.g.neovide then
  local function scale(factor)
    return function()
      vim.g.neovide_scale_factor = factor and (vim.g.neovide_scale_factor or 1.0) * factor or 1.0
    end
  end
  vim.keymap.set("n", "<C-+>", scale(1.25), { desc = "Neovide: zoom in" })
  vim.keymap.set("n", "<C-->", scale(0.8), { desc = "Neovide: zoom out" })
  vim.keymap.set("n", "<C-0>", scale(nil), { desc = "Neovide: reset zoom" })
end
