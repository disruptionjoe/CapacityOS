---
type: SKL
status: active
root: System/skills
title: "Governed Mutation"
slug: governed-mutation
skill_id: governed-mutation
allowed_inputs: ["act_slug", "mutation_target", "mutation_content"]
expected_outputs: ["mutation_applied", "act_status_done"]
target_types: []
canon_mutation_allowed: true
approval_required: true
agt_ref: ""
trigger_conditions: ["user_applies_mutation", "act_status_approved"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Apply approved changes to canonical files in System/ or Alignment/ directories. Requires an approved ACT (status: approved) as the governance authority. Validates the change, applies it safely, and marks the ACT as done.

## Trigger Conditions
- ACT with status: approved and canon_mutation_allowed: true is ready for execution
- User explicitly requests "apply mutation {act_slug}"
- Mutation is part of approved improvement or structural change

## Procedure

### Step 1: Accept Input
Required:
- **act_slug** (string, format: "ACT-{slug}")
- **mutation_target** (string, path relative to CapacityOS/ root)
- **mutation_content** (string, the content to apply or patch)

Optional:
- **patch_mode** (enum: replace, append, merge; default: replace)

### Step 2: Validate ACT Authority
1. Parse act_slug and locate ACT in Flow/actions/
   - File: `Flow/actions/ACT-{slug}.md`
   - If not found, reject: "ACT not found: {act_slug}"

2. Read ACT metadata:
   - Check status: must be "approved"
   - If status ≠ approved, reject: "ACT must be approved to apply mutation; current status: {status}"
   - Check canon_mutation_allowed: must be true
   - If false, reject: "This ACT does not permit canonical mutations"

3. Extract mutation authority:
   - ACT is the governance record for this change
   - ACT.title and ACT.action_description describe the intended change

### Step 3: Validate Mutation Target
1. Check target path:
   - Must be relative to CapacityOS/ root
   - Must be within System/ or Alignment/ (safe zones)
   - Reject mutations to Flow/, tests/, .git, or other restricted dirs
   - If target outside safe zones, reject: "Mutation target must be in System/ or Alignment/"

2. Determine if target exists:
   - If exists: check readability and format (YAML frontmatter if applicable)
   - If not exists: will create new file

3. Verify target path syntax:
   - Must be valid filesystem path
   - No parent directory traversal (..)
   - If invalid, reject: "Invalid target path: {mutation_target}"

### Step 4: Validate Mutation Content
1. Check that mutation_content is non-empty
   - If empty, reject: "Mutation content cannot be empty"

2. If target is YAML-frontmattered file (ACT, IMP, IBX, etc.):
   - Validate new content against PW schema
   - If content is YAML patch (not full file), verify it merges validly
   - If validation fails, reject: "Mutation would create invalid file structure: {reason}"

3. If patch_mode = merge or append:
   - Verify that merge operation is well-defined
   - Test merge without writing to disk
   - If merge fails, reject: "Merge operation failed: {reason}"

### Step 5: Create Backup
1. If mutation_target exists:
   - Create backup: `System/backups/{mutation_target}_{timestamp}.bak`
   - Verify backup created successfully
   - If backup fails, reject: "Failed to create backup; mutation aborted for safety"

2. If target does not exist:
   - No backup needed; proceed

### Step 6: Apply Mutation
1. Based on patch_mode:

   **If patch_mode = replace (default):**
   - Overwrite entire file with mutation_content
   - Write to mutation_target

   **If patch_mode = append:**
   - Read existing file (if exists)
   - Append mutation_content to end
   - Write back

   **If patch_mode = merge:**
   - Read existing file as YAML (if exists and is YAML)
   - Merge mutation_content (parsed as YAML) into existing structure
   - Write merged result

2. Verify write succeeded:
   - Check file exists
   - Check file size is reasonable
   - Spot-check file readability

3. Run PW validation on mutated file:
   - If validation fails: restore from backup and reject: "Mutation created invalid file; restored from backup"
   - If validation passes: proceed to Step 7

### Step 7: Update ACT Status
1. Read ACT file
2. Set status = "done"
3. Update status_updated_at = current timestamp
4. Add mutation metadata:
   ```
   mutation_applied:
     target: {mutation_target}
     timestamp: {current_timestamp}
     patch_mode: {patch_mode}
   ```
5. Write ACT back to Flow/actions/
6. Verify write succeeded

### Step 8: Log Mutation
1. Append to System/logs/governed-mutation.log:
   ```
   [timestamp] Mutation applied by {act_slug}
   Target: {mutation_target}
   Patch Mode: {patch_mode}
   Status: success
   ```

2. Create mutation record in System/mutations/:
   - File: `System/mutations/{act_slug}_{timestamp}.md`
   - Content: before/after diff or description of change (human-readable)

### Step 9: Report
```
Mutation applied: {act_slug}

Target: {mutation_target}
Patch Mode: {patch_mode}
Status: Success
ACT Status: approved → done
Effective: {status_updated_at}
Backup: System/backups/{mutation_target}_{timestamp}.bak
```

## Output Format
```
Governed mutation executed: {act_slug}

Applied to: {mutation_target}
Mode: {patch_mode}
Status: Complete
ACT now: done
```

## Error Handling
- **ACT not found**: Report: "ACT {act_slug} not found"
- **ACT not approved**: Report: "ACT must be approved to apply mutation; current status: {status}"
- **canon_mutation_allowed is false**: Report: "ACT does not permit canonical mutations"
- **Target outside safe zones**: Report: "Cannot mutate {mutation_target}; restricted directory"
- **Mutation content invalid**: Report: "Mutation would create invalid file; rejected"
- **Backup creation failed**: Report: "Failed to create backup; mutation aborted"
- **File write failure**: Report: "Failed to write mutation; target file unchanged"
- **PW validation failed post-mutation**: Report: "Mutation created invalid file; restored from backup; aborted"
- **ACT status update failed**: Warn: "Mutation applied but ACT status not updated; mark manually"
