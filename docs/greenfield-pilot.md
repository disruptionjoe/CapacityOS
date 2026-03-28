# Greenfield Pilot

## Purpose

Use CapacityOS before any migration from the old system.

The goal is to validate:

- the domain shape
- runtime flow through intake, triage, backlog, queue, review, and consequence
- mixed-origin backlog handling
- bundle readiness
- engine-owned cadence and prepared review objects
- clean separation between public engine assets and local private canon/runtime

## Pilot Domains

Use two fake domains with different operating styles:

1. `Northwind Studio`
   - digital/content/business-style domain
   - tests launch bundles, copy assets, and publication checkpoints
2. `Harbor Garden`
   - physical-world operations domain
   - tests volunteer coordination, signage, and human real-world consequence

This pair is intentionally different so the system is not only tested against
software-like or content-like work.

## What Should Be Exercised

### Intake And Triage

- human conversational intake defaults to `^que`
- one intake item can split into multiple proposed outputs
- human review of triage remains lightweight

### Backlog And Queue

- human-originated and agent-originated items can coexist in backlog
- endorsement state remains visible
- queue promotion is the stronger trust boundary

### Execution And Consequence

- one domain should show bundle/package review
- one domain should show a human-only consequence step
- artifacts should link back to queue work

### Review

- a cadence-style review package should be generated from the current state
- the daily operating view should surface agent work and Joe-only work cleanly

## Current Pilot Files

### Canon

- [capacityos.md](/C:/Users/joe/OneDrive/CapacityOS/local/canon/domains/capacityos.md)
- [northwind-studio.md](/C:/Users/joe/OneDrive/CapacityOS/local/canon/domains/northwind-studio.md)
- [harbor-garden.md](/C:/Users/joe/OneDrive/CapacityOS/local/canon/domains/harbor-garden.md)

### Runtime

- [daily-operating-view-2026-03-25.md](/C:/Users/joe/OneDrive/CapacityOS/local/runtime/views/daily-operating-view-2026-03-25.md)
- [review-system3-weekly-2026-03-25.json](/C:/Users/joe/OneDrive/CapacityOS/local/runtime/reviews/review-system3-weekly-2026-03-25.json)

## Pass Conditions

The pilot is good enough to proceed when:

- the two fake domains can use the same base domain shape without special
  pleading
- the runtime records feel staged and legible rather than ad hoc
- the daily operating view surfaces the right trust boundary
- a review package can be prepared without rereading raw chat
- no private JoeEA material was needed to make the system function

## Final Portability Proof

Before migration, run one clean-engine proof:

1. remove or ignore `local/`
2. start from the tracked engine only
3. create a fresh new local canon/runtime layer
4. instantiate a new domain without reusing Joe-specific data
5. confirm the engine, template, and example pack are enough to get started

If that works, the engine is genuinely reusable and safe to publish.
