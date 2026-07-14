# Production inventory snapshot (2026-07-14)

Collected from the live HP EliteDesk while preparing migration. Re-run `scripts/export-inventory.ps1` for an up-to-date dump.

## Paths

| Role | Path |
|------|------|
| Server install | `C:\Program Files (x86)\TOPIX\TOPIX8 Server` |
| Server EXE | `TOPIX8_Server.EXE` |
| Components | `...\Components\TOPIX8.4dbase`, `TOPIX8 U.4dbase` |
| Licenses | `...\Licenses\1.license4D`, `pl1.license4D` |
| Client install | `C:\Program Files (x86)\TOPIX\TOPIX8 Arbeitsplatz` |
| Data root | `C:\Topix\Topix Daten` |
| Installer (8.6.02) | `C:\Topix\Topix Installationsprogramm\TOPIX8_8602_Server.exe` |
| Extra installers | `E:\Topix Programme\` |
| Daily backup tree | `E:\Topix täglich backup\` |
| Staging recommendation | `F:\TOPIX-Migration-Staging\` |

## Database files (approximate sizes)

| File | Size |
|------|------|
| `TOPIX Daten ansatz.4DD` | ~18 GB (live) |
| `TOPIX Daten ansatz_broken.4DD` | ~16 GB (archive; free C: later) |
| `TOPIX Daten ansatz.4DIndx` | ~632 MB |
| `TOPIX Daten ansatz.4DIndy` | ~4 MB |
| `TOPIX8.4DC` | ~183 MB |

## License hardware

- Aladdin HASP USB key present and OK on source PC
- Drivers: aks*.sys / hardlock.sys (~2006)

## Source PC health (why migration matters)

- RAM ~7 GB, CPU often 100%
- C: ~12% free
- Background load: Macrium Reflect, AnyDesk, Avira, Opera, Cursor
- Uptime was ~35 days at measurement

## Explicitly excluded from Git

All `.4DD` / indexes / journals / large `.exe` installers — see `.gitignore`.
