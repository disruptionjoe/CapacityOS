# Scenario Set 03 - Lifecycle And Organization

## S08 - Mark This Done

- Starting state: task in `awaiting_review` or `ready_for_joe`
- User input: `This is done.`
- Expected routing layer: lifecycle update
- Expected runtime mutation: task moves to `done`
- Expected queue visibility: removed from active shelves
- Expected review visibility: remains searchable in done/archive view

## S09 - Review Drafts By Domain

- Starting state: review-ready artifacts exist in multiple projects
- User input: `Show me the Caret drafts.`
- Expected routing layer: project-aware review filter
- Expected runtime mutation: none
- Expected queue visibility: unaffected
- Expected review visibility: only Caret review-ready artifacts shown

## S10 - Archive Or Shelve Something

- Starting state: task exists but should not stay active
- User input: `Put this on the shelf for later.`
- Expected routing layer: lifecycle update with shelf language
- Expected runtime mutation: task moves to `shelved`
- Expected queue visibility: removed from active shelves
- Expected review visibility: findable in shelf/archive views
