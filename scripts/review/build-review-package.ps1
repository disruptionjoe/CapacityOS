[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("system-2", "system-3", "system-4", "system-5")]
  [string]$ReviewLevel,

  [Parameter(Mandatory = $true)]
  [string]$ReviewLabel,

  [Parameter(Mandatory = $true)]
  [string]$ReviewDate,

  [Parameter(Mandatory = $true)]
  [string]$CreatedAt,

  [Parameter(Mandatory = $true)]
  [ValidateSet("observational", "gating", "decision-shaping")]
  [string]$ReviewKind,

  [Parameter(Mandatory = $true)]
  [string[]]$SourceRefs,

  [Parameter(Mandatory = $true)]
  [string[]]$ReviewBasis,

  [Parameter(Mandatory = $true)]
  [string[]]$PreparedFindings,

  [Parameter(Mandatory = $true)]
  [string[]]$RecommendedActions,

  [ValidateSet("not-required", "pending", "approved", "rejected")]
  [string]$HumanDecisionState = "pending",

  [string[]]$DomainIds,
  [string]$DecidedAt,
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

function Ensure-DateText {
  param([string]$Value, [string]$Label)
  $trimmed = Ensure-NonEmptyString $Value $Label
  try {
    [DateTime]::ParseExact($trimmed, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture) | Out-Null
  } catch {
    Fail ("{0} must use YYYY-MM-DD." -f $Label)
  }
  return $trimmed
}

function Ensure-StringList {
  param([string[]]$Values, [string]$Label)
  if ($null -eq $Values -or @($Values).Count -lt 1) { Fail ("{0} must contain at least one item." -f $Label) }
  $seen = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
  $result = New-Object System.Collections.Generic.List[string]
  foreach ($value in @($Values)) {
    $trimmed = Ensure-NonEmptyString $value $Label
    if ($seen.Add($trimmed)) { $result.Add($trimmed) | Out-Null }
  }
  if ($result.Count -lt 1) { Fail ("{0} must contain at least one non-empty item." -f $Label) }
  return @($result)
}

function Get-RefKey {
  param([string]$ObjectType, [string]$Id)
  return "{0}:{1}" -f $ObjectType, $Id
}

function Parse-RefText {
  param([string]$Text)
  $trimmed = Ensure-NonEmptyString $Text "SourceRefs"
  if ($trimmed -notmatch '^(?<object_type>[a-z0-9-]+):(?<id>[a-z0-9][a-z0-9-]*)$') {
    Fail ("Invalid ref '{0}'. Use object_type:id." -f $trimmed)
  }
  return [pscustomobject][ordered]@{
    object_type = $Matches.object_type
    id = $Matches.id
  }
}

function Get-UniqueSortedRefs {
  param([string[]]$RefTexts)
  $map = @{}
  foreach ($refText in @($RefTexts)) {
    $ref = Parse-RefText $refText
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
    Fail ("Unable to parse source object '{0}'." -f (Get-RefKey $Ref.object_type $Ref.id))
  }
}

function Get-ObjectDomainIds {
  param($Object)
  $results = @()
  if ($null -eq $Object) { return $results }
  if ($Object.PSObject.Properties.Name -contains "domain_id") {
    $domainId = $Object.domain_id
    if ($domainId -is [string] -and -not [string]::IsNullOrWhiteSpace($domainId)) { $results += $domainId.Trim() }
  }
  if ($Object.PSObject.Properties.Name -contains "domain_ids") {
    foreach ($domainId in @($Object.domain_ids)) {
      if ($domainId -is [string] -and -not [string]::IsNullOrWhiteSpace($domainId)) { $results += $domainId.Trim() }
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

$reviewLabelValue = Ensure-Slug $ReviewLabel "ReviewLabel"
$reviewDateValue = Ensure-DateText $ReviewDate "ReviewDate"
$createdAtValue = Ensure-Timestamp $CreatedAt "CreatedAt"
$reviewBasisValues = Ensure-StringList $ReviewBasis "ReviewBasis"
$findingValues = Ensure-StringList $PreparedFindings "PreparedFindings"
$actionValues = Ensure-StringList $RecommendedActions "RecommendedActions"

if ($HumanDecisionState -in @("approved", "rejected")) {
  if ([string]::IsNullOrWhiteSpace($DecidedAt)) { Fail "DecidedAt is required when HumanDecisionState is approved or rejected." }
  $DecidedAt = Ensure-Timestamp $DecidedAt "DecidedAt"
} elseif (-not [string]::IsNullOrWhiteSpace($DecidedAt)) {
  $DecidedAt = Ensure-Timestamp $DecidedAt "DecidedAt"
}

$sourceRefObjects = @(Get-UniqueSortedRefs $SourceRefs)
if ($sourceRefObjects.Count -lt 1) { Fail "SourceRefs must contain at least one canonical ref." }

$derivedDomainIds = New-Object System.Collections.Generic.List[string]
foreach ($ref in $sourceRefObjects) {
  $object = Load-RefObject $ref
  foreach ($domainId in (Get-ObjectDomainIds $object)) {
    $derivedDomainIds.Add((Ensure-Slug $domainId "Derived domain id")) | Out-Null
  }
}

$derivedDomainIds = @($derivedDomainIds | Sort-Object -Unique)
$finalDomainIds = @()
if ($null -ne $DomainIds -and @($DomainIds).Count -gt 0) {
  $finalDomainIds = @((Ensure-StringList $DomainIds "DomainIds") | ForEach-Object { Ensure-Slug $_ "DomainIds" } | Sort-Object -Unique)
  if ($derivedDomainIds.Count -gt 0) {
    $derivedJoined = $derivedDomainIds -join "|"
    $finalJoined = $finalDomainIds -join "|"
    if ($derivedJoined -ne $finalJoined) { Fail "DomainIds do not match the domains directly present on the selected source refs." }
  }
} else {
  if ($derivedDomainIds.Count -lt 1) { Fail "DomainIds could not be derived directly from the selected source refs. Supply -DomainIds explicitly." }
  $finalDomainIds = $derivedDomainIds
}

$reviewId = "review-{0}-{1}-{2}" -f ($ReviewLevel -replace '-', ''), $reviewLabelValue, $reviewDateValue
$defaultOutputPath = Join-Path $WorkspaceRoot ("local/runtime/reviews/{0}.json" -f $reviewId)
$resolvedOutputPath = Resolve-OutputPath $OutputPath $defaultOutputPath

$document = [pscustomobject][ordered]@{
  object_type = "review-package"
  id = $reviewId
  review_level = $ReviewLevel
  review_kind = $ReviewKind
  created_at = $createdAtValue
  domain_ids = @($finalDomainIds)
  lineage = [pscustomobject][ordered]@{
    source_refs = @($sourceRefObjects)
  }
  review_basis = @($reviewBasisValues)
  prepared_findings = @($findingValues)
  recommended_actions = @($actionValues)
  human_decision_state = $HumanDecisionState
}

if (-not [string]::IsNullOrWhiteSpace($DecidedAt)) {
  $document | Add-Member -NotePropertyName "decided_at" -NotePropertyValue $DecidedAt
}

Write-JsonFile -PathValue $resolvedOutputPath -Document $document -Overwrite:$Force
Write-Output ("WROTE {0}" -f $resolvedOutputPath)
