#!/usr/bin/env node

import cron from 'node-cron';
import path from 'path';
import { fileURLToPath } from 'url';
import { createDatabaseDump, verifyDatabaseConnection } from './db-manager.js';
import { uploadToS3 } from './s3-manager.js';
import { validateDbConfig, validateAwsConfig, validateBackupConfig, getBackupConfig } from './config.js';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * Delete backup files older than specified days
 */
const autoDeleteOldBackups = async (backupFolderPath, daysToKeep) => {
  try {
    if (!fs.existsSync(backupFolderPath)) {
      return;
    }
    
    const files = fs.readdirSync(backupFolderPath);
    const now = Date.now();
    const timeThreshold = daysToKeep * 24 * 60 * 60 * 1000;
    let deletedCount = 0;
    
    for (const file of files) {
      if (!file.endsWith('.sql')) continue;
      
      const filePath = path.join(backupFolderPath, file);
      const stats = fs.statSync(filePath);
      const fileAge = now - stats.mtimeMs;
      
      if (fileAge > timeThreshold) {
        fs.unlinkSync(filePath);
        deletedCount++;
        console.log(`  🗑️  Deleted: ${file}`);
      }
    }
    
    if (deletedCount > 0) {
      console.log(`  ✅ Removed ${deletedCount} backups older than ${daysToKeep} days`);
    }
    
  } catch (error) {
    console.warn(`  ⚠️  Auto-delete warning: ${error.message}`);
  }
};

/**
 * Log to file
 */
const logToFile = (message, logPath) => {
  try {
    const timestamp = new Date().toISOString();
    const logMessage = `[${timestamp}] ${message}\n`;
    
    const logDir = path.dirname(logPath);
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }
    
    fs.appendFileSync(logPath, logMessage);
  } catch (error) {
    console.warn(`⚠️  Could not write to log file: ${error.message}`);
  }
};

/**
 * Scheduled backup function
 */
const scheduleBackup = async () => {
  console.log('\n⏰ ============== KismatX Automatic Backup Scheduler ==============\n');
  
  try {
    // Validate configurations
    console.log('🔍 Validating configuration...\n');
    validateDbConfig();
    validateAwsConfig();
    validateBackupConfig();
    
    // Get backup configuration
    const backupConfig = getBackupConfig();
    
    // Ensure backup folder exists
    if (!fs.existsSync(backupConfig.backupFolderPath)) {
      fs.mkdirSync(backupConfig.backupFolderPath, { recursive: true });
      console.log(`📁 Created backup folder: ${backupConfig.backupFolderPath}\n`);
    }
    
    const schedule = backupConfig.schedule;
    const retention = backupConfig.retentionDays;
    const autoDeleteEnabled = backupConfig.autoDeleteEnabled;
    const autoDeleteDays = backupConfig.autoDeleteDays;
    const logPath = backupConfig.logFilePath;
    
    console.log('📋 Scheduler Configuration:');
    console.log(`  📅 Schedule: ${schedule}`);
    console.log(`  📁 Backup Folder: ${backupConfig.backupFolderPath}`);
    console.log(`  🗑️  Auto-Delete: ${autoDeleteEnabled ? `Yes (older than ${autoDeleteDays} days)` : 'No'}`);
    console.log(`  📊 S3 Retention: ${retention} days`);
    console.log(`  📝 Log File: ${logPath}`);
    console.log(`\n⏳ Waiting for next backup time...\n`);
    
    // Schedule backup task
    cron.schedule(schedule, async () => {
      const backupTime = new Date().toISOString();
      const logMessage = `Backup started`;
      
      console.log(`\n⏰ [${backupTime}] Starting scheduled backup...`);
      logToFile(logMessage, logPath);
      
      try {
        // Verify database connection
        await verifyDatabaseConnection();
        
        // Create backup in configured folder
        const dumpResult = await createDatabaseDump(backupConfig.backupFolderPath);
        
        // Upload to S3
        const s3Result = await uploadToS3(dumpResult.path, dumpResult.filename);
        
        // Auto-delete old backups if enabled
        if (autoDeleteEnabled) {
          console.log(`  🧹 Running auto-delete check...`);
          await autoDeleteOldBackups(backupConfig.backupFolderPath, autoDeleteDays);
        }
        
        // Clean up local file (--cleanup mode)
        const cleanup = process.argv.includes('--cleanup');
        if (cleanup) {
          fs.unlinkSync(dumpResult.path);
          console.log(`  🧹 Local file deleted`);
        }
        
        const successMsg = `✅ Backup successful | Size: ${dumpResult.size.toFixed(2)}MB | S3: ${s3Result.key}`;
        console.log(`\n${successMsg}\n`);
        logToFile(successMsg, logPath);
        
      } catch (error) {
        const errorMsg = `❌ Backup failed: ${error.message}`;
        console.error(`\n${errorMsg}\n`);
        logToFile(errorMsg, logPath);
      }
    });
    
    // Keep the process running
    process.stdin.resume();
    
  } catch (error) {
    console.error('\n❌ Scheduler setup failed:', error.message);
    process.exit(1);
  }
};

// Handle graceful shutdown
process.on('SIGINT', () => {
  console.log('\n\n👋 Scheduler stopped');
  process.exit(0);
});

// Run scheduler
scheduleBackup();
