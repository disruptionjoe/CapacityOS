# Manifest Notes

## How to use `manifest.csv`

- One row describes one migration candidate.
- `bundle` tells you which drag-over bucket it belongs to.
- `disposition` tells the normalization phase what kind of handling is expected.
- `target_home` points at the future canonical destination.
- `notes` capture ambiguity or guardrails.

## Disposition meanings

- `migrate` - carry over mostly as-is, then refine in place
- `normalize` - convert into the new canonical object model
- `rewrite` - preserve the intent, but not the old file shape
- `archive` - keep searchable, but do not reactivate by default
- `drop` - leave out of the new system

## Current assumption

This manifest is a first-pass classification based on the architecture audit.

It is meant to be reviewed, corrected, and then used as the harvest guide for
the real migration.
