# 03 - Folder Structure

## Target Workspace Shape

This is the preferred Phase 1 structure for the CapacityOS workspace.

```text
CapacityOS/
  00-plan.md
  README.md
  .gitignore

  architecture-lock/
  docs/
  examples/
    domains/
    decisions/
  normalization/
  schemas/
  scripts/
  templates/
  tests/
  notes/

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
- `examples/` is publishable reference material, not live private canon
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
- it keeps local canon durable and inspectable
- it keeps runtime fast and discardable where appropriate
- it supports a same-workspace local private layer without polluting git
- it makes room for public examples without confusing them with real private
  domains

## What This Replaces

- project declarations as the primary coherence layer
- mixed tracked/untracked task systems
- runtime state hidden inside engine docs
- queue logic embedded in hand-maintained markdown boards

## Scannability Rule

At the root, the answer to "what lives here?" should be clear in ten seconds:

- engine here
- examples here
- local canon here
- local runtime here
- child repos here
