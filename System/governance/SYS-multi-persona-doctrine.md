---
type: SYS
status: active
root: System/governance
title: "Multi-Persona Doctrine"
slug: multi-persona-doctrine
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

# Multi-Persona Doctrine

Generic framework for structured multi-perspective review. Personas represent distinct viewpoints or roles; this doctrine provides a repeatable process for gathering independent views, facilitating dialogue, and synthesizing recommendations.

---

## Purpose

The Multi-Persona Doctrine enables:
- **Independent thinking:** Each persona gives unbiased perspective before seeing others' views
- **Constructive challenge:** Personas react to and debate one another's positions
- **Consolidated wisdom:** Chief of Staff synthesizes into a single recommendation
- **Accountability:** All positions are tracked and recorded
- **Scalability:** Process works with 3 personas or 20, with governance controls

---

## Core Principles

1. **Independence First:** Round 1 is genuinely independent; personas don't see each other's views
2. **Radical Honesty:** Personas express true positions, not consensus-seeking
3. **Respectful Challenge:** Disagreement is expected and valuable; disrespect is not
4. **Transparent Synthesis:** Chief of Staff shows how all views influenced final recommendation
5. **Recorded Process:** All rounds and reasoning are documented for future reference

---

## Process Overview

**Default review cycle:** 3 rounds over 2-5 days
- **Round 1:** Independent perspectives (24 hours)
- **Round 2:** Reaction and challenge (24 hours)
- **Round 3:** Final position (24 hours)
- **Synthesis:** Chief of Staff consolidates into recommendation

**Process types:** No-discussion, lightweight, full (set by Chief of Staff)

---

## Personas

Personas represent specific roles, perspectives, or expertise areas. Each persona has:
- **Name:** Simple identifier (e.g., "Engineer", "Designer", "Finance")
- **Definition:** What perspective/expertise this persona brings
- **Scope limit:** What topics this persona weighs in on
- **Capacity:** How many items this persona can review simultaneously

### Persona Capacity

- **Per persona:** Maximum 2 concurrent reviews (soft limit 1)
- **System-wide:** Maximum 20 personas total (hard limit)

**Rationale:** Too many personas causes analysis paralysis; too few misses perspectives.

### Persona Scope

Each persona has explicit scope. When a topic falls outside scope:
- Persona may still comment (optional)
- Persona is not counted as required reviewer
- Persona's absence doesn't delay decision

**Example scopes:**
- Technical Engineer: Code, architecture, systems design
- Designer: UX, visuals, information architecture
- Finance: Budget, resource allocation, ROI
- Legal: Contracts, compliance, risk
- Strategy: Goals, market fit, long-term impact
- Product: User value, feature prioritization, roadmap

---

## Teams

Teams are groupings of personas for organizational structure. Common team division:

### Leadership Team

Personas focused on strategy, priorities, and resource allocation:
- Chief of Staff (decision maker, synthesis)
- Strategy Lead

### Technical Team

Personas focused on execution feasibility and design:
- Software Engineer
- Systems Engineer
- DevOps Engineer

### Design Team

Personas focused on user experience and aesthetics:
- Product Designer
- UX Researcher
- Visual Designer

### Operations Team

Personas focused on process and efficiency:
- Operations Manager
- Project Lead
- Finance

---

## Chief of Staff Role

**Responsibilities:**
1. **Gating:** Decides which reviews need multi-persona input (vs. single-persona decisions)
2. **Composition:** Selects which personas participate in this review
3. **Discussion level:** Sets whether review is no-discussion, lightweight, or full
4. **Facilitation:** Guides Round 2 conversation if full discussion
5. **Synthesis:** Consolidates Round 3 positions into single recommendation
6. **Tie-breaking:** If personas remain split after Round 3, Chief makes final call
7. **Recording:** Ensures all rounds are documented

**Chief of Staff must be present for all 3 rounds.**

---

## Three Discussion Levels

### Level: No-Discussion

**Use when:** Topic is low-stakes, persona views are likely aligned, or time is critical

