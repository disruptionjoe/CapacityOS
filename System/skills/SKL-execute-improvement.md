---
type: SKL
status: active
root: System/skills
title: "Execute Improvement"
slug: execute-improvement
skill_id: execute-improvement
allowed_inputs: ["imp_slug"]
expected_outputs: ["improvement_executed", "imp_status_done"]
target_types: ["IMP"]
canon_mutation_allowed: true
approval_required: false
agt_ref: ""
trigger_conditions: ["user_executes_improvement", "imp_status_approved"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Pick one queued IMP (status: approved or proposed), execute its implementation_plan step-by-step, update status to executing → done. May involve mutations to System/ or Alignment/ if approved.

## Trigger Conditions
- IMP with status: approved is ready for execution
- User explicitly requests "execute {imp_slug}"
- Automatic execution (optional): daily scan for approved IMPs

## Procedure

### Step 1: Accept Input
Required:
- **imp_slug** (string, format: "IMP-{slug}")

### Step 2: Locate & Validate IMP
1. Find `Flow/actions/IMP-{slug}.md`
   - If not found, reject: "Improvement not found: {imp_slug}"

2. Read IMP metadata:
   - Check status: must be "proposed" or "approved"
   - If status is done/archived, reject: "Improvement already executed"
   - If status is review, reject: "Improvement requires review first; call SKL-structural-review"
   - Extract: title, implementation_plan, effort_estimate, affected_personas

3. Validate implementation_plan:
   - Must be non-empty and in numbered step format
   - Extract step list

### Step 3: Update Status to Executing
1. Read IMP file
2. Set status = "executing"
3. Set status_updated_at = current timestamp
4. Write file back
5. Confirm status change succeeded

### Step 4: Execute Implementation Plan
For each numbered step in implementation_plan:

1. **Parse step instruction** — understand what needs to happen
   - Examples:
     - "Create a new skill file System/skills/SKL-auto-archive.md with logic..."
     - "Add 'auto_archive_enabled' field to Config/settings.yaml"
     - "Run SKL-archive-item for all items with status=done"

2. **Execute the step:**

   **If step is creating/modifying a file:**
   - Determine file path (relative to CapacityOS/)
   - If in System/ or Alignment/, validate via PW before writing
   - Create or update the file as specified
   - Log: "Step {N}: File created/updated: {path}"

   **If step is calling another skill:**
   - Invoke the skill (e.g., "Run SKL-archive-item")
   - Pass necessary inputs from IMP context
   - Wait for skill completion
   - Log: "Step {N}: Skill executed: {skill_name}"

   **If step is configuration or setup:**
   - Apply configuration changes
   - Verify changes took effect
   - Log: "Step {N}: Configuration applied"

   **If step is validation/testing:**
   - Run validation checks
   - If validation fails: log error, halt execution, report failure
   - If validation passes: log success

3. **Error handling per step:**
   - If step fails: halt execution
   - Report: "Step {N} failed: {error}; stopping execution"
   - Do NOT skip steps or continue
   - Go to Step 5b (Rollback)

4. **Log each step:**
   - Append to System/logs/execute-improvement.log:
     ```
     [timestamp] IMP-{slug} Step {N}: {step_summary} → {status: success or failure}
     ```

### Step 5a: Completion (All Steps Succeeded)
1. Update IMP status:
   - Set status = "done"
   - Set status_updated_at = current timestamp
   - Add execution metadata:
     ```
     execution:
       executed_at: "{timestamp}"
       steps_completed: {step_count}
     ```

2. Write IMP file back

3. Archive the IMP:
   - Call SKL-archive-item with imp_slug
   - Move completed IMP to Flow/archive/IMP/

4. Log completion:
   ```
   [timestamp] IMP-{slug} executed successfully
   Steps: {step_count}
   Status: done → archived
   ```

5. Report success (see Output Format)

### Step 5b: Failure & Rollback
1. If any step failed:
   - Set status = "blocked"
   - Set status_updated_at = current timestamp
   - Add failure metadata:
     ```
     execution:
       failed_at_step: {N}
       error: "{error_message}"
     ```

2. Attempt rollback (if applicable):
   - If implementation involved file changes, restore from backups (created by SKL-governed-mutation)
   - If restoration possible, report: "Execution failed at step {N}; changes rolled back"
   - If restoration not possible, report: "Execution failed at step {N}; manual intervention may be needed"

3. Do NOT archive failed IMP — leave in blocked status for review

4. Create diagnostic ACT:
   - title: "Repair failed improvement execution: {imp_slug}"
   - description: {error details}
   - requires_approval: true
   - Operator can manually fix and retry

### Step 6: Report
**Success Case:**
```
Improvement executed: {imp_slug}

Title: {title}
Steps: {step_count} completed
Status: done → archived
Execution time: {duration}
Completed: {status_updated_at}
```

**Failure Case:**
```
Improvement execution failed: {imp_slug}

Title: {title}
Failed at step: {N}
Error: {error_message}
Status: blocked (awaiting manual review)

Repair ACT: {diagnostic_act_slug}
Next: Review failure and decide on correction
```

## Output Format
**Success:**
```
Improvement executed: {imp_slug}

Implementation complete: {step_count} steps
Status: done (archived to Flow/archive/IMP/)
```

**Failure:**
```
Improvement execution halted: {imp_slug}

Failed at step: {N}
Error: {error}
Status: blocked

Repair task: {diagnostic_act_slug}
```

## Error Handling
- **IMP not found**: Report: "Improvement {imp_slug} not found"
- **IMP not approved**: Report: "Cannot execute {imp_slug}; status is {status}, not proposed/approved"
- **Status update fails**: Report: "Failed to update IMP status; execution may continue but tracking incomplete"
- **Step execution fails**: Halt, report specific error, create diagnostic ACT
- **Rollback not possible**: Warn operator; create diagnostic ACT for manual repair
- **Implementation_plan missing or malformed**: Report: "IMP does not have valid implementation plan"
