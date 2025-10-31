// Game Routes
// Handles all game-related endpoints

import express from "express";
import {
  createGame,
  getAllGames,
  getGameById,
  startGame,
  declareResult,
  settleBets,
  getCurrentGame,
  getGameStats,
} from "../controllers/gameController.js";
import { authenticateToken, requireAdmin } from "../middleware/auth.js";

const router = express.Router();

// Public routes
router.get("/current", getCurrentGame);
router.get("/:gameId", getGameById);

// Protected routes (require authentication)
router.use(authenticateToken);

// Admin only routes
router.post("/create", requireAdmin, createGame);
router.get("/", requireAdmin, getAllGames);
router.put("/:gameId/start", requireAdmin, startGame);
router.put("/:gameId/result", requireAdmin, declareResult);
router.post("/:gameId/settle", requireAdmin, settleBets);
router.get("/:gameId/stats", requireAdmin, getGameStats);

export default router;


