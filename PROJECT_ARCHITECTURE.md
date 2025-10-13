# Node.js Backend Project Architecture Guide

## Overview

This document provides a comprehensive guide to the Node.js backend project architecture based on the Factory Sarathi ERP system. The template follows enterprise-grade patterns and best practices for scalable, maintainable applications.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Architecture Patterns](#architecture-patterns)
3. [Technology Stack](#technology-stack)
4. [Database Design](#database-design)
5. [Authentication & Authorization](#authentication--authorization)
6. [API Design](#api-design)
7. [Error Handling](#error-handling)
8. [Logging & Monitoring](#logging--monitoring)
9. [Security Considerations](#security-considerations)
10. [Development Workflow](#development-workflow)
11. [Deployment Guide](#deployment-guide)

## Project Structure

```
project-root/
├── src/                          # Source code
│   ├── app.js                    # Express app configuration
│   ├── server.js                 # Server entry point
│   ├── config/                   # Configuration files
│   │   └── typeorm.config.js     # Database configuration
│   ├── controllers/              # Route controllers
│   │   ├── authController.js     # Authentication logic
│   │   ├── userController.js     # User management
│   │   └── [feature]Controller.js # Feature controllers
│   ├── entities/                  # Database entities
│   │   ├── user/                 # User-related entities
│   │   │   ├── User.js           # User entity
│   │   │   ├── Role.js           # Role entity
│   │   │   └── Department.js      # Department entity
│   │   └── [feature]/            # Feature entities
│   ├── middleware/               # Custom middleware
│   │   ├── auth.js               # Authentication middleware
│   │   ├── errorHandler.js       # Error handling
│   │   └── validate.js            # Request validation
│   ├── routes/                   # API routes
│   │   ├── index.js              # Route aggregator
│   │   ├── auth.js                # Authentication routes
│   │   └── user.js                # User routes
│   ├── services/                 # Business logic
│   │   ├── userService.js         # User business logic
│   │   └── [feature]Service.js    # Feature services
│   └── utils/                    # Utility functions
│       ├── logger/               # Logging utilities
│       ├── token.js              # JWT utilities
│       ├── mailer.js             # Email utilities
│       └── validation.js          # Validation utilities
├── public/                       # Static files
├── uploads/                      # File uploads
├── logs/                         # Application logs
├── migrations/                   # Database migrations
└── docs/                         # Documentation
```

## Architecture Patterns

### 1. **Layered Architecture**
- **Controllers**: Handle HTTP requests/responses
- **Services**: Business logic and data processing
- **Entities**: Database models and relationships
- **Utils**: Common functionality and helpers

### 2. **MVC Pattern**
- **Models**: TypeORM entities
- **Views**: JSON API responses
- **Controllers**: Request handling logic

### 3. **Repository Pattern**
- Database operations through TypeORM repositories
- Centralized data access logic
- Easy testing and mocking

### 4. **Middleware Pattern**
- Request/response processing pipeline
- Authentication, validation, logging
- Error handling and security

## Technology Stack

### Core Technologies
- **Node.js**: Runtime environment
- **Express.js**: Web framework
- **TypeORM**: Object-relational mapping
- **MariaDB/MySQL**: Database
- **JWT**: Authentication tokens

### Supporting Libraries
- **bcrypt**: Password hashing
- **joi**: Request validation
- **winston**: Logging
- **nodemailer**: Email sending
- **cors**: Cross-origin resource sharing
- **morgan**: HTTP request logging

### Development Tools
- **nodemon**: Development server
- **jest**: Testing framework
- **eslint**: Code linting
- **prettier**: Code formatting

## Database Design

### Entity Relationships
```
User (1) ←→ (M) Role
User (M) ←→ (1) Department
User (1) ←→ (M) RefreshToken
```

### Key Entities
- **User**: Core user information
- **Role**: User roles and permissions
- **Department**: Organizational units
- **RefreshToken**: JWT refresh tokens

### Database Features
- **Migrations**: Schema versioning
- **Indexes**: Performance optimization
- **Constraints**: Data integrity
- **Relationships**: Foreign key constraints

## Authentication & Authorization

### JWT Implementation
- **Access Tokens**: Short-lived (15 minutes)
- **Refresh Tokens**: Long-lived (7 days)
- **Token Rotation**: Security best practices
- **Cookie Storage**: HTTP-only cookies

### Role-Based Access Control
- **Roles**: Hierarchical permission system
- **Permissions**: Granular access control
- **Middleware**: Route protection
- **Validation**: Permission checking

### Security Features
- **Password Hashing**: bcrypt with salt
- **Token Expiry**: Automatic expiration
- **CSRF Protection**: SameSite cookies
- **Rate Limiting**: Request throttling

## API Design

### RESTful Conventions
- **GET**: Retrieve resources
- **POST**: Create resources
- **PUT**: Update resources
- **DELETE**: Remove resources
- **PATCH**: Partial updates

### Response Format
```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful",
  "pagination": { ... }
}
```

### Error Format
```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error information"
}
```

### API Endpoints
- **Authentication**: `/api/auth/*`
- **Users**: `/api/user/*`
- **Features**: `/api/[feature]/*`

## Error Handling

### Error Types
- **Validation Errors**: 400 Bad Request
- **Authentication Errors**: 401 Unauthorized
- **Authorization Errors**: 403 Forbidden
- **Not Found Errors**: 404 Not Found
- **Server Errors**: 500 Internal Server Error

### Error Handling Strategy
- **Global Error Handler**: Centralized error processing
- **Custom Error Classes**: Specific error types
- **Error Logging**: Comprehensive error tracking
- **User-Friendly Messages**: Clear error communication

## Logging & Monitoring

### Logging Levels
- **Error**: Critical errors
- **Warn**: Warning messages
- **Info**: General information
- **Debug**: Detailed debugging

### Log Destinations
- **Console**: Development logging
- **Files**: Persistent logging
- **Metrics**: Performance monitoring

### Monitoring Features
- **Request Tracking**: HTTP request logging
- **Performance Metrics**: Response time monitoring
- **Error Tracking**: Error rate monitoring
- **Health Checks**: System status monitoring

## Security Considerations

### Input Validation
- **Request Validation**: Joi schema validation
- **SQL Injection**: Parameterized queries
- **XSS Prevention**: Input sanitization
- **CSRF Protection**: Token validation

### Authentication Security
- **Password Security**: Strong password requirements
- **Token Security**: Secure token storage
- **Session Management**: Proper session handling
- **Rate Limiting**: Brute force protection

### Data Protection
- **Encryption**: Sensitive data encryption
- **Access Control**: Role-based permissions
- **Audit Logging**: Security event tracking
- **Data Privacy**: GDPR compliance

## Development Workflow

### Setup Process
1. **Clone Repository**: Get project code
2. **Install Dependencies**: `npm install`
3. **Environment Setup**: Configure `.env`
4. **Database Setup**: Create database
5. **Run Migrations**: `npm run migration:run`
6. **Start Development**: `npm run dev`

### Development Commands
```bash
# Start development server
npm run dev

# Run tests
npm test

# Generate migration
npm run migration:generate -- -n MigrationName

# Run migrations
npm run migration:run

# Revert migration
npm run migration:revert
```

### Code Quality
- **ESLint**: Code linting
- **Prettier**: Code formatting
- **TypeScript**: Type checking
- **Jest**: Unit testing

## Deployment Guide

### Production Setup
1. **Environment Configuration**: Production environment variables
2. **Database Configuration**: Production database setup
3. **Security Configuration**: SSL/TLS setup
4. **Monitoring Setup**: Logging and monitoring
5. **Backup Strategy**: Data backup and recovery

### Deployment Options
- **Docker**: Containerized deployment
- **PM2**: Process management
- **Nginx**: Reverse proxy
- **Cloud Platforms**: AWS, Azure, GCP

### Performance Optimization
- **Database Indexing**: Query optimization
- **Caching**: Redis caching
- **CDN**: Static file delivery
- **Load Balancing**: Traffic distribution

## Best Practices

### Code Organization
- **Modular Structure**: Feature-based organization
- **Separation of Concerns**: Clear responsibility boundaries
- **DRY Principle**: Don't repeat yourself
- **SOLID Principles**: Object-oriented design

### Database Best Practices
- **Normalization**: Proper table design
- **Indexing**: Performance optimization
- **Migrations**: Schema versioning
- **Backups**: Regular data backups

### Security Best Practices
- **Input Validation**: Always validate input
- **Authentication**: Secure authentication
- **Authorization**: Proper access control
- **Monitoring**: Security monitoring

### Performance Best Practices
- **Database Optimization**: Efficient queries
- **Caching**: Strategic caching
- **Monitoring**: Performance tracking
- **Scaling**: Horizontal scaling

## Conclusion

This architecture provides a solid foundation for building scalable, maintainable Node.js applications. The modular structure, comprehensive error handling, and security features ensure robust application development. Follow the established patterns and best practices for optimal results.

For specific implementation details, refer to the individual component documentation in each directory.
