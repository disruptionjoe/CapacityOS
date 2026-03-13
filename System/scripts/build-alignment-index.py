#!/usr/bin/env python3
"""
build-alignment-index.py

Scans Alignment/*/system5_purpose.md, extracts YAML front-matter,
and writes alignment index to System/scripts/indexes/alignment-index.json.

Usage:
    python3 build-alignment-index.py [--root /path/to/CapacityOS]
"""

import sys
import json
import os
from pathlib import Path
import re

def parse_yaml_frontmatter(content):
    """Extract YAML front-matter from markdown content."""
    if not content.startswith('---'):
        return None

    # Match the full front-matter block: ---\n...\n---
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return None

    yaml_block = match.group(1)
    yaml_dict = {}

    for line in yaml_block.split('\n'):
        line = line.strip()
        if not line or line.startswith('#'):
            continue

        if ':' in line:
            key, value = line.split(':', 1)
            key = key.strip()
            value = value.strip()

            # Strip inline comments (# ...) but not inside quoted strings
            if not (value.startswith('"') or value.startswith("'")):
                comment_idx = value.find('#')
                if comment_idx >= 0:
                    value = value[:comment_idx].strip()

            if value.startswith('"') and value.endswith('"'):
                value = value[1:-1]
            elif value.startswith("'") and value.endswith("'"):
                value = value[1:-1]

            if value.lower() == 'true':
                value = True
            elif value.lower() == 'false':
                value = False

            yaml_dict[key] = value

    return yaml_dict

def build_alignment_index(root_path):
    """Scan Alignment/*/system5_purpose.md and build alignment index."""
    alignment_dir = Path(root_path) / 'Alignment'

    index = []

    if not alignment_dir.exists():
        print(f"Warning: {alignment_dir} does not exist", file=sys.stderr)
        return index

    # Iterate through subdirectories
    for domain_dir in sorted(alignment_dir.iterdir()):
        if not domain_dir.is_dir():
            continue

        # Skip template
        if domain_dir.name == '_domain-template':
            continue

        purpose_file = domain_dir / 'system5_purpose.md'

        if not purpose_file.exists():
            continue

        try:
            with open(purpose_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Warning: Error reading {purpose_file}: {e}", file=sys.stderr)
            continue

        # Parse YAML front-matter
        yaml_data = parse_yaml_frontmatter(content)
        if not yaml_data:
            print(f"Warning: No YAML front-matter in {purpose_file}", file=sys.stderr)
            continue

        # Create entry
        entry = {
            'domain_name': yaml_data.get('domain_name'),
            'folder_name': domain_dir.name,
            'priority': yaml_data.get('priority'),
            'active': yaml_data.get('active', True),
        }

        index.append(entry)

    return index

def main():
    root = '.'

    if len(sys.argv) > 1:
        if sys.argv[1] == '--root' and len(sys.argv) > 2:
            root = sys.argv[2]
        else:
            print(f"Usage: {sys.argv[0]} [--root /path/to/CapacityOS]", file=sys.stderr)
            sys.exit(1)

    # Build index
    index = build_alignment_index(root)

    # Ensure output directory exists
    output_dir = Path(root) / 'System' / 'scripts' / 'indexes'
    output_dir.mkdir(parents=True, exist_ok=True)

    # Write JSON
    output_file = output_dir / 'alignment-index.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(index, f, indent=2)

    print(f"Wrote {len(index)} entries to {output_file}")

if __name__ == '__main__':
    main()
