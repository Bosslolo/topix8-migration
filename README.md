# TOPIX 8 on Windows 11 — migration notes (archive)

**Status:** Migration complete. Archived public notes only.

Live databases, license files, installers, machine names, IPs, and inventory were **never** stored in this repository.

## Goal

Move a **TOPIX 8 Server** install from an older Windows PC onto a **new Windows 11 Pro** machine (physical PC, not a VM), keeping the same Aladdin HASP USB license key, then point client workstations at the new host.

## What blocked a naive “install and copy”

1. **Aladdin HASP USB license key** — needs working HASP drivers; do not run two licensed servers at once.
2. **QuickTime 6.5** — TOPIX 8 Server installer often expects Apple QuickTime **6.5.x** specifically.
3. **Large database** — tens of GB; stage on disk/external storage only — never commit.
4. **Licenses/installers** — keep offline next to the install, not in git.

## High-level cutover

1. Prepare the new PC (Windows 11 Pro, disk/RAM, stable LAN, admin access).
2. Install QuickTime 6.5, then TOPIX 8 Server (include HASP/driver options).
3. Brief HASP smoke test on the new PC, then return the key to production until cutover.
4. Idle window — users out; stop the old server cleanly.
5. Copy data + licenses to the new machine; verify sizes.
6. Go live — HASP key stays on the new PC; start server; smoke-test login/record/export.
7. Retarget clients to the new host; leave the old server off.
8. Handover — daily backup to a second disk; keep the old PC for a short rollback window.

## Rollback

Stop the new server, move the HASP key back, start the old server on its original data, retarget clients.

## Outcome

TOPIX 8 Server runs on the new Windows 11 machine with HASP licensing and the migrated database. This document replaces older migration kits (scripts, driver dumps, environment-specific runbooks).