**Process:**
- Round 1: Each persona gives perspective independently
- Skip Round 2 entirely
- Round 3: Chief of Staff synthesizes and decides
- **Total time:** 24 hours

**Constraints:**
- Maximum 3 personas
- No written debate
- Chief's synthesis is final

---

### Level: Lightweight

**Use when:** Topic is moderate-stakes, some disagreement expected, but debate can be brief

**Process:**
- Round 1: Each persona gives perspective independently
- Round 2: Persona sees Round 1 views; writes brief reaction (max 200 words)
- Round 3: Persona revises position based on reactions
- Chief synthesizes
- **Total time:** 48-72 hours

**Constraints:**
- Maximum 6 personas
- Brief written reactions only (no back-and-forth)
- Focused discussion topic

---

### Level: Full

**Use when:** Topic is high-stakes, substantial disagreement expected, or decision requires deep dialogue

**Process:**
- Round 1: Each persona gives perspective independently
- Round 2: Personas see Round 1 views; Chief facilitates 30-60 minute discussion
  - Personas ask clarifying questions
  - Challenge assumptions respectfully
  - Explore options jointly
  - No consensus required; goal is understanding
- Round 3: Personas submit final position (may change based on discussion)
- Chief synthesizes
- **Total time:** 3-5 days

**Constraints:**
- Maximum 10-12 personas (larger groups lose focus)
- Structured discussion (Chief keeps conversation on track)
- All personas expected to attend discussion

---

## Round 1: Independent Perspectives

**Objective:** Gather uncontaminated viewpoints before personas influence each other

**Instructions to personas:**
> "You are reviewing [topic]. Please give your independent perspective on [specific question]. Do not review other personas' responses yet. Your goal is genuine assessment, not consensus-seeking."

**Persona should address:**
1. **My assessment:** What is my honest view on this topic?
2. **My reasoning:** Why do I hold this view? What factors matter most?
3. **My concerns:** What risks or downsides do I see?
4. **My recommendations:** What should be done? What's the priority?
5. **Key assumptions:** What am I assuming to be true?
6. **Open questions:** What would change my mind? What would I need to know more about?

**Constraints:**
- Personas do not review each other's Round 1 responses
- No communication between personas
- Time limit: 24 hours from request

**Output:** Each persona submits a structured Round 1 response (see template below)

---

## Round 2: Reaction and Challenge

**Objective:** Expose contradictions, stress-test assumptions, challenge reasoning

**Instructions to personas:**
> "You now see all Round 1 perspectives. Review them carefully. Where do you agree? Where do you disagree? What assumptions do you question? Submit your response."

**For No-Discussion reviews:** Skip Round 2 entirely

**For Lightweight reviews:** Persona writes brief reaction (max 200 words):
1. **Biggest points of agreement:** Where do I see alignment?
2. **Biggest points of disagreement:** Where do I fundamentally differ?
3. **Questions I'd ask:** What would I want to understand better?
4. **My revised position:** Given what I've read, does my assessment change?

**For Full reviews:** Chief of Staff facilitates 30-60 minute discussion:
1. **Chief opens:** Summarizes the key disagreements from Round 1
2. **Structured round-robin:** Each persona has 3 minutes to:
   - Ask clarifying questions
   - Challenge assumptions
   - Propose alternatives
3. **Open discussion:** Personas engage on points of disagreement (Chief keeps focused)
4. **No decisions yet:** Goal is understanding, not consensus
5. **Chief summarizes:** Restates key positions and remaining questions

**Time limit:** 24 hours (lightweight) or scheduled meeting (full)

**Output:**
- Lightweight: Written reaction from each persona
- Full: Meeting notes and recorded positions

---

## Round 3: Final Position

**Objective:** Allow personas to revise their position in light of Round 2 input

**Instructions to personas:**
> "After reviewing Round 2 feedback [and/or attending the discussion], submit your final position. You may maintain, refine, or change your original assessment. Explain any evolution in your thinking."

