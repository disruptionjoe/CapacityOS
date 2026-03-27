# Import Rules

## Core rules

1. Never delete source material silently.
2. Never merge active things without proving they are the same thing.
3. Preserve provenance on every normalized object.
4. Treat the manifest as the import contract.
5. Route ambiguity to review instead of inventing answers.

## Engine vs Runtime rules

- Engine imports must be durable policy, schema, template, or adapter content.
- Runtime imports must be mutable state, work records, artifacts, or summaries.
- Runtime state must not define engine policy.

## Privacy rules

- Anything personal, financial, medical, or otherwise sensitive imports to
  `runtime/private/` only.
- Private imports require manual review before promotion into any other home.

## Generated-view rules

- Queue boards and dashboards are regenerated from canonical task, artifact, and
  run state.
- No imported board or summary should become the only source of truth.

## Review queue

Create an explicit review queue when:

- two candidates may represent the same active thing
- a file mixes policy and runtime state
- a draft may belong in a child repo instead of runtime archive
- a private file may need redaction before use
