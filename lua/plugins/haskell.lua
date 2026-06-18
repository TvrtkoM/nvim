-- haskell-tools.nvim: batteries-included Haskell IDE layer. It configures and
-- starts haskell-language-server (HLS) itself — do NOT add HLS to
-- mason-lspconfig; this plugin owns it. Standard LSP keymaps (gd/gr/K/<leader>rn
-- etc.) come from the shared LspAttach autocmd in lua/plugins/lsp.lua, and blink
-- completion capabilities are inherited from the `vim.lsp.config("*", …)` default
-- set there. Configured via `vim.g.haskell_tools` (must be set before load).
--
-- External prerequisite: `haskell-language-server` on PATH. Install via GHCup
-- (`ghcup install hls`) — that keeps HLS matched to your project's GHC, which is
-- far more reliable than Mason for Haskell. GHC + cabal also come from GHCup.
--
-- Formatting is handled by conform.nvim (fourmolu), to stay consistent with the
-- rest of this config — so HLS's own formatter is turned off below.
--
-- `.tidal` GOTCHA: tidal.nvim sets .tidal files to filetype=haskell, which would
-- otherwise make HLS attach and flood them with "not a Haskell project" errors.
-- The LspAttach guard below detaches HLS from any .tidal buffer.

return {
  "mrcjkb/haskell-tools.nvim",
  version = "^10",
  lazy = false, -- the plugin manages its own lazy-loading on the haskell filetype
  init = function()
    vim.g.haskell_tools = {
      hls = {
        default_settings = {
          haskell = {
            -- Let conform.nvim + fourmolu own formatting (see conform.lua).
            formattingProvider = "none",
          },
        },
      },
    }

    -- Keep HLS off TidalCycles buffers (filetype=haskell, but .tidal files).
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("haskell_no_hls_on_tidal", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end
        local name = client.name:lower()
        if name == "hls" or name:find("haskell") then
          if vim.api.nvim_buf_get_name(args.buf):match("%.tidal$") then
            vim.schedule(function()
              vim.lsp.buf_detach_client(args.buf, args.data.client_id)
            end)
          end
        end
      end,
    })
  end,
}
