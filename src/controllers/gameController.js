// Game Controller
// Handles game creation, management, and result declaration

import { AppDataSource } from "../config/typeorm.config.js";
import { auditLog } from "../utils/auditLogger.js";

const GameEntity = "Game";
const GameCardTotalEntity = "GameCardTotal";
const BetSlipEntity = "BetSlip";
const BetDetailEntity = "BetDetail";

/**
 * Generate game_id based on current time
 * Format: GAME_HH-MM (e.g., GAME_12-00, GAME_12-05)
 */
const generateGameId = (startTime) => {
  const hours = String(startTime.getHours()).padStart(2, '0');
  const minutes = String(startTime.getMinutes()).padStart(2, '0');
  return `GAME_${hours}-${minutes}`;
};

/**
 * Create a new game
 * POST /api/games/create
 */
export const createGame = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const cardTotalRepo = AppDataSource.getRepository(GameCardTotalEntity);
    
    const { payout_multiplier } = req.body;
    
    // Calculate start and end time
    const startTime = new Date();
    const endTime = new Date(startTime.getTime() + 5 * 60 * 1000); // 5 minutes later
    
    const gameId = generateGameId(startTime);
    
    // Check if game already exists for this time slot
    const existingGame = await gameRepo.findOne({ where: { game_id: gameId } });
    if (existingGame) {
      return res.status(400).json({
        success: false,
        message: "Game already exists for this time slot",
      });
    }
    
    // Create new game
    const game = gameRepo.create({
      game_id: gameId,
      start_time: startTime,
      end_time: endTime,
      status: "pending",
      payout_multiplier: payout_multiplier || 10.00,
    });
    
    await gameRepo.save(game);
    
    // Initialize card totals for all 12 cards
    const cardTotals = [];
    for (let cardNumber = 1; cardNumber <= 12; cardNumber++) {
      const cardTotal = cardTotalRepo.create({
        game_id: gameId,
        card_number: cardNumber,
        total_bet_amount: 0.00,
      });
      cardTotals.push(cardTotal);
    }
    await cardTotalRepo.save(cardTotals);
    
    // Audit log
    await auditLog(
      req.user?.id,
      "CREATE_GAME",
      GameEntity,
      game.id,
      { game_id: gameId },
      req
    );
    
    res.status(201).json({
      success: true,
      message: "Game created successfully",
      data: {
        game_id: game.game_id,
        start_time: game.start_time,
        end_time: game.end_time,
        status: game.status,
        payout_multiplier: game.payout_multiplier,
      },
    });
  } catch (error) {
    console.error("❌ Error creating game:", error);
    next(error);
  }
};

/**
 * Get all games with filters
 * GET /api/games
 */
export const getAllGames = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const { status, page = 1, limit = 20 } = req.query;
    
    const queryBuilder = gameRepo.createQueryBuilder("game");
    
    // Filter by status
    if (status) {
      queryBuilder.where("game.status = :status", { status });
    }
    
    // Pagination
    const skip = (page - 1) * limit;
    queryBuilder.skip(skip).take(limit);
    
    // Order by created_at desc
    queryBuilder.orderBy("game.created_at", "DESC");
    
    const [games, total] = await queryBuilder.getManyAndCount();
    
    res.json({
      success: true,
      data: games,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error("❌ Error fetching games:", error);
    next(error);
  }
};

/**
 * Get game by ID with card totals
 * GET /api/games/:gameId
 */
export const getGameById = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const cardTotalRepo = AppDataSource.getRepository(GameCardTotalEntity);
    
    const { gameId } = req.params;
    
    const game = await gameRepo.findOne({ where: { game_id: gameId } });
    
    if (!game) {
      return res.status(404).json({
        success: false,
        message: "Game not found",
      });
    }
    
    // Get card totals
    const cardTotals = await cardTotalRepo.find({
      where: { game_id: gameId },
      order: { card_number: "ASC" },
    });
    
    res.json({
      success: true,
      data: {
        game,
        cardTotals,
      },
    });
  } catch (error) {
    console.error("❌ Error fetching game:", error);
    next(error);
  }
};

/**
 * Start a game (change status to active)
 * PUT /api/games/:gameId/start
 */
export const startGame = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const { gameId } = req.params;
    
    const game = await gameRepo.findOne({ where: { game_id: gameId } });
    
    if (!game) {
      return res.status(404).json({
        success: false,
        message: "Game not found",
      });
    }
    
    if (game.status !== "pending") {
      return res.status(400).json({
        success: false,
        message: `Cannot start game with status: ${game.status}`,
      });
    }
    
    game.status = "active";
    await gameRepo.save(game);
    
    // Audit log
    await auditLog(
      req.user?.id,
      "START_GAME",
      GameEntity,
      game.id,
      { game_id: gameId, status: "active" },
      req
    );
    
    res.json({
      success: true,
      message: "Game started successfully",
      data: game,
    });
  } catch (error) {
    console.error("❌ Error starting game:", error);
    next(error);
  }
};

/**
 * Declare result - set winning card and complete game
 * PUT /api/games/:gameId/result
 */
