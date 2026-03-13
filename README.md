# CapacityOS

A personal operating system that helps you think clearly about what matters and what to do next.

CapacityOS works with an AI agent (like Claude Cowork) to keep track of your tasks, decisions, and the big areas of your life. You tell it what you care about. It organizes everything into a dashboard that shows you exactly what needs your attention right now — nothing more.

---

## How it works

CapacityOS has three folders. That's the whole system.

**System** is the brain. It contains all the rules, skills, and logic that make the system work. You don't need to touch anything in here unless you want to customize how the system behaves.

**Flow** is the conveyor belt. Things come in (tasks, ideas, decisions), get processed, get done, and get archived. Everything moves in one direction: intake → inbox → actions → archive.

**Alignment** is your life map. Each folder inside Alignment represents a major area of your life or work — like "Career," "Health," "Side Project," or "Family." These folders help the system understand *why* your tasks matter and group them by what they're connected to.

---

## Getting started

You have two options:

### Option A: Let the agent guide you (recommended)

Just open a conversation. If this is your first time, the agent will detect that you haven't set up any domains yet and walk you through it. It takes about 2 minutes. You'll name a couple of life areas, answer a quick question about each, and then see your dashboard.

### Option B: Set it up manually

1. **Pick one or two areas of your life** that you want to organize. Think of the big categories — not individual tasks, but the areas those tasks belong to. Examples: "Career," "Health," "Side Hustle," "Family," "Finances."

2. **Copy the template folder.** Inside `Alignment/`, there's a folder called `_domain-template`. Copy it and rename the copy to your domain name (e.g., `Alignment/Career/`).

3. **Open `system5_purpose.md`** and answer the questions inside. This is the most important file — it defines *why* this domain matters to you. You can write as much or as little as you want.

4. **Fill in the other files if you want.** There are four more files in each domain folder. They're all optional to start. You can come back to them later as the domain grows.

5. **Open a new conversation.** The agent will see your domains and show you a dashboard with your world organized and ready to go.

---

## The dashboard

Every time you start a conversation, the agent shows you a board — a snapshot of everything that needs your attention. It looks something like this:

```
Board: current | 7 items across 2 domains

Start here → Career: finish resume draft

── Awaiting Your Decision ──
  [D1] ACT-hire-contractor (review) — Should we hire a freelance designer?

── Career ──
  In Motion:
    [P1] ACT-finish-resume (active) — Complete resume draft
  Next:
    [P2] ACT-schedule-interview (new) — Book practice interview

── Health ──
  In Motion:
    [P1] ACT-gym-routine (active) — Follow new workout plan

── General ──
  [G1] ACT-fix-leaky-faucet (new) — Call plumber about kitchen sink

── Perspective ──
  Containment: Resume is in motion, one decision pending — manageable.
  Coherence: Career and Health are both active. Good balance.
  Flow: Unblocked. Keep moving.
```

The board IS the greeting. No small talk — just your world, organized.

**"Awaiting Your Decision"** shows items that need your sign-off before the system can act on them. You approve or decline them using quick shortcuts.

---

## Quick-action shortcuts

After seeing the board, you can respond with shorthand to take action fast:

| Shorthand | What it does |
|-----------|-------------|
| `A1 done` | Mark the first item in a domain as done |
| `A2 wip` | Mark item 2 as in-progress (active) |
| `D1 approve` | Approve a pending decision |
| `D1 decline` | Decline a pending decision |
| `S1 approve` | Approve a system improvement |
| `G1 defer` | Defer a general item |

The letters and numbers match what's on the board. It's designed to be fast — you can process your whole board in seconds.

---

## Adding things to do

There are a few ways to add things:

**Simple way:** Just tell the agent what you need to do. Say "I need to call the dentist" and it creates an action item for you. It will ask which domain it belongs to (or put it in General).

