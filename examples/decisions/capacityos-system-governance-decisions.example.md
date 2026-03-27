# CapacityOS System-Governance Decision Records Example

This file is a publishable example decision-record collection for the
CapacityOS system-governance domain.

## [domain-centric-coherence]
- title: Domain-Centric Coherence
- status: active
- decision: domains are the primary coherence/governance objects; projects and
  repos are subordinate execution contexts
- current_effect:
  - queue, review, and stewardship logic resolve against domains
- source_basis:
  - [Phase 1 Lock](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/LOCK.md)
  - [Decision Log](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/08-decision-log.md)

## [reserved-system-governance-domain]
- title: Reserved System-Governance Domain
- status: active
- decision: CapacityOS includes a reserved system-governance domain, while the
  engine/runtime substrate remains outside the domain ontology
- current_effect:
  - the system-governance domain uses the domain shape without collapsing the
    substrate/domain boundary
- source_basis:
  - [Phase 1 Lock](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/LOCK.md)
  - [Decision Log](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/08-decision-log.md)

## [engine-owns-cadence]
- title: Engine Owns Cadence
- status: active
- decision: the engine detects cadence, routes review to the correct skill, and
  surfaces prepared review work; domains do not define cadence policy
- current_effect:
  - review timing and initiation remain engine-owned rather than domain-authored
- source_basis:
  - [Principles](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/01-principles.md)
  - [Scheduled Tasks](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/07-scheduled-tasks.md)

## [system-1-execution-contract]
- title: System 1 as Execution Contract
- status: active
- decision: System 1 in domain canon is an execution contract, not a live
  execution surface
- current_effect:
  - live queue and in-progress state remain outside the domain file in runtime
- source_basis:
  - [Decision Log](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/08-decision-log.md)
  - [Domain Template](/C:/Users/joe/OneDrive/CapacityOS/templates/domains/domain-template.md)

## [default-intake-fast-path-rule]
- title: Default Intake Fast-Path Rule
- status: active
- decision: `^que` is the default intake path; `^now` is explicit fast-path
  handling, not an authority override
- current_effect:
  - immediate handling still respects approval and safety boundaries
- source_basis:
  - [Principles](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/01-principles.md)
  - [Common Flows](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/06-common-flows.md)
