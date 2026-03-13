---
type: SYS
status: active
root: System/schemas
title: "File Type Registry"
slug: file-type-registry
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

# File Type Registry

Consolidated reference for all file types, their storage locations, lifecycle states, naming conventions, and permissions.

---

## Type Reference Table

| Type | Full Name | Primary Folder | Status Enum | Naming Pattern | Creator | Mutator | Notes |
|------|-----------|----------------|-------------|----------------|---------|---------|-------|
| **IBX** | Intake | `Flow/intake` | `new`, `triage` | `IBX-{slug}.md` | Any | Any | Unstructured raw input; minimal validation |
| **ACT** | Actions/Tasks | `Flow/actions` | `new`, `active`, `review`, `approved`, `blocked`, `done`, `deferred`, `declined` | `ACT-{slug}.md` | Human, Agent, Skill | Authorized actor only | Core execution unit; requires authority chain |
| **IMP** | Improvements | `System/improvements` | `proposed`, `queued`, `executing`, `done`, `reviewed`, `rejected`, `deferred` | `IMP-{slug}.md` | Human, Agent | Approved actor only | System-wide optimization proposals |
| **SYS** | System | `System/governance`, `System/schemas`, `System/templates`, `System/scripts`, `System/routing` | `active`, `review` | `SYS-{slug}.md` | Governance only | Governance only | Policy, governance, immutable once active |
| **SKL** | Skills | `System/skills` | `active`, `review` | `SKL-{slug}.md` | System designer | Skill author | Reusable capability definitions |
| **AGT** | Agents | `System/agents` | `active`, `review` | `AGT-{slug}.md` | System designer | Agent author | Autonomous actor definitions |

---

## Folder Structure and Type Locations

```
Flow/
  intake/             → IBX files (raw input)
  inbox/              → (IBX files processed to inbox, tracked separately)
  actions/            → ACT files (current work)
  archive/            → IBX, ACT, IMP files (immutable)

Alignment/
  [domain-1]/         → Alignment-specific files (lightweight validation)
  [domain-2]/
  ...

System/
  schemas/            → SYS files (schema definitions)
  governance/         → SYS files (policy, principles)
  templates/          → SYS files (reusable templates)
  scripts/            → SYS files (executable scripts)
  routing/            → SYS files (routing rules)
  skills/             → SKL files (capabilities)
  agents/             → AGT files (autonomous actors)
  improvements/       → IMP files (optimization proposals)
```

---

## Creation Permissions

| Type | Who Can Create | Notes |
|------|----------------|-------|
| IBX | Any actor (humans, agents, systems) | No approval required; minimal validation |
| ACT | Humans, agents, skills | Approval required if `requires_approval=true` |
| IMP | Humans, agents | Proposals subject to trio assessment |
| SYS | Governance team only | Requires consensus for system changes |
| SKL | System designer only | After technical validation |
| AGT | System designer only | After behavioral safety review |

---

## Mutation Permissions

| Type | Who Can Mutate | Status Transitions Allowed | Notes |
|------|----------------|----------------------------|-------|
| IBX | Any actor | `new` ↔ `triage` | Lightweight, reversible |
| ACT | Authorized actor (see authority chain) | Per lifecycle track | Simple or approval-required track |
| IMP | Approved actor | Per IMP lifecycle | Trio assessment gates execution |
| SYS | Governance team only | `active` ↔ `review` only | No deletion; governance immutable |
| SKL | Skill author + governance approval | `active` ↔ `review` only | Canon mutations require special approval |
| AGT | Agent author + governance approval | `active` ↔ `review` only | Behavioral changes reviewed for safety |

---

## Immutability Rules

| Type | Immutable After | Exception | Notes |
|------|-----------------|-----------|-------|
| IBX | Moved to archive | None | Archived IBX is permanent record |
| ACT | Moved to archive | Emergency revocation rare | Archived ACT is permanent record |
| IMP | Status = `done` and moved to archive | None | Completion is final |
| SYS | Status = `active` and in `/governance/` | Manual governance override | Policy changes require new SYS file |
| SKL | Status = `active` | Canon mutation approval | Active skills are stable |
| AGT | Status = `active` | Behavioral override | Active agents are stable |

---

## Validation Model

