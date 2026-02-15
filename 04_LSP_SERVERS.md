# LSP Server Configuration

**Total Servers:** 20

---

## 🔧 GameDev

### `Godot_ls`

- **File:** `lua/user/config/server/GameDev/Godot_ls.lua`
- **Command:** `Unknown`
- **Filetypes:** `Unknown`

## 🔧 HighLevel

### `lua_ls`

- **File:** `lua/user/config/server/HighLevel/lua_ls.lua`
- **Command:** `Unknown`
- **Filetypes:** `Unknown`

### `pyright`

- **File:** `lua/user/config/server/HighLevel/pyright.lua`
- **Command:** `"pyright-langserver",
        "--stdio",`
- **Filetypes:** `"python"`

## 🔧 LowLevel

### `asm`

- **File:** `lua/user/config/server/LowLevel/asm.lua`
- **Command:** `"asm-lsp"`
- **Filetypes:** `"asm", "s"`

### `clang`

- **File:** `lua/user/config/server/LowLevel/clang.lua`
- **Command:** `"clangd",
        "--background-index",
        "--clang-tidy",
        "--log=error", -- Only log actual errors`
- **Filetypes:** `"c", "cpp"`

### `cmake`

- **File:** `lua/user/config/server/LowLevel/cmake.lua`
- **Command:** `"cmake-language-server"`
- **Filetypes:** `"cmake"`

### `rust_analyzer`

- **File:** `lua/user/config/server/LowLevel/rust_analyzer.lua`
- **Command:** `"rust-analyzer"`
- **Filetypes:** `Unknown`

### `zls`

- **File:** `lua/user/config/server/LowLevel/zls.lua`
- **Command:** `'zls'`
- **Filetypes:** `'zig', 'zir'`

## 🔧 Productive

### `bash_ls`

- **File:** `lua/user/config/server/Productive/bash_ls.lua`
- **Command:** `"bash-language-server", "start"`
- **Filetypes:** `"sh", "bash"`

### `marksman`

- **File:** `lua/user/config/server/Productive/marksman.lua`
- **Command:** `"marksman", "server"`
- **Filetypes:** `"markdown", "markdown.mdx"`

### `vale`

- **File:** `lua/user/config/server/Productive/vale.lua`
- **Command:** `"vale", "--lsp"`
- **Filetypes:** `"markdown", "text", "md"`

### `vimls`

- **File:** `lua/user/config/server/Productive/vimls.lua`
- **Command:** `"vim-language-server", "--stdio"`
- **Filetypes:** `"vim"`

## 🔧 Utilities

### `dockerls`

- **File:** `lua/user/config/server/Utilities/dockerls.lua`
- **Command:** `"docker-langserver", "--stdio"`
- **Filetypes:** `"dockerfile"`

### `jsonls`

- **File:** `lua/user/config/server/Utilities/jsonls.lua`
- **Command:** `"vscode-json-language-server", "--stdio"`
- **Filetypes:** `"json"`

### `yamlls`

- **File:** `lua/user/config/server/Utilities/yamlls.lua`
- **Command:** `"yaml-language-server", "--stdio"`
- **Filetypes:** `"yaml", "yaml.docker-compose", "yaml.gitlab"`

## 🔧 Web

### `css_ls`

- **File:** `lua/user/config/server/Web/css_ls.lua`
- **Command:** `"vscode-css-language-server", "--stdio"`
- **Filetypes:** `"css", "scss", "less"`

### `gopls`

- **File:** `lua/user/config/server/Web/gopls.lua`
- **Command:** `"gopls"`
- **Filetypes:** `"go", "gomod", "gowork", "gotmpl"`

### `html`

- **File:** `lua/user/config/server/Web/html.lua`
- **Command:** `"vscode-html-language-server", "--stdio"`
- **Filetypes:** `"html", "templ"`

### `phpactor`

- **File:** `lua/user/config/server/Web/phpactor.lua`
- **Command:** `"phpactor", "language-server"`
- **Filetypes:** `"php"`

### `ts_ls`

- **File:** `lua/user/config/server/Web/ts_ls.lua`
- **Command:** `Unknown`
- **Filetypes:** `Unknown`

