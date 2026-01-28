#!/bin/bash

# DustNvim Configuration Auditor
# Works with bash - no Neovim required

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default to current directory or accept path argument
CONFIG_ROOT="${1:-$HOME/.config/nv}"

if [ ! -d "$CONFIG_ROOT" ]; then
    echo -e "${RED}Error: Config directory not found: $CONFIG_ROOT${NC}"
    echo "Usage: $0 [path_to_config]"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   DustNvim Configuration Auditor      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}📁 Config Path: $CONFIG_ROOT${NC}"
echo ""

OUTPUT_DIR="$CONFIG_ROOT/audit_reports"
mkdir -p "$OUTPUT_DIR"

# ============================================================================
# SECTION 1: Configuration Statistics
# ============================================================================

echo -e "${YELLOW}[1/7] Gathering configuration statistics...${NC}"

STATS_FILE="$OUTPUT_DIR/01_STATISTICS.md"

cat > "$STATS_FILE" << 'EOF'
# DustNvim Configuration Statistics

> Auto-generated configuration audit report

---

EOF

echo "**Generated:** $(date '+%Y-%m-%d %H:%M:%S')" >> "$STATS_FILE"
echo "" >> "$STATS_FILE"
echo "## 📊 File Statistics" >> "$STATS_FILE"
echo "" >> "$STATS_FILE"

