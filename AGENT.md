# CapacityOS — Agent Operating Manual

CapacityOS is a skill-based personal operating system organized into three nested layers: System, Flow, and Alignment. It helps an operator think clearly about what matters and what to do next by processing action items through a governed pipeline and grounding them in durable life/work domains.

This file is the agent's primary operating manual. It should be loaded at the start of every session.

---

## 1. Three-Layer Model

```
CapacityOS/
├── System/    → The operating system (skills, agents, schemas, governance, scripts)
├── Flow/      → The processing pipeline (intake → inbox → actions → archive)
└── Alignment/ → The life map (one folder per domain, organized by VSM - Stafford Beer's Viable Systems Model)
```

**System** is the reusable logic. It changes rarely and requires governed mutation.
**Flow** is the ephemeral pipeline. Items move through it and get archived.
**Alignment** is durable state. It represents the major areas of the operator's life or work and changes slowly.

---

## 2. Skill-First Behavior Rules

These rules are non-negotiable:

1. **Always check the skill-index before improvising.** Read `System/skills/SYS-skill-index.md` (or `System/scripts/indexes/skill-routing-index.json` for compact lookup). If a skill exists for the task, use it.
2. **If no skill applies, propose creating one.** Create an ACT with `requires_approval: true` describing the new skill needed. Do not silently invent a workflow.
3. **Never silently bypass a skill that matches.** Even if the agent "knows" how to do something, the skill definition is the authority. Follow it.
4. **Ask the human if the correct skill is unclear.** When multiple skills could apply, or none clearly fits, ask — don't guess.

---

## 3. Boot Sequence

On every new session:

1. Read this file (AGENT.md)
2. Check if `Alignment/` has any domain folders (subdirectories besides `_domain-template`)
   - **If no domains exist:** Invoke `SKL-onboard-new-user` — this is the first-run guided setup
   - **If domains exist:** Invoke `SKL-surface-dashboard` — render the board immediately
3. The board IS the greeting. No preamble, no "how can I help you today." Just the board.

---

## 4. Context Loading Tiers

To manage token efficiency, load context in layers:

| Tier | When loaded | What |
|------|-------------|------|
| **Always** | Every session | This file (AGENT.md) |
| **On greeting** | Session start | `SKL-surface-dashboard` procedure, `alignment-index.json`, `ops-index.json` |
| **On task** | When executing a skill | The relevant `SKL-*.md` file + `SYS-schema-enums-registry.md` (for validation) |
| **On demand** | When specifically needed | Individual Alignment domain files, agent persona files, archive manifests |
| **Never auto-load** | Only if explicitly requested | Archive file contents, completed pipeline items, full governance docs |

Prefer indexes (`System/scripts/indexes/*.json`) over scanning directories. Indexes are compact and designed for agent consumption. Fall back to directory scanning only if indexes are stale or missing.

---

## 5. File Types

Six types, each with a mandatory naming pattern `{TYPE}-{slug}.md`:

| Type | Location | Purpose | Status Enum |
|------|----------|---------|-------------|
| IBX | `Flow/inbox/` | Normalized intake item | new, triage |
| ACT | `Flow/actions/` | Action item (task or proposal) | new, active, review, approved, blocked, done, deferred, declined |
| IMP | `Flow/actions/` | System improvement | proposed, queued, executing, done, reviewed, rejected, deferred |
| SYS | `System/{subfolder}/` | System document | active, review |
| SKL | `System/skills/` | Skill definition | active, review |
| AGT | `System/agents/` | Agent persona | active, review |

**ACT has two tracks:**
- **Simple** (requires_approval=false): `new → active → done`
- **Approval** (requires_approval=true): `new → review → approved → active → done`

---

## 6. Pipeline

All operational work flows through a single linear pipeline:

```
Flow/intake → Flow/inbox → Flow/actions → Flow/archive
     ↓              ↓             ↓              ↓
  raw dump     structured     active work    cold storage
               IBX files      ACT/IMP files   (immutable)
```

Key rules:
- **Normalization is a hard boundary.** Nothing enters Flow/inbox/ without being structured as an IBX file.
- **No file moves within the pipeline** (except intake→inbox and actions→archive). Items stay in `Flow/actions/` throughout their lifecycle. The dashboard filters by YAML fields, not folder location.
- **Archive is immutable.** Once archived, a file is never modified.

---

## 7. Alignment Domains

Each subdirectory of `Alignment/` (except `_domain-template`) is a domain — a major area of the operator's life or work.

Each domain contains files organized by Stafford Beer's **Viable System Model (VSM)**:

| File | VSM System | What it captures |
|------|-----------|------------------|
| `system5_purpose.md` | S5 — Identity | Why this domain exists, what success looks like |
| `system4_strategy.md` | S4 — Intelligence | Strategic direction, bets, hypotheses |
| `system3_optimization.md` | S3 — Control | Metrics, cadences, health signals |
| `system2_coordination.md` | S2 — Coordination | Interfaces with other domains, agreements |
| `system1_workstreams.md` | S1 — Operations | Active workstreams, current focus |
| `system_rules.md` _(optional)_ | — | Domain-specific operating rules for the agent |

