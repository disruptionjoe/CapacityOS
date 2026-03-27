# Idea Lifecycle Governance Contract

## Purpose

This document defines how ideas move through CapacityOS without losing
lineage, trust boundaries, or protection against stale execution.

It is meant to shape the runtime schemas and validation layer directly.

## Core Framing

The system does not govern "one document moving through stages."

It governs:

- idea lineage
- derived objects
- promotion boundaries
- freshness checks
- supersession and pause rules

An intake item may split into many downstream objects. That is acceptable.

What must remain stable is the lineage from:

- raw incoming idea
- to interpretation
- to backlog candidate
- to queued commitment
- to execution output
- to real-world consequence

## The Main Risk To Prevent

The system must prevent this failure mode:

1. an idea is captured and later promoted into the queue
2. new same-day input changes the meaning, scope, or priority
3. the queued work proceeds anyway on stale assumptions
4. the agent output silently overwrites or ignores the newer intent

The answer is not "reload all history constantly."

The answer is:

- immutable lineage at intake
- explicit promotion boundaries
- explicit collision basis
- queue snapshotting
- pre-execution freshness checks
- supersession/pause/escalation rules

## Lifecycle Stages

### 1. Intake

Primary object:

- intake receipt

Governance rule:

- every meaningful input creates an intake receipt
- the receipt is immutable
- later interpretation may derive from it, but may not silently rewrite it

What intake is allowed to do:

- preserve raw input
- attach lightweight metadata
- route toward triage or fast-path handling

What intake is not allowed to do:

- silently create trusted queue work
- silently overwrite prior receipts

### 2. Triage

Primary object:

- triage proposal

Governance rule:

- triage proposals are derived interpretations of intake, not replacements for
  intake
- one receipt may yield zero, one, or many proposals
- proposals may also be rejected or split

What triage is allowed to do:

- propose backlog items
- propose goal updates
- propose issue creation
- propose bundle hints

What triage is not allowed to do:

- become canonical truth by inertia
- erase the intake record it came from
- silently drift into backlog admission without recording what happened

### 3. Backlog

Primary object:

- backlog item

Governance rule:

- backlog is durable potential work
- backlog is allowed to be mixed-origin
- backlog items are not equally trusted

Every backlog item should preserve:

- lineage back to intake or other source
- origin type
- endorsement state
- domain linkage
- goal linkage when available

Backlog admission is its own governance boundary.

That boundary must record:

- the source triage refs or other source refs
- whether admission created a new item, merged into an existing item, split, or
  rejected the proposal
- the distinctness or merge decision that justified admission

This boundary should strengthen admission discipline without creating a new
heavy human checkpoint for every case.

What backlog is allowed to do:

- hold parallel possibilities
- hold speculative or agent-originated ideas
- accumulate candidate work without pretending it is committed

What backlog is not allowed to do:

- silently collapse multiple incompatible ideas into one item without lineage
- silently act as if all items are queue-ready

Merge-specific rule:

- merge is an explicit admission outcome, not a casual side effect
- a merged backlog item must retain the union of source lineage it was built
  from
- if merging would make lineage muddy or collision scope too wide to govern
  cleanly, the default is do not merge

### 4. Queue Promotion

Primary objects:

- queue item
- bundle

This is the strongest trust boundary in the lifecycle.

Governance rule:

- queue promotion is a scoped commitment to active work
- promotion should create a snapshot of what is being advanced
- mixed-origin backlog may promote only when its readiness basis resolves
  explicitly

Every queue item should preserve, in structured form, at least:

- queue and domain identity
- source lineage back to backlog and intake where applicable
- promotion timing and promotion basis
- promotion readiness basis
- domain/goal linkage where applicable
- assumptions in force at promotion
- explicit collision basis for later freshness checks
- freshness and supersession state

This snapshot is what makes the queue item governable.

It means later input does not silently rewrite the meaning of already-promoted
work.

### 5. Execution

Primary objects:

- run event
- artifact

Governance rule:

