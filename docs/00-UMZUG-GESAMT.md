# 00 – Umzug gesamt (TOPIX 8)

Schrittige Anleitung für den Umzug vom **alten Server (HP EliteDesk)** auf den **neuen PC**.  
Kein VM – physikalischer Windows-PC.

## Ausgangslage (Alter PC)

| Punkt | Wert |
|-------|------|
| OS | Windows 11 Pro |
| TOPIX Server | `C:\Program Files (x86)\TOPIX\TOPIX8 Server` |
| Daten | `C:\Topix\Topix Daten\` |
| Live-DB | `TOPIX Daten ansatz.4DD` (~18 GB) |
| Struktur | `TOPIX8.4DC` |
| USB-Lizenz | **Aladdin HASP** (muss physisch mit) |
| Staging | `F:\TOPIX-Migration-Staging\` |
| Repo | https://github.com/Bosslolo/topix8-migration |

## Phasenübersicht

```
[ VORBEREITUNG neuer PC ] → [ HASP-Test ] → [ CUTOVER Ruhezeit ]
        → [ Daten kopieren ] → [ Neuer Server live ] → [ Clients ]
        → [ Alter PC als Rollback bereithalten ]
```

### Phase A – Neuer PC vorbereiten (alter Server läuft weiter)

1. Windows 11 **Pro** (nicht Home), Updates, lokaler Admin.  
2. Mindestens **16 GB RAM**, SSD mit **≥ 100 GB frei**.  
3. LAN wie bisher (feste IP empfiehlt sich).  
4. GitHub: `gh auth login` → Repo klonen.  
5. Zugang zu `F:\TOPIX-Migration-Staging` oder Kopie auf USB-Festplatte.  
6. Installer bereitlegen: `TOPIX8_8602_Server.exe`.  
7. Lesen: [01-NEUER-PC-VORAUSSETZUNGEN.md](01-NEUER-PC-VORAUSSETZUNGEN.md)

### Phase B – Software + HASP (Key nur kurz vom alten PC holen)

1. TOPIX8 Server aus Installer installieren (HASP-Gerätetreiber mitinstallieren).  
2. HASP-Key vom alten PC holen, **stecken**, prüfen:  
   `.\scripts\check-hasp.ps1`  
3. Geräte-Manager: „Aladdin HASP Key“ / „Aladdin USB Key“ = OK.  
4. **Key wieder zurück** auf den alten Produktions-PC, bis zum Cutover.  
5. Details: [02-HASP-USB-SCHLUESSEL.md](02-HASP-USB-SCHLUESSEL.md)

### Phase C – Cutover (kein Benutzer in TOPIX)

1. Termin ansagen. Alle Arbeitsplätze schließen.  
2. Auf altem PC: TOPIX8 Server **ordentlich beenden**.  
3. Daten spiegeln:  
   `.\scripts\stage-data-copy.ps1 -Destination "F:\TOPIX-Migration-Staging\data"`  
   oder auf externe Platte.  
4. Dateigrößen prüfen (siehe [03-DATEN-KOPIEREN.md](03-DATEN-KOPIEREN.md)).  
5. Daten auf neuen PC legen, z.B. `D:\Topix\Topix Daten\`.  
6. Lizenzdateien nach `...\TOPIX8 Server\Licenses\` kopieren.  
7. HASP-Key **endgültig** am neuen PC.  
8. TOPIX8 Server starten, Datenbank öffnen.  
9. Smoke-Test: Anmelden, Datensatz, Druck/Export.  
10. Clients umstellen ([05-CLIENTS-UMSTELLEN.md](05-CLIENTS-UMSTELLEN.md)).  
11. Alten Server **aus** lassen (kein zweiter lizenzierter Betrieb).

### Phase D – Nacharbeit

- Tägliches Backup auf **zweite Platte** einstellen.  
- Alten PC ≥ 2 Wochen nicht formatieren (Rollback).  
- Checkliste abhaken: [06-CHECKLISTE.md](06-CHECKLISTE.md)

## Rollback (falls neuer PC problematisch)

1. Neuen Server stoppen, Key zurück auf alten PC.  
2. Alten TOPIX8 Server starten (Originaldaten `C:\Topix\Topix Daten\` waren unangetastet).  
3. Clients wieder auf alten Hostnamen/IP.

## Was dieses Repo enthält / nicht enthält

| Enthalten | Nicht enthalten |
|-----------|-----------------|
| Anleitungen, Checklisten | Live-`.4DD` (~18 GB) |
| PowerShell-Skripte | Große `.exe` im Git (liegen im Staging) |
| Inventar / HASP-Doku | Kundendaten |

## Kontakt / Support

- TOPIX Hersteller: https://www.topix.de  
- TOPIX 8 = Altversion; aktuelle TOPIX oft Online-Lizenz. Bei dauerhaftem HASP-Problem unter Win11 Support fragen.
