# CapacityOS

CapacityOS is a modular operating-system pattern for agentic work.

This repo is meant to be readable as a reusable public engine, not just as one
person's live system.

## Status

CapacityOS is pre-alpha and being built in public.

Expect:

- breaking changes
- incomplete engine surfaces
- evolving schemas and examples
- active restructuring as the public engine/private layer boundary gets locked

## Read The Repo As Four Layers

### 1. Engine

The reusable core.

Main folders:

- `architecture-lock/`
- `docs/`
- `schemas/`
- `scripts/`
- `templates/`
- `tests/`
- `normalization/`

This is the part that should be portable and publishable.

### 2. Packs

Curated installable or reference groupings built on top of the engine.

Main folders:

- `packs/`
- `examples/`

Think of this layer as:

- modular domains
- modular runtime seed material
- starter setups that can be mixed, copied, or swapped

The initial starter package should include:

- the system-maintenance / system-governance domain
- at least one sample normal domain
- a small sample runtime seed

### 3. Workbench

Transitional design and migration support material.

Main folder:

- `workbench/`

This is useful while designing, migrating, or pressure-testing the system, but
it is not the core reusable engine.

### 4. Local

The real private overlay for an actual installation.

Main folder:

- `local/` (ignored by git)

This is where real canon, real runtime, and private workspaces belong.

## Public / Private Boundary

The intended public repo should contain:

- the reusable engine
- modular packs and starter-pack definitions
- publishable example domains and decision records
- publishable example runtime artifacts and runtime templates
- transitional workbench material only when it is useful to builders

The intended public repo should not contain:

- your real private domains
- your live private canon
- your live runtime state
- personal attachments or secrets

In this workspace that means:

- `local/` stays ignored
- `packs/` describes starter-pack composition
- `examples/` holds publishable sample domains and runtime examples
- `workbench/` holds staging and migration-support material
- `JoeCapacityOS/` is an ignored legacy reference folder, not part of the new
  repo root

## What lives here

- `architecture-lock/` - the locked operating model and repo-shape rules
- `docs/` - implementation contracts and recommendation docs
- `schemas/` - canonical runtime schemas
- `scripts/` - deterministic tooling and validators
- `templates/` - canonical engine assets such as domain and decision templates
- `packs/` - curated starter-pack definitions and modular composition guidance
- `examples/` - publishable reference domains, decisions, and sample runtime
  artifacts
- `workbench/` - plan and migration-specific material that supports design or
  cutover work
- `local/` - ignored private canon, runtime, and colocated workspaces
- `normalization/` - normalization skills, schemas, and import rules
- `tests/` - frequent-task acceptance scenarios and result templates
- `notes/` - open questions, review notes, and next-session guidance

## Portability Rule

The engine should be removable from this repo and reusable elsewhere.

That means:

- the engine should not depend on your real private domains
- domains should be modular rather than hard-wired into the engine
- runtime should be modular and seedable rather than tracked as live private
  state
- starter packs should be composable from publishable sample assets

Treat the current `JoeEA/` workspace as the source system for migration work.

Treat this repo as the reusable engine plus starter-pack and workbench material.

## Current direction

The locked Phase 1 model is:

- `containment` = engine
- `coherence` = canon via domains
- `flow` = runtime

That means:

- tracked files define reusable engine structure
- domains live as modular canon objects
- runtime lives as modular operational objects
- the live private installation still belongs under `local/`

## Starter Pack

The first public starter-pack shape should include:

- the `capacityos` system-governance domain
- one normal sample domain such as `harbor-garden`
- the matching example decision-record collections
- a small sample runtime seed that shows intake, triage, backlog, queue, and
  bundle formation

See:

- `packs/starter/`
- `examples/domains/`
- `examples/decisions/`
- `examples/runtime/`

The real private system should continue to run from ignored local layers rather
than from tracked example state.
