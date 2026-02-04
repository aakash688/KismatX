/**
 * Game Scheduler
 * Handles automated game creation and state management via cron jobs
 * 
 * @module schedulers/gameScheduler
 */

import cron from 'node-cron';
import { createDailyGames, createNextGame, activatePendingGames, completeActiveGames } from '../services/gameService.js';
import { settleGame } from '../services/settlementService.js';
import { getSetting, getSettingAsNumber } from '../utils/settings.js';
import { AppDataSource } from '../config/typeorm.config.js';
import { formatIST, toIST, toUTC, parseTimeString } from '../utils/timezone.js';
import { selectWinningCard, calculateProfit, getTotalBetsPerCard } from '../utils/winningCardSelector.js';

const GameEntity = "Game";
const BetDetailEntity = "BetDetail";

// Store interval reference for cleanup
let autoSettlementIntervalRef = null;

/**
 * Recovery function: Create any missed games on startup
 * Detects games that should exist but don't due to scheduler failures
 * 
 * Scenario:
 * - Server running, 5-minute cron creates games successfully
 * - Server crashes at 10:15 AM (missed 10:20, 10:25, 10:30 games)
 * - Server restarts at 10:35 AM
 * - This function finds the gap and creates missing games
 * - Prevents lost revenue from missing game slots
 * 
 * @returns {Promise<void>}
 */
async function recoverMissedGames() {
    try {
        console.log('🔄 [RECOVERY] Checking for missed game creation...');
        
        const gameStartTime = await getSetting('game_start_time', '08:00');
        const gameEndTime = await getSetting('game_end_time', '22:00');
        
        const gameRepo = AppDataSource.getRepository(GameEntity);
        const now = new Date();
        const istNow = toIST(now);
        
        const startTimeObj = parseTimeString(gameStartTime);
        const endTimeObj = parseTimeString(gameEndTime);
        
        const currentMinutes = istNow.getHours() * 60 + istNow.getMinutes();
        const startMinutes = startTimeObj.hours * 60 + startTimeObj.minutes;
        const endMinutes = endTimeObj.hours * 60 + endTimeObj.minutes;
        
        // Don't create games outside game hours
        if (currentMinutes < startMinutes) {
            console.log(`ℹ️  [RECOVERY] Outside game hours (before ${gameStartTime}). No games to create.`);
            return;
        }
        
        if (currentMinutes >= endMinutes) {
            console.log(`ℹ️  [RECOVERY] Outside game hours (after ${gameEndTime}). No games to create.`);
            return;
        }
        
        // Calculate expected games for TODAY ONLY within game hours
        const expectedGames = [];
        
        // Start from today's game start time
        const todayStart = new Date(istNow);
        todayStart.setHours(startTimeObj.hours, startTimeObj.minutes, 0, 0);
        
        // End at current time (or game end time, whichever is earlier)
        const todayEnd = new Date(istNow);
        const gameEndToday = new Date(istNow);
        gameEndToday.setHours(endTimeObj.hours, endTimeObj.minutes, 0, 0);
        
        const effectiveEnd = istNow < gameEndToday ? istNow : gameEndToday;
        
        // Generate all expected game times for today (every 5 minutes)
        let currentGameTime = new Date(todayStart);
        
        while (currentGameTime <= effectiveEnd) {
            const gameId = formatIST(currentGameTime, 'yyyyMMddHHmm');
            
            // Check if this game exists
            const exists = await gameRepo.findOne({ where: { game_id: gameId } });
            if (!exists) {
                // Only add if it's at least 5 minutes in the past (game should have started)
                const timeDiff = istNow.getTime() - currentGameTime.getTime();
                if (timeDiff >= 0) {
                    expectedGames.push({
                        time: new Date(currentGameTime),
                        gameId
                    });
                }
            }
            
            currentGameTime.setMinutes(currentGameTime.getMinutes() + 5);
        }
        
        if (expectedGames.length === 0) {
            console.log('✅ [RECOVERY] No missed games detected.');
            return;
        }
        
        console.log(`⚠️  [RECOVERY] Found ${expectedGames.length} missing game(s) to create`);
        
        const payoutMultiplier = await getSettingAsNumber('game_multiplier', 10);
        
        // Create missing games
        for (const game of expectedGames) {
            const gameEndTime = new Date(game.time);
            gameEndTime.setMinutes(gameEndTime.getMinutes() + 5);
            
            // Check if game time is within game hours
            const gameHour = game.time.getHours();
            const gameMinute = game.time.getMinutes();
            const gameMinutes = gameHour * 60 + gameMinute;
            
            // Skip games outside operating hours
            if (gameMinutes < startMinutes || gameMinutes >= endMinutes) {
                console.log(`⏭️  [RECOVERY] Skipping game ${game.gameId} (outside operating hours)`);
                continue;
            }
            
            const startTimeUTC = toUTC(game.time);
            const endTimeUTC = toUTC(gameEndTime);
            
            const newGame = gameRepo.create({
                game_id: game.gameId,
                start_time: startTimeUTC,
                end_time: endTimeUTC,
                status: 'pending',
                payout_multiplier: payoutMultiplier,
                settlement_status: 'not_settled',
                created_at: new Date(),
                updated_at: new Date()
            });
            
            await gameRepo.save(newGame);
            console.log(`✅ [RECOVERY] Created missing game: ${game.gameId} (Time: ${formatIST(game.time, 'HH:mm')})`);
        }
        
        console.log(`✅ [RECOVERY] Created ${expectedGames.length} missing game(s)`);
        
    } catch (error) {
        console.error('❌ [RECOVERY] Error recovering missed games:', error);
        // Don't throw - allow server to start even if recovery fails
    }
}

