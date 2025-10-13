# Migrations Directory

This directory contains database migration files that manage schema changes over time.

## Purpose

Migrations provide:
- **Version control** for database schema
- **Incremental changes** to database structure
- **Rollback capability** for schema changes
- **Team collaboration** on database changes
- **Production deployment** of schema updates

## Structure

```
migrations/
├── 1234567890123-CreateUserTable.js      # User table creation
├── 1234567890124-AddUserRoles.js         # Add roles to users
├── 1234567890125-CreateProductTable.js   # Product table creation
├── 1234567890126-AddIndexes.js           # Performance indexes
└── README.md                             # This file
```

## Migration Files

### Naming Convention
- **Format**: `{timestamp}-{Description}.js`
- **Timestamp**: Unix timestamp in milliseconds
- **Description**: PascalCase description of the change
- **Examples**:
  - `1704067200000-CreateUserTable.js`
  - `1704067200001-AddUserRoles.js`
  - `1704067200002-CreateProductTable.js`

### File Structure
```javascript
import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateUserTable1704067200000 implements MigrationInterface {
    name = 'CreateUserTable1704067200000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Migration logic here
        await queryRunner.query(`
            CREATE TABLE \`users\` (
                \`id\` int NOT NULL AUTO_INCREMENT,
                \`fname\` varchar(255) NOT NULL,
                \`lname\` varchar(255) NOT NULL,
                \`email\` varchar(255) NOT NULL,
                \`createdAt\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
                \`updatedAt\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
                PRIMARY KEY (\`id\`)
            ) ENGINE=InnoDB
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Rollback logic here
        await queryRunner.query(`DROP TABLE \`users\``);
    }
}
```

## Migration Types

### 1. **Table Creation**
```javascript
public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
        CREATE TABLE \`products\` (
            \`id\` int NOT NULL AUTO_INCREMENT,
            \`name\` varchar(255) NOT NULL,
            \`price\` decimal(10,2) NOT NULL,
            \`createdAt\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
            PRIMARY KEY (\`id\`)
        ) ENGINE=InnoDB
    `);
}
```

### 2. **Table Modification**
```javascript
public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE \`users\` ADD \`phone\` varchar(20) NULL`);
}
```

### 3. **Index Creation**
```javascript
public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`CREATE INDEX \`IDX_user_email\` ON \`users\` (\`email\`)`);
}
```

### 4. **Foreign Key Constraints**
```javascript
public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
        ALTER TABLE \`orders\` 
        ADD CONSTRAINT \`FK_orders_user_id\` 
        FOREIGN KEY (\`userId\`) REFERENCES \`users\`(\`id\`) ON DELETE CASCADE
    `);
}
```

### 5. **Data Migration**
```javascript
public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
        UPDATE \`users\` 
        SET \`status\` = 'active' 
        WHERE \`status\` IS NULL
    `);
}
```

## Migration Commands

### Generate Migration
```bash
# Generate new migration
npm run migration:generate -- -n CreateUserTable

# Generate migration with specific name
npm run migration:generate -- -n AddUserRoles
```

### Run Migrations
```bash
# Run all pending migrations
npm run migration:run

# Run specific migration
npm run migration:run -- -n CreateUserTable
```

### Revert Migrations
```bash
# Revert last migration
npm run migration:revert

# Revert to specific migration
npm run migration:revert -- -n CreateUserTable
```

### Show Migration Status
```bash
# Show migration status
npm run typeorm migration:show
```

## Best Practices

### 1. **Migration Design**
- **Keep migrations small** and focused
- **Test migrations** on development data
- **Always provide rollback** (down method)
- **Use transactions** for complex migrations
- **Avoid data loss** in migrations

### 2. **Naming Conventions**
- **Use descriptive names** for migrations
- **Follow consistent patterns** for similar changes
- **Include table names** in migration names
- **Use PascalCase** for migration names

### 3. **Data Safety**
- **Backup data** before running migrations
- **Test rollback procedures** thoroughly
- **Use staging environment** for testing
- **Monitor migration performance** on large tables

### 4. **Team Collaboration**
- **Coordinate migrations** with team members
- **Review migration code** before committing
- **Document complex migrations** with comments
- **Use version control** for migration files

## Common Migration Patterns

### Adding Columns
```javascript
public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE \`users\` ADD \`phone\` varchar(20) NULL`);
    await queryRunner.query(`ALTER TABLE \`users\` ADD \`address\` text NULL`);
}

public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE \`users\` DROP COLUMN \`address\``);
    await queryRunner.query(`ALTER TABLE \`users\` DROP COLUMN \`phone\``);
}
```

### Creating Indexes
```javascript
public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`CREATE INDEX \`IDX_user_email\` ON \`users\` (\`email\`)`);
    await queryRunner.query(`CREATE INDEX \`IDX_user_created_at\` ON \`users\` (\`createdAt\`)`);
}

public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX \`IDX_user_created_at\` ON \`users\``);
    await queryRunner.query(`DROP INDEX \`IDX_user_email\` ON \`users\``);
}
```

### Data Transformation
```javascript
public async up(queryRunner: QueryRunner): Promise<void> {
    // Transform existing data
    await queryRunner.query(`
        UPDATE \`users\` 
        SET \`fullName\` = CONCAT(\`fname\`, ' ', \`lname\`)
        WHERE \`fullName\` IS NULL
    `);
}

public async down(queryRunner: QueryRunner): Promise<void> {
    // Revert data transformation
    await queryRunner.query(`UPDATE \`users\` SET \`fullName\` = NULL`);
}
```

## Troubleshooting

### Common Issues

1. **Migration Fails**
   - Check database connection
   - Verify SQL syntax
   - Check table/column existence
   - Review error messages

2. **Rollback Issues**
   - Ensure down method is implemented
   - Check for data dependencies
   - Verify rollback SQL syntax
   - Test rollback procedures

3. **Performance Issues**
   - Add indexes for large tables
   - Use batch operations for large datasets
   - Consider migration timing
   - Monitor database performance

### Debug Commands
```bash
# Check migration status
npm run typeorm migration:show

# Run migration with verbose output
npm run typeorm migration:run -- --verbose

# Check database schema
npm run typeorm schema:log
```

## Production Considerations

### Deployment Strategy
1. **Backup database** before migrations
2. **Test migrations** on staging environment
3. **Schedule migrations** during maintenance windows
4. **Monitor migration progress** in production
5. **Have rollback plan** ready

### Performance Optimization
1. **Add indexes** before data migration
2. **Use batch operations** for large datasets
3. **Consider migration timing** for high-traffic systems
4. **Monitor database performance** during migrations
5. **Use connection pooling** for large migrations

### Monitoring
1. **Log migration progress** and timing
2. **Monitor database performance** during migrations
3. **Set up alerts** for migration failures
4. **Track migration history** and success rates
5. **Document migration procedures** for team
