# CapacityOS Design Review Synthesis

Date opened: 2026-03-24
Status: in progress

## Purpose

This document accumulates concept-by-concept review notes for CapacityOS.

For each concept we capture:

- whether it is represented in the current design
- compatibility coaching from a senior software engineering lens
- clarified intent from the discussion
- open questions that affect architecture
- likely change-ticket candidates for the final design update

We will use this document after the concept review is complete to update the
overall CapacityOS design in one pass.

## Decision Principles

These principles should guide tradeoffs, clarifications, and change-ticket
recommendations during this review.

### 1. Design for scalability and compounding

Structure the system so that improvements, patterns, and reusable components
make future work easier and more powerful over time.

### 2. Optimize for token efficiency and determinism

Minimize unnecessary context and ambiguity so agents can operate with lower
cost, higher consistency, and greater confidence in what to do.

### 3. Increase the velocity of real work

The system should help move meaningful work toward completion in the real
world, not just produce drafts, ideas, or organizational overhead.

## Review Protocol

When a clarifying question has a clear preferred answer across the system,
software, and UX lenses, ask it with a recommendation nudge.

Format preference:

- recommend the preferred option directly
- include one sentence explaining why that option better supports the design
  principles

## Concept 01 - Public engine, reusable structure

### Concept

The engine of the system should be able to live in a public GitHub repo, while
Joe-specific information should never need to.

The structure should be:

- common
- portable
- reusable
- modular enough to swap domains, goals, and in-progress work

CapacityOS should therefore be a generalizable operating-system pattern, not
only personal infrastructure.

### Clarified target

The intended model is:

- a public engine repo
- a public example pack with templated example domains
- a mostly local private layer that uses the engine

Rules implied by that target:

- any change to the engine should be safe to publish publicly
- updates to Joe-specific domains, artifacts, and private content should not be
  published
- the public repo should teach the pattern without containing private user data

Additional clarification:

- skills, templates, and other engine-driving assets belong in the versioned
  public engine when they are part of the reusable system
- new domains, new goals, and operational work belong outside git and should
  not sync to GitHub
- the private layer is mostly local rather than a separately maintained private
  repo
- the engine repo should provide templates and examples for how others use the
  engine properly, but it should not contain Joe's real canon, domains, or
  goals
- governance logic for different domain and goal types may live in the engine,
  while the actual private domain/goal content stays local
- the local private layer should live inside the same CapacityOS workspace as
  ignored folders
- private durable canon and private runtime state should be separate because
  they serve different functions

### Current representation

Assessment: partially represented

What is already aligned:

- the current design separates tracked engine concerns from untracked runtime
- the current design keeps project repos separate from the engine repo
- the current design already aims for canonical reusable structures

What is missing or under-specified:

- no explicit concept of a public example pack
- no explicit distinction between engine core and an owner-specific
  operating-model pack
- no explicit model for a private implementation repo or overlay
- current folder structure still hard-codes Joe/current-project content into the
  engine shape

### Compatibility coaching

To make this truly compatible with the goal, CapacityOS should be modeled as:

1. public engine core
2. public example packs
3. local private user layer
4. local runtime state

Recommended implications:

- engine core contains only reusable schemas, adapters, scripts, templates,
  interfaces, and docs
- example packs are publishable reference implementations, not real user data
- Joe-specific domains, goals, and operating work should not be treated as
  engine core
- reusable skills, templates, and system-driving assets should live in the
  public engine
- governance and review logic may live in the engine, but the governed private
  records should remain local
- project and domain declarations should be pack-based or registry-based, not
  hard-coded into the engine tree
- the workspace can contain ignored local folders for private canon and runtime
  state without requiring a second private repo
- durable private canon should optimize for coherence, trust, and reuse
- runtime should optimize for speed, mutation, and execution
- this canon/runtime split should be treated as a first-class architectural
  boundary, not just a folder preference
- runtime remains local and ignored by git by default
- publishing the engine should not require auditing private content because that
  content should not live there in the first place

### Likely change-ticket candidates

- split current harness framing into engine core plus swappable packs
- add a public example-pack mechanism
- replace hard-coded project folders with pack declarations or registry mounts
- define the boundary between public engine assets and local private domains/work

### Open questions

- How should the local private layer reference the public engine: same
  workspace, mounted sibling folder, or another lightweight mechanism?

## Concept 02 - Intake is not one thing

### Concept

Intake should not assume every incoming item follows the same path.

Different incoming items may need to:

- be stored as a raw reference or artifact
- be placed into the proper queue
- have insights extracted from them
- create agent-ready tasks
- execute immediately
- update or revise an existing item
- contribute to dormant or active domain knowledge

So intake should be modeled as:

1. capture
2. decide handling type
3. route appropriately
4. optionally interpret
5. optionally create downstream work

### Clarified target

The key point is that intake is a routing layer, not just a task-creation step.

The system should preserve a universal capture entrypoint while allowing
multiple handling paths based on the nature of the input and the desired
outcome.

### Current representation

Assessment: partially represented

What is already aligned:

- the import/normalization side already assumes files may route to different
  canonical homes
- the current design already distinguishes tasks, plans, artifacts, summaries,
  and review queues
- shelf language suggests multiple user-facing destinations

What is missing or under-specified:

- the main live-intake flow currently assumes capture creates a task in
  `captured`
- there is no explicit live-intake decision layer with typed handling modes
- there is no explicit contract for when input should update existing records
  instead of creating new ones
- there is no explicit route for direct-to-reference, direct-to-knowledge, or
  direct-to-execution handling

### Compatibility coaching

To make this compatible with the broader CapacityOS principles, intake should be
treated as a deterministic router with a bounded set of handling modes.

Recommended model:

1. universal capture
2. classify handling mode
3. route to canonical destination
4. optionally interpret/enrich
5. optionally create downstream tasks/artifacts/actions

Recommended handling modes:

- reference
- knowledge update
- new task
- task update
- immediate execution
- review/ambiguity queue

Why this is important:

- scalability improves because new input types do not force redesign of the
  whole intake flow
- token efficiency improves because agents can decide the minimal route instead
  of always expanding into a full task workflow
- determinism improves because the handling decision becomes explicit and
  testable
- work velocity improves because some inputs can move directly to execution or
  knowledge storage without unnecessary overhead

### Likely change-ticket candidates

- add a first-class intake router to the engine design
- define a small typed set of intake handling modes
- define rules for create-new versus update-existing behavior
- add routes for reference, knowledge contribution, and immediate execution
- add tests for intake-routing parity across platforms

### Open questions

- Resolved: every captured item should create a lightweight intake receipt
  before routing. This supports determinism and provenance while avoiding the
  mistake of forcing every input to become a task.

## Concept 03 - The human's role

### Concept

The human is not meant to manually process every intake item.

Instead, the human should:

- monitor what the system is doing
- reprioritize when needed
- decide when bundles of work are truly ready
- approve final publication, shipping, or release
- log issues when the system made mistakes or produced low-value outputs

The system should therefore handle ongoing triage and preparation, while the
human handles higher-level judgment.

### Clarified target

CapacityOS should reduce manual handling load, not institutionalize it.

The system should absorb routine triage, preparation, and work packaging. The
human should intervene mainly for:

- judgment
- priority changes
- approval gates
- quality feedback
- release decisions

### Current representation

Assessment: partially represented

What is already aligned:

- the current flows already assume Joe approves work for overnight execution
- the current mental model already centers "Waiting on Joe" and review surfaces
  instead of exposing every internal step
- morning review is already designed as a summary/handoff rather than a demand
  to inspect all raw activity

What is missing or under-specified:

- the design does not yet explicitly define the human as a governor of the
  system rather than a processor of items
- there is no explicit feedback/error-reporting loop for low-value or mistaken
  outputs
- bundle readiness had not yet been modeled as a first-class reviewable object
- approval is modeled at the task level, but not yet clearly at the
  publish/ship/release level

### Compatibility coaching

This concept is highly compatible with the CapacityOS principles and should be
made explicit in the design.

Recommended role split:

- system owns routine intake triage
- system owns preparation and packaging of work
- system owns surfacing what needs human judgment
- human owns reprioritization and exception handling
- human owns readiness judgment for bundles
- human owns final external release/publication approval
- human owns feedback when outputs are wrong, weak, or misrouted

Why this is important:

- scalability improves because the human is not a throughput bottleneck for
  every captured item
- token efficiency improves because the engine can summarize and stage decisions
  instead of repeatedly pulling the human into low-value review
- determinism improves because approval gates become explicit and limited
- work velocity improves because the system can keep preparing work while the
  human only intervenes at high-value decision points

Design implication:

The engine should support a small number of explicit human judgment gates rather
than making the human the default router for all work.

Locked decision:

- bundle readiness is a first-class reviewable object, distinct from
  individual tasks

Why the bundle object matters:

- the meaningful human judgment is often whether the package as a whole is
  coherent, safe, and worth advancing, not whether each task is individually
  acceptable
- package-level risk can emerge from how tasks interact, not only from any
  single task in isolation
- the bundle creates a higher-leverage human review surface than forcing
  repeated task-by-task inspection
- explicit bundle modeling prevents hidden bundle logic from being smuggled in
  through naming, sequencing, or operator intuition

Design tests to preserve:

- distinct object semantics: bundle readiness should represent a real review
  boundary, not just a convenience label over grouped tasks
- package-level risk visibility: it should support judgments that only make
  sense at the combined package level
- human approval leverage: the review surface should reduce fragmented
  approvals while preserving meaningful oversight
- queue-promotion boundary clarity: bundle review should remain clearly related
  to, but not confused with, queue promotion
- compositional clarity: it should stay easy to explain how tasks, bundles,
  and queues relate
- failure recovery semantics: the object should be able to represent partially
  ready, internally inconsistent, or blocked bundles
- UX value: the review surface should materially reduce review fatigue and
  better match how humans evaluate coherent work packages

### Likely change-ticket candidates

- define an explicit human-versus-system responsibility model in the principles
- add a feedback loop for system mistakes and low-value outputs
- define the bundle/release-candidate object model and review semantics
- define final publication/release approval as a dedicated human gate
- add tests for "human only sees decision-relevant surfaces"

### Open questions

- Resolved: bundle readiness is a first-class reviewable object, distinct from
  individual tasks.

## Concept 04 - Intake loop and queue formation

### Concept

Intake should be treated as a multi-stage loop whose purpose is to turn raw
incoming information into a well-maintained queue of agent-ready tasks.

Most items should not become fully drafted tasks immediately.

Instead, intake should begin with a lightweight first pass that is:

- high creativity
- high temperature
- very low length
- non-prescriptive
- optimized to extract concise insights, possible tasks, and possible goal
  updates

This first pass exists to identify what might matter, not to fully specify the
work.

After that first extraction pass, the domain-anchored agent should review what
was surfaced in the context of the domain's:

- purpose
- goals
- current backlog
- supporting coherence frameworks

The output of the overall intake process should be:

- a maintained backlog of surfaced possibilities
- a prioritized trusted queue of agent-ready tasks
- both aligned to domain goals
- both maintained by the domain-anchored agent
- both easy for the user to inspect, trust, and correct

### Clarified target

The intake loop should support:

- candidate insights
- candidate tasks
- candidate goal additions or refinements
- issues, dependencies, and follow-on opportunities

The system should support caret semantics inside intake:

- `^que` means route through the intake loop and add resulting work to the
  appropriate queue
- `^now` means immediate action path

A single `^que` input may produce multiple candidate outputs.

Default behavior clarification:

- if no caret notation is expressed, intake should default to `^que`

Backlog and queue clarification:

- the high-temperature extraction pass should feed the backlog
- the domain agent should evaluate backlog items and promote selected work into
  the trusted queue
- the queue should therefore be a smaller, more action-ready subset rather than
  a dump of everything surfaced during intake

### Current representation

Assessment: mostly missing

What is already aligned:

- the current design already supports distinct object types and generated queue
  views
- the intake receipt decision from Concept 02 fits this model well
- the human correction loop from Concept 03 fits this model well

What is missing or under-specified:

- there is no explicit goal entity yet
- there is no backlog model yet
- there is no candidate-record layer between extraction and canonical task
  creation
- there is no explicit domain-agent evaluation stage
- there is no issue-report loop that feeds back into intake
- caret notation semantics are not yet part of the engine design

### Compatibility coaching

This concept is strongly compatible with the design principles and should become
part of the core operating model.

Recommended intake-loop structure:

1. capture raw input
2. create intake receipt
3. run high-temperature extraction
4. store non-canonical candidate records in the backlog
5. run domain-aware evaluation and pruning against backlog, goals, and domain
   purpose
6. promote approved backlog items into canonical goals and the trusted
   agent-ready queue
7. archive the rest rather than deleting

Recommended implementation guidance accepted for carry-forward:

- keep the first pass high-temperature but make its outputs very short and
  schema-bound
- make the domain review pass lower-temperature and more deterministic
- do not let the extraction pass write canonical tasks or goals directly
- make issue reports re-enter the same intake loop as first-class inputs
- model `^que` as route-through-intake and `^now` as a distinct immediate path
  with tighter safeguards
- treat `^que` as the default intake behavior when no explicit override is
  present

Locked decision:

- `^now` always requires explicit user intent
- `^now` is a fast-path for immediate handling and execution readiness, not an
  authority override
- existing trust boundaries, readiness checks, approval gates, hard-stop
  thresholds, and mutation controls remain in force under `^now`

Why this is important:

- scalability improves because the system can absorb high input volume without
  polluting the trusted queue
- token efficiency improves because only promising items get deeper reasoning
- determinism improves because promotion into canonical queues becomes an
  explicit stage
- real-work velocity improves because the queue stays cleaner and more
  actionable

Design tests to preserve:

- narrow stable meaning: `^now` changes speed and handling priority, not what
  rules apply
- explicit intent: accelerated handling should never be inferred from ambiguous
  input
- invariant trust boundaries: `^now` must not weaken approvals, safety checks,
  or mutation controls
- timing not governance: `^now` versus `^que` should remain a timing
  distinction, not an authority distinction
- blocked-condition behavior: if prerequisites are unmet, the system should
  surface blockers, prepare what it can, and pause at the unmet gate
- auditability: logs should show that immediate handling was explicitly
  requested and that normal controls still applied
- naming pressure: if users keep reading `^now` as "skip process," revisit the
  label rather than quietly changing the logic

### Likely change-ticket candidates

- add goal, backlog, intake-receipt, candidate, and issue entities
- define domain-agent evaluation/pruning as a first-class engine flow
- add caret notation semantics for `^que` and `^now`
- add promotion rules from candidate records into canonical records
- add tests for extraction, pruning, queue formation, and issue re-entry

### Open questions

- Resolved: `^now` always requires explicit user intent, and it acts as a
  fast-path for immediate handling rather than an authority override.
- Resolved: high-temperature creative extraction should feed the backlog, and
  the domain agent should promote selected items from backlog into the trusted
  queue.
- Resolved: the user-facing default view should emphasize the trusted queue,
  with backlog shown mainly on demand or in domain review contexts.

## Concept 05 - Intake-first operating principle

### Concept

Conversations are not separate from the operating system. They are one of the
primary ways new information, decisions, requests, and work enter the system.

Because of that, conversational exchanges should be treated as intake by
default.

Core rule:

When something is discussed in conversation and the conclusion is "let's do
that," one of two things should happen:

1. it enters the intake loop for interpretation, evaluation, and possible
   queueing
2. it is treated as an immediate task and executed directly

Even when executed immediately, it should still leave behind a structured
artifact as if it had entered through intake.

### Clarified target

Conversation should be treated as a process that helps produce structured system
state rather than as something that must be fully recorded verbatim.

The important thing is not to preserve all chat. The important thing is to
preserve the structured result when conversation leads to real work.

Both queued and immediate conversational work should preserve enough history for
the system to later understand:

- what was requested
- what was done
- why it was done
- what domain or goal it related to
- what outputs or downstream effects resulted

The system should therefore be intake-first even when moving quickly:

- queued work goes through the fuller intake loop
- immediate work may take a shortcut
- both still enter system history in structured form

This does not imply that the full conversation transcript becomes intake state
by default.

### Current representation

Assessment: partially represented

What is already aligned:

- the current design already has provenance fields on canonical records
- the current design already has artifacts, runs, and summaries as durable
  runtime records
- capture flows already imply that spoken or conversational input can enter the
  system

What is missing or under-specified:

- conversation is not yet explicitly defined as a primary intake surface
- there is no explicit rule that conversational commitments must produce
  durable structured state
- immediate execution is not yet modeled as leaving behind an intake-linked
  artifact trail
- the system does not yet distinguish conversational commitment from disposable
  chat

### Compatibility coaching

This concept is strongly compatible with the design principles and should become
an explicit operating rule.

Recommended model:

- treat conversation as intake by default
- when conversational intent becomes real work, route it to `^que` or `^now`
- default conversational work to queued intake unless immediate execution is
  explicitly signaled
- even immediate execution should create durable intake-linked records
- preserve a concise structured decision/result record rather than raw chat by
  default

Recommended record trail for immediate work:

1. intake receipt
2. execution record or run record
3. resulting artifact(s)
4. provenance links tying the action back to the conversation/request

Recommended record trail for queued conversational work:

1. intake receipt
2. short structured summary of the request/decision
3. candidate or canonical downstream records, depending on the intake stage

Why this is important:

- scalability improves because conversational work becomes part of the same
  reusable operating model instead of a parallel invisible channel
- token efficiency improves because the system can store structured traces
  instead of repeatedly re-reading long chat history
- determinism improves because actions taken from conversation leave an auditable
  trail
- real-work velocity improves because fast execution does not sacrifice memory
  or coherence

### Likely change-ticket candidates

- define conversation as a first-class intake surface in the engine principles
- distinguish disposable chat from conversational commitments that become system
  state
- require immediate execution paths to emit intake-linked structured records
- add tests for conversation-to-intake and conversation-to-immediate-execution
  behavior

### Open questions

- Resolved: when a conversation ends with "let's do that" and no explicit
  urgency marker is given, the system should default to `^que` rather than
  immediate execution.
- Resolved: conversational provenance should default to a short structured
  decision summary rather than raw transcript excerpts.

## Concept 06 - Daily operating view template

### Concept

The system should support a daily operating view that combines:

1. an agent work queue overview
2. an agent task pipeline grouped by domain and then goal
3. a separate Joe-only task list
4. a short coaching note

Intended structure:

- total agent-ready items in queue
- domain-by-domain goal pipeline with top queued agent tasks per goal
- a top-priority Joe task list that is not grouped by domain
- a coaching note that reinforces containment, coherence, and flow

### Clarified target

This view is not meant to expose all system internals.

It is meant to create one compact daily operating surface where:

- the agent queue is visible as structured ongoing work
- the Joe-only tasks are unmistakable and limited
- the relationship between domains, goals, and active queue items is legible
- the system can provide a small amount of operational coaching without
  overwhelming the user

The template implies a distinction between:

- trusted agent-ready queue
- Joe-only action list
- optional coaching/meta guidance

### Current representation

Assessment: partially represented

What is already aligned:

- the current design already has a morning board concept
- the current tests already expect Joe-facing priorities to surface first
- the current mental model already distinguishes Tonight, Waiting on Joe, and
  Review surfaces
- the backlog-hidden-by-default decision from Concept 04 fits this view well

What is missing or under-specified:

- there is no explicit daily operating view template yet
- there is no explicit goal entity or goal-grouped queue presentation yet
- there is no formal distinction between the agent queue surface and a
  consolidated Joe-only daily task list
- there is no explicit coaching-note output in the current view model
- the current design has morning and review views, but not yet this single
  composite operating dashboard

### Compatibility coaching

This concept is strongly compatible with the current direction and looks like a
good evolution of the existing morning board.

Recommended design rules:

- make this a generated view, never a source of truth
- drive counts, priorities, and groupings from canonical queue/task/goal state
- keep backlog out of the default daily view unless explicitly requested
- separate agent-ready queue visibility from Joe-only action visibility
- limit each goal section to a small fixed number of queue items to preserve
  focus and token efficiency
- keep Joe tasks action-led and single-step where possible
- make the coaching note short, templated, and derived from system state rather
  than freeform reflection

Why this is important:

- scalability improves because one stable operator view can work across many
  domains without exposing the full system
- token efficiency improves because the view stays bounded and structured
- determinism improves because the same canonical state can regenerate the same
  daily view
- real-work velocity improves because Joe sees the most important human actions
  separately from the broader agent pipeline

### Likely change-ticket candidates

- define a first-class daily operating view as a generated runtime view
- add goal-grouped queue presentation rules
- add Joe-only task selection and ranking rules
- add coaching-note generation rules tied to state heuristics
- add tests for daily operating view layout, ranking, and parity across
  platforms

### Open questions

- Resolved: this daily operating view should become the default morning board
  surface.

## Concept 07 - Continuous improvement loop

### Concept

The system should learn from corrections.

If something is miscategorized or handled poorly:

- the normal path is not to interrupt everything
- instead, log an issue
- during the intake loop the system-improvement domain agent can send that into
  an issues queue
- use that for later system improvement

Default operating principle:

- autonomous handling first
- issue logging second
- iterative improvement over time

This means mistakes should be treated as fuel for improving operations, not as
reasons to require constant manual approval.

The user will use caret issue notation to indicate an issue should be logged:

- `^issue1` = mild issue
- `^issue9` = maximum criticality

### Clarified target

The system should preserve its bias toward autonomous handling while making it
easy to capture correction signals in a structured way.

Issue logging should:

- avoid derailing the current flow by default
- create durable correction records
- feed a system-improvement queue for later review and action
- help the system compound better judgment over time

