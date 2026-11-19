-- Treesitter: parses code into a syntax tree for accurate highlighting,
-- indentation, and folding. This is the MAINTAINED COMMUNITY FORK under the
-- `neovim-treesitter` org (the original `nvim-treesitter/nvim-treesitter` was
-- archived April 2026). It's a ground-up rewrite, so the setup looks different
-- from older tutorials: highlighting is NOT a config flag — you install parsers,
-- then turn highlighting on per-file via an autocommand (see config below).

-- Parsers/queries to install. (Treesitter parser names — note these differ
-- from filetype names: .tsx uses the "tsx" parser, etc.)
--
-- IMPORTANT: this fork distributes queries per-language and resolves shared
-- parent queries via the registry's "requires" field. TypeScript's highlights
-- query is `; inherits: ecma`, so we MUST also install the `ecma` (and, for
-- TSX, `jsx`) query packs — otherwise only TS-specific captures apply and the
-- file looks flat. These are registry "queries_only" entries (no parser).
local parsers = {
  "ecma", -- shared ECMAScript queries (parent of js/ts/tsx) -- REQUIRED
  "jsx",  -- shared JSX queries (parent of tsx/jsx) -- REQUIRED for .tsx
  "typescript",
  "tsx",
  "javascript",
  "jsdoc",
  "json",
  "html",
  -- queries-only pack that `html` (and `blade`) inherit for tag/attribute
  -- highlights; install() does NOT pull it in automatically, hence listed.
  "html_tags",
  "css",
  "vue", -- .vue SFCs; injects html/css/js/ts into the template & script blocks
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "markdown_inline",
  "latex",
  "bash",
  "rust",
  "python",
  "php",           -- outer grammar: HTML with <?php ?> islands
  "php_only",      -- REQUIRED: code inside the tags is highlighted via an
                   -- injection into this grammar; without it, PHP looks flat
  "phpdoc",        -- /** @param */ docblocks inside PHP
  "blade",         -- Laravel Blade; embeds html, injects php_only for {{ }}
  "nix",
  "angular",       -- Angular templates (filetype htmlangular); inherits html
  "yaml",
  "toml",
  "regex",         -- highlights regex literals inside JS/TS/Python/... strings
  "diff",          -- git diffs / :Gitsigns diffthis / patches
  "gitcommit",     -- commit message buffers
  "query",         -- .scm query files (like the overrides in queries/)
  "haskell",       -- TidalCycles is a Haskell DSL; .tidal buffers use this parser
  "supercollider", -- SuperDirt / SuperCollider .scd files
}

return {
  "neovim-treesitter/nvim-treesitter",
  -- The parser registry tells the plugin where to fetch each language grammar.
  dependencies = { "neovim-treesitter/treesitter-parser-registry" },
  lazy = false,        -- the rewrite explicitly does not support lazy-loading
  build = ":TSUpdate", -- compile/update parsers when the plugin is installed/updated

  config = function()
    -- Make sure the parsers we listed are installed (runs async in background).
    require("nvim-treesitter").install(parsers)

    -- Turn on Treesitter for ANY buffer whose filetype has an installed
    -- parser. Neovim maps filetype -> parser itself (sh -> bash, htmlangular ->
    -- angular, typescriptreact -> tsx, ...), so there's no second hand-kept
    -- filetype list to drift out of sync with `parsers` above. Buffers with no
    -- parser (oil, telescope prompts, plain text) make start() error, which
    -- pcall swallows — they simply keep regex/no highlighting.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end

        -- Indentation driven by the syntax tree (great for JSX/TSX). Only wire
        -- this up for languages that actually ship an `indents` query. Haskell
        -- does NOT (its layout rule is too contextual for a tree-sitter indent
        -- query), so for .hs/.tidal we leave indentexpr to our own ftplugin
        -- (after/ftplugin/haskell.lua) instead of clobbering it with a no-op.
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and vim.treesitter.query.get(lang, "indents") then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        -- NOTE: folding via Treesitter is configured globally in
        -- lua/config/options.lua (foldmethod=expr, foldexpr=treesitter).
      end,
    })
  end,
}
