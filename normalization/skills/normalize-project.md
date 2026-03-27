# Skill: normalize-project

## Purpose

Convert project-facing source material into a canonical project declaration or
project reference file.

## Input

- classified project source
- target project id

## Output

- project declaration or reference artifact

## Steps

1. Extract project identity, purpose, voice, repo path, and automation limits.
2. Write or update the project declaration.
3. Attach provenance metadata.
4. Route uncertain project rules to review instead of hard-coding them.

## Rules

- Do not embed shared lifecycle policy in a project declaration.
- Keep project declarations concise and local.
