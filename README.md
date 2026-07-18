# TOPIX 8 on Windows 11 — migration notes

**Status:** Migration complete. This repo is kept only as a short record of what mattered.

The live database, license files, installers, and machine inventory were **never** meant for GitHub and are not stored here.

## Goal

Move a **TOPIX 8 Server** installation from an older Windows PC onto a **new Windows 11 Pro** machine (physical PC, not a VM), with the same Aladdin HASP USB license key, then point client workstations at the new host.

## What blocked a naive “install and copy” approach

1. **Aladdin HASP USB license key**  
   TOPIX 8 needs the physical HASP key plus working HASP device drivers. A fresh Windows 11 box often does not see the key until the TOPIX installer (and, if needed, the matching HASP drivers) are installed. The key must not run two licensed servers at once — keep it on production until cutover, with only a short test on the new PC.

2. **QuickTime 6.5 on Windows**  
   The TOPIX 8 server installer expects **Apple QuickTime 6.5.x**. Newer QuickTime builds can be rejected. Install 6.5 first, then run the TOPIX server setup.

3. **Large database outside git**  
   The live TOPIX data set is tens of gigabytes. Stage it on local disk / external drive / shared storage during cutover — never commit it.

4. **Licenses and installers offline**  
   License files and the TOPIX installer live next to the install on disk, not in this repository.

## High-level cutover

1. **Prepare the new PC** — Windows 11 Pro, enough RAM/SSD free space, stable LAN (fixed IP helps), admin access.
2. **Install prerequisites** — QuickTime 6.5, then TOPIX 8 Server (include HASP/device driver options when prompted).
3. **HASP smoke test** — Briefly move the key to the new PC, confirm Device Manager shows the HASP device healthy, then return the key to the old production PC until cutover day.
4. **Idle window** — All users out of TOPIX; stop the old server cleanly.
5. **Copy data** — Mirror the TOPIX data directory (and licenses) to the new machine via disk/staging — verify sizes.
6. **Go live** — Place data and licenses on the new PC, leave the HASP key there permanently, start TOPIX 8 Server, open the database, smoke-test login / record / print or export.
7. **Retarget clients** — Point workstations at the new hostname/IP; leave the old server off (no second licensed instance).
8. **Handover** — Daily backup to a second disk; keep the old PC untouched for a rollback window (about two weeks).

## Rollback

Stop the new server, move the HASP key back, start the old server on its original data, retarget clients.

## Outcome

TOPIX 8 Server runs on the new Windows 11 machine with HASP licensing and the migrated database. This document replaces the previous migration kit (scripts, driver dumps, and environment-specific runbooks).
