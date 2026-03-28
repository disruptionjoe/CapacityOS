# Index Examples

This folder contains publishable examples of CapacityOS "hot memory" objects.

These examples are not a live runtime. They are compact compiled packets and
registries that show what agents should load first before drilling into raw
canon or runtime state.

In a real installation, the materialized versions of these files should live
under:

- `local/runtime/indexes/`

In the public repo, these examples exist to make the memory contract readable,
portable, and testable without exposing any private runtime.
