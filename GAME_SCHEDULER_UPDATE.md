# Game Scheduler Update - Continuous 5-Minute Game Creation

## Problem
The game scheduler was only creating games once per day at 07:55 IST, which meant:
- Games were not being created continuously
- No active games were available between daily creation cycles
- Users had to wait until the next day for games to be available

## Solution
Implemented continuous game creation that runs every 5 minutes, ensuring games are always available.

## Changes Made

### 1. New Cron Job: Continuous Game Creation (`src/schedulers/gameScheduler.js`)
- **Schedule**: Every 5 minutes (`*/5 * * * *`)
- **Function**: `createNextGame()` from `gameService.js`
- **Purpose**: Creates a new game every 5 minutes during game hours
- **Behavior**:
  - Creates game that starts at the next 5-minute interval
  - Game duration: 5 minutes
  - Automatically activates if start time is within 1 minute
  - Respects game hours settings (default: 08:00 - 22:00 IST)

### 2. New Service Function: `createNextGame()` (`src/services/gameService.js`)
- Calculates next 5-minute interval for game start
- Creates game with appropriate `game_id` (format: YYYYMMDDHHMM)
- Checks if game already exists (prevents duplicates)
- Automatically activates if start time is imminent
- Validates game hours before creation
- Returns detailed result with game information

### 3. Scheduler Initialization
The scheduler now includes:
1. **Continuous Game Creation**: Every 5 minutes (NEW)
2. **Daily Game Creation**: 07:55 IST (backup/initialization)
3. **Game State Management**: Every minute (activate pending, complete active)
4. **Auto-Settlement**: Every minute (if enabled)

## How It Works

### Game Creation Flow
```
Every 5 minutes:
1. Check if within game hours (default: 08:00 - 22:00 IST)
2. Calculate next 5-minute interval (e.g., 10:23 → 10:25)
3. Create game with:
   - Start time: Next 5-minute interval
   - End time: Start time + 5 minutes
   - Status: 'active' (if start within 1 min) or 'pending'
   - game_id: YYYYMMDDHHMM format
4. Save to database
```

### Game Activation Flow
```
Every minute:
1. Find pending games where start_time <= now
2. Update status to 'active'
3. Log activation
```

### Game Completion Flow
```
Every minute:
1. Find active games where end_time <= now
2. Update status to 'completed'
3. Log completion
```

## Configuration

### Settings (via Admin Panel)
- `game_start_time`: Start of game hours (default: "08:00")
- `game_end_time`: End of game hours (default: "22:00")
- `game_multiplier`: Payout multiplier (default: 10)
- `game_result_type`: "auto" or "manual" (default: "manual")

### Timezone
- All times are in **IST (Asia/Kolkata)**
- Stored in database as UTC
- Converted back to IST for display

## Testing

### Manual Test
You can manually trigger game creation:
```javascript
// In Node.js console or test script
import { createNextGame } from './src/services/gameService.js';
const result = await createNextGame();
console.log(result);
```

### Verify Scheduler is Running
Check server logs for:
```
📅 Initializing game schedulers...
✅ Game schedulers initialized successfully
   - Continuous game creation: Every 5 minutes
   - Daily game creation: 07:55 IST (02:25 UTC)
   - Game state management: Every minute
   - Auto-settlement: Every minute (if enabled)
```

### Expected Logs
Every 5 minutes, you should see:
```
🕐 [CRON] Creating next game at 2025-11-02 10:25:00
✅ Created game 202511021025 (Status: active, Start: 10:25, End: 10:30)
✅ [CRON] Created game: 202511021025 (Status: active)
```

## Benefits

1. **Continuous Availability**: Games are always available during game hours
2. **Automatic Activation**: Games activate automatically when start time arrives
3. **No Manual Intervention**: Fully automated game lifecycle
4. **Duplicate Prevention**: Checks for existing games before creation
5. **Configurable Hours**: Respects admin-configured game hours
6. **Fallback**: Daily bulk creation still runs as backup

## Notes

- Games are created in advance (up to 5 minutes ahead)
- If a game already exists, creation is skipped (no error)
- Outside game hours, no games are created
- The minute-by-minute cron ensures games activate/complete on time
- All operations are transactional (rollback on error)

## Future Enhancements

1. Configurable game interval (currently fixed at 5 minutes)
2. Alert system for scheduler failures
3. Dashboard showing next scheduled games
4. Metrics on game creation success rate

---

**Updated**: November 2, 2025
**Status**: ✅ Implemented and Ready for Testing




