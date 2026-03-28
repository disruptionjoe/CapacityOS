# Starter Pack

This folder describes the first public starter pack for CapacityOS.

The starter pack is the recommended "day 1" setup for a fresh installation.

## Intent

The starter pack should prove three things:

- the engine works without private Joe-specific data
- domains are modular rather than hard-coded into the engine
- runtime can be seeded from small publishable examples rather than from a real
  private operating history

## Starter Pack Contents

### 1. System-maintenance domain

The starter pack includes the CapacityOS system-governance domain so the system
can govern and improve itself.

Primary references:

- `examples/domains/capacityos-system-governance.example.md`
- `examples/decisions/capacityos-system-governance-decisions.example.md`

### 2. Sample normal domain

The starter pack includes one normal sample domain so the system is not only
tested against its own governance layer.

Primary references:

- `examples/domains/harbor-garden.example.md`
- `examples/decisions/harbor-garden-decisions.example.md`

### 3. Sample runtime seed

The starter pack includes a small publishable runtime seed that shows the
intake-to-queue path.

Primary references:

- `examples/runtime/harbor-garden/`

## How To Read This

- the engine defines the rules and structures
- the pack defines what gets bundled together for a fresh start
- the examples provide the concrete publishable assets
- the real private installation still lives under `local/`

## Near-Term Direction

Later, packs may become more formalized with manifests or install scripts.

For now, this folder is the explicit declaration that CapacityOS is meant to be
portable as:

- engine
- pack
- private local overlay