### Standard Validation (IBX, ACT, IMP, SYS, SKL, AGT)

**Pre-write validation checklist:**
- Filename matches pattern `{TYPE}-{slug}.md`
- Filename prefix matches YAML type
- Filename slug matches YAML slug
- File folder matches YAML root
- All global required fields present
- All type-specific required fields present
- Status value in type's enum
- All enum fields contain valid closed-enum values
- Slug format: lowercase-kebab-case
- Date format: YYYY-MM-DD

**Post-write validation:**
- Authority chain valid (ACTs with `authority_type=approval-granted` must have `authority_ref`)
- File not in archive (archived files are immutable)

### Lightweight Validation (Alignment Domain Files)

**Pre-write:**
- Valid domain folder (`Alignment/[domain]/`)
- Expected filename format
- Required YAML fields present

**Post-write:**
- No triple-redundancy enforcement
- Lighter schema requirements

---

## Archival Process

Files move to `Flow/archive/` when:
- ACT reaches `status: done` and is no longer active
- IBX is processed and can be retired
- IMP is `status: done` and documented
- Any file exceeds retention policy

**Archival naming:** Files in archive retain their original names but are marked immutable.

**Archival validation:** Archived files cannot change status, content, or metadata.

---

## Type Relationships and Dependencies

```
IBX (Intake)
  ↓ (processing)
Flow/inbox (structured)
  ↓ (assignment)
ACT (Action/Task)
  ├─→ status: approved (requires authority)
  └─→ Executes via SKL or AGT
      ↓
IMP (Improvement discovered during execution)
  ↓ (if approved)
ACT (New action created from improvement)
  ↓ (completion)
Flow/archive (immutable record)

SYS (governance/policy)
  ← Informs all other types
  ← Defines validation rules
  ← Immutable policy foundation

SKL (Skills)
  ← Called by ACT with task_kind=execute-skill
  ← Scoped by SYS rules

AGT (Agents)
  ← Can create IBX, ACT, IMP
  ← Scoped by SYS rules
  ← Authorized by ACT authority chain
```

---

## Naming Convention Reference

### Pattern Rules

- **Format:** `{TYPE}-{slug}.md`
- **Types:** IBX, ACT, IMP, SYS, SKL, AGT
- **Slug:** lowercase-kebab-case
- **Length:** Keep under 60 characters total

### Valid Examples

- `IBX-weekly-standup-notes.md`
- `ACT-draft-proposal-v2.md`
- `IMP-reduce-context-overhead.md`
- `SYS-validation-policy.md`
- `SKL-process-email-intake.md`
- `AGT-systems-engineer.md`

### Invalid Examples

- `Weekly_Notes.md` (no type prefix)
- `act-draft.md` (lowercase type)
- `ACT_draft_proposal.md` (underscores, not hyphens)
- `ACT-Draft Proposal.md` (spaces, mixed case)
- `ACT-.md` (missing slug)

---

## Query and Retrieval

### By Type
```
Find all SKL files: System/skills/SKL-*.md
Find all active ACTs: Flow/actions/ACT-*.md with status=active
```

### By Status
```
Find all ACTs needing review: Flow/actions/ACT-*.md with status=review
Find all completed IMPs: System/improvements/IMP-*.md with status=done
```

### By Domain (Alignment)
```
Find all alignment files for domain: Alignment/[domain]/*
```

### By Authority
```
Find ACTs requiring approval: All ACT files with requires_approval=true
Find ACTs with specific authority: All ACT files with authority_ref=[ref]
```

---

## Capacity Limits (Soft Guidelines)

| Category | Soft Limit | Hard Limit | Notes |
|----------|-----------|-----------|-------|
| Active ACTs | 3 in "In Motion" status | 10 total active | Keep focus; hard limit triggers triage |
| Open IBX files | 15 | 50 | Over 50 triggers intake emergency |
| Pending APPROVALs | 5 | 20 | Over 20 requires review and archival |
| Active SKLs | 20 | 50 | Over 50 requires SKL consolidation |
| Active AGTs | 10 | 20 | Over 20 requires agent consolidation |

---

## Change Log

| Date | Change | Reason |
|------|--------|--------|
| 2026-03-13 | Schema 1.0 created | Initial system foundation |