**Persona should submit:**
1. **Final recommendation:** What do I recommend?
2. **Confidence level:** How strongly do I hold this view?
3. **Conditions or caveats:** Under what conditions would this work? What could go wrong?
4. **Rationale:** Why is this my final position?
5. **Key changed thinking:** What did I learn from Round 2 that shifted my view (if anything)?

**Constraints:**
- Time limit: 24 hours from Round 2 close
- Personas can reference their own Round 1 response
- Personas can reference other personas' responses
- Final positions are binding (used in synthesis)

**Output:** Each persona submits final position document

---

## Synthesis and Recommendation

**Chief of Staff task:** Consolidate all three rounds into a single recommendation

**Chief should produce:**
1. **Summary of Round 1:** Key independent perspectives (3-4 sentences each persona)
2. **Summary of Round 2:** Major points of agreement and disagreement
3. **Summary of Round 3:** Final positions and how they evolved
4. **Analysis:** Where do personas align? Where do fundamental differences remain?
5. **Chief's recommendation:** What should be done?
6. **Rationale:** Why this recommendation? How does it address major concerns?
7. **Trade-offs:** What are we accepting/rejecting? What are we risking?
8. **Dissent:** If personas strongly disagree with recommendation, note their dissent
9. **Next steps:** What happens next? Who does what?

**Record:** The entire synthesis should be documented in an ACT with:
- Type: ACT
- Title: "Review synthesis: [topic]"
- Content: All of the above
- Authority: If recommendation requires approval, route for authorization
- Origin: Reference to multi-persona review process

### Tie-Breaking

If personas remain evenly divided (e.g., 3 for, 3 against) after Round 3:

1. **Chief reviews reasoning:** Understand why personas disagree
2. **Chief decides:** Chief of Staff has authority to make final call
3. **Chief documents:** Record the tie, the reasoning, and Chief's call
4. **Rationale:** Explain why Chief's preference outweighs the split
5. **Escalation option:** If decision is very high-stakes, escalate to higher governance

---

## Persona Response Templates

### Round 1 Template

```markdown
# Round 1: Independent Perspective

## My Assessment
[Your honest view on the topic]

## Reasoning
[Why you hold this view; key factors]

## Concerns
[Risks, downsides, potential problems]

## Recommendations
[What should be done; priority order]

## Key Assumptions
[What are you assuming to be true?]

## Open Questions
[What would change your mind? What more would you need to know?]
```

### Round 2 Template (Lightweight)

```markdown
# Round 2: Reaction and Challenge

## Points of Agreement
[Where do you see alignment with other personas?]

## Points of Disagreement
[Where do you fundamentally differ?]

## Questions I'd Ask
[What would you want to understand better?]

## Revised Position
[Does your assessment change given Round 1 responses?]
```

### Round 3 Template

```markdown
# Round 3: Final Position

## Final Recommendation
[What do I recommend?]

## Confidence Level
[How strongly held? (High / Medium / Low)]

## Conditions and Caveats
[Under what conditions does this work? What could go wrong?]

## Rationale
[Why this is my final position]

## Key Thinking Evolution
[What did I learn from Round 2 that shifted my view, if anything?]
```

---

## Escalation Triggers

Automatic escalation to governance if:

1. **Consensus impossible:** After Round 3, personas cannot converge toward agreement (more than 50% disagreement)
2. **Major assumption challenged:** A key assumption underlying the review is questioned and unresolved
3. **Scope exceeded:** Decision has implications beyond the intended scope
4. **High-stakes tie:** Chief must decide between 2+ equally valid positions on high-impact topic
5. **Persona conflict:** Personal tension between personas affects the quality of debate
6. **Time exceeds limit:** Review has taken 3x longer than planned

**Escalation process:** Chief creates SYS governance document and routes to leadership

---

## Documenting Reviews

Every multi-persona review should generate:

### Review Metadata File (SYS type)

