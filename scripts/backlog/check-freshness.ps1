[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$QueueId,

  [string[]]$Roots = @("local/runtime"),
  [string]$CheckedAt,
  [switch]$WriteBack
)

$ErrorActionPreference = "Stop"
$WorkspaceRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Fail {
  param([string]$Message)
  throw $Message
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

function IsStr {
  param($Value)
  return ($Value -is [string]) -and ($Value.Trim().Length -gt 0)
}

function Ensure-QueueId {
  param([string]$Value)
  if (-not (IsStr $Value) -or $Value -notmatch '^queue-[a-z0-9][a-z0-9-]*$') {
    Fail "QueueId must be a canonical queue id."
  }
  return $Value.Trim()
}

function Ensure-Timestamp {
  param([string]$Value, [string]$Label)
  if (-not (IsStr $Value)) { Fail ("{0} must be an ISO-8601 timestamp." -f $Label) }
  try {
    [DateTimeOffset]::Parse($Value.Trim()) | Out-Null
  } catch {
    Fail ("{0} must be an ISO-8601 timestamp." -f $Label)
  }
  return $Value.Trim()
}

function Resolve-RootPath {
  param([string]$Path)
  if ([System.IO.Path]::IsPathRooted($Path)) { return $Path }
  return Join-Path $WorkspaceRoot $Path
}

function RefKey {
  param([string]$ObjectType, [string]$Id)
  return "{0}:{1}" -f $ObjectType, $Id
}

function Parse-RefKey {
  param($Ref)
  if ($null -eq $Ref) { return $null }
  return RefKey (GetVal $Ref "object_type") (GetVal $Ref "id")
}

function Unique-SortedStrings {
  param([string[]]$Values)
  return @($Values | Where-Object { IsStr $_ } | ForEach-Object { $_.Trim() } | Sort-Object -Unique)
}

function Unique-SortedRefs {
  param($Refs)
  $map = @{}
  $items = @()
  if ($null -eq $Refs) {
    $items = @()
  } elseif ($Refs -is [System.Collections.IEnumerable] -and -not ($Refs -is [string])) {
    foreach ($item in $Refs) { $items += $item }
  } else {
    $items = @($Refs)
  }
  foreach ($ref in $items) {
    if ($ref -is [pscustomobject] -and (HasP $ref "object_type") -and (HasP $ref "id")) {
      $map[(Parse-RefKey $ref)] = [pscustomobject][ordered]@{
        object_type = (GetVal $ref "object_type")
        id = (GetVal $ref "id")
      }
    }
  }
  return @($map.GetEnumerator() | Sort-Object Name | ForEach-Object { $_.Value })
}

function Get-RefArrayKeys {
  param($Refs)
  return @(Unique-SortedRefs $Refs | ForEach-Object { Parse-RefKey $_ })
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

function Write-JsonFile {
  param([string]$PathValue, $Document)
  $json = $Document | ConvertTo-Json -Depth 10
  Set-Content -Path $PathValue -Value $json -Encoding utf8
}

$queueIdValue = Ensure-QueueId $QueueId
$checkedAtValue = if (IsStr $CheckedAt) { Ensure-Timestamp $CheckedAt "CheckedAt" } else { [DateTimeOffset]::Now.ToString("o") }

$records = @()
$files = @()
foreach ($root in $Roots) {
  $resolved = Resolve-RootPath $root
  if (-not (Test-Path $resolved)) { Fail ("Freshness root does not exist: {0}" -f $root) }
  $files += Get-ChildItem -Path $resolved -Recurse -File -Filter *.json | Where-Object { $_.FullName -notmatch '[\\/]archive[\\/]' }
}

$files = $files | Sort-Object FullName -Unique
foreach ($file in $files) {
  try {
    $object = (Get-Content -Raw $file.FullName) | ConvertFrom-Json
  } catch {
    Fail ("Invalid JSON in runtime file: {0}" -f (Relative-Path $file.FullName))
  }
  if ($null -eq $object -or -not ($object -is [pscustomobject])) { continue }
  if (-not (HasP $object "object_type") -or -not (HasP $object "id")) { continue }
  $records += [pscustomobject]@{
    path = $file.FullName
    relative_path = Relative-Path $file.FullName
    object = $object
    key = RefKey (GetVal $object "object_type") (GetVal $object "id")
  }
}

$registry = @{}
foreach ($record in $records) { $registry[$record.key] = $record }

$queueKey = RefKey "queue-item" $queueIdValue
if (-not $registry.ContainsKey($queueKey)) { Fail ("Queue item not found: {0}" -f $queueIdValue) }

$queueRecord = $registry[$queueKey]
$queue = $queueRecord.object
$collisionBasis = GetVal $queue "collision_basis"
if ($null -eq $collisionBasis) { Fail ("Queue item '{0}' is missing collision_basis." -f $queueIdValue) }

$queueGoalRefs = Unique-SortedStrings @(GetVal $collisionBasis "goal_refs")
$queueObjectKeys = Unique-SortedStrings @(Get-RefArrayKeys (GetVal $collisionBasis "object_refs"))
$queueConsequenceRefs = Unique-SortedStrings @(GetVal $collisionBasis "consequence_refs")
$queueAnchorKeys = New-Object System.Collections.Generic.List[string]
$queueAnchorKeys.Add($queueKey) | Out-Null
foreach ($key in $queueObjectKeys) { if (-not $queueAnchorKeys.Contains($key)) { $queueAnchorKeys.Add($key) | Out-Null } }

$bundleKeysContainingQueue = New-Object System.Collections.Generic.List[string]
foreach ($record in $records | Where-Object { (GetVal $_.object "object_type") -eq "bundle" }) {
  $memberKeys = Get-RefArrayKeys (GetVal $record.object "member_queue_refs")
  if ($memberKeys -contains $queueKey) {
    $bundleKey = $record.key
    $bundleKeysContainingQueue.Add($bundleKey) | Out-Null
    if (-not $queueAnchorKeys.Contains($bundleKey)) { $queueAnchorKeys.Add($bundleKey) | Out-Null }
  }
}

$matchedIssues = New-Object System.Collections.Generic.List[object]
$blockingIssueRefs = New-Object System.Collections.Generic.List[object]
$escalatingIssueRefs = New-Object System.Collections.Generic.List[object]

foreach ($record in $records | Where-Object { (GetVal $_.object "object_type") -eq "issue" }) {
  $issue = $record.object
  if ((GetVal $issue "status") -ne "open") { continue }

  $affectedKeys = Unique-SortedStrings @(Get-RefArrayKeys (GetVal $issue "affected_refs"))
  $impactBasis = GetVal $issue "impact_basis"
  $issueGoalRefs = Unique-SortedStrings @(GetVal $impactBasis "goal_refs")
  $issueObjectKeys = Unique-SortedStrings @(Get-RefArrayKeys (GetVal $impactBasis "object_refs"))
  $issueConsequenceRefs = Unique-SortedStrings @(GetVal $impactBasis "consequence_refs")

  $scopeHits = New-Object System.Collections.Generic.List[string]
  foreach ($key in $affectedKeys) {
    if ($queueAnchorKeys -contains $key) { $scopeHits.Add($key) | Out-Null }
  }
  if ($scopeHits.Count -lt 1) { continue }

  $matchedDimensions = New-Object System.Collections.Generic.List[string]
  if ((@($issueGoalRefs | Where-Object { $queueGoalRefs -contains $_ })).Count -gt 0) { $matchedDimensions.Add("goal_refs") | Out-Null }
  if ((@($issueObjectKeys | Where-Object { $queueAnchorKeys -contains $_ })).Count -gt 0) { $matchedDimensions.Add("object_refs") | Out-Null }
  if ((@($issueConsequenceRefs | Where-Object { $queueConsequenceRefs -contains $_ })).Count -gt 0) { $matchedDimensions.Add("consequence_refs") | Out-Null }
  if ($matchedDimensions.Count -lt 1) { continue }

  $issueRef = [pscustomobject][ordered]@{
    object_type = "issue"
    id = (GetVal $issue "id")
  }

  $match = [pscustomobject][ordered]@{
    issue_ref = $issueRef
    flow_effect = (GetVal $issue "flow_effect")
    matched_dimensions = @($matchedDimensions | Sort-Object -Unique)
    scope_hits = @($scopeHits | Sort-Object -Unique)
  }
  $matchedIssues.Add($match) | Out-Null

  if ((GetVal $issue "flow_effect") -eq "pause-affected") { $blockingIssueRefs.Add($issueRef) | Out-Null }
  if ((GetVal $issue "flow_effect") -eq "escalate-human") { $escalatingIssueRefs.Add($issueRef) | Out-Null }
}

$outcome = "fresh"
if ($escalatingIssueRefs.Count -gt 0) {
  $outcome = "escalate-to-human"
} elseif ($blockingIssueRefs.Count -gt 0) {
  $outcome = "pause-for-retriage"
}

$evidenceRefs = @()
if ($outcome -eq "escalate-to-human") {
  $evidenceRefs = @(Unique-SortedRefs $escalatingIssueRefs)
} elseif ($outcome -eq "pause-for-retriage") {
  $evidenceRefs = @(Unique-SortedRefs $blockingIssueRefs)
} else {
  $matchedIssueRefs = @($matchedIssues | ForEach-Object { $_.issue_ref })
  if (@($matchedIssueRefs).Count -gt 0) {
    $evidenceRefs = @(Unique-SortedRefs $matchedIssueRefs)
  } else {
    $evidenceRefs = @(Unique-SortedRefs (GetVal (GetVal $queue "freshness") "evidence_refs"))
    if ($evidenceRefs.Count -lt 1) {
      $evidenceRefs = @(Unique-SortedRefs (GetVal (GetVal $queue "lineage") "source_refs"))
    }
  }
}

$result = [pscustomobject][ordered]@{
  queue_ref = [pscustomobject][ordered]@{
    object_type = "queue-item"
    id = $queueIdValue
  }
  checked_at = $checkedAtValue
  outcome = $outcome
  matched_issues = @($matchedIssues | Sort-Object { (GetVal $_.issue_ref "id") })
  evidence_refs = @($evidenceRefs)
}

if ($WriteBack) {
  $queue.freshness = [pscustomobject][ordered]@{
    status = $outcome
    checked_at = $checkedAtValue
    evidence_refs = @($evidenceRefs)
  }
  Write-JsonFile -PathValue $queueRecord.path -Document $queue
}

$result | ConvertTo-Json -Depth 10