The issue path should be part of the same broader intake/improvement machinery,
not an ad hoc side channel.

### Current representation

Assessment: partially represented

What is already aligned:

- the human-role concept already includes logging mistakes and low-value outputs
- the intake-loop concept already allows issues to re-enter the intake process
- the earlier recommendation work already suggested local observations and
  reviewer feedback areas

What is missing or under-specified:

- there is no explicit issue entity or issues queue in the current design
- there is no formal system-improvement domain flow yet
- there is no issue criticality notation or severity scale yet
- there is no explicit rule that issue logging is preferred over interrupting
  autonomous execution

### Compatibility coaching

This concept is strongly compatible with the design principles and should be
made explicit.

Recommended operating rule:

- default to autonomous handling
- when the user spots a mistake or weak output, log a structured issue instead
  of forcing immediate global caution
- send issues into a system-improvement queue owned by the relevant improvement
  domain/agent
- review and promote improvements through the same disciplined intake/governance
  process used elsewhere

Recommended issue record properties:

- severity or criticality
- affected domain/system area
- what went wrong
- likely impact
- suggested correction if known
- provenance link to the triggering work/output

Why this is important:

- scalability improves because the system can keep operating without collapsing
  into constant manual intervention
- token efficiency improves because corrections become compact structured
  records instead of repeated reactive discussion
- determinism improves because issue handling follows a standard path
- real-work velocity improves because operational work can continue while
  improvements are queued and addressed systematically

Important nuance:

This principle should not eliminate hard stops for truly unsafe or high-risk
cases. It should define the normal path for ordinary mistakes and quality
issues.

### Likely change-ticket candidates

- add a first-class issue entity and issues queue
- define a system-improvement domain or equivalent improvement ownership model
- add caret severity notation for `^issue1` through `^issue9`
- define when issue logging is sufficient versus when execution should halt
- add tests for issue capture, issue queueing, and improvement-loop handling

### Open questions

- Resolved: `^issue` records should default to re-entering the intake and
  improvement loop without interrupting current execution, unless severity
  crosses a defined threshold.

## Concept 08 - Caret notation as a loadable shorthand layer

### Concept

The official caret notation has not launched yet and is not yet present in the
system.

The notation cheat sheet/spec should be loadable into the repo and removable at
any time. New versions should be able to be loaded when available.

Caret notation should act as a lightweight, portable shorthand for guiding
intake behavior.

It is not intended to be a fully rigid programming language. It is a compact
way to encode intent that is often lost in normal text.

The notation is meant to help preserve nuance such as:

- urgency
- desired creativity
- desired conservatism
- intended action type

### Clarified target

Caret notation should be treated as an optional, portable intent-encoding layer
that can be added, updated, or removed without breaking the core operating
system.

The notation should:

- improve structured guidance for intake and execution
- remain lightweight rather than becoming a full programming model
- be teachable through a cheat sheet/spec
- be versionable over time
- eventually be incorporated into relevant skills and agent personas once the
  official spec is complete

### Current representation

Assessment: partially represented

What is already aligned:

- the intake concepts already rely on caret semantics like `^que`, `^now`, and
  `^issue`
- the public-engine principle supports reusable skills and templates living in
  the engine

What is missing or under-specified:

- there is no official caret notation spec in the repo yet
- there is no loadable/removable notation-pack mechanism yet
- there is no versioning rule for notation support yet
- there is no explicit distinction between core engine behavior and optional
  notation shorthand
- skills and personas do not yet declare how they consume a notation spec

### Compatibility coaching

This concept is strongly compatible with the design principles and should be
modeled as a capability layer, not as hard-wired engine truth.

Recommended design rules:

- keep core operating behavior understandable without caret notation
- treat caret notation as an optional shorthand that maps onto canonical engine
  intents
- store the cheat sheet/spec as a versioned engine asset that can be loaded or
  swapped
- make notation support explicit in skills, templates, and agent personas
  rather than implicit
- avoid allowing notation versions to silently change behavior without an
  explicit support/update step

Why this is important:

- scalability improves because the shorthand can evolve without destabilizing
  the whole engine
- token efficiency improves because a compact notation can encode intent with
  fewer words
- determinism improves when notation resolves to canonical behaviors through a
  versioned mapping
- real-work velocity improves because users can guide behavior more quickly once
  the shorthand is learned

Important nuance:

The notation should guide intent interpretation, not become a second hidden
programming system that bypasses the operating model.

### Likely change-ticket candidates

- add a loadable notation spec/cheat-sheet asset to the engine
- define notation-to-canonical-intent mappings
- define how skills and personas declare notation support
- add versioning rules for notation updates
- add tests for notation parsing, fallback behavior, and cross-version support

### Open questions

- Resolved: skills and agent personas should explicitly declare the caret
  notation version they support rather than assuming "latest".

## Concept 09 - Domains as the coherence layer

### Concept

Domains are emerging as the primary providers of coherence in the system.

Framing:

- containment provides structure
- domains provide meaning and prioritization
- flow executes work inside that context

Domains are where the system determines:

- what matters
- what belongs together
- what goals exist
- what decisions have already been made
- how tasks and projects should be prioritized

Domain changes should be highly intentional.

This implies:

- domains should not be created or changed casually
- domain structure is foundational
- domain definitions should remain relatively stable
- changes to domains should be deliberate and likely tracked

Domains therefore look more like governance objects than temporary folders.

Domains can also be active or latent:

- active domain = currently being worked on and influencing prioritization
- latent domain = not currently a focus, but still able to accumulate
  knowledge, ideas, and future work

### Clarified target

The system should use domains as the main coherence and governance layer across
goals, backlog, queue formation, and prioritization.

Projects, repos, and tasks may still exist, but they should operate inside or
under domain context rather than replacing it.

Domain definitions should be treated as relatively stable governance records,
not casual workspace folders.

Latent domains should remain coherent and searchable without polluting active
prioritization.

### Current representation

Assessment: partially represented, with a likely terminology mismatch

What is already aligned:

- the current plan already uses domain language in several workflows and views
- the newer intake concepts already assume domain-anchored evaluation,
  prioritization, and goal coherence
- the daily operating view already assumes tasks are grouped first by domain and
  then by goal

What is missing or under-specified:

- the formal entity model still treats `project` as the primary canonical
  context object
- there is no explicit domain entity yet
- there is no constitutional/governance treatment for domain changes
- there is no explicit active-versus-latent domain status model
- the relationship between domains, projects, and repos is not yet cleanly
  defined

### Compatibility coaching

This concept is strongly compatible with the overall direction and likely needs
to become a foundational design update.

Recommended model:

- domain becomes the primary coherence/governance object
- goals belong to domains
- backlog and queue formation are domain-governed
- projects/repos are execution surfaces, assets, or subcontexts associated with
  one or more domains
- tasks inherit priority and meaning primarily from their domain context

Recommended governance stance:

- domain creation and domain-definition changes should be deliberate
- domain records should be durable private canon, not casual runtime artifacts
- domain status should at least distinguish active and latent states
- latent domains should keep knowledge and backlog continuity without driving
  current top-level prioritization

Why this is important:

- scalability improves because coherence scales better around stable domains
  than around temporary tasks or repo boundaries
- token efficiency improves because domains provide a durable context frame for
  goals, decisions, and prioritization
- determinism improves because queue formation can resolve against explicit
  domain governance instead of ad hoc local context
- real-work velocity improves because work is prioritized inside meaningful
  contexts rather than as disconnected items

Important nuance:

If this concept is adopted, the system should avoid using `project` and
`domain` interchangeably. That ambiguity will create drift.

### Likely change-ticket candidates

- add a first-class domain entity to the canonical model
- define the relationship between domain, goal, project, repo, and task
- move coherence/prioritization logic to the domain layer explicitly
- define active and latent domain statuses
- define domain-change governance and review rules
- update views and schemas to stop overloading `project` for domain semantics

### Open questions

- Resolved: domain should replace project as the primary canonical
  coherence/governance object, with projects and repos modeled as subordinate
  execution contexts.

## Concept 10 - Domain steward agent and domain contents

### Concept

Each domain should likely have an anchored steward agent that acts as its
maintainer of coherence over time.

The steward agent would be responsible for tracking:

- decisions
- goals
- priorities
- what work belongs in the domain
- what has changed over time

This creates continuity and a clear owner of domain-level context.

A domain should likely include at least:

- a clear purpose
- a decision log
- a hierarchy of goals
- strategic direction
- short-term operational priorities
- enough structure that another agent can quickly understand the domain and
  prioritize within it

### Clarified target

The goal is that any agent entering a domain should be able to gain coherence
quickly without loading excessive context.

The domain steward agent is not just a worker. It is the continuity mechanism
for keeping domain meaning, priorities, and decisions coherent over time.

This implies domains should have a compact but high-trust canonical structure
that supports fast orientation by both humans and agents.

### Current representation

Assessment: partially represented

What is already aligned:

- the intake-loop concept already assumes a domain-anchored agent performing
  evaluation and promotion
- the domain-as-coherence-layer concept already assumes domains hold goals,
  priorities, and decisions
- the current entity model already has pieces like purpose and owner, though
  not yet assembled at the domain level

What is missing or under-specified:

- there is no first-class domain steward/anchored-agent role in the formal
  design
- there is no canonical domain record shape yet
- there is no explicit decision-log requirement at the domain level
- there is no explicit split between strategic direction and short-term
  operational priorities
- there is no explicit domain-orientation contract for new agents entering the
  domain

### Compatibility coaching

This concept is strongly compatible with the overall direction and should likely
become part of the canonical domain model.

Recommended model:

- each domain has a canonical domain record in durable private canon
- each domain has an anchored steward agent responsible for maintaining domain
  coherence
- the steward agent owns backlog pruning, goal alignment, and continuity of
  domain decisions
- other agents may work inside the domain, but the steward is the main context
  maintainer

Recommended minimum domain contents:

- domain purpose
- domain status
- decision log
- goal hierarchy
- strategic direction
- current operational priorities
- active backlog references
- only the narrowest provenance needed to preserve durable meaning

Locked refinement:

- domain files should use minimal YAML front matter for stable machine-critical
  metadata, with the domain canon itself remaining in Markdown

Recommended YAML fields:

- domain_id
- class
- status
- template_version

Possible body-only references when they are still useful:

- compact authority/provenance references when removing them would materially
  weaken the domain's durable meaning

Avoid in the canonical minimum:

- stewardship or ownership fields that are likely to churn
- execution-context references
- list-shaped ecosystem references that can grow into coordination surfaces

Boundary rule:

- keep VSM reasoning, strategic content, prioritization logic, and execution
  contract prose in Markdown rather than pushing the whole domain into YAML
- the domain file should feel like durable orientation and governance canon,
  not a disguised runtime or orchestration surface
- optimize the domain file for system function first; human auditability is a
  secondary benefit rather than the primary formatting target