```yaml
---
type: SYS
status: active
root: System/governance
title: "Review: [topic]"
slug: review-[topic]-[date]
created_at: "YYYY-MM-DD"
updated_at: "YYYY-MM-DD"
---

# Review: [Topic]

**Date:** [YYYY-MM-DD]
**Chief of Staff:** [Name]
**Personas:** [List, comma-separated]
**Discussion Level:** [No-Discussion / Lightweight / Full]
**Topic:** [What is being reviewed?]
**Decision Required:** [Yes / No]
**Time Spent:** [Hours or days]

## Outcomes
[Summary of recommendation and action taken]

## Key Documents
- Round 1 responses: [Links]
- Round 2 feedback: [Links]
- Round 3 final positions: [Links]
- Synthesis: [Link]

## Escalation
[If escalated, document reason and outcome]
```

### Round Responses

Store each round's responses as separate files:
- `review-[topic]-[date]-round1-[persona-name].md`
- `review-[topic]-[date]-round2-[persona-name].md`
- `review-[topic]-[date]-round3-[persona-name].md`

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Groupthink

**Problem:** Personas feel pressure to agree; Round 1 independence is lost

**Prevention:**
- Chief explicitly asks "Does anyone disagree?" in Round 2
- Document dissent, don't suppress it
- Chief models respectful challenge

### Anti-Pattern 2: One Persona Dominates

**Problem:** One persona's voice drowns out others; discussion becomes unbalanced

**Prevention:**
- Chief gives equal time in Round 2 discussion
- Chief asks quieter personas directly: "What's your view on this?"
- Limit speaking time per round-robin turn

### Anti-Pattern 3: Consensus Theater

**Problem:** Personas pretend to agree to end the review quickly

**Prevention:**
- Chief explicitly states: "Disagreement is valuable; please be honest"
- Tie-breaking is acceptable; don't force artificial consensus
- Document genuine disagreement in synthesis

### Anti-Pattern 4: Personas Voting Like a Committee

**Problem:** Review becomes a vote; majority rules instead of reasoning prevails

**Prevention:**
- Chief's job is synthesis, not tallying votes
- Explain reasoning, not just positions
- A minority persona with strong reasoning can outweigh majority positions

### Anti-Pattern 5: Endless Debate (Full Reviews)

**Problem:** Round 2 discussion spirals; no resolution reached

**Prevention:**
- Chief limits discussion to 30-60 minutes
- Chief parking-lots tangential topics
- Chief moves to Round 3 decision even if debate unresolved

---

## Scaling Multi-Persona Doctrine

### Small Scale (3 Personas)

- Process: Lightweight only (no full reviews)
- Chief role: Can be one of the three personas (wears two hats)
- Cycle time: 48-72 hours typical
- Use case: Regular operational decisions

### Medium Scale (6-10 Personas)

- Process: All three discussion levels available
- Chief role: Dedicated role, separate from persona roles
- Cycle time: 3-5 days typical
- Use case: Strategic decisions, major changes

### Large Scale (15-20 Personas)

- Process: Only full reviews for strategic topics; most decisions use lightweight
- Chief role: Dedicated, with assistant
- Cycle time: 5-7 days for full reviews
- Use case: Organization-wide changes, governance updates
- Risk: At 20 personas, recommend breaking into sub-groups

**Hard limit:** 20 personas total (governance override required above this)

---

## Integration with CapacityOS

Multi-persona doctrine is a **review mechanism**, not a task mechanism. It feeds into the ACT (action) system:

1. **Topic needs review** → Chief creates `SYS-review-[topic].md` with scope
2. **Personas participate** → Responses stored in `System/governance/`
3. **Synthesis complete** → Chief creates `ACT-[decision]` with authority_type=approval-granted
4. **Decision authorized** → System can execute the ACT

**Example flow:**
- IMP proposed (improvement file)
- Chief routes to multi-persona review
- Round 1, 2, 3 complete
- Synthesis creates `ACT-implement-improvement-[name]` with Chief's authority
- Team executes ACT

---

## Version History

| Date | Change | Reason |
|------|--------|--------|
| 2026-03-13 | Multi-Persona Doctrine 1.0 | Initial system foundation |
