---
type: IMP
status: proposed
title: "Update plugin skills (dashboard, triage, capture, router) for workstream model"
slug: update-plugin-skills-workstream-model
priority: high
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Proposal

The four plugin skills (capacityos-dashboard, capacityos-triage, capacityos-capture, capacityos-router) are installed as read-only plugins and still reference the old domain-based model. They need to be updated via the skill-creator to use the new workstream-based model.

### Changes needed:

**capacityos-dashboard:**
- Replace "grouped by life domain" → "grouped by workstream"
- Read `Alignment/system1_workstreams.json` instead of scanning domain folders
- Extract `workstream` field from ACT files instead of `alignment_domain`
- Group board sections by workstream ID (title-cased), not domain
- Remove "No domains configured" edge case → "No workstreams configured"

**capacityos-triage:**
- Infer `workstream` from `system1_workstreams.json` instead of scanning `Alignment/` subfolders
- Set `workstream` field instead of `alignment_domain` on created ACT files
- Update error handling: "Unassigned" instead of "General" for unmatched items

**capacityos-capture:**
- Replace `alignment_domain: null` → `workstream: null` in IBX template

**capacityos-router:**
- Remove "new domain", "create domain" from routing table
- Update Three-Layer Model description of Alignment
- Update Alignment description to flat structure with VSM files
- Update context loading tiers to include system1_workstreams.json

### Implementation

Use the skill-creator skill to rebuild and republish the plugin with updated SKILL.md files.

## Origin

Structural migration from domain-based to workstream-based Alignment model (2026-03-13).
