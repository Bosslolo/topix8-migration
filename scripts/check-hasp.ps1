<#
.SYNOPSIS
  Prueft ob der Aladdin-HASP-USB-Schluessel erkannt wird (alter oder neuer PC).
#>
Write-Host "=== PnP HASP / Aladdin ===" -ForegroundColor Cyan
$devs = Get-PnpDevice -ErrorAction SilentlyContinue | Where-Object {
  $_.FriendlyName -match 'HASP|Aladdin' -or $_.InstanceId -match 'VID_0529'
}
if (-not $devs) {
  Write-Host "No Aladdin/HASP device found. Install HASP drivers / TOPIX Server, then replug the key." -ForegroundColor Red
  exit 1
}
$devs | Format-Table Status, Class, FriendlyName, InstanceId -AutoSize
$bad = $devs | Where-Object { $_.Status -ne 'OK' }
if ($bad) {
  Write-Host "Some devices not OK — open Device Manager and update/reinstall HASP driver." -ForegroundColor Yellow
  exit 2
}
Write-Host "HASP looks present and OK." -ForegroundColor Green

Write-Host "`n=== Driver files ==="
Get-ChildItem "$env:SystemRoot\System32\drivers\aks*.sys","$env:SystemRoot\System32\drivers\hardlock.sys" -ErrorAction SilentlyContinue |
  Format-Table Name, Length, LastWriteTime -AutoSize
