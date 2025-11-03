-- Manual SQL Script to Add Foreign Key Constraint
-- Run this script if migration system is not available
-- 
-- This ensures bet_details.slip_id has a proper foreign key
-- relationship with bet_slips.id

-- Step 1: Check if foreign key already exists
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

-- Step 2: If no foreign key exists, run this to add it
-- (Remove the comment markers and run)

ALTER TABLE `bet_details`
ADD CONSTRAINT `FK_bet_details_betSlip`
FOREIGN KEY (`slip_id`)
REFERENCES `bet_slips` (`id`)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Step 3: Verify the foreign key was created
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

-- Expected Result:
-- CONSTRAINT_NAME: FK_bet_details_betSlip
-- TABLE_NAME: bet_details
-- COLUMN_NAME: slip_id
-- REFERENCED_TABLE_NAME: bet_slips
-- REFERENCED_COLUMN_NAME: id
-- DELETE_RULE: CASCADE
-- UPDATE_RULE: CASCADE

