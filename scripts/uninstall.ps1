[CmdletBinding()]
param(
    [string]$SkillRoot = (Join-Path $env:USERPROFILE '.codex\skills')
)

$ErrorActionPreference = 'Stop'

function Test-IsJunction {
    param([Parameter(Mandatory = $true)]$Item)

    return $Item.PSIsContainer -and
        $Item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) -and
        $Item.LinkType -eq 'Junction'
}

$targetPath = Join-Path $SkillRoot 'change-quality-check'

if (-not (Test-Path -LiteralPath $targetPath)) {
    Write-Host "Skill is not installed at '$targetPath'."
    exit 0
}

$targetItem = Get-Item -LiteralPath $targetPath -Force

if (Test-IsJunction -Item $targetItem) {
    [System.IO.Directory]::Delete($targetPath)
    Write-Host "Removed junction '$targetPath'."
    exit 0
}

if ($targetItem.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
    throw "Refusing to remove '$targetPath' because it is a reparse point of type '$($targetItem.LinkType)', not a junction."
}

if ($targetItem.PSIsContainer) {
    throw "Refusing to remove '$targetPath' because it is a normal directory, not an installed junction."
}

throw "Refusing to remove '$targetPath' because it is a file, not an installed junction."