- execution works from queued commitments, not from fuzzy ambient context
- execution may produce outputs, but may not silently mutate upstream lineage

Execution is allowed to:

- create artifacts
- update queue-item execution state
- report blockers or issues
- propose follow-on intake when new meaning is discovered

If execution emits intake-like material:

- it must be explicitly typed as execution-derived rather than human-originated
- it must preserve lineage to the parent queue item and run

This does not mean every execution discovery must re-enter as intake. It means
that if execution creates intake-like material, it must be typed and
lineage-preserving.

Execution is not allowed to:

- rewrite intake receipts
- silently rewrite backlog meaning
- silently ignore conflicts introduced after promotion

### 6. Consequence

Primary object:

- human-required action plus resulting observation

Governance rule:

- execution output is not identical to real-world commitment
- human consequence steps remain separate when risk or legitimacy requires it
- the result of consequence becomes new system input

## Governance At The Major Touchpoints

### Intake Touchpoint

Checks:

- did we preserve the raw idea?
- is the routing mode explicit?
- does this create a new receipt instead of rewriting an old one?

### Triage Touchpoint

Checks:

- what did we infer from the intake?
- what did we propose to create?
- do split outputs remain traceable to the source receipt?
- if human triage is needed, has that validation been recorded?

### Backlog Touchpoint

Checks:

- what is the item's origin?
- what is its endorsement state?
- what domain and goal does it belong to?
- is it materially distinct from nearby items?
- did admission create, merge, split, or reject?

### Queue Promotion Touchpoint

Checks:

- why is this worthy of promotion now?
- what exactly is being committed?
- what assumptions are in force?
- what source items does it depend on?
- what collision basis defines the work being committed?
- what promotion readiness basis allows this item to cross the queue boundary?
- does it require human approval at this boundary?

### Pre-Execution Touchpoint

Checks:

- has anything new touched the recorded collision basis since promotion?
- has any newer backlog work touched that same collision basis?
- has any issue, decision, or review finding changed the assumptions in force?
- if this work is bundled, has bundle state changed in a way that invalidates
  the package?
- are the recorded promotion assumptions still valid against that same
  structured basis?

If the answer is no conflict:

- proceed

If the answer is conflict or ambiguity:

- pause
- re-triage
- split
- supersede
- escalate to the human

### Consequence Touchpoint

Checks:

- is this ready for real-world consequence?
- does the human need to approve, perform, or confirm it?
- what new input should be created from the result?

## Freshness And Collision Governance

This is the key protective layer.

### Closed Collision Basis

Freshness and collision checks must begin from an explicit closed collision
basis, not from open-ended semantic similarity.

That basis may be supported by refs such as:

- goal refs
- object refs
- consequence refs

But the deterministic comparison must begin from recorded collision basis, not
from fuzzy interpretation alone.

Semantic similarity may assist human review. It may not be the primary
validator-facing basis.

Merged backlog or queue work naturally widens collision surface because its
lineage union is larger. That is acceptable and is one of the system's built-in
discouragements against over-merging.

### Freshness Rule

Every queue item must pass a freshness check before execution or publication.

The check should compare the queued commitment against structured recorded
basis, including:

- promotion snapshot
- source lineage refs
- explicit collision basis
- newer intake touching that collision basis
- newer backlog items touching that collision basis
- newer issues affecting that collision basis
- newer decisions or review findings that change assumptions in force
- bundle state where relevant

If freshness, collision, or supersession cannot be resolved from the recorded
structured basis with sufficient confidence, the default outcome is pause or
escalate, not proceed.

### Collision Outcomes

The system should have a small closed set of outcomes:

- `fresh`
- `pause-for-retriage`
- `superseded`
- `escalate-to-human`

### Outcome Precedence

The governance layer defines precedence of outcomes even if runtime
implementation computes checks in a different sequence.

Default precedence:

1. `superseded`
2. missing or invalid promotion basis / broken required lineage ->
   `pause-for-retriage` or `escalate-to-human`
3. bundle invalidated under its current policy
4. unresolved freshness or collision -> `pause-for-retriage` or
   `escalate-to-human`
