[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$IssueSlug,

  [Parameter(Mandatory = $true)]
  [ValidateRange(1, 9)]
  [int]$Severity,

  [Parameter(Mandatory = $true)]
  [ValidateSet("blocker", "risk", "contradiction")]
  [string]$IssueType,

  [Parameter(Mandatory = $true)]
  [ValidateSet("open", "resolved", "superseded")]
  [string]$Status,

  [Parameter(Mandatory = $true)]
  [string]$CreatedAt,

  [Parameter(Mandatory = $true)]
  [string]$Summary,

  [Parameter(Mandatory = $true)]
  [ValidateSet("improvement-only", "pause-affected", "escalate-human")]
  [string]$FlowEffect,

  [Parameter(Mandatory = $true)]
  [string[]]$SourceRefs,

  [Parameter(Mandatory = $true)]
  [string[]]$AffectedRefs,

  [string[]]$GoalRefs,
  [string[]]$ImpactGoalRefs,
  [string[]]$ImpactObjectRefs,
  [string[]]$ImpactConsequenceRefs,
  [string]$DomainId,
  [string]$ClosedAt,
  [string]$OutputPath,
  [switch]$Force
)

$ErrorActionPreference = "Stop"
$WorkspaceRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Fail {
  param([string]$Message)
  throw $Message
}

function Ensure-NonEmptyString {
  param([string]$Value, [string]$Label)
  if ([string]::IsNullOrWhiteSpace($Value)) { Fail ("{0} must be a non-empty string." -f $Label) }
  return $Value.Trim()
}

function Ensure-Slug {
  param([string]$Value, [string]$Label)
  $trimmed = Ensure-NonEmptyString $Value $Label
  if ($trimmed -notmatch '^[a-z0-9][a-z0-9-]*$') { Fail ("{0} must be a canonical slug." -f $Label) }
  return $trimmed
}

function Ensure-GoalId {
  param([string]$Value, [string]$Label)
  $trimmed = Ensure-NonEmptyString $Value $Label
  if ($trimmed -notmatch '^S[145]-[A-Za-z0-9][A-Za-z0-9-]*$') { Fail ("{0} must be a canonical goal id." -f $Label) }
  return $trimmed
}

function Ensure-Timestamp {
  param([string]$Value, [string]$Label)
  $trimmed = Ensure-NonEmptyString $Value $Label
  try {
    [DateTimeOffset]::Parse($trimmed) | Out-Null
  } catch {
    Fail ("{0} must be an ISO-8601 timestamp." -f $Label)
  }
  return $trimmed
}

function Get-UniqueStrings {
  param([string[]]$Values, [string]$Label, [string]$Mode = "slug", [switch]$AllowEmpty)
  if (($null -eq $Values -or @($Values).Count -lt 1) -and -not $AllowEmpty) { Fail ("{0} must contain at least one item." -f $Label) }
  $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
  $result = New-Object System.Collections.Generic.List[string]
  foreach ($value in @($Values)) {
    if ($Mode -eq "slug") { $normalized = Ensure-Slug $value $Label }
    elseif ($Mode -eq "goal") { $normalized = Ensure-GoalId $value $Label }
    else { $normalized = Ensure-NonEmptyString $value $Label }
    if ($seen.Add($normalized)) { $result.Add($normalized) | Out-Null }
  }
  return @($result)
}

function Get-RefKey {
  param([string]$ObjectType, [string]$Id)
  return "{0}:{1}" -f $ObjectType, $Id
}

function Parse-RefText {
  param([string]$Text, [string]$Label)
  $trimmed = Ensure-NonEmptyString $Text $Label
  if ($trimmed -notmatch '^(?<object_type>[a-z0-9-]+):(?<id>[a-z0-9][a-z0-9-]*)$') {
    Fail ("Invalid ref '{0}'. Use object_type:id." -f $trimmed)
  }
  return [pscustomobject][ordered]@{
    object_type = $Matches.object_type
    id = $Matches.id
  }
}

function Get-UniqueSortedRefs {
  param([string[]]$RefTexts, [string]$Label)
  $map = @{}
  foreach ($refText in @($RefTexts)) {
    $ref = Parse-RefText $refText $Label
    $map[(Get-RefKey $ref.object_type $ref.id)] = $ref
  }
  return @($map.GetEnumerator() | Sort-Object Name | ForEach-Object { $_.Value })
}

