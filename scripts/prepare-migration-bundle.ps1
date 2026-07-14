<#
.SYNOPSIS
  One-shot non-physical prep on the OLD PC: inventory, HASP drivers, data, licenses, installers.
.PARAMETER StagingRoot
  Root folder, e.g. F:\TOPIX-Migration-Staging
.PARAMETER IncludeBroken
  Also copy *_broken.4DD (very large).
.PARAMETER SkipDataCopy
  Only inventory + drivers + licenses + installers (if live DB still locked / users online).
.PARAMETER WhatIf
  Pass /L to robocopy (list only).
#>
param(
  [Parameter(Mandatory = $true)]
  [string] $StagingRoot,
  [switch] $IncludeBroken,
  [switch] $SkipDataCopy,
  [switch] $WhatIf
)

$ErrorActionPreference = 'Stop'
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $repoRoot

Write-Host "=== TOPIX migration bundle prep ===" -ForegroundColor Cyan
Write-Host "Repo: $repoRoot"
Write-Host "StagingRoot: $StagingRoot"
Write-Host "IMPORTANT: Live .4DD copy needs TOPIX8 Server STOPPED." -ForegroundColor Yellow

New-Item -ItemType Directory -Force -Path $StagingRoot | Out-Null
$invDest = Join-Path $StagingRoot 'inventory'
$haspDest = Join-Path $StagingRoot 'HASP-Drivers'
New-Item -ItemType Directory -Force -Path $invDest, $haspDest | Out-Null

# --- Inventory ---
Write-Host "`n[1/5] Inventory..." -ForegroundColor Cyan
& (Join-Path $PSScriptRoot 'export-inventory.ps1')
$localInv = Join-Path $repoRoot 'inventory-output'
if (Test-Path $localInv) {
  Copy-Item (Join-Path $localInv '*') -Destination $invDest -Force -ErrorAction SilentlyContinue
}

# --- HASP drivers ---
Write-Host "`n[2/5] HASP driver export..." -ForegroundColor Cyan
& (Join-Path $PSScriptRoot 'export-hasp-drivers.ps1') -Destination $haspDest

# --- Licenses + installers + data via existing stage script ---
Write-Host "`n[3/5] Stage licenses / installers / data..." -ForegroundColor Cyan
if ($SkipDataCopy) {
  Write-Host "SkipDataCopy set — copying licenses + installers only (no live DB)." -ForegroundColor Yellow
  $destLic = Join-Path $StagingRoot 'Licenses'
  $destInst = Join-Path $StagingRoot 'Installers'
  New-Item -ItemType Directory -Force -Path $destLic, $destInst | Out-Null
  $srcLic = 'C:\Program Files (x86)\TOPIX\TOPIX8 Server\Licenses'
  $srcInstaller = 'C:\Topix\Topix Installationsprogramm'
  $srcExtra = 'E:\Topix Programme'
  if (Test-Path $srcLic) {
    Copy-Item (Join-Path $srcLic '*') -Destination $destLic -Force -Recurse
  }
  if (Test-Path $srcInstaller) {
    Copy-Item (Join-Path $srcInstaller '*') -Destination $destInst -Force -ErrorAction SilentlyContinue
  }
  if (Test-Path $srcExtra) {
    $extraDest = Join-Path $destInst 'Topix Programme'
    New-Item -ItemType Directory -Force -Path $extraDest | Out-Null
    & robocopy $srcExtra $extraDest /E /COPY:DAT /R:2 /W:5 /MT:4 /NP /NFL /NDL /XF *.zip | Out-Null
  }
} else {
  $stageParams = @{ Destination = $StagingRoot }
  if ($IncludeBroken) { $stageParams.IncludeBroken = $true }
  if ($WhatIf) { $stageParams.WhatIf = $true }
  & (Join-Path $PSScriptRoot 'stage-data-copy.ps1') @stageParams
}

# --- Manifest ---
Write-Host "`n[4/5] Writing STAGING-MANIFEST.txt..." -ForegroundColor Cyan
$manifest = Join-Path $StagingRoot 'STAGING-MANIFEST.txt'
$lines = @()
$lines += "TOPIX migration staging manifest"
$lines += "Created: $(Get-Date -Format o)"
$lines += "Computer: $env:COMPUTERNAME"
$lines += "User: $env:USERNAME"
$lines += "StagingRoot: $StagingRoot"
$lines += "Suggested UNC: \\$env:COMPUTERNAME\TOPIX-Migration-Staging"
$lines += ""
$lines += "=== Key files ==="

function Add-FileLine([string]$path) {
  if (Test-Path $path) {
    $f = Get-Item $path
    $hash = $null
    try {
      if ($f.Length -lt 2GB) {
        $hash = (Get-FileHash -Path $path -Algorithm SHA256).Hash
      } else {
        $hash = '(skipped SHA256 — file >= 2GB; compare Size + LastWriteTime)'
      }
    } catch { $hash = '(hash failed)' }
    return ("{0}`r`n  Size={1}  LastWrite={2}  SHA256={3}" -f $path, $f.Length, $f.LastWriteTime.ToString('o'), $hash)
  }
  return "$path  MISSING"
}

$candidates = @(
  (Join-Path $StagingRoot 'Topix Daten\TOPIX Daten ansatz.4DD'),
  (Join-Path $StagingRoot 'Topix Daten\TOPIX Daten ansatz.4DIndx'),
  (Join-Path $StagingRoot 'Topix Daten\TOPIX Daten ansatz.4DIndy'),
  (Join-Path $StagingRoot 'Topix Daten\TOPIX8.4DC'),
  (Join-Path $StagingRoot 'Installers\TOPIX8_8602_Server.exe')
)
foreach ($c in $candidates) { $lines += (Add-FileLine $c); $lines += "" }

$lic = Get-ChildItem (Join-Path $StagingRoot 'Licenses') -Filter '*.license4D' -ErrorAction SilentlyContinue
$lines += "License files: $($lic.Count)"
foreach ($l in $lic) { $lines += "  $($l.Name)  $($l.Length) bytes" }

$lines += ""
$lines += "=== Tree (top levels) ==="
Get-ChildItem $StagingRoot -Force | ForEach-Object {
  $lines += ("{0}  {1}" -f $_.Mode, $_.Name)
}

$lines | Set-Content -Path $manifest -Encoding UTF8
Write-Host "Wrote $manifest"

# --- Summary ---
Write-Host "`n[5/5] Handoff summary" -ForegroundColor Green
Get-Content $manifest
Write-Host "`nDone. Next (human): get this folder onto the new PC (share/USB), then new-PC AI installs TOPIX + HASP." -ForegroundColor Green
Write-Host "Docs for this agent: docs\AI-OLD-PC-INSTRUCTIONS.md"
Write-Host "Docs for new PC:     docs\AI-NEW-PC-INSTRUCTIONS.md"
