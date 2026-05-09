# Neovim Configuration

Personal Neovim configuration optimized for development on Linux. Based on NvChad with custom modifications.

## Requirements

- **Neovim 0.9+**
- **Git**
- **Node.js & npm**
- **Python 3 & pip**
- **C compiler** (gcc/clang)
- **Nerd Font** (recommended: JetBrainsMono Nerd Font)
- **Make**
- **ripgrep**
- **fd-find**
- **luarocks**

### Optional for Jupyter/Quarto

```bash
# Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Jupyter support
uv tool install jupyter

# Quarto (Fedora)
sudo dnf install quarto

# Python provider for Neovim
uv tool install pynvim
```

## Features

### AI Integration
- **Copilot** - Code completion via copilot.lua
- **CopilotChat** - AI chat assistant for code explanation, review, and generation

### Language Support
- **Python** - LSP, DAP, formatting, linting, Jupyter (Molten), Quarto, uv
- **Rust** - LSP, DAP, formatting via rustaceanvim
- **Typst** - LSP and preview via typst-preview.nvim
- **HTML/CSS/JS** - LSP, formatting, linting
- **SQL** - LSP and formatting
- **Markdown** - LSP, Obsidian.nvim integration, rendering

### Data Science
- **Molten** - Jupyter notebooks in Neovim
- **Quarto** - Scientific/technical publishing
- **uv.nvim** - Python environment management

### Productivity
- **Telescope** - Fuzzy finding, grep, buffers, etc.
- **Neo-tree** - File explorer
- **Oil** - File explorer with git integration
- **Noice** - Better notifications and messages
- **ufo** - Code folding
- **blink.cmp** - Enhanced completion
- **Conform** - Code formatting
- **nvim-lint** - Linting
- **Mason** - LSP/DAP/Linter management

### Note-taking
- **Obsidian.nvim** - Obsidian vault integration with custom frontmatter

## Installation

```bash
git clone https://github.com/AC-Santiago/nvim.git ~/.config/nvim
nvim  # Lazy will auto-install plugins on first run
```

## Keybindings

> `<Space>` is the leader key. `<leader>` in this table refers to Space.

### General

| Key | Mode | Description |
|-----|------|-------------|
| `<Space>` | Normal | Leader key |
| `\` | Normal | Local leader |
| `;` | Normal | Enter command mode |
| `jk` | Insert | Exit to Normal |
| `<Esc>` | Normal | Clear highlights |
| `<C-s>` | Normal | Save file |
| `<C-h/j/k/l>` | Insert | Move in line |
| `<C-h/j/k/l>` | Normal | Switch window |
| `zR` | Normal | Open all folds |
| `zM` | Normal | Close all folds |

### File Exploration

| Key | Mode | Description |
|-----|------|-------------|
| `<C-n>` | Normal | Toggle Neo-tree |
| `<leader>e` | Normal | Focus Neo-tree |
| `-` | Normal | Open parent (Oil) |

### Telescope

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ff` | Normal | Find files |
| `<leader>fa` | Normal | Find all files |
| `<leader>fw` | Normal | Live grep |
| `<leader>fb` | Normal | Find buffers |
| `<leader>fo` | Normal | Recent files |
| `<leader>fz` | Normal | Search in buffer |
| `<leader>cm` | Normal | Git commits |
| `<leader>gt` | Normal | Git status |
| `<leader>th` | Normal | NvChad themes |

### LSP

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>fm` | Normal | Format file |
| `<leader>ds` | Normal | Diagnostics loclist |
| `<leader>ca` | Normal/Visual | Code actions |
| `gr` | Normal | References |
| `gi` | Normal | Implementation |
| `<leader>ih` | Normal | Toggle inlay hints |

### Git

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>lg` | Normal | Open LazyGit |
| `<leader>ga` | Normal | Git fetch all |
| `<leader>gl` | Normal | Git pull |

### Debugging (DAP)

| Key | Mode | Description |
|-----|------|-------------|
| `<localleader>db` | Normal | Toggle breakpoint |
| `<localleader>dc` | Normal | Continue |
| `<localleader>di` | Normal | Step into |
| `<localleader>do` | Normal | Step out |
| `<localleader>dO` | Normal | Step over |
| `<localleader>dt` | Normal | Terminate |

