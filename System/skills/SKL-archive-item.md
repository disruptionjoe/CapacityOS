---
type: SKL
status: active
root: System/skills
title: "Archive Item"
slug: archive-item
skill_id: archive-item
allowed_inputs: ["slug"]
expected_outputs: ["item_archived"]
target_types: ["ACT", "IMP", "IBX"]
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["item_status_done", "item_status_declined", "item_status_rejected", "user_archives_item"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Move completed or rejected items (status: done, declined, rejected) from Flow/actions/ or Flow/inbox/ to Flow/archive/{TYPE}/, maintaining full history and updating archive MANIFEST.yaml with metadata for later retrieval.

## Trigger Conditions
- Item reaches status: done, declined, or rejected
- User explicitly requests "archive {slug}"
- Automatic weekly cleanup (optional)

## Procedure

### Step 1: Accept Input
Required:
- **slug** (string, format: {TYPE}-{slug})

### Step 2: Locate Item
1. Parse slug to extract TYPE and item_slug
   - Expected format: "ACT-{slug}", "IMP-{slug}", or "IBX-{slug}"

2. Search for item:
   - Check Flow/actions/ for ACT or IMP files
   - Check Flow/inbox/ for IBX files
   - File pattern: `{TYPE}-{item_slug}.md`
   - If not found in either, reject: "Item not found: {slug}"

3. Read file and extract:
   - status (must be: done, declined, rejected)
   - title
   - created_at
   - All YAML metadata

4. Validate archivable status:
   - If status not in [done, declined, rejected], reject:
     "Cannot archive {slug}; status is {status} (not done/declined/rejected)"

### Step 3: Prepare Archive
1. Determine archive destination:
   - If TYPE=ACT: `Flow/archive/ACT/`
   - If TYPE=IMP: `Flow/archive/IMP/`
   - If TYPE=IBX: `Flow/archive/IBX/`

2. Create archive directory if not exists:
   - Create Flow/archive/{TYPE}/ if needed

3. Generate archive filename:
   - Format: `{item_slug}_{status}_{timestamp}.md`
   - Example: `feature-request_done_2026-03-13T14:30:00Z.md`

### Step 4: Move/Copy File
1. Read complete source file
2. Write to archive destination:
   `Flow/archive/{TYPE}/{archive_filename}`
3. Verify write succeeded
4. Delete source file from Flow/actions/ or Flow/inbox/
5. Verify deletion succeeded

### Step 5: Update Archive MANIFEST
1. Read or create `Flow/archive/{TYPE}/MANIFEST.yaml`
   - If not exists, create empty manifest

2. Add entry to manifest:
   ```yaml
   - slug: {slug}
     title: "{title}"
     original_type: {TYPE}
     status: {status}
     created_at: "{created_at}"
     archived_at: "{current_timestamp}"
     archive_file: "{archive_filename}"
   ```

3. Keep manifest entries sorted by archived_at (descending)

4. Write updated MANIFEST.yaml

### Step 6: Log Archive Event
1. Append to System/logs/archive-item.log:
   ```
   [timestamp] Archived {slug}: {status} → {archive_filename}
   ```

### Step 7: Report
```
Archived: {slug}

Type: {TYPE}
Status: {status}
Title: {title}
Location: Flow/archive/{TYPE}/{archive_filename}
Archived At: {current_timestamp}
```

## Output Format
```
Item archived: {slug}

Source: Flow/actions/ or Flow/inbox/
Destination: Flow/archive/{TYPE}/{archive_filename}
Status: {status}
```

## Error Handling
- **Item not found**: Report: "Item {slug} not found in Flow/actions/ or Flow/inbox/"
- **Status not archivable**: Report: "Cannot archive {slug}; status is {status} (must be done/declined/rejected)"
- **File read failure**: Report: "Failed to read item file: {system_error}"
- **File write failure**: Report: "Failed to write to archive: {system_error}"
- **File delete failure**: Report: "Failed to delete source file: {system_error}; archive was created but source remains"
- **MANIFEST update failure**: Warn: "Item archived but MANIFEST not updated; archive listing may be incomplete"
- **Flow/archive/{TYPE}/ creation fails**: Report: "Failed to create archive directory: {system_error}"
