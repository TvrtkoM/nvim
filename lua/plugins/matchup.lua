-- vim-matchup: extends `%` to jump between matching open/close HTML & JSX tags
-- (and keywords like if/end), on top of the built-in matchit pair matching.
--   %      jump to the matching tag
--   g%     jump backward to the match
--   [% ]%  go to the outer open / close of the surrounding pair
--   a% i%  text objects for the whole tag pair / its contents

return {
  "andymass/vim-matchup",
  init = function()
    -- Show the off-screen match in the status line instead of a popup window.
    vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
  end,
}
