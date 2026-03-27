# CapacityOS Chief of Staff Agent Recommendation

## Purpose

This document recommends the structure for a CapacityOS Chief of Staff (CoS)
agent so a building agent can design it against a clear target.

The recommendation is based on:

- the research review in `C:\Users\joe\JoeEA\data\intake\CoS and domain agent design research.md`
- the locked CapacityOS architecture in `architecture-lock/`
- the current domain, runtime, and lifecycle contracts already present in the
  repo

The goal is a CoS that helps CapacityOS learn, coordinate, and preserve trust
without becoming a heavy coordinator bottleneck.

## Executive Recommendation

The CoS should be an anchored, cross-domain governance and operating agent that
works above the domain stewards but below the human.

It should not be the universal executor of all work.

It should be responsible for:

- cross-domain routing when ownership is ambiguous
- maintaining a compact operating picture across domains
- escalating collisions, risk, and authority-boundary questions
- maintaining the agent registry and cross-domain operating rules
- turning runtime outcomes, reviews, and issues into system-improvement
  proposals

It should not be responsible for:

- owning domain-local backlog pruning or queue management by default
- rereading raw history as its main memory strategy
- acting as a mandatory middleman for every agent action
- silently mutating canon or engine behavior

The cleanest CapacityOS placement is:

- CoS is anchored to the reserved `capacityos` system-governance domain
- domain agents remain the primary coherence maintainers inside each domain
- deterministic scripts and structured runtime remain the first routing layer
- the human remains the final authority at the strongest trust boundaries

## Why This Shape Fits CapacityOS

This recommendation matches the strongest shared signals across the research and
the repo:

- tiered memory beats giant ambient context
- append-only logs plus compaction are better than silent rewriting
- deterministic routing is preferred over prompt improvisation
- review should be triggered by risk and uncertainty, not inserted everywhere
- each domain should have one primary steward agent
- CapacityOS already reserves a system-governance domain for self-governance
  without collapsing engine and domain into one thing

## Recommended Role Model

### Role

The CoS is the cross-domain operating governor.

It keeps the system legible enough that:

- domain stewards can work locally
- the human sees the right review and consequence surfaces
- the system can learn from patterns across domains

### Non-Goals

The CoS should not become:

- a universal planner that serializes all work through itself
- a free-form memory blob containing every important fact
- a replacement for the engine router
- a substitute for domain canon
- a debate engine that always invokes extra agents

### Core Responsibilities

- maintain cross-domain awareness and escalation logic
- compile the daily operating picture from structured state
- resolve or escalate ambiguous domain ownership
- maintain the registry of anchored and ephemeral agents
- detect repeated failure patterns and route them into system improvement
- propose changes to agent policy, review triggers, or registry configuration
- prepare cross-domain review packages for the human when needed

## Recommended Authority Boundaries

### The CoS May

- read system-governance canon, domain canon, and structured runtime indexes
- create system-governance backlog items, review packages, and issues
- create cross-domain coordination proposals
- register, pause, or retire agent instances in the agent registry according to
  policy
- recommend canon or engine changes as draft proposals

### The CoS Must Not

- silently rewrite domain canon
- silently change engine policy
- bypass queue-promotion or real-world consequence approvals
- take over domain-local prioritization when ownership is clear
- spawn arbitrary review loops without a trigger

### Human Approval Should Still Gate

- durable engine mutations
- durable canon mutations
- new standing rules or policies promoted from observations
- high-consequence cross-domain queue promotion
- changes to authority thresholds

## Recommended Source-Of-Truth Contract

The CoS should be designed around CapacityOS's existing truth hierarchy.

### Read By Default

- `local/canon/domains/capacityos.md`
- `local/canon/domains/*.md`
- `local/canon/decisions/*.md`
- `local/runtime/backlog/`
- `local/runtime/queue/`
- `local/runtime/bundles/`
- `local/runtime/reviews/`
- `local/runtime/issues/`
- `local/runtime/artifacts/`
- `local/runtime/runs/`
- generated indexes or state packets built from those surfaces

### Treat As Canonical

- engine policy in `architecture-lock/`, `docs/`, `templates/`, and `schemas/`
- domain meaning in `local/canon/domains/`
- durable rationale in `local/canon/decisions/`
- live operational state in `local/runtime/`