/**
 * Recovery function: Settle all missed games on startup
 * Universal logic: Works in both AUTO and MANUAL modes
 * - AUTO mode: Settles all completed but unsettled games immediately
 * - MANUAL mode: Settles games where more than 10 seconds have passed (grace period expired)
 * This ensures data consistency after server crashes or restarts
 * No games will remain stuck in "not_settled" state
 */
async function recoverMissedSettlements() {
    try {
        console.log('🔄 [RECOVERY] Checking for missed game settlements...');
        
        const gameResultType = await getSetting('game_result_type', 'manual');
        const gameRepo = AppDataSource.getRepository(GameEntity);
        const now = new Date();
        
        // Find ALL completed but unsettled games
        // In both AUTO and MANUAL mode, we need to settle games that have been completed
        // In MANUAL mode: Only settle if more than 10 seconds have passed (grace period)
        // In AUTO mode: Settle all (no time restriction)
        const allMissedGames = await gameRepo
            .createQueryBuilder('game')
            .where('game.status = :status', { status: 'completed' })
            .andWhere('game.settlement_status = :settlementStatus', { settlementStatus: 'not_settled' })
            .orderBy('game.end_time', 'ASC')
            .getMany();
        
        // Filter based on mode and time
        let missedGames = [];
        if (gameResultType === 'auto') {
            // AUTO mode: Settle all completed but unsettled games
            missedGames = allMissedGames;
        } else {
            // MANUAL mode: Only settle games where more than 10 seconds have passed since end_time
            // This provides a grace period for admin to manually select, then auto-settles as fallback
            missedGames = allMissedGames.filter(game => {
                const timeSinceEnd = now.getTime() - game.end_time.getTime();
                return timeSinceEnd > 10000; // More than 10 seconds
            });
        }
        
        if (missedGames.length === 0) {
            if (allMissedGames.length > 0 && gameResultType === 'manual') {
                // Some games exist but are still within grace period
                console.log(`ℹ️  [RECOVERY] Found ${allMissedGames.length} game(s) within 10-second grace period (manual mode). Waiting for admin or auto-settle after grace period.`);
            } else {
                console.log('✅ [RECOVERY] No missed settlements found. All games are up to date.');
            }
            return;
        }
        
        const modeLabel = gameResultType === 'auto' ? 'AUTO MODE' : 'MANUAL MODE (10s grace period expired)';
        console.log(`⚠️  [RECOVERY] [${modeLabel}] Found ${missedGames.length} game(s) that need settlement recovery:`);
        missedGames.forEach(game => {
            const timeSinceEnd = Math.round((now.getTime() - game.end_time.getTime()) / 1000);
            const minutesAgo = Math.floor(timeSinceEnd / 60);
            const secondsAgo = timeSinceEnd % 60;
            if (minutesAgo > 0) {
                console.log(`   - Game ${game.game_id} (ended ${minutesAgo}m ${secondsAgo}s ago)`);
            } else {
                console.log(`   - Game ${game.game_id} (ended ${secondsAgo}s ago)`);
            }
        });
        
        console.log(`🔄 [RECOVERY] Starting automatic settlement recovery for ${missedGames.length} game(s)...`);
        
        const betDetailRepo = AppDataSource.getRepository(BetDetailEntity);
        let successCount = 0;
        let failureCount = 0;
        
        for (const game of missedGames) {
            try {
                // Get bets for smart selection
                const bets = await getTotalBetsPerCard(game.game_id, betDetailRepo);
                
                // Select winning card using smart logic
                const winningCard = selectWinningCard(bets);
                
                // Calculate profit for logging
                const profitAnalysis = calculateProfit(bets, winningCard, parseFloat(game.payout_multiplier || 10));
                
                const timeSinceEnd = Math.round((new Date().getTime() - game.end_time.getTime()) / 1000);
                const minutesAgo = Math.floor(timeSinceEnd / 60);
                
                console.log(`🎲 [RECOVERY] Settling game ${game.game_id} (${minutesAgo} min ago) - Card ${winningCard} selected (Profit: ₹${profitAnalysis.profit.toFixed(2)})`);
                
                // Settle the game (using admin_id = 1 as system user)
                const result = await settleGame(game.game_id, winningCard, 1);
                
                if (result.success) {
                    successCount++;
                    const modeLabel = gameResultType === 'auto' ? 'AUTO' : 'MANUAL (auto-fallback after 10s)';
                    console.log(`✅ [RECOVERY] [${modeLabel}] Game ${game.game_id} settled successfully: Card ${winningCard}, Payout: ₹${result.total_payout.toFixed(2)}`);
                } else {
                    failureCount++;
                    console.error(`❌ [RECOVERY] Failed to settle game ${game.game_id}: ${result.message || 'Unknown error'}`);
                }
            } catch (error) {
                // Transaction errors are normal - another process already settled this game
                if (error.message.includes('Transaction')) {
                    continue; // Skip silently
                }
                
                failureCount++;
                console.error(`❌ [RECOVERY] Error settling game ${game.game_id}:`, error.message);
                
                // Fallback to random selection if smart selection fails
                try {
                    const winningCard = Math.floor(Math.random() * 12) + 1;
                    console.log(`🎲 [RECOVERY] Fallback to random selection for game ${game.game_id}: Card ${winningCard}`);
                    
                    const result = await settleGame(game.game_id, winningCard, 1);
                    if (result.success) {
                        successCount++;
                        failureCount--; // Adjust counts
                        console.log(`✅ [RECOVERY] Game ${game.game_id} settled with fallback: Card ${winningCard}`);
                    }
                } catch (fallbackError) {
                    // Silence transaction errors in fallback
                    if (!fallbackError.message.includes('Transaction')) {
                        console.error(`❌ [RECOVERY] Fallback settlement failed for game ${game.game_id}:`, fallbackError.message);
                    }
                }
            }
        }
        
        console.log(`✅ [RECOVERY] Recovery completed: ${successCount} settled, ${failureCount} failed`);
        
        if (failureCount > 0) {
            console.warn(`⚠️  [RECOVERY] ${failureCount} game(s) could not be settled. Please check manually.`);
        }
        
    } catch (error) {
        console.error('❌ [RECOVERY] Error during recovery process:', error);
        // Don't throw - allow server to start even if recovery fails
    }
}

