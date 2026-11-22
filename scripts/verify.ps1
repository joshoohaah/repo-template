#!/usr/bin/env pwsh
# Windows wrapper: runs scripts/verify.sh through Git Bash (or WSL bash).
# Keeps one implementation of "verify" for every platform.
$ErrorActionPreference = 'Stop'

$script = Join-Path $PSScriptRoot 'verify.sh'
$candidates = @(
    "$env:ProgramFiles\Git\bin\bash.exe",
    "${env:ProgramFiles(x86)}\Git\bin\bash.exe",
    (Get-Command bash -ErrorAction SilentlyContinue)?.Source
) | Where-Object { $_ -and (Test-Path $_) }

if (-not $candidates) {
    Write-Error 'bash not found. Install Git for Windows (https://git-scm.com) or WSL.'
    exit 2
}

& $candidates[0] $script @args
exit $LASTEXITCODE
