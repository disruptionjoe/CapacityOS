---
type: SYS
status: active
root: System/governance
title: "Validation Policy"
slug: validation-policy
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

# Validation Policy

Complete validation ruleset for all CapacityOS file types. Validation is deterministic and halting — any failure routes to explicit repair.

---

## Validation Phases

1. **Pre-write validation:** Before file creation/modification
2. **Post-write validation:** Immediately after file written
3. **Mismatch handling:** If any validation fails
4. **Archival validation:** Special rules for archived files

---

## Pre-Write Validation Checklist

All checks must pass before a file is accepted. Any failure → HALT → classify → create repair task.

### PW-01: Filename Pattern Match

**Rule:** Filename must match pattern `{TYPE}-{slug}.md`

**Check:**
- Filename contains exactly one hyphen in the format position
- Character before first hyphen is uppercase letter
- Characters after first hyphen are lowercase letters, numbers, or hyphens only
- Filename ends with `.md`

**Failure example:** `draft-proposal.md` (missing type prefix)

**Repair:** Create ACT with task_kind=update-file to rename file to match pattern

---

### PW-02: Filename Prefix Matches YAML Type

**Rule:** The filename prefix (before first hyphen) must match the YAML `type` field exactly.

**Check:**
```
filename_prefix = filename.split('-')[0]  # e.g., "ACT" from "ACT-proposal.md"
yaml_type = frontmatter.type              # e.g., "ACT" from type: ACT
assert filename_prefix == yaml_type
```

**Failure example:** `ACT-proposal.md` with YAML `type: SKL`

**Repair:** Create ACT with task_kind=update-file to fix either filename or YAML type

---

### PW-03: Filename Slug Matches YAML Slug

**Rule:** The filename slug (after first hyphen, before `.md`) must match the YAML `slug` field exactly.

**Check:**
```
filename_slug = filename.split('-', 1)[1].replace('.md', '')
# e.g., "draft-proposal" from "ACT-draft-proposal.md"
yaml_slug = frontmatter.slug  # e.g., "draft-proposal" from slug: draft-proposal
assert filename_slug == yaml_slug
```

**Failure example:** `ACT-draft-proposal.md` with YAML `slug: draft-proposal-v2`

**Repair:** Create ACT with task_kind=update-file to align filename and YAML slug

---

### PW-04: File Folder Matches YAML Root

**Rule:** The folder containing the file must match the YAML `root` field exactly.

**Check:**
```
file_folder = parent_directory_path
# e.g., "Flow/actions" for file at "Flow/actions/ACT-proposal.md"
yaml_root = frontmatter.root  # e.g., "Flow/actions" from root: Flow/actions
assert file_folder == yaml_root
```

**Failure example:** File at `Flow/inbox/ACT-proposal.md` with YAML `root: Flow/actions`

**Repair:** Create ACT with task_kind=update-file to move file to correct folder and/or fix YAML root

---

### PW-05: Reserved

(Reserved for future use)

---

### PW-06: All Global Required Fields Present

**Rule:** Every file (except Alignment domain files) must have all 7 global required fields in YAML front-matter.

**Required fields:**
1. `type` (closed enum)
2. `status` (type-specific enum)
3. `root` (closed enum)
4. `title` (non-empty string)
5. `slug` (non-empty string, lowercase-kebab-case)
6. `created_at` (date, YYYY-MM-DD format)
7. `updated_at` (date, YYYY-MM-DD format)

**Check:**
```
required_fields = ['type', 'status', 'root', 'title', 'slug', 'created_at', 'updated_at']
for field in required_fields:
  assert field in frontmatter
  assert frontmatter[field] is not None
  assert frontmatter[field] != ""
```

**Failure example:** Missing `created_at` field

**Repair:** Create ACT with task_kind=update-file to add missing field

---

### PW-07: All Type-Specific Required Fields Present

**Rule:** Every file must have all required fields for its type (see Schema and Enums Registry).

**Type-specific required fields:**

| Type | Required Fields |
|------|-----------------|
| IBX | (none beyond global) |
| ACT | `action_description`, `done_condition`, `requires_approval` |
| IMP | `improvement_description`, `category`, `scope`, `priority`, `expected_benefit`, `implementation_plan`, `files_affected` |
| SYS | (none beyond global) |
| SKL | `skill_id`, `allowed_inputs`, `expected_outputs`, `target_types` |
| AGT | `agent_id`, `persona`, `scope`, `delegation_allowed` |

**Check:**
```
required_by_type = SCHEMA_REGISTRY[frontmatter.type].required_fields
for field in required_by_type:
  assert field in frontmatter
  assert frontmatter[field] is not None
```

**Failure example:** ACT file missing `done_condition`

**Repair:** Create ACT with task_kind=update-file to add missing field with appropriate content

