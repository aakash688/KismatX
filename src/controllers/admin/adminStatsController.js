/**
 * Admin Stats Controller
 * Handles all admin statistics and analytics endpoints
 */

import { AppDataSource } from "../../config/typeorm.config.js";
import { In } from "typeorm";

const GameEntity = "Game";
const BetSlipEntity = "BetSlip";
const UserEntity = "User";
const WalletLogEntity = "WalletLog";

/**
 * Get Statistics for Selected Date Range and User(s)
 * POST /api/admin/stats
 * 
 * Request Body:
 * {
 *   startDate: "2025-11-13",
 *   endDate: "2025-11-13",
 *   userId: null or user_id number
 * }
 */
export const getStats = async (req, res, next) => {
  try {
    const { startDate, endDate, userId } = req.body;

    console.log("📊 Stats request:", { startDate, endDate, userId });

    // Validate dates
    if (!startDate || !endDate) {
      return res.status(400).json({
        success: false,
        message: "startDate and endDate are required",
      });
    }

    const gameRepo = AppDataSource.getRepository(GameEntity);
    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const walletLogRepo = AppDataSource.getRepository(WalletLogEntity);
    const userRepo = AppDataSource.getRepository(UserEntity);

    // Parse dates
    const startDateTime = new Date(startDate);
    startDateTime.setHours(0, 0, 0, 0);
    const endDateTime = new Date(endDate);
    endDateTime.setHours(23, 59, 59, 999);

    console.log("Date range:", { startDateTime, endDateTime });

    // Build WHERE clause for games
    let gameWhereCondition = `game.created_at >= :startDate AND game.created_at <= :endDate AND game.settlement_status = 'settled'`;
    let betSlipWhereCondition = `bet_slip.created_at >= :startDate AND bet_slip.created_at <= :endDate`;

    const whereParams = {
      startDate: startDateTime,
      endDate: endDateTime,
    };

    // If specific user is selected, add user filter
    if (userId && userId !== "all") {
      gameWhereCondition += ` AND bet_slip.user_id = :userId`;
      betSlipWhereCondition += ` AND bet_slip.user_id = :userId`;
      whereParams.userId = parseInt(userId);
    }

    // Query 1: Get all bet slips for date range
    const allBetSlips = await betSlipRepo
      .createQueryBuilder("bet_slip")
      .leftJoinAndSelect("bet_slip.game", "game")
      .where(betSlipWhereCondition, whereParams)
      .getMany();

    console.log(`Found ${allBetSlips.length} bet slips`);

    // Query 2: Calculate total wagered (all bet slips)
    const wageredResult = await betSlipRepo
      .createQueryBuilder("bet_slip")
      .leftJoinAndSelect("bet_slip.game", "game")
      .select("SUM(CAST(bet_slip.total_amount AS DECIMAL(15,2)))", "total")
      .where(betSlipWhereCondition, whereParams)
      .getRawOne();

    const totalWagered = parseFloat(wageredResult?.total || 0);

    console.log("Total Wagered:", totalWagered);

    // Query 3: Get claimed payout amounts from BetSlip (scanned/winning amounts)
    let claimedBetsWhereCondition = `bet_slip.created_at >= :startDate AND bet_slip.created_at <= :endDate AND bet_slip.claimed = true`;
    
    let claimedBetsParams = { startDate: startDateTime, endDate: endDateTime };
    if (userId && userId !== "all") {
      claimedBetsParams.userId = parseInt(userId);
      claimedBetsWhereCondition += ` AND bet_slip.user_id = :userId`;
    }

    const claimedBetsResult = await betSlipRepo
      .createQueryBuilder("bet_slip")
      .select("SUM(CAST(bet_slip.payout_amount AS DECIMAL(15,2)))", "total")
      .where(claimedBetsWhereCondition, claimedBetsParams)
      .getRawOne();

    const totalScanned = parseFloat(claimedBetsResult?.total || 0);

    console.log("Total Scanned (Claimed Winnings):", totalScanned);

    // Calculate margin (6% of wagered)
    const margin = totalWagered * 0.06;

    // Calculate net to pay (wagered - scanned - margin)
    const netToPay = totalWagered - totalScanned - margin;

    console.log("Calculations:", { margin, netToPay });

    // Get per-user stats
    const userStatsMap = new Map();

    // Aggregate data per user
    allBetSlips.forEach((slip) => {
      const uid = slip.user_id;
      const wagered = parseFloat(slip.total_amount || 0);

      if (!userStatsMap.has(uid)) {
        userStatsMap.set(uid, {
          user_id: uid,
          wagered: 0,
          claimedWinnings: 0,
        });
      }

      const stats = userStatsMap.get(uid);
      stats.wagered += wagered;
    });

    // Get winnings claimed per user
    const claimedPerUser = await betSlipRepo
      .createQueryBuilder("bet_slip")
      .select("bet_slip.user_id", "user_id")
      .addSelect("SUM(CAST(bet_slip.payout_amount AS DECIMAL(15,2)))", "total")
      .where(
        `bet_slip.created_at >= :startDate AND bet_slip.created_at <= :endDate 
         AND bet_slip.claimed = true`,
        whereParams
      )
      .groupBy("bet_slip.user_id")
      .getRawMany();

    console.log("Claimed per user:", claimedPerUser);

    // Merge claimed amounts
    claimedPerUser.forEach((row) => {
      const uid = row.user_id;
      if (userStatsMap.has(uid)) {
        const stats = userStatsMap.get(uid);
        stats.claimedWinnings = parseFloat(row.total || 0);
      }
    });

    // Get user details
    const userIds = Array.from(userStatsMap.keys());
    let userDetails = [];
    if (userIds.length > 0) {
      userDetails = await userRepo.find({
        where: { id: In(userIds) },
      });
    }

    const userDetailsMap = new Map(userDetails.map((u) => [u.id, u]));

    // Build final user stats array
    const userStats = Array.from(userStatsMap.entries()).map(([uid, stats]) => {
      const user = userDetailsMap.get(uid);
      const wagered = stats.wagered;
      const scanned = stats.claimedWinnings;
      const userMargin = wagered * 0.06;
      const userNetToPay = wagered - scanned - userMargin;

      return {
        user: user || { id: uid, first_name: "Unknown", last_name: "User", user_id: `USER_${uid}` },
        wagered,
        scanned,
        margin: userMargin,
        netToPay: userNetToPay,
      };
    });

    // Sort by wagered amount descending
    userStats.sort((a, b) => b.wagered - a.wagered);

    console.log("✅ Stats calculated successfully");

    res.json({
      success: true,
      data: {
        summary: {
          totalWagered,
          totalScanned,
          margin,
          netToPay,
        },
        userStats,
      },
    });
  } catch (error) {
    console.error("❌ Error getting stats:", error);
    next(error);
  }
};

