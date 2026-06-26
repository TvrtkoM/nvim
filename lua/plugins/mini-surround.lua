-- mini.surround: add/delete/replace surrounding pairs (quotes, brackets, tags).
-- A single standalone module from the mini.nvim family — we pull just this one,
-- not the whole collection, so it doesn't overlap with our existing plugins.
--
-- Usage (the `s` = "surround" prefix):
--   sa<motion><char>  add        e.g. visual-select then `sa"`  → wrap in "
--                                e.g. `saiw)`  → wrap word in ( )
--   sd<char>          delete     e.g. `sd"`     → remove surrounding "
--   sr<old><new>      replace    e.g. `sr"'`    → change "…" to '…'
--   sf / sF           find next/prev surrounding
--
-- NOTE: this takes over the built-in `s` (substitute char), which is just a
-- synonym for `cl` and rarely missed. If you want it back, change `mappings`
-- below to a different prefix (e.g. add a leading <leader>).
return {
  "echasnovski/mini.surround",
  version = "*", -- latest stable tag
  -- Lazy-load the moment one of the surround keys is pressed (n + visual).
  keys = {
    { "sa", mode = { "n", "x" }, desc = "Surround add" },
    { "sd", desc = "Surround delete" },
    { "sr", desc = "Surround replace" },
    { "sf", desc = "Surround find next" },
    { "sF", desc = "Surround find prev" },
  },
  opts = {}, -- defaults are good; lazy calls require("mini.surround").setup(opts)
}
