# Skill: validate-import

## Purpose

Validate a normalized import batch before it is trusted.

## Input

- imported bundle
- canonical records produced

## Output

- validation summary
- error list
- review queue

## Steps

1. Check required fields against schemas.
2. Check task-artifact-project links.
3. Check engine files are tracked-only material.
4. Check private imports stayed private.
5. Report duplicates, missing links, and unresolved ambiguity.

## Rules

- A failed validation never silently passes.
- Review queues are expected and should stay visible.
