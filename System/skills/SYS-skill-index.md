---
type: SYS
status: active
root: System/skills
title: "Skill Index"
slug: skill-index
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

# CapacityOS Skill Index

Master registry of all 17 skills plus this index file.

## Quick Reference Table

| Skill ID | Purpose | Canon Mutation | Approval Required | Agent Ref | Trigger Keywords |
|----------|---------|---|---|---|---|
| surface-dashboard | Primary operator dashboard; real-time ranking of work by CCF (Containment/Coherence/Flow) | No | No | — | dashboard, board, show status |
| normalize-inbox | Convert raw files in Flow/intake/ to structured IBX files in Flow/inbox/ | No | No | — | normalize, intake, process files |
| triage-ibx | Classify IBX items as ACT/IMP/informational; create flow items; update status:new → triaged | No | No | triage | triage, process inbox |
| create-ibx | Create single IBX file from user input with YAML validation | No | No | — | capture, add to inbox, clip |
| create-act | Create ACT (action) file with structured metadata and initial status | No | No | — | create action, add task |
| resolve-approval | Process human decisions (approve/decline/defer) on review items; update status | No | No | — | approve, decline, defer |
| transition-status | Move items through lifecycle (active → wip → done, etc.); validate transitions | No | No | — | mark done, status change |
| archive-item | Move done/declined/rejected items from Flow/actions/ to Flow/archive/{TYPE}/ | No | No | — | archive, cleanup |
| repair-file | Diagnose validation failures; create repair ACT; log diagnostics | No | No | — | repair, validation error |
| governed-mutation | Apply approved changes to System/ or Alignment/ under ACT authority | **Yes** | **Yes** | — | apply mutation, implement change |
| summarize-alignment | Generate VSM hierarchy overview across all domains; report structure health | No | No | — | alignment, overview, domains |
| structural-review | Multi-persona (systems-engineer, software-engineer, designer) evaluation of proposals (3 rounds) | No | **Yes** | systems-engineer | review proposal, structural eval |
| create-domain | Copy Alignment/_domain-template/ to Alignment/{name}/; initialize system5_purpose.md; rebuild index | No | No | — | new domain, create domain |
| onboard-new-user | Guided first-run: detect empty Alignment/, ask for 1-2 domains, initialize, render dashboard | No | No | — | help me get started, onboard |
| generate-improvements | Technical trio scans system; identifies opportunities; creates up to 3 IMP files (status: proposed) | No | No | systems-engineer | improvements, scan, ideas |
| execute-improvement | Execute approved IMP step-by-step; update status: approved → executing → done; archive | **Yes** | No | — | execute, implement |
| review-improvement | Verify completed IMP; check all steps executed; update status: done → reviewed; archive | No | No | — | review improvement |

---

## Skill Descriptions & Workflows

### 1. **surface-dashboard** (SKL-surface-dashboard.md)
The most critical skill. Renders the primary operator interface.
- **Inputs:** None (reads system state)
- **Outputs:** Formatted dashboard board
- **Key actions:**
  1. Gather: alignment metadata, operations index, inbox count, sweep status
  2. Rank: items by CCF (Containment → Coherence → Flow)
  3. Render: dashboard with sections by domain, awaiting decisions, perspective
  4. Support quick-action shorthand: "A1 done", "D1 approve", etc.
- **No preamble, no postamble** — board IS the greeting
- **Triggers:** user requests dashboard, session startup

### 2. **normalize-inbox** (SKL-normalize-inbox.md)
Converts unstructured files in Flow/intake/ to structured IBX format.
- **Inputs:** None (scans Flow/intake/)
- **Outputs:** IBX files in Flow/inbox/, archived raw files
- **Key actions:**
  1. Scan Flow/intake/ for raw files
  2. Extract title, source, content, timestamp
  3. Generate slug, UUID, YAML front-matter
  4. Validate via PW; if fail, create diagnostic ACT
  5. Write IBX; archive original
