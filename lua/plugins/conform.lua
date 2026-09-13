-- Formatting via conform.nvim. It runs a real formatter (prettierd) per
-- filetype, honoring your project's .prettierrc / prettier.config.js if present.
--
-- The formatter binaries come from Nix (home.packages, or a project's
-- `nix develop` shell),
-- or errors — check :ConformInfo, or ~/.local/state/nvim/conform.log.

-- Frontend filetypes vp (vite-plus/Oxfmt) can format. Use vp when the project
-- has it in node_modules (honoring its vite.config.ts `fmt` block); otherwise
-- fall back to prettierd. Shared table — conform reads it, never mutates it.
local web = { "vp", "prettierd", stop_after_first = true }

return {
  -- The formatter runner.
  {
    "stevearc/conform.nvim",
    -- Load right before a write (for format-on-save) or when used manually.
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Moved off <leader>f to avoid clashing with the <leader>f find group
        -- (which-key). "cf" = code format.
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer/selection",
      },
    },
    opts = {
      -- Which formatter to run for each filetype. prettierd is the Prettier
      -- daemon (kept warm in the background = near-instant formatting).
      formatters_by_ft = {
        typescript      = web,
        typescriptreact = web,
        javascript      = web,
        javascriptreact = web,
        json            = web,
        jsonc           = web,
        css             = web,
        scss            = web,
        less            = web,
        html            = web,
        vue             = web,
        markdown        = web,
        yaml            = web,
        graphql         = web,
        -- Real Haskell files. NOTE: `.tidal` files are also filetype=haskell but
        -- are TidalCycles code, not Haskell projects — format_on_save below skips
        -- them so fourmolu never rewrites your patterns.
        haskell         = { "fourmolu" },
        rust            = { "rustfmt" },
        -- nixfmt = the RFC-166 style, what nixpkgs itself uses.
        nix             = { "nixfmt" },
        -- python
        python          = { "ruff_organize_imports", "ruff_format" },
        -- php
        php             = { "pint", "php_cs_fixer", stop_after_first = true }
      },

      -- conform's built-in nixfmt recipe invokes the binary bare, which nixfmt
      -- now warns is deprecated for stdin; "-" is the supported spelling.
      formatters = {
        nixfmt = { args = { "-" } },
        -- require() is wrapped in functions so it runs when conform calls them
        -- (plugin loaded), not at spec-load time (which crashes: util not yet
        -- on the runtimepath). command resolves node_modules/.bin/vp per project,
        -- so the formatter is simply unavailable (→ prettierd) where vp isn't installed.
        vp = {
          command = function(self, ctx)
            return require("conform.util").find_executable({ "node_modules/.bin/vp" }, "vp")(self, ctx)
          end,
          args = { "fmt", "--stdin-filepath", "$FILENAME" },
          stdin = true,
        },
      },

      -- Format on save. Returns nil (skip) when a toggle flag is set, so you
      -- can disable it globally or per-buffer (see the commands below).
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Never run fourmolu on TidalCycles buffers (filetype=haskell but .tidal).
        if vim.api.nvim_buf_get_name(bufnr):match("%.tidal$") then
          return
        end
        -- lsp_format = "fallback": if no prettierd for this ft, let the LSP
        -- format instead. timeout guards against a hung formatter on save.
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- :FormatDisable  -> turn off format-on-save (add ! for current buffer only)
      -- :FormatEnable   -> turn it back on
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "Disable format-on-save", bang = true })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable format-on-save" })
    end,
  },
}
