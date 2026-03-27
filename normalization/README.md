# Normalization

This folder defines how source-system material becomes clean engine or runtime
objects in CapacityOS.

The normalization layer exists because the current source system mixes:

- engine policy
- mutable work state
- historical artifacts
- project repo content
- private information

## What is here

- `skills/` - skill specs for classifying and converting imports
- `schemas/` - canonical object schemas
- `samples/` - place for future sample bundle imports
- `import-rules.md` - shared rules for every normalization pass

## Success criteria

- every imported file ends up with a clear canonical home
- provenance is preserved
- ambiguous files go to review, not guesswork
- sensitive material never lands in tracked paths automatically