5. `fresh`

### Supersession Rule

Supersession should never be implicit.

If a newer item replaces or invalidates an older queued commitment:

- the older queue item must record a superseded status
- the relationship must be typed
- it must record what superseded it
- the newer item must record that relationship explicitly

The runtime should distinguish behaviorally meaningful kinds of supersession,
such as:

- full replacement
- partial replacement or rescope
- invalidated by new fact
- pause pending re-triage

If multiple newer items compete to supersede the same target, the default
outcome is pause or escalate, not automatic winner selection.

## Bundle Governance

Bundles exist because readiness often emerges at the package level.

Governance rule:

- package-level review can override isolated-item optimism

Use bundles when:

- the meaningful approval question is about the package as a whole
- multiple queue items share one consequence step
- one item is only safe or useful in relation to the others

Bundle checks should include:

- internal consistency
- shared assumptions
- shared consequence path
- whether one stale member invalidates the package

Default bundle invalidation policy:

- fail closed unless explicitly marked otherwise

That means:

- if one bundle member becomes stale and there is no explicit partial-safe
  policy, the bundle pauses
- non-stale members remain attached to the paused bundle by default
- they do not silently continue alone
- recovery requires an explicit revalidation, split, demotion, or supersession

## Overwrite Protection Rules

To prevent silent overwrite or stale execution:

1. intake receipts are immutable
2. triage proposals are derived objects
3. backlog items retain lineage and endorsement state
4. queue promotion creates a snapshot commitment
5. execution must freshness-check before acting
6. conflicting newer input pauses or supersedes, rather than being ignored
7. consequence creates new input instead of silently mutating history

## Minimal Status Model By Stage

This is not the final runtime schema, but it is the governance shape the schema
should support.

### Intake receipt

- `captured`
- `routed`

### Triage proposal

- `proposed`
- `approved`
- `rejected`
- `split`

### Backlog item

- `candidate`
- `active`
- `deferred`
- `promoted`
- `archived`

### Queue item

- `queued`
- `paused`
- `executing`
- `awaiting_review`
- `ready_for_consequence`
- `done`
- `superseded`

### Bundle

- `forming`
- `awaiting_bundle_review`
- `ready`
- `paused`
- `superseded`
- `done`

## Schema Implications

This section names the minimum kinds of structured support the runtime schema
must provide. Exact field names may still change during schema drafting as long
as the same governance properties remain preserved.

The upcoming runtime schemas should support at least these property categories.

### Intake receipt

- immutable source payload or source ref
- capture timing
- routing mode
- domain hint

### Triage proposal

- source intake lineage
- proposed outputs
- human review state where applicable
- derivation timing

### Backlog item

- source intake lineage
- source triage lineage
- origin type
- endorsement state
- domain identity
- goal linkage
- admission outcome
- distinctness or merge basis

### Queue item

- source backlog lineage
- source intake lineage where applicable
- promotion timing
- promotion basis
- promotion readiness basis
- assumptions in force
- explicit collision basis
- freshness state
- supersession state
- replacing or replaced-by lineage where applicable

### Bundle

- member queue lineage
- bundle basis
- shared assumptions
- bundle readiness state
- bundle invalidation policy

### Run event

- queue lineage
- freshness check result
- collision result
- freshness evidence basis
- artifact lineage

## Validator Implications

The first lifecycle validators should check:

- every backlog item has lineage
- every queue item has lineage plus promotion basis
- no queue item is missing freshness status at execution time
- superseded items point to the replacing item
- no artifact appears without a queue or run lineage
- no human consequence result appears without feeding new input or outcome state

## Recommended Working Decision

CapacityOS should govern ideas as immutable intake plus derived objects plus
explicit promotion boundaries, not as one mutable object drifting through vague
stages.

The most important implementation rule is:

- queue items must be snapshot-based and freshness-checked before execution

That is the cleanest protection against stale queued work overwriting newer
intent while still keeping the system deterministic and token-efficient.
