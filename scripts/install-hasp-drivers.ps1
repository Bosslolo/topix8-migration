<#
.SYNOPSIS
  Installiert die exportierten HASP/Aladdin-Treiber vom Ordner hasp-drivers.
.DESCRIPTION
  Auf dem neuen PC als Administrator ausfuehren. Key danach stecken und check-hasp.ps1.
#>
param(
  [string] $DriversRoot = (Join-Path $PSScriptRoot '..\hasp-drivers')
)

$ErrorActionPreference = 'Continue'
$DriversRoot = (Resolve-Path $DriversRoot).Path
Write-Host "HASP drivers root: $DriversRoot" -ForegroundColor Cyan

if (-not (Test-Path $DriversRoot)) {
  throw "Ordner fehlt: $DriversRoot — bitte git pull"
}

Get-Content (Join-Path $DriversRoot 'VERSION.txt') -ErrorAction SilentlyContinue | Write-Host

$infs = @()
$infs += Get-ChildItem (Join-Path $DriversRoot 'filerepository') -Recurse -Filter '*.inf' -ErrorAction SilentlyContinue
$infs += Get-ChildItem $DriversRoot -Filter 'oem*.inf' -ErrorAction SilentlyContinue
$infs = $infs | Sort-Object FullName -Unique

if (-not $infs) {
  Write-Host "Keine .inf gefunden. Installiere TOPIX8_8602_Server.exe mit HASP-Option." -ForegroundColor Yellow
  exit 1
}

$ok = 0
foreach ($inf in $infs) {
  Write-Host "`npnputil /add-driver $($inf.FullName) /install"
  & pnputil /add-driver $inf.FullName /install
  if ($LASTEXITCODE -eq 0) { $ok++ }
}

Write-Host "`nErfolgreiche pnputil-Aufrufe (Exit 0): $ok / $($infs.Count)" -ForegroundColor Green
Write-Host "Jetzt USB-HASP-Key stecken, ggf. neu starten, dann:" -ForegroundColor Cyan
Write-Host "  .\scripts\check-hasp.ps1"
Write-Host "Erwartung: Aladdin HASP Key / Aladdin USB Key Status OK"
