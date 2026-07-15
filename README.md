# TOPIX 8 Umzug (Migration)

Privates Repo für den Umzug von **TOPIX8 Server** vom alten HP EliteDesk auf den **neuen PC**.

**Wichtig:** Die lebende Datenbank (~18 GB) liegt **nicht** in GitHub. Daten über Festplatte / `F:\TOPIX-Migration-Staging`.

Repo: https://github.com/Bosslolo/topix8-migration (privat)

---

## Für Menschen (Start hier)

| Dokument | Inhalt |
|----------|--------|
| [docs/00-UMZUG-GESAMT.md](docs/00-UMZUG-GESAMT.md) | **Gesamtablauf Umzug** |
| [docs/01-NEUER-PC-VORAUSSETZUNGEN.md](docs/01-NEUER-PC-VORAUSSETZUNGEN.md) | Was der neue PC braucht |
| [docs/02-HASP-USB-SCHLUESSEL.md](docs/02-HASP-USB-SCHLUESSEL.md) | USB-Lizenzschlüssel unter Win11 |
| [docs/03-DATEN-KOPIEREN.md](docs/03-DATEN-KOPIEREN.md) | Datenbank & Staging |
| [docs/04-INSTALLATION-NEUER-PC.md](docs/04-INSTALLATION-NEUER-PC.md) | TOPIX installieren |
| [docs/05-CLIENTS-UMSTELLEN.md](docs/05-CLIENTS-UMSTELLEN.md) | Arbeitsplätze umstellen |
| [docs/06-CHECKLISTE.md](docs/06-CHECKLISTE.md) | Abhak-Liste Tag X |
| [docs/STAGING.md](docs/STAGING.md) | Wo liegen Installer/Lizenzen/Daten |
| [docs/INVENTORY.md](docs/INVENTORY.md) | Inventar alter PC |

### Auf dem neuen PC

```powershell
gh auth login
git clone https://github.com/Bosslolo/topix8-migration.git
cd topix8-migration
# dann: docs\00-UMZUG-GESAMT.md
```

---

## Shared NAS (beide PCs)

Big files live on **`\\WDMYCLOUD\Public`** (often mapped as `F:`).  
Migration bundle: **`\\WDMYCLOUD\Public\TOPIX-Migration-Staging\`**  
Details: [docs/SHARED-NAS.md](docs/SHARED-NAS.md)

## Für Cursor / AI auf den jeweiligen PCs

| Anleitung | Maschine |
|-----------|----------|
| [docs/AI-OLD-PC-NEXT.md](docs/AI-OLD-PC-NEXT.md) | **Start here on old HP** – what to put on Public / when to copy live DB |
| [docs/QUICKTIME-6.5.md](docs/QUICKTIME-6.5.md) | **Blocker:** QuickTime 6.5 required before TOPIX install |
| [docs/AI-OLD-PC-INSTRUCTIONS.md](docs/AI-OLD-PC-INSTRUCTIONS.md) | Full staging cookbook |
| [docs/AI-NEW-PC-INSTRUCTIONS.md](docs/AI-NEW-PC-INSTRUCTIONS.md) | Neuer Lenovo – Installation + Restore |

**An die KI auf dem alten PC:**

> Pull `Bosslolo/topix8-migration`, follow **`docs/AI-OLD-PC-NEXT.md`**. Use `\\WDMYCLOUD\Public\TOPIX-Migration-Staging` for all large files. Keep production TOPIX + HASP key on this PC until cutover. Only stop the server and copy live `data\` when the user approves an idle window.

One-Shot auf dem alten PC (TOPIX vorher stoppen):

```powershell
git pull
.\scripts\prepare-migration-bundle.ps1 -StagingRoot "F:\TOPIX-Migration-Staging"
```

---

## Was wird umgezogen?

| Was | Transport |
|-----|-----------|
| Anleitungen + Skripte | dieses Repo (`git clone`) |
| Installer (~275 MB) | `F:\TOPIX-Migration-Staging\installers\` |
| Lizenzdateien | Staging `licenses\` |
| Datenbank ~18 GB | Staging `data\` / robocopy – **nie Git** |
| Physischer HASP-Key | Hand mitnehmen (erst nach Treiber-Test / Cutover) |

## Staging (NAS)

```
F:\TOPIX-Migration-Staging\
  installers\          TOPIX8_8602_Server.exe
  licenses\            *.license4D
  data\                Live-DB erst nach Server-Stopp
  archive-broken\      alte broken-4DD (Archiv)
  HASP-Drivers\        falls per Skript exportiert
  STAGING-MANIFEST.txt nachdem Bundle-Skript lief
```

## Kritische Reihenfolge

1. Neuer PC: Win11 **Pro**, genug RAM/SSD  
2. Repo klonen, Installer + TOPIX8 Server (mit HASP-Treibern)  
3. HASP kurz testen → Key zurück auf alten PC bis Cutover  
4. Alter PC: TOPIX stoppen → `prepare-migration-bundle.ps1` / `stage-data-copy.ps1`  
5. Daten auf neuen PC, Key endgültig, Server starten, Clients umstellen  
6. Alten Server aus lassen (≥2 Wochen Rollback)

## Sicherheit

- Live-DB auf dem alten PC nicht löschen, bis neuer Server Tage stabil läuft.  
- Kein Produktionsbetrieb in VMs.  
- Bei HASP-Problemen: TOPIX Support (topix.de).
