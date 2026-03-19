---
type: SKL
status: active
root: System/skills
title: "Summarize Alignment"
slug: summarize-alignment
skill_id: summarize-alignment
allowed_inputs: []
expected_outputs: ["alignment_summary"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["user_requests_alignment_overview", "periodic_alignment_review"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Generate a VSM (Viable System Model) hierarchy overview across all workstreams. Read Alignment/system1_workstreams.json, extract purpose, strategy, and active items per workstream, and produce a compact summary that shows structural coherence.

## Trigger Conditions
- User explicitly requests "show alignment" or "alignment summary"
- Periodic review (e.g., weekly)
- After workstream creation or modification

## Procedure

### Step 1: Discover Workstreams
1. Read `Alignment/system1_workstreams.json`
2. Extract workstreams array
3. Each object in the array represents one workstream
4. If no workstreams found, report: "No workstreams configured; edit Alignment/system1_workstreams.json"
5. Otherwise, proceed with each workstream

### Step 2: Read Workstream Metadata
For each workstream:

1. **Read workstream entry from system1_workstreams.json:**
   - Extract:
     - id (workstream identifier)
     - purpose (one-line mission statement)
     - status (active, paused, etc.)
     - success_criteria

2. **Read system5_purpose.md (overall alignment):**
   - File: `Alignment/system5_purpose.md`
   - Extract overall purpose and strategic direction
   - Apply to all workstreams

3. **Scan for active work:**
   - Check Flow/actions/ for items with workstream = {workstream_id}
   - Count items by status: active, wip, blocked, approved
   - Extract 2-3 highest-priority active items

4. **Check for risks/constraints:**
   - Infer from current Flow/actions/ status
   - Note any items that are blocked or have dependencies

### Step 3: Organize by VSM Levels
Conceptually organize workstreams into VSM hierarchy (though this summary is flat):
- **System 1** (Operations): day-to-day execution, active workstreams from system1_workstreams.json
- **System 2** (Coordination): workstream interactions and dependencies inferred from Flow/actions/
- **System 3** (Management): strategy and resource allocation from system3_optimization.md
- **System 4** (Intelligence): scanning for improvements from system4_intelligence.md
- **System 5** (Policy): purpose and identity from system5_purpose.md

(This is conceptual; report may be flat or minimally hierarchical)

### Step 4: Compose Summary
Create markdown summary with sections:

```
# Alignment Overview

## {Workstream 1}
**Purpose:** {one-line purpose from system1_workstreams.json}

**Status:** {active, paused, etc.}

**Success Criteria:** {criteria}

**In Motion:**
- {active item 1} (status: {status})
- {active item 2} (status: {status})

**Constraints:** {critical constraints or dependencies, if any}

---

## {Workstream 2}
...

---

## Structural Coherence
- Total workstreams: {N}
- Active items: {M}
- Workstreams with open blocks: {K}
- System health: {healthy, degraded, or at risk}
```

### Step 5: Generate Insights
1. Check for:
   - Orphaned work items (Flow/actions/ with workstream not matching any entry in system1_workstreams.json)
   - Unused workstreams (entry exists in JSON but no active work)
   - Workstreams with all items blocked or deferred
   - Missing purpose statement (workstreams without documented purpose)

2. Add insights section to summary:
   ```
   ## Insights & Notes
   - {insight_1}
   - {insight_2}
   ...
   ```

### Step 6: Optional: Write to File
1. Write summary to:
   `System/reports/alignment-summary_{timestamp}.md`
2. Keep last 5 summaries; archive older ones
3. Update System/reports/alignment-index.yaml with reference

### Step 7: Report
1. Display summary to user (or in log)
2. Format: markdown, human-readable
3. No preamble; summary is the output

## Output Format
```
# Alignment Overview

## {Workstream 1}
Purpose: ...
Status: ...
In Motion: {list}
Constraints: {list}

## {Workstream 2}
...

Structural Coherence
- Workstreams: {N}
- Active items: {M}
- Health: {status}
```

## Error Handling
- **Alignment/system1_workstreams.json does not exist**: Create it and report "Alignment structure initialized"
- **Workstream entry missing purpose**: Warn "Workstream {id} has no purpose definition; edit system1_workstreams.json"
- **Flow/actions/ does not exist**: Treat as zero active items
- **Orphaned work items**: Log warning with list of items to reassign
- **Cyclic dependencies detected**: Warn "Workstreams may have circular dependencies"
