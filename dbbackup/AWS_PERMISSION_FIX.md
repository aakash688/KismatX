# ⚠️ AWS S3 Permission Issue - Solution

## Problem
```
❌ User: arn:aws:iam::203520860923:user/dbbackup_user is not authorized 
   to perform: s3:ListAllMyBuckets because no identity-based policy allows 
   the s3:ListAllMyBuckets action
```

Your AWS IAM user `dbbackup_user` is missing S3 permissions.

---

## Solution: Add IAM Policy

### Step 1: Go to AWS IAM Console
1. Login to AWS Console: https://console.aws.amazon.com/iam/
2. Go to **Users** → **dbbackup_user**
3. Click **Add permissions** → **Attach policies directly**

### Step 2: Create Inline Policy

Click **Create inline policy** and paste this JSON policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3BackupBucketAccess",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::kmx",
        "arn:aws:s3:::kmx/*"
      ]
    }
  ]
}
```

**What each permission does:**
- `s3:PutObject` - Upload backup files
- `s3:GetObject` - Download backups for restore
- `s3:DeleteObject` - Delete old backups (retention cleanup)
- `s3:ListBucket` - List backups in S3

### Step 3: Confirm & Save

Click **Create policy** → Done!

---

## After Adding Permissions

Wait 1-2 minutes for AWS to propagate permissions, then test again:

```bash
npm run backup
```

Should work now! ✅

---

## Current Status

✅ Database connection working (fixed!)
✅ Backup creation working (2.84 MB created successfully)
❌ S3 upload failing (missing IAM permissions) → NEEDS FIX ABOVE

---

## Alternative: Use Different AWS Credentials

If you can't modify the IAM policy, you can use your main AWS account credentials instead:

1. Generate new Access Key for your main account
2. Update `backup-config.env`:
   ```env
   AWS_ACCESS_KEY_ID=<your-main-account-key>
   AWS_SECRET_ACCESS_KEY=<your-main-account-secret>
   ```
3. Run `npm run backup` again

---

## Commands to Test

After fixing the IAM policy:

```bash
# Manual backup test
npm run backup

# Start automatic backups (daily 23:00)
npm run backup:schedule

# Check backup log
tail -f ./backups/backups.log
```

---

## Need Help?

1. **AWS IAM Documentation:** https://docs.aws.amazon.com/IAM/latest/UserGuide/
2. **S3 Bucket Policies:** https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketPolicies.html
3. **Check your AWS credentials are correct:**
   ```bash
   AWS_REGION=ap-south-1
   AWS_ACCESS_KEY_ID=AKIAS6YWJ4L5TA2V2ZED
   AWS_SECRET_ACCESS_KEY=zN4K0+UpHJ2afnSOVOev4CQnjB8i401tP8DLmGMR
   AWS_S3_BUCKET=kmx
   ```

Let me know once the IAM policy is added!
