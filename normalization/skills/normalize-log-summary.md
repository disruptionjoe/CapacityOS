# Skill: normalize-log-summary

## Purpose

Import run logs and summaries as canonical run-linked records without making
them the primary source of live state.

## Input

- legacy log or summary

## Output

- run record
- summary record
- provenance link

## Steps

1. Identify date, run type, and referenced work.
2. Preserve the original log text.
3. Extract only reliable metadata into canonical run or summary fields.
4. Leave uncertain references as notes, not hard links.

## Rules

- Logs are historical evidence, not the only state store.
- Do not infer task status from a log unless the evidence is clear.
