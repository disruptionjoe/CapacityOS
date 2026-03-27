# 08 - Decision Log

## Locked Decisions

### D001 - Containment / Coherence / Flow

Status: locked

CapacityOS is organized as:

- containment = engine
- coherence = canon via domains
- flow = runtime

### D002 - Public Engine, Local Canon, Local Runtime

Status: locked

The engine is publishable. Durable private canon and mutable runtime remain
local and ignored.

### D003 - Domain As Primary Coherence Object

Status: locked

Domains replace projects as the primary coherence/governance objects. Projects
and repos are subordinate execution contexts.

### D004 - Reserved System-Governance Domain

Status: locked

CapacityOS includes a reserved system-governance domain, while the
engine/runtime substrate remains outside the domain ontology.

### D005 - Domain Class Is Engine-Defined

Status: locked

Domain `class` is a small engine-defined handling profile, not free-form
descriptive metadata.

### D006 - Engine Owns Cadence

Status: locked

The engine detects cadence, routes review to the correct skill, and surfaces a
queued human review object. Domains do not define cadence policy.

### D007 - Canonical Domain Shape

Status: locked

Domain canon is system-readable first and human-auditable second, with minimal
YAML front matter and schema-shaped authoritative sections.

### D008 - System 1 Is An Execution Contract

Status: locked

System 1 in domain canon contains operational goals plus the execution
contract. It is not a live execution surface.

### D009 - Goals Are Cross-Level Objects

Status: locked

Goals are a reusable object shape inside domains, with level-dependent
semantics rather than one flat undifferentiated goal class.

### D010 - Intake Is Intake-First

Status: locked

Conversation is a valid intake surface. Intake defaults to `^que`. `^now`
requires explicit intent and changes speed, not authority.

### D011 - Backlog And Queue Are Different Trust Surfaces

Status: locked

Backlog may be mixed-origin and noisy. Endorsement state matters. Queue
promotion is the stronger trust boundary for active execution.

### D012 - Human Charge Is Selective

Status: locked

Primary human-charge checkpoints are intake, queue promotion, and real-world
consequence. Triage is a conditional resilience layer.

### D013 - Bundle Readiness Is First-Class

Status: locked

Package-level readiness is a first-class reviewable object, distinct from
individual task validity.

### D014 - Durable Mutation Requires Approval

Status: locked

Autonomous drafting is allowed, but durable mutation of engine or canon
requires human approval.

## Next-Phase Questions

These are important, but not blockers for the Phase 1 lock:

1. what explicit authority and permissions model should govern create/edit/
   promote/publish rights?
2. what compact observability surface should explain why something was surfaced
   or ranked?
3. what retention and compaction policy should keep runtime from recreating
   sprawl?
4. what cross-domain dependency model should govern multi-domain work?
