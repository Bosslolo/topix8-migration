# Inventar alter Produktions-PC (Stand 2026-07-14, aktualisiert)

## Identität

| | |
|--|--|
| Typ | HP EliteDesk |
| OS | Windows 11 Pro (Build 26200) |
| CPU | AMD PRO A10-8770E (4 Kerne) – oft ausgelastet |
| RAM | ~7,4 GB (knapp) |
| Systemdisk | SanDisk 256 GB SSD |

## TOPIX

| Rolle | Pfad |
|-------|------|
| Server | `C:\Program Files (x86)\TOPIX\TOPIX8 Server` |
| EXE | `TOPIX8_Server.EXE` |
| Arbeitsplatz | `C:\Program Files (x86)\TOPIX\TOPIX8 Arbeitsplatz` |
| Daten | `C:\Topix\Topix Daten` |
| Live-DB | `TOPIX Daten ansatz.4DD` (~18 GB) |
| Struktur | `TOPIX8.4DC` |
| Lizenzen | `...\Licenses\1.license4D`, `pl1.license4D` |
| Installer 8.6.02 | `C:\Topix\Topix Installationsprogramm\TOPIX8_8602_Server.exe` |
| Weitere Installer | `E:\Topix Programme\` |
| Tägliches Backup | `E:\Topix täglich backup\` |

## USB-Lizenz

- Aladdin HASP, Gerätetreiber installiert  
- Treiberdateien u.a. `aks*.sys`, `hardlock.sys`

## Staging (NAS F:)

```
F:\TOPIX-Migration-Staging\
  installers\TOPIX8_8602_Server.exe
  licenses\*.license4D
  data\          (für Live-Kopie beim Cutover)
  archive-broken\  (*_broken.4DD ausgelagert, C: entlastet)
```

## Hinweis Freispeicher

Die Datei `TOPIX Daten ansatz_broken.4DD` wurde nach `archive-broken` verschoben (verifiziert) und von C: entfernt. **Live-DB unverändert.**