### Treat As Non-Canonical

- chat transcripts
- one-off agent scratchpads
- generated summaries that are not backed by structured refs
- daily views as the only state surface

## Recommended Memory Architecture

The CoS should use tiered memory with explicit precedence.

### Layer 1: Stable Charter

This is always-load memory.

Contents:

- CoS mission and non-goals
- authority boundaries
- trust-boundary rules
- escalation rules
- source-of-truth precedence
- review-trigger rules

Recommended source:

- engine-owned policy file or prompt asset
- system-governance domain canon

### Layer 2: Registry And Topology

This is compact durable structured memory.

Contents:

- domain registry
- agent registry
- domain classes
- ownership and escalation map
- enabled review profiles

Recommended representation:

- tracked schemas in `schemas/indexes/`
- materialized runtime index in `local/runtime/indexes/`

### Layer 3: Working Operating Summary

This is hot mutable memory for current operating conditions.

Contents:

- top queue items by domain
- active bundles and review packages
- open issues needing escalation
- stale or blocked work
- recent cross-domain collisions
- current health indicators

Recommended representation:

- compiled `cross-domain-state-packet`
- rebuilt from canonical runtime objects rather than hand-edited

### Layer 4: Append-Only Event And Decision History

This is cold memory.

Contents:

- run events
- issue history
- review outcomes
- decision records
- registry changes

Use it for audit, replay, and investigation, not for default prompt loading.

### Layer 5: Promoted Lessons

This is selective durable learning.

Contents:

- standing heuristics that survived repeated review
- trusted playbooks
- approved review-trigger changes
- approved registry-handling rules

Rules:

- promote only with evidence
- record provenance
- support supersession instead of silent overwrite

## Recommended Memory Precedence

When sources conflict, the CoS should resolve them in this order:

1. human approval or explicit human override
2. locked engine policy and durable decision records
3. current domain canon
4. approved promoted rules and registry policy
5. structured runtime state
6. generated summaries and reflections
7. raw historical traces

If conflict cannot be resolved confidently, the CoS should escalate rather than
infer.

## Recommended Supporting Artifacts

The CoS will be much stronger if the builder creates these explicit support
surfaces.

### Canon / Engine-Owned

- `schemas/indexes/domain-registry.schema.json`
- `schemas/indexes/agent-registry.schema.json`
- `schemas/indexes/cross-domain-state-packet.schema.json`
- `templates/agents/chief-of-staff-charter.md`
- `templates/reviews/cross-domain-review-template.md`

### Runtime / Materialized

- `local/runtime/indexes/domain-registry.json`
- `local/runtime/indexes/agent-registry.json`
- `local/runtime/indexes/cross-domain-state-packet.json`
- `local/runtime/reviews/review-cross-domain-<date>.md`
- `local/runtime/issues/issue-system-*.json`

The key design point is that the CoS should read compiled packets first and
drill down into raw runtime objects only when needed.

## Recommended Agent Registry Model

The CoS should own registry governance, but not by embedding all agent state in
its prompt.

Each registry entry should capture:

- `agent_id`
- `agent_type`
- `scope_type`
- `scope_ref`
- `status`
- `authority_tier`
- `default_read_surfaces`
- `default_write_surfaces`
- `review_profile`
- `created_at`
- `updated_at`
- `supersedes` or `superseded_by` when relevant

Recommended agent types:

- `chief-of-staff`
- `domain-steward`
- `ephemeral-worker`
- `reviewer`
- `specialist`

Recommended scope types:

- `system`
- `domain`
- `bundle`
- `review`
- `task`

Lifecycle states should stay small:

- `active`
- `paused`
- `retired`
- `shadow`

The registry should exist so the system can reason about agent responsibility
without inventing it from scratch each run.

## Recommended CoS Workflows

### 1. Build Daily Operating Picture

1. Read the cross-domain state packet.
2. Identify top queue work, review packages, and human-required actions.
3. Surface only the highest-value cross-domain summary.
4. Link every surfaced item back to canonical refs.

### 2. Handle Ambiguous Intake Or Domain Ownership

1. Intake creates a receipt and triage proposals.
2. If the domain is unclear or spans domains, CoS reviews the ambiguity.
3. CoS assigns ownership, splits the work, or escalates to human review.
4. The resulting work is routed into the proper domain backlog or system
   backlog.

