/**
 * Game Scheduler
 * Handles automated game creation and state management via cron jobs
 * 
 * @module schedulers/gameScheduler
 */

import cron from 'node-cron';
import { createDailyGames, createNextGame, activatePendingGames, completeActiveGames } from '../services/gameService.js';
import { settleGame } from '../services/settlementService.js';
import { getSetting } from '../utils/settings.js';
import { AppDataSource } from '../config/typeorm.config.js';
import { formatIST } from '../utils/timezone.js';
import { selectWinningCard, calculateProfit, getTotalBetsPerCard } from '../utils/winningCardSelector.js';

const GameEntity = "Game";
const BetDetailEntity = "BetDetail";

// Store interval reference for cleanup
let autoSettlementIntervalRef = null;

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
                    console.error(`❌ [RECOVERY] Fallback settlement also failed for game ${game.game_id}:`, fallbackError.message);
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
        
        // Step 2: Run recovery AFTER state management
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

    // Cron 1: Daily Game Creation at 07:55 IST (02:25 UTC)
    // Schedule: '25 2 * * *' = 02:25 UTC = 07:55 IST
    // This creates all games for the day in bulk (backup/initialization method)
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
            
            // Find games that ended more than 10 seconds ago (grace period expired)
            // This applies to both AUTO and MANUAL modes for consistency
            const gamesToSettle = await gameRepo
                .createQueryBuilder('game')
                .where('game.status = :status', { status: 'completed' })
                .andWhere('game.settlement_status = :settlementStatus', { settlementStatus: 'not_settled' })
                .andWhere('game.end_time <= :tenSecondsAgo', { tenSecondsAgo }) // More than 10 seconds ago
                .orderBy('game.end_time', 'ASC')
                .take(10) // Limit to 10 games per check
                .getMany();

            // Early exit if no games to process - saves processing time
            if (gamesToSettle.length === 0) {
                return; // No games need settlement - query was fast, no further processing
            }

            console.log(`🔄 [AUTO-SETTLE] Processing ${gamesToSettle.length} game(s) for settlement (Mode: ${gameResultType})...`);

            for (const game of gamesToSettle) {
                try {
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
                            console.error(`❌ [AUTO-SETTLE] Error selecting winning card for game ${game.game_id}:`, selectionError.message);
                            // Fallback to random selection if smart selection fails
                            const winningCard = Math.floor(Math.random() * 12) + 1;
                            console.log(`🎲 [AUTO-SETTLE] Fallback to random selection: Card ${winningCard}`);
                            
                            const result = await settleGame(game.game_id, winningCard, 1);
                            if (result.success) {
                                console.log(`✅ [AUTO-SETTLE] Game ${game.game_id} settled with fallback: Card ${winningCard}`);
                            }
                        }
                    }
                } catch (error) {
                    console.error(`❌ [AUTO-SETTLE] Error auto-settling game ${game.game_id}:`, error.message);
                    // Continue with next game even if one fails
                }
            }

        } catch (error) {
            console.error('❌ [AUTO-SETTLE] Error in auto-settlement:', error);
        }
    };

    // Run immediately on startup
    runAutoSettlement();
    
    // Then run every 10 seconds
    autoSettlementIntervalRef = setInterval(() => {
        runAutoSettlement();
    }, 10000); // 10 seconds = 10000 milliseconds

    console.log('✅ Game schedulers initialized successfully');
    console.log('   - Continuous game creation: Every 5 minutes');
    console.log('   - Daily game creation: 07:55 IST (02:25 UTC)');
    console.log('   - Game state management: Every minute');
    console.log('   - Auto-settlement: Every 10 seconds (if enabled)');
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


