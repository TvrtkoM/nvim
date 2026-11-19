-- Surround editing (overrides built-in `s`):
--   sa<motion><char> add   sd<char> delete   sr<old><new> replace   sf/sF find

return {
  "echasnovski/mini.surround",
  version = "*",
  keys = {
    { "sa", mode = { "n", "x" },        desc = "Surround add" },
    { "sd", desc = "Surround delete" },
    { "sr", desc = "Surround replace" },
    { "sf", desc = "Surround find next" },
    { "sF", desc = "Surround find prev" },
  },
  opts = {},
}
