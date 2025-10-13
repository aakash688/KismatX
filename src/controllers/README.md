# Controllers Directory

This directory contains all route controllers that handle HTTP requests and responses.

## Purpose

Controllers are responsible for:
- Handling HTTP requests
- Validating input data
- Calling appropriate services
- Returning HTTP responses
- Managing request/response flow

## Structure

```
controllers/
├── authController.js          # Authentication endpoints
├── userController.js          # User management
├── [feature]/                 # Feature-specific controllers
│   ├── [feature]Controller.js
│   └── [sub-feature]Controller.js
└── README.md                  # This file
```

## Controller Guidelines

### 1. **Keep Controllers Thin**
- Controllers should only handle HTTP concerns
- Delegate business logic to services
- Focus on request/response handling

### 2. **Error Handling**
- Use try-catch blocks for error handling
- Call `next(err)` to pass errors to error middleware
- Return appropriate HTTP status codes

### 3. **Request Validation**
- Validate input data before processing
- Use middleware for common validation
- Return clear error messages

### 4. **Response Format**
- Use consistent response format
- Include appropriate status codes
- Return meaningful data structures

## Example Controller Structure

```javascript
// Example controller structure
export const createUser = async (req, res, next) => {
  try {
    // 1. Validate input
    const { name, email } = req.body;
    if (!name || !email) {
      return res.status(400).json({ message: "Name and email are required" });
    }

    // 2. Call service
    const user = await userService.createUser({ name, email });

    // 3. Return response
    res.status(201).json({ message: "User created successfully", user });
  } catch (err) {
    next(err);
  }
};
```

## Common Patterns

### 1. **CRUD Operations**
- `create[Entity]`: Create new entity
- `get[Entity]`: Get single entity
- `list[Entity]`: Get list of entities
- `update[Entity]`: Update entity
- `delete[Entity]`: Delete entity

### 2. **Authentication Controllers**
- `login`: User authentication
- `logout`: User logout
- `register`: User registration
- `refreshToken`: Token refresh

### 3. **File Upload Controllers**
- Handle file uploads
- Validate file types and sizes
- Save files to appropriate locations
- Return file URLs

## File Naming Conventions

- Use camelCase for file names
- End with `Controller.js`
- Use descriptive names
- Group related controllers in subdirectories

## Dependencies

Controllers typically depend on:
- Services (business logic)
- Middleware (authentication, validation)
- Utilities (helpers, formatters)
- Database repositories

## Best Practices

1. **Single Responsibility**: Each controller should handle one feature
2. **Consistent Naming**: Use consistent naming patterns
3. **Error Handling**: Always handle errors appropriately
4. **Input Validation**: Validate all input data
5. **Response Consistency**: Use consistent response formats
6. **Documentation**: Document complex logic
7. **Testing**: Write tests for controllers
