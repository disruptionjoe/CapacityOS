# Skill: normalize-plan

## Purpose

Convert plan-like source files into scoped plan artifacts linked to canonical
tasks.

## Input

- source file
- linked task id if known

## Output

- plan artifact

## Steps

1. Determine whether the file is truly a plan or actually a prompt, agenda, or reference.
2. If it is a plan, link it to the correct task.
3. If it is not a plan, route it to a better home.
4. Preserve original content and provenance.

## Rules

- Plans are not the queue.
- Do not leave prompts or agenda docs mixed into the canonical plans area.
