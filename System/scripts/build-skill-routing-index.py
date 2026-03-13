#!/usr/bin/env python3
"""
build-skill-routing-index.py

Scans System/skills/SKL-*.md, extracts skill metadata,
and writes skill routing index to System/scripts/indexes/skill-routing-index.json.

Usage:
    python3 build-skill-routing-index.py [--root /path/to/CapacityOS]
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

            # Handle list values first (before bool conversion)
            if isinstance(value, str) and value.startswith('[') and value.endswith(']'):
                try:
                    value = json.loads(value)
                except:
                    pass
            elif value.lower() == 'true':
                value = True
            elif value.lower() == 'false':
                value = False

            yaml_dict[key] = value

    return yaml_dict

def parse_list_field(value):
    """Parse list field from YAML value."""
    if isinstance(value, list):
        return value
    if isinstance(value, str):
        if value.startswith('[') and value.endswith(']'):
            try:
                return json.loads(value)
            except:
                return [value]
        return [value]
    return []

def build_skill_routing_index(root_path):
    """Scan System/skills/SKL-*.md and build skill routing index."""
    skills_dir = Path(root_path) / 'System' / 'skills'

    index = []

    if not skills_dir.exists():
        print(f"Warning: {skills_dir} does not exist", file=sys.stderr)
        return index

    # Scan all SKL-*.md files
    skl_files = sorted(skills_dir.glob('SKL-*.md'))

    for skl_file in skl_files:
        try:
            with open(skl_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Warning: Error reading {skl_file}: {e}", file=sys.stderr)
            continue

        # Parse YAML front-matter
        yaml_data = parse_yaml_frontmatter(content)
        if not yaml_data:
            print(f"Warning: No YAML front-matter in {skl_file}", file=sys.stderr)
            continue

        # Create entry
        entry = {
            'skill_id': yaml_data.get('skill_id'),
            'purpose': yaml_data.get('title'),  # Use title as purpose
            'trigger_conditions': parse_list_field(yaml_data.get('trigger_conditions', [])),
            'allowed_inputs': parse_list_field(yaml_data.get('allowed_inputs', [])),
            'expected_outputs': parse_list_field(yaml_data.get('expected_outputs', [])),
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
    index = build_skill_routing_index(root)

    # Ensure output directory exists
    output_dir = Path(root) / 'System' / 'scripts' / 'indexes'
    output_dir.mkdir(parents=True, exist_ok=True)

    # Write JSON
    output_file = output_dir / 'skill-routing-index.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(index, f, indent=2)

    print(f"Wrote {len(index)} entries to {output_file}")

if __name__ == '__main__':
    main()
