---
type: SKL
status: active
root: System/skills
title: "Add Workstream"
slug: create-workstream
skill_id: create-workstream
allowed_inputs: ["workstream_id", "purpose", "status", "success_criteria"]
expected_outputs: ["workstream_added", "system1_workstreams_updated"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["user_adds_workstream", "workstream_creation_requested"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Add a new workstream to Alignment/system1_workstreams.json. Workstreams are the atomic units of organization in CapacityOS. Each workstream has a purpose, status, and success criteria. This skill updates the system1_workstreams.json file to register the new workstream.

## Trigger Conditions
- User requests "add workstream {name}" or "new workstream"
- Onboarding flow (SKL-onboard-new-user) triggers workstream creation
- User clicks "Add workstream" in dashboard

## Procedure

### Step 1: Accept Input
Required:
- **workstream_id** (string, 2-50 chars, alphanumeric + hyphens, lowercase, unique)

Optional:
- **purpose** (string, one-line statement of intent)
- **status** (enum: active, paused, blocked, completed; default: active)
- **success_criteria** (string, describes what success looks like)

### Step 2: Validate Workstream ID
1. Check length: 2-50 characters
   - If invalid, reject: "Workstream ID must be 2-50 characters"

2. Check format: alphanumeric, hyphens, underscores only (no spaces)
   - Enforce lowercase
   - If invalid, reject: "Workstream ID must be lowercase alphanumeric and hyphens only"

3. Check for collision:
   - Read Alignment/system1_workstreams.json
   - Scan workstreams array for existing workstream_id
   - If exists, reject: "Workstream '{workstream_id}' already exists"

4. Reject reserved names:
   - Do not allow: "system", "all", "default", "general", "unassigned"
   - If reserved, reject: "'{workstream_id}' is a reserved name"

### Step 3: Verify System1 File
1. Check that `Alignment/system1_workstreams.json` exists
   - If not, reject: "Alignment/system1_workstreams.json not found; system not initialized"

2. Read file and validate JSON structure:
   - Must have "workstreams" array
   - Each entry must have "id", "purpose", "status", "success_criteria"
   - If invalid, reject: "system1_workstreams.json is corrupted; repair first"

### Step 4: Create Workstream Entry
1. Build new workstream object:
   ```json
   {
     "id": "{workstream_id}",
     "purpose": "{purpose or 'Not yet defined'}",
     "status": "{status or 'active'}",
     "success_criteria": "{success_criteria or 'Not yet defined'}"
   }
   ```

2. Append to workstreams array (do NOT insert in middle; append at end)

3. Update top-level "updated_at" timestamp to current ISO timestamp

### Step 5: Write Updated File
1. Write updated Alignment/system1_workstreams.json back to disk
2. Validate JSON syntax:
   - Parse file to ensure valid JSON
   - If invalid, reject and do NOT write: "JSON formatting error; workstream not added"
3. Verify file exists and is readable

### Step 6: Log Creation
1. Append to System/logs/create-workstream.log:
   ```
   [timestamp] Workstream added: {workstream_id}
   Status: {status}
   Purpose: {purpose}
   ```

### Step 7: Report
```
Workstream added: {workstream_id}

Location: Alignment/system1_workstreams.json
Status: {status}
Purpose: {purpose}
Success Criteria: {success_criteria}

Next steps:
1. Edit Alignment/system1_workstreams.json to refine purpose and criteria
2. Create work items in Flow/actions/ with workstream={workstream_id}
3. View progress on dashboard with "show dashboard"
```

## Output Format
```
Workstream initialized: {workstream_id}

File: Alignment/system1_workstreams.json
Status: {status}
Purpose: {purpose}

Quick reference:
- Edit purpose: Alignment/system1_workstreams.json
- Add work: Flow/actions/ (set workstream={workstream_id})
- View: "show dashboard" or SKL-summarize-alignment
```

## Error Handling
- **Invalid workstream_id**: Report specific validation error
- **Workstream already exists**: Report: "Workstream '{workstream_id}' already exists in system1_workstreams.json"
- **system1_workstreams.json not found**: Report: "Cannot add workstream; system1_workstreams.json not found"
- **File read/parse fails**: Report: "Failed to read system1_workstreams.json; file may be corrupted"
- **File write fails**: Report: "Failed to update system1_workstreams.json: {system_error}"
- **JSON validation fails**: Do not write; report: "JSON formatting error; changes not saved"
- **Alignment/ directory does not exist**: Create it and proceed
