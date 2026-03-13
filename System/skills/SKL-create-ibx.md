---
type: SKL
status: active
root: System/skills
title: "Create IBX"
slug: create-ibx
skill_id: create-ibx
allowed_inputs: ["title", "content", "source"]
expected_outputs: ["ibx_file_created"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["user_creates_ibx", "user_clips_input"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Create a single IBX (inbox) file from user input. Accept title, content, and optionally source metadata, validate against IBX schema, run PW checks, and write to Flow/inbox/.

## Trigger Conditions
- User explicitly provides raw input and requests "add to inbox" or "capture this"
- User clips text and requests "create IBX"
- Programmatic intake from normalized files (via SKL-normalize-inbox)

## Procedure

### Step 1: Accept Input
1. Receive from user (or calling skill):
   - **title** (required, string, max 120 chars)
   - **content** (required, string, can be multi-line)
   - **source** (optional, string, default="user_input")

### Step 2: Validate Input
1. **Title validation:**
   - Non-empty, trim whitespace
   - Max 120 characters
   - No leading/trailing special chars
   - If invalid, reject and report: "Title must be 1-120 characters"

2. **Content validation:**
   - Non-empty (at least 1 character)
   - If invalid, reject and report: "Content cannot be empty"

3. **Source validation:**
   - If provided, must be alphanumeric + underscores, max 30 chars
   - If invalid, default to "user_input"

### Step 3: Generate Metadata
1. Generate slug from title:
   - Lowercase, replace spaces with hyphens
   - Remove all non-alphanumeric chars except hyphens
   - Trim to max 40 chars
   - Check for collision in Flow/inbox/; if exists, append UUID suffix

2. Generate ibx_id:
   - UUID v4 or random alphanumeric string (16 chars)

3. Set timestamps:
   - captured_at = current UTC timestamp (ISO 8601)

### Step 4: Create YAML Front-Matter
```yaml
---
type: IBX
status: new
ibx_id: {ibx_id}
title: "{title}"
slug: {slug}
source: {source}
captured_at: "{captured_at}"
alignment_domain: null
tags: []
---
{content}
```

### Step 5: Run PW (Portal Warden) Validation
1. Check file structure against IBX schema:
   - YAML front-matter present and valid
   - All required fields present
   - Type field = "IBX"
   - Status field = "new"
2. If validation fails:
   - Report error: "IBX validation failed: {reason}"
   - Do NOT create file
   - Do NOT proceed

### Step 6: Write File
1. Write complete IBX file to:
   `Flow/inbox/{slug}_{ibx_id}.md`
2. Verify file exists and is readable
3. Report success: "IBX created: {slug}"

### Step 7: Log Event
1. Append to System/logs/create-ibx.log:
   ```
   [timestamp] IBX created: {slug} (source: {source}, chars: {len(content)})
   ```

## Output Format
```
IBX created: {slug}
Location: Flow/inbox/{slug}_{ibx_id}.md
Status: new (awaiting triage)
Title: {title}
Captured: {captured_at}
```

## Error Handling
- **Missing required input**: Reject with "Title and content are required"
- **Title/content validation failure**: Report specific violation and halt
- **PW validation failure**: Report: "IBX does not conform to schema: {reason}"
- **File I/O failure**: Report: "Failed to write IBX file: {system_error}"
- **Slug collision after retries**: Report: "Could not generate unique slug; contact system admin"
- **Flow/inbox/ does not exist**: Create directory and proceed
