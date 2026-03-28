# CapacityOS Plan Update Recommendation

Date: 2026-03-24

## Verdict

The current plan is strong on copy-first migration, generated-view discipline,
and the basic engine-vs-runtime split.

The main gap is that it still treats Joe-specific operating logic and
project/domain content as if they are part of the engine itself. That makes the
system harder to separate from its contents, harder to scale across new repos
and domains, and less deterministic for agent workflows than it should be.

## Review Summary By Lens

### System engineer lens

What is working:

- engine and runtime are already separated in principle
- mutable state is not meant to leak into tracked history
- generated views are not treated as canonical state

What should change:

- split the architecture into explicit modules, not just three harness layers
- stop hard-coding project folders into the target tree
- add one registry that maps engine root, runtime root, mounted repos, and
  active packs

Recommendation:

Treat CapacityOS as five modules:

1. platform adapters
2. engine core
3. operating-model pack
4. project/domain packs
5. runtime state

This preserves the current direction while making the engine portable and the
contents removable.

### Senior software engineer lens

What is working:

- the plan already prefers canonical task state over queue tables
- normalization is being separated from migration bundles
- platform parity is already a stated goal

What should change:

- tighten the schemas so different agents cannot improvise incompatible shapes
- define a real state machine instead of only a list of statuses
- make runs idempotent and replay-safe
- make skills operate as a bounded pipeline with strict input/output contracts

Recommendation:

Use a deterministic pipeline:

1. classify
2. extract
3. normalize
4. validate
5. build views

Each step should declare:

- required inputs
- allowed outputs
- stop conditions
- review/failure route
- schema version

Canonical records should be structured and versioned. Markdown should be used
for human-facing content, not as the primary machine contract.

### UX designer lens

What is working:

- shelves are a strong presentation layer
- the plan protects Joe from needing to learn internals
- generated boards fit the intended mental model

What should change:

- keep shelf vocabulary universal across projects
- make the system explain "why this is here" in every main view
- keep project onboarding to one declaration path
- enforce progressive disclosure so summaries stay short by default

Recommendation:

Use internal technical states, but always map them into a small stable
Joe-facing surface:

- Inbox
- Thinking
- Tonight
- Waiting on Joe
- Review
- Done

Projects and repos should feel like filters and mounts, not like separate UX
systems.

## Main Risks In The Current Plan

1. The current "personal" and "project" harness layers still behave like engine
   content, even though they are really operating-model and domain packs.
2. The proposed folder tree hard-codes current projects, which will not scale
   cleanly as repos and domains are added or removed.
3. The schemas are too loose for deterministic agent execution.
4. The normalization skills are too open-ended to be token-efficient at scale.
5. The plan does not yet define how the system compounds safely over time.

## Suggested Plan Update

### Replace the current architecture framing

Instead of:

- platform harness
- personal harness
- project harness

Use:

- platform adapters
- engine core
- operating-model pack
- project/domain packs
- runtime

This keeps the engine reusable while allowing the Joe-specific model and
project-specific packs to evolve independently.

### Add a workspace registry

Add one tracked workspace manifest that defines:

- engine root
- runtime root
- mounted repo roots
- active operating-model pack
- active project/domain packs

All adapters should resolve paths through this registry instead of assuming a
fixed root layout.

### Tighten canonical data contracts

Before migration work begins, add:

- `schema_version` on every canonical object
- enums for task status and approval state
- explicit timestamp format rules
- explicit transition guards
- explicit run identity and retry rules

Once the model settles, switch schemas toward closed shapes instead of allowing
arbitrary properties.

### Make skills cheaper and more deterministic

Rewrite normalization skills as workflow specs with:

- minimal required context
- metadata-first loading
- body content loaded only when necessary
- strict output targets
- explicit ambiguity handling

This reduces token usage and makes different agents more likely to converge on
the same result.

### Separate compounding knowledge from engine policy

Add a local runtime area for observations and reviewer feedback, then require a
promotion step before those observations become tracked policy.

Suggested new runtime area:

- `runtime/observations/`

This lets CapacityOS compound over time without letting ad hoc runtime patterns
silently rewrite the engine.

## Suggested Revised Phase Order

### Phase 1 - Boundary and contract lock

Lock:

- module boundaries
- workspace registry shape
- pack interfaces
- canonical object formats
- lifecycle transition table
- run idempotency rules

### Phase 2 - Topology and entrypoint lock

Lock:

- target folder/package layout
- platform adapter entrypoints
- repo mount model
- project onboarding path

### Phase 3 - Deterministic normalization pipeline

Build:

- stricter schemas
- extraction/classification pipeline
- validation rules
- ambiguity review queue
- generated views from canonical records

### Phase 4 - Migration bundles

Keep the existing bundle strategy, but classify against the revised contracts.

### Phase 5 - Acceptance and parity tests

Add:

- scenario tests
- state-transition tests
- idempotency tests
- adapter parity tests
- summary/golden-output tests

### Phase 6 - Compounding loop

Define:

- what observations can be captured locally
- how they are reviewed
- how they are promoted into tracked packs

## Suggested Target Shape

```text
CapacityOS/
  workspace.manifest.json

  engine/
    core/
    adapters/
    schemas/
    scripts/
    templates/
    docs/

  packs/
    operating-models/
      joe/
    projects/
      <project-id>/

  runtime/              # ignored by git
    records/
      tasks/
      plans/
      artifacts/
      runs/
      summaries/
    views/
    imports/
    observations/
    private/

  mounts/               # ignored by git
    <repo-name>/
```

## Files To Revisit Next

- `workbench/00-plan.md`
- `architecture-lock/01-principles.md`
- `architecture-lock/03-folder-structure.md`
- `architecture-lock/04-entity-model.md`
- `normalization/schemas/*.json`
- `normalization/skills/*.md`
