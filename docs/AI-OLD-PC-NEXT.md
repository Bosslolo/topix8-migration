# For the OLD PC agent — what to do next

**Repo:** `Bosslolo/topix8-migration` — `git pull` first.  
**Shared disk:** `\\WDMYCLOUD\Public\TOPIX-Migration-Staging\` (aka `F:\TOPIX-Migration-Staging\` if mapped).

New Lenovo already has NAS access and is installing TOPIX8 Server from staging installers. Production must stay on **this** HP until cutover.

---

## Do NOT

- Do **not** remove the Aladdin HASP key from this PC except for a human-supervised short test on the new PC (then plug it back here).
- Do **not** stop TOPIX8 Server during normal business hours without the user saying cutover/idle is OK.
- Do **not** delete live `C:\Topix\Topix Daten\*.4DD`.

---

## URGENT — QuickTime 6.5 for the new PC

The Lenovo **cannot install TOPIX8** until Apple **QuickTime 6.5.x** is present.

See [QUICKTIME-6.5.md](QUICKTIME-6.5.md). Find the 6.5 installer on this PC/media and copy it to:

`\\WDMYCLOUD\Public\TOPIX-Migration-Staging\installers\QuickTimeInstaller-6.5.2.exe`

Do **not** uninstall QuickTime here. Do **not** send QuickTime 7 unless 6.5 is unavailable (TOPIX may reject 7).

---

## Safe anytime (server can keep running)

1. Ensure Public share is reachable:

```powershell
Test-Path \\WDMYCLOUD\Public\TOPIX-Migration-Staging
# or
net use F: \\192.168.18.17\Public /persistent:yes
```

2. Refresh installer + licenses on the share (overwrite OK):

```powershell
$stage = "\\WDMYCLOUD\Public\TOPIX-Migration-Staging"
New-Item -ItemType Directory -Force -Path "$stage\installers","$stage\licenses","$stage\data","$stage\HASP-Drivers" | Out-Null
Copy-Item "C:\Topix\Topix Installationsprogramm\TOPIX8_8602_Server.exe" "$stage\installers\" -Force
Copy-Item "C:\Program Files (x86)\TOPIX\TOPIX8 Server\Licenses\*" "$stage\licenses\" -Force
```

3. Export inventory + HASP drivers (key can stay plugged in here):

```powershell
cd <repo>\topix8-migration
git pull
.\scripts\export-inventory.ps1
Copy-Item .\inventory-output\* "$stage\inventory\" -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path "$stage\inventory","$stage\HASP-Drivers" | Out-Null
.\scripts\export-hasp-drivers.ps1 -Destination "$stage\HASP-Drivers"
```

4. Optional: Arbeitsplatz / extra installers from `E:\Topix Programme` into `$stage\installers\Topix Programme\` (robocopy).

---

## Only in an agreed idle / cutover window

1. Tell users to leave TOPIX. Quit TOPIX8 Server cleanly on this PC.
2. Confirm `.4DD` unlocked, then copy live data to the NAS:

```powershell
cd <repo>\topix8-migration
.\scripts\stage-data-copy.ps1 -Destination "\\WDMYCLOUD\Public\TOPIX-Migration-Staging\data"
# Prefer explicit data destination used by German docs:
# .\scripts\stage-data-copy.ps1 -Destination "F:\TOPIX-Migration-Staging\data"
```

Or one-shot:

```powershell
.\scripts\prepare-migration-bundle.ps1 -StagingRoot "\\WDMYCLOUD\Public\TOPIX-Migration-Staging"
```

3. Verify sizes of `TOPIX Daten ansatz.4DD` / indexes / `TOPIX8.4DC` on the share match source.
4. Write/update `STAGING-MANIFEST.txt` (prepare script does this).
5. Report to the user: staging UNC, file sizes, whether server was restarted afterward.

After the new PC has restored data and passed smoke tests, humans move the HASP key permanently and clients are repointed. Until then, **restart TOPIX8 Server here** if the user still needs production.

---

## Status expected from new PC (context)

- Uses `\\WDMYCLOUD\Public` / `F:` for transfer.
- Installs Server from `...\installers\TOPIX8_8602_Server.exe`.
- Will only open the live DB after `...\data\` is filled and cutover is approved.
