# Add This to Your DustNvim README

## Option 1: Add as a New Section (Recommended)

Add this section after "Contributing" or before "License":

````markdown
---

## 📊 Configuration Audit

DustNvim includes automated audit tools to help you document and maintain your configuration.

### What It Does

- ✅ **Documents** all plugins with GitHub links
- ✅ **Extracts** every keybinding across your config  
- ✅ **Detects** duplicate plugins, functions, and keybindings
- ✅ **Maps** LSP server configurations by category
- ✅ **Generates** professional markdown reports

### Quick Start

```bash
# Install audit tools
cd ~/.config/nv
git clone https://github.com/visrust/DustNvim-Auditor.git scripts
chmod +x scripts/*.sh scripts/*.py

# Run your first audit
python3 scripts/audit_dustnvim.py

# View results
cat audit_reports/00_MASTER_SUMMARY.md
```

### Reports Generated

After running the audit, check `audit_reports/`:

1. **00_MASTER_SUMMARY.md** - Overview and quick stats
2. **01_PLUGINS.md** - Complete plugin inventory  
3. **02_KEYBINDINGS.md** - All keybindings documented
4. **03_DUPLICATES.md** - Duplicate detection
5. **04_LSP_SERVERS.md** - LSP configuration details

### Use Cases

- 📚 **Documentation** - Generate reference docs automatically
- 🧹 **Cleanup** - Find and remove duplicate declarations
- 🔍 **Debugging** - Identify keybinding conflicts
- 👥 **Onboarding** - Help new users understand your config

### Commands in Neovim

Add to your config for quick access:

```lua
-- lua/user/sys/audit.lua
vim.api.nvim_create_user_command('Audit', function()
  vim.cmd('!python3 ~/.config/nv/scripts/audit_dustnvim.py')
end, { desc = 'Run configuration audit' })

vim.api.nvim_create_user_command('AuditView', function()
  vim.cmd('edit ~/.config/nv/audit_reports/00_MASTER_SUMMARY.md')
end, { desc = 'View audit reports' })
```

Then use:
- `:Audit` - Run full configuration audit
- `:AuditView` - Open generated reports

For more details, see [Configuration Audit Documentation](scripts/README.md).

---
````

## Option 2: Add to "Features" Section

Add this bullet point to your features list:

````markdown
### **Project Management**
- Effortless session management (`<Space>ss/sf/sl/sd`)
- Root-based project detection
- Dual completion engines (nvim-cmp default)
- AI-assisted configuration tweaking
- **🔍 Automated config audit** - Document plugins, find duplicates, map LSP servers
````

## Option 3: Add as "Developer Tools" Subsection

Under "Contributing" or create new section:

````markdown
## 🛠️ Developer Tools

### Configuration Audit

Maintain and document your DustNvim configuration with automated audit tools:

```bash
# One-time setup
cd ~/.config/nv
./scripts/audit_dustnvim.py

# View generated documentation
ls audit_reports/
```

**Features:**
- Complete plugin inventory with links
- Keybinding reference guide
- Duplicate detection (plugins, functions, keybindings)
- LSP server documentation
- Configuration statistics

See [scripts/README.md](scripts/README.md) for details.
````

## Option 4: Mention in "Structure" Section

Add after showing your directory tree:

````markdown
## 📁 Project Structure

[Your existing tree here]

### 🔍 Audit Your Configuration

Generate documentation and find issues:

```bash
python3 scripts/audit_dustnvim.py
```

This creates comprehensive reports in `audit_reports/` covering plugins, keybindings, LSP servers, and duplicates.
````

---

## Badge for README (Optional)

Add to the top with other badges:

```markdown
[![Config Audited](https://img.shields.io/badge/config-audited-brightgreen.svg)](audit_reports/00_MASTER_SUMMARY.md)
```

---

## Link in Quick Start (Optional)

Add after installation:

````markdown
**Verify Installation:**
```bash
# Check for issues
python3 scripts/audit_dustnvim.py

# View configuration report  
cat audit_reports/00_MASTER_SUMMARY.md
```
````

---

## Contributing Section Enhancement

Add to contributing guidelines:

````markdown
### Before Submitting

1. Run configuration audit:
   ```bash
   python3 scripts/audit_dustnvim.py
   ```

2. Check for duplicates:
   ```bash
   cat audit_reports/03_DUPLICATES.md
   ```

3. Verify no conflicts introduced
4. Update documentation if needed
````

---

## My Recommendation

Use **Option 1** (full section) for best visibility, and add:
- Badge at top
- Brief mention in features
- Audit step in contributing

This maximizes discoverability while keeping docs clean.

---

## Quick Copy-Paste

Here's the cleanest integration:

````markdown
## 📊 Configuration Documentation

Run automated audits to document and maintain your config:

```bash
python3 scripts/audit_dustnvim.py
```

**Generates:**
- Plugin inventory with GitHub links
- Complete keybinding reference
- Duplicate detection report
- LSP server documentation
- Configuration statistics

Reports saved to `audit_reports/`. See [scripts/README.md](scripts/README.md) for details.
````

That's it! Clean, concise, and informative.
