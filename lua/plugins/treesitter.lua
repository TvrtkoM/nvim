-- Treesitter parsers + queries. Highlighting/indent are enabled per buffer by
-- the FileType autocmd below. Needs the tree-sitter CLI.

-- Parser names (not filetypes). Dependencies such as ecma, jsx, php_only and
-- html_tags are installed automatically.
local parsers = {
  "typescript",
  "tsx",
  "javascript",
  "jsdoc",
  "json",
  "html", -- blade's highlights inherit it
  "css",
  "vue",
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "markdown_inline",
  "latex",
  "bash",
  "rust",
  "python",
  "php",
  "phpdoc",
  "blade",
  "nix",
  "angular", -- filetype htmlangular
  "yaml",
  "toml",
  "regex",
  "diff",
  "gitcommit",
  "query",
  "haskell", -- also .tidal
  "supercollider",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- doesn't support lazy-loading
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter").install(parsers) -- async; no-op if installed

    -- Start Treesitter in any buffer whose filetype has a parser; pcall skips
    -- the rest.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end

        -- Only where an indents query exists, so ftplugin indentexpr (haskell)
        -- isn't overwritten.
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and vim.treesitter.query.get(lang, "indents") then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
