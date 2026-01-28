#!/usr/bin/env python3
"""
DustNvim Configuration Auditor (Python Edition)
More powerful parsing and analysis than bash version
"""

import os
import re
import json
from pathlib import Path
from collections import defaultdict, Counter
from datetime import datetime

class DustNvimAuditor:
    def __init__(self, config_path):
        self.config_path = Path(config_path)
        self.output_dir = self.config_path / "audit_reports"
        self.output_dir.mkdir(exist_ok=True)
        
        self.plugins = []
        self.keybindings = []
        self.functions = []
        self.lsp_servers = []
        
    def scan_plugins(self):
        """Extract all plugin declarations"""
        plugin_pattern = re.compile(r'["\']([a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+)["\']')
        
        for lua_file in self.config_path.rglob("*.lua"):
            try:
                content = lua_file.read_text(encoding='utf-8')
                for match in plugin_pattern.finditer(content):
                    self.plugins.append({
                        'name': match.group(1),
                        'file': str(lua_file.relative_to(self.config_path)),
                        'repo': f"https://github.com/{match.group(1)}"
                    })
            except Exception as e:
                print(f"Warning: Could not read {lua_file}: {e}")
    
    def scan_keybindings(self):
        """Extract keybinding declarations"""
        keymap_patterns = [
            re.compile(r'vim\.keymap\.set\(["\']([a-z]+)["\'],\s*["\']([^"\']+)["\'].*desc\s*=\s*["\']([^"\']+)["\']'),
            re.compile(r'vim\.api\.nvim_set_keymap\(["\']([a-z]+)["\'],\s*["\']([^"\']+)["\']'),
            re.compile(r'map\(["\']([^"\']+)["\'],\s*["\']([^"\']+)["\']')
        ]
        
        for lua_file in self.config_path.rglob("*.lua"):
            try:
                content = lua_file.read_text(encoding='utf-8')
                relative_path = str(lua_file.relative_to(self.config_path))
                
                for line_num, line in enumerate(content.split('\n'), 1):
                    for pattern in keymap_patterns:
                        match = pattern.search(line)
                        if match:
                            groups = match.groups()
                            self.keybindings.append({
                                'file': relative_path,
                                'line': line_num,
                                'mode': groups[0] if len(groups) > 0 else 'n',
                                'key': groups[1] if len(groups) > 1 else groups[0],
                                'desc': groups[2] if len(groups) > 2 else 'No description',
                                'raw': line.strip()
                            })
            except Exception as e:
                print(f"Warning: Could not read {lua_file}: {e}")
    
    def scan_functions(self):
        """Extract function definitions"""
        func_pattern = re.compile(r'function\s+([a-zA-Z_][a-zA-Z0-9_]*)')
        
        for lua_file in self.config_path.rglob("*.lua"):
            try:
                content = lua_file.read_text(encoding='utf-8')
                relative_path = str(lua_file.relative_to(self.config_path))
                
                for line_num, line in enumerate(content.split('\n'), 1):
                    match = func_pattern.search(line)
                    if match:
                        self.functions.append({
                            'name': match.group(1),
                            'file': relative_path,
                            'line': line_num
                        })
            except Exception as e:
                print(f"Warning: Could not read {lua_file}: {e}")
    
    def scan_lsp_servers(self):
        """Extract LSP server configurations"""
        server_dir = self.config_path / "lua/user/config/server"
        
        if not server_dir.exists():
            return
        
        for category_dir in server_dir.iterdir():
            if category_dir.is_dir():
                for server_file in category_dir.glob("*.lua"):
                    try:
                        content = server_file.read_text(encoding='utf-8')
                        
                        # Extract basic info
                        cmd_match = re.search(r'cmd\s*=\s*{([^}]+)}', content)
                        filetypes_match = re.search(r'filetypes\s*=\s*{([^}]+)}', content)
                        
                        self.lsp_servers.append({
                            'name': server_file.stem,
                            'category': category_dir.name,
                            'file': str(server_file.relative_to(self.config_path)),
                            'cmd': cmd_match.group(1).strip() if cmd_match else 'Unknown',
                            'filetypes': filetypes_match.group(1).strip() if filetypes_match else 'Unknown'
                        })
                    except Exception as e:
                        print(f"Warning: Could not read {server_file}: {e}")
    
    def find_duplicates(self):
        """Find duplicate plugins, functions, and keybindings"""
        duplicates = {
            'plugins': defaultdict(list),
            'functions': defaultdict(list),
            'keybindings': defaultdict(list)
        }
        
        # Plugin duplicates
        for plugin in self.plugins:
            duplicates['plugins'][plugin['name']].append(plugin)
        
        # Function duplicates
        for func in self.functions:
            duplicates['functions'][func['name']].append(func)
        
        # Keybinding duplicates
        for kb in self.keybindings:
            key = f"{kb['mode']}:{kb['key']}"
            duplicates['keybindings'][key].append(kb)
        
        # Filter to only actual duplicates
        return {
            'plugins': {k: v for k, v in duplicates['plugins'].items() if len(v) > 1},
            'functions': {k: v for k, v in duplicates['functions'].items() if len(v) > 1},
            'keybindings': {k: v for k, v in duplicates['keybindings'].items() if len(v) > 1}
        }
    
    def generate_reports(self):
        """Generate all markdown reports"""
        print("🔍 Scanning configuration...")
        
        self.scan_plugins()
        print(f"  ✓ Found {len(self.plugins)} plugin references")
        
        self.scan_keybindings()
        print(f"  ✓ Found {len(self.keybindings)} keybindings")
        
        self.scan_functions()
        print(f"  ✓ Found {len(self.functions)} functions")
        
        self.scan_lsp_servers()
        print(f"  ✓ Found {len(self.lsp_servers)} LSP servers")
        
        duplicates = self.find_duplicates()
        
        print("\n📝 Generating reports...")
        
        # Master Summary
        self._generate_master_summary(duplicates)
        print("  ✓ Master summary")
        
        # Plugin Inventory
        self._generate_plugin_inventory()
        print("  ✓ Plugin inventory")
        
        # Keybinding Reference
        self._generate_keybinding_reference()
        print("  ✓ Keybinding reference")
        
        # Duplicate Report
        self._generate_duplicate_report(duplicates)
        print("  ✓ Duplicate detection")
        
        # LSP Report
        self._generate_lsp_report()
        print("  ✓ LSP configuration")
        
        print(f"\n✨ Reports saved to: {self.output_dir}")
    
    def _generate_master_summary(self, duplicates):
        """Generate master summary report"""
        output = self.output_dir / "00_MASTER_SUMMARY.md"
        
        unique_plugins = len(set(p['name'] for p in self.plugins))
        unique_functions = len(set(f['name'] for f in self.functions))
        
        with output.open('w', encoding='utf-8') as f:
            f.write("# DustNvim Configuration Audit\n\n")
            f.write(f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            f.write("---\n\n")
            
            f.write("## 📊 Quick Stats\n\n")
            f.write("| Metric | Count |\n")
            f.write("|--------|------:|\n")
            f.write(f"| Unique Plugins | {unique_plugins} |\n")
            f.write(f"| Total Plugin References | {len(self.plugins)} |\n")
            f.write(f"| Keybindings | {len(self.keybindings)} |\n")
            f.write(f"| Functions | {unique_functions} |\n")
            f.write(f"| LSP Servers | {len(self.lsp_servers)} |\n")
            f.write("\n")
            
            f.write("## ⚠️ Issues Found\n\n")
            f.write(f"- **Duplicate Plugins:** {len(duplicates['plugins'])}\n")
            f.write(f"- **Duplicate Functions:** {len(duplicates['functions'])}\n")
            f.write(f"- **Duplicate Keybindings:** {len(duplicates['keybindings'])}\n")
            f.write("\n")
            
            f.write("## 📚 Report Index\n\n")
            f.write("1. [Plugin Inventory](01_PLUGINS.md)\n")
            f.write("2. [Keybinding Reference](02_KEYBINDINGS.md)\n")
            f.write("3. [Duplicate Detection](03_DUPLICATES.md)\n")
            f.write("4. [LSP Servers](04_LSP_SERVERS.md)\n")
            f.write("\n")
    
    def _generate_plugin_inventory(self):
        """Generate plugin inventory"""
        output = self.output_dir / "01_PLUGINS.md"
        
        # Group by plugin name
        plugin_map = defaultdict(list)
        for plugin in self.plugins:
            plugin_map[plugin['name']].append(plugin['file'])
        
        with output.open('w', encoding='utf-8') as f:
            f.write("# Plugin Inventory\n\n")
            f.write(f"**Total Unique Plugins:** {len(plugin_map)}\n\n")
            f.write("---\n\n")
            
            for plugin_name in sorted(plugin_map.keys()):
                files = plugin_map[plugin_name]
                f.write(f"## `{plugin_name}`\n\n")
                f.write(f"**Repository:** https://github.com/{plugin_name}\n\n")
                f.write(f"**Referenced in {len(files)} file(s):**\n\n")
                for file in sorted(set(files)):
                    f.write(f"- `{file}`\n")
                f.write("\n")
    
    def _generate_keybinding_reference(self):
        """Generate keybinding reference"""
        output = self.output_dir / "02_KEYBINDINGS.md"
        
        # Group by file
        kb_by_file = defaultdict(list)
        for kb in self.keybindings:
            kb_by_file[kb['file']].append(kb)
        
        with output.open('w', encoding='utf-8') as f:
            f.write("# Keybinding Reference\n\n")
            f.write(f"**Total Keybindings:** {len(self.keybindings)}\n\n")
            f.write("---\n\n")
            
            f.write("## 📋 All Keybindings\n\n")
            f.write("| Mode | Key | Description | File |\n")
            f.write("|------|-----|-------------|------|\n")
            
            for kb in sorted(self.keybindings, key=lambda x: (x['mode'], x['key'])):
                f.write(f"| `{kb['mode']}` | `{kb['key']}` | {kb['desc']} | `{kb['file']}:{kb['line']}` |\n")
            
            f.write("\n\n---\n\n")
            f.write("## 📂 By File\n\n")
            
            for file in sorted(kb_by_file.keys()):
                f.write(f"### `{file}`\n\n")
                for kb in kb_by_file[file]:
                    f.write(f"- **[{kb['mode']}]** `{kb['key']}` → {kb['desc']}\n")
                f.write("\n")
    
    def _generate_duplicate_report(self, duplicates):
        """Generate duplicate detection report"""
        output = self.output_dir / "03_DUPLICATES.md"
        
        with output.open('w', encoding='utf-8') as f:
            f.write("# Duplicate Detection\n\n")
            f.write("---\n\n")
            
            # Duplicate Plugins
            f.write("## ⚠️ Duplicate Plugin Declarations\n\n")
            if duplicates['plugins']:
                for plugin_name, occurrences in sorted(duplicates['plugins'].items()):
                    f.write(f"### `{plugin_name}` ({len(occurrences)} occurrences)\n\n")
                    for occ in occurrences:
                        f.write(f"- `{occ['file']}`\n")
                    f.write("\n")
            else:
                f.write("✅ No duplicate plugin declarations found!\n\n")
            
            # Duplicate Functions
            f.write("## ⚠️ Duplicate Function Definitions\n\n")
            if duplicates['functions']:
                for func_name, occurrences in sorted(duplicates['functions'].items()):
                    f.write(f"### `{func_name}()` ({len(occurrences)} definitions)\n\n")
                    for occ in occurrences:
                        f.write(f"- `{occ['file']}:{occ['line']}`\n")
                    f.write("\n")
            else:
                f.write("✅ No duplicate function definitions found!\n\n")
            
            # Duplicate Keybindings
            f.write("## ⚠️ Duplicate Keybindings\n\n")
            if duplicates['keybindings']:
                for key, occurrences in sorted(duplicates['keybindings'].items()):
                    mode, binding = key.split(':', 1)
                    f.write(f"### `{binding}` in `{mode}` mode ({len(occurrences)} mappings)\n\n")
                    for occ in occurrences:
                        f.write(f"- `{occ['file']}:{occ['line']}` → {occ['desc']}\n")
                    f.write("\n")
            else:
                f.write("✅ No duplicate keybindings found!\n\n")
    
    def _generate_lsp_report(self):
        """Generate LSP server report"""
        output = self.output_dir / "04_LSP_SERVERS.md"
        
        # Group by category
        servers_by_category = defaultdict(list)
        for server in self.lsp_servers:
            servers_by_category[server['category']].append(server)
        
        with output.open('w', encoding='utf-8') as f:
            f.write("# LSP Server Configuration\n\n")
            f.write(f"**Total Servers:** {len(self.lsp_servers)}\n\n")
            f.write("---\n\n")
            
            for category in sorted(servers_by_category.keys()):
                f.write(f"## 🔧 {category}\n\n")
                
                for server in sorted(servers_by_category[category], key=lambda x: x['name']):
                    f.write(f"### `{server['name']}`\n\n")
                    f.write(f"- **File:** `{server['file']}`\n")
                    f.write(f"- **Command:** `{server['cmd']}`\n")
                    f.write(f"- **Filetypes:** `{server['filetypes']}`\n")
                    f.write("\n")

def main():
    import sys
    
    config_path = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser("~/.config/nv")
    
    if not os.path.exists(config_path):
        print(f"❌ Error: Configuration not found at {config_path}")
        print(f"Usage: {sys.argv[0]} [path_to_config]")
        sys.exit(1)
    
    print("=" * 50)
    print("  DustNvim Configuration Auditor")
    print("=" * 50)
    print()
    
    auditor = DustNvimAuditor(config_path)
    auditor.generate_reports()
    
    print("\n✅ Audit complete!")
    print(f"📂 Check reports in: {auditor.output_dir}")

if __name__ == "__main__":
    main()
