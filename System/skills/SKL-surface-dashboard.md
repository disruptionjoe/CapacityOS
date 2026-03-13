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
Render the primary operator dashboard — a real-time, ranked view of all active work items grouped by alignment domain, with trust metrics and decision entry points. This is the most critical operator interface.

## Trigger Conditions
- Operator session startup
- User explicitly requests "show dashboard" or "board"
- Automatic refresh (optional: every 30 minutes during active session)

## Procedure

### Phase 1: Gather System State

1. **Read alignment metadata**
   - If `System/scripts/indexes/alignment-index.json` exists, load it (cached domain list)
   - Otherwise, scan `Alignment/*/system5_purpose.md` files to extract domain names and purpose statements
   - Count discovered domains

2. **Read operations metadata**
   - If `System/scripts/indexes/ops-index.json` exists, load it
   - Otherwise, scan `Flow/actions/` directory and read all `.md` files with status ≠ done, declined, rejected
   - Extract: slug, title, status, priority, alignment_domain, requires_approval

3. **Count inbox items**
   - List all files in `Flow/inbox/` with status:new or status:triage
   - Count by alignment_domain if available

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

```
Board: {trust_level} | {total_item_count} items across {domain_count} domains

Start here → {CCF_directive}

── Awaiting Your Decision ──
  {list of requires_approval=true items with status=review, format: [D{N}] [ACT-{slug}](Flow/actions/ACT-{slug}.md) (review) — {title}}

── {Domain Name} ──
  In Motion: [P{N}] [ACT-{slug}](Flow/actions/ACT-{slug}.md) ({status}) — {title}
  Next: [P{N}] [ACT-{slug}](Flow/actions/ACT-{slug}.md) ({status}) — {title}
  On Deck: [P{N}] [ACT-{slug}](Flow/actions/ACT-{slug}.md) (proposed) — {title}

{repeat for each domain}

── System ──
  {items with type=IMP, format: [S{N}] [IMP-{slug}](System/improvements/IMP-{slug}.md) ({status}) — {title}}

── Coaching ──
Containment Coach: {1-2 sentence coaching message about structure and stabilization — are there unresolved decisions, uncontained risks, or things that need boundaries before anything else can move? Containment is the first priority because without it, nothing else holds.}

Coherence Coach: {1-2 sentence coaching message about alignment — are the active items across domains working toward a unified direction, or are they pulling in different directions? Coherence is the second priority because scattered effort dilutes impact.}

Flow Coach: {1-2 sentence coaching message about execution — given what's contained and coherent, what can move forward right now? Flow is the third priority because when containment and coherence are in place, execution becomes a better life instead of many disjointed things.}

── Calendar (optional) ──
{if any items have due_date, list next 3 upcoming due_dates with item titles}
```

4. **Quick-action shorthand** (footer)
   - `A1 done` → mark item A1 as done
   - `A2 wip` → mark item A2 as wip
   - `D1 approve` → approve decision D1
   - `D2 decline` → decline decision D2
   - `S1 approve` → approve system change S1
   - etc.

5. **Edge case: No domains configured**
   - If domain_count = 0, render:
   ```
   No domains configured yet — say 'help me get started' or see Alignment/_domain-template/
   ```
   Then stop.

6. **No preamble, no postamble** — the board IS the greeting. Output only the formatted board.

## Output Format
```
Board: {TRUST_LEVEL} | {ITEM_COUNT} items across {DOMAIN_COUNT} domains

Start here → {CCF_DIRECTIVE}

{domain sections as specified above}

── Coaching ──
Containment Coach: {contextual advice}
Coherence Coach: {contextual advice}
Flow Coach: {contextual advice}
```

## Coaching Guidelines
The three coaches each give 1-2 sentences of contextual advice based on the current board state. They are not generic — they reference specific items and situations.

- **Containment Coach** — focuses on structure and stabilization. Are there decisions that need to be made before anything else can move? Risks that need boundaries? Things falling through the cracks? Containment is the FIRST priority because without it, nothing else holds.
- **Coherence Coach** — focuses on alignment. Are the active items across domains working toward a unified direction, or pulling apart? Is there a way to connect two workstreams so they reinforce each other? Coherence is the SECOND priority because scattered effort dilutes impact.
- **Flow Coach** — focuses on execution. Given what's contained and coherent, what can actually move right now? What's the smallest next step? Flow is the THIRD priority because when containment and coherence are in place, execution builds a better life instead of many disjointed things.

## Error Handling
- If `Alignment/` directory does not exist: treat as no domains configured
- If `Flow/actions/` or `Flow/inbox/` does not exist: treat as zero items
- If any item file is unreadable: skip it and log to System/logs/ (do not block render)
- If alignment_domain references a non-existent domain: route item to Flow/inbox/ for triage