---

### PW-08: Status Value in Type's Enum

**Rule:** The `status` field must contain a value from the closed enum for that file type.

**Check:**
```
valid_statuses = STATUS_ENUMS[frontmatter.type]
assert frontmatter.status in valid_statuses
```

**Type-specific valid statuses:**
- IBX: `new`, `triage`
- ACT: `new`, `active`, `review`, `approved`, `blocked`, `done`, `deferred`, `declined`
- IMP: `proposed`, `queued`, `executing`, `done`, `reviewed`, `rejected`, `deferred`
- SYS: `active`, `review`
- SKL: `active`, `review`
- AGT: `active`, `review`

**Failure example:** ACT file with `status: pending` (not in enum)

**Repair:** Create ACT with task_kind=update-file to set status to valid enum value

---

### PW-09: All Enum Fields Contain Valid Closed-Enum Values

**Rule:** Every field marked as a closed enum in the schema must contain only values from its enum definition.

**Enum fields to validate:**
- `type` (global)
- `root` (global)
- `status` (global, type-specific enums)
- `task_kind` (ACT, optional)
- `authority_type` (ACT, optional)
- `category` (IMP)
- `scope` (IMP, also in AGT)

**Check:**
```
for field_name, field_value in frontmatter:
  if field_name in ENUM_DEFINITIONS:
    valid_values = ENUM_DEFINITIONS[field_name]
    assert field_value in valid_values
```

**Failure example:** ACT with `task_kind: undefined-task` (not in enum)

**Repair:** Create ACT with task_kind=update-file to set field to valid enum value

---

### PW-10: Slug Format: Lowercase-Kebab-Case

**Rule:** The `slug` field must contain only lowercase letters, numbers, and hyphens. No spaces, underscores, or special characters.

**Check:**
```
slug = frontmatter.slug
assert all(c in "abcdefghijklmnopqrstuvwxyz0123456789-" for c in slug)
assert slug[0] != "-"  # no leading hyphen
assert slug[-1] != "-"  # no trailing hyphen
assert "--" not in slug  # no double hyphens
```

**Failure example:** `slug: Draft-Proposal` (uppercase letters)

**Repair:** Create ACT with task_kind=update-file to convert slug to lowercase-kebab-case

---

### PW-11: Date Format: YYYY-MM-DD

**Rule:** Both `created_at` and `updated_at` must be valid dates in ISO 8601 format (YYYY-MM-DD).

**Check:**
```
import datetime
for date_field in ['created_at', 'updated_at']:
  date_str = frontmatter[date_field]
  try:
    datetime.datetime.strptime(date_str, '%Y-%m-%d')
  except ValueError:
    raise ValidationError(f"Invalid date format: {date_str}")
```

**Failure example:** `created_at: "3/13/2026"` (not YYYY-MM-DD format)

**Repair:** Create ACT with task_kind=update-file to convert to YYYY-MM-DD format

---

### PW-12: Authority Chain Valid (ACT Only)

**Rule:** ACT files with `authority_type: approval-granted` MUST have a valid `authority_ref` field pointing to a legitimate authority source.

**Check:**
```
if frontmatter.type == "ACT" and frontmatter.authority_type == "approval-granted":
  assert frontmatter.authority_ref is not None
  assert frontmatter.authority_ref != ""
  # Verify authority_ref points to valid source
  authority_target = resolve_reference(frontmatter.authority_ref)
  assert authority_target exists
  assert authority_target is valid (see below)
```

**Valid authority sources:**
- Another ACT with `status: approved`
- An AGT with `delegation_allowed: true`
- A SYS governance document
- A SKL with `approval_required: false`

**Failure example:** `authority_type: approval-granted` with no `authority_ref`

**Repair:** Create ACT with task_kind=update-file to either:
- Add valid `authority_ref`, or
- Change `authority_type` to `direct-human` or `routine-maintenance`

---

### PW-13: File Not in Archive

**Rule:** Files in `Flow/archive/` are immutable. No modifications allowed.

**Check:**
```
file_path = get_file_path(file)
if "Flow/archive" in file_path:
  raise ValidationError("Archived files are immutable; cannot modify")
```

**Failure example:** Attempting to modify `Flow/archive/ACT-completed-project.md`

**Repair:** Cannot modify archived files. Create new file in active folder if change is needed.

---

## Post-Write Validation

After file is written, perform these additional checks:

### Temporal Consistency

**Rule:** `updated_at` should be >= `created_at`

**Check:**
```
assert frontmatter.updated_at >= frontmatter.created_at
```

**Failure:** File claims to be updated before it was created

**Repair:** Create ACT to correct date fields

---

### Circular Authority References

**Rule:** Authority references must not form cycles.

