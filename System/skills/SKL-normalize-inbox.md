---
type: SKL
status: active
root: System/skills
title: "Normalize Inbox"
slug: normalize-inbox
skill_id: normalize-inbox
allowed_inputs: ["raw_file_path"]
expected_outputs: ["ibx_file_created", "raw_file_archived"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["files_in_intake", "user_normalizes_inbox"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Convert raw files in Flow/intake/ (unstructured notes, clips, exports) into structured IBX (inbox) files in Flow/inbox/ with proper YAML front-matter and consistent content structure.

## Trigger Conditions
- One or more files exist in Flow/intake/
- User explicitly requests "normalize inbox" or "process intake"
- Automatic nightly scan (optional)

## Procedure

### Step 1: Scan Flow/intake/
1. List all files in `Flow/intake/` (excluding subdirectories)
2. If directory does not exist or is empty, skip skill and report "No intake items"
3. For each file, proceed to Step 2

### Step 2: Extract Raw Content
For each raw file:
1. Read the entire file content
2. Extract or infer:
   - **title**: first non-empty line, or filename without extension
   - **source**: file extension or "user_input"
   - **captured_at**: file modification timestamp (ISO 8601)
   - **content**: remaining lines (the bulk of the file)
3. If content is empty or only whitespace, mark for deletion (do not create IBX)

### Step 3: Generate IBX Structure
1. Generate slug from title using: lowercase, alphanumeric + hyphens, max 40 chars
2. Generate UUID for ibx_id
3. Create IBX file content with YAML front-matter:
   ```yaml
   ---
   type: IBX
   status: new
   ibx_id: {UUID}
   title: "{title}"
   slug: {slug}
   source: {source}
   captured_at: "{captured_at}"
   alignment_domain: null
   tags: []
   ---

   {content}
   ```

### Step 4: Validate IBX
1. Run PW (Portal Warden) validation on generated file
2. If validation fails, skip this IBX and create diagnostic ACT with requires_approval=true
3. If validation passes, proceed to Step 5

### Step 5: Write and Archive
1. Write IBX file to `Flow/inbox/{slug}_{ibx_id}.md`
2. Move original raw file to `Flow/intake/archive/{original_filename}_{timestamp}`
   - OR delete it if `Flow/intake/archive/` is not available
3. Log completion: "IBX created: {slug}" → append to System/logs/normalize-inbox.log

### Step 6: Cleanup
1. Remove all processed files from Flow/intake/
2. Report summary: "{N} IBX files created, {M} skipped (invalid)"

## Output Format
```
Normalized {N} raw files → {N} IBX in Flow/inbox/
Status: new (awaiting triage)

Example:
  - quick-grocery-list → ibx_abc123.md (captured 2026-03-13T09:15:00Z)
  - meeting-notes → ibx_def456.md (captured 2026-03-13T10:30:00Z)
```

## Error Handling
- If Flow/intake/ does not exist: create it and report "Intake directory initialized"
- If Flow/inbox/ does not exist: create it
- If PW validation fails: do not create IBX; instead create diagnostic ACT for review
- If file is unreadable: skip it, log error, continue with next file
- If slug collision (two files with same title): append UUID suffix to slug
