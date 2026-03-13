---
type: SKL
status: active
root: System/skills
title: "Resolve Approval"
slug: resolve-approval
skill_id: resolve-approval
allowed_inputs: ["slug", "decision", "decision_notes"]
expected_outputs: ["status_updated"]
target_types: ["ACT", "IMP"]
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["item_requires_approval", "user_approves_decision", "user_declines_decision"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Process human decisions on ACT or IMP items with requires_approval=true and status=review. Update status based on decision (approve → approved → active, decline → declined, defer → review).

## Trigger Conditions
- User explicitly approves or declines a review item
- Dashboard quick-action: "D1 approve" or "D2 decline"
- Programmatic approval via API

## Procedure

### Step 1: Accept Input
Required:
- **slug** (string, format: {TYPE}-{slug})
- **decision** (enum: approve, decline, defer)

Optional:
- **decision_notes** (string, max 500 chars, context for decision)

### Step 2: Locate Item
1. Parse slug to extract TYPE and item_slug
   - Expected format: "ACT-{slug}" or "IMP-{slug}"
   - If format invalid, reject: "Invalid slug format; use ACT-{slug} or IMP-{slug}"

2. Check Flow/actions/ for file matching slug:
   - If TYPE=ACT: search for `ACT-{item_slug}.md`
   - If TYPE=IMP: search for `IMP-{item_slug}.md`
   - If not found, reject: "Item not found: {slug}"

3. Read file and check status:
   - If status ≠ "review", reject: "Item {slug} is not in review status; current status: {status}"
   - If requires_approval ≠ true, reject: "Item {slug} does not require approval"

### Step 3: Validate Decision
1. Check that decision is one of: approve, decline, defer
2. If invalid, reject: "Decision must be one of: approve, decline, defer"

### Step 4: Apply Decision
Perform appropriate state transition:

**If decision = approve:**
1. Set status = "approved"
2. Set status_updated_at = current UTC timestamp
3. If decision_notes provided, append to item metadata: `approval_notes: "{decision_notes}"`
4. Do NOT change status to "active" yet — that happens on next operator action
5. Proceed to Step 5

**If decision = decline:**
1. Set status = "declined"
2. Set status_updated_at = current UTC timestamp
3. Append decision_notes to metadata (mandatory for declined items): `decline_reason: "{decision_notes}"`
4. Mark item as eligible for archiving (operator can run SKL-archive-item)
5. Proceed to Step 5

**If decision = defer:**
1. Keep status = "review"
2. Set status_updated_at = current UTC timestamp
3. Append decision_notes as: `deferred_notes: "{decision_notes}"`
4. Item remains in Awaiting Your Decision section of dashboard
5. Proceed to Step 5

### Step 5: Update File
1. Read complete file
2. Update YAML front-matter with new status and timestamps
3. If decision_notes provided, add metadata field:
   - approval_notes (for approve)
   - decline_reason (for decline)
   - deferred_notes (for defer)
4. Write file back to Flow/actions/{TYPE}-{slug}.md
5. Verify write succeeded

### Step 6: Log Decision
1. Append to System/logs/resolve-approval.log:
   ```
   [timestamp] {slug}: {decision} → status={new_status}
   Notes: {decision_notes or "(none)"}
   ```

### Step 7: Report
1. Report format:
   ```
   Decision recorded: {slug}
   Status: {old_status} → {new_status}
   Decision: {decision}
   Notes: {decision_notes or "(none)"}
   ```

## Output Format
```
Approval resolved: {slug}

Title: {item_title}
Decision: {decision}
New Status: {new_status}
Effective: {status_updated_at}
```

## Error Handling
- **Slug not found**: Report: "Item {slug} not found in Flow/actions/"
- **Item not in review status**: Report: "Cannot approve/decline; item is {status}, not review"
- **requires_approval not true**: Report: "Item does not require approval"
- **Invalid decision value**: Report: "Decision must be approve, decline, or defer"
- **File write failure**: Report: "Failed to update item status; system error"
- **Metadata parsing failure**: Report: "Failed to parse item metadata; check file integrity"
