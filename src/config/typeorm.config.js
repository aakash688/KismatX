import "reflect-metadata";
import { DataSource } from "typeorm";
import dotenv from "dotenv";
import CustomLogger from "../utils/logger/typeorm.js";
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config();

export const AppDataSource = new DataSource({
  type: "mariadb", // or "mysql" for MySQL databases
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT) || 3306,
  username: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "root",
  database: process.env.DB_NAME || "test_db",
  poolSize: 20,
  supportBigNumbers: true,
  synchronize: process.env.NODE_ENV !== "production", // Set to false in production
  logging: process.env.NODE_ENV === "development",
  logger: new CustomLogger(),
  entities: [__dirname + "/../entities/**/*.js"],
  migrations: [__dirname + "/../migrations/*.js"],
  subscribers: [],
  cli: {
    migrationsDir: "src/migrations"
  }
});
