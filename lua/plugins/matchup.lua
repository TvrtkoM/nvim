-- vim-matchup: extends `%` to jump between matching open/close HTML & JSX tags
-- (and keywords like if/end), on top of the built-in matchit pair matching.
--   %      jump to the matching tag
--   g%     jump backward to the match
--   [% ]%  go to the outer open / close of the surrounding pair
--   a% i%  text objects for the whole tag pair / its contents

return {
  "andymass/vim-matchup",
  init = function()
    -- When the match is off-screen (e.g. the `{` of a long function), show its
    -- line in a small popup at the top of the window. ("status_manual" — the
    -- previous value — only computes the text and never displays it unless the
    -- statusline calls MatchupStatusOffscreen(), which lualine doesn't.)
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