- **Triggers:** files in intake, user requests normalization

### 3. **triage-ibx** (SKL-triage-ibx.md)
Processes IBX files with status:new; classifies and routes.
- **Inputs:** None (scans Flow/inbox/ for status:new)
- **Outputs:** ACT/IMP/archived items created; IBX status → triaged
- **Key actions:**
  1. For each IBX, classify: ACTION / IMPROVEMENT / INFORMATIONAL
  2. Create corresponding ACT or IMP
  3. Infer alignment_domain
  4. Update IBX status to triaged
- **Agent:** triage persona
- **Triggers:** new IBX items exist

### 4. **create-ibx** (SKL-create-ibx.md)
User-initiated IBX creation.
- **Inputs:** title, content, source (optional)
- **Outputs:** IBX file in Flow/inbox/
- **Key actions:**
  1. Validate title, content
  2. Generate slug, ibx_id
  3. Create YAML front-matter
  4. Run PW validation
  5. Write file; log event
- **Triggers:** user captures input, clips text

### 5. **create-act** (SKL-create-act.md)
Create action items.
- **Inputs:** title, action_description, done_condition, alignment_domain (opt), requires_approval (opt)
- **Outputs:** ACT file in Flow/actions/
- **Key actions:**
  1. Validate all inputs
  2. Determine initial status: review (if requires_approval) or active
  3. Generate slug, act_id, timestamps
  4. Create YAML front-matter
  5. Run PW validation; write file
- **Triggers:** user creates action, triage routes item

### 6. **resolve-approval** (SKL-resolve-approval.md)
Handle human decisions on review items.
- **Inputs:** slug, decision (approve/decline/defer), decision_notes (opt)
- **Outputs:** status updated (review → approved/declined, or stays review)
- **Key actions:**
  1. Locate item; validate status:review, requires_approval:true
  2. Apply decision: approve → status:approved, decline → status:declined, defer → stays review
  3. Update metadata with notes
  4. Write file; log decision
- **Triggers:** dashboard action (D1 approve), user decides

### 7. **transition-status** (SKL-transition-status.md)
Move items through valid state transitions.
- **Inputs:** slug, new_status
- **Outputs:** status updated, timestamps modified
- **Key actions:**
  1. Locate item
  2. Validate new_status is in enum
  3. Check legal transition: current_status → new_status
  4. Update file, timestamps
  5. Log transition
- **Triggers:** dashboard action (A1 done), user marks status

### 8. **archive-item** (SKL-archive-item.md)
Move completed/rejected items to archive.
- **Inputs:** slug
- **Outputs:** item moved to Flow/archive/{TYPE}/, MANIFEST updated
- **Key actions:**
  1. Locate item; verify status ∈ [done, declined, rejected]
  2. Read complete file
  3. Move to Flow/archive/{TYPE}/{name}_{status}_{timestamp}.md
  4. Update Flow/archive/{TYPE}/MANIFEST.yaml
  5. Log archival
- **Triggers:** item reaches terminal status, user archives

### 9. **repair-file** (SKL-repair-file.md)
Handle validation failures.
- **Inputs:** file_path
- **Outputs:** repair ACT created, diagnosis logged
- **Key actions:**
  1. Run PW validation; collect errors
  2. Diagnose failures (YAML, schema, missing fields)
  3. Create repair ACT with requires_approval:true
  4. Write diagnostic notes to System/repairs/
  5. Log repair task
- **Triggers:** PW validation fails, user requests repair

### 10. **governed-mutation** (SKL-governed-mutation.md)
Apply approved changes under ACT authority.
- **Inputs:** act_slug, mutation_target, mutation_content, patch_mode (opt)
- **Outputs:** change applied, ACT status → done
- **Key actions:**
  1. Verify ACT is approved, canon_mutation_allowed:true
  2. Validate target path (System/ or Alignment/)
  3. Create backup if file exists
  4. Apply patch (replace/append/merge)
  5. Run PW validation; restore if invalid
  6. Mark ACT done; log mutation
