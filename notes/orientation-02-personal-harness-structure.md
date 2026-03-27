# Orientation 02 - Personal Harness Structure

## Short Answer

Yes, we have talked about the personal harness structurally, but not yet enough
at the concrete implementation layer.

What is already clear:

- the engine is tracked and publishable
- personal durable coherence lives in local canon
- live work lives in local runtime
- domains are the primary coherence objects
- cadence and generic review behavior belong to the engine

What is not yet locked tightly enough:

- which parts should be markdown versus JSON versus JSONL
- which scripts are the stable entrypoints
- what indexes or manifests the system should maintain
- how runtime state is validated and regenerated

So the personal harness exists architecturally, but not yet fully as a concrete
file-and-script contract.

## The Strong Shape

### Engine

Tracked, reusable, publishable.

It should contain:

- `templates/`
- `schemas/`
- `scripts/`
- `architecture-lock/`
- `examples/`
- review-skill definitions and adapter entrypoints

### Local Canon

Durable, private, relatively slow-moving.

It should contain:

- domain records
- decision records
- any other durable coherence objects

This is why markdown plus minimal YAML works well here:

- inspectable
- auditable
- stable
- semantically rich

### Local Runtime

Fast-moving, machine-legible, operational.

It should contain:

- intake receipts
- triage proposals
- backlog items
- queue items
- bundles
- review packages
- artifacts
- runs
- issues
- generated views

This is where I think we still need a stronger implementation decision.

## Recommended Format Policy

### Canon

Use:

- markdown
- minimal YAML front matter
- schema-shaped sections

Reason:

- canon optimizes for durable meaning and auditability

### Runtime State

Use:

- JSON for high-churn canonical runtime records
- JSONL for append-only event logs where appropriate
- markdown only for generated views and human-facing review surfaces

Reason:

- high-churn operational state should be cheap to parse, diff, validate, and
  regenerate
- agents should not need to infer structure from prose for core runtime facts

### Generated Views

Use:

- markdown

Reason:

- this is where the system can optimize for human review and orientation

## Recommended Script Shape

The harness should eventually have a small number of stable scripts or
entrypoints for:

- intake normalization
- triage generation
- backlog promotion
- queue generation or mutation
- review-package generation
- daily operating view generation
- portability/bootstrap setup

Those scripts should operate on structured runtime records rather than scraping
human-facing markdown views.

## Recommended Schema Shape

The harness should eventually have machine-validated schemas for:

- runtime records
- indexes/manifests
- generated view inputs

Canon may use lighter validation because it is richer and more semantic, but
the runtime should be much stricter.

## What I Think The Missing Conversation Is

We have mostly designed:

- the ontology
- the boundaries
- the review model

We have not yet fully designed:

- the runtime storage contract
- the script contract
- the validation contract

That is probably the next major design conversation if the goal is better
scalability, determinism, and token efficiency.

## My Recommendation

Treat the personal harness as:

- markdown canon
- structured JSON runtime
- generated markdown views
- thin adapters
- stable engine scripts over canonical machine state

That would give you a much stronger implementation story than letting the whole
system stay mostly markdown.
