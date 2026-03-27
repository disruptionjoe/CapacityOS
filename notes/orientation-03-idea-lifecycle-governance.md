# Orientation 03 - Idea Lifecycle Governance

## Core Framing

The system should not think of governance as "a document moving from stage to
stage."

It should think in terms of:

- idea lineage
- derived objects
- promotion boundaries
- freshness checks

Raw input may split into many downstream objects. The important thing is not
that one file survives intact. The important thing is that the lineage from raw
idea to promoted work remains legible and governable.

## The Governing Objects By Stage

### Intake

Governed object:

- intake receipt

Rule:

- preserve the raw incoming idea or request in a lightweight immutable form

### Triage

Governed object:

- triage proposal

Rule:

- proposals may split, merge, or reinterpret the intake
- human-originated intake may require lightweight human validation here

### Backlog

Governed object:

- backlog item

Rule:

- backlog holds durable potential work
- backlog items are not equally trusted
- endorsement state matters

### Queue

Governed object:

- queue item
- bundle

Rule:

- queue is where the system commits to active work
- queue promotion is the stronger trust boundary

### Execution

Governed object:

- run
- artifact

Rule:

- execution should produce new outputs, not silently rewrite upstream intent

### Consequence

Governed object:

- human-required action plus resulting observation

Rule:

- real-world consequence stays a human checkpoint when appropriate
- the result becomes new input back into the system

## The Main Governance Risk You Named

The risk is:

- a queued task is based on earlier ideas
- later the same day, new input changes the situation
- the agent proceeds on stale scope
- earlier queued work overwrites or ignores newer intent

That is a real risk.

I think the fix is not "make agents read everything again all the time."

The fix is stronger governance at promotion and execution touchpoints.

## Recommended Governance At Each Touchpoint

### 1. Intake Governance

- every idea gets an intake receipt
- receipts are immutable
- new input never silently overwrites an older receipt

### 2. Triage Governance

- triage proposals must point back to source receipts
- proposals may split one idea into multiple backlog candidates
- human review is about validating interpretation, not manually drafting work

### 3. Backlog Governance

- backlog items should carry:
  - source receipt refs
  - origin type
  - endorsement state
  - domain and goal linkage
- backlog is where multiple interpretations can coexist without pretending they
  are all equally ready

### 4. Queue Promotion Governance

This is the most important one.

At queue promotion, the system should create a scoped snapshot of what is being
advanced.

That snapshot should include at least:

- source receipt refs
- source backlog refs
- promoted_at timestamp
- goal/domain linkage
- assumptions or readiness basis

This is what defines the committed work package.

### 5. Pre-Execution Freshness Governance

Before execution starts, the system should run a freshness or collision check.

It should ask:

- has newer intake arrived in the same domain?
- has newer input touched the same goal or object?
- has anything been logged that changes the readiness assumptions?
- has a conflicting backlog item appeared since promotion?

If yes, the queue item should not blindly proceed.

It should:

- continue unchanged
- pause for re-triage
- split
- supersede the older queued item
- escalate to human judgment

### 6. Execution Governance

- agents should create new artifacts or updates to the queued work object
- they should not silently rewrite the meaning of earlier intake receipts
- if execution discovers materially new direction, that should become new intake
  or a new issue/proposal, not hidden mutation

### 7. Bundle Governance

When multiple queue items form one meaningful package:

- judge them as a bundle
- let package-level readiness override isolated-task optimism

This prevents one task from dragging the system forward while the whole package
has drifted.

### 8. Consequence Governance

- human approval still matters at real-world consequence
- execution output is not the same thing as external commitment
- after consequence, the result becomes new input rather than a silent state
  change

## The Structural Protection I Recommend

The most important missing protection is:

### Queue items should be snapshot-based and freshness-checked

That means:

- queue promotion commits a version of the work
- later input does not silently rewrite that commitment
- but the system must still check for collisions before execution or publishing

In other words:

- no silent overwrite
- no infinite re-reading of all history
- no blind execution on stale assumptions

## What I Think We Still Need To Design

We should probably define a concrete governance contract for:

1. lineage refs
2. supersession
3. freshness scans
4. conflict thresholds
5. collision routing

That is the real implementation conversation behind your concern.

## My Current Recommendation

If we want this to stay deterministic and safe:

- ideas should be immutable at intake
- proposals should be derived, not destructive
- backlog should allow parallel possibilities
- queue should commit a scoped snapshot
- execution should run a freshness check against newer same-domain input
- materially conflicting new ideas should pause or supersede queued work, not
  be silently ignored
