# 🦀 arch-nvim

> The beautiful neovim configuration that just works for any programmer. And is maintained actively.

<div align="center">

![arch-nvim Banner](https://github.com/user-attachments/assets/e8877dab-af8d-4949-88aa-44d6683205d7)

[![Version](https://img.shields.io/badge/version-v1.0-blue.svg)](https://github.com/visrust/arch-nvim/releases/tag/v1.0)
[![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)](https://neovim.io)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)
[![Maintained](https://img.shields.io/badge/maintained-no-brightgreen.svg)](https://github.com/visrust/arch-nvim)

[Features](#-features) • [Installation](#-installation) • [Screenshots](#-screenshots) • [Keymaps](KEYMAPS.md) • [Documentation](#-documentation)

</div>

---

## ✨ Features

### 🎨 Beautiful & Modern UI
- **56 carefully curated plugins** for optimal performance
- Multiple premium themes (TokyoNight, Catppuccin, Rose Pine, Nightfox)
- Elegant bufferline with `nvim-cokeline`
- Stunning statusline powered by `lualine.nvim`
- Alpha dashboard for quick access

### 🚀 Productivity Powerhouse
- **20 LSP servers** pre-configured for multiple languages
- Lightning-fast fuzzy finding with `fzf-lua`
- Advanced completion with `blink.cmp`
- Integrated debugging with `nvim-dap`
- Smart code navigation with `leap.nvim`
- Session management with `resession.nvim`

### 🛠️ Developer Experience
- Git integration via `lazygit.nvim`
- File management with `oil.nvim` and `yazi.nvim`
- Terminal integration with `toggleterm.nvim`
- Auto-pairs, surround operations, and multi-cursor editing
- Code formatting with `conform.nvim`
- Comprehensive snippet support

### 🎯 Language Support

#### High-Level Languages
- Python (pyright)
- Lua (lua_ls)

#### Low-Level Languages
- C/C++ (clangd)
- Rust (rust-analyzer)
- Zig (zls)
- Assembly (asm-lsp)
- CMake

#### Web Development
- TypeScript/JavaScript (ts_ls)
- HTML, CSS
- Go (gopls)
- PHP (phpactor)

#### Game Development
- GDScript (Godot_ls)

#### Utilities & Documentation
- Bash, Docker, JSON, YAML
- Markdown (marksman, vale)
- Vim script

---

## 📦 Installation

### Prerequisites

- Neovim ≥ 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (recommended: JetBrainsMono Nerd Font)
- Node.js (for some LSP servers)
- Ripgrep (for fzf-lua)

### Quick Install

```bash
# Backup your existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone arch-nvim (stable v1.0)
git clone --depth 1 --branch v1.0 https://github.com/visrust/arch-nvim.git ~/.config/nvim

# Launch Neovim
nvim
```

The plugin manager will automatically install all plugins on first launch.

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/visrust/arch-nvim.git ~/.config/nvim
```

2. Checkout the stable release:
```bash
cd ~/.config/nvim
git checkout v1.0
```

3. Launch Neovim and let plugins install:
```bash
nvim
```

---

## 📸 Screenshots

### Dashboard & Workflow
![Dashboard](https://github.com/user-attachments/assets/eee31bca-5a46-4fdd-87e0-0b7a89a8a2ea)

### Coding Experience
![Coding](https://github.com/user-attachments/assets/a1cd2cd8-d9eb-4d04-9fd4-2c03ec12ab49)

### File Navigation
![Navigation](https://github.com/user-attachments/assets/4c91c9ee-75a7-49f9-957b-02eb95d90314)

### Fuzzy Finding
![FZF](https://github.com/user-attachments/assets/d21c224f-bc23-4159-bad5-13637cfca9dd)

### Integrated Terminal
![Terminal](https://github.com/user-attachments/assets/1a4a98f0-a725-447e-9415-724f756ec144)

---

## 📚 Documentation

### 📊 Configuration Overview

| Metric | Count |
|--------|------:|
| **Unique Plugins** | 56 |
| **LSP Servers** | 20 |
| **Keybindings** | 36+ |
| **Functions** | 56 |
| **Themes** | 4 |

### 📖 Detailed Documentation

- **[Keybinding Reference](KEYMAPS.md)** - Complete list of all keyboard shortcuts
- **[Plugin Inventory](01_PLUGINS.md)** - All installed plugins and their purposes
- **[LSP Servers](04_LSP_SERVERS.md)** - Language server configurations
- **[Duplicate Detection](03_DUPLICATES.md)** - Configuration audit results

### ⚙️ Configuration Structure

```
arch-nvim/
├── lua/
│   └── user/
│       ├── config/        # Plugin configurations
│       │   ├── dap/       # Debugger setup
│       │   ├── ide/       # IDE features
│       │   ├── server/    # LSP servers
│       │   └── tools/     # Utility tools
│       ├── sys/           # System configurations
│       ├── ui/            # UI components
│       └── other/         # Miscellaneous
└── init.lua               # Entry point
```

---

## ⌨️ Quick Reference

> For the complete keybinding reference, see [KEYMAPS.md](KEYMAPS.md)

### Essential Shortcuts

| Key | Action | Mode |
|-----|--------|------|
| `<Tab>` | Next buffer | Normal |
| `<leader>hf` | Help tags (Fuzzy) | Normal |
| `<leader>zz` | Run code | Normal |
| `<leader>dd` | Debug | Normal |
| `m` / `M` | Leap forward/backward | Normal |
| `<leader>ut` | Toggle Undotree | Normal |

### Leader Key Groups

- `<leader>r*` - Replace operations
- `<leader>l*` - LSP operations
- `<leader>d*` - Debug operations
- `<leader>g*` - Git operations
- `gp*` - Goto preview operations

---

## 🔧 Customization

### Changing the Theme

Edit `lua/user/sys/plugins.lua` and modify the colorscheme section:

```lua
-- Available themes: tokyonight, catppuccin, rose-pine, nightfox
vim.cmd([[colorscheme tokyonight]])
```

### Adding LSP Servers

1. Create a new file in `lua/user/config/server/<category>/`
2. Configure the LSP using `lspconfig`
3. The server will be automatically loaded

### Modifying Keybindings

Edit keybindings in:
- `lua/user/sys/mappings.lua` - Core mappings
- `lua/user/other/keymaps/general.lua` - General keymaps
- Individual plugin configs for plugin-specific maps

---

## 🐛 Troubleshooting

### Plugins Not Installing

```bash
# Remove plugin cache
rm -rf ~/.local/share/nvim

# Restart Neovim
nvim
```

### LSP Not Working

1. Ensure the language server is installed:
```bash
:Mason
```

2. Check LSP status:
```vim
:LspInfo
```

### Performance Issues

- Check for duplicate plugins in [03_DUPLICATES.md](03_DUPLICATES.md)
- Disable unused LSP servers
- Consider using lazy loading for heavy plugins

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Development Guidelines

- Follow the existing configuration structure
- Document new keybindings
- Update KEYMAPS.md for new shortcuts
- Test with multiple languages

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 💖 Acknowledgments

Special thanks to all the plugin authors and the Neovim community for making this configuration possible.

### Featured Plugins

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [blink.cmp](https://github.com/saghen/blink.cmp)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- And 50+ more amazing plugins!

---

## 🌟 Star History

If you find this configuration helpful, please consider giving it a star! ⭐

---

<div align="center">

**Built with ❤️ for the Neovim community**

[Report Bug](https://github.com/visrust/arch-nvim/issues) • [Request Feature](https://github.com/visrust/arch-nvim/issues)

</div>