function Resolve-OutputPath {
  param([string]$PathValue, [string]$DefaultPath)
  $target = $DefaultPath
  if (-not [string]::IsNullOrWhiteSpace($PathValue)) { $target = $PathValue }
  if ([System.IO.Path]::IsPathRooted($target)) { return $target }
  return Join-Path $WorkspaceRoot $target
}

function Get-CanonicalObjectPath {
  param([string]$ObjectType, [string]$Id)
  $folderMap = @{
    "intake-receipt" = "local/runtime/intake"
    "triage-proposal" = "local/runtime/triage"
    "backlog-item" = "local/runtime/backlog"
    "queue-item" = "local/runtime/queue"
    "bundle" = "local/runtime/bundles"
    "review-package" = "local/runtime/reviews"
    "artifact" = "local/runtime/artifacts"
    "issue" = "local/runtime/issues"
    "run-event" = "local/runtime/runs"
  }
  if (-not $folderMap.ContainsKey($ObjectType)) { return $null }
  return Join-Path $WorkspaceRoot (Join-Path $folderMap[$ObjectType] ("{0}.json" -f $Id))
}

function Load-RefObject {
  param($Ref)
  $path = Get-CanonicalObjectPath $Ref.object_type $Ref.id
  if ($null -eq $path -or -not (Test-Path $path)) { return $null }
  try {
    return (Get-Content -Raw $path) | ConvertFrom-Json
  } catch {
    Fail ("Unable to parse referenced object '{0}'." -f (Get-RefKey $Ref.object_type $Ref.id))
  }
}

function Get-ObjectDomainIds {
  param($Object)
  $results = @()
  if ($null -eq $Object) { return $results }
  if ($Object.PSObject.Properties.Name -contains "domain_id") {
    $domainValue = $Object.domain_id
    if ($domainValue -is [string] -and -not [string]::IsNullOrWhiteSpace($domainValue)) { $results += $domainValue.Trim() }
  }
  if ($Object.PSObject.Properties.Name -contains "domain_ids") {
    foreach ($domainValue in @($Object.domain_ids)) {
      if ($domainValue -is [string] -and -not [string]::IsNullOrWhiteSpace($domainValue)) { $results += $domainValue.Trim() }
    }
  }
  return @($results)
}

function Write-JsonFile {
  param([string]$PathValue, $Document, [switch]$Overwrite)
  $directory = Split-Path -Parent $PathValue
  if (-not (Test-Path $directory)) { New-Item -ItemType Directory -Force -Path $directory | Out-Null }
  if ((Test-Path $PathValue) -and -not $Overwrite) { Fail ("Output path already exists: {0}" -f $PathValue) }
  $json = $Document | ConvertTo-Json -Depth 10
  Set-Content -Path $PathValue -Value $json -Encoding utf8
}

if ($IssueType -in @("blocker", "contradiction") -and $FlowEffect -eq "improvement-only") {
  Fail "Blocker and contradiction issues cannot use FlowEffect = improvement-only."
}
if ($IssueType -eq "contradiction" -and @($AffectedRefs).Count -lt 2) {
  Fail "Contradiction issues must affect at least two refs."
}

$issueSlugValue = Ensure-Slug $IssueSlug "IssueSlug"
$createdAtValue = Ensure-Timestamp $CreatedAt "CreatedAt"
$summaryValue = Ensure-NonEmptyString $Summary "Summary"
$sourceRefObjects = @(Get-UniqueSortedRefs $SourceRefs "SourceRefs")
$affectedRefObjects = @(Get-UniqueSortedRefs $AffectedRefs "AffectedRefs")
if ($sourceRefObjects.Count -lt 1) { Fail "SourceRefs must contain at least one canonical ref." }
if ($affectedRefObjects.Count -lt 1) { Fail "AffectedRefs must contain at least one canonical ref." }

$goalRefValues = @()
if ($null -ne $GoalRefs -and @($GoalRefs).Count -gt 0) {
  $goalRefValues = @(Get-UniqueStrings $GoalRefs "GoalRefs" "goal")
}

$impactGoalValues = @()
if ($null -ne $ImpactGoalRefs -and @($ImpactGoalRefs).Count -gt 0) {
  $impactGoalValues = @(Get-UniqueStrings $ImpactGoalRefs "ImpactGoalRefs" "goal")
}