### 3. Run Cross-Domain Review

1. Read comparable review outputs from each domain.
2. Look for systemic failure patterns, stale domains, or overloaded human
   checkpoints.
3. Create a review package in the system-governance domain.
4. Route system-improvement work into backlog rather than mutating policy
   directly.

### 4. Govern Agent Lifecycle

1. Activate anchored stewards for active domains.
2. Track ephemeral workers and reviewers by scope and status.
3. Pause or retire stale profiles.
4. Route repeated worker failures into issue tracking or policy review.

### 5. Learn From Outcomes

1. Observe run events, review findings, and issue patterns.
2. Generate candidate heuristics or policy changes.
3. Keep them provisional until evidence and review justify promotion.
4. Promote only via explicit decision or approved rule update.

## Recommended Review Triggers

The CoS should trigger deeper review only when one of these conditions is true:

- domain ownership is ambiguous
- two domains claim overlapping responsibility
- a queue item conflicts with a system-governance decision
- repeated failure or low-value output appears across domains
- the same review finding appears multiple times
- operating health indicators cross a threshold
- a proposed policy or registry change would affect multiple domains
- a high-impact human consequence step depends on cross-domain alignment

If none of those apply, the CoS should stay lightweight.

## Recommended Health Indicators

The CoS should monitor a compact set of system-health signals:

- queue freshness rate
- false-positive promotion rate
- backlog-to-queue conversion rate
- issue recurrence rate
- stale-domain count
- human review burden
- ratio of draft activity to real-world consequence
- canon/runtime leakage rate

These should guide review and improvement work, not become vanity metrics.

## Recommended Learning And Compaction Policy

The CoS should learn by promotion and supersession, not by accumulating an
ever-growing summary blob.

### Keep Raw

- append-only events
- issue records
- review findings
- decision history

### Summarize Periodically

- working operating summaries
- cross-domain risk picture
- active heuristics with evidence links

### Promote Selectively

- new standing routing rules
- new review triggers
- registry policy
- reusable playbooks

### Retire Explicitly

- stale heuristics
- replaced registry patterns
- superseded reviews or playbooks

Every promoted rule should record:

- what evidence justified promotion
- where the evidence lives
- who approved it
- what it supersedes

## Failure Modes To Avoid

- CoS bottleneck: every task waits for the CoS
- memory sprawl: the CoS prompt becomes the system of record
- coordinator theater: many agent interactions but weak deterministic routing
- silent policy drift: summaries replace decisions without explicit promotion
- review inflation: extra review loops appear without measurable value
- domain erosion: the CoS starts doing the steward's job by default

## Recommended Build Sequence

### Phase 1: Read-Only CoS

Build:

- domain registry
- agent registry
- cross-domain state packet
- read-only daily operating picture

Success criteria:

- CoS can orient from structured state without loading raw history by default
- cross-domain summaries link back to canonical refs

### Phase 2: Escalation And Review

Build:

- ownership ambiguity resolution
- cross-domain review package generation
- issue pattern detection
- health indicator thresholds

Success criteria:

- CoS only intervenes when triggers fire
- review packages are comparable and auditable

### Phase 3: Learning And Registry Governance

Build:

- registry lifecycle operations
- promoted heuristic store
- explicit supersession handling
- outcome-based policy proposals

Success criteria:

- promoted rules have provenance
- stale rules can be retired cleanly
- the CoS remains compact despite longer runtime history

## Acceptance Criteria For The Final Design

The design is good if:

- the CoS can recover after context loss using canon plus structured indexes
- domain-local work usually stays with domain stewards
- cross-domain ambiguity is handled without centralizing everything
- the agent registry is explicit, small, and auditable
- learning happens through reviewed promotion, not free-form memory growth
- human trust improves because the CoS can explain why it surfaced or
  escalated something

## Bottom Line

CapacityOS should use a CoS that is a lightweight cross-domain governor with
tiered memory, explicit registry ownership, and triggered review.

It should sit on top of structured canon and runtime, not replace them.

Its success condition is not "knowing everything." Its success condition is
keeping the system coherent, auditable, and learnable while domain stewards and
deterministic scripts handle most of the local work.