**Check:**
```
def check_no_cycles(ref, visited=set()):
  if ref in visited:
    raise ValidationError("Circular authority reference detected")
  visited.add(ref)
  target = resolve_reference(ref)
  if target.authority_ref:
    check_no_cycles(target.authority_ref, visited)
```

**Failure:** ACT A authorizes ACT B which authorizes ACT A

**Repair:** Create ACT to break the cycle by removing/changing one authority_ref

---

## Mismatch Handling Protocol

When validation fails at any checkpoint:

1. **HALT** — Stop all processing immediately
2. **Classify** — Determine which PW-check failed (PW-01 through PW-13)
3. **Route** — Create repair task:
   - Type: ACT
   - task_kind: update-file
   - status: new
   - requires_approval: false
   - action_description: "Repair validation failure: [PW-XX] in [filename]"
   - done_condition: "File passes all PW-checks 01-13"
   - target_root: [folder of broken file]
   - origin_type: SYS
   - origin_ref: validation-policy
4. **Record** — Log incident with:
   - Timestamp
   - File involved
   - Failed check
   - Repair task ID
   - Resolution status (pending/resolved)

**No silent repair.** Every validation failure creates an explicit task.

---

## Alignment System Files Exception

**Scope:** Files in `Alignment/` folder (flat structure)

**Validation model:** Lightweight (not triple-redundancy)

**Checks that APPLY:**
- PW-06: Global required fields present (adjusted set)
- PW-08: Status valid for type
- PW-09: Enum fields valid
- PW-11: Date format correct
- PW-13: Not in archive

**Checks that DON'T APPLY:**
- PW-01: Filename pattern (lighter naming allowed)
- PW-02: Filename prefix must match type (not strictly enforced)
- PW-03: Filename slug match (not strictly enforced)
- PW-04: Folder match YAML root (not strictly enforced)

**Alignment validation:** Assessed by system-level rules for workstream coordination and alignment files

---

## Archival-Specific Validation

### Archive Immutability

**Rule:** Once a file is in `Flow/archive/`, it cannot be modified.

**Checks:**
- No content changes allowed
- No YAML field changes allowed
- No status transitions allowed (except if somehow reversed from archive, which is rare)

**Exception:** Only governance can reverse archival with explicit ACT

---

### Archive Integrity

**Rule:** All archived files must be complete and valid.

**Checks:**
- All PW-checks 01-13 passed before archival
- Final status recorded (done, declined, rejected, deferred)
- Timestamps match final update

---

## Validation Automation

### Validator Responsibilities

The system should implement a validator (human or agent) that:

1. **Runs pre-write checks** before file is accepted
2. **Runs post-write checks** immediately after file is written
3. **Blocks invalid files** and creates repair tasks
4. **Logs all failures** with timestamps and details
5. **Escalates systematic failures** (e.g., if multiple files fail PW-10) to governance

### Validation Frequency

- **On creation:** Full validation (PW-01 through PW-13)
- **On modification:** Full validation if YAML fields change; content-only changes may skip PW-checks
- **On archival:** Full validation to ensure file is in valid final state
- **Periodic audit:** Weekly scan of all active files for validation drift

---

## Validation Error Messages

When a file fails validation, the error message should include:

1. **Which check failed** (e.g., "PW-03: Filename slug does not match YAML slug")
2. **What was expected** (e.g., "Expected slug 'draft-proposal' in filename")
3. **What was found** (e.g., "Found slug 'draft_proposal' in filename")
4. **Repair task ID** (e.g., "See ACT-repair-validation-failure-2026-03-13-001")
5. **How to fix it** (e.g., "Rename file to 'ACT-draft-proposal.md'")

---

## Validation Exceptions and Overrides

**Rule:** No validation can be bypassed without explicit governance ACT.

**Rare cases requiring override:**
- Emergency archival of corrupted file
- System migration between schema versions
- One-time compatibility with legacy format

**Process:**
1. Create SYS governance document requesting exception
2. Obtain trio assessment
3. Create override ACT with authority_type=approval-granted
4. Record override in audit log
5. Schedule follow-up review

---

## Validation Metrics and Reporting

### Monthly Validation Report

Track and report:
- Total files validated
- Validation pass rate (%)
- Most common failure (which PW-check)
- Repair time average (hours)
- Files with repeated failures
- Systematic issues requiring governance attention

### Escalation Thresholds

If any of these trigger, escalate to governance team:
- Pass rate drops below 95%
- Average repair time exceeds 4 hours
- Same file fails validation 3+ times
- Same PW-check fails more than 10 times in a week
- Circular authority reference detected
- Archive integrity failure

---

## Version History

| Date | Change | Reason |
|------|--------|--------|
| 2026-03-13 | Validation Policy 1.0 | Initial system foundation |
