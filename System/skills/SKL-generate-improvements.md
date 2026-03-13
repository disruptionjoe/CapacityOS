---
type: SKL
status: active
root: System/skills
title: "Generate Improvements"
slug: generate-improvements
skill_id: generate-improvements
allowed_inputs: []
expected_outputs: ["improvement_proposals_created"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: "systems-engineer"
trigger_conditions: ["user_requests_improvement_scan", "periodic_improvement_sweep"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Technical trio (systems-engineer, software-engineer, designer) scans the system, identifies improvement opportunities, and creates up to 3 IMP (improvement) files in Flow/actions/ with status: proposed. Captures structural weaknesses, process gaps, and optimization opportunities.

## Trigger Conditions
- User explicitly requests "scan for improvements" or "generate ideas"
- Automatic weekly/monthly scan (optional)
- After significant change to System/ or Alignment/

## Procedure

### Step 1: Gather System Snapshot
1. **Read alignment summary:**
   - Call SKL-summarize-alignment to get current domain state
   - Capture: domains, active workstreams, constraints, health

2. **Audit Flow/ structure:**
   - Count items in Flow/actions/ by status
   - Identify bottlenecks (many blocked or review items)
   - Note age of oldest active items

3. **Check System/ metadata:**
   - Read System/logs/ for patterns (repeated errors, failures)
   - Scan System/ directory for incomplete or unlinked files

4. **Review improvement history:**
   - Check Flow/archive/ for recently completed improvements
   - Look for recurring themes or similar ideas

### Step 2: Invoke Technical Trio Scan
Three personas independently identify opportunities:

**Persona 1: Systems Engineer**
- Examines architectural coherence
- Looks for: VSM level imbalances, missing feedback loops, integration gaps
- Questions:
  - Are domains properly isolated? Are dependencies explicit?
  - Does the hierarchy support scaling? Can we add domains without rework?
  - Are meta-level systems (System 2-5) adequately supported?

**Persona 2: Software Engineer**
- Examines implementation and process efficiency
- Looks for: automation gaps, repetitive manual tasks, error-prone procedures
- Questions:
  - Which operations could be automated (PW checks, status transitions, archiving)?
  - Are skill implementations optimal? Any premature complexity?
  - What logs or metrics would help diagnose problems?

**Persona 3: Designer**
- Examines user experience and clarity
- Looks for: unclear naming, confusing workflows, cognitive overload
- Questions:
  - Is the dashboard intuitive? Can a new user understand status at a glance?
  - Are skill instructions clear? Any jargon or undefined terms?
  - Can workflows be simplified? Is anything unnecessarily hidden?

### Step 3: Synthesize Proposals
1. **Gather all persona suggestions** (10-20 ideas across trio)

2. **Cluster by theme:**
   - Group related ideas (e.g., "automation", "clarity", "resilience")

3. **Score by impact + feasibility:**
   - High impact + High feasibility → High priority
   - High impact + Medium feasibility → Medium priority
   - Anything else → Lower priority

4. **Select up to 3 proposals** (high priority first, balanced across personas)

### Step 4: Create IMP Files
For each selected proposal:

1. **Generate improvement details:**
   - **title**: Clear, actionable title (e.g., "Auto-archive completed items after 7 days")
   - **proposal**: Detailed description of improvement
   - **rationale**: Why this matters (performance, clarity, resilience, etc.)
   - **implementation_plan**: Numbered steps to execute
   - **effort_estimate**: Low / Medium / High
   - **alignment_domain**: null or specific domain if applicable
   - **affected_personas**: List of user types benefiting

2. **Create IMP file:**
   - File: `Flow/actions/IMP-{slug}.md`
   - YAML front-matter:
     ```yaml
     ---
     type: IMP
     status: proposed
     imp_id: {UUID}
     title: "{title}"
     slug: {slug}
     proposal: |
       {proposal}
     rationale: "{rationale}"
     implementation_plan: |
       1. {step_1}
       2. {step_2}
       ...
     effort_estimate: {Low | Medium | High}
     alignment_domain: {domain_name or null}
     affected_personas: [{persona_1}, {persona_2}]
     created_at: "{timestamp}"
     updated_at: "{timestamp}"
     ---
     ```

3. **Example improvement:**
   ```
   title: "Auto-archive completed items"
   proposal: "Automatically move items with status=done to archive after 7 days, reducing Flow/actions/ clutter"
   rationale: "Large Flow/actions/ directory reduces dashboard clarity; auto-archive keeps active work visible"
   implementation_plan: |
     1. Create scheduled task that runs daily
     2. Scan Flow/actions/ for status=done + updated_at > 7 days ago
     3. Run SKL-archive-item for each matching item
     4. Log summary
   effort_estimate: Low
   affected_personas: ["operator", "system-maintainer"]
   ```

### Step 5: Create Sweep Status File
1. Update or create `System/improvements/SYS-sweep-status.md`:
   ```yaml
   ---
   type: SYS
   status: active
   root: System/improvements
   title: "Improvement Sweep Status"
   ---

   Last scan: {current_timestamp}
   Proposals generated: {N}

   Proposed improvements:
   - IMP-{slug_1}: {title}
   - IMP-{slug_2}: {title}
   ...
   ```

2. Append summary to System/logs/generate-improvements.log:
   ```
   [timestamp] Improvement sweep complete
   Proposals: {N}
   High priority: {count}
   Personas: systems-engineer, software-engineer, designer
   ```

### Step 6: Report
```
Improvement Scan Complete

Proposals generated: {N} (up to 3)

{IMP-slug_1}: {title}
  Effort: {estimate}
  Benefit: {high, medium, low based on impact}
  Affected: {personas or domains}

{IMP-slug_2}: ...

Status: proposed (awaiting operator review)
Next: Review and approve improvement priorities
```

## Output Format
```
Improvements identified: {N}

- IMP-{slug_1}: {title} ({effort})
- IMP-{slug_2}: {title} ({effort})
- IMP-{slug_3}: {title} ({effort})

All in status: proposed
Ready for: operator review and prioritization
```

## Error Handling
- **Alignment/ or Flow/ structure incomplete**: Log warning and scan available structure
- **No clear opportunities found**: Report: "No high-priority improvements identified in current scan; system is healthy"
- **Persona feedback unavailable**: Use simplified duo or solo evaluation
- **IMP file creation fails**: Log error and skip that proposal
- **Sweep status file cannot be written**: Warn but continue; proposals created even if status not recorded
