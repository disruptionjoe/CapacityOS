---
type: IMP
status: proposed
title: "Add display_name field to workstreams for clearer dashboard labels"
slug: workstream-naming-clarity
priority: low
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Proposal

**Designer concern:** Workstream IDs are slugified ("career-development", "disruption-joe") which works for machine references but requires title-casing on the dashboard. Some IDs don't title-case cleanly — "disruption-joe" becomes "Disruption Joe" (the operator's brand name, fine) but future IDs might not be as clean.

### Proposed solution

Add an optional `display_name` field to system1_workstreams.json:

```json
{
  "id": "career-development",
  "display_name": "Career Development",
  "purpose": "...",
  "status": "active",
  "success_criteria": "..."
}
```

Rules:
- Dashboard uses `display_name` if present, otherwise title-cases `id`
- `display_name` is optional — only needed when title-casing would be wrong
- Keep it short (2-3 words max) for dashboard readability

### Impact

Gives the operator control over how their board reads without polluting the machine-readable ID. Low effort, high clarity.

## Origin

Designer review of workstream migration — naming is interface design (2026-03-13).
