---
type: SKL
status: active
root: System/skills
title: "Create Domain"
slug: create-domain
skill_id: create-domain
allowed_inputs: ["domain_name"]
expected_outputs: ["domain_created", "alignment_index_rebuilt"]
target_types: []
canon_mutation_allowed: false
approval_required: false
agt_ref: ""
trigger_conditions: ["user_creates_domain", "domain_scaffolding_requested"]
created_at: "2026-03-13"
updated_at: "2026-03-13"
---

## Purpose
Create a new alignment domain by copying Alignment/_domain-template/ to Alignment/{name}/, initializing the domain_name in system5_purpose.md YAML, and rebuilding the alignment index. This is a clean, repeatable way to spin up new organizational domains.

## Trigger Conditions
- User requests "create domain {name}" or "new domain"
- Onboarding flow (SKL-onboard-new-user) triggers domain creation
- User clicks "Add domain" in dashboard

## Procedure

### Step 1: Accept Input
Required:
- **domain_name** (string, 2-50 chars, alphanumeric + hyphens, lowercase)

### Step 2: Validate Domain Name
1. Check length: 2-50 characters
   - If invalid, reject: "Domain name must be 2-50 characters"

2. Check format: alphanumeric, hyphens, underscores only (no spaces)
   - Enforce lowercase
   - If invalid, reject: "Domain name must be lowercase alphanumeric and hyphens only"

3. Check for collision:
   - Scan Alignment/ for existing subdirectory matching domain_name
   - If exists, reject: "Domain '{domain_name}' already exists"

4. Reject reserved names:
   - Do not allow: "_domain-template", "system", "all", "default"
   - If reserved, reject: "'{domain_name}' is a reserved name"

### Step 3: Verify Template
1. Check that `Alignment/_domain-template/` exists
   - If not, reject: "Domain template not found; cannot create domain"

2. Verify template contains:
   - system5_purpose.md (required)
   - Optional: strategy/, canvas/, or other subdirs
   - If system5_purpose.md missing, reject: "Template is incomplete; missing system5_purpose.md"

### Step 4: Copy Template
1. Create directory: `Alignment/{domain_name}/`
2. Recursively copy all files from `Alignment/_domain-template/*` to `Alignment/{domain_name}/`
   - Skip `.git`, `.gitignore`, `.DS_Store` files
   - Preserve directory structure
3. Verify copy succeeded:
   - Check Alignment/{domain_name}/ exists
   - Check Alignment/{domain_name}/system5_purpose.md exists

### Step 5: Initialize Domain Metadata
1. Read `Alignment/{domain_name}/system5_purpose.md`
2. Update YAML front-matter:
   - Set domain_name = {domain_name}
   - Set created_at = current ISO timestamp
   - Leave other fields (purpose, strategy, etc.) empty or templated for user to fill
3. Write updated file back

### Step 6: Create Alignment Index Entry
1. If `System/scripts/indexes/alignment-index.json` does not exist, create it:
   ```json
   {
     "domains": []
   }
   ```

2. Read alignment-index.json (or create if missing)

3. Add entry:
   ```json
   {
     "domain_name": "{domain_name}",
     "created_at": "{timestamp}",
     "status": "initialized"
   }
   ```

4. Sort domains alphabetically by domain_name

5. Write updated alignment-index.json

### Step 7: Create Domain-Level Metadata
1. Create or update `Alignment/{domain_name}/_domain-metadata.yaml`:
   ```yaml
   domain_name: {domain_name}
   created_at: "{timestamp}"
   initialized_by: "user"
   status: "initialized"
   ```

### Step 8: Log Creation
1. Append to System/logs/create-domain.log:
   ```
   [timestamp] Domain created: {domain_name}
   Path: Alignment/{domain_name}/
   ```

### Step 9: Report
```
Domain created: {domain_name}

Location: Alignment/{domain_name}/
Template copied: ✓
Metadata initialized: ✓
Alignment index rebuilt: ✓

Next steps:
1. Edit Alignment/{domain_name}/system5_purpose.md
2. Define domain purpose and strategy
3. Create initial work in Flow/actions/ for this domain
```

## Output Format
```
Domain initialized: {domain_name}

Path: Alignment/{domain_name}/
Config: system5_purpose.md (ready for editing)
Status: initialized

Quick reference:
- Purpose statement: Alignment/{domain_name}/system5_purpose.md
- Strategy: Alignment/{domain_name}/strategy/
- Work items: Flow/actions/ (set alignment_domain={domain_name})
```

## Error Handling
- **Invalid domain_name**: Report specific validation error
- **Domain already exists**: Report: "Domain '{domain_name}' already exists at Alignment/{domain_name}/"
- **Template not found**: Report: "Cannot create domain; template not found at Alignment/_domain-template/"
- **Copy operation fails**: Report: "Failed to copy template: {system_error}"
- **Alignment/ directory does not exist**: Create it and proceed
- **Index rebuild fails**: Warn: "Domain created but alignment index not updated; rebuild manually"
