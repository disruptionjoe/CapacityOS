---
type: SKL
status: active
root: System/skills
title: "Surface Dashboard"
slug: surface-dashboard
skill_id: surface-dashboard
allowed_inputs: []
expected_outputs: ["dashboard_board"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["user_requests_dashboard", "operator_session_start"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Render the primary operator dashboard — a real-time, ranked view of all active work items grouped by workstream, with trust metrics and decision entry points. This is the most critical operator interface.

## Trigger Conditions
- Operator session startup
- User explicitly requests "show dashboard" or "board"
- Automatic refresh (optional: every 30 minutes during active session)

## Procedure

### Phase 1: Gather System State

1. **Read alignment metadata**
   - If `Alignment/system1_workstreams.json` exists, load it (cached workstream list)
   - Otherwise, read `Alignment/system1_workstreams.json` to extract workstreams and purpose statements
   - Count discovered workstreams

2. **Read operations metadata**
   - If `System/scripts/indexes/ops-index.json` exists, load it
   - Otherwise, scan `Flow/actions/` directory and read all `.md` files with status ≠ done, declined, rejected
   - Extract: slug, title, status, priority, workstream, requires_approval

3. **Count inbox items**
   - List all files in `Flow/inbox/` with status:new or status:triage
   - Count by workstream if available

4. **Read sweep status** (optional)
   - If `System/improvements/SYS-sweep-status.md` exists, extract: last_scan_timestamp, improvement_count_proposed, system_health_rating

5. **Compute trust level**
   - If any items have `requires_approval=true` and `status=review`, trust_level = "REVIEW PENDING"
   - Else if improvement_count_proposed > 0, trust_level = "IMPROVEMENTS QUEUED"
   - Else if all active items have status in [active, wip], trust_level = "FLOWING"
   - Else trust_level = "REVIEW NEEDED"

### Phase 2: Rank by CCF

For each item in Flow/actions/ with status ≠ done|declined|rejected:
- **Containment** (C): requires_approval=true AND status=review → High priority
- **Coherence** (C): status=approved AND next action is blocked → Medium priority
- **Flow** (F): status=active OR status=wip → Low priority (already in motion)

### Phase 3: Render Board

Use proper markdown headings and bullet points for clear visual hierarchy. Each item gets an **action verb** so the operator knows what to DO with it: "Decide", "Do", "Review", "Plan".

Action verb rules:
- `requires_approval=true` AND `status=review` → **Decide**
- `status=active` or `status=wip` → **Do**
- `status=review` (non-approval) → **Review**
- `status=new` or `status=open` → **Do** (default)
- `status=proposed` → **Review**
- `status=deferred` → **Plan**
- IMP files → **Review**

Each item is a bullet with a clickable Obsidian link to the file.

```markdown
**Start here →** {CCF_directive — one sentence, what to do right now}

### Awaiting Your Decision
- [D1] **Decide:** [ACT-{slug}](Flow/actions/ACT-{slug}.md) — {title}
- [D2] **Decide:** [ACT-{slug}](Flow/actions/ACT-{slug}.md) — {title}

### Work
*In Motion:*
- [W1] **Do:** [ACT-{slug}](Flow/actions/ACT-{slug}.md) — {title}
- [W2] **Do:** [ACT-{slug}](Flow/actions/ACT-{slug}.md) — {title}

*Next:*
- [W3] **Do:** [ACT-{slug}](Flow/actions/ACT-{slug}.md) — {title}

### Life Improvements
*In Motion:*
- [L1] **Do:** [ACT-{slug}](Flow/actions/ACT-{slug}.md) — {title}

### System
- [S1] **Review:** [IMP-{slug}](System/improvements/IMP-{slug}.md) — {title}

### Coaching
**Containment:** {1-2 sentence coaching about structure and stabilization — unresolved decisions, uncontained risks, things needing boundaries. Containment is FIRST because without it, nothing else holds.}

**Coherence:** {1-2 sentence coaching about alignment — are active items across domains working together or pulling apart? Coherence is SECOND because scattered effort dilutes impact.}

**Flow:** {1-2 sentence coaching about execution — what can move right now? What's the smallest next step? Flow is THIRD because when containment and coherence are in place, execution builds a better life.}

### Calendar (optional)
{if any items have due_date, list next 3 upcoming}
```

Key formatting rules:
- **No summary line before "Start here"** — "Start here" IS the top of the board, nothing above it
- Section headings use `###` markdown headings
- Items are bulleted with `- [ID] **Verb:** [linked filename](path) — title`
- Action verbs are bolded so they pop visually
- Sub-sections within a domain (In Motion, Next, On Deck) use italic labels
- Links use Obsidian-compatible relative paths

4. **Quick-action shorthand** (footer)
   - `A1 done` → mark item A1 as done
   - `A2 wip` → mark item A2 as wip
   - `D1 approve` → approve decision D1
   - `D2 decline` → decline decision D2
   - `S1 approve` → approve system change S1
   - etc.

5. **Edge case: No workstreams configured**
   - If workstream_count = 0, render:
   ```
   No workstreams configured yet — say 'help me get started' or edit Alignment/system1_workstreams.json
   ```
   Then stop.

6. **No preamble, no postamble** — the board IS the greeting. Output only the formatted board.

## Output Format
```markdown
**Start here →** {CCF_DIRECTIVE}

### Awaiting Your Decision
- [D1] **Decide:** [ACT-{slug}](path) — {title}

### {Workstream Name}
*In Motion:*
- [W1] **Do:** [ACT-{slug}](path) — {title}

### Coaching
**Containment:** {contextual advice}
**Coherence:** {contextual advice}
**Flow:** {contextual advice}
```

## Coaching Guidelines
The three coaches each give 1-2 sentences of contextual advice based on the current board state. They are not generic — they reference specific items and situations.

- **Containment Coach** — focuses on structure and stabilization. Are there decisions that need to be made before anything else can move? Risks that need boundaries? Things falling through the cracks? Containment is the FIRST priority because without it, nothing else holds.
- **Coherence Coach** — focuses on alignment. Are the active items across domains working toward a unified direction, or pulling apart? Is there a way to connect two workstreams so they reinforce each other? Coherence is the SECOND priority because scattered effort dilutes impact.
- **Flow Coach** — focuses on execution. Given what's contained and coherent, what can actually move right now? What's the smallest next step? Flow is the THIRD priority because when containment and coherence are in place, execution builds a better life instead of many disjointed things.

## Error Handling
- If `Alignment/system1_workstreams.json` does not exist: treat as no workstreams configured
- If `Flow/actions/` or `Flow/inbox/` does not exist: treat as zero items
- If any item file is unreadable: skip it and log to System/logs/ (do not block render)
- If workstream field references a non-existent workstream: route item to Flow/inbox/ for triage
