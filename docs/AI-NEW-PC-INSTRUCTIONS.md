# AI instructions — NEW PC (software only)

**Audience:** Cursor / AI agent on the replacement Lenovo (this machine once staging media arrives).  
**Repo:** already cloned at e.g. `C:\Users\Topix-ThinkCentr\Projects\topix8-migration`

## Do NOT do (human / physical)

- Do **not** unplug the HASP key from production until staging is verified and the human starts cutover.
- Do **not** throw away rollback: keep old PC + original data untouched for ≥2 weeks.

## When staging folder is available

Assume staging root is something like `F:\TOPIX-Migration-Staging` on a share, or `E:\TOPIX-Migration-Staging` on USB. Call it `$Staging`.

### 1) Copy staging onto local SSD

```powershell
$Staging = '<UNC-or-USB>\TOPIX-Migration-Staging'
$Local = 'C:\TOPIX-Migration-Staging'
New-Item -ItemType Directory -Force -Path $Local | Out-Null
robocopy $Staging $Local /E /COPY:DAT /R:2 /W:5 /MT:8 /NP
Get-Content (Join-Path $Local 'STAGING-MANIFEST.txt')
```

### 2) Install TOPIX8 Server

```powershell
Start-Process (Join-Path $Local 'Installers\TOPIX8_8602_Server.exe') -Wait
```

Include HASP / device driver components if the installer asks. Reboot if prompted.

### 3) Optional: install exported HASP drivers

```powershell
Get-ChildItem (Join-Path $Local 'HASP-Drivers') -Recurse -Filter '*.inf' | ForEach-Object {
  pnputil /add-driver $_.FullName /install
}
```

### 4) Place data + licenses

```powershell
$Data = 'C:\Topix\Topix Daten'
$Lic  = 'C:\Program Files (x86)\TOPIX\TOPIX8 Server\Licenses'
New-Item -ItemType Directory -Force -Path $Data, $Lic | Out-Null
robocopy (Join-Path $Local 'Topix Daten') $Data /E /COPY:DAT /R:2 /W:5 /MT:8 /NP
Copy-Item (Join-Path $Local 'Licenses\*') $Lic -Force
```

### 5) Human plugs HASP → you verify

```powershell
cd <repo>
.\scripts\check-hasp.ps1
```

### 6) Open data in TOPIX8 Server

Use the Server UI to open `$Data` with structure `TOPIX8.4DC`. Smoke-test after human confirms key is present.

### 7) Clients + firewall

- Install Arbeitsplatz from staging installers if present.
- Point clients at this PC’s hostname/IP.
- Open the same TOPIX/4D ports documented in inventory / old firewall rules.

Deutsche Gesamtanleitung: [00-UMZUG-GESAMT.md](00-UMZUG-GESAMT.md) · Installation: [04-INSTALLATION-NEUER-PC.md](04-INSTALLATION-NEUER-PC.md) · HASP: [02-HASP-USB-SCHLUESSEL.md](02-HASP-USB-SCHLUESSEL.md) · Checkliste: [06-CHECKLISTE.md](06-CHECKLISTE.md)
