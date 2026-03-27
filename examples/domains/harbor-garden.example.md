---
domain_id: harbor-garden
class: default
status: active
template_version: v0.1
---

# Domain: Harbor Garden

## System 5 - Identity and Boundaries

### Purpose
- statement: Run a small neighborhood garden that coordinates volunteers,
  planting days, and simple public communication without letting operations
  become chaotic or unsafe.

### Scope
- includes:
  - volunteer-day planning
  - signage and printed instructions
  - seasonal planting coordination
  - supply and checklist preparation

### Non-Scope
- excludes:
  - long-form education programming unrelated to running the garden
  - grant-writing or partnership work outside the current operating season

### Constraints and Enduring Principles
- constraints:
  - safety and clear instructions override speed
  - seasonal timing matters more than abstract optimization
  - public communication should remain simple and neighbor-friendly

## Reusable Goal Shape

This domain uses the shared goal object. `S4` goals set seasonal direction.
`S1` goals push the next practical work forward.

## System 4 - Strategic Direction

### Goals

#### [S4-1] Reliable Volunteer Rhythm
- level: S4
- statement: make volunteer days easy to understand, safe to join, and simple
  to repeat
- supports:
  - target_type: purpose
    target_ref: purpose
- evaluation_signals:
  - volunteers can understand what to do quickly
  - each event can run without frantic last-minute coordination

#### [S4-2] Clear Seasonal Communication
- level: S4
- statement: keep signage, simple instructions, and event communication clear
  enough that neighbors know what is happening
- supports:
  - target_type: purpose
    target_ref: purpose
- evaluation_signals:
  - signage and event communication stay consistent
  - volunteers and neighbors can orient themselves quickly

## System 3 - Judgment and Prioritization

### Prioritization Policy
- prioritize_when:
  - the work makes the next volunteer day safer or clearer
  - the work reduces operational confusion for volunteers
- deprioritize_when:
  - the work is interesting but not relevant to the next real event
- escalate_when:
  - safety, weather, or unclear instructions create real event risk

### Pruning and Archival Policy
- archive_when:
  - materials are no longer seasonally relevant
- keep_active_when:
  - the item clearly supports the next event or planting window
- reject_when:
  - the item adds complexity without making the garden easier to run

### Tradeoffs and Risk Boundaries
- recurring_tradeoffs:
  - a simpler event that volunteers can execute is better than a more ambitious
    plan that creates confusion
- risk_boundaries:
  - do not queue physical-world consequence work that the human has not
    approved to carry out

### Advancement Judgment
- advance_when:
  - the package is ready to support the next volunteer day or planting action
- defer_when:
  - the event date, weather, or supply assumptions are still too unstable
- bundle_review_when:
  - signage, volunteer brief, and supply list should be judged together
- mixed_origin_judgment:
  - agent-suggested items are welcome if they support a real upcoming event and
    do not create false urgency

## System 2 - Coordination and Ordering

### Coordination Policy
- grouping_rules:
  - group work by event or planting day
- sequencing_rules:
  - confirm event basics before polishing signage
  - prepare instructions before asking people to show up
- dependency_rules:
  - signage and supply lists depend on a clear event plan
- handoff_rules:
  - physical tasks should surface as human-required consequence steps

### Queue and Flow Regulation
- queue_entry_flow:
  - event-ready materials may enter queue once the event assumptions are clear
- in_motion_adjustments:
  - event packages may be resequenced as weather or timing changes
- queue_exit_or_pause_flow:
  - pause or reroute packages when safety or timing assumptions break

### Feedback Regulation
- issue_routing:
  - volunteer confusion or event friction should become structured issues
- correction_routing:
  - post-event feedback should feed the next event package
- surprise_routing:
  - weather and turnout surprises should change the package, not just the notes

## System 1 - Execution Contract

### Goals

#### [S1-1] Prepare the Volunteer-Day Kit
- level: S1
- statement: prepare the core volunteer-day package so the next event can run
  clearly and safely
- supports:
  - target_type: goal
    target_ref: S4-1
- evaluation_signals:
  - the volunteer brief, signage, and supply list fit together
  - the package is ready for human consequence steps

#### [S1-2] Draft Spring Signage
- level: S1
- statement: create simple signage that helps volunteers and neighbors
  understand the next event and garden rules
- supports:
  - target_type: goal
    target_ref: S4-2
- evaluation_signals:
  - the signage is clear enough to print and post
  - the wording matches the volunteer brief

### Execution Units
- unit_types:
  - volunteer brief
  - signage pack
  - supply checklist
  - event package

### Readiness Contract
- ready_when:
  - the event assumptions are clear enough to prepare real materials
- required_inputs:
  - event date or timing window
  - basic volunteer instructions
- blocked_when:
  - physical-world action is required before the human has approved it

### Output Types
- output_types:
  - printable signage
  - volunteer briefs
  - supply lists
  - event packages

### Completion Contract
- done_when:
  - the package is ready for printing, posting, or event execution
- useful_partial_progress_when:
  - volunteer confusion is reduced
  - the next event package becomes more coherent

### Human-Charge Touchpoints
- requires_human_for:
  - printing materials
  - buying supplies
  - posting signage
  - running the real-world volunteer day

## Key Decisions

#### [DEC-1] Safety Over Speed
- current_effect: safety and clear instructions override schedule pressure
- consequence_for_domain:
  - event work should pause if safety assumptions are weak
- decision_ref:
  - decision_id: safety-over-speed
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/examples/decisions/harbor-garden-decisions.example.md

#### [DEC-2] Events Are the Operating Unit
- current_effect: work is grouped by event package rather than by isolated docs
- consequence_for_domain:
  - signage, briefing, and supplies should be coordinated together
- decision_ref:
  - decision_id: events-are-the-operating-unit
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/examples/decisions/harbor-garden-decisions.example.md

#### [DEC-3] Human Does Physical Consequence
- current_effect: the system prepares materials, but physical-world actions
  remain human consequence steps
- consequence_for_domain:
  - queue work can prepare but not silently execute the real-world event
- decision_ref:
  - decision_id: human-does-physical-consequence
  - source_ref: /C:/Users/joe/OneDrive/CapacityOS/examples/decisions/harbor-garden-decisions.example.md
