---
domain_id: capacityos
class: system-governance
status: active
template_version: v0.1
---

# Domain: CapacityOS

## System 5 - Identity and Boundaries

### Purpose
- statement: Define, govern, and improve CapacityOS as a reusable
  operating-system pattern that separates engine containment, domain coherence,
  and runtime flow while increasing determinism, modular scalability, and the
  velocity of real work.

### Scope
- includes:
  - engine-side architecture, templates, schemas, and operating rules
  - canonical system design decisions and migration-shaping choices
  - reusable patterns that should remain publishable in the public engine

### Non-Scope
- excludes:
  - private personal domains, goals, and operational canon
  - live queue state, candidate tasks, and current execution churn
  - ad hoc work that belongs inside subordinate domains or execution contexts
    rather than the system-governance layer itself

### Constraints and Enduring Principles
- constraints:
  - preserve the separation between containment, coherence, and flow
  - keep the engine publishable and reusable across users
  - keep private canon and runtime local and out of tracked engine history
  - prefer modular designs that compound over time
  - optimize for token-efficient determinism and real-world work velocity

### Enduring Commitments or Purpose Realization Opportunities (Optional)

#### [S5-1] Preserve Engine/Content Separation
- level: S5
- statement: keep the reusable engine distinct from private canon, private
  runtime, and subordinate domain content as CapacityOS evolves
- supports:
  - target_type: purpose
    target_ref: purpose
- evaluation_signals:
  - engine changes remain publishable
  - private domain evolution does not force engine ontology changes

##### Notes (Optional, non-authoritative)
- rationale: this boundary is identity-level for CapacityOS and should not be
  allowed to erode through convenience or drift

## Reusable Goal Shape

This domain uses one canonical reusable goal object across levels. `level`
changes how the engine should review and interpret the goal:
- `S4` goals express strategic direction
- `S1` goals express short-horizon operational intent
- `S5` goal-shaped commitments are optional and should remain rare

## System 4 - Strategic Direction

### Goals

#### [S4-1] Public Reusable Engine
- level: S4
- statement: make CapacityOS a publishable engine with reusable templates,
  schemas, skills, and operating structures that others can adopt without
  inheriting user-specific content
- supports:
  - target_type: goal
    target_ref: S5-1
- evaluation_signals:
  - engine updates remain safe to publish
  - templates and examples are reusable without private leakage
  - local private canon and runtime can evolve without forcing engine changes

#### [S4-2] Deterministic, Low-Token Operating Model
- level: S4
- statement: produce an operating model where agents can act with high
  confidence using compact structured context rather than reloading noisy
  history
- supports:
  - target_type: goal
    target_ref: S5-1
- evaluation_signals:
  - canon and runtime stay cleanly separated
  - queue formation and review behavior remain predictable
  - shorthand like caret notation speeds interaction without reducing safety

#### [S4-3] Faster Real-World Throughput
- level: S4
- statement: make the system increase the rate at which meaningful work is
  moved, reviewed, shipped, and learned from
- supports:
  - target_type: purpose
    target_ref: purpose
- evaluation_signals:
  - the default daily operating view reliably surfaces the highest-leverage
    human actions
  - more useful work happens between human checkpoints without losing coherence
  - system mistakes feed structured improvement rather than manual babysitting

## System 3 - Judgment and Prioritization

### Prioritization Policy
- prioritize_when:
  - work tightens a reusable contract or stable system boundary
  - a decision unblocks migration from draft architecture into live usage
  - a change improves determinism, modular scalability, or real-work throughput
- deprioritize_when:
  - a change only renames concepts without improving system behavior
  - a proposal adds coordination overhead without improving trust or clarity
- escalate_when:
  - a proposal risks blurring engine, canon, and runtime authority
  - durable mutation is being applied without explicit approval

### Pruning and Archival Policy
- archive_when:
  - an idea is purely speculative and no longer improves the near-term shape
  - a note duplicates a locked principle or decision already represented
- keep_active_when:
  - the item removes a migration blocker or improves an engine asset
  - the item increases confidence in a reusable system contract
- reject_when:
  - a proposal adds ontology weight without creating a real governance or
    execution advantage

### Tradeoffs and Risk Boundaries
- recurring_tradeoffs:
  - prefer a clean asymmetry over false symmetry between governable domains and
    the execution substrate
- risk_boundaries:
  - do not collapse private canon into the public engine for convenience
  - treat silent durable mutation of engine behavior as a stop condition

### Advancement Judgment
- advance_when:
  - the work materially reduces ambiguity, unlocks migration, or improves the
    daily operating leverage of the system
- defer_when:
  - the underlying boundary is still unstable
  - the output lacks a clear canonical home
- bundle_review_when:
  - the meaningful approval question is about the package as a whole rather
    than a single queue item
- mixed_origin_judgment:
  - allow mixed-origin backlog growth, but require endorsement state and strong
    surfacing discipline

## System 2 - Coordination and Ordering

### Coordination Policy
- grouping_rules:
  - group work by architecture hinge rather than arbitrary file adjacency
- sequencing_rules:
  - move from locked shape to real engine asset to real local canon to migration
    planning
  - prefer finishing one architecture hinge at a time rather than partially
    updating many layers at once
- dependency_rules:
  - keep the lock docs, template, and instantiated domain aligned before
    broader migration work begins
- handoff_rules:
  - downstream migration and bootstrap work should point back to locked engine
    assets rather than note drafts

