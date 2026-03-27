# Architecture Lock - Phase 1

## Locked Summary

- CapacityOS is organized as `containment / coherence / flow`.
- The engine is reusable and publishable.
- Durable private canon is local and domain-shaped.
- Runtime is local and owns live movement.
- Domains are the primary coherence/governance objects.
- The engine owns cadence and review initiation.
- Intake defaults to `^que`; `^now` is explicit fast-path handling.
- Backlog is allowed to be mixed-origin; queue promotion is the stronger trust
  boundary.
- Human charge is concentrated at intake, queue promotion, and real-world
  consequence.
- Durable mutation of engine or canon requires human approval.

## What This Enables

- a public engine with private local operating state
- reusable domain templates across many domains
- stable review cadence without relying on human memory
- a cleaner queue built from structured promotion rather than raw intake
- stronger separation between durable meaning and live operational churn

## Ready-To-Proceed Test

Phase 1 should be treated as ready to move forward when:

- the lock docs agree with the domain template shape
- the system-governance domain can be instantiated cleanly
- at least one additional real domain can use the same base shape
- migration planning can proceed without reopening the primary ontology

## Immediate Next Work

1. walk the greenfield pilot with the fake domains end to end
2. run the clean-engine portability proof on a fresh start
3. write the migration plan
4. define the bootstrap automation pack
