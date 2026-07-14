# 05 – Clients (Arbeitsplätze) umstellen

## Was Clients brauchen

- TOPIX8 **Arbeitsplatz** (Rich Client), installiert von:
  - `TOPIX8_8500_Arbeitsplatz.exe` oder passende Version aus `E:\Topix Programme\`
- Netzwerkzugriff auf den **neuen** Server (Hostname oder IP)
- Kein HASP-Key am Client (der Key gehört an den Server)

## Umstellung

1. Notiere die alte Server-Adresse (Hostname/IP), die bisher funktioniert hat.  
2. Nach Cutover: in der Arbeitsplatz-Verbindung den **neuen** Host/IP eintragen.  
3. Test von einem Client: Login + öffnen eines Datensatzes.  
4. Danach restliche Clients.

## Tipps

- DNS/Hostname ändern oder feste IP am neuen Server – Clients möglichst eine stabile Adresse nutzen.  
- Windows-Firewall am Server muss Client-Verbindungen erlauben.  
- Wenn Terminalserver/RDP genutzt wird: Session auf den neuen Host richten (falls zutreffend).  
- Alte Server-IP nach Umstellung nicht weiter befüllen, sonst verwirrt das.

## Falls Client die alte Version nicht findet

- Arbeitsplatz-Installer vom Staging / `E:\Topix Programme\Installationsprogramme\` neu installieren.  
- Versionsstand zum Server passend halten (TOPIX8 / 8.6.x-Familie).

## Mehrplatz

Nur **ein** TOPIX8 Server mit dem HASP-Key. Alle Arbeitsplätze zeigen auf diesen einen Host.
