# KismatX Database Backup Application

Complete automated database backup solution with AWS S3 integration, scheduled backups, local auto-delete, and restore capabilities.

## ✨ Features

- **Automated Backups** - Schedule backups on any cron schedule (daily, hourly, every 15 minutes, etc.)
- **AWS S3 Integration** - Securely upload backups to AWS S3 cloud storage
- **Auto-Delete Old Backups** - Automatically delete local backup files older than N days
- **Configurable Schedule** - Set backup timing via environment variables (no code changes needed)
- **Restore Capability** - Interactive wizard to download and prepare restoration from S3
- **Local Backup Path** - Configure where backups are stored locally before S3 upload
- **Logging** - Automatic logging of all backup operations
- **Cross-Platform** - Works on Windows, Linux, and macOS

## 🚀 Quick Start

### 1. Install Dependencies
```bash
cd dbbackup
npm install
```

### 2. Run Interactive Setup
```bash
npm run setup
```

You'll be prompted for:
- ✅ AWS Region (e.g., us-east-1)
- ✅ AWS Access Key ID
- ✅ AWS Secret Access Key
- ✅ S3 Bucket Name
- ✅ **Local backup folder path** (e.g., C:\KismatX\backups)
- ✅ **Backup schedule** (cron format or preset)
- ✅ **Auto-delete settings** (enable and days to keep)
- ✅ S3 retention period

### 3. Test Your First Backup
```bash
npm run backup
```

### 4. Start Automatic Scheduling (Optional)
```bash
npm run backup:schedule
```

## 📋 Configuration

All settings are saved in `backup-config.env`:

```env
# AWS Credentials
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_S3_BUCKET=your-bucket-name

# Backup Folder Path
BACKUP_FOLDER_PATH=C:\KismatX\backups

# Schedule (Cron Format)
BACKUP_SCHEDULE=0 2 * * *

# Auto-Delete Old Files
AUTO_DELETE_ENABLED=true
AUTO_DELETE_DAYS=2

# S3 Retention
BACKUP_RETENTION_DAYS=30

# Logging
LOG_FILE_PATH=C:\KismatX\backups\backups.log
DEBUG_MODE=false
```

## 📚 Available Commands

### Create Manual Backup
```bash
npm run backup
```
Creates a database dump and uploads to S3.

**With cleanup:**
```bash
npm run backup -- --cleanup
```
Deletes the local backup file after S3 upload.

### Schedule Automatic Backups
```bash
npm run backup:schedule
```
Starts background scheduler. Runs continuously until stopped (Ctrl+C).

Executes backups based on `BACKUP_SCHEDULE` in `backup-config.env`.

**With auto-cleanup:**
```bash
npm run backup:schedule -- --cleanup
```

### Restore from S3
```bash
npm run restore
```
Interactive wizard to:
1. List all backups in S3
2. Select a backup to download
3. Download to local folder
4. Show next steps for database import

### Re-configure Settings
```bash
npm run setup
```
Re-run the interactive setup wizard anytime.

## 🛠️ File Structure

```
dbbackup/
├── backup.js                  # Main backup script
├── setup.js                   # Interactive setup wizard
├── restore.js                 # Interactive restore wizard
├── scheduler.js               # Cron-based scheduler
├── config.js                  # Configuration manager
├── db-manager.js              # Database operations
├── s3-manager.js              # AWS S3 operations
├── backup-config.env          # Auto-generated config (SECRET!)
├── backup-config.env.example  # Config template
├── package.json               # Dependencies
├── .gitignore                 # Protects secrets from git
├── README.md                  # This file
├── INSTALLATION_GUIDE.md      # Detailed setup guide
└── QUICK_REFERENCE.txt        # Command reference
```

## ⏰ Backup Schedules

### Preset Schedules
| Description | Cron | Usage |
|---|---|---|
| Every day at 2 AM | `0 2 * * *` | Daily overnight |
| Every day at midnight | `0 0 * * *` | Daily at start of day |
| Every 4 hours | `0 */4 * * *` | Frequent backups |
| Every Sunday at midnight | `0 0 * * 0` | Weekly |
| 1st of month at midnight | `0 0 1 * *` | Monthly |
| Every 15 minutes | `*/15 * * * *` | Very frequent |

