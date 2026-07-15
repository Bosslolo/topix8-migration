# QuickTime 6.5 (Windows) — required for TOPIX 8 installer

TOPIX8 Server setup (`TOPIX8_8602_Server.exe`) checks for **Apple QuickTime 6.5.x** on Windows. Without it, the installer aborts.

## New PC status

Need QuickTime **6.5** (not 7.x — TOPIX may reject newer versions). Put the installer on the shared NAS:

`\\WDMYCLOUD\Public\TOPIX-Migration-Staging\installers\QuickTimeInstaller-6.5.2.exe`

(or any clear `QuickTime*6.5*.exe` name in that folder)

## OLD PC agent — do this (safe while TOPIX runs)

1. `git pull` on `Bosslolo/topix8-migration`.
2. Find QuickTime 6.5 installer on the production machine or media, for example:

```powershell
Get-ChildItem "C:\","D:\","E:\" -Recurse -ErrorAction SilentlyContinue -Filter "*QuickTime*" -Depth 5 |
  Where-Object { $_.Name -match 'Install|Setup|6\.5' } |
  Select-Object FullName, Length
# Also check TOPIX media:
Get-ChildItem "C:\Topix","E:\Topix Programme" -Recurse -ErrorAction SilentlyContinue -Filter "*QuickTime*"
```

3. Copy whatever you find to the share:

```powershell
$dest = "\\WDMYCLOUD\Public\TOPIX-Migration-Staging\installers"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item "<path-to-QuickTime-6.5-installer>" "$dest\QuickTimeInstaller-6.5.2.exe" -Force
```

4. If no installer remains, look under Uninstall / original media from TOPIX Zusätze / Apple QuickTime CD. Report the path/version to the user.

5. Do **not** uninstall QuickTime from the old PC.

## After the file is on Public

On the new PC: install QuickTime 6.5 **first**, reboot if asked, then run `TOPIX8_8602_Server.exe` again (include HASP drivers). Keep the HASP key on the old production server except for a short human test.
