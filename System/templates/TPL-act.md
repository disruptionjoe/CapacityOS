---
# ── Required core (every ACT must have these) ──
type: ACT
status: new                    # Simple track: new → active → done
                               # Approval track: new → review → approved → active → done
                               # Escapes: blocked, deferred, declined
root: Flow/actions
title: ""                      # Short descriptive title
slug: ""                       # lowercase-kebab-case (must match filename)
created_at: ""                 # YYYY-MM-DD
updated_at: ""                 # YYYY-MM-DD
workstream: ""                 # Workstream ID from Alignment/system1_workstreams.json, or leave empty
requires_approval: false       # Set to true if this needs human sign-off before execution
action_description: ""         # What should happen
done_condition: ""             # How do we know it's done? Be specific.

# ── Optional routing (used by specific skills — safe to omit) ──
# task_kind: ""                # create-file, update-file, execute-skill, triage, multi-step, other
# authority_type: ""           # direct-human, approval-granted, routine-maintenance, skill-execution
# authority_ref: ""            # Slug of authorizing ACT (if approval-granted)
# skill_ref: ""                # Skill to invoke (if execute-skill)
# target_type: ""              # File type affected
# target_root: ""              # Where the target lives
# origin_type: ""              # IBX, ACT, IMP, or direct-human
# origin_ref: ""               # Slug of originating item
---

<!-- Body: additional context, notes, or instructions -->

## Quick Start

**For a simple task:** Fill in `title`, `slug`, `action_description`, and `done_condition`. That's it. Save and move on.

**For an approval item:** Also set `requires_approval: true`. The item will move to review status before execution.

**Example simple task:**
```yaml
title: "Review Q1 financial report"
slug: "review-q1-financial"
action_description: "Read the Q1 report and flag any items needing follow-up"
done_condition: "Report read, notes compiled, follow-up items logged as new ACTs if needed"
```

**Example approval item:**
```yaml
title: "Schedule executive offsite"
requires_approval: true
action_description: "Book venue and send calendar invites for May 15-16 offsite"
done_condition: "Venue confirmed, all executive invites sent and accepted, agenda shared"
```
