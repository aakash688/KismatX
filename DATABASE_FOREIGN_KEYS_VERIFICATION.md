# Database Foreign Key Relationship Verification

## BetDetail → BetSlip Relationship

### Current Status: ✅ CORRECTLY DEFINED

The `bet_details` table **already has** a foreign key relationship with `bet_slips` table through `slip_id`.

### Entity Definition

#### BetDetail Entity (`src/entities/game/BetDetail.js`)

```javascript
columns: {
  slip_id: {
    type: "bigint",
    nullable: false,
  },
  // ... other columns
},
relations: {
  betSlip: {
    target: "BetSlip",
    type: "many-to-one",
    joinColumn: {
      name: "slip_id",
      referencedColumnName: "id",  // References bet_slips.id
    },
    onDelete: "CASCADE",
  },
}
```

#### BetSlip Entity (`src/entities/game/BetSlip.js`)

```javascript
columns: {
  id: {
    primary: true,
    type: "bigint",
    generated: true,
  },
  // ... other columns
},
relations: {
  betDetails: {
    target: "BetDetail",
    type: "one-to-many",
    inverseSide: "betSlip",
  },
}
```

## Relationship Structure

```
bet_slips (parent)
├── id (PK, bigint)
└── ...

bet_details (child)
├── id (PK, bigint)
├── slip_id (FK → bet_slips.id) ✅
└── ...
```

### Relationship Type
- **Type**: Many-to-One (BetDetail → BetSlip)
- **Cardinality**: 
  - One `BetSlip` can have many `BetDetail` records
  - Each `BetDetail` belongs to exactly one `BetSlip`
- **Cascade**: `onDelete: "CASCADE"` - If a BetSlip is deleted, all its BetDetails are automatically deleted

## Database Schema

When TypeORM synchronizes, it should create:

```sql
CREATE TABLE `bet_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `slip_id` bigint NOT NULL,
  `card_number` tinyint NOT NULL,
  `bet_amount` decimal(18,2) NOT NULL,
  -- ... other columns
  PRIMARY KEY (`id`),
  KEY `idx_slip` (`slip_id`),
  CONSTRAINT `FK_bet_details_betSlip` 
    FOREIGN KEY (`slip_id`) 
    REFERENCES `bet_slips` (`id`) 
    ON DELETE CASCADE
);
```

## Verification Steps

### 1. Check if Foreign Key Exists in Database

Run this SQL query to verify:

```sql
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME,
    DELETE_RULE
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'bet_details'
    AND REFERENCED_TABLE_NAME IS NOT NULL;
```

Expected result:
```
CONSTRAINT_NAME: FK_bet_details_betSlip (or similar)
TABLE_NAME: bet_details
COLUMN_NAME: slip_id
REFERENCED_TABLE_NAME: bet_slips
REFERENCED_COLUMN_NAME: id
DELETE_RULE: CASCADE
```

### 2. Check Entity Relationships

The relationship is correctly defined as:
- **BetDetail.betSlip**: Many-to-One (BetDetail → BetSlip)
- **BetSlip.betDetails**: One-to-Many (BetSlip → BetDetail[])

## Usage Example

```javascript
// Get bet details with their slip
const betDetail = await betDetailRepo.findOne({
  where: { id: 1 },
  relations: ['betSlip']
});

// Get bet slip with all its details
const betSlip = await betSlipRepo.findOne({
  where: { id: 1 },
  relations: ['betDetails']
});

console.log(betSlip.betDetails); // Array of BetDetail entities
```

## Notes

1. ✅ **Foreign Key is Already Defined**: The relationship exists in the entity definition
2. ✅ **Cascade Delete**: When a BetSlip is deleted, all related BetDetails are automatically deleted
3. ✅ **Index on slip_id**: There's an index on `slip_id` for query performance (`idx_slip`)
4. ✅ **Bidirectional Relationship**: Both sides of the relationship are defined

## If Foreign Key is Missing in Database

Since TypeORM is configured with `synchronize: false`, the foreign key might not exist in the database even though it's defined in the entity.

### Option 1: Run the Migration (Recommended)

A migration file has been created at `src/migrations/AddBetDetailsForeignKey.js`:

```bash
# Run the migration
npm run migration:run
```

Or manually execute the SQL in `ADD_FOREIGN_KEY_MANUAL.sql`

### Option 2: Manual SQL Script

Run the SQL script provided in `ADD_FOREIGN_KEY_MANUAL.sql`:

```sql
ALTER TABLE `bet_details`
ADD CONSTRAINT `FK_bet_details_betSlip`
FOREIGN KEY (`slip_id`)
REFERENCES `bet_slips` (`id`)
ON DELETE CASCADE
ON UPDATE CASCADE;
```

### Option 3: Enable Synchronization (Development Only)

⚠️ **Warning**: Only for development, not recommended for production!

Temporarily set `synchronize: true` in `typeorm.config.js`, restart server, then set it back to `false`.

### Verification Query

After adding the foreign key, verify it exists:

```sql
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME,
    DELETE_RULE
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'bet_details'
    AND CONSTRAINT_NAME = 'FK_bet_details_betSlip';
```

---

**Status**: ✅ Relationship is correctly defined in entities
**Action Required**: Verify foreign key exists in database, create migration if missing

