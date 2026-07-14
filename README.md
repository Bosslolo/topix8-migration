# TOPIX 8 Migration Kit

Private handoff package for moving **TOPIX8 Server** (and clients) from the production HP EliteDesk to a new PC.

**This repo does NOT contain the live database.** The `.4DD` file is ~18 GB and must be copied by disk/network (see below). Putting ERP customer data in GitHub is also a privacy risk.

## Tell the other AI (old PC)

Paste this to Cursor on the **production** machine:

> Pull `Bosslolo/topix8-migration`, then follow **`docs/AI-OLD-PC-INSTRUCTIONS.md`** exactly. Run all non-physical staging steps. Prefer `.\scripts\prepare-migration-bundle.ps1 -StagingRoot "F:\TOPIX-Migration-Staging"` after TOPIX is idle and stopped. Do not move the HASP key. Report the staging path and `STAGING-MANIFEST.txt` summary when done.

| Agent doc | Machine |
|-----------|---------|
| [docs/AI-OLD-PC-INSTRUCTIONS.md](docs/AI-OLD-PC-INSTRUCTIONS.md) | Old HP (stage installers + DB + licenses + HASP drivers) |
| [docs/AI-NEW-PC-INSTRUCTIONS.md](docs/AI-NEW-PC-INSTRUCTIONS.md) | New Lenovo (install + restore once staging arrives) |

One-shot on old PC (after server stop):

```powershell
git pull
.\scripts\prepare-migration-bundle.ps1 -StagingRoot "F:\TOPIX-Migration-Staging"
```

## Source machine (as of 2026-07-14)

| Item | Value |
|------|--------|
| Host | HP EliteDesk, Windows 11 Pro (build 26200) |
| CPU | AMD PRO A10-8770E (4 cores) — often at 100% |
| RAM | ~7.4 GB — critically low for Win11 + TOPIX + browsers |
| System disk | SanDisk 256 GB SSD — C: ~12% free (~27 GB) |
| TOPIX Server | `C:\Program Files (x86)\TOPIX\TOPIX8 Server` |
| Live data | `C:\Topix\Topix Daten\` |
| Live DB | `TOPIX Daten ansatz.4DD` (~18 GB) |
| Structure | `TOPIX8.4DC` (~183 MB) |
| Installer | `C:\Topix\Topix Installationsprogramm\TOPIX8_8602_Server.exe` |
| Older installers | `E:\Topix Programme\Installationsprogramme\` |
| Daily backup folder | `E:\Topix täglich backup\` |
| Large free space | `F:` (~1 TB free on WD My Cloud) — use for staging copies |
| USB license key | **Aladdin HASP** (`VID_0529`) — physical dongle required |
| HASP drivers | Installed (“HASP Gerätetreiber”); driver files dated **2006** |
| 4D licenses | `...\TOPIX8 Server\Licenses\*.license4D` |

## Biggest blocker: USB key on a fresh Windows 11 PC

The key is **not** a normal USB stick. Windows only recognizes it after **Aladdin/SafeNet HASP drivers** are installed.

On a clean PC without those drivers, Device Manager shows an unknown USB device (or nothing useful). That is expected.

**Order of operations on the new PC:**

1. Install TOPIX8 Server from the installer (or install HASP drivers first).
2. Confirm Device Manager shows **Aladdin HASP Key** / **Aladdin USB Key**.
3. Only then move the physical key permanently and open the copied database.

**Do not** remove the key from the old PC until:

- Data has a verified offline copy (checksum / open on new PC), and  
- HASP drivers work on the new PC (can test briefly with the key, then plug back into production until cutover).

See [docs/HASP-USB-KEY.md](docs/HASP-USB-KEY.md).

## What goes where

| Content | Transport |
|---------|-----------|
| Migration docs + scripts (this repo) | Private GitHub → `git clone` on new PC |
| Server/client installers (~280 MB) | External disk / `F:` staging / GitHub Release (not normal git) |
| Live DB + indexes (~19+ GB) | `robocopy` / external disk — **never git** |
| Physical HASP key | Hand-carry to new PC |

## Cutover overview

1. **Idle window** — no users in TOPIX.
2. Stop TOPIX8 Server cleanly on the old machine.
3. Run `scripts/export-inventory.ps1` and `scripts/stage-data-copy.ps1` (stage to `F:\TOPIX-Migration-Staging` or external disk).
4. On new PC (Win11 **Pro** recommended): install TOPIX8 Server + HASP, clone this repo, restore data path, plug key, open DB.
5. Point Arbeitsplatz clients at the new server IP/name.
6. Keep old PC offline (or key removed) so only one licensed server runs.

Details: [docs/MIGRATION-RUNBOOK.md](docs/MIGRATION-RUNBOOK.md)

## New PC requirements

- Windows 11 **Pro** (or Windows Server) — avoid Home.
- At least **16 GB RAM** (32 GB better), SSD with **≥100 GB free**.
- USB port that stays powered (no flaky hubs for the HASP key).
- Same LAN reachability for clients.

## Repo setup (once)

```powershell
gh repo create Bosslolo/topix8-migration --private --source=. --remote=origin --push
```

On the new machine:

```powershell
gh auth login
git clone https://github.com/Bosslolo/topix8-migration.git
```

Then copy database files with robocopy from staging media — see scripts.

## Safety

- Never delete `TOPIX Daten ansatz.4DD` on the old PC until the new server has run for several days.
- Prefer copying the broken `*_broken.4DD` off C: only after a verified second copy exists (frees ~16 GB on a full system disk).
- Contact TOPIX (topix.de) if HASP fails on Win11; TOPIX 8 is legacy and support may advise upgrade / license options.
