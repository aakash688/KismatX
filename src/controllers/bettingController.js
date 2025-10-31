// Betting Controller
// Handles bet placement, slip management, and bet queries

import { AppDataSource } from "../config/typeorm.config.js";
import { auditLog } from "../utils/auditLogger.js";
import crypto from "crypto";

const GameEntity = "Game";
const BetSlipEntity = "BetSlip";
const BetDetailEntity = "BetDetail";
const GameCardTotalEntity = "GameCardTotal";
const UserEntity = "User";

/**
 * Generate unique slip ID
 * Format: SLIP_YYYYMMDD_HHMMSS_RANDOM
 */
const generateSlipId = () => {
  const now = new Date();
  const dateStr = now.toISOString().replace(/[-:T.]/g, '').slice(0, 14);
  const random = crypto.randomBytes(4).toString('hex').toUpperCase();
  return `SLIP_${dateStr}_${random}`;
};

/**
 * Generate barcode for slip
 * Format: Unique string that can be converted to barcode
 */
const generateBarcode = (slipId) => {
  const hash = crypto.createHash('md5').update(slipId).digest('hex');
  return hash.toUpperCase();
};

/**
 * Place a bet
 * POST /api/bets/place
 */
export const placeBet = async (req, res, next) => {
  try {
    const gameRepo = AppDataSource.getRepository(GameEntity);
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const betDetailRepo = AppDataSource.getRepository(BetDetailEntity);
    const cardTotalRepo = AppDataSource.getRepository(GameCardTotalEntity);
    const userRepo = AppDataSource.getRepository(UserEntity);
    
    const { game_id, bets } = req.body;
    const userId = req.user?.id;
    
    // Validate input
    if (!game_id || !bets || !Array.isArray(bets) || bets.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid request. game_id and bets array are required",
      });
    }
    
    // Validate bets array
    for (const bet of bets) {
      if (!bet.card_number || !bet.bet_amount) {
        return res.status(400).json({
          success: false,
          message: "Each bet must have card_number and bet_amount",
        });
      }
      
      if (bet.card_number < 1 || bet.card_number > 12) {
        return res.status(400).json({
          success: false,
          message: "Card number must be between 1 and 12",
        });
      }
      
      if (bet.bet_amount <= 0) {
        return res.status(400).json({
          success: false,
          message: "Bet amount must be greater than 0",
        });
      }
    }
    
    // Check if game exists and is active
    const game = await gameRepo.findOne({ where: { game_id } });
    
    if (!game) {
      return res.status(404).json({
        success: false,
        message: "Game not found",
      });
    }
    
    if (game.status !== "active") {
      return res.status(400).json({
        success: false,
        message: `Cannot place bet on game with status: ${game.status}`,
      });
    }
    
    // Check if game has ended
    const now = new Date();
    if (now > game.end_time) {
      return res.status(400).json({
        success: false,
        message: "Game has ended. Cannot place bets",
      });
    }
    
    // Get user and check balance
    const user = await userRepo.findOne({ where: { id: userId } });
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }
    
    // Calculate total bet amount
    const totalAmount = bets.reduce((sum, bet) => sum + parseFloat(bet.bet_amount), 0);
    
    // Check if user has sufficient balance
    if (parseFloat(user.deposit_amount) < totalAmount) {
      return res.status(400).json({
        success: false,
        message: "Insufficient balance",
        data: {
          required: totalAmount,
          available: parseFloat(user.deposit_amount),
        },
      });
    }
    
    // Generate slip ID and barcode
    const slipId = generateSlipId();
    const barcode = generateBarcode(slipId);
    
    // Create bet slip
    const betSlip = betSlipRepo.create({
      slip_id: slipId,
      user_id: userId,
      game_id: game_id,
      total_amount: totalAmount,
      barcode: barcode,
      status: "pending",
    });
    
    await betSlipRepo.save(betSlip);
    
    // Create bet details and update card totals
    const betDetails = [];
    for (const bet of bets) {
      const betDetail = betDetailRepo.create({
        slip_id: betSlip.id,
        card_number: bet.card_number,
        bet_amount: bet.bet_amount,
      });
      betDetails.push(betDetail);
      
      // Update card total
      const cardTotal = await cardTotalRepo.findOne({
        where: { game_id, card_number: bet.card_number },
      });
      
      if (cardTotal) {
        cardTotal.total_bet_amount = parseFloat(cardTotal.total_bet_amount) + parseFloat(bet.bet_amount);
        await cardTotalRepo.save(cardTotal);
      }
    }
    
    await betDetailRepo.save(betDetails);
    
    // Deduct amount from user balance
    user.deposit_amount = parseFloat(user.deposit_amount) - totalAmount;
    await userRepo.save(user);
    
    // Audit log
    await auditLog(
      userId,
      "PLACE_BET",
      BetSlipEntity,
      betSlip.id,
      { slip_id: slipId, game_id, total_amount: totalAmount },
      req
    );
    
    res.status(201).json({
      success: true,
      message: "Bet placed successfully",
      data: {
        slip_id: betSlip.slip_id,
        barcode: betSlip.barcode,
        game_id: betSlip.game_id,
        total_amount: betSlip.total_amount,
        bets: betDetails.map(b => ({
          card_number: b.card_number,
          bet_amount: b.bet_amount,
        })),
      },
    });
  } catch (error) {
    console.error("❌ Error placing bet:", error);
    next(error);
  }
};

