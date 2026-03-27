# CapacityOS Domain Agent Recommendation

## Purpose

This document recommends the structure for a CapacityOS domain agent so a
building agent can design it against a clear target.

The domain agent described here is the anchored steward for one domain. It is
the continuity mechanism for domain coherence over time, not just a worker that
happens to operate inside the domain.

The recommendation is based on:

- the research review in `C:\Users\joe\JoeEA\data\intake\CoS and domain agent design research.md`
- the locked CapacityOS architecture in `architecture-lock/`
- the current domain template, lifecycle contract, and runtime model already in
  the repo

## Executive Recommendation

Each domain should have exactly one primary anchored domain agent at a time.

That agent should be responsible for:

- maintaining fast, reliable orientation to the domain
- evaluating backlog items against purpose, goals, and domain rules
- promoting worthy work into the trusted queue
- preparing domain reviews
- keeping a compact domain learning surface over time

It should not be responsible for:

- owning engine policy
- becoming a general cross-domain coordinator
- silently mutating canon
- acting from raw conversation history as its main memory source

The clean CapacityOS model is:

- one domain canon file provides durable meaning
- one anchored domain steward maintains local coherence
- runtime holds backlog, queue, bundles, reviews, issues, artifacts, and runs
- ephemeral worker agents may operate inside the domain, but the steward is the
  authority-bearing continuity layer

## Why This Shape Fits CapacityOS

This recommendation lines up with the strongest existing repo decisions:

- domains are the primary coherence objects
- each domain has one primary steward agent
- canon is separate from runtime
- queue promotion is the stronger trust boundary
- reviews are engine-triggered but domain-interpreted
- durable mutation requires approval

It also lines up with the research signals:

- stable charter plus working summary plus cold logs is better than huge
  ambient context
- learning should happen through outcome-linked reflection and promotion
- append-only history plus compaction beats silent rewriting
- review should be selective and risk-triggered

## Recommended Role Model

### Role

The domain agent is the steward of one domain's coherence.

It should be the default answer to these questions:

- what belongs in this domain?
- what matters most in this domain right now?
- what should advance from backlog into trusted queue?
- what did we learn in this domain that should affect future judgment?

### Non-Goals

The domain agent should not become:

- a second source of truth separate from domain canon and runtime
- a hidden planner for other domains
- a mandatory gate for all runtime changes
- a free-form memory diary
- a substitute for human approval at strong trust boundaries

### Core Responsibilities

- maintain a compact orientation layer for the domain
- evaluate backlog items against purpose, scope, goals, and decision effects
- create or recommend queue items and bundles
- run freshness and supersession checks before execution
- prepare domain review packages from structured state
- convert outcomes and issues into backlog items, review findings, or canon
  change proposals

## Recommended Source-Of-Truth Contract

The domain agent should be designed around the same truth hierarchy as the rest
of CapacityOS.

### Read By Default

- `local/canon/domains/<domain>.md`
- relevant records in `local/canon/decisions/`
- `local/runtime/backlog/`
- `local/runtime/queue/`
- `local/runtime/bundles/`
- `local/runtime/reviews/`
- `local/runtime/issues/`
- `local/runtime/artifacts/`
- `local/runtime/runs/`
- a compiled domain state packet built from those sources

### Treat As Canonical

- domain purpose, boundaries, goals, and execution contract in domain canon
- full rationale in decision records
- live work state in runtime objects

### Treat As Non-Canonical

- transcripts
- ad hoc summary notes without refs
- ephemeral worker scratch context
- generated views when they are not backed by canonical objects

## Recommended Memory Architecture

The domain agent should use tiered memory with a narrow hot set.

### Layer 1: Domain Charter

Always-load memory:

- purpose
- scope and non-scope
- constraints
- strategic and operational goals
- key decision effects
- execution contract
- escalation rules

Primary source:

- the domain canon file

### Layer 2: Domain State Packet

Hot mutable working memory:

- top backlog items
- active queue items
- bundle and review state
- blockers and stale items
- recent issue patterns
- current assumptions that matter to prioritization

This should be compiled from runtime, not hand-maintained in prose.

### Layer 3: Domain Event History

Cold memory:

- backlog history
- queue history
- run events
- artifact lineage
- review outcomes
- issue history

Use this for replay, investigation, and compaction support, not as default
prompt context.

### Layer 4: Promoted Domain Heuristics

Selective durable learning:

- prioritization heuristics
- domain-specific quality checks
- recurring coordination rules
- reusable execution playbooks

Only promote these after evidence and review.

## Recommended Memory Precedence

When sources disagree, the domain agent should resolve them in this order:

1. explicit human instruction or approval
2. locked engine policy and authoritative decision records
3. current domain canon
4. approved promoted heuristics
5. structured runtime state
6. generated summaries and reflections
7. raw history

If the conflict touches domain identity, trust boundary, or ownership, the
agent should escalate instead of improvising.

## Recommended Supporting Artifacts

The builder should create a few explicit support surfaces for strong domain
agents.

### Engine / Schema

- `schemas/indexes/domain-state-packet.schema.json`
- `templates/reviews/domain-review-template.md`
- `templates/agents/domain-steward-charter.md`

### Runtime / Materialized

- `local/runtime/indexes/domain-state-<domain_id>.json`
- `local/runtime/reviews/review-<domain_id>-<cadence>-<date>.md`

The important design choice is that the steward should load the domain canon and
the domain state packet first, then fetch deeper history only when needed.

## Recommended Authority Boundaries