export const declareResult = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const { gameId } = req.params;
    const { winning_card } = req.body;
    
    // Validate winning card
    if (!winning_card || winning_card < 1 || winning_card > 12) {
      return res.status(400).json({
        success: false,
        message: "Invalid winning card. Must be between 1 and 12",
      });
    }
    
    const game = await gameRepo.findOne({ where: { game_id: gameId } });
    
    if (!game) {
      return res.status(404).json({
        success: false,
        message: "Game not found",
      });
    }
    
    if (game.status === "completed") {
      return res.status(400).json({
        success: false,
        message: "Game already completed",
      });
    }
    
    game.winning_card = winning_card;
    game.status = "completed";
    await gameRepo.save(game);
    
    // Audit log
    await auditLog(
      req.user?.id,
      "DECLARE_RESULT",
      GameEntity,
      game.id,
      { game_id: gameId, winning_card },
      req
    );
    
    res.json({
      success: true,
      message: "Result declared successfully",
      data: {
        game_id: game.game_id,
        winning_card: game.winning_card,
        status: game.status,
      },
    });
  } catch (error) {
    console.error("❌ Error declaring result:", error);
    next(error);
  }
};

/**
 * Settle bets after result declaration
 * POST /api/games/:gameId/settle
 */
export const settleBets = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const betDetailRepo = AppDataSource.getRepository(BetDetailEntity);
    
    const { gameId } = req.params;
    
    const game = await gameRepo.findOne({ where: { game_id: gameId } });
    
    if (!game) {
      return res.status(404).json({
        success: false,
        message: "Game not found",
      });
    }
    
    if (game.status !== "completed" || !game.winning_card) {
      return res.status(400).json({
        success: false,
        message: "Game result must be declared before settling bets",
      });
    }
    
    // Get all bet slips for this game
    const betSlips = await betSlipRepo.find({
      where: { game_id: gameId, status: "pending" },
    });
    
    let settledCount = 0;
    
    for (const slip of betSlips) {
      // Get all bet details for this slip
      const betDetails = await betDetailRepo.find({
        where: { slip_id: slip.id },
      });
      
      let totalPayout = 0;
      let hasWinner = false;
      
      // Update each bet detail
      for (const bet of betDetails) {
        if (bet.card_number === game.winning_card) {
          bet.is_winner = true;
          bet.payout_amount = parseFloat(bet.bet_amount) * parseFloat(game.payout_multiplier);
          totalPayout += parseFloat(bet.payout_amount);
          hasWinner = true;
        } else {
          bet.is_winner = false;
          bet.payout_amount = 0;
        }
        await betDetailRepo.save(bet);
      }
      
      // Update slip status and total payout
      slip.total_payout = totalPayout;
      slip.status = hasWinner ? "settled" : "lost";
      await betSlipRepo.save(slip);
      
      settledCount++;
    }
    
    // Audit log
    await auditLog(
      req.user?.id,
      "SETTLE_BETS",
      GameEntity,
      game.id,
      { game_id: gameId, settled_count: settledCount },
      req
    );
    
    res.json({
      success: true,
      message: "Bets settled successfully",
      data: {
        game_id: gameId,
        settled_slips: settledCount,
      },
    });
  } catch (error) {
    console.error("❌ Error settling bets:", error);
    next(error);
  }
};

/**
 * Get current active game
 * GET /api/games/current
 */
export const getCurrentGame = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const cardTotalRepo = AppDataSource.getRepository(GameCardTotalEntity);
    
    // Find active or pending game
    const game = await gameRepo.findOne({
      where: [
        { status: "active" },
        { status: "pending" },
      ],
      order: { created_at: "DESC" },
    });
    
    if (!game) {
      return res.status(404).json({
        success: false,
        message: "No active game found",
      });
    }
    
    // Get card totals
    const cardTotals = await cardTotalRepo.find({
      where: { game_id: game.game_id },
      order: { card_number: "ASC" },
    });
    
    res.json({
      success: true,
      data: {
        game,
        cardTotals,
      },
    });
  } catch (error) {
    console.error("❌ Error fetching current game:", error);
    next(error);
  }
};

/**
 * Get game statistics
 * GET /api/games/:gameId/stats
 */
export const getGameStats = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const cardTotalRepo = AppDataSource.getRepository(GameCardTotalEntity);
    
    const { gameId } = req.params;
    
    const game = await gameRepo.findOne({ where: { game_id: gameId } });
    
    if (!game) {
      return res.status(404).json({
        success: false,
        message: "Game not found",
      });
    }
    
    // Get total bets and slips
    const [slips, totalSlips] = await betSlipRepo.findAndCount({
      where: { game_id: gameId },
    });
    
    const totalBetAmount = slips.reduce((sum, slip) => sum + parseFloat(slip.total_amount), 0);
    const totalPayoutAmount = slips.reduce((sum, slip) => sum + parseFloat(slip.total_payout), 0);
    
    // Get card totals
    const cardTotals = await cardTotalRepo.find({
      where: { game_id: gameId },
      order: { card_number: "ASC" },
    });
    
    res.json({
      success: true,
      data: {
        game_id: gameId,
        status: game.status,
        winning_card: game.winning_card,
        total_slips: totalSlips,
        total_bet_amount: totalBetAmount,
        total_payout_amount: totalPayoutAmount,
        profit: totalBetAmount - totalPayoutAmount,
        card_totals: cardTotals,
      },
    });
  } catch (error) {
    console.error("❌ Error fetching game stats:", error);
    next(error);
  }
};


