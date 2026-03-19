---
updated_at: "2026-03-13"
---

# System 3: Optimization & Resource Allocation

How the system allocates time, energy, and attention across workstreams using CCF principles.

## CCF scoring logic

- **Containment (highest priority):** Unresolved decisions, uncontained risks, things needing boundaries. Items with `requires_approval: true` and `status: review` score highest. Without containment, nothing else holds.
- **Coherence (medium priority):** Are active items across workstreams working together or pulling apart? Approved but blocked items surface here. Scattered effort dilutes impact.
- **Flow (execution priority):** What can move right now? Items with `status: active` or `status: wip`. When containment and coherence are in place, execution builds a better life.

## Health signals

- **Green:** Active workstreams have items moving, inbox stays under 5 items, no decisions pending more than 3 days.
- **Yellow:** 1-2 workstreams stalled, inbox growing, decisions pending 3-7 days.
- **Red:** Multiple workstreams stalled, inbox overflowing, decisions ignored for 7+ days.

## Review cadence

- **Daily:** Dashboard check — what needs a decision? What can move?
- **Weekly:** Review all workstreams — are they still the right ones? Any status changes needed?
- **Monthly:** Step back — is the system serving its purpose? Any structural improvements needed?
