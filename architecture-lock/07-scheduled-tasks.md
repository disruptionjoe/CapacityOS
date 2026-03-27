# 07 - Scheduled Tasks

## Goal

The engine should make cadence operationally automatic.

Humans should not need to remember when a review is due. The engine should
detect cadence, invoke the right review skill, prepare the review object, and
surface the resulting work at the correct control surface.

## Core Starter Suite

The bootstrap setup should install only the core engine-wide cadence
automations first.

| Cadence | Engine action | Primary output |
| --- | --- | --- |
| Daily | Generate the daily operating view | updated runtime operating view |
| Daily | Run System 2 coordination pass | queue and coordination adjustments, if needed |
| Weekly | Run System 3 control review | review package for prioritization/pruning judgment |
| Monthly | Run System 4 strategic review | review package for strategy and direction |
| Quarterly | Run System 5 identity review | review package for purpose/boundary review |
| Weekly | Run external insight review | candidate improvement items for the system-improvement backlog |

System 1 is continuous execution, not a scheduled governance cadence.

## Review Execution Model

The clean split is:

- engine = timing, routing, initiation
- skill = review interpretation and preparation
- runtime = stores packages, queue items, artifacts, and run records
- human = judgment at the right control surface

Review flow:

1. engine detects due cadence
2. engine invokes the appropriate review skill
3. the skill may perform supporting agent work
4. runtime stores the review package
5. a high-priority human review task is surfaced in the normal flow

## Adapter Rules

- platform adapters stay thin
- adapters should call stable engine entrypoints
- adapters should not own domain-specific review logic
- adapters should not encode private queue behavior directly

## Bootstrap Rules

- install only engine-wide cadence automations on day 1
- add domain-specific automations later as domains mature
- weekly insight review should create candidate improvements, not direct durable
  mutations
- automations should strengthen the normal operating rhythm, not create a second
  hidden workflow

## Mutation Rules

- scheduled tasks may create runtime state automatically
- scheduled tasks may draft or prepare candidate changes automatically
- scheduled tasks may not silently mutate durable engine or canon without human
  approval

## Acceptance Check

After setup, the system should answer these questions cleanly:

- what cadence is due
- which skill handled it
- what review object was produced
- what human task was surfaced
- what runtime state changed
