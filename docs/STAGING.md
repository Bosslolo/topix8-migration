# Staging-Orte (nicht im Git)

Gemeinsamer Spot für **beide** PCs: **`\\WDMYCLOUD\Public`** (meist `F:\`).  
Siehe auch [SHARED-NAS.md](SHARED-NAS.md).

## Bereits vorhanden

| Pfad | Inhalt |
|------|--------|
| `\\WDMYCLOUD\Public\TOPIX-Migration-Staging\installers\TOPIX8_8602_Server.exe` | Server-Installer (~275 MB) |
| `...\licenses\` | `1.license4D`, `pl1.license4D` |
| `...\archive-broken\` | alte broken-4DD (Archiv) |
| `...\data\` | **hierhin** Live-DB beim Cutover (noch leer bis Server-Stopp) |

## Alten PC (Originale)

| Pfad | Inhalt |
|------|--------|
| `C:\Topix\Topix Daten\` | Live-DB |
| `C:\Topix\Topix Installationsprogramm\` | Installer |
| `C:\Program Files (x86)\TOPIX\TOPIX8 Server\` | laufende Installation |
| `E:\Topix Programme\` | weitere Installer / Arbeitsplatz |
| `E:\Topix täglich backup\` | tägliche Backups |

## Vom neuen PC

1. NAS `F:` bzw. `\\wdmycloud\Public\...` verbinden **oder**  
2. Inhalt von `TOPIX-Migration-Staging` auf USB-Festplatte kopieren und mitnehmen.
