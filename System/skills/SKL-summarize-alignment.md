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
Generate a VSM (Viable System Model) hierarchy overview across all alignment domains. Scan all domain directories, extract purpose, strategy, and active workstreams, and produce a compact summary that shows structural coherence.

## Trigger Conditions
- User explicitly requests "show alignment" or "alignment summary"
- Periodic review (e.g., weekly)
- After domain creation or modification

## Procedure

### Step 1: Discover Domains
1. Scan `Alignment/` directory
2. List all subdirectories (excluding `_domain-template/`)
3. Each subfolder represents one alignment domain
4. If no domains found, report: "No alignment domains configured; see Alignment/_domain-template/"
5. Otherwise, proceed with each domain

### Step 2: Read Domain Metadata
For each domain:

1. **Read system5_purpose.md:**
   - File: `Alignment/{domain_name}/system5_purpose.md`
   - Extract YAML front-matter:
     - domain_name
     - purpose (one-line mission statement)
     - strategy (strategic direction)
   - If file missing, log warning and skip domain

2. **Read strategy files (if present):**
   - Check for `Alignment/{domain_name}/strategy/` subdirectory
   - List any files that describe approach or methodology
   - Extract key strategic points (max 1-2 sentences per file)

3. **Scan for active work:**
   - Check Flow/actions/ for items with alignment_domain = {domain_name}
   - Count items by status: active, wip, blocked, approved
   - Extract 2-3 highest-priority active workstreams

4. **Check for risks/constraints:**
   - Look for files in `Alignment/{domain_name}/` named *constraint*, *risk*, *assumption*
   - Note any critical constraints

### Step 3: Organize by VSM Levels
Conceptually organize domains into VSM hierarchy (though this summary is flat):
- **System 1** (Operations): day-to-day execution, active workstreams
- **System 2** (Coordination): domain interactions and dependencies
- **System 3** (Management): strategy and resource allocation
- **System 4** (Intelligence): scanning for improvements
- **System 5** (Policy): purpose and identity

(This is conceptual; report may be flat or minimally hierarchical)

### Step 4: Compose Summary
Create markdown summary with sections:

```
# Alignment Overview

## {Domain 1}
**Purpose:** {one-line purpose from system5_purpose.md}

**Strategy:** {strategy summary, 1-2 sentences}

**In Motion:**
- {active workstream 1} (status: {status})
- {active workstream 2} (status: {status})

**Constraints:** {critical constraints or dependencies, if any}

---

## {Domain 2}
...

---

## Structural Coherence
- Total domains: {N}
- Active workstreams: {M}
- Domains with open blocks: {K}
- System health: {healthy, degraded, or at risk}
```

### Step 5: Generate Insights
1. Check for:
   - Orphaned work items (Flow/actions/ with alignment_domain not matching any domain folder)
   - Unused domains (directory exists but no active work)
   - Domains with all items blocked or deferred
   - Missing strategy files (domains without documented strategy)

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

## {Domain 1}
Purpose: ...
Strategy: ...
In Motion: {list}
Constraints: {list}

## {Domain 2}
...

Structural Coherence
- Domains: {N}
- Active workstreams: {M}
- Health: {status}
```

## Error Handling
- **Alignment/ does not exist**: Create it and report "Alignment structure initialized"
- **Domain folder missing system5_purpose.md**: Warn "Domain {domain} has no purpose definition; see Alignment/_domain-template/"
- **Flow/actions/ does not exist**: Treat as zero workstreams
- **Orphaned work items**: Log warning with list of items to reassign
- **Cyclic dependencies detected**: Warn "Domains may have circular dependencies"
