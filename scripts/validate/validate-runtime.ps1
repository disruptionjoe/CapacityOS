[CmdletBinding()]
param(
  [string[]]$Roots = @("local/runtime"),
  [switch]$IncludeArchive
)

$ErrorActionPreference = "Stop"
$WorkspaceRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$SupportedObjectTypes = @("intake-receipt", "triage-proposal", "backlog-item", "queue-item", "bundle", "run-event")

function Add-Issue {
  param($List, [string]$Path, [string]$Message)
  $List.Add(("{0}: {1}" -f $Path, $Message)) | Out-Null
}

function HasP {
  param($Object, [string]$Name)
  return $null -ne $Object -and ($Object.PSObject.Properties.Name -contains $Name)
}

function GetVal {
  param($Object, [string]$Name)
  if (HasP $Object $Name) { return $Object.$Name }
  return $null
}

function IsArr { param($Value) return $Value -is [System.Array] }
function IsStr { param($Value) return ($Value -is [string]) -and ($Value.Trim().Length -gt 0) }
function IsSlug { param($Value) return (IsStr $Value) -and ($Value -match '^[a-z0-9][a-z0-9-]*$') }
function IsGoal { param($Value) return (IsStr $Value) -and ($Value -match '^S[145]-[A-Za-z0-9][A-Za-z0-9-]*$') }
function IsTs {
  param($Value)
  if (-not (IsStr $Value)) { return $false }
  try { [DateTimeOffset]::Parse($Value) | Out-Null; return $true } catch { return $false }
}

function RefKey {
  param([string]$ObjectType, [string]$Id)
  return "{0}:{1}" -f $ObjectType, $Id
}

