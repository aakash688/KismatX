# Routes Directory

This directory contains all API route definitions and route handlers.

## Purpose

Routes define the API endpoints and connect them to their respective controllers. They handle HTTP method routing and middleware application.

## Structure

```
routes/
├── index.js                    # Main route aggregator
├── routes.js                   # API route definitions
├── auth.js                     # Authentication routes
├── user.js                     # User management routes
├── [feature]/                  # Feature-specific routes
│   ├── [feature]Routes.js      # Feature routes
│   └── [sub-feature]Routes.js  # Sub-feature routes
└── README.md                   # This file
```

## Route Guidelines

### 1. **Route Organization**
- Group routes by feature/module
- Use descriptive route names
- Follow RESTful conventions
- Use consistent URL patterns

### 2. **Middleware Application**
- Apply authentication middleware
- Use validation middleware
- Apply permission checks
- Handle errors appropriately

### 3. **Route Patterns**
- Use HTTP methods appropriately
- Follow RESTful conventions
- Use consistent parameter naming
- Group related endpoints

## Example Route Structure

```javascript
import express from 'express';
import { verifyToken, isAdmin } from '../middleware/auth.js';
import { validateRequest } from '../middleware/validate.js';
import { createUser, getUser, updateUser, deleteUser } from '../controllers/userController.js';
import { commonSchemas } from '../middleware/validate.js';

const router = express.Router();

// Public routes
router.post('/register', validateRequest(commonSchemas.user), createUser);

// Protected routes
router.use(verifyToken);

// User routes
router.get('/', getUser);
router.put('/:id', isAdmin, validateRequest(commonSchemas.user), updateUser);
router.delete('/:id', isAdmin, deleteUser);

export default router;
```

## Common Route Patterns

### 1. **CRUD Routes**
```javascript
// GET /api/users - List users
router.get('/', listUsers);

// GET /api/users/:id - Get user by ID
router.get('/:id', getUser);

// POST /api/users - Create user
router.post('/', createUser);

// PUT /api/users/:id - Update user
router.put('/:id', updateUser);

// DELETE /api/users/:id - Delete user
router.delete('/:id', deleteUser);
```

### 2. **Authentication Routes**
```javascript
// POST /api/auth/login - User login
router.post('/login', login);

// POST /api/auth/logout - User logout
router.post('/logout', logout);

// POST /api/auth/refresh - Refresh token
router.post('/refresh', refreshToken);
```

### 3. **File Upload Routes**
```javascript
// POST /api/users/:id/avatar - Upload avatar
router.post('/:id/avatar', uploadAvatar);

// GET /api/users/:id/avatar - Get avatar
router.get('/:id/avatar', getAvatar);
```

## Route Naming Conventions

- Use kebab-case for route paths
- Use descriptive names
- Use consistent patterns
- Group related routes

## HTTP Methods

- **GET**: Retrieve data
- **POST**: Create new resources
- **PUT**: Update entire resource
- **PATCH**: Partial updates
- **DELETE**: Remove resources

## Middleware Application

### 1. **Authentication**
```javascript
router.use(verifyToken); // Apply to all routes
```

### 2. **Authorization**
```javascript
router.get('/admin', isAdmin, adminController); // Specific route
```

### 3. **Validation**
```javascript
router.post('/', validateRequest(schema), createController);
```

### 4. **File Upload**
```javascript
router.post('/upload', validateFile(options), uploadController);
```

## Route Parameters

### 1. **Path Parameters**
```javascript
router.get('/:id', getController); // req.params.id
```

### 2. **Query Parameters**
```javascript
router.get('/', listController); // req.query
```

### 3. **Body Parameters**
```javascript
router.post('/', createController); // req.body
```

## Error Handling

Routes should handle errors by:
- Using try-catch blocks
- Calling `next(err)` for middleware errors
- Returning appropriate HTTP status codes
- Providing meaningful error messages

## File Naming Conventions

- Use camelCase for file names
- Use descriptive names
- End with `.js` extension
- Use consistent naming patterns

## Best Practices

1. **Single Responsibility**: Each route file should handle one feature
2. **Consistent Naming**: Use consistent naming patterns
3. **Error Handling**: Always handle errors appropriately
4. **Validation**: Validate all input data
5. **Documentation**: Document complex routes
6. **Testing**: Write tests for routes
7. **Security**: Apply appropriate security measures

## Common Route Types

### Authentication Routes
- Login, logout, register, refresh token

### User Management Routes
- CRUD operations for users
- Profile management
- Password management

### File Upload Routes
- File upload endpoints
- File retrieval endpoints
- File management

### API Routes
- Data retrieval endpoints
- Data modification endpoints
- Search and filter endpoints

## Route Dependencies

Routes typically depend on:
- Controllers (business logic)
- Middleware (authentication, validation)
- Services (data processing)
- Utilities (helpers, formatters)
