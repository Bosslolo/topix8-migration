<#
.SYNOPSIS
  Kopiert gestagte TOPIX-Daten auf den neuen PC (nach Cutover-Kopie).
.EXAMPLE
  .\restore-data-on-new-pc.ps1 -Source "F:\TOPIX-Migration-Staging\data\Topix Daten" -Destination "D:\Topix\Topix Daten"
#>
param(
  [Parameter(Mandatory = $true)]
  [string] $Source,
  [Parameter(Mandatory = $true)]
  [string] $Destination,
  [string] $LicensesSource = 'F:\TOPIX-Migration-Staging\licenses',
  [string] $LicensesDest = 'C:\Program Files (x86)\TOPIX\TOPIX8 Server\Licenses'
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path $Source)) { throw "Quelle fehlt: $Source" }

New-Item -ItemType Directory -Force -Path $Destination | Out-Null
Write-Host "robocopy Daten: $Source -> $Destination"
& robocopy $Source $Destination /E /COPY:DAT /R:2 /W:5 /MT:4 /NP
if ($LASTEXITCODE -ge 8) { throw "robocopy fehlgeschlagen: $LASTEXITCODE" }

$srcDb = Get-ChildItem $Source -Filter '*.4DD' -File | Where-Object { $_.Name -notmatch 'broken' } | Select-Object -First 1
$dstDb = Join-Path $Destination $srcDb.Name
if ($srcDb -and (Test-Path $dstDb)) {
  if ((Get-Item $dstDb).Length -ne $srcDb.Length) {
    throw "4DD-Groesse stimmt nicht ueberein!"
  }
  Write-Host "4DD-Groesse OK: $($srcDb.Name)"
}

if ((Test-Path $LicensesSource) -and (Test-Path (Split-Path $LicensesDest -Parent))) {
  New-Item -ItemType Directory -Force -Path $LicensesDest | Out-Null
  Copy-Item (Join-Path $LicensesSource '*') $LicensesDest -Force
  Write-Host "Lizenzen nach $LicensesDest kopiert"
}

Write-Host "Fertig. Als Naechstes: HASP stecken, check-hasp.ps1, TOPIX8 Server starten."
