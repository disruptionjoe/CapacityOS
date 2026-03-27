# Skill: normalize-artifact

## Purpose

Convert drafts and outputs into canonical artifacts linked to a task and
project.

## Input

- source artifact
- linked task id if known

## Output

- canonical artifact record

## Steps

1. Determine artifact type.
2. Determine review state.
3. Link to task and project.
4. Preserve source location in provenance.
5. Place unresolved artifacts into review-ready import queue.

## Rules

- Every active artifact must point back to one task.
- Artifact review status must not live only in a log entry.
