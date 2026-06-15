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

## Layout

```
init.lua              entry point (leader keys + loads the modules below)
lua/config/           options.lua, lazy.lua (plugin-manager bootstrap)
lua/plugins/          one file per plugin, auto-imported by lazy.nvim
queries/tsx/          local Treesitter query overrides for .tsx
```

To add a plugin: drop a new file in `lua/plugins/` returning its spec. To remove one:
delete the file.