### Terminal

| Key | Mode | Description |
|-----|------|-------------|
| `<C-x>` | Terminal | Escape terminal mode |
| `<leader>h` | Normal | New horizontal terminal |
| `<leader>v` | Normal | New vertical terminal |
| `<A-h>` | Normal/Term | Toggle horizontal |
| `<A-v>` | Normal/Term | Toggle vertical |
| `<A-i>` | Normal/Term | Toggle floating |

### Jupyter (Molten)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>mi` | Normal | Initialize Molten |
| `<leader>ml` | Normal | Evaluate line |
| `<leader>mv` | Visual | Evaluate selection |
| `<leader>me` | Normal | Evaluate operator |
| `<leader>mr` | Normal | Re-evaluate cell |
| `<leader>mo` | Normal | Show output |
| `<leader>mh` | Normal | Hide output |
| `]c` | Normal | Next cell |
| `[c` | Normal | Previous cell |

### Quarto

| Key | Mode | Description |
|-----|------|-------------|
| `<localleader>qp` | Normal | Preview |
| `<localleader>qq` | Normal | Close preview |
| `<localleader>rc` | Normal | Run cell |
| `<localleader>ra` | Normal | Run cell and above |

### Obsidian

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>on` | Normal | New note |
| `<leader>oo` | Normal | Open in Obsidian app |
| `<leader>os` | Normal | Search notes |
| `<leader>oq` | Normal | Quick switch |
| `<leader>ot` | Normal | Today's note |
| `<leader>oy` | Normal | Yesterday's note |
| `<leader>ob` | Normal | Backlinks |
| `<leader>ol` | Normal | Links in note |
| `<leader>og` | Normal | Search by tags |
| `<leader>oc` | Normal | Toggle checkbox |
| `<leader>op` | Normal | Paste image |
| `<leader>oT` | Normal | Insert template |

### AI (CopilotChat)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>cc` | Normal | Open chat |
| `<leader>ce` | Normal/Visual | Explain code |
| `<leader>ct` | Normal/Visual | Generate tests |
| `<leader>cr` | Normal/Visual | Review code |
| `<leader>cf` | Normal/Visual | Fix code |
| `<leader>cd` | Normal/Visual | Generate docs |

### Utilities

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>cp` | Normal | Color picker (Minty) |
| `<localleader>cp` | Normal | Save color |
| `<leader>snl` | Normal | Noice last message |
| `<leader>snh` | Normal | Noice history |

## Project Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── lazy-lock.json        # Plugin lock file
├── .stylua.toml          # Lua formatter config
├── lua/
│   ├── chadrc.lua        # NvChad config overrides
│   ├── options.lua        # Neovim options
│   ├── mappings.lua       # Keybindings
│   ├── autocmds.lua       # Autocommands
│   ├── configs/           # Plugin configurations
│   │   ├── lsp.lua
│   │   ├── conform.lua
│   │   ├── lint.lua
│   │   ├── treesitter.lua
│   │   └── ...
│   ├── plugins/           # Plugin definitions (per language)
│   │   └── lang/
│   │       ├── python/
│   │       ├── rust/
│   │       ├── typst/
│   │       └── ...
│   ├── utils/             # Utility modules
│   │   ├── lang_loader.lua
│   │   └── mason_cleanup.lua
│   └── themes/            # Custom themes
├── docs/                  # Documentation
│   ├── README_LANGUAGE_SYSTEM.md
│   └── MASON_CLEANUP_GUIDE.md
├── KEYBINDINGS.md          # This file
└── spell/                  # Spelling dictionaries
```

## Configuration

### Languages System

Languages are enabled/disabled in `lua/configs/languages.lua`. The Mason Cleanup system automatically removes unused tools when languages are disabled.

### Custom Themes

The theme is set to "toby-theme" in `lua/chadrc.lua`.

### Statusline

Uses "vscode_colored" theme from NvChad.

## Troubleshooting

### Update plugins
```
:Lazy sync
```

### Clean Mason tools
```lua
:lua require('utils.lang_loader').manual_cleanup()
```

### Check language state
```lua
:lua vim.print(require('utils.lang_loader').get_state_info())
```

## License

MIT