$impactObjectRefValues = @()
if ($null -ne $ImpactObjectRefs -and @($ImpactObjectRefs).Count -gt 0) {
  $impactObjectRefValues = @(Get-UniqueSortedRefs $ImpactObjectRefs "ImpactObjectRefs")
}

$impactConsequenceValues = @()
if ($null -ne $ImpactConsequenceRefs -and @($ImpactConsequenceRefs).Count -gt 0) {
  $impactConsequenceValues = @(Get-UniqueStrings $ImpactConsequenceRefs "ImpactConsequenceRefs" "slug")
}

if ($impactGoalValues.Count -lt 1 -and $impactObjectRefValues.Count -lt 1 -and $impactConsequenceValues.Count -lt 1) {
  Fail "At least one impact basis dimension must be supplied."
}

if ($Status -in @("resolved", "superseded")) {
  if ([string]::IsNullOrWhiteSpace($ClosedAt)) { Fail "ClosedAt is required when Status is resolved or superseded." }
  $ClosedAt = Ensure-Timestamp $ClosedAt "ClosedAt"
} elseif (-not [string]::IsNullOrWhiteSpace($ClosedAt)) {
  $ClosedAt = Ensure-Timestamp $ClosedAt "ClosedAt"
}

$derivedDomainIds = New-Object System.Collections.Generic.List[string]
foreach ($ref in @($sourceRefObjects + $affectedRefObjects)) {
  $object = Load-RefObject $ref
  foreach ($domainValue in (Get-ObjectDomainIds $object)) {
    $derivedDomainIds.Add((Ensure-Slug $domainValue "Derived domain id")) | Out-Null
  }
}

$derivedDomainIds = @($derivedDomainIds | Sort-Object -Unique)
$finalDomainId = $null
if (-not [string]::IsNullOrWhiteSpace($DomainId)) {
  $finalDomainId = Ensure-Slug $DomainId "DomainId"
  if ($derivedDomainIds.Count -gt 0 -and ($derivedDomainIds -notcontains $finalDomainId)) {
    Fail "DomainId does not match the domains directly present on the selected source or affected refs."
  }
} else {
  if ($derivedDomainIds.Count -eq 1) {
    $finalDomainId = $derivedDomainIds[0]
  } elseif ($derivedDomainIds.Count -gt 1) {
    Fail "DomainId is required when the selected refs span multiple direct domains."
  } else {
    Fail "DomainId could not be derived directly from the selected refs. Supply -DomainId explicitly."
  }
}

$issueId = "issue-{0}" -f $issueSlugValue
$defaultOutputPath = Join-Path $WorkspaceRoot ("local/runtime/issues/{0}.json" -f $issueId)
$resolvedOutputPath = Resolve-OutputPath $OutputPath $defaultOutputPath

$impactBasis = [ordered]@{}
if ($impactGoalValues.Count -gt 0) { $impactBasis.goal_refs = @($impactGoalValues) }
if ($impactObjectRefValues.Count -gt 0) { $impactBasis.object_refs = @($impactObjectRefValues) }
if ($impactConsequenceValues.Count -gt 0) { $impactBasis.consequence_refs = @($impactConsequenceValues) }

$document = [pscustomobject][ordered]@{
  object_type = "issue"
  id = $issueId
  domain_id = $finalDomainId
  severity = $Severity
  issue_type = $IssueType
  status = $Status
  created_at = $createdAtValue
  summary = $summaryValue
  flow_effect = $FlowEffect
  lineage = [pscustomobject][ordered]@{
    source_refs = @($sourceRefObjects)
  }
  affected_refs = @($affectedRefObjects)
  impact_basis = [pscustomobject]$impactBasis
}

if ($goalRefValues.Count -gt 0) {
  $document | Add-Member -NotePropertyName "goal_refs" -NotePropertyValue @($goalRefValues)
}
if (-not [string]::IsNullOrWhiteSpace($ClosedAt)) {
  $document | Add-Member -NotePropertyName "closed_at" -NotePropertyValue $ClosedAt
}

Write-JsonFile -PathValue $resolvedOutputPath -Document $document -Overwrite:$Force
Write-Output ("WROTE {0}" -f $resolvedOutputPath)
