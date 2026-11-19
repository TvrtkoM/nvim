-- Language servers. Binaries come from Nix; nvim-lspconfig provides default
-- configs, vim.lsp.config() overrides them, vim.lsp.enable() starts them.

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp", -- capabilities below
    "folke/lazydev.nvim", -- must load before lua_ls starts
    "b0o/SchemaStore.nvim", -- JSON schemas for jsonls
  },
  config = function()
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- Diagnostics: signs + underline only; full message via <leader>d.
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
      signs = true,
      underline = true,
      severity_sort = true,
      update_in_insert = true, -- otherwise diagnostics from other files don't redraw in insert mode
      float = { source = true },
    })

    vim.keymap.set("n", "<leader>uv", function()
      local cfg = vim.diagnostic.config()
      if cfg.virtual_lines then
        vim.diagnostic.config({ virtual_lines = false })
      else
        vim.diagnostic.config({ virtual_lines = { current_line = true } })
      end
    end, { desc = "Toggle diagnostic virtual lines" })

    vim.lsp.inlay_hint.enable(true)
    vim.keymap.set("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle inlay hints" })

    local lsp_group = vim.api.nvim_create_augroup("user_lsp", { clear = true })

    -- Built-in defaults used as-is: K, grr, gri, grn, gra, grt, gO, [d, ]d.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = lsp_group,
      callback = function(event)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Goto definition")
        map("gD", vim.lsp.buf.declaration, "Goto declaration")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cl", vim.lsp.codelens.run, "Run code lens")
        map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
      end,
    })

    -- Vue hybrid mode: vue_ls handles templates, vtsls handles <script> via
    -- @vue/typescript-plugin, found inside the vue-language-server package.
    local function vue_ts_plugin_location()
      local exe = vim.fn.exepath("vue-language-server")
      if exe == "" then
        return nil
      end
      local real = vim.uv.fs_realpath(exe) or exe
      -- <store>/bin/vue-language-server -> <store>/lib/language-tools/packages/language-server
      local loc = vim.fs.dirname(vim.fs.dirname(real))
        .. "/lib/language-tools/packages/language-server"
      return vim.uv.fs_stat(loc .. "/node_modules/@vue/typescript-plugin") and loc or nil
    end

    local vtsls_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
    local vtsls_settings = {
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          variableTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
        },
      },
    }

    local vue_plugin_loc = vue_ts_plugin_location()
    if vue_plugin_loc then
      table.insert(vtsls_filetypes, "vue")
      vtsls_settings.vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_plugin_loc,
              languages = { "vue" },
              configNamespace = "typescript",
            },
          },
        },
      }
    end

    vim.lsp.config("vtsls", {
      filetypes = vtsls_filetypes,
      settings = vtsls_settings,
    })

    vim.lsp.config("eslint", {
      settings = { workingDirectory = { mode = "location" } }
    })

    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- Tailwind at-rules (@apply, ...) are handled by tailwindcss.
    vim.lsp.config("cssls", {
      settings = {
        css = { lint = { unknownAtRules = "ignore" } },
        scss = { lint = { unknownAtRules = "ignore" } },
        less = { lint = { unknownAtRules = "ignore" } },
      },
    })

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
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

    vim.lsp.config("nixd", {
      settings = {
        nixd = {
          nixpkgs = { expr = "import <nixpkgs> { }" },
        },
      },
    })

    vim.lsp.config("basedpyright", {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard", -- "basic"/"standard"/"strict"
            autoImportCompletions = true,
          },
        },
      },
    })

    -- Hover comes from basedpyright.
    vim.lsp.config("ruff", {
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    })

    vim.lsp.config("intelephense", {
      filetypes = { "php", "blade" },
      settings = {
        intelephense = {
          format = { enable = false }
        }
      },
      on_attach = function(client, bufnr)
        -- Blade syntax shows up as PHP errors; mute its diagnostics there.
        if vim.bo[bufnr].filetype == "blade" then
          local ns = vim.lsp.diagnostic.get_namespace(client.id)
          vim.diagnostic.enable(false, { bufnr = bufnr, ns_id = ns })
        end
      end,
    })

    -- Only in Laravel projects (fails to start without `artisan`).
    vim.lsp.config("laravel_ls", {
      root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(vim.api.nvim_buf_get_name(bufnr), { "artisan" })
        if root then
          on_dir(root)
        end
      end,
    })

    -- Only in Angular workspaces. The extra flag makes @for/@if/... completions
    -- expand to full snippets; it's appended by wrapping the rpc.start call
    -- that lspconfig's default cmd makes, keeping its node_modules probing.
    local angularls_default_cmd = vim.lsp.config.angularls.cmd
    vim.lsp.config("angularls", {
      workspace_required = true,
      cmd = function(dispatchers, config)
        local rpc_start = vim.lsp.rpc.start
        vim.lsp.rpc.start = function(cmd, ...)
          return rpc_start(vim.list_extend(vim.deepcopy(cmd), { "--includeCompletionsWithSnippetText" }), ...)
        end
        local ok, client = pcall(angularls_default_cmd, dispatchers, config)
        vim.lsp.rpc.start = rpc_start
        if not ok then
          error(client)
        end
        return client
      end,
    })

    -- angularls ignores a template until its component .ts is open, so load
    -- foo.ts / foo.component.ts in the background and attach to it.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = lsp_group,
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client or client.name ~= "angularls" or vim.bo[event.buf].filetype ~= "htmlangular" then
          return
        end
        local base = vim.api.nvim_buf_get_name(event.buf):gsub("%.html$", "")
        for _, ts in ipairs({ base .. ".ts", base .. ".component.ts" }) do
          if vim.uv.fs_stat(ts) then
            local ts_buf = vim.fn.bufadd(ts)
            vim.fn.bufload(ts_buf)
            -- bufload() skips filetype detection.
            if vim.bo[ts_buf].filetype == "" then
              vim.api.nvim_buf_call(ts_buf, function() vim.cmd("filetype detect") end)
            end
            if not vim.lsp.buf_is_attached(ts_buf, client.id) then
              vim.lsp.buf_attach_client(ts_buf, client.id)
            end
            return
          end
        end
      end,
    })

    -- Add blade and Angular templates to the html and emmet servers.
    for _, name in ipairs({ "html", "emmet_language_server" }) do
      local fts = vim.deepcopy(vim.lsp.config[name].filetypes or {})
      local changed = false
      for _, ft in ipairs({ "blade", "htmlangular" }) do
        if not vim.tbl_contains(fts, ft) then
          table.insert(fts, ft)
          changed = true
        end
      end
      if changed then
        vim.lsp.config(name, { filetypes = fts })
      end
    end

    -- server name -> executable; enabled only if the executable is on PATH
    local servers = {
      vtsls         = "vtsls",
      html          = "vscode-html-language-server",
      lua_ls        = "lua-language-server",
      eslint        = "vscode-eslint-language-server",
      jsonls        = "vscode-json-language-server",
      cssls         = "vscode-css-language-server",
      rust_analyzer = "rust-analyzer",
      nixd          = "nixd",
      basedpyright  = "basedpyright",
      ruff          = "ruff",
      tailwindcss   = "tailwindcss-language-server",
      emmet_language_server = "emmet-language-server",
      vue_ls        = "vue-language-server",
      angularls     = "ngserver",
      intelephense  = "intelephense",
      laravel_ls    = "laravel-ls",
    }
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

    -- Re-check once direnv has loaded a project's environment (devshell servers).
    vim.api.nvim_create_autocmd("User", {
      group = lsp_group,
      pattern = "DirenvLoaded",
      callback = enable_available_servers,
    })
  end,
}
