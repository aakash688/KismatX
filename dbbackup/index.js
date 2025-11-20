require("dotenv").config();
const mysql = require("mysql2/promise");
const cron = require("node-cron");
const fs = require("fs");
const { exec } = require("child_process");

// AWS SDK v3
const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");

// ------------------------------------------
// AWS S3 CONFIG
// ------------------------------------------
const s3 = new S3Client({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

const BUCKET_NAME = process.env.S3_BUCKET;
const S3_PREFIX = process.env.S3_PREFIX;

// ------------------------------------------
// DB CONFIG
// ------------------------------------------
const localDB = {
  host: process.env.LOCAL_DB_HOST,
  user: process.env.LOCAL_DB_USER,
  password: process.env.LOCAL_DB_PASSWORD,
  database: process.env.LOCAL_DB_DATABASE,
};

const remoteDB = {
  host: process.env.REMOTE_DB_HOST,
  user: process.env.REMOTE_DB_USER,
  password: process.env.REMOTE_DB_PASSWORD,
  database: process.env.REMOTE_DB_DATABASE,
};

// ------------------------------------------
// TABLE CONFIGURATION
// ------------------------------------------
const tablesWithUpdatedAt = [
  "bet_details","bet_slips","games","game_card_totals",
  "login_history","refresh_tokens","settings","settings_logs",
  "users","wallet_logs"
];

const tablesWithCreatedAt = [
  "audit_logs","permissions","roles","role_permissions","user_roles"
];

const tables = [
  "users","bet_slips","bet_details","games","game_card_totals","wallet_logs",
  "settings","settings_logs","login_history","refresh_tokens",
  "permissions","roles","role_permissions","user_roles","audit_logs"
];

// Hold last sync time per table
let lastSync = {};

// ------------------------------------------
// UPLOAD SQL TO S3
// ------------------------------------------
async function uploadBackupToS3(filePath) {
  const fileStream = fs.createReadStream(filePath);
  const fileName = filePath.split("/").pop();

  const command = new PutObjectCommand({
    Bucket: BUCKET_NAME,
    Key: `${S3_PREFIX}/${fileName}`,
    Body: fileStream,
  });

  await s3.send(command);
  console.log(`☁️ Backup uploaded to S3: s3://${BUCKET_NAME}/${S3_PREFIX}/${fileName}`);
}

// ------------------------------------------
// CREATE DB DUMP
// ------------------------------------------
async function createBackup() {
  const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
  const filePath = `./KismatX_${timestamp}.sql`;

  const cmd = `mysqldump -h ${localDB.host} -u ${localDB.user} -p${localDB.password} ${localDB.database} > ${filePath}`;
  
  return new Promise((resolve, reject) => {
    exec(cmd, async (err) => {
      if (err) return reject(err);
      console.log(`💾 Local backup created: ${filePath}`);
      try {
        await uploadBackupToS3(filePath);

        // Delete local dump after upload
        fs.unlink(filePath, (err) => {
          if (err) console.error("❌ Failed to delete local backup:", err);
          else console.log(`🗑 Local backup deleted: ${filePath}`);
        });

        resolve(filePath);
      } catch (e) {
        reject(e);
      }
    });
  });
}

// ------------------------------------------
// SYNC ONE TABLE
// ------------------------------------------
async function syncTable(tableName) {
  const startTime = new Date();
  console.log(`\n--------------------------------------`);
  console.log(`🔄 Sync started for table [${tableName}] at ${startTime.toLocaleString()}`);
  console.log(`--------------------------------------`);

  const sourceConn = await mysql.createConnection(localDB);
  const backupConn = await mysql.createConnection(remoteDB);

  try {
    let query, params = [];
    const lastTime = lastSync[tableName] || "1970-01-01 00:00:00";

    if (tablesWithUpdatedAt.includes(tableName)) {
      query = `SELECT * FROM ${tableName} WHERE updated_at > ?`;
      params = [lastTime];
    } else if (tablesWithCreatedAt.includes(tableName)) {
      query = `SELECT * FROM ${tableName} WHERE created_at > ?`;
      params = [lastTime];
    } else {
      query = `SELECT * FROM ${tableName}`;
    }

    const [rows] = await sourceConn.execute(query, params);

    if (rows.length === 0) {
      console.log(`✔ No new or updated entries for table [${tableName}]`);
      return 0;
    }

    console.log(`📦 Found ${rows.length} rows for table [${tableName}]`);
    console.log(`🚀 Syncing to remote backup...`);

    const keys = Object.keys(rows[0]);
    const placeholders = keys.map(() => "?").join(",");
    const updateString = keys.map(k => `${k}=VALUES(${k})`).join(",");

    const sql = `
      INSERT INTO ${tableName} (${keys.join(",")})
      VALUES (${placeholders})
      ON DUPLICATE KEY UPDATE ${updateString}
    `;

    for (const row of rows) {
      await backupConn.execute(sql, Object.values(row));
    }

    console.log(`✅ Table [${tableName}] synced successfully!`);

    lastSync[tableName] = new Date().toISOString().slice(0, 19).replace("T", " ");
    return rows.length;

  } catch (err) {
    console.error(`❌ Error syncing table [${tableName}]:`, err);
    return 0;
  } finally {
    await sourceConn.end();
    await backupConn.end();
  }
}

// ------------------------------------------
// SYNC ALL TABLES
// ------------------------------------------
async function syncDatabase() {
  console.log(`\n⏱ Starting full sync cycle at ${new Date().toLocaleString()}`);

  try {
    await createBackup(); // Step 1: create & upload SQL backup
  } catch (err) {
    console.error("❌ Backup failed:", err);
    return;
  }

  const affected = [];
  for (const table of tables) {
    const count = await syncTable(table);
    if (count > 0) affected.push(`${table} (${count} rows)`);
  }

  if (affected.length > 0) {
    console.log(`✨ Tables updated: ${affected.join(", ")}`);
  } else {
    console.log("✔ No tables updated this cycle.");
  }

  console.log("⏳ Waiting for next sync…\n");
}

// ------------------------------------------
// CRON: Every day at 10:00 AM
// ------------------------------------------
cron.schedule("0 10 * * *", () => {
  console.log("\n⏱ Cron triggered → Starting daily sync...");
  syncDatabase();
});

// ------------------------------------------
// INITIAL RUN
// ------------------------------------------
console.log("🚀 MariaDB Incremental Sync Service Running...");
console.log("⏳ Running initial sync...");
syncDatabase();
