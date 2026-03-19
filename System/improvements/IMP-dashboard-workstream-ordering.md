---
type: IMP
status: proposed
title: "Define workstream display ordering for the dashboard"
slug: dashboard-workstream-ordering
priority: low
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Proposal

**Designer concern:** With the old domain model, the dashboard had hardcoded sections ("Work", "Life Improvements"). With the new workstream model, the dashboard groups by workstream — but there's no defined ordering rule.

### Problem

If the dashboard renders workstreams alphabetically, the operator sees: Career Development, Disruption Joe, Finances, Health, Pure, Relationships. That's not priority-ordered — it's arbitrary. The operator has to scan the whole board to find what matters most.

### Options:

1. **Add a `priority` or `order` field to system1_workstreams.json** — Explicit ordering. Simple. Operator controls it.

2. **Order by CCF score** — Workstreams with Containment issues first, then Coherence, then Flow. Dynamic but computed.

3. **Order by active item count** — Workstreams with more active items appear first. Simple but may not reflect priority.

4. **Hybrid** — Show "Awaiting Decision" section first (CCF Containment), then workstreams ordered by explicit priority field.

### Recommendation

Option 4 (hybrid). Add an `order` field to system1_workstreams.json. The dashboard already pulls decisions to the top via CCF; workstream sections below that should follow the operator's declared priority.

### Schema change to system1_workstreams.json:

```json
{
  "id": "career-development",
  "purpose": "...",
  "status": "active",
  "success_criteria": "...",
  "order": 1
}
```

## Origin

Designer review of workstream migration — information hierarchy concern (2026-03-13).
