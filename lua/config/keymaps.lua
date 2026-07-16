-- In any terminal buffer (Claude split included), <C-q> leaves insert/terminal
-- mode and enters Terminal-Normal mode for scrolling/yanking. We avoid <Esc>
-- here on purpose so Esc still passes through to programs that use it (Claude
-- uses Esc to interrupt). Press i/a to start typing again.
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { desc = "Terminal: enter Normal mode" })

-- Yank a Claude-style file reference (@path#L12 or @path#L12-L34) for the current
-- line or visual selection into the system clipboard, ready to paste into Claude.
-- Path is relative to nvim's cwd (":." modifier) — the dir Claude runs in.
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

-- Increase/Decrease/Reset font size in Neovide
vim.keymap.set("n", "<C-+>", function()
  vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1.0) * 1.25
end)
vim.keymap.set("n", "<C-->", function()
  vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1.0) * 0.8
end)
vim.keymap.set("n", "<C-0>", function() vim.g.neovide_scale_factor = 1.0 end)
