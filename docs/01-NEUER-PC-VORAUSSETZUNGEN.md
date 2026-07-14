# 01 – Voraussetzungen neuer PC

## Betriebssystem

| Anforderung | Empfehlung |
|-------------|------------|
| Edition | Windows 11 **Pro** oder Windows Server |
| Nicht | Windows 11 **Home** (vermeiden) |
| Architektur | 64-Bit |
| Updates | Aktuell, vor TOPIX-Installation |

Grund: Treiber, Firewall, Domäne/Freigaben, Stabilität.

## Hardware (Minimum sinnvoll)

| Ressource | Minimum | Besser |
|-----------|---------|--------|
| RAM | 16 GB | 32 GB |
| Systemplatte | SSD, ≥ 100 GB **frei** nach Windows | 256 GB+ frei für Daten |
| CPU | Moderne Mehrkern-CPU | — |
| USB | Stabiler Port (am besten hinten am Mainboard) | Kein wackeliger Hub für den HASP-Key |
| Netz | Gigabit-LAN zum gleichen Netzwerk wie Clients | Feste IP für den Server |

Der alte PC hatte nur ~7 GB RAM und war oft bei 100 % CPU – der neue muss klar leistungsfähiger sein.

## Netzwerk

- Gleiches LAN/VLAN wie die Arbeitsplätze.  
- Firewall: Ports für TOPIX/4D-Server freigeben (nach Installation prüfen, was der alte PC genutzt hat – oft 4D-Server-Port, ggf. in Dokumentation/Firewall-Regeln des alten PCs nachschauen).  
- Name: klarer Hostname, z.B. `TOPIX-SERVER` – Clients brauchen Host oder IP.

## Software, die du brauchst

1. **Git** + **GitHub CLI** (`gh`) – dieses Repo klonen.  
2. **TOPIX8_8602_Server.exe** – aus Staging/NAS.  
3. Optional: TOPIX8 Arbeitsplatz-Installer für Clients.  
4. Zugang zum privaten Repo (Account Bosslolo oder Einladung).

```powershell
winget install Git.Git GitHub.cli
gh auth login
git clone https://github.com/Bosslolo/topix8-migration.git
```

## Festplatten-Layout (Vorschlag)

```
C:\  Windows + Programme (TOPIX unter Program Files)
D:\  Topix\Topix Daten\     ← große Datenbank hier (viel Platz)
```

Wenn nur eine SSD: Daten z.B. `C:\Topix\Topix Daten\` – dann **sehr viel** freien Platz einplanen (≥ 50 GB frei nach Kopie der ~18 GB DB).

## Was du physisch mitnehmen musst

- [ ] Aladdin HASP USB-Schlüssel (nur zur Cutover-Zeit dauerhaft umstecken)  
- [ ] Optional: USB-Festplatte mit Staging-Kopie, falls NAS vom neuen PC schlecht erreichbar  
- [ ] Zugangsdaten NAS / `\\wdmycloud\Public` falls genutzt  

## Nicht vergessen

- Kein Betrieb als einzige Produktionsmaschine in einer VM mit USB-Passthrough.  
- Vor Cutover: kurzer HASP-Test, dann Key bis zur Ruhestunde wieder am alten Server.
