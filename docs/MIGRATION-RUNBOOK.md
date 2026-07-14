# TOPIX 8 migration runbook

Physical machines only — no VMs for production TOPIX 8 / HASP.

## Phase 0 — Prep (old PC still running)

- [ ] Confirm HASP key lights/works; Device Manager OK.
- [ ] Clone/pull this repo on both machines when network ready.
- [ ] Stage installers onto external disk or `F:\TOPIX-Migration-Staging\installers\`.
- [ ] Free or plan C: space; do **not** delete live `.4DD`.
- [ ] Note server hostname, IP, TOPIX ports/firewall rules, client connection settings.
- [ ] Schedule downtime with users.

## Phase 1 — Verified data copy (old PC)

1. Stop **TOPIX8 Server** (and Arbeitsplatz processes using the DB).
2. Wait until `TOPIX Daten ansatz.4DD` is no longer locked.
3. Run:

```powershell
# From this repo
.\scripts\stage-data-copy.ps1 -Destination "F:\TOPIX-Migration-Staging\data"
```

Or to an external drive, e.g. `E:\TOPIX-Migration-Staging\data` / USB path.

4. Confirm sizes match (script prints summary). Optional: robocopy `/L` verify.
5. Copy installers + `Licenses` folder into staging.
6. Run `.\scripts\export-inventory.ps1` and commit or copy the JSON/TXT output into staging if desired.

**Minimum files to migrate from `C:\Topix\Topix Daten\`:**

- `TOPIX Daten ansatz.4DD`
- `TOPIX Daten ansatz.4DIndx`
- `TOPIX Daten ansatz.4DIndy`
- `TOPIX Daten ansatz.Match` (if present)
- `TOPIX8.4DC`
- `Preferences\` (backup settings)
- Journals if non-empty / in use

Do **not** require `*_broken.4DD` on the new PC (keep as archive offline).

## Phase 2 — New PC software

1. Windows 11 Pro (or Server), updates installed, local admin account.
2. Install TOPIX8 Server from `TOPIX8_8602_Server.exe`.
3. Confirm HASP drivers; plug key; verify Device Manager (see HASP doc).
4. Copy `Licenses\*.license4D` into new Server `Licenses` folder.
5. Place data under a stable path, e.g. `D:\Topix\Topix Daten\` or `C:\Topix\Topix Daten\` (prefer roomy SSD).
6. Open/register the datafile in TOPIX8 Server using the same structure (`TOPIX8.4DC`) as before.
7. Install Arbeitsplatz clients; point to new server host/IP.
8. Firewall: allow TOPIX/4D server ports used previously (document from inventory).

## Phase 3 — Cutover

1. Final differential robocopy after a short freeze (stop server again).
2. Start server only on **new** PC with HASP plugged in.
3. Old PC: leave TOPIX stopped; remove or keep key out so it cannot run licensed.
4. Smoke-test: login, open recent records, print/export one document, check backups.
5. Keep old disk image / Macrium backup for ≥2 weeks.

## Phase 4 — Aftercare

- Configure TOPIX backup Preferences to write to a **second disk** daily.
- Monitor C:/system free space on old PC until decommissioned.
- Consider TOPIX upgrade path with vendor (online license, supported OS).

## Rollback

1. Stop new server; move HASP back to old PC.
2. Start old TOPIX8 Server with original `C:\Topix\Topix Daten\` (untouched if you only copied).
3. Repoint clients to old hostname/IP.
