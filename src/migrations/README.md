# Database Migrations

This directory contains TypeORM migration files for database schema changes.

## Migration Files

### 1. `20241201120000-AddSettlementToGames.js`
**Purpose**: Add settlement tracking fields to the `games` table

**Changes**:
- Adds `settlement_status` enum field (not_settled, settling, settled, failed)
- Adds `settlement_started_at` datetime field
- Adds `settlement_completed_at` datetime field
- Adds `settlement_error` text field
- Adds indexes: `idx_settlement`, `idx_status`, `idx_time_range`

### 2. `20241201130000-UpdateBetSlipsForClaim.js`
**Purpose**: Update `bet_slips` table for claim tracking and UUID support

**Changes**:
- Changes `slip_id` from VARCHAR(50) to VARCHAR(36) for UUID v4 format
- Adds `claimed` boolean field
- Adds `claimed_at` datetime field
- Adds `idempotency_key` unique varchar field
- Updates `status` enum to include 'won'
- Renames `total_payout` to `payout_amount`
- Adds indexes: `idx_user_game`, `idx_claim`, `idx_idempotency`

### 3. `20241201140000-AddIndexesToBetDetails.js`
**Purpose**: Add performance indexes and foreign key to `bet_details` table

**Changes**:
- Adds `game_id` and `user_id` columns if they don't exist
- Adds indexes: `idx_game_card`, `idx_game_winner`, `idx_slip`
- Adds foreign key constraint on `slip_id` with CASCADE delete

### 4. `20241201150000-AddReferenceToWalletLogs.js`
**Purpose**: Add reference tracking to `wallet_logs` table

**Changes**:
- Adds `reference_type` varchar field (bet_placement, settlement, claim)
- Adds `reference_id` varchar field (slip_id or game_id)
- Adds `status` enum field (pending, completed, failed)

## Running Migrations

### Using TypeORM CLI

```bash
# Run all pending migrations
npm run migration:run

# Revert last migration
npm run migration:revert

# Show migration status
npm run migration:show
```

### Manual Execution

Migrations can also be executed manually using TypeORM:

```javascript
import { AppDataSource } from './config/typeorm.config.js';

await AppDataSource.initialize();
await AppDataSource.runMigrations();
```

## Rollback

To rollback a migration, use the TypeORM CLI:

```bash
npm run migration:revert
```

Each migration includes a `down()` method that reverses all changes made in the `up()` method.

## Important Notes

1. **Backup First**: Always backup your database before running migrations in production
2. **Test Environment**: Test migrations in a development environment first
3. **Data Migration**: These migrations focus on schema changes. Data migration scripts may be needed separately
4. **Foreign Keys**: The BetDetails migration adds a foreign key with CASCADE delete - ensure this is the desired behavior

## Schema Status

- ✅ **Settings Table**: Already exists and matches requirements
- ✅ **Games Table**: Updated with settlement tracking
- ✅ **Bet Slips Table**: Updated with UUID, claimed, and idempotency fields
- ✅ **Bet Details Table**: Updated with indexes and foreign key
- ✅ **Wallet Logs Table**: Updated with reference tracking








