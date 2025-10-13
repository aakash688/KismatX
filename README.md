# KismatX

A simple and engaging prediction-based game where players choose 1 card out of 12. If the selected card matches the randomly chosen winning card, the player wins 10X their investment. Built for fun, luck, and high-stakes excitement!

## Project Architecture Overview

This project follows a modular, enterprise-grade architecture with:
- **Express.js** with ES6 modules
- **TypeORM** for database management
- **JWT Authentication** with refresh tokens
- **Role-based access control**
- **Comprehensive logging and monitoring**
- **File upload handling**
- **Email services**
- **API documentation with Swagger**

## Quick Start

1. Clone this repository
2. Run `npm install` to install dependencies
3. Configure your environment variables in `.env`
4. Set up your database connection
5. Run `npm run dev` to start development server

## Project Structure

```
project-root/
├── src/                          # Source code
│   ├── app.js                    # Express app configuration
│   ├── server.js                 # Server entry point
│   ├── config/                   # Configuration files
│   ├── controllers/              # Route controllers
│   ├── entities/                 # Database entities/models
│   ├── middleware/               # Custom middleware
│   ├── routes/                   # API routes
│   ├── services/                 # Business logic services
│   └── utils/                    # Utility functions
├── public/                       # Static files and web interfaces
│   ├── api_page.html             # API documentation page
│   ├── dashboard.html            # Admin dashboard
│   ├── [feature]_test.html       # Feature testing pages
│   └── css/                      # Stylesheets
├── uploads/                      # File uploads and user content
│   ├── profilePhoto/             # User profile pictures
│   ├── documents/                # Document uploads
│   ├── temp/                     # Temporary files
│   └── exports/                  # Data exports
├── logs/                         # Application logs
│   ├── combined.log              # All application logs
│   ├── error.log                 # Error logs only
│   └── access.log                # HTTP request logs
├── migrations/                   # Database schema migrations
│   ├── [timestamp]-CreateUserTable.js
│   └── [timestamp]-AddUserRoles.js
├── assets/                       # Static assets and resources
│   ├── fonts/                    # Font files
│   ├── icons/                    # Icon libraries
│   ├── images/                   # Image assets
│   └── templates/                # Document templates
├── docs/                         # Project documentation
│   ├── api/                      # API documentation
│   ├── architecture/             # System architecture
│   ├── development/              # Development guides
│   └── deployment/               # Deployment guides
└── tests/                        # Test files and test data
    ├── unit/                     # Unit tests
    ├── integration/              # Integration tests
    └── fixtures/                 # Test data
```

## Key Features

- **Authentication & Authorization**: JWT-based auth with role management
- **Database Management**: TypeORM with MariaDB/MySQL support
- **File Handling**: Profile photos and document uploads
- **Logging**: Winston-based logging with metrics
- **Monitoring**: Express status monitor and Prometheus metrics
- **API Documentation**: Swagger/OpenAPI integration
- **Error Handling**: Centralized error management
- **Validation**: Joi-based request validation

## Environment Variables

Create a `.env` file with the following variables:

```env
# Database
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=KismatX

# JWT Secrets
ACCESS_TOKEN_SECRET=your_access_token_secret
REFRESH_TOKEN_SECRET=your_refresh_token_secret

# Server
PORT=5001
NODE_ENV=development

# Email (Optional)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_app_password
```

## Development Commands

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start

# Run database migrations
npm run migration:run

# Generate new migration
npm run migration:generate -- -n MigrationName
```

## Next Steps

1. Review the folder structure and documentation
2. Customize the entities for your specific domain
3. Add your business logic in controllers and services
4. Configure your database and run migrations
5. Set up your authentication and authorization rules
6. Add your API endpoints and documentation

For detailed information about each component, see the individual README files in each folder.
