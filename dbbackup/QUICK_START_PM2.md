# 🚀 PM2 Auto-Backup - Get Started Now!

Your backup system is **fully configured and ready to run**.

---

## ⚡ Quick Start (Copy & Paste)

### Step 1: Install PM2 (one-time, first time only)

```bash
npm install -g pm2
```

### Step 2: Start Automatic Backups

```bash
cd d:\Game\KismatX\dbbackup
npm run pm2:start
```

### Step 3: Verify It's Running

```bash
npm run pm2:status
```

**DONE!** ✅ Your backup now runs every night at **23:00 (11:00 PM)**

---

## 📊 What You Just Set Up

```
Backup Scheduler: ACTIVE ✅
├─ Database: KismatX (localhost:3306)
├─ Schedule: Every night at 23:00
├─ Backup to: ./backups/ (local)
├─ Upload to: s3://yantra-dbbackup/kmx/
├─ Auto-delete: Old files after 2 days
└─ Logs: ./backups/backups.log
```

---

## 🕐 Change Backup Time

Want backup at different time? Edit `backup-config.env`:

**Find:**
```env
BACKUP_SCHEDULE=0 23 * * *
```

**Change to one of these:**
```env
BACKUP_SCHEDULE=0 2 * * *     # 2:00 AM
BACKUP_SCHEDULE=0 6 * * *     # 6:00 AM
BACKUP_SCHEDULE=0 12 * * *    # 12:00 PM
BACKUP_SCHEDULE=0 18 * * *    # 6:00 PM
```

**Restart:**
```bash
npm run pm2:restart
```

---

## 📋 Essential Commands

```bash
# View status
npm run pm2:status

# View live logs
npm run pm2:logs

# Stop scheduler
npm run pm2:stop

# Restart (after config changes)
npm run pm2:restart

# Delete scheduler
npm run pm2:delete
```

---

## 🧪 Test It Works (Before Going Live)

Run manual backup:
```bash
npm run backup
```

Should show:
```
✅ Database connection verified
✅ Database dump created (2.84 MB)
✅ Backup uploaded to S3
✅ Auto-delete check passed
```

If manual backup works → scheduler will work! ✅

---

## 📁 Current Configuration

**File:** `backup-config.env`

```env
# Time for automatic backup
BACKUP_SCHEDULE=0 23 * * *        # 23:00 daily

# Local backup location
BACKUP_FOLDER_PATH=./backups       # Created automatically

# Auto-delete old files
AUTO_DELETE_ENABLED=true
AUTO_DELETE_DAYS=2                 # Delete after 2 days

# S3 settings
AWS_S3_BUCKET=yantra-dbbackup
AWS_REGION=ap-south-1

# Cloud retention
BACKUP_RETENTION_DAYS=30           # Keep 30 days in S3

# Logging
LOG_FILE_PATH=./backups/backups.log
```

---

## 🔄 How It Works (Automatic)

Every night at configured time:

```
23:00 ⏰ Scheduler triggers
  ├─ 🔍 Connect to KismatX database
  ├─ 📦 Create SQL dump (~2.84 MB)
  ├─ ☁️  Upload to S3 (yantra-dbbackup/kmx/)
  ├─ 🧹 Delete local files older than 2 days
  └─ 📝 Log completion to ./backups/backups.log
```

Everything automatic, no manual work! ✅

---

## ✨ Next Steps

1. **Run:** `npm run pm2:start`
2. **Check:** `npm run pm2:status` (should show "online")
3. **Monitor:** `npm run pm2:logs` (view activity)
4. **Done!** Backups run automatically every night

---

## 🎯 Your Backup is Now:

✅ **Automatic** - Runs on schedule, no manual action  
✅ **Monitored** - PM2 watches process, auto-restarts if crashes  
✅ **Logged** - All activity recorded in ./backups/backups.log  
✅ **Portable** - Works on any server/host  
✅ **Configurable** - Change time in backup-config.env  

---

## 📞 Quick Help

| Need? | Command |
|-------|---------|
| Start scheduler | `npm run pm2:start` |
| Check status | `npm run pm2:status` |
| View logs | `npm run pm2:logs` |
| Change time | Edit backup-config.env, then `npm run pm2:restart` |
| Stop scheduler | `npm run pm2:stop` |
| Restart | `npm run pm2:restart` |
| Manual backup | `npm run backup` |

---

## 🚀 YOU'RE ALL SET!

```bash
npm run pm2:start
```

**Your backup system is live!** 🎉

Every night at 23:00:
- Database backed up ✅
- Uploaded to S3 ✅
- Old files cleaned up ✅
- All logged ✅

No more manual backups needed! 🎊
