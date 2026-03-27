# Migration Bundles

This folder defines the drag-over bundles for harvesting content from the
current JoeEA source system.

The bundle folders are intentionally organized by import behavior, not by the
old live layout.

## Bundle groups

- `01-personal-canon/` - durable operating logic and durable non-sensitive personal canon
- `02-project-canon/` - project repos and durable project-facing documents
- `03-runtime-active/` - live state worth normalizing into the new runtime
- `04-runtime-reference/` - useful history and legacy reference
- `05-private-manual/` - sensitive material that requires manual review
- `06-ignore-or-drop/` - dead weight or residue not worth importing

## Files to review first

- `manifest.csv`
- `manifest-notes.md`
- `source-inventory.txt`

Those two files are the primary migration map for the first pass.

`source-inventory.txt` is a source-system snapshot so the staging workspace can
be moved elsewhere without immediately needing another manual scan of the live
JoeEA tree.
