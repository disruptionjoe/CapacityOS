# Decision Record Template

Use this file shape for durable decision provenance.

This file holds the full decision object that domains should reference through
structured `decision_ref` fields. Domains keep only compact current-effect
summaries inline. Full rationale, current effect, and supporting basis belong
here.

## Usage Notes

- Use stable kebab-case `decision_id` values.
- Keep one decision record collection per domain unless there is a clear reason
  to split further.
- The domain file should answer what is true now.
- The decision record should answer what was decided, why it matters, and what
  current effect remains in force.

## Canonical Shape

```md
# [Domain Name] Decision Records

Use this file as the authoritative target for `decision_ref` values in the
related domain file.

## [decision-id]
- title: [Decision title]
- status: [active | draft | superseded | retired]
- decision: [The durable decision statement]
- current_effect:
  - [What is true now because of this decision]
- source_basis:
  - [Canonical discussion, review package, or architecture basis]

### Notes (Optional, non-authoritative)
- rationale: [Optional explanation]
- supersedes:
  - [Optional earlier decision id]
- related_refs:
  - [Optional canonical references]
```

## Reference Rule

For canonical use in a domain file:

- `decision_ref.decision_id` must exactly match one bracketed decision heading
  in this file
- `decision_ref.source_ref` must point to this file or another authoritative
  decision record collection
- broad unscoped references are not sufficient
