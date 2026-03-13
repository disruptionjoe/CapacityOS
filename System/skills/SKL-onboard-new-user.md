---
type: SKL
status: active
root: System/skills
title: "Onboard New User"
slug: onboard-new-user
skill_id: onboard-new-user
allowed_inputs: []
expected_outputs: ["onboarding_complete", "dashboard_rendered"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["first_run_detected", "user_requests_onboarding", "empty_alignment_directory"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Guided first-run experience. Suggest default domains with pre-filled workstreams, ask one goal per workstream plus one purpose sentence per domain, process a first task, introduce system improvements via the tech trio, and set up auto-improvement. Target: up and running in ~10 minutes. Friendly, fast, low cognitive load.

## Trigger Conditions
- First time operator runs CapacityOS (no domains configured)
- User explicitly requests "help me get started"
- Alignment/ directory is empty or contains only _domain-template/

## Procedure

### Step 1: Detect Onboarding Needed
1. Check if Alignment/ directory exists — create if missing
2. Scan Alignment/ for domain subdirectories (exclude _domain-template/)
   - If zero domains found → onboarding is needed
   - Otherwise → abort (system already initialized)

### Step 2: Welcome and Invite
1. Display:
   ```
   Welcome to CapacityOS

   Disruption Joe, the creator, says hello and invites you to
   a ~10 minute onboarding. By the end you'll have:

   - A system where you can drop in any messy ideas or links
     and be sure they aren't forgotten
   - Ideas that have decisions or tasks will automagically be
     turned into Action Items and prioritized for you with
     coaching suggestions
   - A system that recursively self-improves based on you
     simply interacting with it

   Ready to begin?
   ```

2. Wait for user to confirm they're ready.

### Step 2b: Voice Recommendation and Reassurance
1. Display:
   ```
   Disruption Joe highly recommends using your voice instead
   of typing. Feel free to give longer, free-form responses
   to any of the questions — the more context the better.

   And don't worry about getting anything exactly right. The
   magic of CapacityOS is that once you finish onboarding,
   the system self-improves and will make adjustments to your
   domains, workstreams, and priorities over time. You're not
   stuck with anything — every decision you make here can and
   will evolve as you use the system.

   Sound good?
   ```

2. Wait for user to confirm before proceeding.

### Step 2c: Suggest Defaults
1. Display:
   ```
   Disruption Joe highly recommends going with the defaults so
   you can feel the flow first. Once you're set up, you use the
   system itself to recursively update and improve everything,
   including the domains and workstreams.

   He suggests starting with two domains:

   1. "Life Improvements" — health, finances, relationships
   2. "Work" — career development, your job, side hustles

   Are you okay using the defaults as suggested?
   ```

2. Accept user choice:
   - If user accepts defaults → domain_list = ["life-improvements", "work"]
   - If user provides custom names → validate and use those
   - Minimum 1 domain, maximum 5 for onboarding

### Step 3: Create Domains and Pre-Fill Workstreams
1. After user accepts defaults, display:
   ```
   Great choice. Now we're going to walk through setting up
   these two default domains. You can always choose to keep
   them, change them, or add more later.

   It can be confusing what should be a domain and what
   shouldn't. But for now, think of it this way: things that
   have to do with your personal life are workstreams in the
   Life Improvements domain, and things that have to do with
   your professional life go on the Work side.
   ```

2. Create each domain via SKL-create-domain (silently, no need to tell user)
3. Pre-fill default workstreams in YAML (do NOT ask — just set them):
   - **life-improvements:** `workstreams: ["health", "finances", "relationships"]`
   - **work:** `workstreams: ["career-development", "my-job", "side-hustle"]`
   - Custom domains: leave workstreams empty, ask user to list 2-3

### Step 4: Life Improvements — Goals per Workstream
1. Introduce and ask the first question in the same message:
   ```
   Let's get started with a few quick questions about the
   Life Improvements domain. I've set up three focus areas:
   health, finances, and relationships. You can add more later.

   Tell me about health — any goals, deadlines, or things
   you're working on?
   (be as open-ended as you like, or just say "not sure yet")
   ```

2. After user answers health, ask remaining workstreams one at a time:
   ```
   Tell me about finances — any goals, deadlines, or things
   you're working on?
   ```
   Wait for answer, then:
   ```
   And relationships — any goals, deadlines, or things
   you're focused on?
   ```

3. After all three, ask the purpose question:
   ```
   Last one for life improvements — in one sentence, what's
   your highest-level goal for using this system to improve
   your life?
   ```

4. Synthesize ALL answers into the 5 system files:
   - `system1_workstreams.md` → YAML workstreams array + goal for each as body
   - `system2_coordination.md` → infer from answers if obvious connections mentioned, otherwise leave templated
   - `system3_optimization.md` → infer any metrics from goals if obvious, otherwise leave templated
   - `system4_strategy.md` → infer approach from goals if obvious, otherwise leave templated
   - `system5_purpose.md` → user's one-sentence purpose

5. Report:
   ```
   Life improvements is set up. Moving on to work.
   ```

### Step 5: Work — Goals per Workstream
1. Introduce:
   ```
   Now let's do Work.

   I've set up three focus areas: career development, your
   current job, and your side hustle. You can change these
   or add more later.
   ```

2. Ask ONE open-ended question per workstream, one at a time:
   ```
   Tell me about career development — any goals, deadlines,
   or things you're working on?
   ```
   Wait for answer, then:
   ```
   Tell me about your current job — any goals, deadlines,
   or things you're focused on?
   ```
   Wait for answer, then:
   ```
   And your side hustle — any goals, deadlines, or things
   you're working on?
   ```

3. After all three, ask the purpose question:
   ```
   In one sentence, tell me about why you do the work you do
   — what drives you?
   ```

4. Synthesize into system files (same pattern as Step 4).

5. Report:
   ```
   Work domain is set. Both domains are ready.
   ```

### Step 6: Additional Domains
If user created more than 2 domains, repeat the pattern:
- Pre-fill workstreams if obvious, otherwise ask for 2-3
- One goal per workstream
- One purpose sentence
- Synthesize into files

### Step 7: First Task Through the Pipeline
1. Render the dashboard using SKL-surface-dashboard. It will be empty — that's the point.

2. Explain the pipeline and ask for a first task:
   ```
   This is your dashboard. It's empty right now, but here's
   how we fill it up.

   You can dump raw ideas, notes, or brain-dumps into the
   intake folder (Flow/intake/). They don't need to be
   organized or formatted. From there, the system processes
   them through a pipeline:

     intake → inbox → actions → archive

   Along the way, they become structured items — tasks to do,
   decisions to make, and even system improvements or updates
   to your domain docs.

   Give me one task, related to any domain, and let's get
   something on the board.
   ```

3. When user provides a task:
   - Create IBX in Flow/intake/
   - Normalize → Flow/inbox/
   - Triage → ACT in Flow/actions/
   - Show each step briefly
   - Rebuild ops index, render updated dashboard

### Step 8: Normalize as Scheduled Task
1. After the first task flows through:
   ```
   That normalize step — where raw intake gets structured and
   routed — that's something the system can do automatically
   on a schedule. Disruption Joe suggests running it at 3am
   so everything is processed by the time you wake up.

   Does 3am work, or would you prefer a different time?
   ```

2. Accept user's preferred time (default suggestion: 3am daily)
3. Create the scheduled task

### Step 9: Dashboard, System Improvement, and Tech Trio
1. **Render the dashboard first** using SKL-surface-dashboard. Let the user see it.

2. Transition:
   ```
   I know this dashboard is a little overkill to start, but
   Disruption Joe assures you that a few days in it will make
   more sense and advises you not to delete anything
   immediately.

   However, let's try one quick system improvement and set up
   our auto-self-improvement scheduled task with our tech trio!
   ```

3. Point out the General section on the dashboard the user just saw:
   ```
   CapacityOS can improve itself. When something feels off or
   could work better, the system creates an IMP (improvement)
   file. A "tech trio" — three specialized personas (systems
   engineer, software engineer, designer) — reviews it from
   different angles before anything changes.

   See that "General" section on the dashboard? It catches
   items without a domain. Since everything should have a
   domain, let's remove it as our first system improvement.
   ```

4. Walk through IMP lifecycle:
   - Create IMP-remove-general-section.md (status: proposed)
   - Run abbreviated tech trio review
   - Approve and execute the change
   - Mark IMP as done

5. Set up auto-improvement scheduled task with the tech trio workflow:
   ```
   Now let's schedule the system to periodically improve
   itself. Here's how the tech trio works:

   1. Each persona (systems engineer, software engineer,
      designer) independently drafts improvement tickets
   2. All tickets in the queue get prioritized
   3. The top ticket is reviewed by the full tech trio and
      updated based on their recommendations
   4. Tech trio gives a pass/fail — is it safe to try?
   5. If pass → implement automatically. If fail → resolve
      and retry next sweep.

   You never have to look at this if you don't want to —
   the system just keeps improving itself in the background.
   Changes are logged in SYS-imp-changelog.md if you're
   ever curious what changed.

   Want to set this up? How often — weekly?
   ```

6. Ask when (e.g., weekly on Sundays)
7. Create the scheduled task

### Step 10: Completion, Brain Dump, and Dashboard
1. Signal completion:
   ```
   Onboarding complete! Here's what we set up:

   Domains: {domain_list}
   Domain docs: ✓
   Pipeline: ✓ (first task flowing)
   Auto-normalize: ✓ (scheduled {frequency})
   Auto-improvements: ✓ (scheduled {frequency})
   First system improvement: ✓
   ```

2. Invite brain dump to populate the board:
   ```
   Now the best thing you can do is get everything out of
   your head and onto the board.

   Go ahead and drop one big freeform message with anything
   on your mind — tasks, decisions, ideas, things you've been
   meaning to do, stuff you're worried about forgetting. Don't
   worry about formatting or organizing it. I'll parse it into
   individual items and route them to the right places.

   The more you give me, the more useful the board becomes.
   ```

3. When user provides brain dump:
   - Parse into individual items
   - Create each as a file in Flow/intake/
   - Run normalize on all items (classify, tag domain/workstream, route)
   - Render the updated dashboard

4. After dashboard is rendered, share tips (ONE TIME ONLY — this is NOT part of the dashboard):
   ```
   One last tip: if you use Obsidian (obsidian.md), point it
   at your CapacityOS folder as a vault. This gives you a
   nice way to browse your domain docs, review actions, see
   improvements, and navigate the whole system visually.

   Separately — the fastest way to capture things is to drop
   files into Flow/intake/. You can do this from Obsidian,
   from your file manager, or just tell me. The normalize
   process picks them up and routes them automatically.

   Quick reference:
   - Add items: drop files in Flow/intake/ or say "capture this"
   - Review: "show dashboard" or just say hi
   ```

5. From this point forward, ALWAYS render the dashboard at the end of every interaction. The Obsidian tip and quick reference are NOT repeated — only the dashboard.

## Notes
- Pre-fill workstreams — don't ask users to name them during onboarding
- ONE question per workstream, asked one at a time — not batched
- Reassure early: nothing is permanent, any answer works, ~10 minutes
- When user picks "I'll type my own", ask conversationally — don't force multiple-choice
- Agent synthesizes S2/S3/S4 from context where possible, leaves templated otherwise
- Dashboard comes AFTER all domains are done
- The IMP section renders the dashboard FIRST so the user can see what's being improved
- The IMP section teaches by doing, not by explaining abstractly
- Auto-improvement follows the full tech trio workflow: individual drafts → prioritize → trio review → pass/fail → implement or retry
- After onboarding, invite a freeform brain dump to populate the board
- ALWAYS show the dashboard after the brain dump and at the end of every interaction from this point forward
- End with Obsidian recommendation
- Default workstreams:
  - life-improvements: health, finances, relationships
  - work: career-development, my-job, side-hustle
