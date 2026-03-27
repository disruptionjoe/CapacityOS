# Orientation 01 - Current State And Plan

## Where We Are

CapacityOS is past the architecture-brainstorm stage and into the first
real-system stage.

What is materially done:

- Phase 1 architecture is locked around `containment / coherence / flow`
- the domain-centric model replaced the old project-centric model in the lock
  docs
- the canonical domain template exists as a real engine asset
- the canonical decision-record template exists as a real engine asset
- the reserved CapacityOS system-governance domain exists in local canon
- a publishable example version of that domain exists
- a greenfield pilot exists with two fake domains and sample runtime records

What is not done yet:

- we have not walked the greenfield pilot end to end as an operating test
- we have not run the clean-engine portability proof
- we have not written the actual migration plan from JoeEA into this system
- we have not defined the bootstrap automation pack in executable detail
- we have not fully specified the scripts/schema/runtime-record layer of the
  personal harness

## Current Truth Surfaces

The main orientation files right now are:

- [LOCK.md](/C:/Users/joe/OneDrive/CapacityOS/architecture-lock/LOCK.md)
- [00-plan.md](/C:/Users/joe/OneDrive/CapacityOS/00-plan.md)
- [greenfield-pilot.md](/C:/Users/joe/OneDrive/CapacityOS/docs/greenfield-pilot.md)

## What The Plan Looks Like From Here

### 1. Walk the greenfield pilot

Use the fake domains and runtime scaffold to see whether the system feels:

- deterministic
- staged correctly
- clean at the queue boundary
- stable across digital and physical-world work

### 2. Run the clean-engine portability proof

This is the last major pre-migration confidence test.

The question is:

- if `local/` disappears, can a new person still start from the tracked engine
  without inheriting Joe-specific data?

### 3. Finish the personal-harness implementation contract

We have the architecture.

We still need the more concrete contract for:

- scripts
- JSON/JSONL or other machine-state formats
- indexes/manifests
- schema validation
- adapter entrypoints

### 4. Write the migration plan

Only after the pilot and portability proof should we define:

- what gets migrated
- what gets rewritten
- what gets archived
- what stays out entirely

### 5. Define bootstrap automation

Then we can make the system operational quickly for a fresh install.

## Recommended Immediate Order

1. inspect the greenfield pilot as if it were today's real system
2. identify any determinism or trust-boundary failures
3. define the personal-harness implementation contract
4. run the clean-engine portability proof
5. write the migration plan

## My Read Right Now

We are in a strong place architecturally.

The biggest remaining risks are no longer ontology confusion. They are:

- implementation shape of the personal harness
- lifecycle governance under change and collision
- proving engine portability without Joe-specific leakage
