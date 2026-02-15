# Keybinding Reference

**Total Keybindings:** 36

---

## 📋 All Keybindings

| Mode | Key | Description | File |
|------|-----|-------------|------|
| `n` | `<C-x>s` | Spelling suggestions | `lua/user/sys/options.lua:48` |
| `n` | `<Tab>` | Next buffer | `lua/user/ui/core/cokeline.lua:55` |
| `n` | `<leader>cr` | Check file changes | `lua/user/sys/inbuilt/ReloadFiles.lua:8` |
| `n` | `<leader>dd` | No description | `lua/user/config/dap/keymaps.lua:4` |
| `n` | `<leader>hf` | Help tags (FzfLua) | `lua/user/ui/core/windows.lua:69` |
| `n` | `<leader>llp` | No description | `lua/user/other/keymaps/general.lua:67` |
| `n` | `<leader>lls` | No description | `lua/user/other/keymaps/general.lua:69` |
| `n` | `<leader>llu` | No description | `lua/user/other/keymaps/general.lua:68` |
| `n` | `<leader>lsi` | No description | `lua/user/other/keymaps/general.lua:73` |
| `n` | `<leader>lsl` | No description | `lua/user/other/keymaps/general.lua:74` |
| `n` | `<leader>lsr` | No description | `lua/user/other/keymaps/general.lua:75` |
| `n` | `<leader>ra` | Replace in whole file | `lua/user/sys/mappings.lua:49` |
| `n` | `<leader>rm` | Replace in matching lines | `lua/user/sys/mappings.lua:62` |
| `n` | `<leader>rrb` | No description | `lua/user/other/keymaps/general.lua:25` |
| `n` | `<leader>rrc` | No description | `lua/user/other/keymaps/general.lua:15` |
| `n` | `<leader>rrf` | No description | `lua/user/other/keymaps/general.lua:20` |
| `n` | `<leader>rrl` | No description | `lua/user/other/keymaps/general.lua:29` |
| `n` | `<leader>rs` | Range substitute | `lua/user/sys/mappings.lua:39` |
| `n` | `<leader>rsa` | No description | `lua/user/other/keymaps/general.lua:60` |
| `n` | `<leader>rsl` | No description | `lua/user/other/keymaps/general.lua:36` |
| `n` | `<leader>rsm` | No description | `lua/user/other/keymaps/general.lua:53` |
| `n` | `<leader>rsr` | No description | `lua/user/other/keymaps/general.lua:46` |
| `n` | `<leader>ut` | Toggle Undotree | `lua/user/config/ide/ide/undotree.lua:11` |
| `n` | `<leader>zz` | Run code | `lua/user/config/ide/ide/module_require/run.lua:95` |
| `n` | `M` | Leap backward | `lua/user/config/ide/file/leap.lua:26` |
| `n` | `gP` | Close all preview windows | `lua/user/config/tools/goto_preview.lua:19` |
| `n` | `gm` | Leap from window | `lua/user/config/ide/file/leap.lua:27` |
| `n` | `gpD` | Preview declaration | `lua/user/config/tools/goto_preview.lua:17` |
| `n` | `gpd` | Preview definition | `lua/user/config/tools/goto_preview.lua:14` |
| `n` | `gpi` | Preview implementation | `lua/user/config/tools/goto_preview.lua:16` |
| `n` | `gpr` | Preview references | `lua/user/config/tools/goto_preview.lua:18` |
| `n` | `gpt` | Preview type definition | `lua/user/config/tools/goto_preview.lua:15` |
| `n` | `m` | Leap forward | `lua/user/config/ide/file/leap.lua:25` |
| `v` | `<leader>m` | Move block to line | `lua/user/sys/mappings.lua:145` |
| `v` | `<leader>rs` | Replace in selection | `lua/user/sys/mappings.lua:52` |
| `v` | `<leader>rsv` | No description | `lua/user/other/keymaps/general.lua:41` |


---

## 📂 By File

### `lua/user/config/dap/keymaps.lua`

- **[n]** `<leader>dd` → No description

### `lua/user/config/ide/file/leap.lua`

- **[n]** `m` → Leap forward
- **[n]** `M` → Leap backward
- **[n]** `gm` → Leap from window

### `lua/user/config/ide/ide/module_require/run.lua`

- **[n]** `<leader>zz` → Run code

### `lua/user/config/ide/ide/undotree.lua`

- **[n]** `<leader>ut` → Toggle Undotree

### `lua/user/config/tools/goto_preview.lua`

- **[n]** `gpd` → Preview definition
- **[n]** `gpt` → Preview type definition
- **[n]** `gpi` → Preview implementation
- **[n]** `gpD` → Preview declaration
- **[n]** `gpr` → Preview references
- **[n]** `gP` → Close all preview windows

### `lua/user/other/keymaps/general.lua`

- **[n]** `<leader>rrc` → No description
- **[n]** `<leader>rrf` → No description
- **[n]** `<leader>rrb` → No description
- **[n]** `<leader>rrl` → No description
- **[n]** `<leader>rsl` → No description
- **[v]** `<leader>rsv` → No description
- **[n]** `<leader>rsr` → No description
- **[n]** `<leader>rsm` → No description
- **[n]** `<leader>rsa` → No description
- **[n]** `<leader>llp` → No description
- **[n]** `<leader>llu` → No description
- **[n]** `<leader>lls` → No description
- **[n]** `<leader>lsi` → No description
- **[n]** `<leader>lsl` → No description
- **[n]** `<leader>lsr` → No description

### `lua/user/sys/inbuilt/ReloadFiles.lua`

- **[n]** `<leader>cr` → Check file changes

### `lua/user/sys/mappings.lua`

- **[n]** `<leader>rs` → Range substitute
- **[n]** `<leader>ra` → Replace in whole file
- **[v]** `<leader>rs` → Replace in selection
- **[n]** `<leader>rm` → Replace in matching lines
- **[v]** `<leader>m` → Move block to line

### `lua/user/sys/options.lua`

- **[n]** `<C-x>s` → Spelling suggestions

### `lua/user/ui/core/cokeline.lua`

- **[n]** `<Tab>` → Next buffer

### `lua/user/ui/core/windows.lua`

- **[n]** `<leader>hf` → Help tags (FzfLua)

