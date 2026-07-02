-- SuperCollider (scnvim) which-key labels. scnvim's map() sets the actual
-- keymaps buffer-local (only in .scd/.sc buffers) but carries no `desc`, so we
-- label them here — also buffer-local (buffer = 0 = this buffer). Previously
-- these lived in which-key's GLOBAL spec (lua/plugins/which-key.lua), which made
-- them show in EVERY buffer (even Haskell) while the maps only worked in SC
-- buffers. Registering per-buffer here ties the labels to the SC buffer's life.
local ok, wk = pcall(require, "which-key")
if not ok then
  return
end
wk.add({
  { "<leader>s", group = "supercollider", buffer = 0 },
  { "<leader>sl", desc = "Send line", buffer = 0 },
  { "<leader>ss", desc = "Send selection", mode = "x", buffer = 0 },
  { "<leader>sb", desc = "Send block", buffer = 0 },
  { "<leader>sL", desc = "Launch sclang", buffer = 0 },
  { "<leader>sr", desc = "Recompile class library", buffer = 0 },
  { "<leader>sh", desc = "Stop sound (hard stop)", buffer = 0 },
  { "<leader>sp", desc = "Toggle post window", buffer = 0 },
  { "<leader>sP", desc = "Clear post window", buffer = 0 },
  { "<leader>si", desc = "Show signature", buffer = 0 },
})
