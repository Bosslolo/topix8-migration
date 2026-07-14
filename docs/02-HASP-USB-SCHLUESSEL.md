# 02 – Aladdin HASP USB-Lizenzschlüssel

## Was das ist

- Kein USB-Stick zum Speichern von Dateien.  
- Hardware-Lizenz: **Aladdin HASP** / SafeNet-Familie.  
- Am alten PC sichtbar als:
  - **Aladdin USB Key** (`VID_0529`)
  - **Aladdin HASP Key**
- Windows-Eintrag: **HASP Gerätetreiber**

Ohne diesen Key startet TOPIX8 Server nicht korrekt lizenziert.

## Warum der neue Windows-11-PC den Key „nicht sieht“

1. Windows braucht die **HASP-Treiber**.  
2. Ohne Treiber: Unbekanntes USB-Gerät oder gar keine sinnvolle Anzeige.  
3. Auf dem alten PC sind sehr alte Treiber (ca. 2006) – frisches Win11 + Secure Boot blockiert oft, bis der TOPIX-Installer die Treiber setzt.  
4. Key nur stecken **ohne** Treiber bringt nichts.

## Reihenfolge (verbindlich)

1. TOPIX8 Server installieren (HASP-/Gerätetreiber-Option mitnehmen, falls gefragt).  
2. Neustart falls Installer das verlangt.  
3. Key stecken.  
4. Prüfen:

```powershell
cd Pfad\zu\topix8-migration
.\scripts\check-hasp.ps1
```

Geräte-Manager → USB / HASP: Status **OK**, keine gelben Ausrufezeichen.

5. Erst wenn das klappt: mit Cutover und Datenweitermachen.

## Kurztest vor dem Umzugstag

- Alten Server vorher kurz herunterfahren oder TOPIX beenden.  
- Key am neuen PC testen.  
- Danach **sofort wieder** am alten PC, bis zum finalen Cutover.  
- Nie zwei Server gleichzeitig mit demselben Key betreiben wollen.

## Wenn es nicht erkannt wird

1. Anderen USB-Port (hinten Mainboard, USB 2.0 falls vorhanden).  
2. TOPIX-Installer erneut „Reparieren“ / HASP-Komponenten nachinstallieren.  
3. Keine USB-Dock/Hub-Zwischenstücke.  
4. Lizenzdateien `*.license4D` ins Server-`Licenses\`-Verzeichnis kopieren (liegen im Staging).  
5. TOPIX Support kontaktieren – TOPIX 8 ist Altversion; ggf. Lizenzweg klären.

## Lizenzdateien (zusätzlich zum Hardware-Key)

Vom Staging:

```
F:\TOPIX-Migration-Staging\licenses\
  1.license4D
  pl1.license4D
```

Ziel auf dem neuen PC typischerweise:

```
C:\Program Files (x86)\TOPIX\TOPIX8 Server\Licenses\
```

## Verbotenes

- Key wegwerfen oder „irgendwo“ deponieren während Produktion läuft.  
- Produktion dauerhaft über VM + USB-Passthrough.  
- Key endgültig vom alten PC nehmen, bevor Daten verifiziert auf dem neuen PC laufen.
