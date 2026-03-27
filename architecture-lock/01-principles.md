# 01 - Principles

## Purpose

These principles define the non-negotiable architecture of CapacityOS.

If a future file, flow, or automation conflicts with these rules, the system is
drifting.

## Primary Architecture

CapacityOS is organized as:

- `containment`
- `coherence`
- `flow`

### Containment

Containment is the engine.

It owns reusable structure:

- schemas
- templates
- review skills
- cadence logic
- notation support
- automation patterns
- architecture docs

It does not own:

- private domains
- live backlog or queue state
- in-progress execution
- domain-specific decisions that belong in local canon

### Coherence

Coherence lives in durable canon.

Its primary object is the `domain`.

Domains own:

- purpose
- boundaries
- goals
- evaluative control
- coordination rules
- execution contract
- compact current-effect decisions

Domains do not own:

- engine cadence policy
- live queue state
- recent run history
- orchestration mechanics

### Flow

Flow is runtime.

It owns:

- intake
- triage
- backlog
- queue
- bundles
- review packages
- artifacts
- runs
- issues
- generated views

Flow does not own:

- durable domain meaning
- engine policy
- publishable architecture rules

## Public Engine And Local Layers

CapacityOS should support:

1. a public engine core
2. public example packs
3. a local private canon layer
4. a local private runtime layer

Rules:

- the engine repo must remain safe to publish
- private canon and runtime stay local and ignored
- private canon and runtime are separate layers
- project or repo context is subordinate to the domain/coherence layer

## Domain Policy

- `domain` is the primary coherence/governance object
- projects and repos are subordinate execution contexts
- each domain has exactly one primary steward agent at a time
- domains may declare a small engine-defined `class`
- class changes bounded engine handling, not the meaning of what a domain is
- CapacityOS includes a reserved `system-governance` domain
- the engine/runtime substrate itself is not modeled as an ordinary domain

## Canonical Object Policy

The system should prefer a small number of explicit object types with clear
promotion paths.

Core objects:

- domain
- goal
- decision record
- intake receipt
- triage proposal
- backlog item
- queue item
- bundle
- review package
- issue
- artifact
- run

`Human-required` is a cross-cutting operational property, not a primary
ontology class.

## Intake And Queue Policy

- conversations are valid intake surfaces by default
- the system preserves structured outcomes of conversation, not full transcripts
  by default
- intake creates a lightweight intake receipt before routing
- default intake behavior is `^que`
- `^now` always requires explicit user intent
- `^now` means fast-path handling, not authority override

The intake pipeline is:

1. intake
2. triage
3. backlog
4. queue
5. execution
6. consequence
7. return edge into intake

Additional rules:

- human-originated intake may require visible triage before backlog entry
- agent-generated items may enter backlog more freely
- backlog may be large and partially noisy
- backlog items carry endorsement state
- queue promotion is the stronger trust boundary

## Human Charge Policy

Human attention is selectively applied charge, not universal supervision.

The three primary human-charge checkpoints are:

- intake
- queue promotion
- real-world consequence

Additional rules:

- triage is a conditional resilience layer, not a universal gate
- the system should surface what only the human can do now
- human-required work remains a first-class operational surface
- the human often acts as both actuator and sensor at the real-world boundary

## Review And Cadence Policy

- the engine owns cadence
- the human does not need to remember review timing
- domains do not carry their own cadence policy
- review skills interpret what a cadence means for a given domain
- scheduled review outputs should become queued human review tasks at the right
  control surface

The clean split is:

- engine = timing, routing, initiation
- skill = review logic and preparation
- queue = surfaced review object
- human = judgment, approval, correction

## Mutation Policy

- runtime may mutate during normal operation
- autonomous drafting and candidate generation are allowed
- durable mutation of engine or canon requires human approval
- high-severity cases may interrupt normal flow
- system improvements should usually enter the improvement loop before becoming
  durable change

## Source-Of-Truth Policy

Every concept should have one canonical home.

Generated views are allowed.

They must remain views, not competing truth surfaces.

If a thing can be regenerated from canonical engine, canon, or runtime state,
it is not the source of truth.

## System-Readable Canon Policy

Canonical objects should be optimized for:

- machine legibility
- deterministic parsing
- inspectable structure

Human auditability is non-negotiable, but human-friendly rendering is a later
layer rather than the primary design target for stored canon.

## Portability And Recovery

- platform adapters should change execution mechanics more than reasoning
- migration should be copy-first and non-destructive by default
- the engine repo should be recoverable without losing local canon or runtime
- stale project-centric structures should not be preserved merely for
  familiarity
