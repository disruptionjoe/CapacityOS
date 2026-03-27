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
  - ad hoc project work that belongs inside subordinate domains or execution
    contexts rather than the engine design itself

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
- statement: make CapacityOS a publishable engine with reusable templates, schemas,
  skills, and operating structures that others can adopt without inheriting
  Joe-specific content
- supports:
  - target_type: goal
    target_ref: S5-1
- evaluation_signals:
  - engine updates remain safe to publish
  - example packs/templates are reusable without private leakage
  - local private canon and runtime can evolve without forcing engine changes

##### Notes (Optional, non-authoritative)
- rationale: this is the core engine-versus-content boundary that makes
  CapacityOS generalizable instead of merely personal infrastructure
- risks_or_open_questions:
  - engine logic may accidentally absorb domain-specific content
  - example material may drift too close to live private material

#### [S4-2] Deterministic, Low-Token Operating Model
- level: S4
- statement: produce an operating model where agents can act with high confidence
  using compact structured context rather than reloading noisy history
- supports:
  - target_type: goal
    target_ref: S5-1
- evaluation_signals:
  - canon and runtime stay cleanly separated
  - queue formation and review behavior remain predictable
  - shorthand like caret notation speeds interaction without reducing safety

##### Notes (Optional, non-authoritative)
- rationale: CapacityOS only scales if it stays legible, auditable, and cheap
  enough to run routinely
- risks_or_open_questions:
  - runtime noise could leak back into canon
  - too many special cases could weaken determinism

#### [S4-3] Faster Real-World Throughput
- level: S4
- statement: make the system increase the rate at which meaningful work is moved,
  reviewed, shipped, and learned from
- supports:
  - target_type: purpose
    target_ref: purpose
- evaluation_signals:
  - the default daily operating view reliably surfaces the highest-leverage
    human actions
  - more useful work happens between human checkpoints without losing coherence
  - system mistakes feed structured improvement rather than manual babysitting

##### Notes (Optional, non-authoritative)
- rationale: the system should create completed work, not just organized
  possibility
- risks_or_open_questions:
  - backlog growth could outpace surfacing quality
  - review surfaces could become noisy or fragmented

## System 3 - Judgment and Prioritization

System 3 is the evaluative control layer for this domain.

### Prioritization Policy
- prioritize_when:
  - decisions clarify boundaries between engine, canon, and runtime
  - work unlocks broad migration progress across the rest of the system
  - structures are reusable rather than one-off local accommodations
  - the option reduces token load and ambiguity for future agent work
- deprioritize_when:
  - a change mainly renames concepts without improving system behavior
  - a proposal adds coordination overhead without improving determinism
- escalate_when:
  - a proposal risks blurring engine, canon, and runtime authority
  - durable mutation is being applied without explicit approval

### Pruning and Archival Policy
- archive_when:
  - ideas merely rename concepts without improving boundary clarity
  - a structure duplicates engine behavior inside domains
- keep_active_when:
  - the item removes a migration blocker or tightens a core boundary
  - the item improves a reusable contract or stable operating surface
- reject_when:
  - a proposal adds ontology weight without creating a real review,
    governance, or execution advantage

### Tradeoffs and Risk Boundaries
- recurring_tradeoffs:
  - prefer a clean asymmetry over false symmetry between governable domains and
    the execution substrate
- risk_boundaries:
  - do not collapse private canon into the public engine for the sake of
    convenience
  - treat silent durable mutation of engine behavior as a stop condition

### Advancement Judgment
- advance_when:
  - items materially reduce ambiguity, unlock migration, or improve daily
    operating leverage
- defer_when:
  - the underlying boundary decision is still unstable
  - the output lacks a clear canonical home
- bundle_review_when:
  - the meaningful approval question is about the package as a whole rather
    than a single task
- mixed_origin_judgment:
  - allow mixed-origin backlog growth, but require endorsement state and strong
    surfacing discipline

## System 2 - Coordination and Ordering

System 2 is the coordination and flow-regulation layer for this domain.

### Coordination Policy
- grouping_rules:
  - group work by architecture hinge rather than by arbitrary file adjacency
- sequencing_rules:
  - move from boundary decisions to templates/schema to locked docs to
    migration planning
  - prefer finishing one architecture hinge at a time rather than partially
    updating many layers at once
