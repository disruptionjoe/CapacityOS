# Personal Harness Implementation Contract

## Purpose

This document turns the current architectural direction of CapacityOS into a
concrete implementation contract for the personal harness.

It answers:

- what belongs in engine, canon, runtime, and views
- which layers should be markdown versus JSON versus JSONL
- where scripts and schemas should live
- which ideas are relevant now versus later

## Status

The architecture is already strong.

The missing piece is implementation discipline.

Today CapacityOS has:

- locked architecture docs
- real domain and decision templates
- a real local canon structure
- a greenfield pilot scaffold

But it does not yet have:

- final runtime record formats
- final engine script entrypoints
- final schema validation contract

This document is meant to close that gap.

## Core Principle

Do not optimize for making the model more informed.

Optimize for making the system need less re-explanation.

That implies:

- compile before reason
- route before load
- separate durable meaning from live state
- let scripts do deterministic plumbing
- let the LLM handle interpretation, synthesis, drafting, and novelty

## Layer Contract

### 1. Engine

Tracked, reusable, publishable.

The engine should contain:

- `templates/`
- `schemas/`
- `scripts/`
- `examples/`
- `architecture-lock/`
- adapter entrypoints
- validation rules

The engine should not contain:

- private domains
- live backlog or queue state
- private runtime
- user-specific operational history

### 2. Canon

Private, durable, relatively slow-moving.

Canon should contain:

- domain records
- decision-record collections
- other future durable coherence objects

Canon should answer:

- what this domain is
- what matters in it
- how work in it should be judged
- what decisions currently shape it

Canon should not contain:

- live queue state
- in-progress execution state
- recent run logs
- engine cadence policy

### 3. Runtime

Private, mutable, machine-legible, operational.

Runtime should contain:

- intake receipts
- triage proposals
- backlog items
- queue items
- bundles
- review packages
- artifacts
- issues
- run records
- generated indexes

Runtime should answer:

- what is happening now
- what was just proposed
- what is trusted enough to move
- what ran
- what needs review

### 4. Views

Views are generated products, not canonical truth surfaces.

Views should contain:

- daily operating view
- Joe-only action views
- review digests
- backlog surfacing views

Views should be rebuilt from runtime and canon, not manually edited.

## Format Contract

### Canon Format

Use:

- Markdown
- minimal YAML front matter
- schema-shaped body sections

Why:

- canon is semantically rich and needs human auditability
- the locked domain shape already fits this well

### Runtime Object Format

Use:

- one JSON file per canonical runtime object

Target pattern:

- `local/runtime/intake/<id>.json`
- `local/runtime/triage/<id>.json`
- `local/runtime/backlog/<id>.json`
- `local/runtime/queue/<id>.json`
- `local/runtime/bundles/<id>.json`
- `local/runtime/reviews/<id>.json`
- `local/runtime/artifacts/<id>.json`
- `local/runtime/issues/<id>.json`

Why:

- high-churn state should be cheap to parse and validate
- agents should not depend on prose parsing for core operational facts
- deterministic scripts should read and write these objects directly

### Runtime Event Format

Use:

- JSONL for append-only event logs

Target pattern:

- `local/runtime/runs/events-YYYY-MM.jsonl`
- optional per-run materialized JSON records when needed

Why:

- events are naturally append-only
- JSONL is cheap to stream, diff, filter, and archive

### Generated View Format

Use:

- Markdown

Examples:

- daily operating view
- review packages intended for human scanning
- coaching notes

Why:

- views are for orientation and judgment, not core machine storage

## Important Distinction

The current pilot runtime is markdown-shaped because it is a visibility
scaffold.

That is acceptable for the pilot.

It should not become the final runtime storage contract by default.

The long-term runtime should be structured JSON plus JSONL, with markdown
reserved for human-facing views.

## Identifier Contract

Use stable symbolic identifiers everywhere important:

- domain ids
- goal ids
- decision ids
- intake ids
- triage ids
- backlog ids
- queue ids
- bundle ids
- review ids
- artifact ids
- run ids

Rules:

- ids should be generated deterministically where possible
- references should prefer ids over fuzzy labels
- human-readable titles should remain, but ids are the machine spine

## Script Contract

The engine should expose a small number of stable script entrypoints.

Recommended first set:

### Intake

- `scripts/intake/normalize-input`
- `scripts/intake/create-intake-receipt`