- the Markdown body should become selectively rigid and schema-like in
  authoritative sections, while explanatory content should live in clearly
  bounded non-authoritative zones
- key decisions in the domain file should be compact summaries of current
  canonical effect, while full rationale and history live in separate decision
  objects
- prefer provenance/authority references over stewardship or execution-context
  references

Why this is important:

- scalability improves because any agent can enter a domain through a stable
  orientation layer
- token efficiency improves because agents can load compact domain canon instead
  of reconstructing context from scattered artifacts
- determinism improves because prioritization and queue formation resolve
  against one stewarded coherence layer
- real-work velocity improves because agents can start useful work faster with
  less context assembly

Important nuance:

The anchored steward agent should not become an opaque bottleneck. It should be
the stabilizing coherence layer, while still allowing other agents to act
efficiently inside the domain.

### Likely change-ticket candidates

- add a first-class domain steward-agent concept
- define the canonical domain record/schema
- add domain decision-log support
- define strategic versus operational sections inside domains
- define how other agents enter and use domain context safely

### Open questions

- Resolved: each domain should have exactly one primary steward agent at a
  time, even if other agents contribute within the domain.

## Concept 11 - Cadence by VSM level

### Concept

Each domain may have VSM structuring where each layer has its own review rhythm.

Suggested cadence:

- System 5 = quarterly, stable foundational review, revisit purpose and
  identity
- System 4 = monthly, update strategic assumptions and future direction
- System 3 = weekly or biweekly, assess operational effectiveness and movement
  toward strategic goals
- System 2 = daily or near-daily, reorganize, coordinate, and reprioritize
  operational work
- System 1 = continuous, execution is always happening

The value of this model is that a new domain could immediately be "in cadence"
because the engine provides the VSM review cadence logic and the skills for
reviewing each layer, while the domain provides the domain-specific information
and decision logs managed by the domain steward agent.

### Clarified target

Cadence logic should be generalizable across domains and owned by the engine.

The engine should hold reusable cadence structure, scheduling, and review skills
for each VSM layer. Domains should supply the local content needed for those
reviews:

- purpose and identity
- strategic assumptions
- operational status
- priorities
- decision logs

This allows new domains to inherit a review rhythm immediately instead of
needing custom review design from scratch.

Additional clarification:

- the domain itself should not contain cadence guidance
- the engine should know that a domain implies VSM levels and corresponding
  review rhythms
- if a domain is not using the preferred template, the engine should still make
  its best judgment about the available layer content and run the cadence
- the domain should log the results of the review, the assessment of those
  results, and any resulting decisions

### Current representation

Assessment: mostly missing

What is already aligned:

- the system already has daily/morning review concepts
- the daily operating view concept already implies a System 2 style operational
  cadence
- the domain-governance and steward-agent concepts provide a natural place for
  cadence-specific domain content

What is missing or under-specified:

- there is no explicit VSM layer model yet
- there is no cadence schema or review schedule model yet
- there are no engine-held review skills by VSM layer yet
- there is no inheritance model for "new domain starts in cadence"
- there is no explicit distinction yet between engine-owned cadence logic and
  domain-owned review content/outcomes
- there is no fallback rule yet for non-template or partially structured
  domains

### Compatibility coaching

This concept is strongly compatible with the design principles and fits very
well with the domain-governance direction.

Recommended model:

- engine defines the VSM layer framework
- engine defines cadence logic, scheduling behavior, and review skills per VSM
  layer
- each domain stores the canon those reviews operate on
- the domain steward agent maintains the domain's layer-specific content and
  decisions
- generated review tasks and views are produced from engine cadence logic plus
  domain canon
- review outputs are written back into the domain as logs, assessments, and
  decisions
- when a domain is incomplete or non-standard, the engine should use best-fit
  inference rather than skipping cadence entirely

Why this is important:

- scalability improves because new domains inherit a proven review structure
  immediately
- token efficiency improves because review skills can load only the relevant
  VSM-layer context instead of the whole domain
- determinism improves because cadence is driven by engine rules rather than ad
  hoc review habits
- real-work velocity improves because coordination, strategy, and identity
  review happen on appropriate rhythms instead of collapsing into one noisy
  operational loop

Important nuance:

The engine should own cadence guidance rather than scattering it into domain
definitions. Domain canon should record review inputs and review outcomes, not
the cadence policy itself.

Locked refinement:

- the engine owns cadence, not the human
- when a review cadence is reached, the engine should trigger evaluation
  automatically rather than relying on human memory
- the engine should route the due review to the correct review skill
- the review skill should interpret how to evaluate that specific domain or
  system and prepare the next valid outputs
- the result should surface as a queued human review task at the right control
  surface, not as an obligation the human has to remember manually

Recommended review flow:

1. engine detects that a review is due
2. engine routes to the correct review skill
3. review skill evaluates the domain/system and may generate supporting agent
   work to prepare the review
4. system creates a queued human review task with the prepared review object
5. human exercises judgment, approval, correction, or decision at that control
   surface

Boundary rule:

- engine = timing, routing, initiation
- skill = review logic, interpretation, preparation
- queue = surfaced work object
- human = approval, correction, or judgment at the right point

UX test to preserve:

- the resulting review task should be specific enough to be useful
- light enough to review quickly
- important enough to deserve priority
- bounded enough not to feel like vague administrative churn

Risks to watch:

- engine overreach if engine logic starts containing domain-specific judgment
- skill ambiguity if it is unclear what a review skill must produce
- human-task overload if cadence creates too many high-priority review tasks
- weak review objects if the human still has to do excessive synthesis work
- hidden multi-step execution if review-preparation subtasks become opaque or
  feel unrelated to the review flow

### Likely change-ticket candidates

- add a first-class VSM-layer model to domains
- define engine-held cadence logic and review skills by VSM layer
- define domain-held content requirements for each VSM layer
- add cadence scheduling and generated review-task/view rules
- add inheritance/override rules for domain cadence

### Open questions

- Resolved: the engine should always attempt to run VSM cadences for any
  recognized domain, even when the domain is only partially structured.
- Resolved: when a domain lacks enough structure for a strong VSM-layer
  review, the engine should emit an explicit "insufficient signal / best-fit
  review" result rather than fabricating certainty.
- Resolved: the engine should extract and map the best information possible
  from partially structured domains, but the suggested domain formats remain
  the preferred path because they improve signal quality and review accuracy.

## Concept 12 - Modular engine implication

### Concept

If every domain follows a common structure, the engine can apply generic review
skills across all domains.

Examples:

- run quarterly System 5 reviews across all domains
- run monthly System 4 reviews across all domains
- run weekly System 3 audits across all domains
- run daily System 2 coordination passes across all domains

This means the engine does not need custom review logic for every domain. It
needs:

- a standard domain template
- common cadence-aware review skills

This is a major modularity and scalability insight.

### Clarified target

The engine should operate on a stable canonical domain shape rather than on
one-off domain-specific logic.

Domains may differ in content, but the engine should be able to:

- discover the same classes of information in each domain
- run the same review skills against that information
- emit comparable outputs across domains
- scale to new domains without bespoke workflow design

The standard domain format is therefore an enabling contract for generic engine
behavior.

### Current representation

Assessment: partially represented

What is already aligned:

- the public-engine principle already favors reusable skills and templates
- the domain-as-coherence-layer concept creates a common governance object
- the VSM cadence concept already assumes engine-held review skills can operate
  across domains

What is missing or under-specified:

- there is no canonical domain template/schema yet
- there is no explicit minimum review contract for domains yet
- there is no clear extension model for domain-specific details on top of the
  common structure
- the current architecture still contains older project-centric assumptions that
  work against this modularity

### Compatibility coaching

This concept is strongly compatible with the direction and should be treated as
one of the core architectural payoffs of the new design.

Recommended model:

- define one minimum canonical domain schema/template
- write generic engine review skills against that schema
- allow optional domain-specific extensions only after the common contract is
  satisfied
- keep review outputs standardized enough that cross-domain summaries and
  dashboards remain comparable

Why this is important:

- scalability improves because every new domain can immediately participate in
  the same operating rhythms
- token efficiency improves because review skills know exactly what fields and
  sections to load
- determinism improves because engine behavior depends on shared contracts
  rather than bespoke interpretation
- real-work velocity improves because new domains do not require custom review
  workflows before they become useful

Important nuance:

The common structure should be minimal but sufficient. If it is too thin, the
engine loses coherence. If it is too heavy, onboarding new domains becomes slow
and brittle.

### Likely change-ticket candidates

- define the canonical domain template/schema
- define the minimum review contract domains must expose
- define optional extension points for domain-specific detail
- standardize review outputs across domains
- remove or refactor project-centric structures that block generic domain review

### Open questions

- Resolved: every domain should expose the same minimum canonical review
  fields, with optional extension sections beyond that.

## Concept 13 - Canonical domain shape

### Concept

The domain should be lightweight but coherent enough that:

- the engine can review it through VSM cadences
- the anchored domain steward agent can prioritize work well
- another agent can enter the domain quickly without loading excessive context

Proposed VSM-shaped contents:

- System 5: identity and boundaries
- System 4: strategic direction
- System 3: operational judgment
- System 2: coordination and ordering
- System 1: current execution surface

Goal-layer clarification:

- domains should likely include a reusable goal shape
- System 4 goals are longer-term strategic goals or OKR-like goals
- domains may also include shorter-term current goals that support the daily
  dashboard and near-term focus
- runtime remains separate and holds live backlog, queue, and in-progress state

The template also distinguishes canon from runtime:

- canon holds identity, goals, decision logic, prioritization logic, and
  coordination logic
- runtime holds active backlog, queue ordering, candidate tasks, current issues,
  in-progress state, and recent review outputs

The template also supports:

- active versus latent domain status
- common VSM shape with domain-specific extension points

### Clarified target

The domain shape should provide a minimal canonical contract for coherence while
avoiding redundancy with engine-owned logic and runtime-owned state.

It should preserve:

- domain meaning
- domain-specific governance and judgment
- fast orientation for humans and agents

It should avoid storing:

- cadence policy
- engine review instructions
- live queue state
- current operational churn

### Current representation

Assessment: not yet formalized, but strongly aligned with the recent direction

What is already aligned:

- the domain-as-coherence-layer concept
- the steward-agent concept
- the VSM cadence concept
- the canon-versus-runtime split
- the modular engine concept

What still needs refinement:

- System 1 as currently phrased is too close to runtime state
- some framework examples risk duplicating engine guidance instead of recording
  domain-specific judgment
- the current draft does not yet fully separate engine-owned cadence/review
  logic from domain-owned content

### Compatibility coaching

This is a strong shape overall, but it needs a few deliberate boundary edits to
stay compatible with the CapacityOS design decisions.

Keep in the domain canon:

- domain purpose
- scope and non-scope
- constraints
- strategic goals and direction
- current shorter-term focus goals
- domain-specific prioritization and pruning criteria
- domain-specific coordination preferences
- domain status such as active or latent
- decision log or decision-log references
- execution contract details such as what types of outputs matter and what
  "ready" means in this domain

