# Scenario Set 02 - Morning And Review

## S05 - What Should I Do This Morning

- Starting state: tasks exist in `ready_for_joe`, `ready_for_factory`, and `awaiting_review`
- User input: `What should I do this morning?`
- Expected routing layer: personal priority logic
- Expected runtime mutation: none
- Expected queue visibility: Tonight shelf summarized but not confused with Joe actions
- Expected review visibility: Morning board surfaces only Joe-relevant items first

## S06 - Review What Ran Overnight

- Starting state: execution run and artifacts exist
- User input: `Review what ran overnight.`
- Expected routing layer: personal review flow
- Expected runtime mutation: none unless Joe marks follow-up
- Expected queue visibility: tonight leftovers remain visible separately
- Expected review visibility: review-ready artifacts grouped by project/domain

## S07 - Show Me What's Waiting On Me

- Starting state: mixed queue with several task states
- User input: `Show me what's waiting on me.`
- Expected routing layer: personal priority logic
- Expected runtime mutation: none
- Expected queue visibility: only `ready_for_joe` tasks surfaced
- Expected review visibility: draft review and approval items clearly separated