- dependency_rules:
  - keep the synthesis doc ahead of the architecture rewrite so the lock docs
    are updated from a stable source of truth
- handoff_rules:
  - downstream doc rewrites should point back to locked synthesis decisions

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

#### [S1-1] Lock the Domain-Based Architecture
- level: S1
- statement: finalize the shift from project-centric modeling to domain-centric
  coherence with a reusable canonical domain shape
- supports:
  - target_type: goal
    target_ref: S4-1
- evaluation_signals:
  - the domain template and example are stable enough to guide migration
  - architecture docs consistently describe domains as the primary coherence
    object

##### Notes (Optional, non-authoritative)
- rationale: this is the near-term step that makes the broader reusable engine
  strategy actionable
- risks_or_open_questions:
  - the canonical domain shape could still blur engine and domain
    responsibilities

#### [S1-2] Rewrite the Phase 1 Lock Docs
- level: S1
- statement: update the locked architecture docs so the written system matches the
  decisions already captured in the synthesis
- supports:
  - target_type: goal
    target_ref: S4-2
- evaluation_signals:
  - the main lock docs stop using the older project-centric framing
  - core loop, checkpoint, and mutation policies are explicit in the docs

##### Notes (Optional, non-authoritative)
- rationale: migration should rely on stable written architecture, not just
  conversational history
- risks_or_open_questions:
  - stale lock docs could reintroduce older assumptions during migration

#### [S1-3] Define the Day-1 Operating Bootstrap
- level: S1
- statement: make a new CapacityOS installation operational quickly through a
  small starter suite of engine-driven automations and rhythms
- supports:
  - target_type: goal
    target_ref: S4-3
- evaluation_signals:
  - the bootstrap prompt/setup is clearly defined
  - the starter automations are bounded, useful, and non-overwhelming

##### Notes (Optional, non-authoritative)
- rationale: the system should create usable operating leverage from day one
- risks_or_open_questions:
  - too many default automations could create noise before trust is earned

### Execution Units
- unit_types:
  - architecture decisions
  - canonical templates and schemas
  - locked design docs
  - example domain artifacts
  - automation/bootstrap definitions
  - migration bundles

### Readiness Contract
- ready_when:
  - the affected boundary or design question is explicitly named
  - the relevant synthesis decisions are linked or summarized
  - the proposed output has a clear canonical home
- required_inputs:
  - the governing synthesis decision or equivalent canonical basis is available
  - the target artifact or target schema is known
- blocked_when:
  - required human approval threshold is unknown before mutation would be
    applied

### Output Types
- output_types:
  - locked architecture docs
  - reusable templates
  - example canonical artifacts
  - schema and contract definitions
  - automation/task setup definitions
  - migration guidance

### Completion Contract
- done_when:
  - the durable artifact is updated, internally consistent, and aligned with
    the synthesis
- useful_partial_progress_when:
  - a major ambiguity is removed
  - a reusable contract is drafted
  - a migration blocker is clearly isolated

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
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/notes/domain-example-capacityos-decisions-draft.md

#### [DEC-2] Reserved System-Governance Domain
- current_effect: CapacityOS includes a reserved system-governance domain,
  while the engine/runtime substrate remains outside the domain ontology
- consequence_for_domain:
  - this domain uses the domain shape without collapsing the substrate/domain
    boundary
- decision_ref:
  - decision_id: reserved-system-governance-domain
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/notes/domain-example-capacityos-decisions-draft.md

#### [DEC-3] System 1 as Execution Contract
- current_effect: System 1 in domain canon is an execution contract, not a
  live execution surface
- consequence_for_domain:
  - live queue and in-progress state remain outside this file in runtime
- decision_ref:
  - decision_id: system-1-execution-contract
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/notes/domain-example-capacityos-decisions-draft.md

#### [DEC-4] Default Intake Fast-Path Rule
- current_effect: `^que` is the default intake path; `^now` is explicit
  fast-path handling, not an authority override
- consequence_for_domain:
  - immediate handling still respects approval and safety boundaries
- decision_ref:
  - decision_id: default-intake-fast-path-rule
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/notes/domain-example-capacityos-decisions-draft.md

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
