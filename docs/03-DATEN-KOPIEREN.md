# 03 – Daten kopieren

Die Live-Datenbank liegt **nicht** im Git-Repo. Sie muss über NAS / USB-Festplatte / Netzwerkkopie.

## Pflicht-Dateien aus `C:\Topix\Topix Daten\`

| Datei / Ordner | Bedeutung |
|----------------|-----------|
| `TOPIX Daten ansatz.4DD` | Live-Datenbank (~18 GB) |
| `TOPIX Daten ansatz.4DIndx` | Index |
| `TOPIX Daten ansatz.4DIndy` | Index |
| `TOPIX Daten ansatz.Match` | falls vorhanden |
| `TOPIX8.4DC` | Programmstruktur |
| `Preferences\` | u.a. Backup-Einstellungen |
| Journal-Dateien | mitkopieren falls vorhanden |

**Nicht nötig** auf dem neuen PC: `*_broken.4DD` (bereits nach `F:\TOPIX-Migration-Staging\archive-broken\` ausgelagert).

## Vor dem Kopieren (alter PC)

1. Alle Benutzer abmelden / Arbeitsplätze schließen.  
2. **TOPIX8 Server beenden** (nicht nur Fenster minimieren).  
3. Prüfen, dass die `.4DD` nicht gesperrt ist (Skript meldet das indirekt über robocopy-Erfolg).

## Empfohlenes Skript (alter PC, aus diesem Repo)

```powershell
cd C:\Users\HP EliteDesk\Projects\topix8-migration
# oder wo das Repo liegt

.\scripts\stage-data-copy.ps1 -Destination "F:\TOPIX-Migration-Staging\data"
```

Das kopiert:

- Datenordner → `...\data\Topix Daten\`
- Licenses → `...\data\Licenses\` (bzw. parallele Struktur laut Skript)
- Installer → `...\data\Installers\`

Zielstruktur laut Skript:

```
F:\TOPIX-Migration-Staging\data\
  Topix Daten\
  Licenses\
  Installers\
```

(Bereits existierende `F:\TOPIX-Migration-Staging\installers` und `licenses` können parallel genutzt werden.)

## Alternative: USB-Festplatte

```powershell
.\scripts\stage-data-copy.ps1 -Destination "E:\TOPIX-Migration-Staging\data"
# Laufwerksbuchstabe anpassen
```

## Auf dem neuen PC einspielen

1. Zielordner anlegen, z.B. `D:\Topix\Topix Daten\`.  
2. Inhalt von Staging `Topix Daten\` dorthin kopieren (robocopy oder Explorer – Größen vergleichen!).  
3. Beispiel:

```powershell
robocopy "F:\TOPIX-Migration-Staging\data\Topix Daten" "D:\Topix\Topix Daten" /E /COPY:DAT /R:2 /W:5 /MT:4
```

4. Größen der `.4DD` Quell/Ziel **müssen gleich** sein.  
5. Lizenzdateien nach Server-`Licenses\` (siehe HASP-Doku).

## Inventar exportieren (optional, alter PC)

```powershell
.\scripts\export-inventory.ps1
```

Ausgabe unter `inventory-output\` – kann mit auf den neuen PC.

## Niemals

- Live-`.4DD` in Git committen.  
- Alte Live-DB löschen, bevor neuer Server Tage erfolgreich lief.  
- Während Benutzer arbeiten die DB kopieren (Inkonsistenz).
