# Domain Template

Use this file shape for durable domain canon.

This file is the durable orientation and governance surface for a domain. Its
job is to give the system a stable canonical contract for what the domain is,
why it exists, what matters inside it, and how work in it should be judged over
time.

It is not a runtime dashboard, routing table, cadence schedule, or orchestration
object. It should not hold live backlog state, queue order, in-progress work,
recent run logs, or engine-owned cadence logic.

Use minimal YAML front matter only for small, stable, machine-critical fields.
Keep interpretation, reasoning, and governance content in the Markdown body.
Optimize the file for system function first; human auditability is secondary.

## Usage Notes

- Keep this file concise and high-trust.
- Use one file per domain as the main canonical contract for system handling.
- Let the engine own cadence, generic review skills, notation support, and
  automation behavior.
- Let runtime own live work state.
- Treat `class` as an engine-defined handling profile, not free-form metadata.
- Keep YAML front matter minimal and stable.
- If a field invites long lists, frequent edits, or interpretation debates, it
  likely does not belong in the header.
- Put narrative reasoning, VSM content, and execution-contract prose in the
  Markdown body.
- Favor structures that improve determinism, parseability, and routing over
  structures that merely read nicely to humans.

## Body Rules

- Authoritative sections should use explicit, repeatable field patterns.
- Explanatory content should live only in clearly labeled note sections.
- Notes should never override canonical fields.
- If the system must interpret it reliably, it should not be hidden inside
  loose prose.

## Reference Grammar

### Goal Identifier Contract

- the bracketed token in each goal heading is the canonical goal identifier for
  intra-domain references
- allowed canonical goal id shapes:
  - `S5-<id>` for System 5 commitments
  - `S4-<id>` for System 4 goals
  - `S1-<id>` for System 1 goals
- the heading id and the `level` field must agree

### `supports` Contract

- `supports` is a list of typed support references
- allowed `target_type` values:
  - `purpose`
  - `goal`
  - `maintenance`
- `target_ref` rules:
  - if `target_type: purpose`, `target_ref` must be the literal token
    `purpose`
  - if `target_type: goal`, `target_ref` must exactly match another declared
    goal id in the same domain
  - if `target_type: maintenance`, `target_ref` must be the literal token
    `maintenance`
- allowed source-to-target pairings:
  - `S5` goals may support `purpose` only
  - `S4` goals may support `purpose` or an `S5` goal
  - `S1` goals may support an `S4` goal or `maintenance`
- same-level goal-to-goal support is not part of the base grammar
- cross-domain goal references are not part of the base grammar

### `decision_ref` Contract

- `decision_ref` is a structured provenance reference, not a free-form link
- required fields:
  - `decision_id`
  - `source_ref`
- `decision_id` must be a stable kebab-case identifier
- `source_ref` must point to the authoritative decision record or decision
  record collection
- canonical use is valid only if `decision_id` resolves within `source_ref`
- broad document-level references without a `decision_id` are invalid for
  canonical use
- line-number-only references are invalid for canonical use

## Canonical Shape

```md
---
domain_id: [stable-id]
class: [default | system-governance | other engine-defined class]
status: [active | latent]
template_version: [v0.1]
---

# Domain: [Domain Name]

## System 5 - Identity and Boundaries

These are separate canonical slots. Do not collapse them into one blended
identity block, because each slot carries different semantics the system should
be able to interpret directly.

### Purpose
- statement: [Why this domain exists and what it is meant to protect, create,
  or make true over time]

### Scope
- includes:
  - [What belongs in this domain]
  - [What else belongs in this domain]

### Non-Scope
- excludes:
  - [What does not belong in this domain]
  - [Where adjacent work should go instead, if helpful]

### Constraints and Enduring Principles
- constraints:
  - [Long-lived constraint or principle]
  - [Long-lived constraint or principle]

### Enduring Commitments or Purpose Realization Opportunities (Optional)

Use sparingly. System 5 should remain purpose-and-boundaries first. Only add
goal-shaped items here when they represent rare long-horizon commitments tightly
coupled to the identity of the domain.

#### [S5-1] [Name]
- level: S5
- statement: [What must remain true over the long horizon]
- supports:
  - target_type: purpose
    target_ref: purpose
- evaluation_signals:
  - [Canonical signal used in review/evaluation]

##### Notes (Optional, non-authoritative)
- rationale: [Why this is identity-level rather than merely strategic]
- risks_or_open_questions:
  - [Optional bounded note]

### Notes (Optional, non-authoritative)
- [Optional explanation or context]

## Reusable Goal Shape

This is the canonical reusable goal object wherever goals appear in this
domain. The object shape is shared across levels, but `level` is semantically
operative: it changes horizon, review posture, mutability expectations, and how
the engine evaluates the goal.

The canonical minimum should stay narrow. If meaning cannot be reliably
recovered from the fields below, the shape is still too soft.

```md
#### [Goal-ID] [Goal Name]
- level: [S4 | S1 | optional S5]
- statement: [Canonical goal statement]
- supports:
  - target_type: [purpose | goal | maintenance]
    target_ref: [must follow the `supports` reference grammar above]
