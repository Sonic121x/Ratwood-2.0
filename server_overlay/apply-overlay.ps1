param(
    [Parameter(Mandatory = $true)]
    [string]$WorkspaceRoot,

    [string]$OverlayRoot = $PSScriptRoot,

    [switch]$SkipCore,
    [switch]$SkipMods
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([Parameter(Mandatory = $true)][string]$Path)
    return [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $Path).Path)
}

$WorkspaceRoot = Resolve-FullPath -Path $WorkspaceRoot
$OverlayRoot = Resolve-FullPath -Path $OverlayRoot

$ManifestPath = Join-Path $OverlayRoot "core-files.txt"
$CoreSourceRoot = Join-Path $OverlayRoot "core"
$ModsSourceRoot = Join-Path $OverlayRoot "mods"

if (!(Test-Path -LiteralPath $ManifestPath)) {
    throw "Overlay manifest not found: $ManifestPath"
}

if (!(Test-Path -LiteralPath $WorkspaceRoot)) {
    throw "Workspace root not found: $WorkspaceRoot"
}

if (!$SkipCore) {
    $relativeFiles = Get-Content -LiteralPath $ManifestPath | Where-Object {
        $_ -and -not $_.StartsWith("#")
    }

    foreach ($relativePath in $relativeFiles) {
        $sourcePath = Join-Path $CoreSourceRoot $relativePath
        $targetPath = Join-Path $WorkspaceRoot $relativePath
        $targetDir = Split-Path -Parent $targetPath

        if (!(Test-Path -LiteralPath $sourcePath)) {
            throw "Missing overlay core file: $sourcePath"
        }

        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
        Write-Host "Applied core override: $relativePath"
    }
}

if (!$SkipMods -and (Test-Path -LiteralPath $ModsSourceRoot)) {
    $modsTarget = Join-Path $WorkspaceRoot "mods"
    New-Item -ItemType Directory -Force -Path $modsTarget | Out-Null

    Get-ChildItem -LiteralPath $ModsSourceRoot -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $modsTarget -Recurse -Force
    }

    $autogenPath = Join-Path $modsTarget "_autogen.dm"
    if (Test-Path -LiteralPath $autogenPath) {
        Remove-Item -LiteralPath $autogenPath -Force
    }

    Write-Host "Applied mods overlay from: $ModsSourceRoot"
}
