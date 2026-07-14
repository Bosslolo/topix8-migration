# Aladdin HASP USB license key (TOPIX 8)

## What it is

- Hardware license dongle: **Aladdin HASP** / SafeNet family
- USB ID observed on production: `VID_0529` `PID_0001`
- Device Manager names when working:
  - **Aladdin USB Key**
  - **Aladdin HASP Key**
- Windows component: **HASP Gerätetreiber**

## Why a fresh Windows 11 PC “does not see” the key

1. HASP is a **driver-backed** device, not mass storage.
2. Without the HASP runtime/drivers, Windows cannot bind the correct device class.
3. Drivers on the production machine are very old (file dates ~2006). Clean Win11 + Secure Boot may need the drivers bundled by the TOPIX installer, or a newer Sentinel/HASP runtime from the vendor path TOPIX used.
4. Plugging the key in before drivers does not “activate” detection.

## What works on the current (old) PC

Confirmed present and OK:

- `Aladdin HASP Key`
- `Aladdin USB Key` (`USB\VID_0529&PID_0001\...`)
- Drivers under `C:\Windows\System32\drivers\`:
  - `aksclass.sys`, `akshasp.sys`, `aksusb.sys`, `hardlock.sys` (dated 2006)

## Procedure for the new PC

### A. Preferred

1. Install **TOPIX8 Server** from `TOPIX8_8602_Server.exe` (ensure HASP/device driver option is included if the installer asks — historically “HASP Gerätetreiber” / Everything).
2. Reboot if prompted.
3. Plug in the HASP key.
4. Open Device Manager → verify Aladdin HASP entries are healthy (no yellow bang).
5. Start TOPIX8 Server and open the migrated data folder.

### B. If still not detected

1. On the old PC (while key still works): Device Manager → Aladdin device → Properties → Driver → **Driver Details** / export via `pnputil` if available.
2. Copy any HASP installer found under TOPIX install media / Zusätze.
3. Install on new PC **before** expecting recognition.
4. Try another USB port (rear motherboard port, USB 2.0 if available).
5. Temporarily disable unused USB hubs; avoid front-panel-only ports if unstable.

### C. If drivers install but TOPIX still unlicensed

- Copy `Licenses\*.license4D` from the old `TOPIX8 Server` folder into the new install’s `Licenses` folder.
- Confirm only one machine holds the key at a time.

## Do not

- Throw away or overwrite the key.
- Leave the key on a VM USB passthrough as the primary plan (fragile; not used for this migration).
- Unplug from production during the day until a verified backup exists.

## Modern TOPIX note

Current TOPIX versions often use online licensing. TOPIX 8 is legacy USB-HASP. If Win11 blocks old HASP drivers permanently, ask TOPIX support about license migration before the old PC dies.
