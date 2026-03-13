---
type: SKL
status: active
root: System/skills
title: "Triage IBX"
slug: triage-ibx
skill_id: triage-ibx
allowed_inputs: []
expected_outputs: ["act_created", "imp_created", "ibx_status_triaged"]
target_types: ["IBX"]
canon_mutation_allowed: false
approval_required: false
agt_ref: "triage"
trigger_conditions: ["ibx_status_new", "user_triages_inbox"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Process IBX (inbox) files with status:new, classify them as action (ACT), improvement (IMP), or informational (archived), and route to appropriate workflow. Move processed IBX files to status:triaged.

## Trigger Conditions
- One or more IBX files exist in Flow/inbox/ with status:new
- User explicitly requests "triage inbox" or "process new items"
- Automatic hourly scan (optional)

## Procedure

### Step 1: Discover IBX Files
1. Scan `Flow/inbox/` for all `.md` files
2. For each file, read YAML front-matter and check `status: new`
3. If no new items, report "No items to triage" and exit
4. Create list of IBX objects for processing

### Step 2: Classify Each IBX

For each IBX with status:new:

1. **Read content and title** to understand intent
2. **Classify into one of three categories:**
   - **ACTION**: Requires explicit human decision or execution
     - Indicators: action verbs (do, decide, review, create, fix), next-step clarity, due date present
   - **IMPROVEMENT**: Suggests system or process enhancement
     - Indicators: "should", "could", "improve", "better", "optimize", "refactor"
   - **INFORMATIONAL**: Reference material, knowledge artifact, or resolved item
     - Indicators: past tense, "learned", "documented", "reference", no action needed

3. **Infer alignment_domain** (if not already set):
   - Scan title and content for domain keywords (must match a folder in Alignment/)
   - If match found, set alignment_domain = {domain_name}
   - Otherwise, leave as null (will be General)

4. **Proceed per classification:**

   **If ACTION:**
   - Generate ACT file via SKL-create-act with:
     - title = IBX title
     - action_description = IBX content summary
     - alignment_domain = {inferred domain or null}
     - requires_approval = false (default; user can escalate manually)
     - done_condition = (extracted from IBX if present, else inferred)
   - Update IBX status to triaged
   - Link IBX to ACT via metadata tag: `created_from: {act_slug}`

   **If IMPROVEMENT:**
   - Generate IMP file in Flow/actions/ with:
     - title = IBX title
     - proposal = IBX content
     - status = proposed
     - alignment_domain = {inferred domain or null}
   - Update IBX status to triaged
   - Link via: `created_from: {imp_slug}`

   **If INFORMATIONAL:**
   - Update IBX status to archived
   - Move IBX file to `Flow/inbox/archive/` (or mark as archived in-place)

### Step 3: Update IBX Metadata
1. For each triaged IBX:
   - Set `status: triaged` in YAML
   - Set `triaged_at: "{ISO_timestamp}"`
   - If ACT or IMP was created, add: `created_act: {act_slug}` or `created_imp: {imp_slug}`
2. Write updated file back to Flow/inbox/

### Step 4: Report
1. Log summary to System/logs/triage-ibx.log
2. Report format:
   ```
   Triaged {N} IBX items
   - {A} actions created
   - {I} improvements proposed
   - {G} archived as informational
   ```

## Output Format
```
Triage complete: {N} items processed

Actions created:
  - ACT-{slug}: {title}

Improvements proposed:
  - IMP-{slug}: {title}

Archived (informational):
  - {N} items moved to Flow/inbox/archive/
```

## Error Handling
- If Flow/inbox/ does not exist: create it and report "Inbox directory initialized"
- If alignment_domain inference fails: set to null (will appear in General section)
- If ACT or IMP creation fails: log error, create diagnostic ACT for manual review, do not update IBX status
- If IBX file is unreadable: skip it, log error, continue with next
- If duplicate slug generated: append UUID suffix or timestamp
