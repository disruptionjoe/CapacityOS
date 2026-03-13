---
type: SYS
status: active
root: System/schemas
title: "Schema and Enums Registry"
slug: schema-enums-registry
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

# Schema and Enums Registry

Canonical definition of all schemas, enums, and required fields across the CapacityOS system.

## Global Required Fields

All pipeline and system files must include these fields in their YAML front-matter:

| Field | Type | Enum | Required | Notes |
|-------|------|------|----------|-------|
| `type` | string | [IBX, ACT, IMP, SYS, SKL, AGT] | Yes | File classification |
| `status` | string | Type-specific (see below) | Yes | Lifecycle state |
| `root` | string | [Flow/intake, Flow/inbox, Flow/actions, Flow/archive, Alignment, System/skills, System/agents, System/schemas, System/governance, System/templates, System/scripts, System/routing, System/improvements] | Yes | Folder classification |
| `title` | string | N/A | Yes | Human-readable title |
| `slug` | string | Lowercase-kebab-case | Yes | URL-safe identifier |
| `created_at` | string | YYYY-MM-DD | Yes | Creation date |
| `updated_at` | string | YYYY-MM-DD | Yes | Last modification date |

---

## Type-Specific Schemas

### IBX (Intake)

**Status enum:** `new`, `triage`

**Required fields (beyond global):**
- None (minimal structure for raw input)

**Optional fields:**
- source (string): origin system or channel
- raw_format (string): original content format

**Notes:** IBX files are unstructured and represent raw information before processing.

---

### ACT (Actions/Tasks)

**Status enum:** `new`, `active`, `review`, `approved`, `blocked`, `done`, `deferred`, `declined`

**Required core fields:**
- `action_description` (string): what is being done
- `done_condition` (string): success criteria
- `alignment_domain` (string, optional): which domain/project this serves
- `requires_approval` (boolean): whether approval is required before execution

**Optional routing fields:**
- `task_kind` (closed enum): [create-file, update-file, execute-skill, triage, multi-step, other]
- `authority_type` (closed enum): [direct-human, approval-granted, routine-maintenance, skill-execution]
- `authority_ref` (string): reference to authority source (required if authority_type=approval-granted)
- `skill_ref` (string): reference to skill being executed (if task_kind=execute-skill)
- `target_type` (string): what type of object is being modified
- `target_root` (string): folder path to target
- `origin_type` (string): IBX, ACT, AGT, or SKL
- `origin_ref` (string): specific reference to originating object

**Lifecycle tracks:**

**Simple track** (requires_approval=false):
```
new → active → done
```

**Approval track** (requires_approval=true):
```
new → review → approved → active → done
```

**Escape statuses** (approval track only):
- `blocked`: temporary obstruction
- `deferred`: postponed indefinitely
- `declined`: rejected after review

---

### IMP (Improvements)

**Status enum:** `proposed`, `queued`, `executing`, `done`, `reviewed`, `rejected`, `deferred`

**Required fields:**
- `improvement_description` (string): what is being improved
- `category` (closed enum): [context-management, token-efficiency, determinism, best-practices, schema, skill, agent, documentation, structure, validation]
- `scope` (closed enum): [system, alignment, flow, cross-layer]
- `priority` (integer): 1 (critical), 2 (standard), 3 (nice-to-have)
- `expected_benefit` (string): what value this creates
- `implementation_plan` (string): how to implement
- `files_affected` (array of strings): which files will change

**Optional fields:**
- `proposed_by` (string): who suggested this
- `trio_assessment` (string): evaluation by technical trio
- `completion_review` (string): post-completion assessment

---

### SYS (System)

**Status enum:** `active`, `review`

**Required fields (beyond global):**
- None (system files are self-contained policy)

**Notes:** SYS files define governance, policy, and operating principles. They are immutable once active.

---

### SKL (Skills)

**Status enum:** `active`, `review`

**Required fields:**
- `skill_id` (string): unique identifier
- `allowed_inputs` (array): valid input types
- `expected_outputs` (array): output specification
- `target_types` (array): what can be modified by this skill

**Optional fields:**
- `canon_mutation_allowed` (boolean, default false): whether this skill can modify system files
- `approval_required` (boolean, default false): whether execution requires approval
- `agt_ref` (string): agent that implements this skill
- `trigger_conditions` (array): when this skill is invoked
- `eval_criteria` (array): how to assess if skill executed successfully

---

### AGT (Agents)

**Status enum:** `active`, `review`

**Required fields:**
- `agent_id` (string): unique identifier
- `persona` (string): role/perspective this agent takes
- `scope` (string): what domain this agent operates in
- `delegation_allowed` (boolean): whether this agent can delegate to other agents

---

## Triple-Redundancy Rule

**Applies to:** IBX, ACT, IMP, SYS, SKL, AGT

All three of the following must match exactly:

1. **Filename prefix** must match YAML `type` field
   - Example: `ACT-draft-proposal.md` has prefix `ACT`
   - YAML must contain `type: ACT`

2. **Filename slug** must match YAML `slug` field
   - Example: filename `ACT-draft-proposal.md` has slug `draft-proposal`
   - YAML must contain `slug: draft-proposal`

3. **File folder** must match YAML `root` field
   - Example: file at `Flow/actions/ACT-draft-proposal.md`
   - YAML must contain `root: Flow/actions`

**Mismatch detection:** Any mismatch halts processing → classify discrepancy → route to repair task → record incident.

**Alignment domain files exemption:** Alignment domain files (typically in `Alignment/[domain]/` folders) are exempt from triple-redundancy and use lighter validation (see Validation Policy).

---

## Enum Reference

### Closed Enums (exhaustive list, no other values valid)

| Enum Name | Valid Values |
|-----------|--------------|
| type | IBX, ACT, IMP, SYS, SKL, AGT |
| root | Flow/intake, Flow/inbox, Flow/actions, Flow/archive, Alignment, System/skills, System/agents, System/schemas, System/governance, System/templates, System/scripts, System/routing, System/improvements |
| task_kind | create-file, update-file, execute-skill, triage, multi-step, other |
| authority_type | direct-human, approval-granted, routine-maintenance, skill-execution |
| category (IMP) | context-management, token-efficiency, determinism, best-practices, schema, skill, agent, documentation, structure, validation |
| scope (IMP) | system, alignment, flow, cross-layer |

### Type-Specific Status Enums

| Type | Valid Status Values |
|------|-------------------|
| IBX | new, triage |
| ACT | new, active, review, approved, blocked, done, deferred, declined |
| IMP | proposed, queued, executing, done, reviewed, rejected, deferred |
| SYS | active, review |
| SKL | active, review |
| AGT | active, review |

---

## Date and Time Format

- **Date format:** `YYYY-MM-DD` (ISO 8601)
- **Timestamp format:** `YYYY-MM-DDTHH:MM:SSZ` (ISO 8601, UTC)

---

## Slug Format Rules

- Lowercase letters and numbers only
- Hyphens as word separators (kebab-case)
- No underscores, spaces, or special characters
- Example: `draft-proposal`, `monthly-review-jan-2026`, `context-limits`

---

## Authority Chain Validation

**Rule:** ACT files with `authority_type: approval-granted` MUST have a valid `authority_ref`.

The `authority_ref` must point to a valid source:
- Another ACT with `status: approved`
- An AGT delegation
- A SYS governance document
- A SKL authorization

Orphaned authority references halt processing.

---

## Schema Versioning

This schema is version 1.0 (2026-03-13). Breaking changes require:
1. New schema version document
2. Migration plan for existing files
3. SYS governance approval
4. Transition period with both versions active
