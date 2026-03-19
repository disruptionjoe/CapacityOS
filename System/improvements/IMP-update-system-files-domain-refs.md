---
type: IMP
status: proposed
title: "Update remaining System files that still reference domains"
slug: update-system-files-domain-refs
priority: high
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Proposal

Seven System files still reference the old domain model and need updating:

### Files to update:

1. **System/routing/SYS-routing-rules.md** — Remove "create domain" route, update references to workstream routing
2. **System/schemas/SYS-schema-enums-registry.md** — Replace `alignment_domain` enum/field with `workstream`; update valid values to match workstream IDs from system1_workstreams.json
3. **System/schemas/SYS-file-type-registry.md** — Update ACT/IBX schema definitions to use `workstream` field
4. **System/governance/SYS-validation-policy.md** — Update validation checks that reference alignment_domain to reference workstream
5. **System/governance/SYS-operating-principles.md** — Update any domain-based principles to workstream-based
6. **System/templates/TPL-act.md** — Update ACT template frontmatter: `alignment_domain` → `workstream`
7. **System/templates/TPL-alignment-domain.md** — Delete (no longer needed; domains don't exist)

### Implementation

Read each file, perform surgical find-and-replace of domain terminology, verify consistency with the new model.

## Origin

Structural migration from domain-based to workstream-based Alignment model (2026-03-13).
