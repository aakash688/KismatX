# ✅ Complete PM2 Setup & Auto-Backup Guide

Your KismatX database will now automatically backup every night using PM2.

---

## 🎯 What's Configured

| Setting | Value |
|---------|-------|
| **Backup Time** | 23:00 (11:00 PM) daily |
| **Database** | KismatX (localhost:3306) |
| **Backup Location** | ./backups/ (local) |
| **S3 Bucket** | yantra-dbbackup |
| **S3 Path** | kmx/ |
| **Auto-Delete** | Enabled (2 days) |
| **S3 Retention** | 30 days |
| **Process Manager** | PM2 |
| **Logs** | ./backups/backups.log |

---

## 🚀 Quick Start (3 Steps)

### Step 1: Install PM2 (One-time)

```bash
npm install -g pm2
```

### Step 2: Start Backup Scheduler

```bash
cd d:\Game\KismatX\dbbackup
npm run pm2:start
```

### Step 3: Verify It's Running

```bash
npm run pm2:status
```

**That's it!** ✅ Your backup now runs automatically every night at 23:00

---

## 📝 All PM2 Commands

```bash
# Start scheduler
npm run pm2:start

# View status
npm run pm2:status

# View live logs
npm run pm2:logs

# Restart (after config changes)
npm run pm2:restart

# Stop scheduler
npm run pm2:stop

# Delete scheduler
npm run pm2:delete
```

---

## 🕐 Change Backup Time

Edit `backup-config.env`:

```env
# Current: 23:00 (11:00 PM)
BACKUP_SCHEDULE=0 23 * * *

# Change to 2:00 AM
BACKUP_SCHEDULE=0 2 * * *
```

Then restart:
```bash
npm run pm2:restart
```

**Common Times:**
- `0 2 * * *` → 2:00 AM
- `0 6 * * *` → 6:00 AM
- `0 12 * * *` → 12:00 PM (noon)
- `0 22 * * *` → 10:00 PM

See `CHANGE_BACKUP_TIME.md` for more options.

---

## 📊 What Happens Every Night

At configured time (default 23:00):

```
1. 🔍 Connect to database
   └─ Verify MySQL connection
   
2. 📦 Create backup
   └─ Export all tables & data to SQL file (~2.84 MB)
   
3. ☁️  Upload to S3
   └─ Upload to: s3://yantra-dbbackup/kmx/KismatX_YYYY-MM-DD_*.sql
   
4. 🧹 Auto-delete old files
   └─ Delete local files older than 2 days (saves disk)
   
5. 📝 Log completion
   └─ Write to: ./backups/backups.log
```

All automated, no manual intervention needed! ✅

---

## 🔍 Monitor Scheduler

### View Live Logs
```bash
npm run pm2:logs
```

### View All Status
```bash
npm run pm2:status
```

### View Error Logs
```bash
tail -f ./logs/scheduler-error.log
```

### View Output Logs
```bash
tail -f ./logs/scheduler-out.log
```

---

## 🧪 Test Before Going Live

Run a manual backup to verify everything works:

```bash
npm run backup
```

Should see:
```
✅ Database connection verified
✅ Database dump created (2.84 MB)
✅ Backup uploaded to S3
✅ Auto-delete check passed
```

If this works, the scheduler will work too! ✅

---

## 🔧 Environment Variables

All settings in `backup-config.env`:

```env
# AWS
AWS_REGION=ap-south-1
AWS_ACCESS_KEY_ID=AKIAS6YWJ4L5TA2V2ZED
AWS_SECRET_ACCESS_KEY=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
AWS_S3_BUCKET=yantra-dbbackup

# Backup
BACKUP_FOLDER_PATH=./backups
BACKUP_SCHEDULE=0 23 * * *

# Cleanup
AUTO_DELETE_ENABLED=true
AUTO_DELETE_DAYS=2
BACKUP_RETENTION_DAYS=30

# Logging
LOG_FILE_PATH=./backups/backups.log
DEBUG_MODE=false
```

Change any setting and restart:
```bash
npm run pm2:restart
```

---

## 💾 Files Involved

```
dbbackup/
├── backup-config.env          ← All settings (edit this!)
├── ecosystem.config.js        ← PM2 configuration
├── scheduler.js               ← Runs backups at scheduled time
├── backup.js                  ← Manual backup
├── db-manager.js              ← Database operations
├── s3-manager.js              ← S3 upload/download
├── package.json               ← NPM scripts
├── backups/                   ← Local backup files
│   └── backups.log           ← Backup activity log
└── logs/                      ← PM2 logs
    ├── scheduler-error.log
    └── scheduler-out.log
```

---

## 🔄 Auto-Restart on Server Reboot

To make scheduler restart when server boots:

```bash
pm2 startup
pm2 save
```

This ensures backups continue even if server reboots!

---

## ✨ Your Backup System is Ready!

```bash
npm run pm2:start
```

Then:
- ✅ Every night at 23:00: Automatic backup
- ✅ Database exported to SQL file
- ✅ Uploaded to S3 bucket
- ✅ Old files auto-cleaned
- ✅ Everything logged

**No manual intervention needed!** 🎉

---

## 📞 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| Scheduler not starting | `npm run pm2:logs` |
| Want to check status | `npm run pm2:status` |
| Changed config | `npm run pm2:restart` |
| Need to stop | `npm run pm2:stop` |
| View live backup log | `npm run pm2:logs` |
| Test manual backup | `npm run backup` |

---

## 📚 More Information

- **Change Backup Time:** See `CHANGE_BACKUP_TIME.md`
- **Detailed PM2 Guide:** See `PM2_SETUP.md`
- **Backup Concepts:** See `CONFIGURATION_GUIDE.md`
- **Manual Backup:** See `MANUAL_BACKUP_GUIDE.md`

---

## 🎯 Summary

**Before (Manual):** You had to run `npm run backup` every time

**Now (Automatic):** 
```bash
npm run pm2:start
```
✅ Done! Backup runs every night automatically

Your backup is complete and production-ready! 🚀
