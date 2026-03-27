# Skill: classify-source

## Purpose

Classify one source file or directory using the manifest contract.

## Input

- source path
- matching manifest row

## Output

- canonical type
- import destination
- confidence
- review-needed flag

## Steps

1. Read the manifest row.
2. Read the source item.
3. Decide whether it is engine, runtime, private, archive, or drop.
4. If it mixes concerns, flag it for review.
5. Emit a classification record with provenance.

## Rules

- Do not convert yet.
- Do not guess through ambiguity.
- Prefer review over silent misclassification.
