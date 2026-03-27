# Skill: normalize-task

## Purpose

Convert source-system work records into canonical task records.

## Input

- source file
- manifest row
- project context if known

## Output

- canonical task object

## Steps

1. Extract the work title and project/domain.
2. Determine current lifecycle state.
3. Attach origin and provenance.
4. Link any related plan or artifact references.
5. Write a canonical task record.

## Rules

- A task record is the source of truth for active status.
- If two files may be the same task, route to review.
