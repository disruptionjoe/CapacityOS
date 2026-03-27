# CapacityOS Plan

## Summary

- CapacityOS is now being locked around `containment / coherence / flow`.
- The engine is tracked and publishable.
- Durable private canon is local and ignored.
- Runtime is local and ignored.
- Domains are the primary coherence/governance objects.
- The next move is to turn the locked architecture into real files, real
  domains, and a migration path.

## Working Architecture

### Containment

The engine owns reusable structure:

- schemas
- templates
- review skills
- cadence logic
- notation support
- automation patterns
- architecture docs

### Coherence

Durable canon is local and domain-shaped:

- domains
- goals
- decisions
- domain-specific governance

### Flow

Runtime owns live movement:

- intake receipts
- triage proposals
- backlog items
- queue items
- bundles
- review packages
- artifacts
- runs
- issues
- views

## Phase 1 - Architecture Lock Closeout

Goal: finish freezing the domain-centric architecture so migration work does not
reopen basic ontology questions.

Outputs:

- updated lock docs in `architecture-lock/`
- locked domain template shape
- example system-governance domain
- frozen Phase 1 summary in `architecture-lock/LOCK.md`

Exit criteria:

- one short explanation of the system still works
- domains are the primary coherence objects everywhere in the docs
- engine-owned cadence is explicit
- canon/runtime separation is explicit
- the core object model has one canonical home per concept

## Phase 2 - Canonicalization

Goal: promote the locked shape into real reusable engine assets.

Outputs:

- real domain template file
- real decision-record template
- reserved system-governance domain
- one additional real non-system domain for pressure-testing

Exit criteria:

- the template is usable without referring back to the review conversation
- at least two domains can use the same base shape
- the example no longer feels special-cased to CapacityOS

## Phase 3 - Migration Planning

Goal: define how the current project-centric material moves into the new system
without destructive cutover.

Outputs:

- migration bundle model
- mapping from current material into:
  - engine
  - local canon
  - runtime
  - archive/reference
- first-pass import and normalization rules

Rules:

- migration is copy-first
- no silent deletion
- old project framing is translated into domain framing deliberately
- private content does not leak into the publishable engine

## Phase 4 - Day-1 Operation

Goal: make a fresh CapacityOS install start working quickly.

Outputs:

- bootstrap prompt or setup flow
- core engine-wide cadence automations
- morning operating view
- review-package generation rules

Starter cadence suite:

- daily operating view generation
- daily System 2 coordination pass
- weekly System 3 control review
- monthly System 4 strategic review
- quarterly System 5 identity review
- weekly external insight review

## Current Priority Order

1. walk the greenfield pilot end to end with the fake domains
2. run the clean-engine portability proof on a fresh start
3. write the migration plan
4. define the bootstrap automation pack
5. define first-pass import and normalization rules against the locked shape

## Assumptions

- the engine repo remains safe to publish
- local canon and runtime remain ignored by git
- conversations are valid intake surfaces, but transcripts are not canonical by
  default
- the human is used as selective charge, not as a universal router
- durable mutation of engine or canon still requires human approval
