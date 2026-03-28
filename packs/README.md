# Packs

Packs are the modular layer that sits on top of the reusable CapacityOS
engine.

Use this folder to describe curated combinations of:

- domains
- decision collections
- runtime seed material
- operating-model defaults

The idea is:

- the engine is portable
- packs are composable
- a user can start from a curated starter pack rather than from a blank system

In this repo:

- `packs/starter/` describes the initial public starter pack
- `examples/` holds the publishable example assets that those packs can draw
  from

Packs should not be confused with:

- the user's live private canon
- the user's live runtime
- one-off migration workbench material
