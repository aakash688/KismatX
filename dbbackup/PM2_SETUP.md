# 🚀 PM2 Setup - Automatic Backup Scheduling

Your backup scheduler will run automatically every night at the time configured in `backup-config.env`.

---

## 📋 Prerequisites

Make sure pm2 is installed globally:

```bash
npm install -g pm2
```

---

## 🎯 How It Works

1. **Configure backup time** in `backup-config.env`:
   ```env
   BACKUP_SCHEDULE=0 23 * * *
   ```
   This means: Every day at 23:00 (11:00 PM)

2. **Start scheduler with pm2**:
   ```bash
   npm run pm2:start
   ```

3. **Scheduler runs automatically** every night and:
   - ✅ Connects to database
   - ✅ Creates backup dump
   - ✅ Uploads to S3
   - ✅ Deletes old local files (if enabled)
   - ✅ Logs all activity

---

## 🔧 PM2 Commands

### Start Scheduler
```bash
npm run pm2:start
```

### View Scheduler Status
```bash
npm run pm2:status
```

### View Live Logs
```bash
npm run pm2:logs
```

### Restart Scheduler
```bash
npm run pm2:restart
```

### Stop Scheduler
```bash
npm run pm2:stop
```

### Remove Scheduler (stops + deletes)
```bash
npm run pm2:delete
```

---

## 🕐 Change Backup Time

Edit `backup-config.env` and change `BACKUP_SCHEDULE`:

```env
# Current (11:00 PM every day)
BACKUP_SCHEDULE=0 23 * * *

# To run at 2:00 AM every day
BACKUP_SCHEDULE=0 2 * * *

# To run at 12:00 PM (noon) every day
BACKUP_SCHEDULE=0 12 * * *

# To run every 4 hours
BACKUP_SCHEDULE=0 */4 * * *

# To run at 3:30 AM every day
BACKUP_SCHEDULE=30 3 * * *
```

After changing the time:

```bash
npm run pm2:restart
```

---

## 📊 Cron Schedule Reference

Format: `minute hour day month weekday`

| Schedule | Meaning |
|----------|---------|
| `0 23 * * *` | Daily at 23:00 (11:00 PM) |
| `0 2 * * *` | Daily at 02:00 (2:00 AM) |
| `0 12 * * *` | Daily at 12:00 (noon) |
| `0 0 * * 0` | Every Sunday at midnight |
| `0 */6 * * *` | Every 6 hours |
| `*/30 * * * *` | Every 30 minutes |
| `30 3 * * *` | Daily at 03:30 (3:30 AM) |
| `0 23 * * 1-5` | Weekdays at 23:00 (Mon-Fri) |

Reference: https://crontab.guru/

---

## 📝 Logs

All backups are logged to: `./backups/backups.log`

View logs with:
```bash
npm run pm2:logs
```

Or manually:
```bash
tail -f ./backups/backups.log
```

---

## 🔄 Auto-Restart on Server Reboot

To make pm2 restart on server reboot:

```bash
pm2 startup
pm2 save
```

This will:
- Auto-start scheduler when server boots
- Restore the same apps that were running before reboot

---

## 📊 Current Configuration

Your backup is configured as:

```
Scheduler Process: kismatx-backup-scheduler
Schedule: 0 23 * * * (Every night at 23:00)
Database: KismatX (localhost:3306)
Backup Location: ./backups/
S3 Bucket: yantra-dbbackup
S3 Path: kmx/
Auto-Delete: Enabled (2 days)
S3 Retention: 30 days
Logs: ./backups/backups.log
```

---

## 🧪 Test Scheduler (Without Waiting)

Run a manual backup anytime:
```bash
npm run backup
```

This helps verify everything is working before starting pm2.

---

## ✨ Start Scheduler

When ready, start with:

```bash
npm run pm2:start
```

Then check status:

```bash
npm run pm2:status
```

You should see:
```
id  │ name                      │ namespace   │ version │ mode    │ pid      │ uptime │ ↺    │ status    │
─   │ kismatx-backup-scheduler  │ default     │ 1.0.0   │ fork    │ 12345   │ 5s    │ 0    │ online    │
```

✅ Now backups will run automatically every night at 23:00!

---

## 🛠️ Troubleshooting

### Scheduler not starting?
```bash
npm run pm2:logs
```

### Check if pm2 is running?
```bash
pm2 list
```

### Restart after config changes?
```bash
npm run pm2:restart
```

### Reset everything and start fresh?
```bash
npm run pm2:delete
npm run pm2:start
```

---

## 📞 Need Help?

1. Check logs: `npm run pm2:logs`
2. Verify config: `cat backup-config.env`
3. Test manual backup: `npm run backup`
4. Check status: `npm run pm2:status`
