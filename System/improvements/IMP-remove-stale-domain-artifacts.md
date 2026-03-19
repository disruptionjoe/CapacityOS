---
type: IMP
status: proposed
title: "Remove stale domain artifacts (SKL-create-domain, TPL-alignment-domain, agent references)"
slug: remove-stale-domain-artifacts
priority: medium
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Proposal

**Software Engineer concern:** Several files are now dead code — they describe domain-based operations that no longer exist. Keeping them increases context size and creates ambiguity for agents that might load them.

### Artifacts to remove or repurpose:

1. **System/skills/SKL-create-domain.md** — Already updated to describe workstream creation, but the filename still says "domain". Either rename to `SKL-create-workstream.md` (update all references) or delete and fold the functionality into documentation.

2. **System/templates/TPL-alignment-domain.md** — Template for creating domain folders. No longer needed. Delete.

3. **System/agents/AGT-systems-engineer.md** — References "alignment domains" in stable_state list (line 55). Update to "workstreams".

4. **System/skills/SYS-skill-index.md** — Verify the "create-domain" entry was updated to "create-workstream" or removed.

5. **IBX files in Flow/inbox/** — Check if any migrated IBX files carry stale `alignment_domain` fields that should be `workstream`.

### Token impact

Removing TPL-alignment-domain.md and cleaning SKL-create-domain.md saves ~200 tokens of stale context per agent session that loads these files.

## Origin

Software Engineer review of workstream migration — dead code cleanup (2026-03-13).
