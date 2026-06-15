-- blink.cmp: the completion engine — the popup of suggestions as you type,
-- fed by LSP (vtsls), snippets, file paths, and words in open buffers.
-- It ships a prebuilt Rust fuzzy-matcher binary via the version tag below, so
-- there's no cargo/compile step (unlike Treesitter — no toolchain saga here).

return {
  "saghen/blink.cmp",
  -- A release tag makes lazy.nvim download the matching prebuilt binary.
  version = "1.*",
  -- A big community snippet collection (React/TS/etc.), exposed via the
  -- "snippets" source below.
  dependencies = { "rafamadriz/friendly-snippets" },

  opts = {
    -- Keymap preset. "default" is blink's own scheme:
    --   <C-space> open menu / toggle docs    <C-e> hide
    --   <C-y> ACCEPT the selected item       <C-n>/<C-p> next/prev
    --   <Tab>/<S-Tab> jump between snippet placeholders
    -- Prefer accepting with Enter or Tab instead? Swap to "enter" or
    -- "super-tab" here.
    keymap = { preset = "default" },

    -- Icons in the menu need a Nerd Font in your terminal. If you see boxes
    -- instead of icons, install one (or this is harmless to ignore).
    appearance = { nerd_font_variant = "mono" },

    completion = {
      -- Auto-show the documentation/details popup next to the selected item.
      documentation = { auto_show = true },
    },

    -- Where completions come from, in priority order. "lazydev" feeds Neovim
    -- API / plugin-module completions in Lua files (no-op elsewhere).
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
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
  },

  -- Lets other plugin files append to sources.default instead of overwriting it.
  opts_extend = { "sources.default" },
}
