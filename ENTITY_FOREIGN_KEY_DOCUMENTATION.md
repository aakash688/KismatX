# Foreign Key in Entity Definition - Auto-Creation Guide

## ✅ Current Status: Foreign Key is Defined in Entity

The foreign key relationship between `bet_details.slip_id` and `bet_slips.id` is **already defined** in the entity file and will be automatically created when:

1. **TypeORM Synchronization** is enabled (`synchronize: true`)
2. **Migrations** are run on a new server

## Entity Definition

### BetDetail Entity (`src/entities/game/BetDetail.js`)

```javascript
relations: {
  betSlip: {
    target: "BetSlip",
    type: "many-to-one",
    joinColumn: {
      name: "slip_id",
      referencedColumnName: "id",
      onDelete: "CASCADE",    // ✅ Cascade delete
      onUpdate: "CASCADE",    // ✅ Cascade update
    },
  },
}
```

This definition will automatically create the foreign key constraint:
```sql
FOREIGN KEY (`slip_id`) 
REFERENCES `bet_slips` (`id`) 
ON DELETE CASCADE 
ON UPDATE CASCADE
```

## How It Works on New Servers

### Option 1: Using TypeORM Synchronization (Development)

If you enable synchronization in `src/config/typeorm.config.js`:

```javascript
export const AppDataSource = new DataSource({
  // ... other config
  synchronize: true,  // ⚠️ ONLY for development!
  // ...
});
```

When the server starts, TypeORM will:
- ✅ Read all entity definitions
- ✅ Create tables with proper foreign keys
- ✅ Create indexes
- ✅ Set up relationships

**⚠️ Warning**: `synchronize: true` is NOT recommended for production as it can cause data loss!

### Option 2: Using Migrations (Production Recommended)

For production servers, use migrations:

#### Step 1: Run All Migrations

```bash
npm run migration:run
```

This will execute:
- ✅ All migration files in `src/migrations/`
- ✅ Including `20241201160000-AddBetDetailsForeignKey.js`
- ✅ Creates foreign key constraint automatically

#### Step 2: Verify Migration

Check if the foreign key exists:

```sql
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME,
    DELETE_RULE,
    UPDATE_RULE
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'bet_details'
    AND CONSTRAINT_NAME = 'FK_bet_details_betSlip';
```

## Migration File

A migration file has been created: `src/migrations/20241201160000-AddBetDetailsForeignKey.js`

This migration:
- ✅ Checks if foreign key already exists
- ✅ Adds the constraint if missing
- ✅ Includes CASCADE options
- ✅ Can be safely run multiple times (idempotent)

## Setup for New Server

### Quick Setup Script

1. **Clone repository**
2. **Install dependencies**: `npm install`
3. **Configure database**: Update `.env` with database credentials
4. **Run migrations**: `npm run migration:run`

That's it! All tables and foreign keys will be created automatically.

### Manual Verification

After setup, verify the foreign key:

```sql
SHOW CREATE TABLE bet_details;
```

You should see:
```sql
CONSTRAINT `FK_bet_details_betSlip` 
FOREIGN KEY (`slip_id`) 
REFERENCES `bet_slips` (`id`) 
ON DELETE CASCADE 
ON UPDATE CASCADE
```

## Benefits of Having It in Entity

1. ✅ **Automatic Creation**: Foreign key is created when tables are created
2. ✅ **Code as Documentation**: Relationship is clear in the code
3. ✅ **TypeORM Support**: Full TypeORM relationship support (eager loading, etc.)
4. ✅ **Migration Support**: Migrations can be generated from entity changes
5. ✅ **Consistency**: Same definition across all environments

## Summary

| Method | When to Use | Auto-Creates FK? |
|--------|-------------|------------------|
| Entity Definition | Always | ✅ Yes (with synchronize or migrations) |
| Migration File | Production | ✅ Yes |
| Manual SQL | Emergency fixes | ❌ No |

**Recommendation**: 
- ✅ Keep the entity definition (already done)
- ✅ Use migrations for deployment (already created)
- ✅ Both ensure foreign keys are created automatically

---

**Status**: ✅ Complete
- Entity has foreign key definition
- Migration file created
- Ready for new server deployment




