# ⌨️ Keybinding Reference

Complete keybinding reference for arch-nvim configuration.

**Total Keybindings:** 36

---

## 📑 Table of Contents

- [Navigation](#-navigation)
- [File Operations](#-file-operations)
- [LSP Operations](#-lsp-operations)
- [Debugging](#-debugging)
- [Text Manipulation](#-text-manipulation)
- [Terminal & Tools](#-terminal--tools)
- [Complete Reference](#-complete-reference)

---

## 🧭 Navigation

### Leap Motion

Leap provides lightning-fast cursor movement to any visible location.

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `m` | Normal | Leap forward to any visible location | `lua/user/config/ide/file/leap.lua` |
| `M` | Normal | Leap backward to any visible location | `lua/user/config/ide/file/leap.lua` |
| `gm` | Normal | Leap from current window | `lua/user/config/ide/file/leap.lua` |

### Buffer Navigation

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<Tab>` | Normal | Switch to next buffer | `lua/user/ui/core/cokeline.lua` |

---

## 📁 File Operations

### File Management

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>cr` | Normal | Check and reload file changes | `lua/user/sys/inbuilt/ReloadFiles.lua` |

### Fuzzy Finding

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>hf` | Normal | Search help tags using FzfLua | `lua/user/ui/core/windows.lua` |

---

## 🔧 LSP Operations

### Code Preview

Goto preview allows you to peek at definitions without leaving your current location.

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `gpd` | Normal | Preview definition | `lua/user/config/tools/goto_preview.lua` |
| `gpt` | Normal | Preview type definition | `lua/user/config/tools/goto_preview.lua` |
| `gpi` | Normal | Preview implementation | `lua/user/config/tools/goto_preview.lua` |
| `gpD` | Normal | Preview declaration | `lua/user/config/tools/goto_preview.lua` |
| `gpr` | Normal | Preview references | `lua/user/config/tools/goto_preview.lua` |
| `gP` | Normal | Close all preview windows | `lua/user/config/tools/goto_preview.lua` |

### LSP Operations

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>llp` | Normal | LSP operation (unspecified) | `lua/user/other/keymaps/general.lua` |
| `<leader>llu` | Normal | LSP operation (unspecified) | `lua/user/other/keymaps/general.lua` |
| `<leader>lls` | Normal | LSP operation (unspecified) | `lua/user/other/keymaps/general.lua` |
| `<leader>lsi` | Normal | LSP server info | `lua/user/other/keymaps/general.lua` |
| `<leader>lsl` | Normal | LSP server log | `lua/user/other/keymaps/general.lua` |
| `<leader>lsr` | Normal | LSP server restart | `lua/user/other/keymaps/general.lua` |

---

## 🐛 Debugging

### Debug Commands

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>dd` | Normal | Start/toggle debugger | `lua/user/config/dap/keymaps.lua` |

---

## ✏️ Text Manipulation

### Replace Operations

Powerful search and replace functionality across different scopes.

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>rs` | Normal | Range substitute (within range) | `lua/user/sys/mappings.lua` |
| `<leader>rs` | Visual | Replace in current selection | `lua/user/sys/mappings.lua` |
| `<leader>ra` | Normal | Replace in entire file | `lua/user/sys/mappings.lua` |
| `<leader>rm` | Normal | Replace in matching lines only | `lua/user/sys/mappings.lua` |

### Reload Operations

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>rrc` | Normal | Reload config | `lua/user/other/keymaps/general.lua` |
| `<leader>rrf` | Normal | Reload file | `lua/user/other/keymaps/general.lua` |
| `<leader>rrb` | Normal | Reload buffer | `lua/user/other/keymaps/general.lua` |
| `<leader>rrl` | Normal | Reload LSP | `lua/user/other/keymaps/general.lua` |

### Search Operations

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>rsl` | Normal | Search line | `lua/user/other/keymaps/general.lua` |
| `<leader>rsv` | Visual | Search in visual selection | `lua/user/other/keymaps/general.lua` |
| `<leader>rsr` | Normal | Search and replace | `lua/user/other/keymaps/general.lua` |
| `<leader>rsm` | Normal | Search matching | `lua/user/other/keymaps/general.lua` |
| `<leader>rsa` | Normal | Search all | `lua/user/other/keymaps/general.lua` |

### Block Movement

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>m` | Visual | Move selected block to specific line | `lua/user/sys/mappings.lua` |

---

## 🛠️ Terminal & Tools

### Code Execution

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>zz` | Normal | Run current code/file | `lua/user/config/ide/ide/module_require/run.lua` |

### Version Control

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<leader>ut` | Normal | Toggle Undotree (visual undo history) | `lua/user/config/ide/ide/undotree.lua` |

### Spell Check

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<C-x>s` | Normal | Show spelling suggestions | `lua/user/sys/options.lua` |

---

## 📋 Complete Reference

### Alphabetical List

| Key | Mode | Description | File |
|-----|------|-------------|------|
| `<C-x>s` | Normal | Spelling suggestions | `lua/user/sys/options.lua` |
| `<leader>cr` | Normal | Check file changes | `lua/user/sys/inbuilt/ReloadFiles.lua` |
| `<leader>dd` | Normal | Start debugger | `lua/user/config/dap/keymaps.lua` |
| `<leader>hf` | Normal | Help tags (FzfLua) | `lua/user/ui/core/windows.lua` |
| `<leader>llp` | Normal | LSP operation | `lua/user/other/keymaps/general.lua` |
| `<leader>lls` | Normal | LSP operation | `lua/user/other/keymaps/general.lua` |
| `<leader>llu` | Normal | LSP operation | `lua/user/other/keymaps/general.lua` |
| `<leader>lsi` | Normal | LSP server info | `lua/user/other/keymaps/general.lua` |
| `<leader>lsl` | Normal | LSP server log | `lua/user/other/keymaps/general.lua` |
| `<leader>lsr` | Normal | LSP server restart | `lua/user/other/keymaps/general.lua` |
| `<leader>m` | Visual | Move block to line | `lua/user/sys/mappings.lua` |
| `<leader>ra` | Normal | Replace in whole file | `lua/user/sys/mappings.lua` |
| `<leader>rm` | Normal | Replace in matching lines | `lua/user/sys/mappings.lua` |
| `<leader>rs` | Normal | Range substitute | `lua/user/sys/mappings.lua` |
| `<leader>rs` | Visual | Replace in selection | `lua/user/sys/mappings.lua` |
| `<leader>rsa` | Normal | Search all | `lua/user/other/keymaps/general.lua` |
| `<leader>rsm` | Normal | Search matching | `lua/user/other/keymaps/general.lua` |
| `<leader>rsr` | Normal | Search and replace | `lua/user/other/keymaps/general.lua` |
| `<leader>rsl` | Normal | Search line | `lua/user/other/keymaps/general.lua` |
| `<leader>rsv` | Visual | Search in visual selection | `lua/user/other/keymaps/general.lua` |
| `<leader>rrb` | Normal | Reload buffer | `lua/user/other/keymaps/general.lua` |
| `<leader>rrc` | Normal | Reload config | `lua/user/other/keymaps/general.lua` |
| `<leader>rrf` | Normal | Reload file | `lua/user/other/keymaps/general.lua` |
| `<leader>rrl` | Normal | Reload LSP | `lua/user/other/keymaps/general.lua` |
| `<leader>ut` | Normal | Toggle Undotree | `lua/user/config/ide/ide/undotree.lua` |
| `<leader>zz` | Normal | Run code | `lua/user/config/ide/ide/module_require/run.lua` |
| `<Tab>` | Normal | Next buffer | `lua/user/ui/core/cokeline.lua` |
| `gP` | Normal | Close all preview windows | `lua/user/config/tools/goto_preview.lua` |
| `gm` | Normal | Leap from window | `lua/user/config/ide/file/leap.lua` |
| `gpD` | Normal | Preview declaration | `lua/user/config/tools/goto_preview.lua` |
| `gpd` | Normal | Preview definition | `lua/user/config/tools/goto_preview.lua` |
| `gpi` | Normal | Preview implementation | `lua/user/config/tools/goto_preview.lua` |
| `gpr` | Normal | Preview references | `lua/user/config/tools/goto_preview.lua` |
| `gpt` | Normal | Preview type definition | `lua/user/config/tools/goto_preview.lua` |
| `M` | Normal | Leap backward | `lua/user/config/ide/file/leap.lua` |
| `m` | Normal | Leap forward | `lua/user/config/ide/file/leap.lua` |

---

## 🎯 Tips & Tricks

### Leader Key
The leader key is typically set to `<Space>` in arch-nvim. All keybindings starting with `<leader>` mean you press Space first, then the following keys.

### Modal Editing
- **Normal mode**: Default mode for navigation and commands
- **Visual mode**: For selecting text
- Remember to press `<Esc>` to return to Normal mode

### Custom Keybindings
To add your own keybindings, edit:
- `lua/user/sys/mappings.lua` for core mappings
- `lua/user/other/keymaps/general.lua` for general keymaps

### Plugin-Specific Keybindings
Many plugins provide additional keybindings that are documented in their respective configuration files under `lua/user/config/`.

---

## 📚 Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Which-Key Plugin](https://github.com/folke/which-key.nvim) - Press `<Space>` and wait to see available keybindings
- [Back to README](README.md)

---

<div align="center">

**Need help?** Check the [main documentation](README.md) or [open an issue](https://github.com/yourusername/arch-nvim/issues)

</div>
