---
type: SKL
status: active
root: System/skills
title: "Repair File"
slug: repair-file
skill_id: repair-file
allowed_inputs: ["file_path"]
expected_outputs: ["repair_act_created", "diagnosis_provided"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["pw_validation_failure", "malformed_yaml", "missing_required_field"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Handle files that fail PW (Portal Warden) validation. Diagnose the failure, document the issue, and create an ACT with requires_approval=true that describes the repair needed. Do not attempt auto-repair — make human decision explicit.

## Trigger Conditions
- PW validation fails on any file in System/, Alignment/, or Flow/
- User explicitly requests "repair {file_path}"
- Automated validation sweep detects malformed file

## Procedure

### Step 1: Accept Input
Required:
- **file_path** (string, absolute path to problematic file)

### Step 2: Verify File Exists
1. Check if file exists and is readable
2. If not, reject: "File not found or not readable: {file_path}"

### Step 3: Diagnose Failure
1. Run full PW validation on file
2. Collect all validation errors:
   - YAML parsing errors (syntax, indentation)
   - Missing required fields
   - Invalid field values or types
   - Type mismatch (expecting ACT, found IBX, etc.)
   - Schema violations
3. Store error list for reporting

4. Attempt to parse file structure:
   - Try to read YAML front-matter
   - If successful, extract: type, slug, status (if available)
   - If YAML fails, note: "YAML front-matter is malformed"

### Step 4: Create Diagnostic Report
1. Compose detailed diagnosis:
   ```
   File: {file_path}
   Type: {type or "unknown"}
   Errors:
   - {error_1}
   - {error_2}
   ...

   Suggested Repair:
   {repair_suggestion_text}
   ```

2. Repair suggestions should be specific, e.g.:
   - "YAML indentation error on line 5: use 2 spaces, not tabs"
   - "Missing required field 'action_description' in ACT metadata"
   - "Invalid status 'in-progress'; must be one of: active, wip, blocked, done"
   - "Type field must match filename pattern: ACT-*.md requires type: ACT"

### Step 5: Create Repair ACT
1. Generate slug from filename or file_path:
   - Extract basename without extension
   - Prefix with "repair-"
   - Example: "repair-act-my-item"

2. Create ACT with:
   - title = "Repair {filename}: {brief_error}"
   - action_description = {diagnostic_report} (detailed diagnosis)
   - done_condition = "File passes PW validation; verified in System/logs/"
   - workstream = "system" (or null)
   - requires_approval = true (human review and decision required)
   - priority = "high" (validation failures need attention)

3. Call SKL-create-act with above parameters
4. Retrieve created act_slug

### Step 6: Link Repair to Original
1. If original file has readable YAML:
   - Try to add metadata field: `repair_act: "{repair_act_slug}"`
   - Write file back (best-effort; don't block if fails)

### Step 7: Log Repair
1. Append to System/logs/repair-file.log:
   ```
   [timestamp] Repair ACT created: {repair_act_slug}
   Original file: {file_path}
   Errors: {error_count}
   ```

2. Also create brief human-readable note in System/repairs/:
   - File: `System/repairs/{repair_act_slug}_DIAGNOSIS.md`
   - Content: diagnostic report (markdown, human-readable)

### Step 8: Report
```
Repair needed: {file_path}

Errors found: {error_count}
- {error_1_short}
- {error_2_short}

Repair ACT created: {repair_act_slug}
Status: review (awaiting approval)
Details: System/repairs/{repair_act_slug}_DIAGNOSIS.md
```

## Output Format
```
File repair initiated: {file_path}

Diagnostic ACT: {repair_act_slug}
Errors: {error_count}
Severity: {high, medium, low based on error count}
Next Step: Review and approve repair ACT → {repair_act_slug}
```

## Error Handling
- **File not found**: Report: "File not found: {file_path}"
- **File not readable**: Report: "Cannot read file (permission or I/O error): {file_path}"
- **Diagnosis unavailable**: Report: "Could not diagnose file; PW validation returned no error details"
- **ACT creation fails**: Report: "Failed to create repair ACT: {system_error}; diagnosis logged to System/repairs/"
- **YAML front-matter completely corrupted**: Create minimal ACT with best-guess diagnosis
