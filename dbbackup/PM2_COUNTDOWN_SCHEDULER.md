# ⏰ PM2 Scheduler With Countdown - Complete Guide

## ✅ What's New

Your scheduler now:
- ✅ **Runs ONLY at 23:00** (no continuous uploads)
- ✅ **Shows live countdown** to next backup
- ✅ **Displays last backup time**
- ✅ **Updates every 5 seconds**
- ✅ **Keeps process alive** waiting for next scheduled time

---

## 📊 Display Example

```
⏰ ============== KismatX Backup Scheduler ==============

📅 Current Time: 11/25/2025, 5:27:48 PM

📋 Backup Status:
   Last Backup:  Never
   Next Backup:  11/25/2025, 11:00:00 PM
   Time Until:   5h 32m 11s

📝 Log File: ./backups/backups.log

💡 Tip: Backups run ONLY at scheduled time
   Tip: Each backup: Create → Upload → Delete Local → Clean S3

=======================================================
```

---

## 🚀 Start Scheduler With PM2

```bash
npm run pm2:start
```

**What happens:**
1. ✅ Scheduler starts
2. ✅ Shows countdown display
3. ✅ Updates every 5 seconds
4. ✅ **Waits silently** until 23:00
5. ✅ At 23:00: Creates backup, uploads, deletes local, cleans S3
6. ✅ After backup: Shows countdown to NEXT day's 23:00

---

## 📋 Check Status

```bash
npm run pm2:status
```

Shows:
```
id  │ name                      │ status    │ uptime
─   │ kismatx-backup-scheduler  │ online    │ 2h 30m
```

---

## 📝 View Live Logs

```bash
npm run pm2:logs
```

Shows:
- Countdown updates
- Last/next backup times
- Any errors

---

## 🛑 Stop Scheduler

```bash
npm run pm2:stop
```

---

## 🔄 Restart Scheduler

```bash
npm run pm2:restart
```

Use after changing backup time in `backup-config.env`

---

## 🕐 Change Backup Time

Edit `backup-config.env`:

```env
BACKUP_SCHEDULE=0 23 * * *        # Current: 23:00 daily
# Change to:
BACKUP_SCHEDULE=0 2 * * *         # 2:00 AM daily
```

Then restart:
```bash
npm run pm2:restart
```

Countdown will immediately update to show new time!

---

## 📊 How Scheduler Works Now

```
START (pm2 start)
    ↓
Display countdown with:
  - Current time
  - Last backup time
  - Next backup time
  - Time remaining
    ↓
WAIT silently (no uploads) every 5 seconds refresh
    ↓
When scheduled time arrives (23:00):
  - Create backup
  - Upload to S3
  - Delete local file
  - Delete old S3 files
  - Log success
    ↓
Show updated countdown to NEXT 23:00
    ↓
REPEAT forever
```

---

## ✅ Key Features

| Feature | Before | After |
|---------|--------|-------|
| **Continuous uploads** | ❌ Yes (bad) | ✅ No (fixed) |
| **Runs at exact time** | ❌ No | ✅ Yes (23:00) |
| **Countdown display** | ❌ No | ✅ Yes |
| **Shows next backup** | ❌ No | ✅ Yes |
| **Live updates** | ❌ No | ✅ Every 5 seconds |
| **No wasted uploads** | ❌ No | ✅ Yes |

---

## 🧪 Test It

Start scheduler:
```bash
npm run pm2:start
```

Check status:
```bash
npm run pm2:status
```

View countdown:
```bash
npm run pm2:logs
```

You'll see:
```
⏰ ============== KismatX Backup Scheduler ==============

📅 Current Time: 11/25/2025, 5:27:48 PM

📋 Backup Status:
   Last Backup:  Never
   Next Backup:  11/25/2025, 11:00:00 PM
   Time Until:   5h 32m 11s
```

---

## 📋 All PM2 Commands

```bash
# Start
npm run pm2:start

# Check status
npm run pm2:status

# View logs/countdown
npm run pm2:logs

# Restart (after config changes)
npm run pm2:restart

# Stop
npm run pm2:stop

# Delete (stop + remove)
npm run pm2:delete
```

---

## 🎯 Current Configuration

**File:** `backup-config.env`

```env
BACKUP_SCHEDULE=0 23 * * *        # Daily at 23:00 ONLY
BACKUP_RETENTION_DAYS=2           # Delete S3 files after 2 days
AUTO_DELETE_ENABLED=true          # Delete local immediately
```

---

## 🚀 Summary

**Before:** Continuous uploads, no control

**Now:**
- ✅ Runs ONLY at 23:00
- ✅ Shows live countdown
- ✅ Display updates every 5 seconds
- ✅ Shows last/next backup times
- ✅ No wasted uploads or processing

**Start it:**
```bash
npm run pm2:start
```

**That's it!** Your backup now runs exactly once per day at 23:00 with countdown display! 🎉
