# ⏰ Changing Backup Time - Quick Guide

Your backup scheduler reads the time from `backup-config.env`.

---

## 📝 Step 1: Edit backup-config.env

Open: `d:\Game\KismatX\dbbackup\backup-config.env`

Find this section:
```env
# ==================== BACKUP SCHEDULE ====================
BACKUP_SCHEDULE=0 23 * * *
```

---

## 🕐 Step 2: Change the Time

### Current Setting
```env
BACKUP_SCHEDULE=0 23 * * *    # Every day at 23:00 (11:00 PM)
```

### Common Examples

**Run at 2:00 AM**
```env
BACKUP_SCHEDULE=0 2 * * *
```

**Run at 12:00 PM (Noon)**
```env
BACKUP_SCHEDULE=0 12 * * *
```

**Run at 3:30 AM**
```env
BACKUP_SCHEDULE=30 3 * * *
```

**Run at 6:00 AM**
```env
BACKUP_SCHEDULE=0 6 * * *
```

**Run at 10:00 PM**
```env
BACKUP_SCHEDULE=0 22 * * *
```

---

## 📊 Understanding Cron Format

```
BACKUP_SCHEDULE=minute hour day month weekday
                   0    23   *   *      *
```

| Part | Value | Meaning |
|------|-------|---------|
| minute | 0 | At 0 minutes past |
| hour | 23 | At 23:00 (11 PM) |
| day | * | Every day |
| month | * | Every month |
| weekday | * | Every day of week |

---

## 🔄 Step 3: Restart Scheduler

After changing the time, restart pm2:

```bash
npm run pm2:restart
```

The new schedule will take effect immediately!

---

## ✅ Verify the Change

Check that scheduler is running:

```bash
npm run pm2:status
```

View logs to see next backup time:

```bash
npm run pm2:logs
```

---

## 🕐 More Complex Schedules

**Every 4 hours**
```env
BACKUP_SCHEDULE=0 */4 * * *
```

**Every 30 minutes**
```env
BACKUP_SCHEDULE=*/30 * * * *
```

**Every day at midnight (00:00)**
```env
BACKUP_SCHEDULE=0 0 * * *
```

**Every day at 15:45 (3:45 PM)**
```env
BACKUP_SCHEDULE=45 15 * * *
```

**Monday to Friday at 23:00**
```env
BACKUP_SCHEDULE=0 23 * * 1-5
```

**Weekends only at 02:00**
```env
BACKUP_SCHEDULE=0 2 * * 0,6
```

---

## 🔗 Cron Generator

Need help creating a custom schedule?

Visit: https://crontab.guru/

Select your desired time and paste the cron expression into `BACKUP_SCHEDULE`.

---

## 📝 Current Setup

Your current configuration:

```env
BACKUP_SCHEDULE=0 23 * * *
AUTO_DELETE_ENABLED=true
AUTO_DELETE_DAYS=2
BACKUP_RETENTION_DAYS=30
```

This means:
- ✅ Backup runs every day at 23:00
- ✅ Local files older than 2 days auto-deleted
- ✅ S3 files older than 30 days auto-deleted

---

## 🚀 Summary

1. Edit `backup-config.env`
2. Change `BACKUP_SCHEDULE=...` 
3. Run `npm run pm2:restart`
4. Done! ✅

New schedule takes effect immediately!