Move out of the domain canon and keep in engine:

- cadence rules
- VSM review timing
- generic review skill instructions
- generic evaluation frameworks as engine capabilities

Move out of the domain canon and keep in runtime:

- active backlog contents
- queue ordering
- candidate tasks
- current issues
- in-progress work
- recent review results as live operating state

Locked decision:

- System 1 is an execution contract, not a live execution surface

That means the domain should explain:

- what execution units exist in this domain
- what counts as ready
- what outputs/artifacts matter
- what "done" or "useful progress" looks like

But it should not list the current live tasks or queue.

Goal-structure refinement:

- goal should be treated as a reusable object shape inside domains rather than
  a single flat category
- goal semantics depend on VSM level
- `level` should be the primary semantic classifier for goals
- the bracketed goal-heading token should function as the canonical intra-domain
  goal identifier
- System 4 goals express slower-moving strategic direction
- System 1 goals express short-horizon operational intent that should push
  progress toward System 4 goals or explicitly represent maintenance
- System 5 should remain purpose-and-boundaries first, but may include rare
  goal-shaped enduring commitments when they are tightly coupled to identity
- the canonical minimum for a goal should stay narrow:
  - `level`
  - `statement`
  - typed `supports` references
  - `evaluation_signals`
- `role` should drop out of the canonical minimum unless it proves genuinely
  distinct from `level`
- `supports` should use a closed reference grammar rather than generic loose
  links:
  - allowed `target_type` values: `purpose`, `goal`, `maintenance`
  - `purpose` uses the reserved literal token `purpose`
  - `maintenance` uses the reserved literal token `maintenance`
  - `goal` references must resolve to another declared goal id in the same
    domain
  - allowed source-to-target pairings:
    - `S5 -> purpose`
    - `S4 -> purpose | S5 goal`
    - `S1 -> S4 goal | maintenance`
  - same-level and cross-domain goal support are outside the base grammar
- `decision_ref` should use a structured reference grammar rather than a broad
  document link:
  - required fields: `decision_id`, `source_ref`
  - `decision_id` must be a stable kebab-case identifier
  - `source_ref` must point to the authoritative decision record or decision
    record collection
  - canonical use is valid only if `decision_id` resolves within `source_ref`
  - broad document-level refs without `decision_id` are invalid
- `evaluation_signals` should be part of the canonical reviewable core
- rationale and risk material should move into bounded non-authoritative note
  zones
- do not confuse System 1 operational goals with runtime queue items; runtime
  should hold the actual tasks, candidates, and current execution state linked
  to those goals
- engine governs review cadence by level; the domain governs the meaning and
  legitimacy of the goals at each level

System 5 identity refinement:

- keep Purpose, Scope, Non-Scope, and Constraints as separate canonical slots
- Purpose answers why the domain exists
- Scope answers what belongs in the domain
- Non-Scope answers what explicitly does not belong in the domain
- Constraints answer what enduring limits or principles govern the domain
- do not collapse these into one blended identity block, because that would
  push inclusion, exclusion, and boundary semantics back into prose inference

System 3 / System 2 refinement:

- keep System 3 and System 2 as separate layers
- System 3 governs evaluative control:
  - judgment
  - prioritization
  - pruning
  - readiness/advancement boundaries
  - risk/control boundaries
- System 2 governs operational coordination:
  - sequencing
  - handoffs
  - queue-entry flow for already-judged work
  - feedback regulation across work in motion
- queue promotion must be split explicitly:
  - System 3 = the judgment that something is worthy/ready/safe enough to
    advance
  - System 2 = the coordination mechanics of advancing it through flow
- do not let System 3 become a vague operations summary
- do not let System 2 become a second home for prioritization or readiness
  judgment

System 1 refinement:

- keep System 1 as the home of both short-horizon operational goals and the
  execution contract
- treat that pairing as asymmetric and internally separated
- operational goals express what near-term execution is trying to achieve
- execution contract defines what valid execution looks like:
  - execution units
  - readiness
  - output types
  - completion
- do not let goals absorb the execution contract
- do not let the contract erase operational intent
- operational goals may change more often than the execution contract
- runtime still owns live queue state, in-progress tasks, and execution
  activity

Framework guidance:

- the engine should hold the generic review/reasoning skills
- domain-specific frameworks should not be part of the universal canonical
  minimum by default
- if a domain truly needs a local framework, it should live in constrained
  extension space
- any framework extension should declare where it applies and what it is
  allowed to influence

Why this is important:

- scalability improves because all domains share one minimal shape
- token efficiency improves because agents can load compact canon instead of
  mixed canon plus runtime
- determinism improves because engine logic and domain content do not conflict
- real-work velocity improves because active work stays in runtime while canon
  stays stable and reusable

Design tests to preserve:

- canon versus live state separation: System 1 should define durable execution
  logic, not carry queue state or in-progress work
- contract clarity: System 1 should clearly answer what execution units exist,
  what must be true before work starts, what outputs matter, and what counts as
  done
- runtime independence: runtime orchestration can change without repeatedly
  redefining the domain
- auditability and reviewability: it should remain possible to tell whether a
  failure came from weak contract design or weak runtime execution
- avoiding duplicate authority: the domain defines the execution contract while
  runtime holds live state
- human mental model: "System 1 says what execution should look like; runtime
  shows what is happening now"
- template leverage: this should produce cleaner domain templates and easier
  migration patterns, but only after the boundary tests above are satisfied

Near-lock assessment:

- the overall domain shape is now materially stronger and close to lock
- do not reopen broad architecture from here
- the remaining pre-lock work should stay narrow and schema-focused

Current pre-lock blockers:

- harden the System 3 / System 2 / System 1 readiness boundary so:
  - System 3 governs advancement judgment
  - System 2 governs how already-judged work moves through coordination flow
  - System 1 governs execution preconditions
- none at the domain-shape level, assuming the final tightening pass is
  accepted

Non-blocking but worth watching:

- `class` should stay, but only with a closed enum and bounded engine effects
- System 2 wording should continue to be pressure-tested against non-software
  domains
- compact decision summaries should stay thin enough that rationale/history do
  not regrow inline
- domain-specific frameworks should stay constrained enough that extension
  space does not become a methodology junk drawer

Resolved:

- `supports` should use a closed reference grammar now
- `decision_ref` should use a strict structured provenance grammar now
- `Domain-Specific Frameworks` should move out of the universal template and
  into constrained extension space
- duplicated System 5 section-level note surfaces should be cleaned up before
  treating the shape as lockable

### Likely change-ticket candidates

- define the canonical domain schema/template
- implement the System 1 execution-contract framing in the canonical schema and
  template
- define which VSM sections are required versus optional
- separate inline domain summary from linked decision-log/history material
- define engine-selected versus domain-selected framework fields

### Open questions

- Resolved: System 1 in the canonical domain shape is an execution contract,
  not a live execution surface.
- Resolved: every short-term current goal should either link back to a System 4
  strategic goal or explicitly declare that it is a maintenance goal.
- Resolved: goals are a reusable cross-level object shape inside domains, with
  level-dependent semantics rather than one flat undifferentiated class.

## Concept 14 - Containment, coherence, flow mental model

### Concept

High-level mental model:

- the engine is the containment and structure
- the canon uses domains for the coherence
- the runtime is the flow

This frames CapacityOS as three cooperating layers:

- containment = reusable engine structure and operating rules
- coherence = domain canon that gives meaning, priorities, and continuity
- flow = runtime where work moves, mutates, and executes

### Clarified target

This is a simple explanatory model for how the system works at a high level.

It should help guide both architecture and UX by making the role of each layer
clear:

- engine answers "how is the system structured and governed?"
- canon answers "what matters here and how should it be interpreted?"
- runtime answers "what is happening now?"

This mental model should also help prevent category mistakes such as:

- putting private meaning into the engine
- putting durable coherence into runtime
- putting live mutable work into canon

### Current representation

Assessment: strongly aligned, but not yet stated this cleanly in the formal
docs

What is already aligned:

- the public-engine and engine/runtime split concepts already establish
  containment as reusable structure
- the domain-as-coherence-layer concept already establishes canon as the source
  of meaning and prioritization
- the canon-versus-runtime split already treats runtime as the mutable flow
  layer

What is missing or under-specified:

- the architecture does not yet state this as the primary mental model
- the current docs still have some older vocabulary that could blur the layer
  boundaries

### Compatibility coaching

This is an excellent unifying mental model and I would carry it into the final
design update directly.

Why it works:

- scalability improves because each layer has a clear job
- token efficiency improves because agents can load the right layer for the task
- determinism improves because policies, meaning, and active state are not
  mixed
- real-work velocity improves because flow can move quickly without destabilizing
  containment or coherence

Recommended use:

- use this as a top-level explanatory model in the architecture docs
- use it to judge boundary questions when deciding where something belongs
- use it in onboarding and UX language to keep the system understandable

Important nuance:

Containment, coherence, and flow are roles, not just folder names. The files
and folders should reflect that model, but the conceptual boundary matters more
than the exact naming.

### Likely change-ticket candidates

- add containment/coherence/flow as a top-level mental model in the
  architecture
- audit the design for boundary violations using this framing
- align folder/entity naming with this model where helpful

### Open questions

- Resolved: containment, coherence, and flow should become the primary
  one-sentence architectural explanation of CapacityOS.

## Concept 15 - Weekly external insight review

### Concept

The system should have a weekly task to review a curated set of prominent
external sources for insights.

Example source types:

- major AI lab blogs
- model/provider release notes
- infrastructure/agent workflow blogs
- other high-signal sources relevant to CapacityOS

The weekly task should extract the ten most profound insights that could impact
the three high-level system goals:

- token-efficient determinism
- compounding and modular scalability
- increasing the velocity of real work done

### Clarified target

This should function as an engine-driven external intelligence cadence rather
than as ad hoc browsing.

The purpose is not simply to summarize news. The purpose is to scan for
high-leverage insights that may improve the system's:

- architecture
- workflows
- skills
- review logic
- operating habits

The output should be selective, goal-filtered, and improvement-oriented.

### Current representation

Assessment: partially represented

What is already aligned:

- the system already has scheduled-task and cadence concepts
- the system-improvement loop already exists conceptually
- the high-level design principles already define the three filtering goals

What is missing or under-specified:

- there is no external source-review task yet
- there is no source registry or source-selection contract yet
- there is no insight entity or insight-review output format yet
- there is no explicit route from insight digest to system-improvement backlog

### Compatibility coaching

This concept is strongly compatible with the design and is a good example of
compounding improvement in practice.

Recommended model:

- engine owns the weekly external-insight review cadence and review skill
- the engine or public example layer can define a default curated source list
- the review pass extracts a bounded ranked insight digest tied explicitly to
  the three system goals
- candidate improvements flow into the system-improvement backlog rather than
  directly mutating canon or engine behavior

