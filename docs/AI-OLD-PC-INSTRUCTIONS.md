# AI instructions — OLD production PC (non-physical only)

**Audience:** Cursor / AI agent on the HP EliteDesk that currently runs TOPIX8 Server.  
**Goal:** Stage everything the new Lenovo can install and restore from disk/network.  
**Repo:** `https://github.com/Bosslolo/topix8-migration` (private)

Humans handle anything that needs hands. You handle everything else on this machine.

---

## Do NOT do (human / physical)

- Do **not** unplug or relocate the Aladdin HASP USB key for cutover (brief Device Manager glance is OK if the human plugged it; leave it in production until cutover).
- Do **not** delete `TOPIX Daten ansatz.4DD` or any live data.
- Do **not** decommission the old PC, reimage it, or change client DNS/DHCP on the LAN.
- Do **not** commit `.4DD` / indexes / installers / journals to Git (blocked by `.gitignore` for good reason).

---

## Prerequisites you must verify first

1. Clone or pull this repo on the old PC:

```powershell
gh auth login   # if needed
git clone https://github.com/Bosslolo/topix8-migration.git
# or, if already cloned:
cd <path-to>\topix8-migration
git pull
```

2. Confirm these paths exist (adjust only if inventory proves otherwise):

| Role | Path |
|------|------|
| Live data | `C:\Topix\Topix Daten\` |
| Server | `C:\Program Files (x86)\TOPIX\TOPIX8 Server\` |
| Licenses | `C:\Program Files (x86)\TOPIX\TOPIX8 Server\Licenses\` |
| Installer folder | `C:\Topix\Topix Installationsprogramm\` |
| Extra installers | `E:\Topix Programme\` (if present) |
| Preferred staging root | `F:\TOPIX-Migration-Staging\` (~1 TB free preferred) |

3. If `F:` is missing or full, pick another drive with **≥40 GB free** (prefer ≥60 GB) and use that as `$StagingRoot` below.

4. Schedule / confirm with the user: **TOPIX must be idle** — no Arbeitsplatz users — before the live DB copy. Tell the user clearly when you need them to stop TOPIX8 Server.

---

## One-shot: preferred workflow

From the repo root, after TOPIX8 Server is **stopped** and the `.4DD` is unlocked:

```powershell
cd <path-to>\topix8-migration
.\scripts\prepare-migration-bundle.ps1 -StagingRoot "F:\TOPIX-Migration-Staging"
```

That script (in order):

1. Exports inventory → `inventory-output\` and copies it into staging.
2. Exports HASP PnP driver packages (if present) → `staging\HASP-Drivers\`.
3. Copies licenses, server installer tree, extra installers.
4. Robocopies live data (excludes `*_broken.4DD` unless `-IncludeBroken`).
5. Writes `STAGING-MANIFEST.txt` with sizes and checksums for key files.
6. Prints a short handoff summary for the new PC.

### If you must run steps manually

```powershell
# 1) Inventory (safe anytime)
.\scripts\export-inventory.ps1

# 2) HASP driver export (safe anytime; key can stay plugged in)
.\scripts\export-hasp-drivers.ps1 -Destination "F:\TOPIX-Migration-Staging\HASP-Drivers"

# 3) STOP TOPIX8 Server first (ask human if you cannot stop it safely)
#    Then stage data + licenses + installers:
.\scripts\stage-data-copy.ps1 -Destination "F:\TOPIX-Migration-Staging"
```

---

## Stopping TOPIX safely (software only)

1. Ask the user to ensure no one is working in TOPIX.
2. Stop the TOPIX8 Server process/service gracefully (prefer the app’s own Quit/Stop if a GUI is available; otherwise stop the process named like `TOPIX8_Server` / related 4D server only after confirmation).
3. Confirm the live file is not locked:

```powershell
$path = 'C:\Topix\Topix Daten\TOPIX Daten ansatz.4DD'
try {
  $fs = [IO.File]::Open($path, 'Open', 'Read', 'None')
  $fs.Close()
  'UNLOCKED — OK to copy'
} catch {
  'LOCKED — do not copy yet: ' + $_.Exception.Message
}
```

4. Only then run `prepare-migration-bundle.ps1` / `stage-data-copy.ps1`.

---

## Required staging layout

After a successful run, `$StagingRoot` should look like:

```text
F:\TOPIX-Migration-Staging\
  STAGING-MANIFEST.txt
  inventory\
    inventory-*.txt
  HASP-Drivers\          # exported .inf packages when possible
  Topix Daten\           # live DB + indexes + structure + Preferences
  Licenses\              # *.license4D
  Installers\            # TOPIX8_8602_Server.exe and related media
    Topix Programme\     # optional extras from E:
```

### Minimum files that must exist under `Topix Daten\`

- `TOPIX Daten ansatz.4DD`
- `TOPIX Daten ansatz.4DIndx`
- `TOPIX Daten ansatz.4DIndy`
- `TOPIX Daten ansatz.Match` (if it exists on source)
- `TOPIX8.4DC`
- `Preferences\` (if present)

Do **not** require `*_broken.4DD` on the staging media (optional archive later).

---

## Network share alternative (no USB walk)

If the new PC is on the same LAN and `F:` (or staging) can be shared:

1. Share `$StagingRoot` read-only to the new machine’s account, **or**
2. From the new PC, robocopy from `\\OLD-HOSTNAME\TOPIX-Migration-Staging` to local disk.

Document the share UNC in `STAGING-MANIFEST.txt` (the prepare script appends hostname + suggested UNC).

Do **not** put the database into GitHub Releases or git.

---

## Verification checklist (you must complete and report)

- [ ] Inventory file exists and shows HASP OK on this PC.
- [ ] `TOPIX Daten ansatz.4DD` size on staging matches source (within robocopy success).
- [ ] `Licenses\*.license4D` present on staging.
- [ ] `Installers\` contains `TOPIX8_8602_Server.exe` (or newest available 8.x server installer found).
- [ ] `STAGING-MANIFEST.txt` written; paste its summary back to the user.
- [ ] TOPIX8 Server left in the state the user wants (usually **restart it** after staging unless they are in a cutover freeze).

---

## Optional: push only safe text artifacts to GitHub

Allowed to commit/push if the user asks:

- Updated docs
- Fresh `inventory-output\inventory-*.txt` (no DB paths contents beyond names/sizes — already text)
- Script fixes

Never force-add ignored binary data files.

```powershell
git add docs scripts README.md
git add inventory-output/*.txt   # only if user wants inventory in git
git status   # verify no .4DD/.exe
git commit -m "chore: refresh old-PC inventory / staging notes"
git push
```

---

## What to tell the user when you finish

Report:

1. Full path of `$StagingRoot`
2. Whether TOPIX was stopped/restarted
3. Sizes of `.4DD` / `.4DC` / installer
4. Whether HASP drivers were exported
5. Suggested UNC share path (if any)
6. Anything missing (e.g. no `F:`, installer not found, file locked)

The new PC AI will consume that staging folder next. Physical HASP move waits for human cutover.
