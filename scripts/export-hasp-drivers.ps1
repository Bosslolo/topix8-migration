<#
.SYNOPSIS
  Export Aladdin/HASP PnP drivers from the machine where the key currently works.
.PARAMETER Destination
  Folder to receive pnputil-exported driver packages.
#>
param(
  [Parameter(Mandatory = $true)]
  [string] $Destination
)

$ErrorActionPreference = 'Continue'
New-Item -ItemType Directory -Force -Path $Destination | Out-Null

Write-Host "=== Looking for HASP / Aladdin devices ===" -ForegroundColor Cyan
$devs = Get-PnpDevice -ErrorAction SilentlyContinue | Where-Object {
  $_.FriendlyName -match 'HASP|Aladdin' -or $_.InstanceId -match 'VID_0529'
}
if (-not $devs) {
  Write-Host "No HASP/Aladdin PnP device found. Key may be unplugged or drivers missing." -ForegroundColor Yellow
} else {
  $devs | Format-Table Status, Class, FriendlyName, InstanceId -AutoSize
}

Write-Host "`n=== Searching driver store for HASP-related packages ===" -ForegroundColor Cyan
$published = & pnputil /enum-drivers 2>$null
$driverLines = $published -split "`r?`n"

# Collect Published Name (oemXX.inf) when nearby text mentions Aladdin/HASP/aks/SafeNet/hardlock
$oemNames = New-Object System.Collections.Generic.HashSet[string]
$currentOem = $null
foreach ($line in $driverLines) {
  if ($line -match 'Published Name\s*:\s*(oem\d+\.inf)') {
    $currentOem = $Matches[1]
  }
  elseif ($currentOem -and $line -match 'Aladdin|HASP|SafeNet|Sentinel|hardlock|aks(class|hasp|usb)|AKS') {
    [void]$oemNames.Add($currentOem)
  }
  if ($line -match '^\s*$') { $currentOem = $null }
}

# Fallback: scan INF provider/strings under FileRepository
if ($oemNames.Count -eq 0) {
  Get-ChildItem "$env:SystemRoot\System32\DriverStore\FileRepository" -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match 'aks|hasp|hardlock|aladdin|sentinel' } |
    ForEach-Object {
      $inf = Get-ChildItem $_.FullName -Filter '*.inf' -ErrorAction SilentlyContinue | Select-Object -First 1
      if ($inf) { Write-Host "Found repository package: $($_.Name)" }
    }
}

if ($oemNames.Count -eq 0) {
  Write-Host "Could not map oemXX.inf automatically. Copying known sys files as fallback..." -ForegroundColor Yellow
  $sysDest = Join-Path $Destination 'sys-files'
  New-Item -ItemType Directory -Force -Path $sysDest | Out-Null
  Copy-Item "$env:SystemRoot\System32\drivers\aks*.sys","$env:SystemRoot\System32\drivers\hardlock.sys" `
    -Destination $sysDest -ErrorAction SilentlyContinue
  Get-ChildItem $sysDest | Format-Table Name, Length, LastWriteTime -AutoSize
  Write-Host "Note: .sys alone may not be installable; prefer TOPIX installer HASP option on new PC." -ForegroundColor Yellow
  exit 0
}

Write-Host "Exporting OEM packages: $($oemNames -join ', ')"
foreach ($oem in $oemNames) {
  $out = Join-Path $Destination $oem.Replace('.inf', '')
  New-Item -ItemType Directory -Force -Path $out | Out-Null
  Write-Host "pnputil /export-driver $oem -> $out"
  & pnputil /export-driver $oem $out
}

Write-Host "`n=== Export tree ===" -ForegroundColor Green
Get-ChildItem $Destination -Recurse -File | Select-Object FullName, Length | Format-Table -AutoSize
Write-Host "HASP driver export finished: $Destination"
