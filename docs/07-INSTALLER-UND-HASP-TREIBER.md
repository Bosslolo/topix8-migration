# 07 – Installer & HASP-Treiber (exakte Version)

## Warum nicht alle `.exe` im Git-Ordner?

GitHub blockiert Dateien **über 100 MB** im normalen Git.  
`TOPIX8_8602_Server.exe` ist ~**275 MB** → liegt als **Release-Asset** am gleichen privaten Repo.

| Datei | Größe | Wo |
|-------|------|-----|
| `TOPIX8_8602_Server.exe` | ~275 MB | **Release** `topix8-binaries` |
| `TOPIX8_8501_Server.exe` | ~266 MB | Release |
| `TOPIX8_8500_Arbeitsplatz.exe` | ~67 MB | Release |
| `TOPIX8_8410_Einzelplatz.exe` | ~122 MB | Release |
| HASP-Treiber vom laufenden PC | klein | Ordner **`hasp-drivers/`** im Repo |

Download auf dem neuen PC:

```powershell
gh auth login
gh release download topix8-binaries -R Bosslolo/topix8-migration -D .\installers-download
```

Oder im Browser: Repo → **Releases** → `topix8-binaries`.

---

## Exakte HASP-Treiber (funktionieren auf diesem PC)

Aufgenommen vom Produktions-PC mit **erkanntem** Key (`VID_0529`).

| Datei | Größe | Datum |
|-------|------:|-------|
| `aksclass.sys` | 13952 | 2006-10-16 |
| `akshasp.sys` | 90240 | 2006-12-04 |
| `aksusb.sys` | 18688 | 2006-12-04 |
| `hardlock.sys` | 314368 | 2006-12-04 |

- Windows-Produktname: **HASP Gerätetreiber**
- Geräte bei Erfolg: `Aladdin USB Key`, `Aladdin HASP Key`
- Treiberstore-Pakete (installierbar):  
  `hasp-drivers/filerepository/akshasp.inf_amd64_*`  
  `hasp-drivers/filerepository/aksusb.inf_amd64_*`
- Details: `hasp-drivers/VERSION.txt`

### Installation auf dem neuen PC (Reihenfolge)

1. Zuerst `TOPIX8_8602_Server.exe` installieren (HASP-/Gerätetreiber-Option).  
2. Falls Key noch unbekannt:

```powershell
cd topix8-migration
.\scripts\install-hasp-drivers.ps1
.\scripts\check-hasp.ps1
```

3. Key stecken, anderen USB-Port versuchen, ggf. neu starten.

`.sys` allein zu kopieren reicht oft **nicht** – immer die `filerepository\*.inf` per `pnputil` nutzen (macht das Skript).

---

## Empfohlene TOPIX-Version

| Rolle | Datei |
|-------|--------|
| Server (aktuell hier) | **TOPIX8_8602_Server.exe** |
| Arbeitsplatz | TOPIX8_8500_Arbeitsplatz.exe |

DB und physischen USB-Key nimmst du separat mit (nicht über Git).
