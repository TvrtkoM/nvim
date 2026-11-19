-- Better `%`: also matches HTML/JSX tags and keywords. Adds g%, [%, ]%, a%, i%.

return {
  "andymass/vim-matchup",
  init = function()
    -- Show an off-screen match in a popup.
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
