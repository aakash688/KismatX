# Middleware Directory

This directory contains custom middleware functions for the Express application.

## Purpose

Middleware functions handle cross-cutting concerns like authentication, validation, error handling, and request processing.

## Structure

```
middleware/
├── auth.js                    # Authentication middleware
├── errorHandler.js           # Global error handler
├── notFoundHandler.js        # 404 handler
├── validate.js               # Request validation
├── checkPermission.js        # Permission checking
├── formatDates.js            # Date formatting
└── README.md                 # This file
```

## Middleware Guidelines

### 1. **Authentication Middleware**
- Verify JWT tokens
- Check user permissions
- Handle token refresh
- Manage session state

### 2. **Error Handling**
- Global error handler
- 404 not found handler
- Custom error responses
- Logging errors

### 3. **Validation Middleware**
- Request body validation
- Query parameter validation
- File upload validation
- Data sanitization

### 4. **Utility Middleware**
- Date formatting
- Request logging
- Response formatting
- CORS handling

## Common Middleware Patterns

### 1. **Authentication Middleware**
```javascript
export const verifyToken = async (req, res, next) => {
  try {
    // Token verification logic
    const token = req.cookies.accessToken || req.headers.authorization;
    if (!token) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    
    const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ message: "Invalid token" });
  }
};
```

### 2. **Error Handler**
```javascript
const errorHandler = (err, req, res, next) => {
  logger.error(`${err.message} - ${req.method} ${req.url}`);
  
  const statusCode = err.status || 500;
  res.status(statusCode).json({
    success: false,
    message: err.message || 'Internal Server Error',
    error: process.env.NODE_ENV === 'development' ? err.stack : undefined,
  });
};
```

### 3. **Validation Middleware**
```javascript
export const validateRequest = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body);
    if (error) {
      return res.status(400).json({ message: error.details[0].message });
    }
    next();
  };
};
```

## Middleware Order

The order of middleware is important:

1. **CORS** - Handle cross-origin requests
2. **Body Parser** - Parse request bodies
3. **Cookie Parser** - Parse cookies
4. **File Upload** - Handle file uploads
5. **Logging** - Log requests
6. **Authentication** - Verify tokens
7. **Authorization** - Check permissions
8. **Validation** - Validate input
9. **Routes** - Handle requests
10. **Error Handler** - Handle errors

## File Naming Conventions

- Use camelCase for file names
- Use descriptive names
- End with `.js` extension
- Use consistent naming patterns

## Best Practices

1. **Single Responsibility**: Each middleware should handle one concern
2. **Error Handling**: Always handle errors appropriately
3. **Performance**: Keep middleware lightweight
4. **Reusability**: Make middleware reusable
5. **Documentation**: Document middleware purpose and usage
6. **Testing**: Write tests for middleware
7. **Logging**: Log important events

## Common Middleware Types

### Authentication & Authorization
- `verifyToken`: Verify JWT tokens
- `isAdmin`: Check admin permissions
- `isSuperAdmin`: Check super admin permissions
- `checkPermission`: Check specific permissions

### Validation
- `validateRequest`: Validate request data
- `validateFile`: Validate file uploads
- `sanitizeInput`: Sanitize user input

### Error Handling
- `errorHandler`: Global error handler
- `notFoundHandler`: 404 handler
- `asyncHandler`: Handle async errors

### Utility
- `formatDates`: Format date fields
- `requestLogger`: Log requests
- `responseTime`: Measure response time

## Middleware Dependencies

Common dependencies:
- `jsonwebtoken` for JWT handling
- `joi` for validation
- `bcrypt` for password hashing
- `winston` for logging
- `express` for middleware functions
