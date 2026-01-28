# 🔍 DustNvim Configuration Auditor

## Quick Start Guide

### 📦 What You Received

```
dustnvim_audit/
├── audit_dustnvim.sh       # Bash version (works everywhere)
├── audit_dustnvim.py       # Python version (more powerful)
├── install.sh              # Easy installer
├── README.md               # Full documentation
└── example_reports/        # Sample output
    ├── 00_MASTER_SUMMARY.md
    ├── 01_PLUGINS.md
    ├── 02_KEYBINDINGS.md
    ├── 03_DUPLICATES.md
    └── 04_LSP_SERVERS.md
```

---

## 🚀 Installation (3 Options)

### Option 1: Auto-Install (Recommended)

```bash
cd dustnvim_audit
chmod +x install.sh
./install.sh
```

This will:
- ✅ Detect your config location
- ✅ Copy scripts to `~/.config/nv/scripts/`
- ✅ Make everything executable
- ✅ Offer to run first audit

### Option 2: Manual Install

```bash
# Copy to your config
cp audit_dustnvim.* ~/.config/nv/scripts/
chmod +x ~/.config/nv/scripts/audit_dustnvim.*

# Run it
cd ~/.config/nv
./scripts/audit_dustnvim.py
```

### Option 3: Run Directly (No Install)

```bash
# Just run from current directory
chmod +x audit_dustnvim.py
./audit_dustnvim.py ~/.config/nv
```

---

## 📊 What Gets Generated

After running, check `~/.config/nv/audit_reports/`:

### 1. Master Summary (START HERE!)
- Overview of your entire config
- Issue counts (duplicates found)
- Quick statistics

### 2. Plugin Inventory
- Every plugin with GitHub links
- Where each is referenced
- Easy to spot unused plugins

### 3. Keybinding Reference
- Complete list of ALL keybindings
- Organized by file and mode
- Table format for easy searching

### 4. Duplicate Detection
- Plugins declared multiple times
- Duplicate function definitions
- Conflicting keybindings

### 5. LSP Server Configuration
- All servers by category
- Commands and filetypes
- Configuration locations

---

## 💡 Usage Examples

### Basic Audit
```bash
python3 audit_dustnvim.py
```

### Specific Config Path
```bash
python3 audit_dustnvim.py /path/to/config
```

### Use Bash Version (if no Python)
```bash
./audit_dustnvim.sh ~/.config/nv
```

### Add to Your Config
Create `lua/user/sys/audit.lua`:
```lua
vim.api.nvim_create_user_command('Audit', function()
  vim.cmd('!python3 ~/.config/nv/scripts/audit_dustnvim.py')
end, {})

vim.api.nvim_create_user_command('AuditView', function()
  vim.cmd('edit ~/.config/nv/audit_reports/00_MASTER_SUMMARY.md')
end, {})
```

Then use `:Audit` and `:AuditView` in Neovim!

---

## 🔍 Understanding Results

### "Duplicate Plugins"
**Example:** `folke/lazy.nvim` appears in 2 files

**What to do:**
- Keep one declaration (usually in main plugin file)
- Remove others unless intentional

### "Duplicate Keybindings"
**Example:** `<leader>ff` mapped twice in different files

**What to do:**
- Check if both are needed
- Different modes (n, v, i) is OK
- Same mode = conflict!

### "Plugin Count Mismatch"
**Example:** 65 references but only 60 unique

**What to do:**
- Check duplicates report
- Some plugins legitimately appear multiple times (dependencies)
- Remove unintended duplicates

---

## 🎯 Recommended Workflow

1. **Run the audit:**
   ```bash
   python3 audit_dustnvim.py
   ```

2. **Review master summary:**
   ```bash
   cat audit_reports/00_MASTER_SUMMARY.md
   ```

3. **Fix duplicates (if any):**
   ```bash
   cat audit_reports/03_DUPLICATES.md
   ```

4. **Document keybindings:**
   - Keep `02_KEYBINDINGS.md` as reference
   - Add to your repo for other users

5. **Verify LSP servers:**
   ```bash
   cat audit_reports/04_LSP_SERVERS.md
   ```

6. **Re-run after changes:**
   ```bash
   python3 audit_dustnvim.py
   ```

---

## 📚 Add Reports to Your Repo

```bash
# Copy reports to your docs
mkdir -p docs/configuration
cp audit_reports/*.md docs/configuration/

# Commit them
git add docs/configuration/
git commit -m "docs: add configuration audit reports"
```

---

## 🐛 Troubleshooting

### Script won't run
```bash
# Make executable
chmod +x audit_dustnvim.py audit_dustnvim.sh
```

### Python not found
```bash
# Check Python version (need 3.6+)
python3 --version

# Use bash version instead
./audit_dustnvim.sh
```

### Config not detected
```bash
# Specify path explicitly
./audit_dustnvim.py /full/path/to/config
```

### No output
```bash
# Check if reports were created
ls -la ~/audit_reports/

# Run with full path
cd ~/.config/nv
python3 scripts/audit_dustnvim.py .
```

---

## ⚙️ Advanced: Scheduled Audits

### Add to Git Hooks
Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
echo "Running config audit..."
python3 ~/.config/nv/scripts/audit_dustnvim.py
```

### Weekly Audit (Cron)
```bash
# Edit crontab
crontab -e

# Add weekly audit
0 9 * * 1 python3 ~/.config/nv/scripts/audit_dustnvim.py
```

---

## 🎨 Example Reports

Check the `example_reports/` folder to see what output looks like!

---

## 📄 System Requirements

**Bash Script:**
- bash 4.0+
- grep, sed, awk (standard Unix tools)
- Optional: tree or eza

**Python Script:**
- Python 3.6+
- No external dependencies

**Both work on:**
- ✅ Linux
- ✅ macOS  
- ✅ Termux
- ✅ WSL

---

## 🆘 Need Help?

1. Check example_reports/ for sample output
2. Read full README.md for details
3. Open issue on GitHub

---

**Made with ❤️ for DustNvim**

Stop wondering what's in your config. Know exactly what you have!