### Triage

- `scripts/triage/generate-proposals`
- `scripts/triage/validate-human-triage`

### Promotion

- `scripts/backlog/promote-to-queue`
- `scripts/backlog/check-freshness`

### Review

- `scripts/review/build-review-package`

### Execution

- `scripts/execution/record-artifact`

### Issues

- `scripts/issues/record-issue`

### Views

- `scripts/views/build-daily-operating-view`

### Validation

- `scripts/validate/validate-runtime`
- `scripts/validate/validate-canon-refs`
- `scripts/validate/check-drift`

### Bootstrap

- `scripts/bootstrap/init-local-layer`
- `scripts/bootstrap/create-sample-domain`

These scripts should operate on canonical machine state rather than scraping
human-facing markdown views.

## Schema Contract

The current `normalization/schemas/` set is legacy and still reflects the old
project/task model.

Do not extend that old shape as the final harness model.

Instead, create a new engine schema surface for the current architecture.

Recommended new schema groups:

### Runtime schemas

- `schemas/runtime/intake-receipt.schema.json`
- `schemas/runtime/triage-proposal.schema.json`
- `schemas/runtime/backlog-item.schema.json`
- `schemas/runtime/queue-item.schema.json`
- `schemas/runtime/bundle.schema.json`
- `schemas/runtime/review-package.schema.json`
- `schemas/runtime/artifact.schema.json`
- `schemas/runtime/issue.schema.json`
- `schemas/runtime/run-event.schema.json`

### Index schemas

- `schemas/indexes/domain-registry.schema.json`
- `schemas/indexes/agent-registry.schema.json`
- `schemas/indexes/domain-state-packet.schema.json`
- `schemas/indexes/cross-domain-state-packet.schema.json`
- `schemas/indexes/daily-operating-view-input.schema.json`

### Validation rules

- required lineage refs
- required timestamps
- allowed status enums
- source-target mutation rules
- reference format rules

## Routing Contract

Before substantial model reasoning, the harness should do deterministic routing.

The router should narrow:

- candidate domain
- candidate script path
- allowed read targets
- allowed write targets
- whether action is advisory, preparatory, or mutating

This is relevant now.

It is one of the strongest immediate moves for:

- determinism
- token efficiency
- context discipline

## Dashboard Contract

The daily operating view should be compiled from structured state first.

The system may optionally add explanatory language afterward.

The prioritization substrate itself should not depend on open-ended LLM
narrative generation.

This is relevant now.

## Validation Contract

CapacityOS should add anti-drift validators early.

The first validator set should check:

- schema validity
- missing lineage refs
- broken decision refs
- broken goal refs
- missing domain ids
- queue items with stale or missing source refs
- invalid status transitions

This is relevant now.

## What From The Divergence Set Is Relevant Now

These ideas should affect implementation now:

- compiler pipeline
- aggressive canon/runtime separation
- hard routing before model reasoning
- symbolic identifiers
- scripts for repeated transformations
- compiled dashboard
- anti-drift validators
- dual-engine split:
  - code for routing/validation/assembly
  - LLM for interpretation/synthesis/drafting

## What Is Strong But Should Come Later

These ideas are good, but not the next bottleneck:

- manifests as a full retrieval layer
- context ladders
- a heavy retrieval or memory stack beyond compact compiled state packets
- replayable sessions
- operator modes
- promotion engine
- forgetting policies
- friction heatmaps

They likely become relevant after the structured runtime and script substrate
exists.

## What Should Be Deferred Hard

These ideas are interesting, but too early right now:

- personal bytecode
- heavy mini-language expansion beyond the notation already being developed
- overbuilt meta-architecture before the runtime substrate is real

## Immediate Implementation Priorities

1. Define the new runtime schemas.
2. Decide canonical runtime file naming and status enums.
3. Create the first validation script layer.
4. Create the first deterministic daily-view assembly script.
5. Replace markdown-shaped pilot runtime records with JSON equivalents when the
   schemas exist.

## Recommended Working Decision

Treat the personal harness as:

- markdown canon
- structured JSON runtime
- JSONL event streams
- markdown generated views
- thin deterministic routing and validation scripts
- LLM reasoning on top of structured state, not instead of it

This is the strongest current implementation direction for CapacityOS if the
goals are:

- scalability
- determinism
- token efficiency
- better context-window discipline
- stronger operator leverage over time
