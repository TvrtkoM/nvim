-- In any terminal buffer (Claude split included), <C-q> leaves insert/terminal
-- mode and enters Terminal-Normal mode for scrolling/yanking. We avoid <Esc>
-- here on purpose so Esc still passes through to programs that use it (Claude
-- uses Esc to interrupt). Press i/a to start typing again.
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { desc = "Terminal: enter Normal mode" })
