-- Completion engine.

return {
  "saghen/blink.cmp",
  version = "1.*", -- release tag = prebuilt Rust matcher, no compile step
  dependencies = { "L3MON4D3/LuaSnip" },

  opts = {
    -- "default" preset: <C-y> accept, <C-n>/<C-p> next/prev, <C-e> hide,
    -- <C-space> open/toggle docs, <Tab>/<S-Tab> jump snippet placeholders.
    keymap = {
      preset = "default",
      -- Snippets aren't in the auto list; <C-s> shows only snippets.
      ["<C-s>"] = {
        function(cmp) cmp.show({ providers = { "snippets" } }) end,
      },
    },

    appearance = { nerd_font_variant = "mono" },

    completion = {
      documentation = { auto_show = true },
      list = {
        selection = {
          preselect = true,
          -- Required: live-inserting the previewed item corrupts text typed
          -- into LuaSnip placeholders.
          auto_insert = false,
        },
      },
    },

    sources = {
      default = { "lazydev", "lsp", "path", "buffer" },
      providers = {
        lsp = {
          -- angularls sends @for/@if/... block completions with an empty range,
          -- so accepting after `@f` gives `@ffor`. Extend the range back to `@`.
          transform_items = function(ctx, items)
            for _, item in ipairs(items) do
              local range = item.client_name == "angularls"
                and item.detail == "block"
                and item.textEdit
                and item.textEdit.range
              if range and range.start.line == range["end"].line then
                local line = vim.api.nvim_buf_get_lines(ctx.bufnr, range.start.line, range.start.line + 1, false)[1] or ""
                local ok, start_byte = pcall(vim.str_byteindex, line, "utf-16", range.start.character)
                local at = ok and line:sub(1, start_byte):match("()@[%a ]*$")
                if at then
                  range.start.character = vim.str_utfindex(line, "utf-16", at)
                end
              end
            end
            return items
          end,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- rank above LSP in Lua files
        },
      },
    },

    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    snippets = { preset = "luasnip" },
  },

  opts_extend = { "sources.default" },
}
