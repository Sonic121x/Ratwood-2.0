param(
    [string]$SourceRoot = (Join-Path $PSScriptRoot ".."),
    [string]$OverlayRoot = $PSScriptRoot
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([Parameter(Mandatory = $true)][string]$Path)
    return [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $Path).Path)
}

$SourceRoot = Resolve-FullPath -Path $SourceRoot
$OverlayRoot = Resolve-FullPath -Path $OverlayRoot

$ManifestPath = Join-Path $OverlayRoot "core-files.txt"
$CoreOutputRoot = Join-Path $OverlayRoot "core"
$ModsOutputRoot = Join-Path $OverlayRoot "mods"

if (!(Test-Path -LiteralPath $ManifestPath)) {
    throw "Overlay manifest not found: $ManifestPath"
}

if (Test-Path -LiteralPath $CoreOutputRoot) {
    Remove-Item -LiteralPath $CoreOutputRoot -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $CoreOutputRoot | Out-Null

$relativeFiles = Get-Content -LiteralPath $ManifestPath | Where-Object {
    $_ -and -not $_.StartsWith("#")
}

foreach ($relativePath in $relativeFiles) {
    $sourcePath = Join-Path $SourceRoot $relativePath
    $targetPath = Join-Path $CoreOutputRoot $relativePath
    $targetDir = Split-Path -Parent $targetPath

    if (!(Test-Path -LiteralPath $sourcePath)) {
        throw "Source file not found: $sourcePath"
    }

    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
    Write-Host "Captured core override: $relativePath"
}

if (Test-Path -LiteralPath $ModsOutputRoot) {
    Remove-Item -LiteralPath $ModsOutputRoot -Recurse -Force
}

$sourceModsRoot = Join-Path $SourceRoot "mods"
if (Test-Path -LiteralPath $sourceModsRoot) {
    New-Item -ItemType Directory -Force -Path $ModsOutputRoot | Out-Null
    Get-ChildItem -LiteralPath $sourceModsRoot -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $ModsOutputRoot -Recurse -Force
    }

    $autogenPath = Join-Path $ModsOutputRoot "_autogen.dm"
    if (Test-Path -LiteralPath $autogenPath) {
        Remove-Item -LiteralPath $autogenPath -Force
    }

    Write-Host "Captured mods overlay from: $sourceModsRoot"
}
