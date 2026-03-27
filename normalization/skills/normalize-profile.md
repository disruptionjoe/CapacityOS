# Skill: normalize-profile

## Purpose

Import personal profile material into runtime/private with explicit review.

## Input

- sensitive profile file

## Output

- normalized private profile artifact

## Steps

1. Confirm file is sensitive or personal.
2. Preserve original text.
3. Normalize only for structure and metadata.
4. Store under runtime/private.
5. Mark for manual review before any reuse.

## Rules

- Never import sensitive material to tracked engine paths.
- Never redact or summarize away important personal context without keeping the original.
