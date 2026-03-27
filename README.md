# CapacityOS

This folder is the greenfield staging workspace for CapacityOS.

It exists so the new system can be designed, reviewed, and tested before
anything in the live `JoeEA/` workspace is migrated.

## Status

CapacityOS is pre-alpha and being built in public.

Expect:

- breaking changes
- incomplete engine surfaces
- evolving schemas and examples
- active restructuring as the public engine/private layer boundary gets locked

## Public / Private Boundary

The intended public repo should contain:

- the reusable engine
- locked architecture docs
- templates
- schemas
- tests
- publishable example domains and decision records
- publishable example runtime artifacts and runtime templates

The intended public repo should not contain:

- your real private domains
- your live private canon
- your live runtime state
- personal attachments or secrets

In this workspace that means:

- `local/` stays ignored
- `examples/` is the place for publishable sample domains and runtime examples
- `JoeCapacityOS/` is an ignored legacy reference folder, not part of the new
  repo root

## What lives here

- `00-plan.md` - the implementation plan for this staging workspace
- `architecture-lock/` - the proposed operating model and lock docs
- `docs/` - implementation contracts and recommendation docs for future system capabilities, including agent design targets
- `templates/` - canonical engine assets such as domain and decision templates
- `examples/` - publishable reference domains, decision records, and sample
  runtime artifacts
- `local/` - ignored private canon, runtime, and colocated workspaces
- `migration-bundles/` - bundle definitions plus a first-pass import manifest
- `normalization/` - normalization skills, schemas, and import rules
- `tests/` - frequent-task acceptance scenarios and result templates
- `notes/` - open questions, review notes, and next-session guidance

## Working rule

Treat the current `JoeEA/` workspace as the source system.

Treat this folder as the clean-room design and migration workspace for CapacityOS.

Nothing here should require destructive changes to the live system.

## Current direction

The locked Phase 1 model is:

- `containment` = engine
- `coherence` = canon via domains
- `flow` = runtime

That means:

- tracked files define reusable engine structure
- local canon holds real domain governance objects
- local runtime holds live intake, backlog, queue, reviews, runs, and artifacts

## Publishing Direction

The public repo root should be this folder: `CapacityOS/`.

The public teaching surface should include at least:

- one sample domain in `examples/domains/`
- its decision-record collection in `examples/decisions/`
- a small example runtime pack in `examples/runtime/`

The real private system should continue to run from ignored local layers rather
than from tracked example state.
