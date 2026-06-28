-- blink.cmp: the completion engine — the popup of suggestions as you type,
-- fed by LSP (vtsls), snippets, file paths, and words in open buffers.
-- It ships a prebuilt Rust fuzzy-matcher binary via the version tag below, so
-- there's no cargo/compile step (unlike Treesitter — no toolchain saga here).

return {
  "saghen/blink.cmp",
  -- A release tag makes lazy.nvim download the matching prebuilt binary.
  version = "1.*",
  -- LuaSnip is our snippet engine (see lua/plugins/luasnip.lua). Listed as a
  -- dependency so it loads first; blink expands/jumps snippets through it and
  -- sources snippet items from it (LuaSnip carries friendly-snippets along).
  dependencies = { "L3MON4D3/LuaSnip" },

  opts = {
    -- Keymap preset. "default" is blink's own scheme:
    --   <C-space> open menu / toggle docs    <C-e> hide
    --   <C-y> ACCEPT the selected item       <C-n>/<C-p> next/prev
    --   <Tab>/<S-Tab> jump between snippet placeholders
    -- Prefer accepting with Enter or Tab instead? Swap to "enter" or
    -- "super-tab" here.
    keymap = {
      preset = "default",
      -- Snippets are NOT in the auto-completion list below, so they don't
      -- clutter the menu while typing. Press <C-s> to open a menu containing
      -- ONLY snippets, filtered by the text you've already typed.
      ["<C-s>"] = {
        function(cmp) cmp.show({ providers = { "snippets" } }) end,
      },
    },

    -- Icons in the menu need a Nerd Font in your terminal. If you see boxes
    -- instead of icons, install one (or this is harmless to ignore).
    appearance = { nerd_font_variant = "mono" },

    completion = {
      -- Auto-show the documentation/details popup next to the selected item.
      documentation = { auto_show = true },
      list = {
        selection = {
          -- Keep the first item highlighted...
          preselect = true,
          -- ...but DON'T live-insert it on every keystroke. blink's default
          -- auto_insert writes the previewed completion into the buffer as you
          -- type, which collides with LuaSnip's placeholder region and throws
          -- the cursor back (typing "Cl" yielded "lC"). With this off, text is
          -- inserted only when you explicitly accept (<C-y>).
          auto_insert = false,
        },
      },
    },

    -- Where completions come from, in priority order. "lazydev" feeds Neovim
    -- API / plugin-module completions in Lua files (no-op elsewhere).
    sources = {
      -- No "snippets" here on purpose: while typing you only get LSP / path /
      -- buffer (and lazydev in Lua). Snippets are summoned on demand with <C-s>
      -- (see the keymap above). They still expand via LuaSnip.
      default = { "lazydev", "lsp", "path", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- rank lazydev results above LSP in lua files
        },
      },
    },

    -- Show function signature help (param hints) while typing call arguments.
    signature = { enabled = true },

    -- Use the fast Rust matcher; warn (don't error) if the binary is missing.
    fuzzy = { implementation = "prefer_rust_with_warning" },

    -- Expand/jump snippets via LuaSnip instead of the built-in vim.snippet.
    -- This also makes blink's "snippets" source pull items from LuaSnip (which
    -- has friendly-snippets loaded), filetype-scoped.
    snippets = { preset = "luasnip" },
  },

  -- Lets other plugin files append to sources.default instead of overwriting it.
  opts_extend = { "sources.default" },
}