# Count files
LUA_COUNT=$(find "$CONFIG_ROOT/lua" -type f -name "*.lua" 2>/dev/null | wc -l)
JSON_COUNT=$(find "$CONFIG_ROOT" -type f -name "*.json" 2>/dev/null | wc -l)
MD_COUNT=$(find "$CONFIG_ROOT" -type f -name "*.md" 2>/dev/null | wc -l)
TOTAL_LINES=$(find "$CONFIG_ROOT/lua" -type f -name "*.lua" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')

echo "| Metric | Count |" >> "$STATS_FILE"
echo "|--------|------:|" >> "$STATS_FILE"
echo "| Lua Files | $LUA_COUNT |" >> "$STATS_FILE"
echo "| JSON Files | $JSON_COUNT |" >> "$STATS_FILE"
echo "| Markdown Files | $MD_COUNT |" >> "$STATS_FILE"
echo "| Total Lines of Lua | $TOTAL_LINES |" >> "$STATS_FILE"
echo "" >> "$STATS_FILE"

# Directory breakdown
echo "## 📂 Directory Breakdown" >> "$STATS_FILE"
echo "" >> "$STATS_FILE"
echo "| Directory | Files | Lines |" >> "$STATS_FILE"
echo "|-----------|------:|------:|" >> "$STATS_FILE"

for dir in config ui sys stages mini snippets; do
    if [ -d "$CONFIG_ROOT/lua/user/$dir" ]; then
        DIR_FILES=$(find "$CONFIG_ROOT/lua/user/$dir" -type f -name "*.lua" 2>/dev/null | wc -l)
        DIR_LINES=$(find "$CONFIG_ROOT/lua/user/$dir" -type f -name "*.lua" -exec cat {} + 2>/dev/null | wc -l)
        echo "| lua/user/$dir | $DIR_FILES | $DIR_LINES |" >> "$STATS_FILE"
    fi
done

echo "" >> "$STATS_FILE"

echo -e "${GREEN}✓ Statistics saved to: $STATS_FILE${NC}"

# ============================================================================
# SECTION 2: Plugin Inventory
# ============================================================================

echo -e "${YELLOW}[2/7] Scanning for plugins...${NC}"

PLUGINS_FILE="$OUTPUT_DIR/02_PLUGINS_INVENTORY.md"

cat > "$PLUGINS_FILE" << 'EOF'
# DustNvim Plugin Inventory

> Complete list of all plugins referenced in configuration

---

EOF

echo "## 🔌 Plugins by Declaration" >> "$PLUGINS_FILE"
echo "" >> "$PLUGINS_FILE"

# Extract plugin declarations (GitHub repos)
find "$CONFIG_ROOT/lua" -type f -name "*.lua" -exec grep -h "\"[a-zA-Z0-9_-]\+/[a-zA-Z0-9_.-]\+\"" {} + 2>/dev/null | \
    grep -oE "[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+" | \
    sort -u | \
    while read plugin; do
        echo "- [\`$plugin\`](https://github.com/$plugin)" >> "$PLUGINS_FILE"
        
        # Find where it's declared
        grep -r "$plugin" "$CONFIG_ROOT/lua" --include="*.lua" -l 2>/dev/null | \
            sed "s|$CONFIG_ROOT/||" | \
            while read file; do
                echo "  - 📄 \`$file\`" >> "$PLUGINS_FILE"
            done
    done

echo "" >> "$PLUGINS_FILE"

# Check installed plugins
if [ -d "$HOME/.local/share/nv/lazy" ]; then
    echo "## 💾 Installed Plugins (from lazy.nvim)" >> "$PLUGINS_FILE"
    echo "" >> "$PLUGINS_FILE"
    
    INSTALLED_COUNT=$(ls -1 "$HOME/.local/share/nv/lazy" 2>/dev/null | wc -l)
    echo "**Total Installed:** $INSTALLED_COUNT" >> "$PLUGINS_FILE"
    echo "" >> "$PLUGINS_FILE"
    
    ls -1 "$HOME/.local/share/nv/lazy" 2>/dev/null | sort | while read plugin; do
        echo "- \`$plugin\`" >> "$PLUGINS_FILE"
    done
    echo "" >> "$PLUGINS_FILE"
fi

echo -e "${GREEN}✓ Plugin inventory saved to: $PLUGINS_FILE${NC}"

# ============================================================================
# SECTION 3: Keybinding Extraction
# ============================================================================

echo -e "${YELLOW}[3/7] Extracting keybindings...${NC}"

KEYS_FILE="$OUTPUT_DIR/03_KEYBINDINGS.md"

cat > "$KEYS_FILE" << 'EOF'
# DustNvim Keybinding Reference

> All custom keybindings found in configuration

---

EOF

echo "## ⌨️ Keybindings by File" >> "$KEYS_FILE"
echo "" >> "$KEYS_FILE"

# Find keybindings
find "$CONFIG_ROOT/lua" -type f -name "*.lua" -print0 | while IFS= read -r -d '' file; do
    RELATIVE_PATH="${file#$CONFIG_ROOT/}"
    
    # Look for various keybinding patterns
    KEYBINDS=$(grep -nE "vim\.keymap\.set|vim\.api\.nvim_set_keymap|map\(" "$file" 2>/dev/null || true)
    
    if [ ! -z "$KEYBINDS" ]; then
        echo "### 📄 \`$RELATIVE_PATH\`" >> "$KEYS_FILE"
        echo "" >> "$KEYS_FILE"
        echo '```lua' >> "$KEYS_FILE"
        echo "$KEYBINDS" >> "$KEYS_FILE"
        echo '```' >> "$KEYS_FILE"
        echo "" >> "$KEYS_FILE"
    fi
done

echo -e "${GREEN}✓ Keybindings saved to: $KEYS_FILE${NC}"

# ============================================================================
# SECTION 4: Duplicate Detection
# ============================================================================

echo -e "${YELLOW}[4/7] Detecting duplicates...${NC}"

DUPLICATES_FILE="$OUTPUT_DIR/04_DUPLICATES.md"

cat > "$DUPLICATES_FILE" << 'EOF'
# DustNvim Duplicate Detection

> Potential duplicates and conflicts

---

EOF

echo "## ⚠️ Duplicate Plugin References" >> "$DUPLICATES_FILE"
echo "" >> "$DUPLICATES_FILE"

# Find plugins declared multiple times
find "$CONFIG_ROOT/lua" -type f -name "*.lua" -exec grep -h "\"[a-zA-Z0-9_-]\+/[a-zA-Z0-9_.-]\+\"" {} + 2>/dev/null | \
    grep -oE "[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+" | \
    sort | uniq -c | sort -rn | while read count plugin; do
        if [ "$count" -gt 1 ]; then
            echo "### 🔴 \`$plugin\` (declared $count times)" >> "$DUPLICATES_FILE"
            echo "" >> "$DUPLICATES_FILE"
            grep -r "$plugin" "$CONFIG_ROOT/lua" --include="*.lua" -n 2>/dev/null | \
                sed "s|$CONFIG_ROOT/||" | head -10 >> "$DUPLICATES_FILE"
            echo "" >> "$DUPLICATES_FILE"
        fi
    done

echo "## ⚠️ Duplicate Function Names" >> "$DUPLICATES_FILE"
echo "" >> "$DUPLICATES_FILE"

# Find duplicate function definitions
grep -r "function" "$CONFIG_ROOT/lua" --include="*.lua" -n 2>/dev/null | \
    grep -oE "function [a-zA-Z_][a-zA-Z0-9_]*" | \
    awk '{print $2}' | sort | uniq -c | sort -rn | while read count funcname; do
        if [ "$count" -gt 1 ]; then
            echo "### 🔴 \`$funcname()\` (defined $count times)" >> "$DUPLICATES_FILE"
            echo "" >> "$DUPLICATES_FILE"
            grep -r "function $funcname" "$CONFIG_ROOT/lua" --include="*.lua" -n 2>/dev/null | \
                sed "s|$CONFIG_ROOT/||" | head -10 >> "$DUPLICATES_FILE"
            echo "" >> "$DUPLICATES_FILE"
        fi
    done

echo "## ⚠️ Potential Duplicate Keybindings" >> "$DUPLICATES_FILE"
echo "" >> "$DUPLICATES_FILE"

# Extract keybindings and find duplicates
grep -r "<leader>" "$CONFIG_ROOT/lua" --include="*.lua" -oh 2>/dev/null | \
    sort | uniq -c | sort -rn | head -20 | while read count key; do
        if [ "$count" -gt 1 ]; then
            echo "- \`$key\` appears $count times" >> "$DUPLICATES_FILE"
        fi
    done

echo "" >> "$DUPLICATES_FILE"

echo -e "${GREEN}✓ Duplicates report saved to: $DUPLICATES_FILE${NC}"

# ============================================================================
# SECTION 5: LSP Server Documentation
# ============================================================================

echo -e "${YELLOW}[5/7] Documenting LSP servers...${NC}"

LSP_FILE="$OUTPUT_DIR/05_LSP_SERVERS.md"

cat > "$LSP_FILE" << 'EOF'
# DustNvim LSP Server Configuration

> All configured Language Server Protocol servers

---

EOF

for category in LowLevel HighLevel Web GameDev Productive Utilities; do
    if [ -d "$CONFIG_ROOT/lua/user/config/server/$category" ]; then
        echo "## 🔧 $category Languages" >> "$LSP_FILE"
        echo "" >> "$LSP_FILE"
        
        find "$CONFIG_ROOT/lua/user/config/server/$category" -name "*.lua" 2>/dev/null | sort | while read server_file; do
            SERVER_NAME=$(basename "$server_file" .lua)
            echo "### \`$SERVER_NAME\`" >> "$LSP_FILE"
            echo "" >> "$LSP_FILE"
            echo "**File:** \`${server_file#$CONFIG_ROOT/}\`" >> "$LSP_FILE"
            echo "" >> "$LSP_FILE"
            
            # Extract configuration details
            if grep -q "cmd.*=" "$server_file" 2>/dev/null; then
                CMD=$(grep "cmd.*=" "$server_file" | head -1)
                echo "**Command:** \`$CMD\`" >> "$LSP_FILE"
                echo "" >> "$LSP_FILE"
            fi
            
            if grep -q "filetypes" "$server_file" 2>/dev/null; then
                FILETYPES=$(grep "filetypes" "$server_file" | head -1)
                echo "**Filetypes:** \`$FILETYPES\`" >> "$LSP_FILE"
                echo "" >> "$LSP_FILE"
            fi
            
            echo "---" >> "$LSP_FILE"
            echo "" >> "$LSP_FILE"
        done
    fi
done

echo -e "${GREEN}✓ LSP servers documented in: $LSP_FILE${NC}"

# ============================================================================
# SECTION 6: Configuration Structure Map
# ============================================================================

echo -e "${YELLOW}[6/7] Mapping configuration structure...${NC}"

STRUCTURE_FILE="$OUTPUT_DIR/06_STRUCTURE_MAP.md"

cat > "$STRUCTURE_FILE" << 'EOF'
# DustNvim Configuration Structure

> Visual map of the configuration architecture

---

## 📁 Directory Tree

EOF

# Use tree or fallback to find
if command -v tree &> /dev/null; then
    tree -L 4 -I 'node_modules|.git' "$CONFIG_ROOT/lua" >> "$STRUCTURE_FILE" 2>/dev/null
elif command -v eza &> /dev/null; then
    eza --tree --level=4 --git-ignore "$CONFIG_ROOT/lua" >> "$STRUCTURE_FILE" 2>/dev/null
else
    find "$CONFIG_ROOT/lua" -type d | sed "s|$CONFIG_ROOT/lua|.|" | sort >> "$STRUCTURE_FILE"
fi

echo "" >> "$STRUCTURE_FILE"
echo "## 📊 Stage Loading Order" >> "$STRUCTURE_FILE"
echo "" >> "$STRUCTURE_FILE"

if [ -d "$CONFIG_ROOT/lua/user/stages" ]; then
    ls -1 "$CONFIG_ROOT/lua/user/stages" 2>/dev/null | sort | while read stage; do
        echo "### Stage: \`$stage\`" >> "$STRUCTURE_FILE"
        echo "" >> "$STRUCTURE_FILE"
        
        # Count requires in this stage
        REQUIRES=$(grep -c "require" "$CONFIG_ROOT/lua/user/stages/$stage" 2>/dev/null || echo "0")
        echo "- **Requires:** $REQUIRES module(s)" >> "$STRUCTURE_FILE"
        
        # Extract loaded modules
        echo "- **Loads:**" >> "$STRUCTURE_FILE"
        grep "require" "$CONFIG_ROOT/lua/user/stages/$stage" 2>/dev/null | \
            sed 's/.*require[("]*\([^)"]*\).*/  - `\1`/' >> "$STRUCTURE_FILE"
        
        echo "" >> "$STRUCTURE_FILE"
    done
fi

echo -e "${GREEN}✓ Structure map saved to: $STRUCTURE_FILE${NC}"

# ============================================================================
# SECTION 7: Master Summary Report
# ============================================================================

echo -e "${YELLOW}[7/7] Generating master summary...${NC}"

SUMMARY_FILE="$OUTPUT_DIR/00_MASTER_SUMMARY.md"

cat > "$SUMMARY_FILE" << EOF
# DustNvim Configuration Audit Report

> **Comprehensive analysis of your Neovim configuration**

**Generated:** $(date '+%Y-%m-%d %H:%M:%S')  
**Configuration Path:** \`$CONFIG_ROOT\`

---

## 📋 Quick Stats

| Metric | Value |
|--------|------:|
| Total Lua Files | $LUA_COUNT |
| Total Lines of Code | $TOTAL_LINES |
| Configuration Stages | $(ls -1 "$CONFIG_ROOT/lua/user/stages" 2>/dev/null | wc -l) |
| LSP Servers | $(find "$CONFIG_ROOT/lua/user/config/server" -name "*.lua" 2>/dev/null | wc -l) |

---

## 📚 Report Index

1. [📊 Configuration Statistics](01_STATISTICS.md)
2. [🔌 Plugin Inventory](02_PLUGINS_INVENTORY.md)
3. [⌨️ Keybinding Reference](03_KEYBINDINGS.md)
4. [⚠️ Duplicate Detection](04_DUPLICATES.md)
5. [🔧 LSP Server Configuration](05_LSP_SERVERS.md)
6. [📁 Structure Map](06_STRUCTURE_MAP.md)

---

## 🎯 Key Findings

### Plugins
EOF

# Count unique plugins
UNIQUE_PLUGINS=$(find "$CONFIG_ROOT/lua" -type f -name "*.lua" -exec grep -h "\"[a-zA-Z0-9_-]\+/[a-zA-Z0-9_.-]\+\"" {} + 2>/dev/null | grep -oE "[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+" | sort -u | wc -l)
echo "- **Total Unique Plugins:** $UNIQUE_PLUGINS" >> "$SUMMARY_FILE"

if [ -d "$HOME/.local/share/nv/lazy" ]; then
    INSTALLED=$(ls -1 "$HOME/.local/share/nv/lazy" 2>/dev/null | wc -l)
    echo "- **Installed Plugins:** $INSTALLED" >> "$SUMMARY_FILE"
fi

echo "" >> "$SUMMARY_FILE"
echo "### Potential Issues" >> "$SUMMARY_FILE"

# Count duplicates
DUP_PLUGINS=$(find "$CONFIG_ROOT/lua" -type f -name "*.lua" -exec grep -h "\"[a-zA-Z0-9_-]\+/[a-zA-Z0-9_.-]\+\"" {} + 2>/dev/null | grep -oE "[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+" | sort | uniq -c | awk '$1 > 1' | wc -l)

if [ "$DUP_PLUGINS" -gt 0 ]; then
    echo "- ⚠️ **$DUP_PLUGINS** plugins declared multiple times" >> "$SUMMARY_FILE"
else
    echo "- ✅ No duplicate plugin declarations found" >> "$SUMMARY_FILE"
fi

echo "" >> "$SUMMARY_FILE"
echo "---" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"
echo "## 💡 Recommendations" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"
echo "1. Review [Duplicate Detection](04_DUPLICATES.md) for optimization opportunities" >> "$SUMMARY_FILE"
echo "2. Check [Plugin Inventory](02_PLUGINS_INVENTORY.md) for unused plugins" >> "$SUMMARY_FILE"
echo "3. Examine [Keybinding Reference](03_KEYBINDINGS.md) for conflicts" >> "$SUMMARY_FILE"
echo "4. Verify all LSP servers in [LSP Configuration](05_LSP_SERVERS.md) are needed" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

echo -e "${GREEN}✓ Master summary saved to: $SUMMARY_FILE${NC}"

# ============================================================================
# Completion
# ============================================================================

echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Audit Complete! ✨                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}📂 Reports Location: $OUTPUT_DIR${NC}"
echo ""
echo -e "${YELLOW}Generated Reports:${NC}"
echo "  1. 00_MASTER_SUMMARY.md       - Start here!"
echo "  2. 01_STATISTICS.md           - File and code stats"
echo "  3. 02_PLUGINS_INVENTORY.md    - All plugins listed"
echo "  4. 03_KEYBINDINGS.md          - Complete keybinding reference"
echo "  5. 04_DUPLICATES.md           - Duplicate detection"
echo "  6. 05_LSP_SERVERS.md          - LSP configuration"
echo "  7. 06_STRUCTURE_MAP.md        - Directory structure"
echo ""
echo -e "${BLUE}💡 Tip: Start with 00_MASTER_SUMMARY.md for an overview!${NC}"
echo ""

# Open summary in default editor (optional)
if command -v xdg-open &> /dev/null; then
    read -p "Open master summary now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        xdg-open "$SUMMARY_FILE" 2>/dev/null &
    fi
fi