- **Canon Mutation:** Yes (modifies canonical files)
- **Approval Required:** Yes (requires approved ACT authority)
- **Triggers:** approved ACT ready for execution

### 11. **summarize-alignment** (SKL-summarize-alignment.md)
VSM overview across domains.
- **Inputs:** None (reads system state)
- **Outputs:** markdown alignment summary
- **Key actions:**
  1. Discover domains in Alignment/
  2. Read system5_purpose.md per domain
  3. Scan Flow/actions/ for active work per domain
  4. Identify constraints, risks
  5. Report: VSM structure, health, insights
- **Triggers:** user requests alignment overview, periodic review

### 12. **structural-review** (SKL-structural-review.md)
Multi-persona proposal evaluation (3 rounds).
- **Inputs:** proposal_slug (ACT or IMP)
- **Outputs:** synthesis document, recommendation, optional review ACT
- **Key actions:**
  1. Locate proposal
  2. Invoke three personas: systems-engineer, software-engineer, designer
  3. Round 1: Individual evaluation (strengths, risks, questions)
  4. Round 2: Cross-functional refinement
  5. Round 3: Synthesis (consensus, tensions, recommendation)
  6. Create review ACT if conditional/negative recommendation
- **Agent:** systems-engineer (orchestrator)
- **Approval Required:** Yes (synthesis informs decision)
- **Triggers:** complex proposal, user requests review

### 13. **create-domain** (SKL-create-domain.md)
Scaffold new alignment domain.
- **Inputs:** domain_name
- **Outputs:** Alignment/{domain_name}/ created, alignment-index rebuilt
- **Key actions:**
  1. Validate domain_name (2-50 chars, lowercase, no collision)
  2. Copy Alignment/_domain-template/ → Alignment/{domain_name}/
  3. Update system5_purpose.md YAML: domain_name
  4. Create/update alignment-index.json
  5. Log domain creation
- **Triggers:** user creates domain, onboarding

### 14. **onboard-new-user** (SKL-onboard-new-user.md)
First-run setup (2 minutes to dashboard).
- **Inputs:** None (detects empty Alignment/)
- **Outputs:** domains created, purpose initialized, dashboard rendered
- **Key actions:**
  1. Detect onboarding needed (zero domains)
  2. Ask user for 1-2 domain names
  3. Create domains via SKL-create-domain
  4. Prompt for domain purpose/strategy
  5. Offer first work item (optional)
  6. Render dashboard
- **No long tutorial** — minimal explanation, straight to working board
- **Triggers:** first run, user requests "help me get started"

### 15. **generate-improvements** (SKL-generate-improvements.md)
Technical trio scans for improvement opportunities.
- **Inputs:** None (scans system state)
- **Outputs:** up to 3 IMP files (status: proposed)
- **Key actions:**
  1. Gather system snapshot (domains, work, logs, patterns)
  2. Invoke three personas: systems-engineer, software-engineer, designer
  3. Each identifies opportunities (10-20 ideas)
  4. Cluster and score by impact + feasibility
  5. Select top 3; create IMP files
  6. Update SYS-sweep-status.md
- **Agent:** systems-engineer
- **Triggers:** user requests improvements, periodic weekly scan

### 16. **execute-improvement** (SKL-execute-improvement.md)
Execute approved IMP step-by-step.
- **Inputs:** imp_slug
- **Outputs:** IMP status: executing → done (or blocked on failure)
- **Key actions:**
  1. Locate IMP; verify status ∈ [proposed, approved]
  2. Set status → executing
  3. For each step in implementation_plan:
     - Parse step; validate
     - Execute (create files, call skills, apply config)
     - Log result; if fail, halt
  4. On success: set status → done, archive
  5. On failure: set status → blocked, create diagnostic ACT, rollback