Recommended output shape:

- source reviewed
- insight summary
- which of the three system goals it impacts
- why it matters
- confidence/relevance score
- recommended follow-up, if any

Why this is important:

- scalability improves because the system gains a repeatable external learning
  loop
- token efficiency improves because the review is bounded, selective, and tied
  to explicit goals
- determinism improves because external input is filtered through one stable
  review task instead of random opportunistic changes
- real-work velocity improves because only high-leverage insights are promoted
  into improvement work

Important nuance:

The task should produce candidate improvements, not automatic architecture
changes. External insight should enter through the same disciplined improvement
loop as other system changes.

### Likely change-ticket candidates

- add a weekly external-insight review scheduled task
- define a curated source registry with default sources and optional additions
- define an insight digest/output schema
- route promising insights into the system-improvement backlog
- add tests or review criteria for insight relevance and bounded output

### Open questions

- Resolved: the weekly insight review should produce candidate improvement
  items for the system-improvement backlog rather than directly changing canon
  or engine behavior.

## Concept 16 - Day-1 bootstrap automation suite

### Concept

The system should include a single prompt or bootstrap action that sets up a
suite of automated or scheduled tasks so the system can start "chugging along"
from day 1.

The purpose is to let a new installation quickly become operational without
manual setup of many separate automations.

### Clarified target

The bootstrap should:

- create a useful default automation suite
- align with engine-owned cadence and review logic
- work from day 1 even before the user's private system is highly mature
- reduce setup friction dramatically

This should feel like a one-step activation of the operating rhythm rather than
an advanced manual configuration exercise.

### Current representation

Assessment: partially represented

What is already aligned:

- the design already has scheduled-task and engine-entrypoint concepts
- the cadence model already assumes reusable engine-driven reviews
- the system is already moving toward generic skills that can operate across
  domains

What is missing or under-specified:

- there is no bootstrap prompt or setup flow yet
- there is no defined starter automation suite yet
- there is no explicit day-1 activation story for new users
- there is no separation yet between default starter automations and
  domain-specific follow-on automations

### Compatibility coaching

This concept is strongly compatible with the design and is probably important
for real adoption.

Recommended model:

- the engine exposes one bootstrap prompt or setup command
- that bootstrap installs a default starter suite of scheduled tasks
- the starter suite covers the core operating rhythm, not every possible domain
  specialization
- domain-specific or advanced automations can be layered on later

Good candidates for the starter suite:

- morning operating view
- daily System 2 coordination/reprioritization
- overnight execution/review cadence
- weekly System 3 operational audit
- monthly System 4 strategic review
- quarterly System 5 identity review
- weekly external insight review

Why this is important:

- scalability improves because the same starter kit can activate many
  installations
- token efficiency improves because setup knowledge is encoded once instead of
  re-explained manually
- determinism improves because the default automation suite is engine-defined
  and reproducible
- real-work velocity improves because the system becomes useful immediately

Important nuance:

The bootstrap suite should be minimal but meaningful. If it installs too many
automations, new users will get noise before they get value.

### Likely change-ticket candidates

- define a one-step bootstrap automation/setup prompt
- define the default starter automation suite
- separate starter automations from optional domain-specific automations
- define idempotent bootstrap behavior so reruns do not create duplicates
- add setup guidance and verification for the automation suite

### Open questions

- Resolved: the bootstrap should install only the core engine-wide cadence
  automations first, with domain-specific automations added later as domains
  mature.

## Concept 17 - System improvement approval thresholds

### Concept

Implementing system improvements should not be governed by one blanket rule.

The better model is a thresholded approval policy:

- observation and issue logging can happen automatically
- candidate improvements can be generated automatically
- draft analysis, draft tasks, and even draft patches/tests in safe contexts
  can often happen automatically
- applying changes to engine behavior, canon, or automations should cross a
  higher approval threshold

### Clarified target

The system should preserve autonomy and compounding improvement without allowing
live operating rules to mutate impulsively.

This means the improvement loop should distinguish between:

- observing a problem
- proposing an improvement
- preparing an implementation
- applying the implementation

These stages do not all require the same human involvement.

### Current representation

Assessment: partially represented

What is already aligned:

- engine changes are already supposed to be deliberate and reviewed
- the system-improvement loop already prefers structured feedback over constant
  interruption
- external insight review is already framed as producing candidate improvements
  rather than direct changes

What is missing or under-specified:

- there is no formal threshold/heuristic model yet
- there is no explicit distinction between drafting an improvement and applying
  it
- there is no explicit rule for when runtime-only optimization can proceed
  autonomously versus when engine/canon changes need approval

### Compatibility coaching

Recommended policy:

- automatic: log issues, create candidate improvements, classify severity, and
  route items into the improvement backlog
- autonomous low-risk drafting: prepare analysis, proposed tasks, draft patches,
  and draft tests in a reviewable form
- human approval required: apply any change that mutates engine logic, canonical
  domain content, automation schedules, notation semantics, or public/persistent
  behavior
- hard-stop threshold: require immediate human attention for high-severity,
  privacy-sensitive, destructive, or high-blast-radius cases

Locked decision:

- autonomous drafting and candidate generation are allowed
- human approval is required before any durable engine or canon mutation is
  applied

Boundary this preserves:

- proposing changes can be highly autonomous
- committing changes that alter future system behavior, interpretation, or
  durable structure requires explicit human approval

Why this is better than blanket approval for everything:

- scalability improves because the system can keep learning and preparing work
  without constant human gating
- token efficiency improves because only consequential changes consume human
  review bandwidth
- determinism improves because approval boundaries are tied to mutation risk and
  blast radius
- real-work velocity improves because the system can autonomously prepare
  improvements while preserving human control over durable change

Recommended heuristic dimensions:

- mutation target: runtime versus canon versus engine
- reversibility
- blast radius across domains
- public/publishable impact
- privacy/safety sensitivity
- confidence level

Design tests to preserve:

- mutation-boundary clarity: the system must clearly distinguish candidate
  generation from durable mutation
- legitimacy of durable change: durable changes should not occur without
  explicit human approval
- drift containment: candidate outputs must not become canon through inertia,
  defaults, or weak review
- reversibility asymmetry: durable mutations should face a higher threshold
  because they are harder to unwind
- auditability and authorship: the system should preserve what it proposed,
  what a human approved, and what ultimately changed
- improvement velocity without over-control: friction should appear at durable
  mutation, not earlier than needed
- scope testing: ambiguous cases like config, template, policy, routing, and
  threshold changes should still classify coherently

### Likely change-ticket candidates

- define formal improvement-stage thresholds
- define approval-required mutation categories
- define hard-stop severity rules
- separate draft-implementation from applied-implementation states
- add tests for threshold routing and approval behavior

### Open questions

- Resolved: autonomous drafting is allowed, but applying any durable engine or
  canon mutation requires human approval.

## Concept 18 - Intake-to-triage validation loop

### Concept

Intake should not flow directly into a backlog as if raw input and actionable
work are the same thing.

Instead, intake should pass through an agentic triage loop that:

- preserves the raw intake item
- extracts possible backlog items from it
- shows the human what was inferred
- lets the human quickly validate or correct the extraction
- only then promotes approved items into the backlog

A single intake item may produce:

- no backlog items
- one backlog item
- multiple backlog items
- both agent tasks and human tasks

This makes triage a creative interpretation step with lightweight human
oversight, not a simple filing step.

### Clarified target

The intended chain is:

- raw intake
- triage interpretation
- lightweight human validation/correction
- validated backlog
- downstream queue and execution loops

The triage experience should make it easy to inspect, for each intake item:

- the raw intake
- what happened to the raw intake itself
- what candidate backlog items were extracted
- links to created files, plans, or tasks
- quick shorthand responses such as approve, reject, split, add missing item,
  or note a correction

The goal is transparency and control without heavy workflow overhead.

### Current representation

Assessment: partially represented, but not yet aligned on backlog semantics

What is already aligned:

- the current synthesis already requires preserving raw intake through an intake
  receipt
- the current synthesis already models extraction as a creative candidate
  generation step
- the current synthesis already assumes human correction matters
- the broader system already values auditable chains and visible review surfaces

What is missing or in tension:

- the current synthesis still says the high-temperature extraction pass feeds
  the backlog directly
- there is no explicit triage-review layer or triage queue yet
- there is no explicit human validation surface for extracted candidate items
- backlog is currently behaving more like a candidate reservoir than a
  validated work layer

### Compatibility coaching

This concept is compatible with the overall design, but it changes an important
earlier assumption: backlog should become a higher-trust validated layer rather
than the immediate output of creative extraction.

Recommended revised loop:

1. raw intake is captured and preserved
2. triage extraction produces candidate items
3. candidate items enter a triage review surface
4. human validates, rejects, splits, or corrects them in lightweight shorthand
5. only validated items become backlog entries
6. domain/backlog logic then prioritizes backlog and prepares trusted queue work

Recommended consequence:

- rename or separate the current exploratory backlog into a candidate/triage
  layer
- reserve "backlog" for validated work
- keep the trusted queue as the smaller execution-ready subset beyond backlog

Why this is important:

- scalability improves because the system preserves a clear staged loop instead
  of blurring interpretation with accepted work
- token efficiency improves because later loops can reason over validated
  backlog instead of noisy inferred candidates
- determinism improves because there is an auditable approval step between
  inference and durable work creation
- real-work velocity improves because downstream automation compounds on
  validated structure rather than uncertain interpretation

Important nuance:

This does introduce more human touch than the earlier backlog model. The design
should keep that validation layer fast, browsable, and shorthand-friendly so it
does not become a bottleneck.

### Likely change-ticket candidates

- add a first-class triage review layer and triage queue
- redefine backlog as validated rather than merely extracted
- add candidate-to-backlog promotion rules
- define triage review UI/output format and shorthand correction actions
- update intake and daily-view concepts to reflect the new staged semantics

### Open questions

- Recommended: should "backlog" in CapacityOS mean only human-validated work,
  with extracted proposals living in a separate triage/candidate layer? This
  likely best supports determinism and transparency because the system stops
  treating inference and accepted work as the same class of object.

## Concept 19 - Backlog admission by origin and endorsement

### Concept

The system should support agents adding items into the backlog without requiring
human triage for every single one.

The intended distinction is:

- human intake may need explicit triage because it begins from ambiguous raw
  human input
- agent-generated items may enter backlog more freely so the system can expand
  capacity and surface opportunities the human would not create manually
- human judgment remains especially important when work is promoted into the
  queue for active execution

The system should therefore tolerate a large and partially noisy backlog as long
as prioritization and surfacing remain strong enough that the top of backlog
stays useful, reviewable, and close to what should actually be considered for
queueing.

### Clarified target

Backlog size is not the primary risk.

The real risks are:

- important items getting buried by noise or duplication
- mixed item types reducing prioritization quality
- speculative agent-generated items shaping attention before they are useful
- false momentum from many possible items with weak execution relevance
- queue review being overly dependent on what the agent chose to surface

