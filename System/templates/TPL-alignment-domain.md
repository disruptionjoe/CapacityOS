# DEPRECATED: Alignment Domain Template

This template is no longer used. The CapacityOS system has migrated from per-domain subfolders to a flat workstream-based model.

## Migration Notes

The old domain-based structure:
```
Alignment/
  Health/
    system5_purpose.md
    system4_strategy.md
    system3_optimization.md
    system2_coordination.md
    system1_workstreams.md
```

Has been replaced with a flat workstream model:
```
Alignment/
  system1_workstreams.json      # Canonical workstream definitions
  system2_coordination.md       # Cross-system coordination
  system3_optimization.md       # System optimization metrics
  system4_strategy.md           # Strategic direction
  system5_purpose.md            # System purpose and identity
```

## What Changed

- **OLD:** `alignment_domain` field on ACT/IBX files, Alignment/{domain}/ subfolders, domains as organizational concept
- **NEW:** `workstream` field on ACT/IBX files, Alignment/ is flat with system1-5 files, workstreams are the atomic unit
- **Workstream IDs:** Come from `Alignment/system1_workstreams.json`

## For Creating New Workstreams

Edit `Alignment/system1_workstreams.json` directly and add new workstream entries. The system will auto-discover them for use in ACT files.
