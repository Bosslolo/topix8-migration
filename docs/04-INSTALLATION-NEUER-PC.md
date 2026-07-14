# 04 – Installation auf dem neuen PC

## 1. Repo holen

```powershell
gh auth login
git clone https://github.com/Bosslolo/topix8-migration.git
cd topix8-migration
```

## 2. Installer holen

Vom NAS Staging:

```
F:\TOPIX-Migration-Staging\installers\TOPIX8_8602_Server.exe
```

Falls `F:` fehlt: USB-Kopie vom alten PC / Staging mitnehmen.

Optional Arbeitsplatz:

```
E:\Topix Programme\Installationsprogramme\TOPIX8_8500_Arbeitsplatz.exe
```

(ältere Varianten liegen dort ebenfalls.)

## 3. TOPIX8 Server installieren

1. `TOPIX8_8602_Server.exe` als Administrator starten.  
2. Falls Auswahl: **HASP Gerätetreiber** / vollständige Installation wählen.  
3. Installation abschließen, ggf. neu starten.  
4. Typischer Pfad:  
   `C:\Program Files (x86)\TOPIX\TOPIX8 Server\`

## 4. Lizenzdateien kopieren

```powershell
Copy-Item "F:\TOPIX-Migration-Staging\licenses\*" `
  "C:\Program Files (x86)\TOPIX\TOPIX8 Server\Licenses\" -Force
```

## 5. HASP prüfen

Key stecken (beim finalen Cutover dauerhaft; vorher nur Test):

```powershell
.\scripts\check-hasp.ps1
```

Erwartung: Status OK für Aladdin HASP / USB Key.

## 6. Datenordner verbinden

1. Daten liegen z.B. unter `D:\Topix\Topix Daten\`.  
2. TOPIX8 Server starten (`TOPIX8_Server.EXE`).  
3. Datenbank / Datenordner öffnen – dieselbe Kombination aus:
   - `TOPIX8.4DC` (Struktur)
   - `TOPIX Daten ansatz.4DD` (Daten)  
4. Wenn Pfade anders als früher: in TOPIX/4D den Datenordner einmalig korrekt auswählen (wie gewohnt beim Öffnen einer bestehenden Datenbank).

## 7. Firewall / Dienst

- TOPIX/4D-Server-Ports in der Windows-Firewall für das LAN freigeben.  
- Optional: Autostart von TOPIX8 Server nach Login/Boot (nur wenn gewünscht und Key immer steckt).  
- Feste IP empfehlen und notieren.

## 8. Erster Funktionstest

- [ ] Server startet ohne Lizenzfehler  
- [ ] Anmelden möglich  
- [ ] Aktuelle Daten sichtbar (letzter Arbeitstag)  
- [ ] Ein Beleg / Report / Export probeweise  
- [ ] Backup-Pfad in Preferences setzen (zweite Platte!)

## 9. Alten PC

- TOPIX **nicht** parallel starten.  
- Key nur am neuen PC.  
- Alten Rechner ausschalten oder TOPIX deaktiviert lassen – Rollback-Reserve behalten.

Weiter: [05-CLIENTS-UMSTELLEN.md](05-CLIENTS-UMSTELLEN.md)
