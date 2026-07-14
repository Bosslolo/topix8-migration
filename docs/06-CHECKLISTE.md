# 06 – Checkliste Umzugstag

## Vorher (Tage davor)

- [ ] Neuer PC: Win11 Pro, Updates, ≥16 GB RAM, genug SSD-Platz  
- [ ] Repo geklont: `https://github.com/Bosslolo/topix8-migration`  
- [ ] Staging erreichbar: `F:\TOPIX-Migration-Staging\` (Installer + Licenses schon drauf)  
- [ ] Installer `TOPIX8_8602_Server.exe` getestet (Installation ohne finalen Key ok)  
- [ ] HASP kurz getestet, Key wieder am alten Server  
- [ ] Feste IP / Hostname des neuen Servers geplant  
- [ ] Cutover-Zeitfenster mit Nutzern abgesprochen  
- [ ] Externe USB-Platte als Plan B falls NAS hakt  

## Cutover

- [ ] Alle Benutzer offline  
- [ ] TOPIX8 Server auf altem PC beendet  
- [ ] `stage-data-copy.ps1` nach Staging / USB ausgeführt  
- [ ] Dateigröße `.4DD` Quell = Ziel geprüft  
- [ ] Daten auf neuem PC am Zielpfad  
- [ ] `*.license4D` in Server-`Licenses\`  
- [ ] HASP-Key am neuen PC, `check-hasp.ps1` = OK  
- [ ] TOPIX8 Server startet, DB öffnet  
- [ ] Smoke-Test (Login, Daten, Druck/Export)  
- [ ] Mindestens ein Arbeitsplatz-Client verbunden  
- [ ] Alten Server aus / TOPIX gestoppt  

## Danach (Tage danach)

- [ ] Tägliches Backup auf zweite Platte konfiguriert  
- [ ] Alle Clients umgestellt  
- [ ] 2+ Wochen alter PC als Rollback behalten  
- [ ] Erst dann alten PC außer Dienst / plattmachen  

## Bei Problemen

| Symptom | Erste Schritte |
|---------|----------------|
| Key nicht erkannt | HASP-Doku, Treiber, anderer USB-Port, `check-hasp.ps1` |
| Lizenzfehler | `Licenses\*.license4D` + Key steckt |
| Alte Daten fehlen | Größenvergleich Staging vs. Ziel, erneutes robocopy |
| Clients verbinden nicht | IP/Hostname, Firewall, Server läuft |
| Katastrophe | Key + Betrieb zurück auf alten PC (Rollback) |
