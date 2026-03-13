---
type: SKL
status: active
root: System/skills
title: "Transition Status"
slug: transition-status
skill_id: transition-status
allowed_inputs: ["slug", "new_status"]
expected_outputs: ["status_updated"]
target_types: ["ACT", "IMP"]
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["user_marks_status", "status_transition_requested"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Move items (ACT, IMP) through their lifecycle by validating state transitions and updating status and timestamps. All items remain in Flow/actions/ — no file movement here (archiving is separate, via SKL-archive-item).

## Trigger Conditions
- User marks item as done, wip, active, etc. via quick-action shorthand
- Programmatic transition request
- Dashboard action: "A1 done", "A2 wip", etc.

## Procedure

### Step 1: Accept Input
Required:
- **slug** (string, format: {TYPE}-{slug})
- **new_status** (enum: active, approved, wip, blocked, done, declined, rejected)

### Step 2: Locate Item
1. Parse slug to extract TYPE and item_slug
   - Expected format: "ACT-{slug}" or "IMP-{slug}"
   - If invalid format, reject: "Invalid slug format"

2. Search Flow/actions/ for file:
   - Look for `{TYPE}-{item_slug}.md`
   - If not found, reject: "Item not found: {slug}"

3. Read file and extract current status from YAML

### Step 3: Validate Status Enum
1. Check that new_status is one of the valid enum values:
   - active, approved, wip (work in progress), blocked, done, declined, rejected
2. If invalid, reject: "Invalid status '{new_status}'; must be one of: active, approved, wip, blocked, done, declined, rejected"

### Step 4: Validate Transition
1. Define valid transitions per current status:
   ```
   new:
     → active, approved, declined (review decision)

   review:
     → approved, declined (approval resolution)

   approved:
     → active, blocked, declined

   active:
     → wip, blocked, done, rejected

   wip:
     → active, blocked, done, rejected

   blocked:
     → active, wip, rejected

   done:
     → (terminal; cannot transition) [optional: allow undo to active]

   declined:
     → (terminal; cannot transition)

   rejected:
     → (terminal; cannot transition)
   ```

2. Check if transition is legal:
   - If current_status not in valid_transitions[new_status], reject:
     "Illegal transition: {current_status} → {new_status}"
   - Else, proceed

### Step 5: Update File
1. Read complete file
2. Update YAML front-matter:
   - status = {new_status}
   - updated_at = current UTC timestamp
   - status_updated_at = current UTC timestamp
3. Preserve all other metadata
4. Write file back to Flow/actions/{TYPE}-{slug}.md
5. Verify write succeeded

### Step 6: Log Transition
1. Append to System/logs/transition-status.log:
   ```
   [timestamp] {slug}: {current_status} → {new_status}
   ```

### Step 7: Report
```
Status updated: {slug}

Title: {item_title}
Transition: {current_status} → {new_status}
Effective: {updated_at}
```

## Output Format
```
Transitioned: {slug}
Status: {current_status} → {new_status}
Updated: {status_updated_at}
```

## Error Handling
- **Item not found**: Report: "Item {slug} not found"
- **Invalid new_status**: Report: "Invalid status value"
- **Illegal transition**: Report: "Cannot transition {current_status} → {new_status}"
- **File write failure**: Report: "Failed to update status; system error"
- **YAML parse error**: Report: "Failed to parse item file; check integrity"
