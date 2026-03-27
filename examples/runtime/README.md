# Runtime Examples

This folder contains publishable example runtime artifacts for CapacityOS.

These files are not meant to be the live runtime for a real user.

Their job is to:

- show the intended object shapes in a public repo
- teach the lifecycle from intake through queue and bundle formation
- give builders and contributors concrete examples to validate against

These examples should stay:

- synthetic
- small
- publishable
- schema-aligned

They should not be treated as:

- a user's real runtime state
- the only source of truth for runtime design
- a substitute for the schemas in `schemas/runtime/`

The real private runtime for a user belongs under the ignored `local/` layer.