The numbering goes S5→S1 because the model works from abstract (identity, purpose) to concrete (active workstreams). You always define purpose first — everything else flows from it.

**The `alignment_domain` field** on ACT and IMP files links flow items to domains. The dashboard groups items by domain automatically.

**Alignment files are exempt from triple-redundancy.** They are validated by: valid domain folder, expected filename, required YAML fields.

---

## 8. Path Conventions

All internal path references must be **relative to `CapacityOS/`** as root.

Correct: `System/skills/SKL-surface-dashboard.md`
Correct: `Flow/actions/ACT-deploy-website.md`
Correct: `Alignment/Career/system5_purpose.md`

Incorrect: `/meta/SKL-surface-dashboard.md` (flat-path assumption)
Incorrect: `/sessions/.../CapacityOS/...` (absolute VM path)
Incorrect: `../Joe Second Brain/...` (leaks outside CapacityOS)

---

## 9. Triple-Redundancy

Every pipeline and system file encodes its identity three ways:

1. **Filename prefix** matches YAML `type`
2. **Filename slug** matches YAML `slug`
3. **Folder location** matches YAML `root`

All three must agree. If any check fails → route to `SKL-repair-file`. Never silently fix.

### Universal Prefix Rule

**ALL files use their three-letter type prefix in their filename** (e.g., `SKL-`, `AGT-`, `SYS-`, `TPL-`, `ACT-`, `IBX-`, `IMP-`). This is intentionally redundant with both the folder structure and the YAML `type` field. The redundancy improves agent determinism: an agent can identify a file's type from any single signal — filename, folder, or YAML — without needing to load or parse context.

**Exceptions:** `AGENT.md` and `README.md` (root-level convention files). Alignment domain files use VSM numbering (`system5_purpose.md`, etc.) because they are user-authored state, exempt from triple-redundancy.

---

## 10. Core Principles

1. **Intake is unstructured; Inbox is structured; System is governed; Archive is immutable.**
2. **Three-way validation** — filename prefix, YAML type, and folder location must all agree.
3. **Universal prefix naming** — ALL files carry their three-letter type prefix (e.g., `SYS-`, `SKL-`, `ACT-`). Redundancy with folder structure and YAML is intentional — it improves agent determinism.
4. **No silent repair** — invalid files get explicit repair tasks, never quiet fixes.
5. **Containment before flow** — if the operator is overloaded, reduce pressure; don't increase output.
6. **LLM minimalism** — use code for deterministic work (arithmetic, formatting, validation).
7. **Agent determinism over human readability** — when they conflict, determinism wins.
8. **The board IS the greeting** — no preamble, just render the actionable state.
9. **Keep "In Motion" to 3 items** — more than that triggers paralysis.
10. **Prefer action over planning** when both are available.
11. **Reduce friction to act** — the system should make starting easy, not impressive.

---

## 11. Agent Personas

| Agent | Purpose | File |
|-------|---------|------|
| Chief of Staff | Routing, coordination, synthesis | `System/agents/AGT-chief-of-staff.md` |
| Validator | Schema enforcement, file integrity | `System/agents/AGT-validator.md` |
| Triage | Intake classification and routing | `System/agents/AGT-triage.md` |
| Systems Engineer | Context structure, state durability | `System/agents/AGT-systems-engineer.md` |
| Software Engineer | Schema quality, determinism, token efficiency | `System/agents/AGT-software-engineer.md` |
| Designer | Operator experience, cognitive load, trust | `System/agents/AGT-designer.md` |

Load agent persona files on demand — not on every session.

---

## 12. Validation

Full validation policy: `System/governance/SYS-validation-policy.md`

Quick reference — pre-write checks (PW-01 through PW-13) must all pass before any file is written. The validator agent (`AGT-validator`) runs these checks. If any check fails, the write is halted and routed to repair.

---

## 13. Quick Reference: Skill Routing

| Operator says... | Skill |
|------------------|-------|
| (greeting, "what's next", opens session) | `surface-dashboard` |
| Quick-action shorthand (A1 done, D2 approve) | `surface-dashboard` |
| "create a task", "I need to..." | `create-act` |
| "approve/decline/defer" on a pending item | `resolve-approval` |
| "set up a new domain" | `create-domain` |
| (first session, no domains) | `onboard-new-user` |
| "triage inbox", "what's new" | `triage-ibx` |
| "archive this" | `archive-item` |
| "system health", "improvements" | `generate-improvements` |

Full routing rules: `System/routing/SYS-routing-rules.md`
Full skill registry: `System/skills/SYS-skill-index.md`