### Custom Schedules
Edit `BACKUP_SCHEDULE` in `backup-config.env` with any valid cron format.

**Cron format:** `minute hour day month weekday`
- **minute**: 0-59
- **hour**: 0-23
- **day**: 1-31
- **month**: 1-12
- **weekday**: 0-6 (0=Sunday)

Use [crontab.guru](https://crontab.guru/) for help building cron expressions.

## 🗂️ Backup Folder Path

The `BACKUP_FOLDER_PATH` variable controls where backups are stored locally:

### Windows
```
C:\KismatX\backups
D:\Backups\Database
```

### Linux
```
/var/backups/kismatx
/home/user/kismatx-backups
```

### macOS
```
~/KismatX/backups
/Volumes/External/kismatx
```

All backups are saved with format: `KismatX_YYYY-MM-DD_timestamp.sql`

## 🗑️ Auto-Delete Old Backups

When `AUTO_DELETE_ENABLED=true` in `backup-config.env`:

- Local backup files older than `AUTO_DELETE_DAYS` are automatically deleted
- Keeps disk space clean since backups are already in S3
- Deletion happens automatically during each backup operation
- Only deletes `.sql` files in the backup folder

### Example
If `AUTO_DELETE_DAYS=2`:
- Day 1: Backup created
- Day 2: Backup created
- Day 3: Day 1's backup automatically deleted

## 💾 S3 Storage Organization

Backups are organized by date in S3:

```
s3://your-bucket/backups/
├── 2024/
│   ├── 11/
│   │   ├── KismatX_2024-11-25_1734010800000.sql
│   │   ├── KismatX_2024-11-24_1733924400000.sql
│   └── 10/
│       └── KismatX_2024-10-31_1730372400000.sql
└── 2023/
```

## 🔄 Restore Process

### From S3 (Easiest)
```bash
npm run restore
```

The wizard will:
1. Show list of all available backups
2. Let you select which backup to restore
3. Download to your local folder
4. Show the next steps

### Manual Restore
```bash
mysql -u root KismatX < backup.sql
```

## 📊 Logging

Automatic logs are saved to `LOG_FILE_PATH`:

```
[2024-11-25T14:30:00.000Z] Backup started
[2024-11-25T14:30:15.000Z] ✅ Backup successful | Size: 125.50MB | S3: backups/2024/11/KismatX_2024-11-25_1734010800000.sql
```

Enable `DEBUG_MODE=true` for detailed logging.

## 🔐 Security Best Practices

### 1. Protect `backup-config.env`
```bash
# This file is in .gitignore
# Never commit credentials to git
# Restrict file permissions (Linux/macOS)
chmod 600 backup-config.env
```

### 2. Rotate AWS Credentials
- Use IAM users with minimal S3 permissions
- Rotate credentials every 90 days
- Use bucket encryption for S3

### 3. Environment-Specific Setup
- Use different S3 buckets per environment
- Maintain separate AWS credentials
- Test restore procedures regularly

## 🐛 Troubleshooting

### Error: "mysqldump not found"
**Solution:** Install MySQL Client:
- **Windows:** Download MySQL Community Server (includes client tools)
- **Linux:** `apt install mysql-client`
- **macOS:** `brew install mysql-client`

### Error: "AWS credentials incomplete"
**Solution:** Run setup again:
```bash
npm run setup
```

### Error: "Cannot create or access directory"
**Solution:** Ensure backup folder path is writable:
- Check folder exists
- Verify user permissions
- Ensure sufficient disk space

### Error: "S3 upload failed"
**Solution:** Verify AWS configuration:
- Check AWS credentials are correct
- Verify bucket exists and name is exact
- Confirm IAM user has S3 write permissions

### Backup takes too long
**Solution:** Check database size and network speed:
- Large databases take longer to dump
- Slow internet affects S3 upload
- Consider scheduling during off-hours

## 📖 Full Documentation

- **INSTALLATION_GUIDE.md** - Step-by-step setup instructions
- **QUICK_REFERENCE.txt** - Command reference card
- **backup-config.env.example** - Configuration template

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section
2. Review INSTALLATION_GUIDE.md
3. Check log files in BACKUP_FOLDER_PATH
4. Verify all prerequisites are installed

## 📄 License

KismatX Database Backup Application - Part of KismatX Gaming Platform

Runs the scheduler to automatically backup on a schedule (default: 2 AM daily).

Edit `backup-config.env` to change the schedule:
```
BACKUP_SCHEDULE=0 2 * * *  # Every day at 2 AM (cron format)
```

### Restore from S3
```bash
npm run restore
```
Interactive wizard to:
1. List available backups
2. Download a backup
3. Restore to database

## File Structure

```
dbbackup/
├── package.json              # Dependencies
├── config.js                 # Configuration management
├── db-manager.js             # Database backup/restore functions
├── s3-manager.js             # AWS S3 operations
├── backup.js                 # Main backup script
├── setup.js                  # Interactive setup wizard
├── restore.js                # Restore from S3
├── scheduler.js              # Automatic backup scheduler
└── README.md                 # This file
```

## Configuration Files

### .env (Parent Directory)
Contains main database credentials:
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=KismatX
```

### backup-config.env (Created by setup)
Contains AWS credentials:
```
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_S3_BUCKET=your-bucket-name
BACKUP_RETENTION_DAYS=30
BACKUP_SCHEDULE=0 2 * * *
```

## AWS Setup

### Prerequisites
1. AWS Account
2. IAM User with S3 permissions
3. S3 Bucket created

### Required S3 Permissions
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
```

### System Requirements
- Node.js 16+ (using ES modules)
- MySQL 5.7+ (mysqldump utility)
- Windows, Linux, or macOS

### Environment Setup

#### Windows
1. Install MySQL Community Server (includes mysqldump)
2. Add MySQL bin directory to PATH:
   - Default: `C:\Program Files\MySQL\MySQL Server 8.0\bin`
3. Verify: `mysqldump --version`

#### Linux/macOS
```bash
# Ubuntu/Debian
sudo apt-get install mysql-client

# macOS
brew install mysql-client
```

## Features

✅ **Automated Backups** - Schedule daily backups
✅ **AWS S3 Storage** - Secure cloud storage
✅ **Easy Restore** - Interactive restore wizard
✅ **Compression** - Optimized dump format
✅ **Logging** - Detailed operation logs
✅ **Error Handling** - Graceful error management
✅ **Retention Policy** - Auto-cleanup old backups (future)

## Troubleshooting

### mysqldump not found
**Error:** `mysqldump: command not found`
**Solution:** Install MySQL client tools and add to PATH

### Database connection failed
**Error:** `Error: connect ECONNREFUSED`
**Solution:** Check DB credentials in `.env` file

### AWS credentials invalid
**Error:** `InvalidUserID.Malformed`
**Solution:** Verify AWS Access Key ID and Secret in `backup-config.env`

### S3 permission denied
**Error:** `AccessDenied`
**Solution:** Add S3 permissions to IAM user

## Backup File Naming

Backups are organized by date in S3:
```
backups/
├── 2024/
│   ├── 11/
│   │   ├── KismatX_2024-11-25_1734010800000.sql
│   │   └── KismatX_2024-11-24_1733924400000.sql
│   └── 10/
│       └── KismatX_2024-10-31_1730372400000.sql
```

## Cost Optimization

### S3 Storage Classes
For long-term backups, consider using S3 Glacier:
- Standard (frequent access)
- Intelligent-Tiering (automatic cost optimization)
- Glacier (archival storage - much cheaper)

### Lifecycle Policy
Set S3 lifecycle rules to automatically:
1. Move to Glacier after 30 days
2. Delete after 1 year

## Best Practices

✅ **Test Restores** - Regularly test backup restoration
✅ **Monitor Storage** - Check S3 usage and costs
✅ **Multiple Regions** - Backup to multiple S3 regions
✅ **Encrypt Data** - Use S3 encryption
✅ **Access Logs** - Enable S3 access logging
✅ **Versioning** - Enable S3 versioning for protection

## Security Notes

🔒 **Keep credentials secure:**
- Never commit `backup-config.env` to git
- Add to `.gitignore`
- Use IAM roles in production
- Rotate access keys regularly
- Use AWS Secrets Manager for sensitive data

## Support

For issues or questions:
1. Check troubleshooting section
2. Review AWS IAM permissions
3. Verify MySQL client installation
4. Check S3 bucket configuration

## License

MIT - KismatX Team
