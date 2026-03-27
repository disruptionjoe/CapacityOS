# 04 - Entity Model

## Core Canon Entities

### Domain

The primary coherence/governance object.

Minimum fields:

- `domain_id`
- `name`
- `class`
- `status`
- `system_5`
- `system_4`
- `system_3`
- `system_2`
- `system_1`
- `key_decisions`

Notes:

- each domain has one canonical domain record
- domains are durable canon, not runtime objects
- the system-governance domain uses the same base shape with a reserved class

### Goal

A reusable cross-level object shape nested inside a domain.

Minimum canonical fields:

- `id`
- `level`
- `statement`
- `supports`
- `evaluation_signals`

Notes:

- `level` is semantically operative
- `S4` goals express strategic direction
- `S1` goals express short-horizon operational intent
- `S5` goal-shaped commitments are optional and rare

### Decision Record

A durable record for full decision rationale and provenance.

Minimum fields:

- `decision_id`
- `title`
- `status`
- `decision`
- `current_effect`
- `source_basis`

Notes:

- domains keep only compact current-effect summaries inline
- full rationale and history live in separate decision records

## Core Runtime Entities

### Intake Receipt

The preserved record of raw incoming material before routing.

Minimum fields:

- `id`
- `captured_at`
- `source_type`
- `source_summary`
- `raw_ref`
- `routing_mode`

Notes:

- every meaningful intake creates a receipt
- conversation becomes structured state here rather than remaining only chat

### Triage Proposal

A lightweight proposed interpretation of an intake receipt.

Minimum fields:

- `id`
- `intake_receipt_id`
- `proposed_domain_id`
- `proposed_outputs`
- `human_review_state`
- `created_at`

Notes:

- most important for human-originated intake
- one intake receipt may yield zero, one, or many proposals
- a proposal may become backlog, be rejected, or be split

### Backlog Item

Durable potential work or opportunity that has not yet been promoted into the
trusted queue.

Minimum fields:

- `id`
- `domain_id`
- `title`
- `origin_type`
- `endorsement_state`
- `status`
- `provenance`
- `created_at`
- `updated_at`

Notes:

- mixed-origin backlog is allowed
- backlog items are not equally trusted by default
- endorsement state is part of the canonical runtime model

### Queue Item

The canonical unit of trusted active work in runtime.

Minimum fields:

- `id`
- `domain_id`
- `source_ref`
- `status`
- `readiness_state`
- `execution_mode`
- `human_required`
- `created_at`
- `updated_at`

Notes:

- queue promotion is the stronger trust boundary
- queue items may represent agent work, review work, or human-required work
- `task` is often a useful rendered word, but it is not required as a separate
  primary ontology class

### Bundle

A first-class package-level review object over multiple queue items.

Minimum fields:

- `id`
- `domain_id`
- `member_queue_item_ids`
- `readiness_state`
- `approval_state`
- `review_summary`

Notes:

- bundle readiness is distinct from individual task validity
- packages may be partially ready, blocked, or unsafe as a whole

### Review Package

A prepared review object created by a cadence skill or other structured review
flow.

Minimum fields:

- `id`
- `domain_id`
- `review_level`
- `source_ref`
- `prepared_findings`
- `recommended_actions`
- `human_decision_state`

Notes:

- the engine triggers review cadence
- skills prepare the package
- the human judges at the right control surface

### Issue

A structured signal that something was wrong, weak, or miscategorized.

Minimum fields:

- `id`
- `domain_id`
- `severity`
- `source_ref`
- `issue_type`
- `status`
- `created_at`

Notes:

- `^issue1` through `^issue9` map onto issue severity
- issues usually feed the improvement loop rather than interrupting execution

### Artifact

A durable execution output.

Minimum fields:

- `id`
- `domain_id`
- `source_ref`
- `artifact_type`
- `status`
- `provenance`

### Run

An execution, review, or generation event.

Minimum fields:

- `id`
- `run_type`
- `started_at`
- `ended_at`
- `touched_refs`
- `outcome`

## Generated Views

### Operating View

A generated runtime surface for daily use.

Typical sections:

- queue overview
- top work by domain and goal
- Joe-only work
- coaching note

### Human-Required View

A generated operational lens over runtime objects.

Notes:

- not a separate ontology class
- derived from queue items, bundles, review packages, and consequence steps

## Relationship Rules

- a domain contains goals and compact decision summaries
- a decision record may shape one or many domains
- an intake receipt may produce zero or many triage proposals
- a triage proposal may produce zero or many backlog items
- agents may create backlog items directly
- backlog items may promote to queue items
- queue items may be grouped into bundles
- runs may produce artifacts, review packages, and issue records
- consequence actions may create new intake receipts or update existing runtime
  state

## Anti-Drift Rules

- domains do not hold live queue state
- review cadence does not live inside domains
- generated views are not sources of truth
- conversation transcripts are not canonical by default
- a queue item should not silently become canon
- runtime optimization should not silently mutate engine or canon
