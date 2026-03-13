---
type: SKL
status: active
root: System/skills
title: "Structural Review"
slug: structural-review
skill_id: structural-review
allowed_inputs: ["proposal_slug"]
expected_outputs: ["review_summary", "recommendation"]
target_types: ["ACT", "IMP"]
canon_mutation_allowed: false
approval_required: true
agt_ref: "systems-engineer"
trigger_conditions: ["proposal_requires_review", "user_requests_structural_review"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Multi-persona team evaluation of structural proposals (System/Alignment changes, major ACTs, IMPs). Invoke the technical trio (systems-engineer, software-engineer, designer) using the multi-persona doctrine to deliver 3 rounds of feedback. Aggregate perspectives and produce a final recommendation.

## Trigger Conditions
- ACT or IMP with complexity marker or canon_mutation_allowed=true requires structural review
- User explicitly requests "review {slug} with technical trio"
- Improvement proposal involves System/ or Alignment/ mutations

## Procedure

### Step 1: Accept Input & Validate
Required:
- **proposal_slug** (format: "ACT-{slug}" or "IMP-{slug}")

1. Locate proposal in Flow/actions/:
   - File: `Flow/actions/{proposal_slug}.md`
   - If not found, reject: "Proposal not found: {proposal_slug}"

2. Read proposal:
   - Extract title, action_description or proposal field
   - Identify target (which domain or system component)
   - Extract any existing constraints or decision criteria

3. Validate proposal maturity:
   - If status is "new" or "review", warn: "Proposal may not be mature enough for structural review"
   - Proceed anyway (review can inform refinement)

### Step 2: Set Up Multi-Persona Review
1. Define three reviewer personas:

   **Persona 1: Systems Engineer**
   - Focus: architectural soundness, integration points, scalability
   - Questions: Does this design fit the VSM hierarchy? Are dependencies explicit? Can it scale?

   **Persona 2: Software Engineer**
   - Focus: implementation feasibility, tech debt, maintainability
   - Questions: Is this implementable? Does it introduce maintainability risks? Dependencies?

   **Persona 3: Designer**
   - Focus: user experience, coherence, clarity, cognitive load
   - Questions: Is this intuitive? Does it fit existing patterns? User journey clarity?

2. Each persona will evaluate the proposal in Round 1 (individual), Round 2 (cross-functional), Round 3 (synthesis)

### Step 3: Round 1 — Individual Evaluation
For each persona (sequentially or in parallel):

1. **Present proposal** to persona:
   - Title, description, target system/domain
   - Current status, decision criteria

2. **Persona generates initial assessment:**
   - Strengths (3-5 points in their domain)
   - Risks/weaknesses (2-4 points)
   - Questions for clarification (2-3)
   - Preliminary recommendation: strong support / conditional support / concerns / oppose

3. **Capture assessment:**
   - Store as structured notes for Round 2
   - Example:
     ```
     Systems Engineer Round 1:
     Strengths:
     - Decomposes domain cleanly into VSM levels
     - Explicit dependency graph
     Risks:
     - Level 4 scanning component not well integrated
     Questions:
     - How does this interact with existing Alignment/[other-domain]?
     Preliminary: Conditional support (pending clarification)
     ```

### Step 4: Round 2 — Cross-Functional Discussion
1. **Share all Round 1 assessments** among personas
2. **Each persona reads others' feedback** and refines:
   - Do other perspectives reveal blind spots?
   - Are there dependencies or conflicts between domains?
   - Updated assessment: same structure as Round 1, now accounting for cross-functional input

3. **Capture Round 2 assessments** (refined per persona)

### Step 5: Round 3 — Synthesis & Recommendation
1. **Synthesize all perspectives:**
   - Identify consensus areas (all personas agree)
   - Identify tension areas (conflicting concerns)
   - Identify open questions

2. **Produce synthesis document:**
   ```
   # Structural Review: {proposal_slug}

   ## Consensus Findings
   - {agreed strength or risk}
   - {agreed strength or risk}

   ## Tension Areas
   - {area where personas differ}:
     Systems view: {position}
     Software view: {position}
     Design view: {position}

   ## Open Questions
   - {question 1}
   - {question 2}

   ## Recommendation
   {Strong Support | Conditional Support | Request Revision | Not Recommended}

   Rationale: {2-3 sentence explanation grounded in consensus and tension areas}

   ## Conditions for Approval (if conditional)
   1. {Clarification or revision needed}
   2. {Testing or validation gate}
   ```

### Step 6: Create Review ACT (if recommendation is not strong support)
If recommendation is "conditional support", "request revision", or "not recommended":
1. Create new ACT with:
   - title: "Review {proposal_slug}: {recommendation}"
   - action_description: {synthesis document}
   - requires_approval: true (human decision on review findings)
   - alignment_domain: null or "System" (system-level decision)

2. Link review ACT to original proposal:
   - Add field to original proposal: `structural_review_act: {review_act_slug}`

3. If recommendation is "not recommended": recommend archiving original proposal

### Step 7: Log Review
1. Append to System/logs/structural-review.log:
   ```
   [timestamp] Reviewed {proposal_slug}
   Recommendation: {recommendation}
   Personas: systems-engineer, software-engineer, designer
   ```

2. Create review record:
   - File: `System/reviews/{proposal_slug}_{timestamp}.md`
   - Content: full synthesis document

### Step 8: Report
```
Structural Review Complete: {proposal_slug}

Recommendation: {Strong Support | Conditional Support | Request Revision | Not Recommended}

Strengths: {3-5 key points from consensus}
Risks: {2-4 key concerns}

Open Questions: {list}

Conditions for Approval:
1. {condition 1}
2. {condition 2}

Review Document: System/reviews/{proposal_slug}_{timestamp}.md
```

## Output Format
```
Structural Review: {proposal_slug}

Recommendation: {STRONG SUPPORT | CONDITIONAL | REVISION NEEDED | NOT RECOMMENDED}

Consensus:
- {finding}

Tensions:
- {domain}: {positions}

Next: {action}
```

## Error Handling
- **Proposal not found**: Report: "Proposal {proposal_slug} not found"
- **Persona feedback unavailable**: Log error and use simplified dual-persona review (skip unavailable persona)
- **Review ACT creation fails**: Log error but still report synthesis findings
- **Synthesis document cannot be generated**: Report: "Insufficient data to synthesize; review failed"