### The Domain Agent May

- classify, split, merge, and rank backlog items inside its domain
- create backlog items with lineage and endorsement state
- recommend or create queue items and bundles within its authority tier
- prepare review packages
- draft domain canon changes or decision updates as proposals
- spawn or guide ephemeral workers scoped to domain-local tasks

### The Domain Agent Must Not

- mutate engine policy
- mutate another domain's canon
- bypass human approval for high-consequence queue promotion or durable canon
  mutation
- silently convert runtime observations into standing rules
- own cross-domain arbitration when ownership is genuinely ambiguous

### Human Approval Should Still Gate

- durable canon mutation
- high-consequence queue promotion
- external publication or real-world consequence steps
- promotion of new standing domain heuristics
- changes that materially shift domain boundaries

## Recommended Domain Workflow Model

### 1. Intake To Backlog

1. Intake receipt is created.
2. Triage proposals are produced.
3. The domain agent evaluates proposals against domain purpose and scope.
4. Accepted proposals become backlog items with lineage and endorsement state.
5. Rejected or ambiguous proposals are archived, split, or escalated.

### 2. Backlog To Queue

1. The domain agent reviews backlog items against System 3 and System 1 logic.
2. It checks worthiness, readiness, and collision basis.
3. It creates queue items or bundles when the work is ready.
4. If the work crosses a human-charge threshold, the human approves promotion.

### 3. Queue To Execution

1. Execution reads queue commitments, not ambient chat context.
2. The domain agent or execution layer runs freshness checks before action.
3. If new input invalidates assumptions, the item pauses, supersedes, or
   escalates.
4. Artifacts and run events are recorded with lineage.

### 4. Review

1. The engine triggers cadence.
2. The domain agent interprets the domain through the standard review contract.
3. It creates a review package with findings, signals, and recommended actions.
4. The review package becomes a human-readable runtime object.

### 5. Learning

1. Outcomes, artifacts, issues, and review findings are observed.
2. The domain agent extracts candidate lessons.
3. Lessons remain provisional until repeated evidence or explicit review
   justifies promotion.
4. Promoted lessons become heuristics, playbooks, or canon/decision proposals.

## Recommended Queue-Promotion Discipline

The domain agent should treat queue promotion as a real commitment boundary.

Every promoted item should preserve:

- source lineage
- promotion basis
- readiness basis
- assumptions in force
- collision basis
- freshness state
- supersession links when relevant

This keeps the steward from acting on fuzzy domain intuition instead of
governable structured state.

## Recommended Review Triggers

The domain agent should escalate or ask for deeper review when:

- domain ownership is ambiguous
- the item conflicts with domain canon or a decision effect
- freshness checks fail
- the work is high consequence
- multiple backlog items collide around the same basis
- repeated execution failures appear
- the proposed action would change domain canon or a standing heuristic
- cross-domain dependency becomes material

If none of those are true, the steward should stay efficient and local.

## Recommended Learning And Compaction Policy

The domain agent should learn through a narrow loop:

1. observe
2. summarize
3. compare against outcomes
4. promote selectively
5. supersede explicitly

### Keep Raw

- event history
- issue records
- review findings
- artifact lineage

### Summarize Periodically

- domain state packet
- active blockers and risks
- recurring outcome patterns

### Promote Selectively

- prioritization heuristics
- quality rubrics
- reusable task patterns
- bounded domain playbooks

### Retire Explicitly

- stale heuristics
- superseded playbooks
- outdated assumptions

Every promoted heuristic should record:

- evidence refs
- approval status
- affected domain scope
- what it supersedes

## Recommended Failure Modes To Avoid

- domain memory swamp: loading too much raw history every time
- hidden steward bottleneck: all work waits for the anchored agent
- canon drift: runtime observations become rules without approval
- stale execution: queued work proceeds on invalid assumptions
- custom-domain sprawl: every domain invents incompatible structures
- cross-domain leakage: the steward starts deciding work that belongs elsewhere

## Recommended Build Sequence

### Phase 1: Orientation And Review

Build:

- domain charter asset
- domain state packet
- read-only backlog and queue interpretation
- review-package generation

Success criteria:

- the steward can recover orientation from canon plus state packet
- review outputs are comparable across domains

### Phase 2: Promotion And Freshness

Build:

- backlog triage logic
- queue-promotion logic
- freshness and supersession checks
- bundle formation support

Success criteria:

- promotions are lineage-preserving and auditable
- stale work pauses instead of silently proceeding

### Phase 3: Learning And Heuristic Promotion

Build:

- issue-pattern aggregation
- candidate heuristic generation
- explicit promotion and supersession workflow
- domain-local playbook support

Success criteria:

- useful patterns persist without expanding hot context uncontrollably
- the steward remains deterministic by default

## Acceptance Criteria For The Final Design

The design is good if:

- a new agent can orient in a domain from one canon file plus one state packet
- backlog evaluation clearly resolves against purpose, goals, and decisions
- queue promotion is structured and explainable
- review outputs can be compared across domains
- domain learning improves future judgment without becoming free-form memory
  sprawl
- the domain agent knows when to escalate instead of overreaching

## Bottom Line

CapacityOS should use domain agents as anchored stewards of local coherence.

Each steward should load a compact domain charter and state packet, make
structured promotion judgments, prepare reviews, and learn through
evidence-linked compaction and promotion.

Its success condition is not "doing more work itself." Its success condition is
keeping a domain understandable, governable, and execution-ready over time.
