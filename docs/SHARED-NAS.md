# Shared transfer spot — WD My Cloud Public

Both PCs use the same NAS share for big files (never Git).

## Canonical paths

| How | Path |
|-----|------|
| UNC | `\\WDMYCLOUD\Public` or `\\192.168.18.17\Public` |
| Mapped drive (typical) | `F:\` → Public |
| Migration bundle | `\\WDMYCLOUD\Public\TOPIX-Migration-Staging\` |

If `F:` is missing on a PC:

```powershell
net use F: \\192.168.18.17\Public /user:Guest "" /persistent:yes
# If Guest fails, use the WD My Cloud username/password from the web UI.
```

Win11 note: Guest shares need insecure guest SMB allowed (already done on the new Lenovo). Old PC usually already works.

## Layout under `TOPIX-Migration-Staging`

```
TOPIX-Migration-Staging\
  installers\     TOPIX8_8602_Server.exe (+ extras if needed)
  licenses\       *.license4D
  data\           Live Topix Daten copy — ONLY after server stop / cutover
  archive-broken\ optional old *_broken.4DD archive
  HASP-Drivers\   optional exported drivers from old PC
  STAGING-MANIFEST.txt
```

## Rules

- Keep production TOPIX running on the **old** PC until cutover.
- Do **not** leave the HASP key on the new PC while the old server is still the production server (short plug-test only, then return the key).
- Database files stay on the NAS / disks — never commit to GitHub.
