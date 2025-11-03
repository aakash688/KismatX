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
  getRecentWinners,
} from "../controllers/gameController.js";
import { verifyToken, isAdmin } from "../middleware/auth.js";

const router = express.Router();

// Public routes
router.get("/current", getCurrentGame);
router.get("/recent-winners", getRecentWinners);
router.get("/:gameId", getGameById);

// Admin only routes (require authentication + admin role)
router.post("/create", verifyToken, isAdmin, createGame);
router.get("/", verifyToken, isAdmin, getAllGames);
router.put("/:gameId/start", verifyToken, isAdmin, startGame);
router.put("/:gameId/result", verifyToken, isAdmin, declareResult);
router.post("/:gameId/settle", verifyToken, isAdmin, settleBets);
router.get("/:gameId/stats", verifyToken, isAdmin, getGameStats);

export default router;


