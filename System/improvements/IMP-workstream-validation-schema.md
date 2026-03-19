---
type: IMP
status: proposed
title: "Add workstream field validation against system1_workstreams.json"
slug: workstream-validation-schema
priority: medium
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Proposal

**Systems Engineer concern:** The `workstream` field on ACT and IBX files should be validated against the canonical list in `Alignment/system1_workstreams.json`. Currently there's no validation gate ensuring that a workstream value actually exists in the JSON.

### Problem

An agent could set `workstream: "carer-development"` (typo) and it would pass all current checks. The dashboard would then show this item in an orphaned section.

### Proposed solution

Add a pre-write validation check (PW-14 or extend PW-07):
- When writing an ACT or IBX file with a non-null `workstream` value
- Read `Alignment/system1_workstreams.json`
- Verify the workstream ID exists in the `workstreams[].id` array
- If not found: halt write, suggest correction (fuzzy match against valid IDs)

### Implementation

1. Add rule to `SYS-validation-policy.md`
2. Update `SYS-schema-enums-registry.md` to define workstream as a dynamic enum (sourced from JSON, not hardcoded)
3. Update `AGT-validator.md` evaluation criteria

## Origin

Systems Engineer review of workstream migration (2026-03-13).
