-- Treesitter: parses code into a syntax tree for accurate highlighting,
-- indentation, and folding. This is the MAINTAINED COMMUNITY FORK under the
-- `neovim-treesitter` org (the original `nvim-treesitter/nvim-treesitter` was
-- archived April 2026). It's a ground-up rewrite, so the setup looks different
-- from older tutorials: highlighting is NOT a config flag — you install parsers,
-- then turn highlighting on per-file via an autocommand (see config below).

-- Filetypes we want Treesitter active for. (Neovim filetype names.)
local filetypes = {
  "typescript",
  "typescriptreact", -- .tsx
  "javascript",
  "javascriptreact", -- .jsx
  "json",
  "html",
  "css",
  "lua", -- so editing this config looks good too
  "vim",
  "markdown",
  "bash",
  "haskell",       -- also covers TidalCycles: tidal.nvim sets .tidal files to filetype=haskell
  "supercollider", -- .scd SuperCollider files (SuperDirt sound engine)
}

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
  "css",
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "markdown_inline",
  "bash",
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

    -- Turn on Treesitter features whenever we open one of these filetypes.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        -- 1. Highlighting (resolves the right parser for this buffer's filetype).
        vim.treesitter.start()

        -- 2. Indentation driven by the syntax tree (great for JSX/TSX). Only wire
        --    this up for languages that actually ship an `indents` query. Haskell
        --    does NOT (its layout rule is too contextual for a tree-sitter indent
        --    query), so for .hs/.tidal we leave indentexpr to our own ftplugin
        --    (after/ftplugin/haskell.lua) instead of clobbering it with a no-op.
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype) or vim.bo.filetype
        if vim.treesitter.query.get(lang, "indents") then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        -- NOTE: folding via Treesitter is already configured globally in
        -- lua/config/options.lua (foldmethod=expr, foldexpr=treesitter). With
        -- parsers now installed, that folding actually works for these files.
      end,
    })
  end,
}
