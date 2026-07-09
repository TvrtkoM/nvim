-- In any terminal buffer (Claude split included), <C-q> leaves insert/terminal
-- mode and enters Terminal-Normal mode for scrolling/yanking. We avoid <Esc>
-- here on purpose so Esc still passes through to programs that use it (Claude
-- uses Esc to interrupt). Press i/a to start typing again.
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { desc = "Terminal: enter Normal mode" })

-- Increase/Decrease/Reset font size in Neovide
vim.keymap.set("n", "<C-+>", function()
  vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1.0) * 1.25
end)
vim.keymap.set("n", "<C-->", function()
  vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1.0) * 0.8
end)
vim.keymap.set("n", "<C-0>", function() vim.g.neovide_scale_factor = 1.0 end)
