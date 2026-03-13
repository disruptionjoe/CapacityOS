---
type: SKL
status: active
root: System/skills
title: "Create ACT"
slug: create-act
skill_id: create-act
allowed_inputs: ["title", "action_description", "done_condition", "alignment_domain", "requires_approval"]
expected_outputs: ["act_file_created"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["user_creates_act", "ibx_triaged_to_action"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Create a new ACT (action) file in Flow/actions/ with proper structure, metadata, and status initialization. ACT files represent concrete work items requiring execution or decision.

## Trigger Conditions
- User explicitly requests "create action" or "add task"
- IBX triage (SKL-triage-ibx) classifies item as ACTION
- External workflow routes item to actions

## Procedure

### Step 1: Accept Input
Required:
- **title** (string, max 120 chars)
- **action_description** (string, can be multi-line)
- **done_condition** (string, describes success criteria)

Optional:
- **alignment_domain** (string, must match folder in Alignment/; default null)
- **requires_approval** (boolean, default false)
- **priority** (enum: low, medium, high; default medium)
- **due_date** (ISO 8601 date; default null)

### Step 2: Validate Input
1. **Title validation:**
   - Non-empty, 1-120 chars
   - If invalid, reject: "Title required and must be 1-120 characters"

2. **action_description validation:**
   - Non-empty
   - If invalid, reject: "Action description cannot be empty"

3. **done_condition validation:**
   - Non-empty
   - If invalid, reject: "Done condition must describe success criteria"

4. **alignment_domain validation:**
   - If provided, check that Alignment/{alignment_domain}/ exists
   - If directory does not exist, warn: "Domain '{domain}' not found; setting to null"
   - Set to null if invalid

5. **requires_approval validation:**
   - Must be boolean; default false

6. **priority validation:**
   - Must be one of: low, medium, high
   - If invalid, default to medium

7. **due_date validation:**
   - If provided, must be valid ISO 8601 date
   - If invalid, set to null and warn

### Step 3: Generate Metadata
1. Generate slug from title:
   - Lowercase, replace spaces with hyphens
   - Remove non-alphanumeric except hyphens
   - Trim to max 40 chars
   - Check for collision in Flow/actions/; append UUID if needed

2. Generate act_id:
   - UUID v4 or 16-char alphanumeric

3. Set timestamps:
   - created_at = current UTC timestamp
   - updated_at = created_at
   - status_updated_at = created_at

4. Determine initial status:
   - If requires_approval=true: status = "review"
   - Else: status = "active"

### Step 4: Create YAML Front-Matter
```yaml
---
type: ACT
status: {status}
act_id: {act_id}
title: "{title}"
slug: {slug}
action_description: |
  {action_description}
done_condition: "{done_condition}"
alignment_domain: {alignment_domain or null}
priority: {priority}
due_date: {due_date or null}
requires_approval: {requires_approval}
created_at: "{created_at}"
updated_at: "{updated_at}"
status_updated_at: "{status_updated_at}"
tags: []
---
```

### Step 5: Run PW Validation
1. Check file structure against ACT schema:
   - YAML valid
   - Type field = "ACT"
   - All required fields present
   - Status is valid enum
2. If validation fails: reject and report specific error

### Step 6: Write File
1. Write ACT file to:
   `Flow/actions/ACT-{slug}.md`
2. Verify file exists
3. Report: "ACT created: {slug}"

### Step 7: Log Event
1. Append to System/logs/create-act.log:
   ```
   [timestamp] ACT created: {slug} (status: {status}, domain: {domain}, approval_required: {requires_approval})
   ```

## Output Format
```
ACT created: {slug}
Location: Flow/actions/ACT-{slug}.md
Status: {status}
Title: {title}
Alignment Domain: {alignment_domain or "General"}
Approval Required: {requires_approval}
Created: {created_at}
```

## Error Handling
- **Missing required fields**: Reject with specific field name
- **Invalid alignment_domain**: Warn and set to null; continue
- **Validation failure**: Report: "ACT does not conform to schema: {reason}"
- **File I/O error**: Report: "Failed to write ACT file: {system_error}"
- **Slug collision**: Append UUID suffix
- **Flow/actions/ does not exist**: Create directory and proceed
