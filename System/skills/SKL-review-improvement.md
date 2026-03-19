---
type: SKL
status: active
root: System/skills
title: "Review Improvement"
slug: review-improvement
skill_id: review-improvement
allowed_inputs: ["imp_slug"]
expected_outputs: ["improvement_reviewed", "imp_archived"]
target_types: ["IMP"]
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["imp_status_done", "user_reviews_improvement"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Review a completed IMP (status: done). Verify that implementation_plan steps were executed correctly and changes were applied as intended. Update status to reviewed, add review notes, then archive the improvement.

## Trigger Conditions
- IMP reaches status: done (via SKL-execute-improvement)
- User explicitly requests "review {imp_slug}"
- Automatic review after improvement execution (optional)

## Procedure

### Step 1: Accept Input
Required:
- **imp_slug** (string, format: "IMP-{slug}")

### Step 2: Locate & Validate IMP
1. Find `Flow/actions/IMP-{slug}.md`
   - If not found, reject: "Improvement not found: {imp_slug}"

2. Read IMP metadata:
   - Check status: must be "done"
   - If status ≠ done, reject: "Improvement not ready for review; status is {status}"
   - Extract: title, implementation_plan, effort_estimate, affected_personas, execution metadata

3. Validate execution was complete:
   - If no execution metadata found, warn: "No execution record found; assuming manual verification needed"

### Step 3: Verify Implementation
For each step in the implementation_plan:

1. **Reconstruct what step was supposed to do** from step description

2. **Verify result:**

   **If step created/modified a file:**
   - Check if file exists at expected path
   - Read file and verify content matches spec
   - Run PW validation if applicable
   - Log: "Step {N}: File verified at {path}"

   **If step invoked a skill:**
   - Check skill execution log (System/logs/)
   - Verify skill reported success
   - Log: "Step {N}: Skill execution verified"

   **If step applied configuration:**
   - Check that configuration changes are present
   - Verify no unintended side effects
   - Log: "Step {N}: Configuration verified"

   **If step was validation:**
   - Re-run validation check
   - Verify results still pass
   - Log: "Step {N}: Validation confirmed"

3. **Handle verification failures:**
   - If any step cannot be verified: log warning "Step {N}: verification incomplete"
   - Do NOT fail entire review on verification warning
   - Note issues in review_notes for operator attention

### Step 4: Assess Impact
1. **Check affected systems:**
   - If IMP modified System/ files: scan for PW errors, integrity checks
   - If IMP modified Alignment/ files: verify no workstream consistency issues (check system1_workstreams.json)
   - If IMP called skills: check System/logs/ for side effects

2. **Measure improvements (if applicable):**
   - If IMP promised to reduce manual work: confirm time savings
   - If IMP promised clarity improvement: spot-check user experience
   - Log observations

3. **Document impact:**
   - Create impact assessment (brief notes)
   - Example: "Auto-archive skill now runs daily; verified 5 items archived in past week"

### Step 5: Create Review Notes
1. Compose review_notes (markdown):
   ```
   # Review: {title}

   ## Verification Results
   - Step 1: ✓ Verified
   - Step 2: ✓ Verified
   - Step 3: ⚠ Incomplete verification (reason)

   ## Impact Assessment
   - {change 1 verified}
   - {change 2 verified}
   - {unexpected side effect, if any}

   ## System Health
   - No new errors detected
   - Alignment workstreams: consistent (system1_workstreams.json verified)
   - Flow structure: intact

   ## Recommendation
   [Approved for production | Approved with caveats | Needs rework]
   ```

### Step 6: Update IMP Status
1. Read IMP file
2. Set status = "reviewed"
3. Set status_updated_at = current timestamp
4. Add review_notes field to YAML:
   ```
   review_notes: |
     {review_notes markdown}
   ```
5. Write file back
6. Verify write succeeded

### Step 7: Archive Improvement
1. Call SKL-archive-item with imp_slug
   - Moves IMP from Flow/actions/ to Flow/archive/IMP/
   - Updates archive MANIFEST

2. Verify archival succeeded

### Step 8: Log Review
1. Append to System/logs/review-improvement.log:
   ```
   [timestamp] Reviewed and archived: {imp_slug}
   Recommendation: {recommendation}
   Verification: {verification_status}
   ```

2. Create review record:
   - File: `System/reviews/{imp_slug}_{timestamp}_review.md`
   - Content: review_notes (for historical record)

### Step 9: Report
**Success Case:**
```
Improvement reviewed: {imp_slug}

Title: {title}
Status: done → reviewed → archived
Verification: All steps confirmed
Impact: {impact summary}
Recommendation: Approved

Archive: Flow/archive/IMP/{archive_file}
Review: System/reviews/{imp_slug}_review.md
```

**Partial Success (Verification Warnings):**
```
Improvement reviewed with caveats: {imp_slug}

Title: {title}
Status: done → reviewed → archived
Verification: {N} steps confirmed, {M} warnings

Warnings:
- {issue 1}
- {issue 2}

Recommendation: Approved with monitoring

Review: System/reviews/{imp_slug}_review.md
```

## Output Format
```
Improvement review complete: {imp_slug}

Verification: {N}/{step_count} steps confirmed
Status: done → reviewed → archived
Recommendation: {Approved | Approved with caveats}

Location: Flow/archive/IMP/{archive_file}
```

## Error Handling
- **IMP not found**: Report: "Improvement {imp_slug} not found"
- **IMP not in done status**: Report: "Cannot review {imp_slug}; status is {status}, not done"
- **Verification fails for critical step**: Log error and note in review; still proceed to approval with caveat
- **Archive operation fails**: Warn but still mark as reviewed; log error for manual archival
- **Review notes cannot be written**: Log error; review still completed but notes not persisted
- **System integrity check fails (PW errors in modified files)**: Flag as "Needs Rework" and halt archival