/**
 * Get bet slip by ID or barcode
 * GET /api/bets/slip/:identifier
 */
export const getBetSlip = async (req, res, next) => {
  try {
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const betDetailRepo = AppDataSource.getRepository(BetDetailEntity);
    const gameRepo = AppDataSource.getRepository(GameEntity);
    
    const { identifier } = req.params;
    
    // Try to find by slip_id or barcode
    let betSlip = await betSlipRepo.findOne({
      where: [
        { slip_id: identifier },
        { barcode: identifier },
      ],
    });
    
    if (!betSlip) {
      return res.status(404).json({
        success: false,
        message: "Bet slip not found",
      });
    }
    
    // Get bet details
    const betDetails = await betDetailRepo.find({
      where: { slip_id: betSlip.id },
      order: { card_number: "ASC" },
    });
    
    // Get game info
    const game = await gameRepo.findOne({
      where: { game_id: betSlip.game_id },
    });
    
    res.json({
      success: true,
      data: {
        slip: {
          slip_id: betSlip.slip_id,
          barcode: betSlip.barcode,
          game_id: betSlip.game_id,
          total_amount: betSlip.total_amount,
          total_payout: betSlip.total_payout,
          status: betSlip.status,
          created_at: betSlip.created_at,
        },
        game: {
          game_id: game?.game_id,
          status: game?.status,
          winning_card: game?.winning_card,
          payout_multiplier: game?.payout_multiplier,
        },
        bets: betDetails.map(b => ({
          card_number: b.card_number,
          bet_amount: b.bet_amount,
          is_winner: b.is_winner,
          payout_amount: b.payout_amount,
        })),
      },
    });
  } catch (error) {
    console.error("❌ Error fetching bet slip:", error);
    next(error);
  }
};

/**
 * Get all bets for current user
 * GET /api/bets/my-bets
 */
