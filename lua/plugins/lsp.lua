-- LSP: the language-server layer. This is what gives you type errors, hover
-- docs, go-to-definition, references, rename, and code actions for TypeScript.
--
-- The stack (modern Neovim 0.11+ way):
--   * nix                 -> installs the server BINARIES (home.packages, or a
--                            project's `nix develop` shell for per-project tools)
--   * nvim-lspconfig      -> ships the per-server default configs (cmd, root dir, ...)
--   * vim.lsp.config()    -> Neovim core API for per-server overrides
--   * vim.lsp.enable()    -> Neovim core API that actually starts a server; called
--                            from the guarded loop at the bottom of this file

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Listed here so blink is loaded before this config runs, making its
    -- completion capabilities available below.
    "saghen/blink.cmp",
    -- Loaded before lua_ls is enabled below, so lua_ls attaches with lazydev's
    -- Neovim type library already in place (no transient undefined-global flash).
    "folke/lazydev.nvim",
    -- Bundles the schemastore.org catalog so jsonls knows which schema applies to
    -- tsconfig.json, package.json, etc. — this is what gives VSCode-style JSON
    -- completion + validation. A library (no setup/spec of its own).
    "b0o/SchemaStore.nvim",
  },
  config = function()
    -- Tell every language server that our client (via blink.cmp) supports rich
    -- completion + snippets. `vim.lsp.config('*', ...)` applies to all servers.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- 1. Diagnostics display. Minimal, non-intrusive: no inline message text at
    --    all (no virtual_text, no virtual_lines). The always-on indicators are
    --    the sign-column marker (E/W — WHICH lines have problems) and an underline
    --    under the exact offending span. Press <leader>d to open a float with the
    --    full diagnostic message(s) for the current line on demand.
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
      signs = true,     -- E/W markers in the sign column: the global "here be errors" map
      underline = true, -- squiggle under the exact offending token
      severity_sort = true,
      update_in_insert = true,
      float = { border = "rounded", source = true }, -- the <leader>d / hover float
    })

    -- Toggle virtual_lines on/off. Default view is clean (signs + underline only);
    -- press this to reveal the full diagnostic message BELOW the current line
    -- (wraps properly — good for HLS's long multi-line type errors), press again
    -- to return to the clean default.
    vim.keymap.set("n", "<leader>uv", function()
      local cfg = vim.diagnostic.config()
      if cfg.virtual_lines then
        vim.diagnostic.config({ virtual_lines = false })
      else
        vim.diagnostic.config({ virtual_lines = { current_line = true } })
      end
    end, { desc = "Toggle diagnostic virtual lines" })

    -- 2. Buffer-local keymaps, set only once a server attaches to a buffer.
    --    (Neovim 0.11 has some built-in LSP defaults like K=hover, grn=rename,
    --    gra=code action, grr=references; these add friendlier aliases.)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Goto definition")
        map("gD", vim.lsp.buf.declaration, "Goto declaration")
        map("gi", vim.lsp.buf.implementation, "Goto implementation")
        map("gr", vim.lsp.buf.references, "References")
        map("K", vim.lsp.buf.hover, "Hover docs")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cl", vim.lsp.codelens.run, "Run code lens")
        map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
        map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
        map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
      end,
    })

    -- 3. Per-server overrides. nvim-lspconfig already provides the base config
    --    for `vtsls`; this MERGES on top. Inlay hints are a nice TS extra.
    vim.lsp.config("vtsls", {
      settings = {
        typescript = {
          inlayHints = {
            parameterNames = { enabled = "literals" },
            variableTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
          },
        },
      },
    })

    vim.lsp.config("eslint", {
      settings = { workingDirectory = { mode = "location" } }
    })

    -- jsonls: JSON completion/validation from schemas. Feed it the schemastore
    -- catalog (matched to files by name) so tsconfig.json, package.json, etc. get
    -- the same schema-driven autocomplete as VSCode. Attaches to json + jsonc.
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          -- Use clippy instead of plain `cargo check` for on-save diagnostics:
          -- same type errors, plus clippy's lint suggestions.
          checkOnSave = true,
          check = { command = "clippy" },
          cargo = { allFeatures = true },
          inlayHints = {
            parameterHints = { enable = true },
            typeHints = { enable = true },
          },
        },
      },
    })
    -- nixd: Nix LSP, installed declaratively via home.packages.
    --
    -- nixpkgs.expr gives package-name completion + hover on `pkgs.<...>`.
    -- NixOS *option* completion would need an additional options.nixos.expr
    -- pointing at this machine's evaluated config; deliberately left out.
    vim.lsp.config("nixd", {
      settings = {
        nixd = {
          nixpkgs = { expr = "import <nixpkgs> { }" },
        },
      },
    })

    local servers = {
      vtsls         = "vtsls",
      lua_ls        = "lua-language-server",
      eslint        = "vscode-eslint-language-server",
      jsonls        = "vscode-json-language-server",
      rust_analyzer = "rust-analyzer",
      nixd          = "nixd",
    }
    -- Re-runnable: devshell servers (rust-analyzer) only land on PATH once
    -- direnv exports, which is after startup. Idempotent via `enabled`.
    local enabled = {}
    local function enable_available_servers()
      for server, bin in pairs(servers) do
        if not enabled[server] and vim.fn.executable(bin) == 1 then
          enabled[server] = true
          vim.lsp.enable(server)
        end
      end
    end

    enable_available_servers()

    -- direnv.vim fires this after applying the exported env, so PATH is updated.
    vim.api.nvim_create_autocmd("User", {
      pattern = "DirenvLoaded",
      callback = enable_available_servers,
    })
  end,
}
