# Configuration Directory

This directory contains all configuration files for your application.

## Files

- **typeorm.config.js**: Database configuration using TypeORM

## Configuration Guidelines

1. **Database Config**: Use environment variables for database credentials
2. **Connection Pool**: Configure appropriate pool size for your application
3. **Logging**: Enable database logging in development, disable in production
4. **Synchronize**: Set to false in production, use migrations instead
5. **Entities**: Use glob patterns to automatically load entity files

## Environment Variables

Make sure to set these environment variables:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=your_database
```

## Database Setup

1. Create your database
2. Configure connection in typeorm.config.js
3. Run migrations: `npm run migration:run`
4. Verify connection in server startup logs

## Production Considerations

- Set `synchronize: false` in production
- Use migrations for schema changes
- Configure proper connection pooling
- Set up database monitoring
- Use connection string for cloud databases