So the key design need is not "make backlog small."
It is "make backlog surfacing and endorsement quality strong."

### Current representation

Assessment: partially represented, but not yet explicit enough

What is already aligned:

- the current design already separates backlog from trusted queue
- the human role is already strongest at review/approval points downstream
- the system already values domain-based prioritization and queue quality more
  than raw item counts

What is missing or under-specified:

- there is no explicit distinction yet between human-triaged backlog items and
  agent-originated backlog items
- there is no endorsement/trust metadata model for backlog entries
- there is no explicit surfacing-quality contract for how noisy backlog stays
  usable
- there is no explicit agenda-setting safeguard for speculative agent entries

### Compatibility coaching

This concept is compatible with the broader design and is a better fit than
requiring human validation for every backlog admission.

Recommended model:

- human-originated raw intake goes through visible triage before backlog entry
- agent-generated opportunities may enter backlog directly
- backlog entries carry explicit provenance and endorsement state
- queue promotion remains the main human approval gate

Recommended backlog metadata:

- origin type: human intake, agent-generated, imported, recurring, external
  insight, etc.
- endorsement state: untriaged human proposal, agent-suggested, human-corrected,
  human-confirmed, queue-approved, etc.
- confidence or evidence strength
- domain/goal linkage
- duplicate/related-item links
- surfacing score inputs

Recommended surfacing safeguards:

- deduplication and merge/sibling detection
- priority weighting toward goal-linked and evidence-backed items
- downranking of speculative items until they gain support
- separate views or filters for agent-suggested versus human-confirmed work
- explicit reporting on why something surfaced near the top

Why this is important:

- scalability improves because the system can expand backlog capacity without
  forcing the human to triage everything
- token efficiency improves because only the top of backlog needs richer review
- determinism improves because endorsement and provenance make mixed backlog
  states legible
- real-work velocity improves because the system can surface useful work
  opportunities while still preserving human control at queue entry

Important nuance:

This shifts the control point downward. The main trust boundary is not backlog
admission itself; it is backlog surfacing quality and queue promotion quality.

### Likely change-ticket candidates

- add backlog endorsement/provenance states
- define human-intake versus agent-originated backlog admission rules
- define surfacing/ranking safeguards for noisy backlog
- define top-of-backlog explanation fields
- update the intake-to-triage concept so it applies mainly to human-originated
  intake rather than all backlog creation

### Open questions

- Resolved: every backlog item should carry an explicit endorsement state so
  the system can mix human-triaged and agent-generated entries without treating
  them as equally trusted.

## Concept 20 - Human charge at transition points

### Concept

Human involvement should be understood less as general supervision and more as
selectively applied charge.

The goal is not to keep the human in every loop. The goal is to increase system
capacity by having the human inject energy only at a small number of
high-leverage control points.

The main places where human charge matters are:

- when intent or raw material enters the system through intake
- when possible work is promoted into the queue for active execution
- when outputs are committed to the world through publishing, sending,
  deploying, or similar consequential acts

Between those points, the system should become increasingly agentic.

Triage plays a different role than general supervision:

- it is not mainly a throughput step
- it is a resilience or resistance layer
- it absorbs ambiguity
- it catches interpretive errors
- it prevents misread inputs from compounding downstream

Alternative framing:

- intake introduces direction
- triage preserves fidelity
- queue approval creates commitment
- publishing creates real-world consequence

### Clarified target

Human checkpoints should be few, deliberate, and placed at transition points
where judgment has the most leverage.

The purpose of those checkpoints is not to manually process everything. It is
to:

- shape direction
- validate promotion
- approve consequence

The system should increase capacity by doing more work autonomously between
those checkpoints without losing coherence.

### Current representation

Assessment: strongly compatible and partially represented, but not yet framed
this precisely

What is already aligned:

- the human-role concept already pushes the human away from item-by-item
  processing
- the intake and triage concepts already give human review a special role where
  interpretation risk is highest
- the queue and release concepts already imply stronger human gates at
  commitment and publication points
- the thresholded improvement policy already uses higher approval at durable
  mutation boundaries

What is missing or under-specified:

- the architecture does not yet describe human attention as strategic charge
- triage is not yet explicitly framed as a resilience mechanism
- the checkpoint sequence across intake, queue, and consequence is not yet
  expressed as one coherent model

### Compatibility coaching

This is a very strong framing and I would carry it directly into the final
design.

Recommended human checkpoint model:

- intake checkpoint: shape direction when raw intent enters
- triage checkpoint: preserve fidelity when ambiguous input is interpreted
- queue checkpoint: approve commitment of work into active execution
- consequence checkpoint: approve externalized outcomes that affect the world

Recommended system behavior between checkpoints:

- expand autonomous analysis
- expand backlog generation
- expand preparation and packaging
- expand execution where approval rules already allow it

Why this is important:

- scalability improves because the human is reserved for the highest-leverage
  transitions
- token efficiency improves because human review bandwidth is spent where it
  changes outcomes most
- determinism improves because human judgment is attached to clear state
  transitions rather than vague supervision
- real-work velocity improves because the system can move faster between
  checkpoints without losing control

Important nuance:

Not every intake event must receive the same amount of human charge. The
human-intake versus agent-generated-backlog distinction still matters. The key
is that human charge should attach to transition risk and consequence, not to
every object equally.

### Likely change-ticket candidates

- define a formal checkpoint model across intake, triage, queue, and
  publication
- revise the human-role section to use the strategic-charge framing
- define which transitions require explicit human charge by default
- align UI surfaces to these checkpoints

### Open questions

- Resolved: intake, queue promotion, and real-world consequence should be the
  three primary human-charge checkpoints, with triage acting as a conditional
  resilience layer rather than a universal gate.

## Concept 21 - Human-required work as an operational lens

### Concept

Human-required work should remain a first-class operational surface, even if it
is not a separate primary ontology category.

Key distinction:

- ontology answers: what kind of thing is this?
- operational presentation answers: what does the human need to see and do?

This means "human-required" is best understood as a cross-cutting execution
property rather than its own core class of object.

A task, queue item, consequence step, or review step may all be
human-required without needing to become a fundamentally different kind of
thing.

### Clarified target

The system should preserve two truths at once:

- human-required work is not a separate primary ontology category
- human-required work must still be surfaced cleanly and explicitly in the UX

This is necessary because one of the most important system questions is:

- what only the human can do now?

So human-required work should be a first-class operational lens over the
system, even when the underlying objects belong to other ontology classes.

### Current representation

Assessment: partially represented, but now clarified more precisely

What is already aligned:

- the daily operating view already assumes a Joe-only task surface
- the human-role concept already gives the system a distinct human-facing action
  layer
- the checkpoint model already identifies the places where human judgment has
  special leverage

What is missing or under-specified:

- the design does not yet explicitly distinguish ontology from operational lens
- there is no formal cross-cutting human-required property model yet
- there is no explicit rule that human-required work can span multiple object
  types without becoming a new ontology category

### Compatibility coaching

This is the right refinement.

Recommended model:

- keep ontology classes focused on domain objects and workflow state
- add a cross-cutting human-required property or view model
- derive human action surfaces from that property across tasks, reviews,
  consequence steps, and other objects
- keep the UX answer to "what only the human can do now?" simple and prominent

Why this is important:

- scalability improves because ontology stays clean while the UX can remain
  action-oriented
- token efficiency improves because the system can surface only the
  human-required subset without redefining the whole model
- determinism improves because object identity and human-action presentation are
  not conflated
- real-work velocity improves because the human sees actionable work clearly
  regardless of the underlying object type

### Likely change-ticket candidates

- define a cross-cutting human-required property/state model
- define the human-required operational lens and view-generation rules
- update daily operating surfaces to derive human-only views from that model
- keep ontology docs explicit about the difference between object type and
  operational presentation

### Open questions

- Resolved: human-required work should remain a first-class operational
  surface, even if it is not a separate primary ontology category.

## Concept 22 - System governance domain versus engine substrate

### Concept

There is a strong preference to keep the domain structure as universal and clean
as possible.

The motivating intuition is:

- if domains are the unit through which the system understands policy,
  strategy, control, coordination, and operations
- then that should apply consistently, including to the system itself

This suggests a clean model where the system is one domain among others rather
than something entirely outside the pattern.

### Clarified target

The attraction of this framing is:

- one domain model everywhere
- no special-case ontology too early
- the system itself remains governable and improvable through the same VSM lens

At the same time, the design must avoid blurring three different things:

- the engine/runtime substrate that enacts loops and cadences
- the system's own governance and adaptation layer
- ordinary domains the system helps operate

Boundary test clarification:

- if the thing is a governable coherence object, it should fit the domain model
- if the thing is an execution substrate, forcing it into the domain ontology
  likely creates confusion rather than consistency

Key criteria for this distinction:

- ontological boundary clarity
- canon versus runtime separation
- stability under engine evolution
- universal domain-shape integrity
- mental model simplicity
- avoiding false symmetry between governance objects and infrastructure objects
- migration/template leverage as supporting evidence rather than primary
  justification

### Current representation

Assessment: compatible in spirit, but requiring a careful distinction

What is already aligned:

- the domain-as-coherence-layer concept already makes domains the unit of
  policy, prioritization, and coherence
- the system-improvement concepts already imply a domain-like governance area
  for improving the system
- the containment/coherence/flow model already separates engine, canon, and
  runtime conceptually

What is risky or under-specified:

- if "the system is a domain" is interpreted to mean the engine itself is just
  another domain, the current boundary model breaks
- engine cadence logic, schemas, adapters, and automation substrate should not
  collapse into canon-level domain content
- recursive confusion appears if the same object is simultaneously the thing
  being governed and the substrate doing the governing

### Compatibility coaching

Strong pushback:

The clean universal model works only if we distinguish "system governance
domain" from "engine substrate."

Recommended refinement:

- yes, CapacityOS should have a system-governance domain inside canon
- no, the engine and runtime substrate should not themselves be modeled as just
  another ordinary domain

In other words:

- the domain model applies to the system's goals, decisions, improvement work,
  and governance
- the engine remains containment
- the runtime remains flow
- the system-governance domain lives in coherence

Why this distinction matters:

- scalability improves because the universal domain model stays clean without
  collapsing architectural layers
- token efficiency improves because agents can reason about the system's goals
  and decisions without loading engine internals as if they were ordinary domain
  canon
- determinism improves because authority boundaries remain clear
- real-work velocity improves because change-control for engine behavior stays
  stronger than ordinary domain adaptation

Recommended model:

- treat "CapacityOS" or equivalent as a reserved meta/system-governance domain
- let that domain use the same canonical domain shape as other domains
- allow it to hold system goals, design decisions, improvement backlog, and
  strategic direction
- do not let that imply that engine logic, cadence rules, schemas, or runtime
  substrate are domain-owned

Important nuance:

This is best understood as self-governance, not total self-identity. The system
can govern itself through a domain while still preserving a substrate/domain
boundary.

### Likely change-ticket candidates

- define a reserved system-governance domain type or metadata flag
- clarify that engine substrate is not itself a normal domain object
- define which system concerns belong in the system-governance domain versus the
  engine
- use the same canonical domain shape for the system-governance domain where
  possible

### Open questions

- Resolved: CapacityOS should have an explicit reserved system-governance
  domain that uses the standard domain model, while the engine/runtime
  substrate remains outside the domain ontology.

## Concept 23 - Domain class as an engine-handling modifier

### Concept

Domains may share a universal base model while also declaring a class.

In this framing:

- domain remains the primary coherence/governance object everywhere
- class gives the engine a controlled way to apply different cadence logic,
  skill mappings, agent personas, or other handling patterns to different kinds
  of domains

Examples:

- most domains use a default class
- a reserved system-governance domain may use a distinct class
- the engine applies different review, cadence, or skill behavior based on
  class while still treating the object as a domain-shaped governance record

### Clarified target

The goal is to preserve universality at the coherence layer while allowing
modular, extensible differences in engine interaction.

The important constraint is that class should not become an unbounded escape
hatch for special cases.

The base domain model should remain primary. Class should only introduce
explicit, legible differences in engine handling.

Additional clarification:

- class functions as a bounded engine-handling modifier rather than descriptive
  free-form metadata
- if more expressiveness is needed later, that should likely live in separate
  descriptors or tags rather than expanding class itself

### Current representation

Assessment: not yet represented explicitly, but highly compatible with the
current direction

What is already aligned:

- the design already wants one universal domain model
- the engine already needs a way to vary cadence, review, and handling in some
  controlled cases
- the reserved system-governance domain idea creates a strong use case for this
  mechanism

What is missing or under-specified:

- there is no domain-class field or taxonomy yet
- there are no rules yet for which engine behaviors class may affect
- there is no guardrail yet against class sprawl or class-specific ontology
  drift

### Compatibility coaching

This is a strong refinement.

I think it solves the main tension cleanly:

- keep one domain ontology
- add a limited class mechanism for engine-side handling differences

That gives you:

- universality in canon
- modularity in engine behavior
- explicit handling differences where they are truly needed

Recommended boundaries:

- class should influence engine handling, not rewrite the base domain schema
- class should be defined by the engine as a small controlled set, not arbitrary
  free text
- class should affect things like cadence profile, review skills, steward
  persona defaults, and surfacing rules
- class should not become a way to smuggle private one-off semantics into the
  ontology

Why this is important:

- scalability improves because new domain types can be added without breaking
  the universal model
- token efficiency improves because engine behavior can branch from a compact
  class signal instead of ad hoc inference
- determinism improves because handling differences are explicit and auditable
- real-work velocity improves because the engine can apply better-fit behavior
  automatically where warranted

Important nuance:

Class should be closer to a policy profile than to a subtype explosion. If too
many behaviors depend on class, the universal domain model will become nominal
instead of real.

### Likely change-ticket candidates

- add a controlled domain-class field to the canonical domain model
- define the allowed class set and default class
- define which engine behaviors may vary by class
- define guardrails against class proliferation
- define the reserved system-governance class if that direction is adopted

### Open questions

- Resolved: domain class should be a small engine-defined enum/profile set
  rather than arbitrary domain-authored text.
- Resolved: if richer expressiveness is needed, it should live in separate
  descriptors or tags rather than in class itself.

  ## Candidate additions / tensions to pressure-test

### Concept 24 - State transitions and object lifecycle

#### Concept

The design may need a more explicit model of how objects are allowed to move through the system.

Right now the architecture strongly implies transitions such as:
- intake → candidate
- candidate → backlog
- backlog → queue
- queue → execution
- execution → consequence
- consequence → new intake or archived record

But those transitions do not yet seem fully formalized.

#### Why this matters

A large part of CapacityOS depends on maintaining clean distinctions between:
- raw input
- proposals
- validated work
- active commitments
- completed outcomes
- durable canon

If lifecycle transitions are not explicit, the system risks category drift, hidden promotion, and ambiguity about what status an item actually has.

#### Pressure-test question

Should the system define a small, explicit state-transition model for major object types so that promotion, demotion, archival, and consequence are always legible and auditable?

---

### Concept 25 - Observability and explanation surfaces

#### Concept

The system may need a first-class observability layer for understanding why it behaved the way it did.

This goes beyond provenance and audit history. It is about surfacing:
- why something was surfaced
- why something was not surfaced
- why something was ranked highly
- why something stayed provisional
- what heuristics or confidence assumptions were involved
- what fallback behavior was used

#### Why this matters

As the system becomes more agentic, trust will depend not only on outputs, but on the user being able to inspect the reasoning shape of the system without having to inspect every raw step.

#### Pressure-test question

Should CapacityOS define a compact explanation/telemetry surface so the human can inspect system behavior at the level of decisions and rankings, rather than only at the level of artifacts?

---

### Concept 26 - Explicit authority and permissions model

#### Concept

The system may need a more formal answer to who or what is allowed to do which kinds of things.

This includes permissions around:
- create
- edit
- promote
- queue
- publish
- archive
- change canon
- change engine behavior
- mutate automations
- reclassify domain objects

#### Why this matters

The design already distinguishes between human charge, engine-owned cadence, domain stewardship, and thresholded improvement. A clearer authority model would make those distinctions more durable and auditable.

#### Pressure-test question

Should the design define an explicit authority model that makes action rights legible across humans, stewards, engine behavior, and system-improvement flows?

---

### Concept 27 - Structured conflict resolution

#### Concept

The system may need a more explicit way to handle disagreement and collision, not just prioritization.

Examples:
- two agents produce conflicting interpretations
- two domains both claim ownership
- a queue proposal conflicts with a system-governance decision
- runtime optimization conflicts with domain coherence
- two candidate improvements pull the system in different directions

#### Why this matters

The current design is strong on structured flow, but as the system becomes more modular and more recursive, conflict becomes inevitable. Without a conflict model, edge cases will turn into ad hoc judgment calls.

#### Pressure-test question

Should CapacityOS define a formal conflict-resolution pattern for ownership disputes, competing recommendations, and incompatible agent outputs?

---

### Concept 28 - Retention, compaction, and forgetting

#### Concept

The system may need a first-class policy for what is kept, summarized, compacted, archived, or discarded across runtime and review layers.

This may apply to:
- candidate records
- backlog history
- stale queue items
- issue logs
- review outputs
- low-value generated drafts
- error reports
- runtime traces

#### Why this matters

The canon/runtime split is strong, but runtime itself can still become a context swamp if there is no retention discipline.

#### Pressure-test question

Should the system define a memory policy that distinguishes durable value from temporary operational residue, so runtime does not slowly recreate the sprawl the architecture is trying to avoid?

---

### Concept 29 - Simulation and shadow-mode operation

#### Concept

The design may benefit from a first-class simulation mode where the system can show what it would have done without actually doing it.

This could include:
- what would have been queued
- what would have been published
- what would have changed in canon
- what would have been promoted
- what the next review output would likely be

#### Why this matters

A simulation layer would give you a safer way to calibrate trust, especially around thresholded improvement, publishing, and autonomous routing behavior.

#### Pressure-test question

Should the system support a shadow-mode or dry-run path for key transitions so trust can be built through comparison before irreversible actions are taken?

---

### Concept 30 - Failure-mode doctrine and graceful degradation

#### Concept

The design may need a clearer doctrine for how the system should behave when information is incomplete, confidence is weak, or parts of the operating stack are degraded.

Examples:
- a domain is partially structured
- cadence content is missing
- steward metadata is stale
- duplicate detection is uncertain
- ranking quality is weak
- the notation pack is unavailable
- automation execution fails

#### Why this matters

It is not enough for the system to work when clean inputs are present. A trustworthy operating system also needs to fail predictably and legibly.

#### Pressure-test question

Should CapacityOS explicitly define graceful degradation rules so that partial failure produces bounded, honest behavior rather than silent misrouting or false confidence?

---

### Concept 31 - Cross-domain dependency model

#### Concept

The design may need a more explicit model for work that spans domains.

This could include:
- blocked-by relations
- dependency links
- handoff semantics
- cross-domain initiatives
- domain ownership with external dependencies
- system-governance implications for multi-domain work

#### Why this matters

The domain model is strong internally, but real work often crosses coherence boundaries. If those seams are under-modeled, the system may remain elegant inside domains but messy between them.

#### Pressure-test question

Should the design define a cross-domain dependency and handoff model so that domain coherence does not come at the expense of system-wide coordination clarity?

---

### Concept 32 - System health metrics and self-governance instrumentation

#### Concept

The system-governance domain may need a compact set of health indicators that let the system reason about its own performance.

Possible examples:
- queue freshness
- backlog surfacing precision
- human review burden
- false-positive promotion rate
- stale-domain count
- issue resolution latency
- ratio of internal draft activity to real-world consequence
- canon/runtime leakage rate

#### Why this matters

If the system is meant to govern itself, it likely needs a small set of measures that make self-governance concrete rather than purely conceptual.

#### Pressure-test question

Should the system-governance domain include explicit operating health indicators so that self-improvement can be guided by observed system behavior rather than intuition alone?

---

### Concept 33 - Canon versioning and migration discipline

#### Concept

The design may need a more explicit model for how canon evolves over time without breaking compatibility.

This could apply to:
- domain schema evolution
- domain class changes
- engine-facing contracts
- notation changes
- VSM-layer expectations
- runtime record compatibility
- migration of older domains into newer structures

#### Why this matters

A reusable operating system needs a clean story for how structures evolve. Otherwise every design improvement risks fragmenting the system or forcing manual cleanup.

#### Pressure-test question

Should CapacityOS define a migration/versioning discipline for domain canon and engine contracts so that structural evolution remains orderly and auditable?

---

## Five things I would absolutely not change

### 1. Containment / coherence / flow as the primary organizing frame

This is one of the strongest abstractions in the whole design. It gives clear placement logic and protects the architecture from collapsing runtime, canon, and substrate into one blur.

### 2. Domain as the universal coherence/governance object

This feels like the right center of gravity. It is cleaner and more extensible than letting project or task become the main organizing object.

### 3. Canon versus runtime separation

This is one of the most important anti-drift decisions in the system. It protects coherence from becoming polluted by live operational residue.

### 4. Selective human charge rather than universal human gating

This is a deep and scalable insight. It preserves human leverage where it matters most without turning the human into the throughput bottleneck for every step.

### 5. Thresholded improvement policy

The distinction between observing, proposing, preparing, and applying changes is exactly the right shape for a compounding but governable operating system.

---

## Compact synthesis

If I were pressure-testing the design at the next layer, I would focus less on the core philosophical structure and more on the control architecture around it.

The most important next questions seem to be:
- how things move
- who can do what
- how the system explains itself
- how it fails
- how it remembers
- how it evolves
