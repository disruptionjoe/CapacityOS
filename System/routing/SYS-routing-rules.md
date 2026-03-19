---
type: SYS
status: active
root: System/routing
title: "Routing Rules"
slug: routing-rules
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

# Routing Rules

Decision tree for intake → skill selection. Routes incoming requests to appropriate skills based on request type.

## Routing Decision Tree

```
USER INPUT ARRIVES
  │
  ├─ Is this a greeting or dashboard request?
  │  └─→ SKL-surface-dashboard
  │
  ├─ Is this quick-action shorthand (e.g., "/capture", "/sync")?
  │  └─→ SKL-surface-dashboard (with action processing)
  │
  ├─ Is this raw unstructured content for intake?
  │  └─→ SKL-create-ibx or SKL-normalize-inbox
  │
  ├─ Is this a request to create a task?
  │  └─→ SKL-create-act
  │
  ├─ Is this a decision on a pending approval?
  │  └─→ SKL-resolve-approval
  │
  ├─ Is this about workstream/alignment management?
  │  └─→ SKL-manage-workstreams
  │
  ├─ Is this a first-time user (empty Alignment/)?
  │  └─→ SKL-onboard-new-user
  │
  ├─ Is this about system health/improvements?
  │  └─→ Appropriate IMP skill
  │
  └─ DEFAULT: No clear intent
     └─→ Create ACT with requires_approval=true
```

## Route Details

### Route 1: Greeting / Dashboard Request
**Condition**: User says hello, asks for status, requests dashboard, etc.
**Skill**: `SKL-surface-dashboard`
**Action**: Display current state (pending tasks, recent activities, system status)

### Route 2: Quick-Action Shorthand
**Condition**: User inputs like `/capture [text]`, `/quick`, `/sync`
**Skill**: `SKL-surface-dashboard`
**Action**: Process shorthand, execute action, return results

### Route 3: Unstructured Intake
**Condition**: Raw content (meeting notes, ideas, data dumps) for later processing
**Skill**: `SKL-create-ibx` or `SKL-normalize-inbox`
**Action**: Create IBX item or normalize inbox entry

### Route 4: Task Creation
**Condition**: "Create a task to...", explicit action request
**Skill**: `SKL-create-act`
**Action**: Create ACT with appropriate metadata

### Route 5: Approval Decision
**Condition**: User responds to pending approval (yes/no/revise)
**Skill**: `SKL-resolve-approval`
**Action**: Update ACT status, trigger dependent workflows

### Route 6: Workstream/Alignment Management
**Condition**: "Create workstream X", "Update alignment", workstream queries
**Skill**: `SKL-manage-workstreams`
**Action**: Manage Alignment/ structure

### Route 7: First-Time User
**Condition**: Alignment/ directory is empty
**Skill**: `SKL-onboard-new-user`
**Action**: Initialize system, create default workstreams

### Route 8: System Health / Improvements
**Condition**: "How is the system?", improvement suggestions, sweeps
**Skill**: Appropriate IMP skill
**Action**: Run diagnostics, log improvements

### Route 9: Fallback
**Condition**: Intent unclear or ambiguous
**Skill**: Create ACT
**Action**: Create action with `requires_approval: true` for human review
