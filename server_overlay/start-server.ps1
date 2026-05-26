param(
    [Parameter(Mandatory = $true)]
    [string]$UpstreamRoot,

    [Parameter(Mandatory = $true)]
    [string]$WorkdirRoot,

    [string]$OverlayRoot = $PSScriptRoot,
    [string]$StartupCommand = "bin\server.cmd",

    [switch]$BuildOnly,
    [switch]$RunBuildFirst,
    [switch]$KeepWorkdir,
    [switch]$SkipCore,
    [switch]$SkipMods
)

$ErrorActionPreference = "Stop"

function Resolve-FullPathOrLiteral {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (Test-Path -LiteralPath $Path) {
        return [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $Path).Path)
    }

    return [System.IO.Path]::GetFullPath($Path)
}

$UpstreamRoot = Resolve-FullPathOrLiteral -Path $UpstreamRoot
$WorkdirRoot = Resolve-FullPathOrLiteral -Path $WorkdirRoot
$OverlayRoot = Resolve-FullPathOrLiteral -Path $OverlayRoot

if (!(Test-Path -LiteralPath $UpstreamRoot)) {
    throw "Upstream root not found: $UpstreamRoot"
}

if (!(Test-Path -LiteralPath (Join-Path $UpstreamRoot "roguetown.dme"))) {
    throw "Upstream root does not look like a Ratwood source tree: $UpstreamRoot"
}

if ((Test-Path -LiteralPath $WorkdirRoot) -and !$KeepWorkdir) {
    Remove-Item -LiteralPath $WorkdirRoot -Recurse -Force
}

if (!(Test-Path -LiteralPath $WorkdirRoot)) {
    New-Item -ItemType Directory -Force -Path $WorkdirRoot | Out-Null
    Get-ChildItem -LiteralPath $UpstreamRoot -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $WorkdirRoot -Recurse -Force
    }
}

$applyOverlayScript = Join-Path $OverlayRoot "apply-overlay.ps1"
if (!(Test-Path -LiteralPath $applyOverlayScript)) {
    throw "Overlay apply script not found: $applyOverlayScript"
}

& $applyOverlayScript -WorkspaceRoot $WorkdirRoot -OverlayRoot $OverlayRoot -SkipCore:$SkipCore -SkipMods:$SkipMods

$buildCmd = Join-Path $WorkdirRoot "bin\build.cmd"
$startupCmd = Join-Path $WorkdirRoot $StartupCommand

if ($RunBuildFirst -or $BuildOnly) {
    if (!(Test-Path -LiteralPath $buildCmd)) {
        throw "Build command not found: $buildCmd"
    }

    Push-Location $WorkdirRoot
    try {
        & cmd /c $buildCmd
        if ($LASTEXITCODE -ne 0) {
            throw "Build failed with exit code $LASTEXITCODE"
        }
    }
    finally {
        Pop-Location
    }
}

if (!$BuildOnly) {
    if (!(Test-Path -LiteralPath $startupCmd)) {
        throw "Startup command not found: $startupCmd"
    }

    Push-Location $WorkdirRoot
    try {
        & cmd /c $startupCmd
        if ($LASTEXITCODE -ne 0) {
            throw "Server command failed with exit code $LASTEXITCODE"
        }
    }
    finally {
        Pop-Location
    }
}