/**
 * Get Daily Stats Trend
 * GET /api/admin/stats/trend
 */
export const getStatsTrend = async (req, res, next) => {
  try {
    const { startDate, endDate, userId } = req.query;

    if (!startDate || !endDate) {
      return res.status(400).json({
        success: false,
        message: "startDate and endDate are required",
      });
    }

    const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
    const walletLogRepo = AppDataSource.getRepository(WalletLogEntity);

    const startDateTime = new Date(startDate);
    startDateTime.setHours(0, 0, 0, 0);
    const endDateTime = new Date(endDate);
    endDateTime.setHours(23, 59, 59, 999);

    const whereParams = { startDate: startDateTime, endDate: endDateTime };

    // Get daily wagered amounts
    const dailyWagered = await betSlipRepo
      .createQueryBuilder("bet_slip")
      .select("DATE(bet_slip.created_at)", "date")
      .addSelect("SUM(CAST(bet_slip.total_amount AS DECIMAL(15,2)))", "total")
      .where(`bet_slip.created_at >= :startDate AND bet_slip.created_at <= :endDate`, whereParams)
      .groupBy("DATE(bet_slip.created_at)")
      .orderBy("DATE(bet_slip.created_at)", "ASC")
      .getRawMany();

    // Get daily claimed amounts
    const dailyClaimed = await walletLogRepo
      .createQueryBuilder("wallet_log")
      .select("DATE(wallet_log.created_at)", "date")
      .addSelect("SUM(CAST(wallet_log.amount AS DECIMAL(15,2)))", "total")
      .where(
        `wallet_log.created_at >= :startDate AND wallet_log.created_at <= :endDate 
         AND wallet_log.reference_type = 'game_win' 
         AND wallet_log.transaction_direction = 'credit'`,
        whereParams
      )
      .groupBy("DATE(wallet_log.created_at)")
      .orderBy("DATE(wallet_log.created_at)", "ASC")
      .getRawMany();

    // Merge data
    const trendMap = new Map();
    dailyWagered.forEach((row) => {
      const date = row.date;
      if (!trendMap.has(date)) {
        trendMap.set(date, { date, wagered: 0, scanned: 0 });
      }
      trendMap.get(date).wagered = parseFloat(row.total || 0);
    });

    dailyClaimed.forEach((row) => {
      const date = row.date;
      if (!trendMap.has(date)) {
        trendMap.set(date, { date, wagered: 0, scanned: 0 });
      }
      trendMap.get(date).scanned = parseFloat(row.total || 0);
    });

    const trend = Array.from(trendMap.values()).sort((a, b) => new Date(a.date) - new Date(b.date));

    res.json({
      success: true,
      data: trend,
    });
  } catch (error) {
    console.error("❌ Error getting trend:", error);
    next(error);
  }
};
