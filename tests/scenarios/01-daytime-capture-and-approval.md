# Scenario Set 01 - Daytime Capture And Approval

## S01 - Do This Tonight

- Starting state: project exists, no task yet
- User input: `Do this tonight: review the GitHub profile and give me the fixes.`
- Expected routing layer: personal capture -> project context -> task creation
- Expected runtime mutation: new task in `ready_for_factory`
- Expected queue visibility: appears on Tonight shelf immediately
- Expected review visibility: visible in next morning summary if run

## S02 - Capture While Driving

- Starting state: empty inbox
- User input: `Log this. I want to rethink the AI session intake flow.`
- Expected routing layer: platform adapter -> personal capture
- Expected runtime mutation: new task in `captured`
- Expected queue visibility: not on Tonight shelf yet
- Expected review visibility: visible on Inbox shelf

## S03 - Approve This Plan For Agent Execution

- Starting state: task in `ready_for_joe` with linked plan
- User input: `Yes, let the agent run this tonight.`
- Expected routing layer: personal review/approval logic
- Expected runtime mutation: task moves to `ready_for_factory`
- Expected queue visibility: appears on Tonight shelf automatically
- Expected review visibility: approval recorded in task provenance

## S04 - Add A New Repo/Project

- Starting state: project does not exist
- User input: `Add a new project for my newsletter repo.`
- Expected routing layer: project onboarding flow
- Expected runtime mutation: none required beyond onboarding request
- Expected queue visibility: none until project declaration exists
- Expected review visibility: project declaration checklist appears for review
