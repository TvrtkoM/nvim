# Neovim — TypeScript IDE config

A modular Neovim setup for TypeScript/React development: Treesitter, LSP (vtsls + ESLint),
completion, Prettier formatting, fuzzy finding, git signs, and more. Managed by
[lazy.nvim](https://github.com/folke/lazy.nvim).

## Prerequisites

Install these **before** first launch (commands shown for Ubuntu/Debian):

| Tool | Why | Install |
|------|-----|---------|
| **Neovim ≥ 0.12** | required by the Treesitter fork & LSP API | [neovim.io](https://neovim.io) |
| **git** | plugin manager clones repos | `sudo apt install git` |
| **Node.js + npm** | runs vtsls, eslint, prettierd | [nvm](https://github.com/nvm-sh/nvm) or distro pkg |
| **C compiler + make** | builds Treesitter parsers & fzf-native | `sudo apt install build-essential` |
| **ripgrep** | Telescope live-grep | `sudo apt install ripgrep` |
| **tree-sitter CLI** | the Treesitter fork builds parsers with it | see below |
| **A Nerd Font** | icons in completion / statusline / file tree | see below |

### tree-sitter CLI

```bash
mkdir -p ~/.local/bin
curl -fL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz \
  | gunzip > ~/.local/bin/tree-sitter
chmod +x ~/.local/bin/tree-sitter
# ensure ~/.local/bin is on your PATH (and PATH visible to nvim)
```

### Nerd Font

```bash
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d JetBrainsMono && fc-cache -f
```

Then set your terminal font to **"JetBrainsMono Nerd Font"**.

## Setup

```bash
# 1. Put this config at ~/.config/nvim
git clone <this-repo> ~/.config/nvim     # or copy the files there

# 2. Launch — lazy.nvim bootstraps itself and installs all plugins
nvim
```

On first launch, automatically: lazy.nvim installs plugins, **Mason** installs the language
servers + formatter (`vtsls`, `lua_ls`, `eslint`, `prettierd`), and **Treesitter** compiles
its parsers. Wait for it to finish, then **restart nvim**.

Verify with `:Lazy` (plugins), `:Mason` (tools), and `:checkhealth`.

## Notes

- **prettierd** sometimes doesn't finish auto-installing on the first run. If formatting
  doesn't work, run `:MasonInstall prettierd` (or `npm i -g @fsouza/prettierd`).
- **ESLint** only attaches in projects that have an ESLint config + eslint in `node_modules`.
  It shows warnings only — no auto-fix. Prettier handles formatting.
- The two files under `queries/tsx/` are intentional overrides that fix `.tsx`
  highlighting/indentation gaps in the Treesitter fork — don't delete them.
- **Haskell** IDE support ([haskell-tools.nvim]) is included but needs
  **haskell-language-server** on your PATH — install via [GHCup]
  (`ghcup install hls`), which keeps HLS matched to your project's GHC (more
  reliable than Mason). Formatting uses **fourmolu** through conform (HLS's own
  formatter is disabled). `.tidal` files share `filetype=haskell` but are *not*
  Haskell projects, so HLS is auto-detached from them and fourmolu never runs on
  them.

## Live-coding music (TidalCycles & SuperCollider)

Optional setup for algorithmic music. The Neovim plugins ([tidal.nvim],
[scnvim]) are already in this config — they reuse the Treesitter fork's `haskell`
and `supercollider` parsers, so no extra editor setup is needed. You only need
the **external** sound toolchain:

| Tool | Why | Install (Ubuntu/Debian) |
|------|-----|-------------------------|
| **SuperCollider** | the sound engine (`sclang`/`scsynth`) | `sudo apt install supercollider` |
| **SuperDirt** | Tidal's sampler/synths (a SC Quark) | in `sclang`: `Quarks.install("SuperDirt")` |
| **GHC + cabal** | runs the Tidal Haskell library | [ghcup](https://www.haskell.org/ghcup/) |
| **TidalCycles** | the pattern language | `cabal update && cabal install tidal --lib` |

### TidalCycles

1. Open a `.tidal` file (it becomes filetype `haskell`).
2. `:TidalLaunch` (or `<leader>tL`) boots GHCi with Tidal. For sound, SuperDirt
   must be running in SuperCollider first (boot it with `SuperDirt.start` in
   `sclang`, or enable `sclang` in tidal.nvim's `boot` opts).
3. Send code: `<leader>tl` line · `<leader>ts` selection (visual) · `<leader>tb`
   block · `<leader>tn` Treesitter node · `<leader>td` silence `dN`
   (prefix the channel number, e.g. `2<leader>td`) · `<leader>th` hush all.
   `:TidalQuit` / `<leader>tq` stops it.

### SuperCollider (scnvim)

1. Open a `.scd`/`.sc` file (filetype `supercollider`).
2. `<leader>sL` starts `sclang`. **First time only:** run `:SCNvimGenerateAssets`
   to build syntax/snippets from the class library.
3. Send code: `<leader>sl` line · `<leader>ss` selection (visual) · `<leader>sb`
   block · `<leader>sh` stop all sound · `<leader>sr` recompile ·
   `<leader>sp`/`<leader>sP` toggle/clear the post window · `<leader>si` signature.

All keymaps are buffer-local and grouped under `<leader>t` / `<leader>s` in which-key.

[tidal.nvim]: https://github.com/grddavies/tidal.nvim
[scnvim]: https://github.com/davidgranstrom/scnvim
[haskell-tools.nvim]: https://github.com/mrcjkb/haskell-tools.nvim
[GHCup]: https://www.haskell.org/ghcup/

## Layout

```
init.lua              entry point (leader keys + loads the modules below)
lua/config/           options.lua, lazy.lua (plugin-manager bootstrap)
lua/plugins/          one file per plugin, auto-imported by lazy.nvim
queries/tsx/          local Treesitter query overrides for .tsx
```

To add a plugin: drop a new file in `lua/plugins/` returning its spec. To remove one:
delete the file.