- **Canon Mutation:** Yes (may modify System/Alignment/)
- **Triggers:** approved IMP ready, user requests execution

### 17. **review-improvement** (SKL-review-improvement.md)
Verify completed IMP; assess impact.
- **Inputs:** imp_slug
- **Outputs:** IMP status: done → reviewed → archived
- **Key actions:**
  1. Locate IMP; verify status:done
  2. For each implementation_plan step:
     - Check that step was executed correctly
     - Verify file created, config applied, skill ran, etc.
  3. Assess impact (changes verified, side effects?)
  4. Compose review_notes (pass/fail/caveats)
  5. Set status → reviewed
  6. Archive via SKL-archive-item
  7. Log review; create review record
- **Triggers:** IMP completion, user reviews improvement

### 18. **skill-index** (This File)
Master registry and navigation guide.
- **Inputs:** None
- **Outputs:** This index (searchable reference)

---

## Workflow Sequences

### Typical Operator Day
1. **Morning:** SKL-surface-dashboard → see board
2. **Intake:** SKL-normalize-inbox (if files in Flow/intake/)
3. **Triage:** SKL-triage-ibx (if new IBX items)
4. **Work:** SKL-transition-status (mark items active/wip/done)
5. **Decisions:** SKL-resolve-approval (approve/decline review items)
6. **Cleanup:** SKL-archive-item (move done items to archive)
7. **Evening:** SKL-generate-improvements (weekly or on-demand)

### Creating New Work
1. SKL-create-ibx (clip or capture)
2. SKL-triage-ibx (automatic, or manual via triage skill)
3. SKL-create-act (convert to actionable item)
4. Operator marks as active, works, marks done
5. SKL-archive-item (cleanup)

### Structural Changes
1. Proposal (ACT or IMP) created
2. SKL-structural-review (technical trio evaluates)
3. If approved: SKL-execute-improvement (for IMP) or SKL-governed-mutation (for ACT)
4. SKL-review-improvement (verify execution)
5. SKL-archive-item (cleanup)

### Adding Domains
1. SKL-create-domain (scaffold new domain)
2. Edit Alignment/{domain}/system5_purpose.md (user fills in purpose/strategy)
3. Create work in Flow/actions/ with alignment_domain={new_domain}
4. SKL-summarize-alignment (confirm domain integration)

### System Maintenance
1. SKL-generate-improvements (scan for ideas)
2. Operator reviews and prioritizes
3. SKL-execute-improvement (run approved improvement)
4. SKL-review-improvement (verify it worked)
5. Iterate

---

## Agent References

Skills with assigned agents (agt_ref field):

- **triage** → SKL-triage-ibx (classification persona)
- **systems-engineer** → SKL-structural-review, SKL-generate-improvements (architecture focus)

Multi-persona skills invoke all three personas (systems-engineer, software-engineer, designer) internally.

---

## Canon Mutation & Approval Matrix

| Skill | Canon Mutation | Approval Required | Use Case |
|-------|---|---|---|
| governed-mutation | **Yes** | **Yes** | Apply approved changes to System/ or Alignment/ |
| execute-improvement | **Yes** | No | Execute approved IMP (may mutate System/Alignment/) |
| All others | No | Mostly no | Work items, flow, decisions |
| structural-review | No | **Yes** | Evaluation requires approval to inform decision |

---

## Quick Start

**New user:**
1. Run SKL-onboard-new-user
2. Answer 1-2 domain questions
3. Set domain purpose
4. See dashboard

**Existing operator:**
1. Run SKL-surface-dashboard (show board)
2. Take action based on board recommendations
3. Use quick-action shorthand (A1 done, D1 approve, etc.)

**Learn more:**
- See individual skill files in System/skills/ for full procedures
- Skills are deterministic and chainable
- Follow the workflow sequences above for common tasks