### Queue and Flow Regulation
- queue_entry_flow:
  - judged-ready work should enter the trusted queue with a clear canonical
    home and explicit traceability back to the governing decision or template
- in_motion_adjustments:
  - active work may be regrouped or resequenced to reduce friction without
    changing the evaluative criteria in System 3
- queue_exit_or_pause_flow:
  - blocked or superseded work should pause or reroute explicitly rather than
    silently falling out of flow

### Feedback Regulation
- issue_routing:
  - system mistakes should usually create structured issues rather than
    immediate manual interruption
- correction_routing:
  - review corrections should feed the improvement backlog unless severity
    requires a hard stop
- surprise_routing:
  - weekly external insight review should create candidate improvements, not
    direct mutations

## System 1 - Execution Contract

System 1 in this domain pairs near-term operational intent with the rules that
define valid execution. The goals explain what current execution is trying to
move. The contract explains what counts as ready, valid, and done. Live work
state still belongs in runtime, not here.

### Goals

#### [S1-1] Pressure-Test a Second Real Domain
- level: S1
- statement: instantiate one additional real domain using the canonical domain
  shape so the model is tested outside the system-governance case
- supports:
  - target_type: goal
    target_ref: S4-1
- evaluation_signals:
  - a second real domain can use the same template without special pleading
  - cross-domain wording holds up outside the CapacityOS context

#### [S1-2] Write the Migration Plan
- level: S1
- statement: define how current material moves into engine, local canon,
  runtime, and archive without destructive cutover
- supports:
  - target_type: goal
    target_ref: S4-2
- evaluation_signals:
  - the migration path is explicit enough to execute incrementally
  - old project-centric material has a clear translation path into domain-based
    canon and runtime

#### [S1-3] Define the Day-1 Bootstrap
- level: S1
- statement: make a new CapacityOS installation operational quickly through a
  bounded starter suite of engine-driven automations and rhythms
- supports:
  - target_type: goal
    target_ref: S4-3
- evaluation_signals:
  - the bootstrap setup is clearly defined
  - the starter automations are useful without being noisy or overwhelming

### Execution Units
- unit_types:
  - architecture decisions
  - canonical templates and schemas
  - local canon domain records
  - decision-record collections
  - bootstrap automation definitions
  - migration bundles and plans

### Readiness Contract
- ready_when:
  - the affected boundary or design question is explicitly named
  - the governing architecture basis is available
  - the proposed output has a clear canonical home
- required_inputs:
  - the relevant locked principle, decision, or template exists
  - the target artifact or target schema is known
- blocked_when:
  - required human approval threshold is unknown before mutation would be
    applied

### Output Types
- output_types:
  - locked architecture docs
  - reusable templates
  - local canonical domain files
  - local decision-record collections
  - automation/setup definitions
  - migration guidance

### Completion Contract
- done_when:
  - the durable artifact is updated, internally consistent, and aligned with
    the locked architecture
- useful_partial_progress_when:
  - a major ambiguity is removed
  - a reusable contract is promoted out of notes and into the engine
  - a migration blocker is isolated clearly enough for direct follow-up work

### Human-Charge Touchpoints
- requires_human_for:
  - approving durable mutations to engine logic or canonical architecture
  - approving queue promotion for high-consequence work packages
  - approving publication or rollout of externally consequential changes

## Key Decisions

#### [DEC-1] Domain-Centric Coherence
- current_effect: domains are the primary coherence/governance objects;
  projects and repos are subordinate execution contexts
- consequence_for_domain:
  - queue, review, and stewardship logic resolve against domains
- decision_ref:
  - decision_id: domain-centric-coherence
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/examples/decisions/capacityos-system-governance-decisions.example.md

#### [DEC-2] Reserved System-Governance Domain
- current_effect: CapacityOS includes a reserved system-governance domain,
  while the engine/runtime substrate remains outside the domain ontology
- consequence_for_domain:
  - this domain uses the domain shape without collapsing the substrate/domain
    boundary
- decision_ref:
  - decision_id: reserved-system-governance-domain
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/examples/decisions/capacityos-system-governance-decisions.example.md

#### [DEC-3] Engine Owns Cadence
- current_effect: review cadence and review initiation are engine-owned rather
  than domain-authored
- consequence_for_domain:
  - the domain stores meaning and review outcomes, but not schedule policy
- decision_ref:
  - decision_id: engine-owns-cadence
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/examples/decisions/capacityos-system-governance-decisions.example.md

#### [DEC-4] System 1 as Execution Contract
- current_effect: System 1 in domain canon is an execution contract, not a
  live execution surface
- consequence_for_domain:
  - live queue and in-progress state remain outside this file in runtime
- decision_ref:
  - decision_id: system-1-execution-contract
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/examples/decisions/capacityos-system-governance-decisions.example.md

#### [DEC-5] Default Intake Fast-Path Rule
- current_effect: `^que` is the default intake path; `^now` is explicit
  fast-path handling, not an authority override
- consequence_for_domain:
  - immediate handling still respects approval and safety boundaries
- decision_ref:
  - decision_id: default-intake-fast-path-rule
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/examples/decisions/capacityos-system-governance-decisions.example.md

## Optional Extensions

### Domain-Specific Frameworks (Optional Extension)
- framework_name: containment / coherence / flow
- applies_to: System 3
- interpretation: use this as the primary boundary test for deciding where a
  concept belongs
- bounded_effects:
  - prioritization, pruning, and risk-boundary interpretation
- exceptions_or_weights:
  - if a proposal weakens the engine/canon/runtime split, it should face a
    higher burden of proof