/**
 * Initialize all game-related cron jobs
 */
export function initializeSchedulers() {
    console.log('📅 Initializing game schedulers...');
    
    // Step 1: Run game state management IMMEDIATELY on startup
    // This ensures any games that should have been completed/activated are processed first
    // This is critical for games that were active when server crashed
    (async () => {
        try {
            console.log('🔄 [STARTUP] Running immediate game state management...');
            const { activatePendingGames, completeActiveGames } = await import('../services/gameService.js');
            
            // Activate any pending games that should have started
            const activationResult = await activatePendingGames();
            if (activationResult.activated > 0) {
                console.log(`✅ [STARTUP] Activated ${activationResult.activated} pending game(s)`);
            }
            
            // Complete any active games that should have ended
            const completionResult = await completeActiveGames();
            if (completionResult.completed > 0) {
                console.log(`✅ [STARTUP] Completed ${completionResult.completed} active game(s) that should have ended`);
            }
            
            console.log('✅ [STARTUP] Game state management completed');
        } catch (error) {
            console.error('❌ [STARTUP] Error in game state management:', error);
        }
        
        // Step 2: Recover any missed game creation BEFORE settling
        // This fills in any games that should have been created but weren't due to scheduler failure
        // Must happen before settlement recovery to ensure all games exist
        try {
            await recoverMissedGames();
        } catch (error) {
            console.error('❌ [STARTUP] Error in game creation recovery:', error);
        }
        
        // Step 3: Run settlement recovery AFTER state management and game creation
        // This ensures any newly completed games are settled
        await recoverMissedSettlements();
    })().catch(error => {
        console.error('❌ [STARTUP] Error in startup sequence:', error);
    });

    // Cron 0: Create Next Game (every 5 minutes) - NEW
    // This creates and activates games continuously every 5 minutes
    // Schedule: '*/5 * * * *' = Every 5 minutes
    cron.schedule('*/5 * * * *', async () => {
        try {
            console.log('🕐 [CRON] Creating next game at', formatIST(new Date(), 'yyyy-MM-dd HH:mm:ss'));
            const result = await createNextGame();
            
            if (result.success) {
                console.log(`✅ [CRON] Created game: ${result.game_id} (Status: ${result.status})`);
            } else {
                console.error('❌ [CRON] Failed to create next game:', result.message);
            }
        } catch (error) {
            console.error('❌ [CRON] Error creating next game:', error);
        }
    }, {
        scheduled: true,
        timezone: 'Asia/Kolkata'
    });

    // Cron 1: DISABLED - Daily Bulk Game Creation at 07:55 IST
    // REASON: Games are now created continuously every 5 minutes via createNextGame()
    // If game creation fails, recovery logic recreates missing games on startup
    // Bulk creation at 07:55 IST caused duplicate games and unnecessary database load
    // 
    // For manual bulk game creation if needed, call createDailyGames() from API endpoint
    // But do not run as a scheduled cron job
    /*
    cron.schedule('25 2 * * *', async () => {
        try {
            console.log('🕐 [CRON] Daily game creation job started at', new Date().toISOString());
            const result = await createDailyGames();
            
            if (result.success) {
                console.log(`✅ [CRON] Daily games created: ${result.gamesCreated} games`);
                if (result.duplicatesSkipped > 0) {
                    console.log(`ℹ️  [CRON] Skipped ${result.duplicatesSkipped} duplicate games`);
                }
            } else {
                console.error('❌ [CRON] Failed to create daily games:', result.message);
            }
        } catch (error) {
            console.error('❌ [CRON] Error in daily game creation:', error);
            // TODO: Send alert to administrator
        }
    }, {
        scheduled: true,
        timezone: 'Asia/Kolkata'
    });
    */

    // Cron 2: Game State Management (every minute)
    // Activate pending games and complete active games
    cron.schedule('* * * * *', async () => {
        try {
            // Activate pending games
            const activationResult = await activatePendingGames();
            if (activationResult.activated > 0) {
                console.log(`✅ [CRON] Activated ${activationResult.activated} games: ${activationResult.gameIds.join(', ')}`);
            }

            // Complete active games
            const completionResult = await completeActiveGames();
            if (completionResult.completed > 0) {
                console.log(`✅ [CRON] Completed ${completionResult.completed} games: ${completionResult.gameIds.join(', ')}`);
            }
        } catch (error) {
            console.error('❌ [CRON] Error in game state management:', error);
        }
    }, {
        scheduled: true,
        timezone: 'Asia/Kolkata'
    });

    // Auto-Settlement (runs every 10 seconds)
    // Behavior:
    // - Auto Mode: Settle immediately (within 5-10 seconds of game completion)
    // - Manual Mode: Wait 10 seconds after game end, then auto-settle if still not settled
    // OPTIMIZED: Only queries games that need settlement, excludes already settled games
    const runAutoSettlement = async () => {
        try {
            // Get game result type setting
            const gameResultType = await getSetting('game_result_type', 'manual');
            
            // OPTIMIZED QUERY: Find games that need settlement
            // 1. Are completed (status = 'completed')
            //    - Note: Active games settled early by admin become 'completed', so they're excluded here
            //    - Active games cannot be auto-settled (only admin can settle them early in manual mode)
            // 2. Are NOT already settled (settlement_status = 'not_settled') - THIS EXCLUDES SETTLED GAMES
            // 3. Universal logic: In both AUTO and MANUAL mode, settle games where more than 10 seconds have passed
            //    - AUTO mode: Settle immediately (5-10 seconds after completion)
            //    - MANUAL mode: Wait 10 seconds grace period, then auto-settle as fallback
            // This ensures no games get stuck in "not_settled" state
            const gameRepo = AppDataSource.getRepository(GameEntity);
            const now = new Date();
            const tenSecondsAgo = new Date(now.getTime() - 10 * 1000);
            
            // Find games that need settlement based on mode
            // AUTO mode: Settle immediately (no grace period needed)
            // MANUAL mode: Wait 10 seconds for admin to manually select, then auto-settle
            const queryBuilder = gameRepo
                .createQueryBuilder('game')
                .where('game.status = :status', { status: 'completed' })
                .andWhere('game.settlement_status = :settlementStatus', { settlementStatus: 'not_settled' });
            
            // In MANUAL mode: Only fetch games older than 10 seconds (grace period expired)
            // In AUTO mode: Fetch all completed games immediately (no grace period)
            if (gameResultType === 'manual') {
                queryBuilder.andWhere('game.end_time <= :tenSecondsAgo', { tenSecondsAgo });
            }
            
            // Use pessimistic locking with SKIP LOCKED to prevent race conditions
            // Each settlement process will lock different games, avoiding conflicts
            const gamesToSettle = await queryBuilder
                .orderBy('game.end_time', 'ASC')
                .take(10)
                .setLock('pessimistic_write', undefined, ['SKIP LOCKED'])
                .getMany();

            // Early exit if no games to process - saves processing time
            if (gamesToSettle.length === 0) {
                return; // No games need settlement - query was fast, no further processing
            }

            console.log(`🔄 [AUTO-SETTLE] Processing ${gamesToSettle.length} game(s) for settlement (Mode: ${gameResultType})...`);

            for (const game of gamesToSettle) {
                try {
                    // Double-check game status before processing (prevents race conditions)
                    // Another settlement process might have grabbed this game between query and processing
                    const freshGame = await gameRepo.findOne({ 
                        where: { game_id: game.game_id } 
                    });
                    
                    if (!freshGame || freshGame.settlement_status !== 'not_settled') {
                        // Game already being settled or settled by another process - skip
                        continue;
                    }
                    
                    // Calculate time since game ended (in milliseconds)
                    const timeSinceEnd = now.getTime() - game.end_time.getTime();
                    const secondsSinceEnd = Math.round(timeSinceEnd / 1000);
                    
                    // Determine settlement timing based on mode
                    let shouldSettle = false;
                    let settlementReason = '';
                    
                    // Universal logic: Settle if more than 10 seconds have passed since game end
                    // This applies to both AUTO and MANUAL modes
                    // - AUTO mode: Settles within 5-10 seconds (immediate)
                    // - MANUAL mode: Waits 10 seconds for admin, then auto-settles as fallback
                    if (timeSinceEnd >= 10000) {
                        shouldSettle = true;
                        if (gameResultType === 'auto') {
                            settlementReason = `Auto mode - immediate settlement (${secondsSinceEnd}s since game end)`;
                        } else {
                            settlementReason = `Manual mode - auto-settling after 10s grace period (${secondsSinceEnd}s since game end)`;
                        }
                    } else {
                        // Still within 10-second grace period - wait (applies to both modes)
                        // In AUTO mode, this is just a brief delay
                        // In MANUAL mode, this gives admin time to manually select
                        continue;
                    }
                    
                    if (shouldSettle) {
                        // Use smart winning card selection logic (profit-optimized)
                        try {
                            const betDetailRepo = AppDataSource.getRepository(BetDetailEntity);
                            
                            // Get bets first (needed for both selection and profit calculation)
                            const bets = await getTotalBetsPerCard(game.game_id, betDetailRepo);
                            
                            // Select winning card using smart logic
                            const winningCard = selectWinningCard(bets);
                            
                            // Calculate profit for logging
                            const profitAnalysis = calculateProfit(bets, winningCard, parseFloat(game.payout_multiplier || 10));
                            
                            console.log(`🎲 [AUTO-SETTLE] Game ${game.game_id} - ${settlementReason}`);
                            console.log(`   📊 Smart selection: Card ${winningCard} selected (Profit: ₹${profitAnalysis.profit.toFixed(2)}, ${profitAnalysis.profit_percentage.toFixed(2)}%)`);

                    // Settle the game (using admin_id = 1 as system user)
                            // This will update settlement_status to 'settled', so next query won't find it
                    const result = await settleGame(game.game_id, winningCard, 1);

                    if (result.success) {
                                const modeLabel = gameResultType === 'auto' ? 'AUTO' : 'MANUAL (auto-fallback)';
                                console.log(`✅ [AUTO-SETTLE] [${modeLabel}] Game ${game.game_id} settled: Card ${winningCard}, Payout: ₹${result.total_payout.toFixed(2)}, Winning Slips: ${result.winning_slips}, Losing Slips: ${result.losing_slips}`);
                                // Game is now marked as 'settled' - won't be found in future queries
                    } else {
                                console.error(`❌ [AUTO-SETTLE] Failed to settle game ${game.game_id}`);
                            }
                        } catch (selectionError) {
                            // Transaction errors are normal in concurrent environments - skip silently
                            if (selectionError.message.includes('Transaction')) {
                                continue; // Another process is handling this game
                            }
                            
                            // Log non-transaction errors
                            console.error(`❌ [AUTO-SETTLE] Error selecting winning card for game ${game.game_id}:`, selectionError.message);
                            
                            // Fallback to random selection if smart selection fails (non-transaction errors only)
                            const winningCard = Math.floor(Math.random() * 12) + 1;
                            console.log(`🎲 [AUTO-SETTLE] Fallback to random selection: Card ${winningCard}`);
                            
                            try {
                                const result = await settleGame(game.game_id, winningCard, 1);
                                if (result.success) {
                                    console.log(`✅ [AUTO-SETTLE] Game ${game.game_id} settled with fallback: Card ${winningCard}`);
                                }
                            } catch (fallbackError) {
                                // Silence transaction errors in fallback too
                                if (!fallbackError.message.includes('Transaction')) {
                                    console.error(`❌ [AUTO-SETTLE] Fallback settlement failed for game ${game.game_id}:`, fallbackError.message);
                                }
                            }
                        }
                    }
                } catch (error) {
                    // Silence transaction errors (normal in concurrent environments)
                    if (!error.message.includes('Transaction')) {
                        console.error(`❌ [AUTO-SETTLE] Error auto-settling game ${game.game_id}:`, error.message);
                    }
                    // Continue with next game even if one fails
                }
            }

        } catch (error) {
            console.error('❌ [AUTO-SETTLE] Error in auto-settlement:', error);
        }
    };

    // Run immediately on startup
    runAutoSettlement();
    
    // Then run every 5 seconds (faster detection for AUTO mode)
    // For MANUAL mode, 10 second grace period applies before auto-settling
    autoSettlementIntervalRef = setInterval(() => {
        runAutoSettlement();
    }, 5000); // 5 seconds = 5000 milliseconds (faster settlement detection)

    console.log('✅ Game schedulers initialized successfully');
    console.log('   - Startup recovery: Game state + missed game creation + settlement');
    console.log('   - Continuous game creation: Every 5 minutes');
    console.log('   - Game state management: Every minute');
    console.log('   - Auto-settlement: Every 5 seconds (faster detection)');
    console.log('   - Fallback: Missed games recreated on next server restart');
}

/**
 * Stop all schedulers (useful for graceful shutdown)
 */
export function stopSchedulers() {
    console.log('🛑 Stopping game schedulers...');
    
    // Clear auto-settlement interval if running
    if (autoSettlementIntervalRef) {
        clearInterval(autoSettlementIntervalRef);
        autoSettlementIntervalRef = null;
        console.log('   - Auto-settlement interval stopped');
    }
    
    // Note: node-cron doesn't provide a direct way to stop all jobs
    // Cron jobs will stop when the process exits
    console.log('✅ Game schedulers stopped');
}


