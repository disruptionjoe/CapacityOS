[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$ArtifactSlug,

  [Parameter(Mandatory = $true)]
  [string]$ArtifactType,

  [Parameter(Mandatory = $true)]
  [string]$CreatedAt,

  [Parameter(Mandatory = $true)]
  [string[]]$SourceRefs,

  [Parameter(Mandatory = $true)]
  [string]$CreationContext,

  [ValidateSet("draft", "review_ready", "final", "superseded", "archived")]
  [string]$Status = "draft",

  [string]$Summary,
  [string]$DomainId,
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
    "queue-item" = "local/runtime/queue"
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

$artifactSlugValue = Ensure-Slug $ArtifactSlug "ArtifactSlug"
$artifactTypeValue = Ensure-Slug $ArtifactType "ArtifactType"
$createdAtValue = Ensure-Timestamp $CreatedAt "CreatedAt"
$creationContextValue = Ensure-NonEmptyString $CreationContext "CreationContext"
$summaryValue = $null
if (-not [string]::IsNullOrWhiteSpace($Summary)) { $summaryValue = Ensure-NonEmptyString $Summary "Summary" }

$sourceRefObjects = @(Get-UniqueSortedRefs $SourceRefs)
if ($sourceRefObjects.Count -lt 1) { Fail "SourceRefs must contain at least one canonical ref." }
$hasQueueSource = (@($sourceRefObjects | Where-Object { $_.object_type -eq "queue-item" })).Count -gt 0
$hasRunSource = (@($sourceRefObjects | Where-Object { $_.object_type -eq "run-event" })).Count -gt 0
if (-not $hasQueueSource -and -not $hasRunSource) {
  Fail "Artifacts must include at least one direct queue-item or run-event source ref."
}

$derivedDomainIds = New-Object System.Collections.Generic.List[string]
foreach ($ref in $sourceRefObjects) {
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
    Fail "DomainId does not match the domains directly present on the selected source refs."
  }
} else {
  if ($derivedDomainIds.Count -eq 1) {
    $finalDomainId = $derivedDomainIds[0]
  } elseif ($derivedDomainIds.Count -gt 1) {
    Fail "DomainId is required when the selected source refs span multiple direct domains."
  } else {
    Fail "DomainId could not be derived directly from the selected source refs. Supply -DomainId explicitly."
  }
}

$artifactId = "artifact-{0}" -f $artifactSlugValue
$defaultOutputPath = Join-Path $WorkspaceRoot ("local/runtime/artifacts/{0}.json" -f $artifactId)
$resolvedOutputPath = Resolve-OutputPath $OutputPath $defaultOutputPath

$document = [pscustomobject][ordered]@{
  object_type = "artifact"
  id = $artifactId
  domain_id = $finalDomainId
  artifact_type = $artifactTypeValue
  status = $Status
  created_at = $createdAtValue
  creation_context = $creationContextValue
  lineage = [pscustomobject][ordered]@{
    source_refs = @($sourceRefObjects)
  }
}

if ($null -ne $summaryValue) {
  $document | Add-Member -NotePropertyName "summary" -NotePropertyValue $summaryValue
}

Write-JsonFile -PathValue $resolvedOutputPath -Document $document -Overwrite:$Force
Write-Output ("WROTE {0}" -f $resolvedOutputPath)
