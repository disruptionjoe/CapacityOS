# 06 - Common Flows

## 1. Human Conversational Intake

1. A conversation, note, or raw request enters the system.
2. Runtime creates an intake receipt.
3. Default routing is `^que` unless explicit notation says otherwise.
4. High-temperature extraction creates triage proposals.
5. If the source is human intake and interpretation risk matters, the human may
   quickly confirm, reject, split, or correct the proposals.
6. Approved proposals become backlog items with provenance and endorsement
   state.

## 2. Agent-Originated Backlog Creation

1. An agent notices a useful opportunity, dependency, issue, or follow-on task.
2. Runtime creates a backlog item directly.
3. The item carries origin and endorsement metadata.
4. It competes in backlog surfacing, but it does not become trusted queue work
   automatically.

## 3. Promote Work Into The Trusted Queue

1. A domain steward or review flow evaluates backlog items.
2. System 3 judgment determines whether the work is worthy, legitimate, and
   ready enough to advance.
3. Runtime creates a queue item or bundle.
4. If the item crosses a human-charge threshold, the human approves promotion
   at this point.
5. The item becomes part of the trusted execution queue.

## 4. Explicit `^now` Fast Path

1. The user explicitly marks a request `^now`.
2. Runtime still creates an intake receipt.
3. The system fast-tracks preparation and handling.
4. Approval gates, safety checks, and mutation thresholds still apply.
5. If execution cannot proceed, the system surfaces blockers rather than
   pretending the command overrode them.

## 5. Execute Queue Work

1. Execution reads canonical queue items or bundles.
2. The run creates artifacts, updates queue state, and records a run entry.
3. Human-required consequence steps are surfaced separately from purely agentic
   steps.
4. Runtime views regenerate from the new state.

## 6. Review By Cadence

1. The engine detects that a review cadence is due.
2. The engine routes to the correct review skill.
3. The skill evaluates the domain or system and may do supporting preparation
   work.
4. Runtime creates a review package and a queued human review item.
5. The human reviews the prepared object instead of having to remember cadence
   manually.

## 7. Real-World Consequence And Return Edge

1. A queued item or bundle reaches a point where only the human can publish,
   send, deploy, approve, pay, or otherwise affect the world.
2. The human acts as actuator.
3. The result becomes new system input:
   - done
   - failed
   - blocked
   - changed external state
   - created follow-on work
4. Runtime records the result and the loop continues.

## 8. Issue Logging And Improvement

1. The human or system logs an issue, optionally with `^issue1` through
   `^issue9`.
2. Runtime records the issue with severity.
3. Unless severity crosses a hard-stop threshold, normal execution continues.
4. The issue feeds the improvement loop and may create backlog or review work in
   the system-governance domain.

## 9. Generate The Daily Operating View

1. Runtime reads queue, bundle, review, and human-required state.
2. It generates the daily operating view.
3. The default surface emphasizes:
   - trusted queue work
   - top work by domain and goal
   - Joe-only actions
   - review packages
4. Backlog remains available, but it is not the default operational surface.

## Flow Guardrails

- no capture path should silently skip intake receipts
- no agent-generated backlog item should become trusted queue work without the
  promotion boundary
- no generated view should become the only place state lives
- no `^now` path should bypass approvals or safety rules
- no cadence review should depend on human memory alone
