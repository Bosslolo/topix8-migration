# New PC checklist

Physical PC only (no VM). Software steps for an agent: [AI-NEW-PC-INSTRUCTIONS.md](AI-NEW-PC-INSTRUCTIONS.md).

- [ ] Windows 11 Pro installed and updated
- [ ] Clone repo: `git clone https://github.com/Bosslolo/topix8-migration.git`
- [ ] Copy staged data from external disk / `F:\TOPIX-Migration-Staging` (see `STAGING-MANIFEST.txt`)
- [ ] Install `TOPIX8_8602_Server.exe` (include HASP drivers)
- [ ] Optional: install exported drivers from staging `HASP-Drivers\`
- [ ] Run `.\scripts\check-hasp.ps1` after plugging USB key
- [ ] Copy `Licenses\*.license4D` into Server Licenses folder
- [ ] Restore `Topix Daten` to a stable local path; open in TOPIX8 Server
- [ ] Install Arbeitsplatz; connect clients
- [ ] Configure daily backup to a second drive
- [ ] Keep old PC as rollback for 2+ weeks
