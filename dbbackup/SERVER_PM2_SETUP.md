# 🚀 PM2 Backup Scheduler - Server Setup

## Your Server Environment

Based on your PM2 list, you have:
- ✅ PM2 already running on Linux server
- ✅ `backend` process (id: 0)
- ✅ `adminpanel` process (id: 1)
- ⏳ `dbbackup` (just deleted, ready for new one)

---

## ✅ Start Backup Scheduler on Server

### Option 1: Using npm script (Recommended)
```bash
cd ~/KismatX/dbbackup
npm run pm2:start
```

This will start with the name: `kismatx-backup-scheduler`

### Option 2: Using ecosystem config directly
```bash
cd ~/KismatX/dbbackup
pm2 start ecosystem.config.js
```

Same result, same process name.

---

## 🔍 Verify It Started

```bash
pm2 status
```

You should see:
```
┌────┬──────────────────────────┬─────────────┬─────────┬─────────┬──────────┬────────┬──────┬───────────┬──────────┬──────────┬──────────┬──────────┐
│ id │ name                     │ namespace   │ version │ mode    │ pid      │ uptime │ ↺    │ status    │ cpu      │ mem      │ user     │ watching │
├────┼──────────────────────────┼─────────────┼─────────┼─────────┼──────────┼────────┼──────┼───────────┼──────────┼──────────┼──────────┼──────────┤
│ 0  │ backend                  │ default     │ N/A     │ fork    │ 134014   │ 76m    │ 0    │ online    │ 0%       │ 67.2mb   │ admin    │ disabled │
│ 1  │ adminpanel               │ default     │ N/A     │ fork    │ 134060   │ 76m    │ 0    │ online    │ 0%       │ 66.8mb   │ admin    │ disabled │
│ 2  │ kismatx-backup-scheduler │ default     │ N/A     │ fork    │ XXXXX    │ 1s     │ 0    │ online    │ 0%       │ 35.2mb   │ admin    │ disabled │
└────┴──────────────────────────┴─────────────┴─────────┴─────────┴──────────┴────────┴──────┴───────────┴──────────┴──────────┴──────────┴──────────┘
```

---

## 📊 Commands on Server

```bash
# View status (all processes)
pm2 status

# View countdown/logs for backup scheduler
pm2 logs kismatx-backup-scheduler

# View only errors
pm2 logs kismatx-backup-scheduler --err

# Stop backup scheduler
pm2 stop kismatx-backup-scheduler

# Restart backup scheduler
pm2 restart kismatx-backup-scheduler

# Delete backup scheduler
pm2 delete kismatx-backup-scheduler

# Restart ALL processes (backend, adminpanel, backup)
pm2 restart all

# Save PM2 config (for auto-start on reboot)
pm2 save
```

---

## 🎯 Quick Start on Server

```bash
# Navigate to backup folder
cd ~/KismatX/dbbackup

# Start scheduler with PM2
npm run pm2:start

# Verify it's running
pm2 status

# View the countdown display
pm2 logs kismatx-backup-scheduler
```

---

## ✅ What Your Backup Does

Every day at **23:00**:

1. ✅ Connect to KismatX database
2. ✅ Create SQL dump (~4.34 MB)
3. ✅ Upload to S3 (yantra-dbbackup/kmx/)
4. ✅ Delete local file immediately
5. ✅ Delete old S3 files (older than 2 days)
6. ✅ Log everything

**Rest of the day:** Shows countdown to next backup (updates every 5 minutes)

---

## 📁 Process Name

- **Name:** `kismatx-backup-scheduler`
- **Script:** `scheduler.js`
- **Mode:** fork (single process)
- **Auto-restart:** Yes (if crashes)
- **Logs:** `./logs/scheduler-error.log`, `./logs/scheduler-out.log`

---

## 🔄 Auto-start on Server Reboot

After starting, run:
```bash
pm2 save
pm2 startup
```

This makes PM2 auto-start all processes (backend, adminpanel, backup) on server reboot.

---

## 🚀 Start It Now

```bash
cd ~/KismatX/dbbackup
npm run pm2:start
```

Then check:
```bash
pm2 status
pm2 logs kismatx-backup-scheduler
```

Your backup is now running! 🎉
