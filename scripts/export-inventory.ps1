<#
.SYNOPSIS
  Exportiert TOPIX-/HASP-/Festplatten-Inventar fuer den Umzug.
#>
$ErrorActionPreference = 'Continue'
$outDir = Join-Path $PSScriptRoot '..\inventory-output'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$out = Join-Path $outDir "inventory-$stamp.txt"

function W($s) { $s | Tee-Object -FilePath $out -Append }

W "=== TOPIX migration inventory $stamp ==="
W "Computer: $env:COMPUTERNAME"
W "User: $env:USERNAME"
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
W "OS: $($os.Caption) $($os.Version)"
W ("RAM GB: {0:N1}  Free MB: {1}" -f ($cs.TotalPhysicalMemory/1GB), [math]::Round($os.FreePhysicalMemory/1024,0))
W ""
W "=== Logical disks ==="
Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' |
  Select-Object DeviceID, @{N='SizeGB';E={[math]::Round($_.Size/1GB,1)}}, @{N='FreeGB';E={[math]::Round($_.FreeSpace/1GB,1)}} |
  Format-Table -AutoSize | Out-String | ForEach-Object { W $_.TrimEnd() }

W "`n=== HASP devices ==="
Get-PnpDevice -ErrorAction SilentlyContinue |
  Where-Object { $_.FriendlyName -match 'HASP|Aladdin' } |
  Format-Table Status, Class, FriendlyName, InstanceId -AutoSize |
  Out-String | ForEach-Object { W $_.TrimEnd() }

W "`n=== HASP driver files ==="
Get-ChildItem "$env:SystemRoot\System32\drivers\aks*.sys","$env:SystemRoot\System32\drivers\hardlock.sys" -ErrorAction SilentlyContinue |
  Format-Table Name, Length, LastWriteTime -AutoSize | Out-String | ForEach-Object { W $_.TrimEnd() }

$paths = @(
  'C:\Program Files (x86)\TOPIX',
  'C:\Topix',
  'C:\Topix\Topix Daten',
  'C:\Topix\Topix Installationsprogramm',
  'E:\Topix Programme',
  'E:\Topix täglich backup'
)
W "`n=== Path existence / top-level ==="
foreach ($p in $paths) {
  W "-- $p exists=$(Test-Path $p)"
  if (Test-Path $p) {
    Get-ChildItem $p -Force -ErrorAction SilentlyContinue |
      Select-Object -First 40 Name, Mode, Length, LastWriteTime |
      Format-Table -AutoSize | Out-String | ForEach-Object { W $_.TrimEnd() }
  }
}

W "`n=== Key data file sizes ==="
$data = 'C:\Topix\Topix Daten'
if (Test-Path $data) {
  Get-ChildItem $data -File -ErrorAction SilentlyContinue |
    Select-Object Name, @{N='GB';E={[math]::Round($_.Length/1GB,2)}}, LastWriteTime |
    Format-Table -AutoSize | Out-String | ForEach-Object { W $_.TrimEnd() }
}

W "`n=== Installed TOPIX/HASP apps (registry) ==="
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* ,
  HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue |
  Where-Object { $_.DisplayName -match 'TOPIX|HASP|4D' } |
  Select-Object DisplayName, DisplayVersion, Publisher |
  Format-List | Out-String | ForEach-Object { W $_.TrimEnd() }

W "`nWrote: $out"
Write-Host "Inventory written to $out"
