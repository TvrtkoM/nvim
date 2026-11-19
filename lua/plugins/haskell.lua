-- Haskell IDE: starts and configures HLS (install HLS via GHCup, not Nix/Mason,
-- so it matches the project's GHC).

return {
  "mrcjkb/haskell-tools.nvim",
  version = "^10",
  lazy = false, -- lazy-loads itself on the haskell filetype
  init = function()
    vim.g.haskell_tools = {
      hls = {
        default_settings = {
          haskell = {
            formattingProvider = "none", -- conform runs fourmolu
          },
        },
      },
    }

    -- .tidal files are filetype=haskell but not Haskell projects: detach HLS.
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
