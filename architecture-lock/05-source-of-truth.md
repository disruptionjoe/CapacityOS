# 05 - Source Of Truth

## Canonical Ownership Table

| Concept | Canonical home | Notes |
| --- | --- | --- |
| Engine policy | tracked engine docs/templates/schemas | publishable |
| Cadence rules | tracked engine review skills and automation logic | engine-owned |
| Domain record | `local/canon/domains/` | durable private canon |
| Decision record | `local/canon/decisions/` | full rationale/provenance |
| Intake receipt | `local/runtime/intake/` | preserved raw intake state |
| Triage proposal | `local/runtime/triage/` | interpretation before promotion |
| Backlog item | `local/runtime/backlog/` | mixed-origin potential work |
| Queue item | `local/runtime/queue/` | trusted active work |
| Bundle/review package | `local/runtime/bundles/` and `local/runtime/reviews/` | review boundary surfaces |
| Artifact state | `local/runtime/artifacts/` | execution outputs |
| Run history | `local/runtime/runs/` | append-only event history |
| Issue log | `local/runtime/issues/` | feeds improvement loop |
| Operating views | `local/runtime/views/` | generated surfaces |
| Example domains/decisions | `examples/` | publishable reference only |
| Child repo code/docs | subordinate repos in `local/workspaces/repos/` or elsewhere | separate history |

## Rule For Conversation-Derived State

Conversation is an intake surface, not the source of truth by itself.

Canonical state should preserve structured outcomes such as:

- intake receipts
- triage proposals
- backlog items
- queue items
- review packages
- decision summaries

Raw transcripts are not canonical by default.

## Rule For Generated Views

If a view can be regenerated from canonical engine, canon, or runtime state, it
is not the source of truth.

Examples:

- daily operating views
- Joe-only task lists
- top-of-backlog surfacing views
- morning or review summaries

## Rule For Canon

If a thing explains durable meaning, boundaries, policy, goals, or execution
contract for a domain, it belongs in canon.

Canon should not absorb:

- live queue order
- current in-progress state
- recent run logs
- mutable automation state

## Rule For Runtime

If a thing reflects what is happening now, what is being considered now, or
what just happened, it belongs in runtime.

Runtime should not silently become durable governance.

## Rule For Decision Provenance

Compact decision summaries may appear in a domain.

The full decision record remains canonical elsewhere.

The domain summary and the decision record must not become competing truth
surfaces.

## Rule For Examples

Publishable examples should teach the system.

They should not be confused with:

- real private domains
- real private runtime
- the user's live queue or backlog