**With approval:** If something needs your sign-off first — like a big purchase or a decision that affects other people — the agent creates it with an approval flag. It shows up in "Awaiting Your Decision" on your next board.

**The lifecycle** of a simple task is: `new → active → done`. That's it. Three steps.

If something needs approval, it goes: `new → review → approved → active → done`. The extra steps mean a human (you) looked at it and said "yes, do this."

---

## Why the files are numbered 5 to 1

Inside each domain folder, you'll see files named `system5_purpose.md`, `system4_strategy.md`, and so on down to `system1_workstreams.md`. The numbering comes from a management framework called the **Viable System Model**, created by Stafford Beer in the 1970s.

The idea is simple: every healthy system — whether it's a company, a team, or an area of your life — needs five functions working together:

| File | What it means | In plain terms |
|------|--------------|----------------|
| `system5_purpose.md` | **Identity** | Why does this exist? What would be lost without it? |
| `system4_strategy.md` | **Intelligence** | Where are you heading? What are you betting on? |
| `system3_optimization.md` | **Control** | How do you know it's healthy? What do you measure? |
| `system2_coordination.md` | **Coordination** | How does this connect to other areas? Who's involved? |
| `system1_workstreams.md` | **Operations** | What are you actually doing right now? |

The numbering goes 5→1 because you start with the abstract (purpose) and work down to the concrete (daily work). Everything flows from knowing *why* the domain exists.

You don't need to understand the Viable System Model to use CapacityOS. But if you're curious, it's a powerful framework for thinking about how systems stay healthy. Stafford Beer's *Brain of the Firm* is the classic introduction.

---

## Advanced: domain rules

If you find yourself giving the agent the same instructions over and over for a specific domain — like "never schedule Health tasks before 7am" or "always check the shared calendar before booking Career meetings" — you can create a `system_rules.md` file in that domain folder.

This file isn't included by default because most people won't need it right away. But when you do, it's a powerful way to customize how the agent behaves in a specific area of your life.

---

## Recommended: Install the CapacityOS plugin

CapacityOS works out of the box — just open the folder in any AI tool and the agent reads the skills from `System/skills/`. But if you're using Claude Cowork, installing the plugin gives you faster triggering, better context management, and a smoother experience.

The plugin includes four skills that handle the most common interactions: the dashboard, inbox capture, triage, and routing. Everything else loads from the repo on demand.

**To install:** Download the `.skill` files from the [latest release](https://github.com/disruptionjoe/CapacityOS/releases) and double-click each one to install in Cowork. Install order: `capacityos-router` first, then the others in any order.

| Skill file | What it does |
|------------|-------------|
| `capacityos-router.skill` | Routes requests to the right skill (plugin or repo) |
| `capacityos-dashboard.skill` | Renders your priority board on session start |
| `capacityos-capture.skill` | Quick-captures ideas, tasks, and brain dumps to inbox |
| `capacityos-triage.skill` | Processes inbox items into actions or improvements |

The plugin is optional — the repo works standalone for any AI tool. The plugin just optimizes the hot paths for Cowork.

---

## For developers and forkers

CapacityOS is designed to be forked, customized, and extended. Here's where to start:

- **Agent operating manual:** `AGENT.md` — the complete behavioral spec for agents
- **Skill registry:** `System/skills/SYS-skill-index.md` — all 17 skills with metadata
- **Schema reference:** `System/schemas/SYS-schema-enums-registry.md` — all file types, fields, and enums
- **Validation rules:** `System/governance/SYS-validation-policy.md` — the 13 pre-write checks
- **Agent personas:** `System/agents/` — 6 specialized evaluation personas

The architecture is skill-first: agents always look for an existing skill before improvising. If you want to change how CapacityOS works, start by reading (or modifying) the skills. If you need new behavior, create a new skill file — don't patch the agent's instructions.

All internal paths are relative to `CapacityOS/` as root. The system is self-contained and doesn't depend on any external files or services (calendar integration is optional via MCP).
