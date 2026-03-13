---
type: SYS
status: active
root: System/governance
title: "Operating Principles"
slug: operating-principles
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

# Operating Principles

Ten core principles that guide system design, decision-making, and behavior across CapacityOS. These principles sometimes conflict; when they do, the listed priority order applies.

---

## Principle 1: Intake is Unstructured; Inbox is Structured; System is Governed; Archive is Immutable

**Statement:**
The system has four distinct stages with different rules:

- **Intake** (Flow/intake): Raw, unstructured input. Minimal validation. Low friction. No one cares about naming or format at this stage.
- **Inbox** (Flow/inbox): Triaged, structured input ready for action. Files have metadata. Clear status. Rules apply.
- **System** (System/* folders): Canonical policy, schemas, governance. Immutable once active. High scrutiny before activation.
- **Archive** (Flow/archive): Final record. Permanently immutable. No modifications, no status changes, no exceptions.

**Rationale:**
- Intake must be frictionless or people won't feed in real information
- Inbox needs structure so decisions can be made
- System needs consistency and stability
- Archive needs immutability for integrity

**In practice:**
- Don't enforce schema validation in Flow/intake — let intake be messy
- Use Flow/intake as a buffer; only move to inbox when it's triaged
- SYS files are immutable; create a new version if policy changes
- Archived files are the permanent record; they never change

**Anti-pattern:** Trying to make intake files follow schema rules — defeats the purpose

---

## Principle 2: Three-Way Validation — Filename Prefix, YAML Type, Folder Location Must All Agree

**Statement:**
Triple redundancy prevents silent corruption:

1. **Filename prefix** (ACT- in "ACT-proposal.md")
2. **YAML type field** (type: ACT in front-matter)
3. **Folder location** (stored in Flow/actions/)

All three must match exactly. Any mismatch halts processing.

**Rationale:**
- Single validation point is unreliable (one field can be missed)
- Two validation points create ambiguity (which one is correct?)
- Three validation points force explicit repair; no silent fixes

**In practice:**
- Validator checks all three independently
- If any mismatch found, create repair task (don't fix silently)
- Alignment domain files are exempt (lighter model for domain-specific files)

**Anti-pattern:** Silently fixing filename if YAML type is authoritative — hides the corruption

---

## Principle 3: No Silent Repair — Invalid Files Get Explicit Repair Tasks

**Statement:**
When a validation check fails, never fix it automatically. Instead:

1. **HALT** processing
2. **Create explicit repair task** (ACT file with task_kind=update-file)
3. **Record the incident** (timestamp, file, check, task ID)
4. **Wait for human to review and fix**

**Rationale:**
- Automated repair can hide systematic problems
- Silent fixes hide errors from the person who made them
- Explicit tasks create accountability and learning
- If the same thing fails repeatedly, that's a signal something is wrong

**In practice:**
- Validation policy (PW-01 through PW-13) defines when to fail
- On any failure, create repair ACT immediately
- Repair tasks are high-priority but not blocking
- Track repair failure rate; escalate if >5% per week

**Anti-pattern:** Automatically fixing file names, renaming slugs, or changing YAML fields

---

## Principle 4: Containment Before Flow — If Overloaded, Reduce Pressure Not Increase Output

**Statement:**
When the system gets backed up or overloaded:

**Don't:**
- Rush through triage
- Lower quality standards
- Skip validation
- Add more processes

**Do:**
- Pause intake (let Flow/intake fill up)
- Reduce active items (move some to deferred)
- Clear the backlog
- Then restart intake

**Rationale:**
- Speed creates errors; errors create more work
- Quality is worth waiting for
- Pausing intake is better than rushing output
- System that slows down is more stable than system that cuts corners

**In practice:**
- When active ACTs exceed 5, temporarily close intake
- When IBX in Flow/intake exceeds 30, triage urgently before taking new
- When approval queue exceeds 15, pause new submissions
- Recovery: Clear backlog first, then resume normal flow

**Anti-pattern:** Running harder when overloaded; this increases error rate and damages quality

---

## Principle 5: LLM Minimalism — Use Code for Deterministic Work (Arithmetic, Formatting, Validation)

**Statement:**
Reserve LLM (language model, human decision-making, agent reasoning) for work that requires judgment. Use code and rules for:

- Arithmetic and calculations
- Formatting and normalization
- Validation and checking
- Routine transformations
- Deterministic routing

**Rationale:**
- LLMs are expensive and non-deterministic
- Code is cheaper and reliable
- Humans should spend time on judgment, not routine work
- Deterministic work should produce identical results every time

**In practice:**
- Validation happens with code checks (PW-01 through PW-13), not agent review
- Slug normalization happens with code (lowercase, hyphenate), not human decision
- File routing happens with code (if type=ACT, route to Flow/actions/), not agent dispatch
- Approval decisions (requires_approval=true) require human judgment, not code

**Anti-pattern:** Using agents to validate schemas, check file format, or do arithmetic

---

## Principle 6: Agent Determinism Over Human Readability — When They Conflict, Determinism Wins

**Statement:**
When a design choice must pick between:

- **A:** Human-friendly naming, structure, or format
- **B:** Machine-deterministic structure, validation, machine-parsing

Choose B.

**Rationale:**
- Machines operate 24/7; humans operate 8 hours
- Determinism prevents errors; readability is nice but not required
- Agents need signals that are unambiguous; humans are flexible
- If humans need readability, add a separate human-facing view

**In practice:**
- Slug format is deterministic (lowercase-kebab-case) even if ugly to humans
- YAML front-matter is strict (not loose) so parsers don't fail
- Filenames follow rigid pattern (TYPE-slug.md) not descriptive titles
- Validation is binary pass/fail, no "close enough"

**Exception:** Where readability doesn't reduce determinism, be readable too

**Anti-pattern:** Choosing human-friendly naming if it breaks machine parsing

---

## Principle 7: The Board IS the Greeting — No Preamble, Just Render the Actionable State

**Statement:**
When presenting the system state (to a human or agent):

**Don't:**
- Explain what the system is
- Provide context or background
- Offer suggestions
- Apologize for delays

**Do:**
- Render the current state (what's in motion, what's next)
- Show actionable items only
- Let the item speak for itself
- Move directly to "what's next?"

**Rationale:**
- People know what the system is; don't waste their time
- Actions are self-explanatory; context is noise
- Actionable state is useful; commentary is not
- Quick display means faster decision-making

**In practice:**
- Display active ACTs (status=active) with their done_condition, not history
- Show approval queue with priorities, not explanations
- List pending IBX by order of arrival, not category
- Highlight items requiring decisions, not items completed

**Example (wrong):**
> "Hi! Your personal operating system has processed 14 intake items today, mostly from email and notes. There are 5 items waiting for approval, which is slightly higher than average. You also have 3 actions in progress..."

**Example (right):**
> "Active: 3 | Pending approval: 5 | In intake: 14 | Next: ACT-Q1-planning (requires approval by tomorrow)"

---

## Principle 8: Keep "In Motion" to 3 Items — More Than That Triggers Paralysis

**Statement:**
Define "In Motion" as ACTs with status=`active` or status=`review`:

- **Ideal:** 1-3 items in motion
- **Acceptable:** Up to 5 items
- **Warning:** 6+ items (paralysis likely)
- **Critical:** 10+ items (system is broken, pause intake)

**Rationale:**
- Humans can focus on 3-5 things at once
- More than 5 spreads attention too thin
- Context-switching has a cost
- Paralysis happens when nothing is progressing

**In practice:**
- Weekly check: Count active+review ACTs
- If count ≥ 6, pause new intake until one completes
- If count ≥ 10, emergency action: move some to deferred, focus on 3-5
- Track "in motion" metric weekly

**Exception:** During critical periods, 5-7 is acceptable if moving toward completion

**Anti-pattern:** Trying to actively work on 15 things at once and wondering why nothing finishes

---

## Principle 9: Prefer Action Over Planning When Both Are Available

**Statement:**
When you have a choice between:

- **A:** Plan (create an IMP, design a solution, wait for approval)
- **B:** Act (create an ACT, execute, learn from result)

Choose B.

**Rationale:**
- Planning is useful but can become procrastination
- Action produces feedback; planning produces uncertainty
- Small action beats big plan
- Learning from action beats hypothetical planning

**In practice:**
- "Should I plan this?" → No, create the action and iterate
- "Is this ready?" → Start it now, improve as you go
- "Do we have buy-in?" → Build it, get feedback, refine
- IMPs are for systemic improvements, not for every decision

**Exception:** High-cost actions (expensive, irreversible, risky) warrant planning first

**Anti-pattern:** Excessive planning that delays start; "we'll execute when everything is perfect"

---

## Principle 10: Reduce Friction to Act — The System Should Make Starting Easy

**Statement:**
The system should be designed so that starting an action is frictionless:

- **Intake:** No validation, minimal structure, just drop it in
- **Inbox:** Clear metadata, ready to act on
- **Actions:** Pre-defined templates, authority clear, no surprises
- **Execution:** Skills are pre-built, agents are empowered, minimal approval

**Rationale:**
- High friction delays action and discourages participation
- Low friction means more good actions start
- Starting is the hardest part; make it easy
- Friction eliminates good ideas, not bad ones

**In practice:**
- IBX files need no schema validation (Principle 1)
- ACT creation should take 5 minutes, not 30
- Action templates should be pre-written
- Authority should be clear (don't require approval unless necessary)
- Skills should be documented and ready to use

**Anti-pattern:** Requiring extensive justification, approval, or planning before allowing an action to start

---

## Priority Order When Principles Conflict

When two principles conflict, apply them in this priority order:

1. **Principle 3 (No Silent Repair)** — Always explicit, never silent
2. **Principle 6 (Determinism over Readability)** — Machine wins over human-friendly
3. **Principle 2 (Triple Redundancy)** — Validation must be consistent
4. **Principle 4 (Containment over Flow)** — Quality over speed
5. **Principle 5 (LLM Minimalism)** — Use code, not agents, for routine work
6. **Principle 1 (Staged Governance)** — Keep stages separate
7. **Principle 8 (Limit In Motion)** — Focus over breadth
8. **Principle 9 (Action over Planning)** — Start rather than plan
9. **Principle 7 (Board is the Greeting)** — No preamble, actionable state
10. **Principle 10 (Reduce Friction)** — Make starting easy

**Example conflict:** Principle 4 (quality) vs. Principle 10 (reduce friction)
- **Resolution:** Use Principle 4; require validation even if it adds friction
- **Mitigation:** Make validation automatic (code-based, not manual) to reduce actual friction

**Example conflict:** Principle 9 (action) vs. Principle 8 (limit in motion)
- **Resolution:** Use Principle 8; don't start new action if already 5+ active
- **Mitigation:** Complete existing actions faster, then start new ones

---

## Applying Principles to Common Scenarios

### Scenario 1: Someone Creates a Malformed ACT File

**Principle 2:** Three-way validation must catch it
**Principle 3:** Create repair task, don't fix silently
**Principle 5:** Use code validation, not agent review

**Action:** Validator detects mismatch (PW-02 or PW-03), creates ACT-repair task, halts processing

---

### Scenario 2: System Has 8 Active ACTs, New Urgent Action Comes In

**Principle 8:** In Motion = 8, which is over 5 (warning threshold)
**Principle 9:** Want to start new action
**Principle 4:** Can't add more without losing quality

**Action:** Defer new action or pause until one completes. Don't start #9.

---

### Scenario 3: Should We Plan the Q2 Roadmap or Just Start Building?

**Principle 9:** Prefer action
**Principle 4:** Some planning is legitimate
**Principle 10:** Low friction to start

**Action:** Create ACT-build-Q2-roadmap, start immediately, refine as you go. Planning happens during execution, not before.

---

### Scenario 4: Validator Found 3 Mismatched Files This Week

**Principle 3:** Record incidents
**Principle 5:** Use code validation, not humans
**Principle 4:** Quality over speed

**Action:** Review why mismatches occurred. Is validation code broken? Is creation process unclear? Fix the root cause, not just the symptom.

---

## Review and Evolution

**These principles are living guidance, not rules.**

- Every 3 months, review which principles are being violated most
- If a principle is violated repeatedly, either:
  - **Strengthen the principle** (make it clearer, more actionable)
  - **Weaken the principle** (it may not apply universally)
  - **Change the principle** (with governance approval)

**Governance process:** Proposed change to operating principles requires:
1. Multi-persona review (full discussion level)
2. Trio assessment
3. Recorded rationale for change
4. New version of this document

---

## Glossary of Terms

| Term | Meaning |
|------|---------|
| **Intake** | Flow/intake folder; raw, unstructured input |
| **Inbox** | Flow/inbox folder; triaged, ready for action |
| **In Motion** | Active or under-review ACTs (status=active or status=review) |
| **Determinism** | Produces identical output every time (predictable, testable, reliable) |
| **Friction** | Effort/time required to start an action |
| **Governance** | System policy, validation, and approval authority |
| **Agent** | Autonomous actor (SKL or AGT file) |
| **Persona** | Perspective/role in multi-persona review |
| **Authority** | Permission to act (defined in ACT.authority_type) |

---

## Version History

| Date | Change | Reason |
|------|--------|--------|
| 2026-03-13 | Operating Principles 1.0 | Initial system foundation |
