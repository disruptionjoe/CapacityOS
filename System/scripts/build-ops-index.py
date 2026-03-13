#!/usr/bin/env python3
"""
build-ops-index.py

Scans Flow/actions/ for .md files, extracts YAML front-matter,
and writes a compact JSON index to System/scripts/indexes/ops-index.json.

Usage:
    python3 build-ops-index.py [--root /path/to/CapacityOS]
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

            # Remove quotes if present
            if value.startswith('"') and value.endswith('"'):
                value = value[1:-1]
            elif value.startswith("'") and value.endswith("'"):
                value = value[1:-1]

            # Parse boolean values
            if value.lower() == 'true':
                value = True
            elif value.lower() == 'false':
                value = False

            yaml_dict[key] = value

    return yaml_dict

def build_ops_index(root_path):
    """Scan Flow/actions/ and build ops index."""
    actions_dir = Path(root_path) / 'Flow' / 'actions'

    index = []

    if not actions_dir.exists():
        print(f"Warning: {actions_dir} does not exist", file=sys.stderr)
        return index

    # Scan all .md files
    md_files = sorted(actions_dir.glob('*.md'))

    for md_file in md_files:
        try:
            with open(md_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Warning: Error reading {md_file}: {e}", file=sys.stderr)
            continue

        # Parse YAML front-matter
        yaml_data = parse_yaml_frontmatter(content)
        if not yaml_data:
            print(f"Warning: No YAML front-matter in {md_file}", file=sys.stderr)
            continue

        # Extract required fields
        entry = {
            'slug': yaml_data.get('slug'),
            'type': yaml_data.get('type'),
            'status': yaml_data.get('status'),
            'title': yaml_data.get('title'),
            'alignment_domain': yaml_data.get('alignment_domain'),
        }

        # Add optional fields based on type
        if entry['type'] == 'ACT' and 'requires_approval' in yaml_data:
            entry['requires_approval'] = yaml_data['requires_approval']

        if entry['type'] == 'IMP' and 'priority' in yaml_data:
            entry['priority'] = yaml_data['priority']

        index.append(entry)

    return index

def main():
    root = '.'

    # Parse --root argument
    if len(sys.argv) > 1:
        if sys.argv[1] == '--root' and len(sys.argv) > 2:
            root = sys.argv[2]
        else:
            print(f"Usage: {sys.argv[0]} [--root /path/to/CapacityOS]", file=sys.stderr)
            sys.exit(1)

    # Build index
    index = build_ops_index(root)

    # Ensure output directory exists
    output_dir = Path(root) / 'System' / 'scripts' / 'indexes'
    output_dir.mkdir(parents=True, exist_ok=True)

    # Write JSON
    output_file = output_dir / 'ops-index.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(index, f, indent=2)

    print(f"Wrote {len(index)} entries to {output_file}")

if __name__ == '__main__':
    main()
