---
type: "IMP"
title: "Remove General section from dashboard"
status: "done"
priority: "low"
domain: "system"
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Problem

The dashboard's "General" section catches items with `alignment_domain=null`. In practice, every item should be assigned to a domain during normalization. The General section adds visual clutter and suggests the system tolerates unclassified items.

## Proposed Change

Remove the `── General ──` section from SKL-surface-dashboard.md. Update the error handling to route unclassified items to the inbox for triage instead of displaying them on the dashboard.

## Tech Trio Review

### Systems Engineer
The General section is a fallback for incomplete normalization. Removing it is fine IF the normalize process guarantees domain assignment. Add a validation check: any item without a domain gets routed to `Flow/inbox/` for triage rather than silently appearing on the dashboard. This preserves containment.

### Software Engineer
Clean change. Remove lines 78-79 from the dashboard template. Update error handling (line 123) to say "place item in Flow/inbox/ for triage" instead of "place item in General." Low risk, no dependencies.

### Designer
Good UX call. The General bucket trains users to accept unclassified work. Removing it reinforces the mental model that everything belongs somewhere. The inbox becomes the natural catch-all instead of polluting the dashboard.

## Decision

Approved — remove the General section.
