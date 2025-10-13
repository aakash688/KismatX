import "reflect-metadata";
import express from "express";
import cors from "cors";
import cookieParser from "cookie-parser";
import bodyParser from "body-parser";
import fileUpload from "express-fileupload";
import apiRouter from "./routes/routes.js";
import morgan from "morgan";
import { logger } from "./utils/logger/logger.js";
import { httpRequestDurationMicroseconds, register } from "./utils/logger/metrics.js";
import statusMonitor from "express-status-monitor";
import errorHandler from "./middleware/errorHandler.js";
import notFoundHandler from "./middleware/notFoundHandler.js";
import { AppDataSource } from "./config/typeorm.config.js";
import path from "path";
import { fileURLToPath } from 'url';
import {formatDatesMiddleware} from "./middleware/formatDates.js";

const app = express();
const PORT = process.env.PORT || 5001;
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
// Go up from src to project root
const projectRoot = path.resolve(__dirname, '..');

// Define path to public folder
const publicPath = path.join(projectRoot, 'public');

// ------------------ Middlewares ------------------ //

// 🛡️ CORS setup
app.use(
  cors({
    origin: process.env.CORS_ORIGIN || true,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Cookie'],
    exposedHeaders: ['Set-Cookie']
  })
);

// Body Parser and Cookies
app.use(bodyParser.json());
app.use(cookieParser());
app.use(fileUpload({
    createParentPath: true,
    limits: { fileSize: parseInt(process.env.MAX_FILE_SIZE) || 50 * 1024 * 1024 }, // 50MB max file size
    abortOnLimit: true,
    responseOnLimit: "File size limit has been reached",
    useTempFiles: true,
    tempFileDir: '/tmp/'
}));

// logging setup (Morgan)
app.use(morgan('combined', { stream: { write: (message) => logger.info(message.trim()) } }))

// ------------------ 📺 Monitoring and metrics setup ------------------ //

// request duration tracking
app.use((req, res, next) => {
  const end = httpRequestDurationMicroseconds.startTimer();
  res.on('finish', () => {
    end({ method: req.method, route: req.originalUrl, status: res.statusCode });
  });
  next();
});

// express status monitor
app.use(statusMonitor());

// Expose Prometheus metrics
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

// ------------------ 🛣️ Static Content ------------------ //
app.get("/api", (req, res) => {
  res.sendFile(path.join(publicPath, "api_page.html"));
});
app.use('/profile', express.static(path.join(__dirname,'..', 'uploads', 'profilePhoto')));

// ------------------ 🛣️ Routes ------------------ //
app.use("/api", apiRouter)

// ------------------ ❌ Error Handling ------------------ //

// 404 Handler
app.use(notFoundHandler)

// Global ErrorHandler
app.use(errorHandler)

// ------------------ 🏃‍➡️ Start server after DB connection ------------------ //

AppDataSource.initialize()
  .then(() => {
    console.log("✅ Database connected successfully");

    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
    });
  })
  .catch((err) => console.error("❌ Database connection failed", err));
