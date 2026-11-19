-- Formatting. Binaries come from Nix; debug with :ConformInfo.

-- Use the project's vp (vite-plus) if installed, else prettierd.
local web = { "vp", "prettierd", stop_after_first = true }

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer/selection",
      },
    },
    opts = {
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
        htmlangular     = web,
        vue             = web,
        markdown        = web,
        yaml            = web,
        graphql         = web,
        haskell         = { "fourmolu" }, -- .tidal files are skipped below
        rust            = { "rustfmt" },
        nix             = { "nixfmt" },
        python          = { "ruff_organize_imports", "ruff_format" },
        php             = { "pint", "php_cs_fixer", stop_after_first = true },
        blade           = { "blade-formatter" },
      },

      formatters = {
        nixfmt = { args = { "-" } }, -- read stdin explicitly (avoids a nixfmt warning)
        -- Resolves node_modules/.bin/vp per project; unavailable elsewhere.
        vp = {
          command = function(self, ctx)
            return require("conform.util").find_executable({ "node_modules/.bin/vp" }, "vp")(self, ctx)
          end,
          args = { "fmt", "--stdin-filepath", "$FILENAME" },
          stdin = true,
        },
        -- php-cs-fixer needs a ruleset: use the project's config, else @PER-CS.
        php_cs_fixer = {
          args = function(_, ctx)
            local has_config = vim.fs.find(
              { ".php-cs-fixer.php", ".php-cs-fixer.dist.php" },
              { path = ctx.dirname, upward = true }
            )[1]
            if has_config then
              return { "fix", "$FILENAME" }
            end
            return { "fix", "--rules=@PER-CS", "$FILENAME" }
          end,
        },
      },

      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- TidalCycles code, not a Haskell project.
        if vim.api.nvim_buf_get_name(bufnr):match("%.tidal$") then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
    config = function(_, opts)
      require("conform").setup(opts)

      -- :FormatDisable (! = this buffer only) / :FormatEnable
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