export const getMyBets = async (req, res, next) => {
  try {
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const { page = 1, limit = 20, status } = req.query;
    const userId = req.user?.id;
    
    const queryBuilder = betSlipRepo.createQueryBuilder("slip");
    queryBuilder.where("slip.user_id = :userId", { userId });
    
    // Filter by status
    if (status) {
      queryBuilder.andWhere("slip.status = :status", { status });
    }
    
    // Pagination
    const skip = (page - 1) * limit;
    queryBuilder.skip(skip).take(limit);
    
    // Order by created_at desc
    queryBuilder.orderBy("slip.created_at", "DESC");
    
    const [slips, total] = await queryBuilder.getManyAndCount();
    
    res.json({
      success: true,
      data: slips,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error("❌ Error fetching user bets:", error);
    next(error);
  }
};

/**
 * Get all bets for a game (Admin)
 * GET /api/bets/game/:gameId
 */
export const getGameBets = async (req, res, next) => {
  try {
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const { gameId } = req.params;
    const { page = 1, limit = 50 } = req.query;
    
    const queryBuilder = betSlipRepo.createQueryBuilder("slip");
    queryBuilder.where("slip.game_id = :gameId", { gameId });
    
    // Pagination
    const skip = (page - 1) * limit;
    queryBuilder.skip(skip).take(limit);
    
    // Order by created_at desc
    queryBuilder.orderBy("slip.created_at", "DESC");
    
    const [slips, total] = await queryBuilder.getManyAndCount();
    
    res.json({
      success: true,
      data: slips,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error("❌ Error fetching game bets:", error);
    next(error);
  }
};

/**
 * Validate and claim winnings
 * POST /api/bets/claim/:identifier
 */
export const claimWinnings = async (req, res, next) => {
  try {
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const userRepo = AppDataSource.getRepository(UserEntity);
    
    const { identifier } = req.params;
    const userId = req.user?.id;
    
    // Find bet slip
    let betSlip = await betSlipRepo.findOne({
      where: [
        { slip_id: identifier, user_id: userId },
        { barcode: identifier, user_id: userId },
      ],
    });
    
    if (!betSlip) {
      return res.status(404).json({
        success: false,
        message: "Bet slip not found or doesn't belong to you",
      });
    }
    
    if (betSlip.status !== "settled") {
      return res.status(400).json({
        success: false,
        message: `Cannot claim winnings. Slip status: ${betSlip.status}`,
      });
    }
    
    if (parseFloat(betSlip.total_payout) <= 0) {
      return res.status(400).json({
        success: false,
        message: "No winnings to claim",
      });
    }
    
    // Add winnings to user balance
    const user = await userRepo.findOne({ where: { id: userId } });
    user.deposit_amount = parseFloat(user.deposit_amount) + parseFloat(betSlip.total_payout);
    await userRepo.save(user);
    
    // Mark as claimed (you might want to add a 'claimed' status)
    betSlip.status = "settled"; // or create a new status "claimed"
    await betSlipRepo.save(betSlip);
    
    // Audit log
    await auditLog(
      userId,
      "CLAIM_WINNINGS",
      BetSlipEntity,
      betSlip.id,
      { slip_id: betSlip.slip_id, amount: betSlip.total_payout },
      req
    );
    
    res.json({
      success: true,
      message: "Winnings claimed successfully",
      data: {
        slip_id: betSlip.slip_id,
        claimed_amount: betSlip.total_payout,
        new_balance: user.deposit_amount,
      },
    });
  } catch (error) {
    console.error("❌ Error claiming winnings:", error);
    next(error);
  }
};

/**
 * Get betting statistics for user
 * GET /api/bets/stats
 */
export const getBettingStats = async (req, res, next) => {
  try {
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const userId = req.user?.id;
    
    // Total bets
    const totalSlips = await betSlipRepo.count({ where: { user_id: userId } });
    
    // Pending bets
    const pendingSlips = await betSlipRepo.count({
      where: { user_id: userId, status: "pending" },
    });
    
    // Won bets
    const wonSlips = await betSlipRepo.count({
      where: { user_id: userId, status: "settled" },
    });
    
    // Lost bets
    const lostSlips = await betSlipRepo.count({
      where: { user_id: userId, status: "lost" },
    });
    
    // Total bet amount
    const slips = await betSlipRepo.find({ where: { user_id: userId } });
    const totalBetAmount = slips.reduce((sum, slip) => sum + parseFloat(slip.total_amount), 0);
    const totalWinnings = slips.reduce((sum, slip) => sum + parseFloat(slip.total_payout), 0);
    
    res.json({
      success: true,
      data: {
        total_slips: totalSlips,
        pending_slips: pendingSlips,
        won_slips: wonSlips,
        lost_slips: lostSlips,
        total_bet_amount: totalBetAmount,
        total_winnings: totalWinnings,
        net_profit: totalWinnings - totalBetAmount,
      },
    });
  } catch (error) {
    console.error("❌ Error fetching betting stats:", error);
    next(error);
  }
};


