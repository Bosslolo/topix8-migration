<#
.SYNOPSIS
  TOPIX-Daten, Lizenzen und Installer fuer den Umzug stagen (robocopy).
.DESCRIPTION
  Zuerst TOPIX8 Server auf dem alten PC beenden!
  Beispiel: .\stage-data-copy.ps1 -Destination "F:\TOPIX-Migration-Staging\data"
.PARAMETER Destination
  Zielordner (NAS/USB), z.B. F:\TOPIX-Migration-Staging\data
.PARAMETER IncludeBroken
  Auch *_broken.4DD kopieren (gross). Standard: aus.
#>
param(
  [Parameter(Mandatory = $true)]
  [string] $Destination,
  [switch] $IncludeBroken,
  [switch] $WhatIf
)

$ErrorActionPreference = 'Stop'
$srcData = 'C:\Topix\Topix Daten'
$srcLic = 'C:\Program Files (x86)\TOPIX\TOPIX8 Server\Licenses'
$srcInstaller = 'C:\Topix\Topix Installationsprogramm'
$srcExtra = 'E:\Topix Programme'

if (-not (Test-Path $srcData)) { throw "Data path missing: $srcData" }

$destData = Join-Path $Destination 'Topix Daten'
$destLic = Join-Path $Destination 'Licenses'
$destInst = Join-Path $Destination 'Installers'
New-Item -ItemType Directory -Force -Path $destData, $destLic, $destInst | Out-Null

Write-Host "IMPORTANT: Stop TOPIX8 Server before copying live .4DD files." -ForegroundColor Yellow
Write-Host "Source data: $srcData"
Write-Host "Destination: $Destination"

$exclude = @()
if (-not $IncludeBroken) {
  $exclude += '*_broken.4DD'
  $exclude += '*_broken.Match'
}

$roboArgs = @(
  $srcData, $destData, '/E', '/COPY:DAT', '/R:2', '/W:5', '/MT:4', '/NP', '/NFL', '/NDL'
)
foreach ($x in $exclude) { $roboArgs += @('/XF', $x) }
if ($WhatIf) { $roboArgs += '/L' }

Write-Host "Running robocopy data..."
& robocopy @roboArgs
$rc = $LASTEXITCODE
# robocopy 0-7 = success-ish
if ($rc -ge 8) { throw "robocopy data failed with code $rc" }

if (Test-Path $srcLic) {
  Write-Host "Copying licenses..."
  Copy-Item -Path (Join-Path $srcLic '*') -Destination $destLic -Force -Recurse
}

if (Test-Path $srcInstaller) {
  Write-Host "Copying installers from Topix Installationsprogramm..."
  Copy-Item -Path (Join-Path $srcInstaller '*') -Destination $destInst -Force -ErrorAction SilentlyContinue
}

if (Test-Path $srcExtra) {
  $extraDest = Join-Path $destInst 'Topix Programme'
  New-Item -ItemType Directory -Force -Path $extraDest | Out-Null
  Write-Host "Mirroring extra installers (may be large)..."
  & robocopy $srcExtra $extraDest /E /COPY:DAT /R:2 /W:5 /MT:4 /NP /NFL /NDL /XF *.zip
}

Write-Host "`n=== Destination summary ==="
Get-ChildItem $destData -File -ErrorAction SilentlyContinue |
  Select-Object Name, @{N='GB';E={[math]::Round($_.Length/1GB,2)}} |
  Format-Table -AutoSize
Write-Host "Staging complete. Robocopy exit: $rc (0-7 OK)"
Write-Host "Next: verify HASP on new PC, then restore data path and open TOPIX8 Server."
