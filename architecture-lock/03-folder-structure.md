# 03 - Folder Structure

## Target Workspace Shape

This is the preferred Phase 1 structure for the CapacityOS workspace.

```text
CapacityOS/
  README.md
  .gitignore

  architecture-lock/
  docs/
  packs/
    starter/
  examples/
    domains/
    decisions/
    runtime/
  normalization/
  schemas/
  scripts/
  templates/
  tests/
  notes/
  workbench/
    00-plan.md
    migration-bundles/

  local/                     # ignored by git
    canon/
      domains/
      decisions/
    runtime/
      intake/
      triage/
      backlog/
      queue/
      bundles/
      reviews/
      artifacts/
      runs/
      issues/
      views/
      archive/
    workspaces/
      repos/
```

## Boundary Rules

- the tracked repo is the engine
- `packs/` defines curated starter-pack composition
- `examples/` is publishable reference material, not live private canon
- `workbench/` holds transitional migration/design support, not the core engine
- `local/canon/` holds durable private coherence objects
- `local/runtime/` holds mutable operational state
- `local/workspaces/repos/` holds subordinate repos or workspaces when they are
  colocated with CapacityOS

## Naming Rules

- the exact internal file schema may evolve
- the engine/canon/runtime boundary may not collapse
- domains belong in canon, not runtime
- live backlog, queue, and run history belong in runtime, not canon
- example domains are examples, not the user's real operating state

## Why This Tree Works

- it keeps the publishable engine clean
- it gives starter-pack material a clear home
- it keeps local canon durable and inspectable
- it keeps runtime fast and discardable where appropriate
- it supports a same-workspace local private layer without polluting git
- it makes room for migration support without making migration material look
  like core engine structure

## What This Replaces

- project declarations as the primary coherence layer
- mixed tracked/untracked task systems
- runtime state hidden inside engine docs
- queue logic embedded in hand-maintained markdown boards

## Scannability Rule

At the root, the answer to "what lives here?" should be clear in ten seconds:

- engine here
- packs here
- workbench here
- examples here
- local canon here
- local runtime here
- child repos here
