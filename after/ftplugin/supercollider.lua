-- which-key labels for scnvim's keymaps (it maps them without descriptions).
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
