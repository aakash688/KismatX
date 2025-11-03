-- QUICK FIX: Add Foreign Key for bet_details.slip_id → bet_slips.id
-- Copy and paste this into your phpMyAdmin SQL console or MySQL client

-- First, check if foreign key already exists (optional)
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
    AND COLUMN_NAME = 'slip_id'
    AND REFERENCED_TABLE_NAME IS NOT NULL;

-- If no results, run this to add the foreign key:
ALTER TABLE `bet_details`
ADD CONSTRAINT `FK_bet_details_betSlip`
FOREIGN KEY (`slip_id`)
REFERENCES `bet_slips` (`id`)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Verify it was created:
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




