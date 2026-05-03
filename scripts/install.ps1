[CmdletBinding()]
param(
    [string]$RepoPath = (Split-Path -Parent $PSScriptRoot),
    [string]$SkillRoot = (Join-Path $env:USERPROFILE '.codex\skills')
)

$ErrorActionPreference = 'Stop'

function Get-NormalizedPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $resolved = Resolve-Path -LiteralPath $Path
    return [System.IO.Path]::GetFullPath($resolved.Path).TrimEnd('\')
}

function Get-LinkTargetPath {
    param([Parameter(Mandatory = $true)]$Item)

    if (-not ($Item.PSObject.Properties.Name -contains 'Target')) {
        return $null
    }

    $target = $Item.Target
    if ($target -is [array]) {
        $target = $target[0]
    }

    if ([string]::IsNullOrWhiteSpace($target)) {
        return $null
    }

    return [System.IO.Path]::GetFullPath($target).TrimEnd('\')
}

function Test-IsJunction {
    param([Parameter(Mandatory = $true)]$Item)

    return $Item.PSIsContainer -and
        $Item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) -and
        $Item.LinkType -eq 'Junction'
}

function Assert-RepoStructure {
    param([Parameter(Mandatory = $true)][string]$Root)

    $requiredPaths = @(
        @{ Path = (Join-Path $Root 'SKILL.md'); Type = 'Leaf' },
        @{ Path = (Join-Path $Root 'references'); Type = 'Container' },
        @{ Path = (Join-Path $Root 'agents\openai.yaml'); Type = 'Leaf' }
    )

    foreach ($entry in $requiredPaths) {
        if (-not (Test-Path -LiteralPath $entry.Path -PathType $entry.Type)) {
            throw "Repository structure check failed: missing $($entry.Type.ToLower()) '$($entry.Path)'."
        }
    }
}

$repoRoot = Get-NormalizedPath -Path $RepoPath
Assert-RepoStructure -Root $repoRoot

$targetPath = Join-Path $SkillRoot 'change-quality-check'
$targetParent = Split-Path -Parent $targetPath

if (-not (Test-Path -LiteralPath $targetParent -PathType Container)) {
    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
}

if (-not (Test-Path -LiteralPath $targetPath)) {
    New-Item -ItemType Junction -Path $targetPath -Target $repoRoot | Out-Null
    Write-Host "Installed junction: $targetPath -> $repoRoot"
    exit 0
}

$targetItem = Get-Item -LiteralPath $targetPath -Force

if (Test-IsJunction -Item $targetItem) {
    $existingTarget = Get-LinkTargetPath -Item $targetItem
    if ($existingTarget -and $existingTarget -eq $repoRoot) {
        Write-Host "Skill already installed: $targetPath -> $existingTarget"
        exit 0
    }

    if ($existingTarget) {
        throw "Refusing to overwrite junction '$targetPath' because it points to '$existingTarget'."
    }

    throw "Refusing to overwrite junction '$targetPath' because its target could not be resolved."
}

if ($targetItem.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
    throw "Refusing to modify '$targetPath' because it is a reparse point of type '$($targetItem.LinkType)'."
}

if ($targetItem.PSIsContainer) {
    throw "Refusing to overwrite existing directory '$targetPath'. Move or back it up first."
}

throw "Refusing to overwrite existing file '$targetPath'."
