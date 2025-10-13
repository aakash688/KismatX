# Source Code Directory

This directory contains all the source code for your Node.js backend application.

## Directory Structure

```
src/
├── app.js                    # Express application configuration
├── server.js                 # Server entry point and startup
├── config/                   # Configuration files
│   └── typeorm.config.js     # Database configuration
├── controllers/              # Route controllers (business logic)
├── entities/                 # Database entities/models
├── middleware/               # Custom middleware functions
├── routes/                   # API route definitions
├── services/                 # Business logic services
└── utils/                    # Utility functions and helpers
```

## Key Files

- **app.js**: Express app setup, middleware configuration, and route mounting
- **server.js**: Server startup, database connection, and error handling
- **config/**: Database and application configuration
- **controllers/**: Handle HTTP requests and responses
- **entities/**: Define database schema using TypeORM
- **middleware/**: Authentication, validation, and error handling
- **routes/**: Define API endpoints and route handlers
- **services/**: Business logic and data processing
- **utils/**: Helper functions, logging, and utilities

## Development Guidelines

1. **Controllers**: Keep controllers thin, delegate business logic to services
2. **Entities**: Use TypeORM EntitySchema for database models
3. **Middleware**: Create reusable middleware for common functionality
4. **Routes**: Organize routes by feature/module
5. **Services**: Implement complex business logic in services
6. **Utils**: Create utility functions for common operations

## File Naming Conventions

- Use camelCase for file names
- Use descriptive names that indicate purpose
- Group related files in subdirectories
- Use consistent naming patterns across the project