- evaluation_signals:
  - [Canonical signal used in review/evaluation]
  - [Canonical signal used in review/evaluation]

##### Notes (Optional, non-authoritative)
- rationale: [Optional explanation]
- risks_or_open_questions:
  - [Optional bounded note]
```

## System 4 - Strategic Direction

### Goals

Use goal-shaped items here for longer-horizon strategic direction. These are
slower-moving than System 1 operational goals.

#### [S4-1] [Name]
- level: S4
- statement: [Longer-term strategic direction or outcome]
- supports:
  - target_type: [purpose | goal]
    target_ref: [purpose | S5 goal id]
- evaluation_signals:
  - [Canonical signal used in review/evaluation]
  - [Canonical signal used in review/evaluation]

##### Notes (Optional, non-authoritative)
- rationale: [Optional explanation]
- risks_or_open_questions:
  - [Optional bounded note]

#### [S4-2] [Name]
- level: S4
- statement: [...]
- supports:
  - target_type: [purpose | goal]
    target_ref: [...]
- evaluation_signals:
  - [...]

### Notes (Optional, non-authoritative)
- [Optional explanation or context]

## System 3 - Judgment and Prioritization

System 3 is the evaluative control layer. It should govern worthiness, priority,
pruning, readiness judgment, and risk/control boundaries. It should not drift
into flow-coordination mechanics.

### Prioritization Policy
- prioritize_when:
  - [What should make work feel high leverage in this domain]
  - [How urgency, risk, dependency, or opportunity should be weighed here]
- deprioritize_when:
  - [What should lower priority]
- escalate_when:
  - [What should trigger a stop condition or escalation]

### Pruning and Archival Policy
- archive_when:
  - [What should be archived instead of kept active]
- keep_active_when:
  - [What justifies keeping an item active]
- reject_when:
  - [What makes an item too weak, redundant, or off-domain]

### Tradeoffs and Risk Boundaries
- recurring_tradeoffs:
  - [Important tradeoff this domain repeatedly faces]
- risk_boundaries:
  - [What should be treated as a stop condition or escalation signal]

### Advancement Judgment
- advance_when:
  - [What makes work worthy, ready, or safe enough to move forward]
- defer_when:
  - [What means work should wait rather than advance]
- bundle_review_when:
  - [When judgment should happen at the package or bundle level]
- mixed_origin_judgment:
  - [How mixed-origin work should be judged for legitimacy and trust]

### Notes (Optional, non-authoritative)
- [Optional explanation or context]

## System 2 - Coordination and Ordering

System 2 is the coordination and flow-regulation layer. It should govern how
already-judged work stays coherent in motion through sequencing, handoffs,
queue-entry flow, and feedback regulation. It should not become a second home
for evaluative priority or readiness logic.

### Coordination Policy
- grouping_rules:
  - [How work should be grouped]
- sequencing_rules:
  - [How work should be sequenced]
- dependency_rules:
  - [How dependencies should be handled]
- handoff_rules:
  - [How handoffs should be handled]

### Queue and Flow Regulation
- queue_entry_flow:
  - [How already-judged-ready work should enter the trusted queue]
- in_motion_adjustments:
  - [How active work may be reorganized without redefining evaluative policy]
- queue_exit_or_pause_flow:
  - [How work leaves, pauses, or gets rerouted once in flow]

### Feedback Regulation
- issue_routing:
  - [How issues should feed back into this domain]
- correction_routing:
  - [How corrections should move through the flow and back into governance]
- surprise_routing:
  - [How unexpected signals should be folded back into the domain]

### Notes (Optional, non-authoritative)
- [Optional explanation or context]

## System 1 - Execution Contract

System 1 is the execution-facing layer. It should contain both:

- operational goals, which express what near-term execution is trying to
  achieve
- execution contract, which defines what valid execution looks like in this
  domain

These belong in the same layer, but they are not the same kind of thing.
Operational goals orient execution. The execution contract bounds execution.
Operational goals may change more often than the execution contract, but
runtime still owns live queue state, in-progress work, and execution activity.

### Goals

Use goal-shaped items here for short-horizon operational intent. These should
orient near-term execution and logically push progress toward System 4 goals or
explicitly represent maintenance.

#### [S1-1] [Name]
- level: S1
- statement: [What near-term operational progress this goal is trying to
  create]
- supports:
  - target_type: [goal | maintenance]
    target_ref: [S4 goal id | maintenance]
- evaluation_signals:
  - [Canonical sign of useful near-term progress]
  - [Canonical sign of useful near-term progress]

##### Notes (Optional, non-authoritative)
- rationale: [Optional explanation]
- risks_or_open_questions:
  - [Optional bounded note]

#### [S1-2] [Name]
- level: S1
- statement: [...]
- supports:
  - target_type: [goal | maintenance]
    target_ref: [...]
- evaluation_signals:
  - [...]

This section defines what execution is supposed to look like in this domain.
It should not contain live queue items or in-progress state.

### Execution Units
- unit_types:
  - [What types of execution units exist in this domain]
  - [Examples: task, bundle, artifact, review package, release candidate]

### Readiness Contract
- ready_when:
  - [What must be true before work is ready for active execution]
- required_inputs:
  - [What information or links must be present]
- blocked_when:
  - [What should prevent active execution]

### Output Types
- output_types:
  - [What kinds of outputs matter in this domain]
  - [Examples: docs, shipped assets, decisions, code changes, reports]

### Completion Contract
- done_when:
  - [What counts as done]
- useful_partial_progress_when:
  - [What counts as meaningful partial progress]

### Human-Charge Touchpoints
- requires_human_for:
  - [Which parts of execution typically require human judgment, approval, or
    real-world action]

### Notes (Optional, non-authoritative)
- [Optional explanation or context]

## Key Decisions

List only compact summaries of the decisions that materially shape current
interpretation. Keep the full rationale, alternatives, and history in separate
decision objects. Decision references are the primary durable provenance
mechanism in this file.

#### [DEC-1] [Decision Name]
- current_effect: [What is true now in this domain because of this decision]
- consequence_for_domain:
  - [How this shapes interpretation, judgment, or execution in the domain]
- decision_ref:
  - decision_id: [stable-kebab-case id]
  - source_ref: [absolute path or canonical ref to the authoritative decision
    record set]

#### [DEC-2] [Decision Name]
- current_effect: [...]
- consequence_for_domain:
  - [...]
- decision_ref:
  - decision_id: [...]
  - source_ref: [...]

## Optional Extensions

Use only when the base shape is insufficient.

### Domain-Specific Frameworks (Optional Extension)
- framework_name: [framework id or short name]
- applies_to: [System 5 | System 4 | System 3 | System 2 | System 1]
- interpretation: [How the domain uses it]
- bounded_effects:
  - [What this framework is allowed to influence]
- exceptions_or_weights:
  - [Optional exception, weighting, or special rule]

### Domain-Specific Notes
- [Optional section]
```

## Keep Out of This File

- live backlog contents
- queue ordering
- candidate-task lists
- in-progress execution state
- recent run logs
- engine cadence rules
- generic review instructions
- automation schedules
- large narrative sections in YAML front matter
- explanatory notes mixed into authoritative fields without clear labeling
