#!/usr/bin/env python3
"""
validate-file.py

Validates a single file against the CapacityOS schema.
Runs checks PW-01 through PW-13.

Usage:
    python3 validate-file.py /path/to/file.md

Returns: 0 if all checks pass, 1 if any fail.
"""

import sys
import os
from pathlib import Path
import re

# Valid enums
VALID_ROOTS = [
    'Flow/intake',
    'Flow/inbox',
    'Flow/actions',
    'Flow/archive',
    'Alignment',
    'System/skills',
    'System/agents',
    'System/schemas',
    'System/governance',
    'System/templates',
    'System/scripts',
    'System/routing',
    'System/improvements',
]

VALID_TYPES = ['IBX', 'ACT', 'IMP', 'SYS', 'SKL', 'AGT']

def parse_yaml_frontmatter(content):
    """Extract YAML front-matter from markdown content."""
    if not content.startswith('---'):
        return None, None

    # Match the full front-matter block: ---\n...\n---
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return None, None

    yaml_block = match.group(1)
    body = content[match.end():].lstrip('\n')
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

    return yaml_dict, body

def validate_file(filepath):
    """Run validation checks on file."""
    checks = {
        'PW-01': False,  # File exists and is readable
        'PW-02': False,  # Has YAML front-matter
        'PW-03': False,  # type is valid
        'PW-04': False,  # root is valid
        'PW-05': False,  # status is present
        'PW-06': False,  # slug is present and valid format
        'PW-07': False,  # title is present
        'PW-08': False,  # created_at is present
        'PW-09': False,  # updated_at is present
        'PW-10': False,  # slug matches filename (for non-archive)
        'PW-11': False,  # type-specific fields present
        'PW-12': False,  # No extra unknown fields (warning level)
        'PW-13': False,  # Body is not empty
    }

    # PW-01: File exists and is readable
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        checks['PW-01'] = True
    except Exception as e:
        print(f"FAIL PW-01: File not readable: {e}")
        return checks

    # PW-02: Has YAML front-matter
    yaml_data, body = parse_yaml_frontmatter(content)
    if yaml_data is None:
        print("FAIL PW-02: No YAML front-matter")
        return checks
    checks['PW-02'] = True

    # PW-03: type is valid
    file_type = yaml_data.get('type')
    if file_type not in VALID_TYPES:
        print(f"FAIL PW-03: Invalid type '{file_type}'. Must be one of {VALID_TYPES}")
    else:
        checks['PW-03'] = True

    # PW-04: root is valid
    file_root = yaml_data.get('root')
    if file_root not in VALID_ROOTS:
        print(f"FAIL PW-04: Invalid root '{file_root}'. Must be one of {VALID_ROOTS}")
    else:
        checks['PW-04'] = True

    # PW-05: status is present
    status = yaml_data.get('status')
    if not status:
        print("FAIL PW-05: status is missing")
    else:
        checks['PW-05'] = True

    # PW-06: slug is present and valid format
    slug = yaml_data.get('slug')
    if not slug:
        print("FAIL PW-06: slug is missing")
    elif not re.match(r'^[a-z0-9_-]+$', slug):
        print(f"FAIL PW-06: slug '{slug}' has invalid format (must be lowercase with hyphens/underscores)")
    else:
        checks['PW-06'] = True

    # PW-07: title is present
    title = yaml_data.get('title')
    if not title:
        print("FAIL PW-07: title is missing")
    else:
        checks['PW-07'] = True

    # PW-08: created_at is present
    created_at = yaml_data.get('created_at')
    if not created_at:
        print("FAIL PW-08: created_at is missing")
    else:
        checks['PW-08'] = True

    # PW-09: updated_at is present
    updated_at = yaml_data.get('updated_at')
    if not updated_at:
        print("FAIL PW-09: updated_at is missing")
    else:
        checks['PW-09'] = True

    # PW-10: slug matches filename (for non-archive files)
    # Filename format is {TYPE}-{slug}, so strip the type prefix before comparing
    if 'Flow/archive' not in file_root:
        filename = Path(filepath).stem
        # Strip TYPE- prefix from filename to get the slug portion
        filename_slug = re.sub(r'^[A-Z]+-', '', filename)
        if slug and slug != filename_slug:
            print(f"FAIL PW-10: slug '{slug}' does not match filename slug '{filename_slug}' (from '{filename}')")
        else:
            checks['PW-10'] = True
    else:
        checks['PW-10'] = True  # Archive files don't need to match

    # PW-11: type-specific fields
    if file_type == 'ACT':
        if 'requires_approval' not in yaml_data:
            print("FAIL PW-11: ACT files must have 'requires_approval' field")
        else:
            checks['PW-11'] = True
    elif file_type == 'IMP':
        if 'priority' not in yaml_data:
            print("FAIL PW-11: IMP files must have 'priority' field")
        else:
            checks['PW-11'] = True
    else:
        checks['PW-11'] = True

    # PW-12: No extra unknown fields (warning level)
    known_fields = {
        'type', 'root', 'status', 'slug', 'title', 'created_at', 'updated_at',
        'alignment_domain', 'requires_approval', 'priority', 'domain_name',
        'skill_id', 'purpose', 'trigger_conditions', 'allowed_inputs',
        'expected_outputs', 'target_types', 'canon_mutation_allowed',
        'approval_required', 'agt_ref', 'agent_id', 'persona', 'scope',
        'delegation_allowed', 'active',
        'last_sweep', 'sweep_result', 'inbox_count_at_sweep'
    }
    extra_fields = set(yaml_data.keys()) - known_fields
    if extra_fields:
        print(f"WARN PW-12: Unknown fields: {extra_fields}")
    checks['PW-12'] = True  # Warning level only

    # PW-13: Body is not empty
    if not body or not body.strip():
        print("FAIL PW-13: File body is empty")
    else:
        checks['PW-13'] = True

    return checks

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} /path/to/file.md", file=sys.stderr)
        sys.exit(1)

    filepath = sys.argv[1]

    checks = validate_file(filepath)

    # Print results
    for check_id in sorted(checks.keys()):
        status = "PASS" if checks[check_id] else "FAIL"
        print(f"{status} {check_id}")

    # Return exit code
    failed = [k for k, v in checks.items() if not v and k != 'PW-12']
    if failed:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == '__main__':
    main()
