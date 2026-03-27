# CapacityOS Decision Records Draft

This file is an example decision-record collection used by the example domain's
`decision_ref` grammar.

## [domain-centric-coherence]
- title: Domain-Centric Coherence
- status: active
- decision: domains are the primary coherence/governance objects; projects and
  repos are subordinate execution contexts
- current_effect:
  - queue, review, and stewardship logic resolve against domains
- source_basis:
  - [Design Review Synthesis](/C:/Users/joe/OneDrive/CapacityOS/notes/design-review-synthesis.md)

## [reserved-system-governance-domain]
- title: Reserved System-Governance Domain
- status: active
- decision: CapacityOS includes a reserved system-governance domain, while the
  engine/runtime substrate remains outside the domain ontology
- current_effect:
  - the system-governance domain uses the domain shape without collapsing the
    substrate/domain boundary
- source_basis:
  - [Design Review Synthesis](/C:/Users/joe/OneDrive/CapacityOS/notes/design-review-synthesis.md)

## [system-1-execution-contract]
- title: System 1 as Execution Contract
- status: active
- decision: System 1 in domain canon is an execution contract, not a live
  execution surface
- current_effect:
  - live queue and in-progress state remain outside the domain file in runtime
- source_basis:
  - [Design Review Synthesis](/C:/Users/joe/OneDrive/CapacityOS/notes/design-review-synthesis.md)

## [default-intake-fast-path-rule]
- title: Default Intake Fast-Path Rule
- status: active
- decision: `^que` is the default intake path; `^now` is explicit fast-path
  handling, not an authority override
- current_effect:
  - immediate handling still respects approval and safety boundaries
- source_basis:
  - [Design Review Synthesis](/C:/Users/joe/OneDrive/CapacityOS/notes/design-review-synthesis.md)