function Resolve-RootPath {
  param([string]$Path)
  if ([System.IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path $WorkspaceRoot $Path
}

function Relative-Path {
  param([string]$FullPath)
  $root = [System.IO.Path]::GetFullPath($WorkspaceRoot).TrimEnd('\')
  $full = [System.IO.Path]::GetFullPath($FullPath)
  if ($full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $full.Substring($root.Length).TrimStart('\')
  }
  return $full
}

function Req-Enum {
  param($Object, [string]$Name, [string[]]$Allowed, [string]$Path, $Issues)
  if (-not (HasP $Object $Name)) { Add-Issue $Issues $Path ("missing required field '{0}'" -f $Name); return $null }
  $value = GetVal $Object $Name
  if (-not (IsStr $value)) { Add-Issue $Issues $Path ("field '{0}' must be a non-empty string" -f $Name); return $null }
  if ($Allowed -notcontains $value) { Add-Issue $Issues $Path ("field '{0}' must be one of: {1}" -f $Name, ($Allowed -join ", ")) }
  return $value
}

function Req-Str {
  param($Object, [string]$Name, [string]$Path, $Issues)
  if (-not (HasP $Object $Name)) { Add-Issue $Issues $Path ("missing required field '{0}'" -f $Name); return $null }
  $value = GetVal $Object $Name
  if (-not (IsStr $value)) { Add-Issue $Issues $Path ("field '{0}' must be a non-empty string" -f $Name); return $null }
  return $value
}

function Opt-Str {
  param($Object, [string]$Name, [string]$Path, $Issues)
  if (-not (HasP $Object $Name)) { return $null }
  $value = GetVal $Object $Name
  if (-not (IsStr $value)) { Add-Issue $Issues $Path ("field '{0}' must be a non-empty string when present" -f $Name); return $null }
  return $value
}

function Req-Ts {
  param($Object, [string]$Name, [string]$Path, $Issues)
  $value = Req-Str $Object $Name $Path $Issues
  if ($null -ne $value -and -not (IsTs $value)) { Add-Issue $Issues $Path ("field '{0}' must be an ISO-8601 timestamp" -f $Name) }
  return $value
}

function Opt-Ts {
  param($Object, [string]$Name, [string]$Path, $Issues)
  $value = Opt-Str $Object $Name $Path $Issues
  if ($null -ne $value -and -not (IsTs $value)) { Add-Issue $Issues $Path ("field '{0}' must be an ISO-8601 timestamp when present" -f $Name) }
  return $value
}

function Req-Obj {
  param($Object, [string]$Name, [string]$Path, $Issues, [switch]$Optional)
  if (-not (HasP $Object $Name)) {
    if (-not $Optional) { Add-Issue $Issues $Path ("missing required object '{0}'" -f $Name) }
    return $null
  }
  $value = GetVal $Object $Name
  if ($null -eq $value -or -not ($value -is [pscustomobject])) { Add-Issue $Issues $Path ("field '{0}' must be an object" -f $Name); return $null }
  return $value
}

function Validate-StringArray {
  param($Value, [string]$Label, [int]$Minimum, [string]$Path, $Issues, [string]$Mode = "string")
  if ($null -eq $Value) { Add-Issue $Issues $Path ("missing required array '{0}'" -f $Label); return @() }
  $values = @($Value)
  if ($values.Count -lt $Minimum) { Add-Issue $Issues $Path ("field '{0}' must contain at least {1} item(s)" -f $Label, $Minimum) }
  $items = @()
  foreach ($item in $values) {
    if (-not (IsStr $item)) { Add-Issue $Issues $Path ("field '{0}' must contain only non-empty strings" -f $Label); continue }
    if ($Mode -eq "slug" -and -not (IsSlug $item)) { Add-Issue $Issues $Path ("field '{0}' contains invalid slug '{1}'" -f $Label, $item); continue }
    if ($Mode -eq "goal" -and -not (IsGoal $item)) { Add-Issue $Issues $Path ("field '{0}' contains invalid goal ref '{1}'" -f $Label, $item); continue }
    $items += $item
  }
  if (($items | Select-Object -Unique).Count -ne $items.Count) { Add-Issue $Issues $Path ("field '{0}' must not contain duplicates" -f $Label) }
  return $items
}

function Validate-Ref {
  param($Ref, [string]$Label, [string]$Path, $Issues, [string[]]$AllowedTypes = $null)
  if ($null -eq $Ref -or -not ($Ref -is [pscustomobject])) { Add-Issue $Issues $Path ("{0} must be an object ref" -f $Label); return $null }
  $type = Req-Enum $Ref "object_type" $SupportedObjectTypes $Path $Issues
  $id = Req-Str $Ref "id" $Path $Issues
  if ($null -ne $id -and -not (IsSlug $id)) { Add-Issue $Issues $Path ("{0}.id must be a canonical slug" -f $Label) }
  if ($null -ne $type -and $AllowedTypes -and ($AllowedTypes -notcontains $type)) { Add-Issue $Issues $Path ("{0} must reference one of: {1}" -f $Label, ($AllowedTypes -join ", ")) }
  if ($null -eq $type -or $null -eq $id) { return $null }
  return (RefKey $type $id)
}

function Validate-RefArray {
  param($Value, [string]$Label, [int]$Minimum, [string]$Path, $Issues, [string[]]$AllowedTypes = $null)
  if ($null -eq $Value) { Add-Issue $Issues $Path ("missing required array '{0}'" -f $Label); return @() }
  $values = @($Value)
  if ($values.Count -lt $Minimum) { Add-Issue $Issues $Path ("field '{0}' must contain at least {1} ref(s)" -f $Label, $Minimum) }
  $keys = @()
  for ($i = 0; $i -lt $values.Count; $i++) {
    $key = Validate-Ref $values[$i] ("{0}[{1}]" -f $Label, $i) $Path $Issues $AllowedTypes
    if ($null -ne $key) { $keys += $key }
  }
  if (($keys | Select-Object -Unique).Count -ne $keys.Count) { Add-Issue $Issues $Path ("field '{0}' must not contain duplicate refs" -f $Label) }
  return $keys
}

function Validate-CollisionBasis {
  param($Basis, [string]$Path, $Issues)
  if ($null -eq $Basis -or -not ($Basis -is [pscustomobject])) { Add-Issue $Issues $Path "field 'collision_basis' must be an object"; return }
  $hasAny = $false
  if (HasP $Basis "goal_refs") { if ((Validate-StringArray (GetVal $Basis "goal_refs") "collision_basis.goal_refs" 1 $Path $Issues "goal").Count -gt 0) { $hasAny = $true } }
  if (HasP $Basis "object_refs") { if ((Validate-RefArray (GetVal $Basis "object_refs") "collision_basis.object_refs" 1 $Path $Issues).Count -gt 0) { $hasAny = $true } }
  if (HasP $Basis "consequence_refs") { if ((Validate-StringArray (GetVal $Basis "consequence_refs") "collision_basis.consequence_refs" 1 $Path $Issues "slug").Count -gt 0) { $hasAny = $true } }
  if (-not $hasAny) { Add-Issue $Issues $Path "collision_basis must declare at least one closed basis dimension" }
}

function Collect-Refs {
  param($Value)
  $results = @()
  if ($null -eq $Value) { return $results }
  if (IsArr $Value) { foreach ($item in $Value) { $results += Collect-Refs $item }; return $results }
  if ($Value -is [pscustomobject]) {
    $names = $Value.PSObject.Properties.Name
    if (($names.Count -eq 2) -and ($names -contains "object_type") -and ($names -contains "id")) { return @($Value) }
    foreach ($name in $names) { $results += Collect-Refs (GetVal $Value $name) }
  }
  return $results
}

function Ref-ArrayContainsKey {
  param($Value, [string]$ExpectedKey)
  foreach ($item in @($Value)) {
    if ($item -is [pscustomobject]) {
      if ((RefKey (GetVal $item "object_type") (GetVal $item "id")) -eq $ExpectedKey) { return $true }
    }
  }
  return $false
}

$issues = New-Object System.Collections.Generic.List[string]
$entries = @()
$files = @()

foreach ($root in $Roots) {
  $resolved = Resolve-RootPath $root
  if (-not (Test-Path $resolved)) { Add-Issue $issues $root "validation root does not exist"; continue }
  $files += Get-ChildItem -Path $resolved -Recurse -File -Filter *.json | Where-Object {
    if ($IncludeArchive) { return $true }
    return $_.FullName -notmatch '[\\/]archive[\\/]'
  }
}

$files = $files | Sort-Object FullName -Unique

foreach ($file in $files) {
  $path = Relative-Path $file.FullName
  try { $object = (Get-Content -Raw $file.FullName) | ConvertFrom-Json } catch { Add-Issue $issues $path ("invalid JSON: {0}" -f $_.Exception.Message); continue }
  if ($null -eq $object -or -not ($object -is [pscustomobject])) { Add-Issue $issues $path "runtime records must be single JSON objects"; continue }

  $type = Req-Enum $object "object_type" $SupportedObjectTypes $path $issues
  if ($null -eq $type) { continue }

  switch ($type) {
    "intake-receipt" {
      $id = Req-Str $object "id" $path $issues; if ($null -ne $id -and $id -notmatch '^intake-[a-z0-9][a-z0-9-]*$') { Add-Issue $issues $path "field 'id' must match the intake id contract" }
      $status = Req-Enum $object "status" @("captured", "routed") $path $issues
      Req-Ts $object "captured_at" $path $issues | Out-Null
      $routedAt = Opt-Ts $object "routed_at" $path $issues
      if ($status -eq "routed" -and $null -eq $routedAt) { Add-Issue $issues $path "routed intake receipts must include 'routed_at'" }
      $sourceType = Req-Enum $object "source_type" @("human-conversation", "human-direct", "execution-derived", "system-generated") $path $issues
      Req-Enum $object "routing_mode" @("^que", "^now") $path $issues | Out-Null
      $domainHint = Opt-Str $object "domain_hint" $path $issues; if ($null -ne $domainHint -and -not (IsSlug $domainHint)) { Add-Issue $issues $path "field 'domain_hint' must be a canonical slug when present" }
      Opt-Str $object "summary" $path $issues | Out-Null
      $source = Req-Obj $object "source" $path $issues
      if ($null -ne $source) {
        $kind = Req-Enum $source "kind" @("raw-text", "structured-payload", "external-ref") $path $issues
        if ($kind -eq "raw-text") { Req-Str $source "raw_text" $path $issues | Out-Null }
        if ($kind -eq "external-ref") { Req-Str $source "external_ref" $path $issues | Out-Null }
        if ($kind -eq "structured-payload" -and -not (HasP $source "payload")) { Add-Issue $issues $path "structured-payload sources must include 'payload'" }
      }
      $lineage = Req-Obj $object "lineage" $path $issues -Optional
      if ($null -ne $lineage) {
        if (HasP $lineage "source_refs") { Validate-RefArray (GetVal $lineage "source_refs") "lineage.source_refs" 1 $path $issues | Out-Null }
        if (HasP $lineage "queue_refs") { Validate-RefArray (GetVal $lineage "queue_refs") "lineage.queue_refs" 1 $path $issues @("queue-item") | Out-Null }
        if (HasP $lineage "run_refs") { Validate-RefArray (GetVal $lineage "run_refs") "lineage.run_refs" 1 $path $issues @("run-event") | Out-Null }
      }
      if ($sourceType -eq "execution-derived" -and ($null -eq $lineage -or -not (HasP $lineage "source_refs") -or -not (HasP $lineage "queue_refs") -or -not (HasP $lineage "run_refs"))) { Add-Issue $issues $path "execution-derived intake receipts must preserve source_refs, queue_refs, and run_refs" }
    }
    "triage-proposal" {
      $id = Req-Str $object "id" $path $issues; if ($null -ne $id -and $id -notmatch '^triage-[a-z0-9][a-z0-9-]*$') { Add-Issue $issues $path "field 'id' must match the triage id contract" }
      $status = Req-Enum $object "status" @("proposed", "approved", "rejected", "split") $path $issues
      Req-Ts $object "created_at" $path $issues | Out-Null
      $decidedAt = Opt-Ts $object "decided_at" $path $issues
      if (@("approved", "rejected", "split") -contains $status -and $null -eq $decidedAt) { Add-Issue $issues $path "resolved triage proposals must include 'decided_at'" }
      Validate-Ref (GetVal $object "intake_ref") "intake_ref" $path $issues @("intake-receipt") | Out-Null
      $domainId = Req-Str $object "proposed_domain_id" $path $issues; if ($null -ne $domainId -and -not (IsSlug $domainId)) { Add-Issue $issues $path "field 'proposed_domain_id' must be a canonical slug" }
      Req-Enum $object "human_review_state" @("not-required", "pending", "approved", "rejected") $path $issues | Out-Null
      $outputsRaw = GetVal $object "proposed_outputs"
      if ($null -eq $outputsRaw) { Add-Issue $issues $path "field 'proposed_outputs' must be a non-empty array" }
      else {
        $outputs = @($outputsRaw)
        if ($outputs.Count -lt 1) { Add-Issue $issues $path "field 'proposed_outputs' must be a non-empty array" }
        for ($i = 0; $i -lt $outputs.Count; $i++) {
          $output = $outputs[$i]
          if ($null -eq $output -or -not ($output -is [pscustomobject])) { Add-Issue $issues $path ("proposed_outputs[{0}] must be an object" -f $i); continue }
          $outputType = Req-Enum $output "output_type" @("backlog-item", "bundle-hint", "issue", "goal-update-proposal", "reject") $path $issues
          Req-Str $output "title" $path $issues | Out-Null
          if (@("backlog-item", "bundle-hint", "issue", "goal-update-proposal") -contains $outputType) {
            $proposedId = Req-Str $output "proposed_id" $path $issues
            if ($null -ne $proposedId -and -not (IsSlug $proposedId)) { Add-Issue $issues $path ("proposed_outputs[{0}].proposed_id must be a canonical slug" -f $i) }
          }
          if (HasP $output "goal_refs") { Validate-StringArray (GetVal $output "goal_refs") ("proposed_outputs[{0}].goal_refs" -f $i) 0 $path $issues "goal" | Out-Null }
          if (HasP $output "basis") { Validate-StringArray (GetVal $output "basis") ("proposed_outputs[{0}].basis" -f $i) 1 $path $issues | Out-Null }
        }
      }
    }
    "backlog-item" {
      $id = Req-Str $object "id" $path $issues; if ($null -ne $id -and $id -notmatch '^backlog-[a-z0-9][a-z0-9-]*$') { Add-Issue $issues $path "field 'id' must match the backlog id contract" }
      Req-Enum $object "status" @("candidate", "active", "deferred", "promoted", "archived") $path $issues | Out-Null
      $domainId = Req-Str $object "domain_id" $path $issues; if ($null -ne $domainId -and -not (IsSlug $domainId)) { Add-Issue $issues $path "field 'domain_id' must be a canonical slug" }
      Req-Str $object "title" $path $issues | Out-Null
      $originTypes = Validate-StringArray (GetVal $object "origin_types") "origin_types" 1 $path $issues
      foreach ($originType in $originTypes) { if (@("human-intake", "agent-derived", "execution-derived", "system-generated") -notcontains $originType) { Add-Issue $issues $path ("origin_types contains invalid value '{0}'" -f $originType) } }
      Req-Enum $object "endorsement_state" @("unreviewed", "agent-suggested", "human-triaged", "human-approved") $path $issues | Out-Null
      Req-Ts $object "created_at" $path $issues | Out-Null
      Req-Ts $object "updated_at" $path $issues | Out-Null
      if (HasP $object "goal_refs") { Validate-StringArray (GetVal $object "goal_refs") "goal_refs" 0 $path $issues "goal" | Out-Null }
      $lineage = Req-Obj $object "lineage" $path $issues
      if ($null -ne $lineage) {
        $sourceKeys = Validate-RefArray (GetVal $lineage "source_refs") "lineage.source_refs" 1 $path $issues
        if (HasP $lineage "intake_refs") { Validate-RefArray (GetVal $lineage "intake_refs") "lineage.intake_refs" 1 $path $issues @("intake-receipt") | Out-Null }
        if ($originTypes -contains "human-intake" -and -not (HasP $lineage "intake_refs")) { Add-Issue $issues $path "human-intake backlog items must preserve intake_refs" }
        if ($originTypes -contains "execution-derived" -and -not (($sourceKeys -match '^run-event:').Count -gt 0)) { Add-Issue $issues $path "execution-derived backlog items must preserve at least one run-event source ref" }
      }
      $admission = Req-Obj $object "admission" $path $issues
      if ($null -ne $admission) {
        $outcome = Req-Enum $admission "outcome" @("create", "merge", "split") $path $issues
        Validate-StringArray (GetVal $admission "basis") "admission.basis" 1 $path $issues | Out-Null
        if ($outcome -eq "merge") {
          $sourceRefs = GetVal $lineage "source_refs"
          if (-not (IsArr $sourceRefs) -or $sourceRefs.Count -lt 2) { Add-Issue $issues $path "merge backlog items must preserve source lineage union with at least two source refs" }
        }
      }
    }
    "queue-item" {
      $id = Req-Str $object "id" $path $issues; if ($null -ne $id -and $id -notmatch '^queue-[a-z0-9][a-z0-9-]*$') { Add-Issue $issues $path "field 'id' must match the queue id contract" }
      $status = Req-Enum $object "status" @("queued", "paused", "executing", "awaiting_review", "ready_for_consequence", "done", "superseded") $path $issues
      $domainId = Req-Str $object "domain_id" $path $issues; if ($null -ne $domainId -and -not (IsSlug $domainId)) { Add-Issue $issues $path "field 'domain_id' must be a canonical slug" }
      Req-Str $object "title" $path $issues | Out-Null
      Req-Enum $object "execution_mode" @("agent", "human", "hybrid") $path $issues | Out-Null
      if (HasP $object "goal_refs") { Validate-StringArray (GetVal $object "goal_refs") "goal_refs" 0 $path $issues "goal" | Out-Null }
      $lineage = Req-Obj $object "lineage" $path $issues
      if ($null -ne $lineage) {
        Validate-RefArray (GetVal $lineage "source_refs") "lineage.source_refs" 1 $path $issues @("backlog-item") | Out-Null
        if (HasP $lineage "intake_refs") { Validate-RefArray (GetVal $lineage "intake_refs") "lineage.intake_refs" 1 $path $issues @("intake-receipt") | Out-Null }
      }
      $promotion = Req-Obj $object "promotion" $path $issues
      if ($null -ne $promotion) {
        Req-Ts $promotion "promoted_at" $path $issues | Out-Null
        Validate-StringArray (GetVal $promotion "basis") "promotion.basis" 1 $path $issues | Out-Null
        Validate-StringArray (GetVal $promotion "readiness_basis") "promotion.readiness_basis" 1 $path $issues | Out-Null
      }
      Validate-StringArray (GetVal $object "assumptions_in_force") "assumptions_in_force" 0 $path $issues | Out-Null
      Validate-CollisionBasis (GetVal $object "collision_basis") $path $issues
      $freshness = Req-Obj $object "freshness" $path $issues
      $freshnessStatus = $null
      if ($null -ne $freshness) {
        $freshnessStatus = Req-Enum $freshness "status" @("unchecked", "fresh", "pause-for-retriage", "superseded", "escalate-to-human") $path $issues
        $checkedAt = Opt-Ts $freshness "checked_at" $path $issues
        if (HasP $freshness "evidence_refs") { Validate-RefArray (GetVal $freshness "evidence_refs") "freshness.evidence_refs" 1 $path $issues | Out-Null }
        if (@("fresh", "pause-for-retriage", "superseded", "escalate-to-human") -contains $freshnessStatus) {
          if ($null -eq $checkedAt) { Add-Issue $issues $path "checked freshness states must include 'checked_at'" }
          if (-not (HasP $freshness "evidence_refs")) { Add-Issue $issues $path "checked freshness states must include 'evidence_refs'" }
        }
      }
      $supersession = Req-Obj $object "supersession" $path $issues
      $relationship = $null
      if ($null -ne $supersession) {
        $relationship = Req-Enum $supersession "relationship" @("none", "full-replacement", "partial-replacement", "invalidated-by-new-fact", "pause-pending-retriage") $path $issues
        if (HasP $supersession "by_refs") { Validate-RefArray (GetVal $supersession "by_refs") "supersession.by_refs" 1 $path $issues @("queue-item") | Out-Null }
        if (@("full-replacement", "partial-replacement", "invalidated-by-new-fact") -contains $relationship -and -not (HasP $supersession "by_refs")) { Add-Issue $issues $path "replacement supersession relationships must include 'by_refs'" }
      }
      $supersedes = Req-Obj $object "supersedes" $path $issues -Optional
      if ($null -ne $supersedes) {
        Req-Enum $supersedes "relationship" @("full-replacement", "partial-replacement", "invalidated-by-new-fact") $path $issues | Out-Null
        Validate-RefArray (GetVal $supersedes "target_refs") "supersedes.target_refs" 1 $path $issues @("queue-item") | Out-Null
      }
      if (@("executing", "awaiting_review", "ready_for_consequence", "done") -contains $status -and $freshnessStatus -ne "fresh") { Add-Issue $issues $path ("queue items in status '{0}' must have freshness.status = 'fresh'" -f $status) }
      if ($status -eq "superseded" -and $relationship -eq "none") { Add-Issue $issues $path "superseded queue items must record a non-'none' supersession relationship" }
      if ($status -eq "superseded" -and $freshnessStatus -ne "superseded") { Add-Issue $issues $path "superseded queue items must record freshness.status = 'superseded'" }
    }
    "bundle" {
      $id = Req-Str $object "id" $path $issues; if ($null -ne $id -and $id -notmatch '^bundle-[a-z0-9][a-z0-9-]*$') { Add-Issue $issues $path "field 'id' must match the bundle id contract" }
      Req-Enum $object "status" @("forming", "awaiting_bundle_review", "ready", "paused", "superseded", "done") $path $issues | Out-Null
      $domainId = Req-Str $object "domain_id" $path $issues; if ($null -ne $domainId -and -not (IsSlug $domainId)) { Add-Issue $issues $path "field 'domain_id' must be a canonical slug" }
      Req-Ts $object "created_at" $path $issues | Out-Null
      Validate-RefArray (GetVal $object "member_queue_refs") "member_queue_refs" 2 $path $issues @("queue-item") | Out-Null
      Validate-StringArray (GetVal $object "bundle_basis") "bundle_basis" 1 $path $issues | Out-Null
      Validate-StringArray (GetVal $object "assumptions_in_force") "assumptions_in_force" 0 $path $issues | Out-Null
      if (HasP $object "shared_consequence_refs") { Validate-StringArray (GetVal $object "shared_consequence_refs") "shared_consequence_refs" 1 $path $issues "slug" | Out-Null }
      Req-Enum $object "invalidation_policy" @("fail-closed", "partial-safe") $path $issues | Out-Null
      $supersession = Req-Obj $object "supersession" $path $issues
      if ($null -ne $supersession) {
        $relationship = Req-Enum $supersession "relationship" @("none", "full-replacement", "partial-replacement", "invalidated-by-new-fact", "pause-pending-retriage") $path $issues
        if (HasP $supersession "by_refs") { Validate-RefArray (GetVal $supersession "by_refs") "supersession.by_refs" 1 $path $issues @("bundle") | Out-Null }
        if (@("full-replacement", "partial-replacement", "invalidated-by-new-fact") -contains $relationship -and -not (HasP $supersession "by_refs")) { Add-Issue $issues $path "replacement bundle supersession relationships must include 'by_refs'" }
      }
    }
    "run-event" {
      $id = Req-Str $object "id" $path $issues; if ($null -ne $id -and $id -notmatch '^run-[a-z0-9][a-z0-9-]*$') { Add-Issue $issues $path "field 'id' must match the run id contract" }
      $status = Req-Enum $object "status" @("started", "completed", "failed", "cancelled") $path $issues
      Req-Enum $object "run_type" @("execution", "review", "generation") $path $issues | Out-Null
      Req-Ts $object "recorded_at" $path $issues | Out-Null
      Req-Ts $object "started_at" $path $issues | Out-Null
      $endedAt = Opt-Ts $object "ended_at" $path $issues
      if (@("completed", "failed", "cancelled") -contains $status -and $null -eq $endedAt) { Add-Issue $issues $path "completed, failed, and cancelled runs must include 'ended_at'" }
      $lineage = Req-Obj $object "lineage" $path $issues
      if ($null -ne $lineage) {
        Validate-RefArray (GetVal $lineage "source_refs") "lineage.source_refs" 1 $path $issues @("queue-item", "bundle") | Out-Null
        if (HasP $lineage "artifact_refs") { Validate-RefArray (GetVal $lineage "artifact_refs") "lineage.artifact_refs" 1 $path $issues @("artifact") | Out-Null }
        if (HasP $lineage "emitted_intake_refs") { Validate-RefArray (GetVal $lineage "emitted_intake_refs") "lineage.emitted_intake_refs" 1 $path $issues @("intake-receipt") | Out-Null }
      }
      $preflight = Req-Obj $object "preflight" $path $issues
      if ($null -ne $preflight) {
        Req-Ts $preflight "checked_at" $path $issues | Out-Null
        Req-Enum $preflight "freshness_outcome" @("fresh", "pause-for-retriage", "superseded", "escalate-to-human") $path $issues | Out-Null
        Req-Enum $preflight "collision_outcome" @("fresh", "pause-for-retriage", "superseded", "escalate-to-human") $path $issues | Out-Null
        Validate-CollisionBasis (GetVal $preflight "collision_basis") $path $issues
        if (HasP $preflight "evidence_refs") { Validate-RefArray (GetVal $preflight "evidence_refs") "preflight.evidence_refs" 1 $path $issues | Out-Null }
      }
    }
  }

  $entries += [pscustomobject]@{ Path = $path; Object = $object }
}

$registry = @{}
foreach ($entry in $entries) {
  $key = RefKey (GetVal $entry.Object "object_type") (GetVal $entry.Object "id")
  if ($registry.ContainsKey($key)) { Add-Issue $issues $entry.Path ("duplicate runtime object id '{0}'" -f $key) } else { $registry[$key] = $entry }
}

foreach ($entry in $entries) {
  foreach ($ref in (Collect-Refs $entry.Object)) {
    $key = RefKey (GetVal $ref "object_type") (GetVal $ref "id")
    if ($registry.ContainsKey($key) -eq $false -and ($SupportedObjectTypes -contains (GetVal $ref "object_type"))) {
      Add-Issue $issues $entry.Path ("unresolved ref '{0}'" -f $key)
    }
  }
}

foreach ($entry in $entries) {
  $object = $entry.Object
  $path = $entry.Path
  $type = GetVal $object "object_type"
  if ($type -eq "queue-item") {
    $thisKey = RefKey "queue-item" (GetVal $object "id")
    $supersession = GetVal $object "supersession"
    $byRefs = GetVal $supersession "by_refs"
    if ($null -ne $byRefs) {
      foreach ($byRef in @($byRefs)) {
        $replacement = $registry[(RefKey (GetVal $byRef "object_type") (GetVal $byRef "id"))]
        if ($null -ne $replacement) {
          $supersedes = GetVal $replacement.Object "supersedes"
          if ($null -eq $supersedes -or -not (Ref-ArrayContainsKey (GetVal $supersedes "target_refs") $thisKey)) {
            Add-Issue $issues $path ("replacement queue item '{0}' does not reciprocally record supersedes.target_refs" -f (GetVal $byRef "id"))
          }
        }
      }
    }
    $supersedes = GetVal $object "supersedes"
    if ($null -ne $supersedes) {
      foreach ($targetRef in @(GetVal $supersedes "target_refs")) {
        $target = $registry[(RefKey (GetVal $targetRef "object_type") (GetVal $targetRef "id"))]
        if ($null -ne $target) {
          if (-not (Ref-ArrayContainsKey (GetVal (GetVal $target.Object "supersession") "by_refs") $thisKey)) {
            Add-Issue $issues $path ("target queue item '{0}' does not reciprocally record this replacement" -f (GetVal $targetRef "id"))
          }
        }
      }
    }
  }
  if ($type -eq "bundle" -and (GetVal $object "invalidation_policy") -eq "fail-closed") {
    $hasStaleMember = $false
    foreach ($memberRef in @(GetVal $object "member_queue_refs")) {
      $member = $registry[(RefKey (GetVal $memberRef "object_type") (GetVal $memberRef "id"))]
      if ($null -ne $member) {
        $memberStatus = GetVal $member.Object "status"
        $memberFreshness = GetVal (GetVal $member.Object "freshness") "status"
        if (@("pause-for-retriage", "superseded", "escalate-to-human") -contains $memberFreshness -or $memberStatus -eq "superseded") { $hasStaleMember = $true }
      }
    }
    if ($hasStaleMember -and @("paused", "superseded") -notcontains (GetVal $object "status")) { Add-Issue $issues $path "fail-closed bundles must pause or supersede when a member becomes stale" }
  }
  if ($type -eq "run-event") {
    foreach ($intakeRef in @(GetVal (GetVal $object "lineage") "emitted_intake_refs")) {
      $intake = $registry[(RefKey (GetVal $intakeRef "object_type") (GetVal $intakeRef "id"))]
      if ($null -ne $intake) {
        if ((GetVal $intake.Object "source_type") -ne "execution-derived") { Add-Issue $issues $path ("emitted intake '{0}' must be typed as execution-derived" -f (GetVal $intakeRef "id")) }
        $thisKey = RefKey "run-event" (GetVal $object "id")
        if (-not (Ref-ArrayContainsKey (GetVal (GetVal $intake.Object "lineage") "run_refs") $thisKey)) { Add-Issue $issues $path ("emitted intake '{0}' does not preserve lineage back to this run" -f (GetVal $intakeRef "id")) }
      }
    }
  }
}

if ($issues.Count -gt 0) {
  foreach ($issue in $issues) { Write-Output ("ERROR {0}" -f $issue) }
  Write-Output ("FAILED validation with {0} issue(s)." -f $issues.Count)
  exit 1
}

$counts = $entries | Group-Object { GetVal $_.Object "object_type" } | Sort-Object Name
foreach ($count in $counts) { Write-Output ("OK    {0} {1}" -f $count.Count, $count.Name) }
Write-Output ("PASSED validation for {0} runtime object(s)." -f $entries.Count)

