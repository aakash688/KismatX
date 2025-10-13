# Development Guide

## Quick Start

### 1. Project Setup
```bash
# Copy the template to your new project
cp -r setup-template/ your-new-project/
cd your-new-project/

# Install dependencies
npm install

# Copy environment file
cp env.example .env

# Edit environment variables
nano .env
```

### 2. Database Setup
```bash
# Create database
mysql -u root -p
CREATE DATABASE your_database_name;

# Run migrations
npm run migration:run
```

### 3. Start Development
```bash
# Start development server
npm run dev

# Server will be available at http://localhost:5001
```

## Project Structure Explained

### Core Files
- **`src/server.js`**: Application entry point
- **`src/app.js`**: Express app configuration
- **`package.json`**: Dependencies and scripts
- **`.env`**: Environment variables

### Directory Structure
```
src/
├── config/          # Configuration files
├── controllers/      # Request handlers
├── entities/         # Database models
├── middleware/       # Custom middleware
├── routes/          # API endpoints
├── services/        # Business logic
└── utils/           # Helper functions
```

## Adding New Features

### 1. Create Entity
```javascript
// src/entities/feature/Feature.js
import { EntitySchema } from "typeorm";

const Feature = new EntitySchema({
  name: "Feature",
  tableName: "features",
  columns: {
    id: {
      primary: true,
      type: "int",
      generated: true,
    },
    name: {
      type: "varchar",
      nullable: false,
    },
    // Add more columns
  }
});

export default Feature;
```

### 2. Create Controller
```javascript
// src/controllers/featureController.js
import { AppDataSource } from "../config/typeorm.config.js";

export const createFeature = async (req, res, next) => {
  try {
    const featureRepo = AppDataSource.getRepository("Feature");
    const feature = featureRepo.create(req.body);
    const result = await featureRepo.save(feature);
    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};
```

### 3. Create Routes
```javascript
// src/routes/feature.js
import express from 'express';
import { createFeature } from '../controllers/featureController.js';
import { verifyToken } from '../middleware/auth.js';

const router = express.Router();
router.post('/', verifyToken, createFeature);

export default router;
```

### 4. Register Routes
```javascript
// src/routes/index.js
import featureRoutes from './feature.js';

router.use('/feature', featureRoutes);
```

## Database Operations

### Creating Migrations
```bash
# Generate migration
npm run migration:generate -- -n CreateFeatureTable

# Run migrations
npm run migration:run

# Revert migration
npm run migration:revert
```

### Entity Relationships
```javascript
// One-to-Many
relations: {
  posts: {
    target: "Post",
    type: "one-to-many",
    inverseSide: "user"
  }
}

// Many-to-Many
relations: {
  roles: {
    target: "Role",
    type: "many-to-many",
    joinTable: {
      name: "user_roles",
      joinColumn: { name: "user_id" },
      inverseJoinColumn: { name: "role_id" }
    }
  }
}
```

## Authentication & Authorization

### Protecting Routes
```javascript
import { verifyToken, isAdmin } from '../middleware/auth.js';

// Require authentication
router.get('/protected', verifyToken, controller);

// Require admin role
router.get('/admin', verifyToken, isAdmin, controller);
```

### Custom Permissions
```javascript
import { checkPermission } from '../middleware/auth.js';

// Check specific permission
router.get('/data', checkPermission('read_data'), controller);
```

## Validation

### Request Validation
```javascript
import { validateRequest } from '../middleware/validate.js';
import Joi from 'joi';

const schema = Joi.object({
  name: Joi.string().required(),
  email: Joi.string().email().required()
});

router.post('/', validateRequest(schema), controller);
```

### File Upload Validation
```javascript
import { validateFile } from '../middleware/validate.js';

router.post('/upload', validateFile({
  maxSize: 5 * 1024 * 1024, // 5MB
  allowedTypes: ['image/jpeg', 'image/png']
}), controller);
```

## Error Handling

### Custom Errors
```javascript
import { createError } from '../utils/errorHandler.js';

// Throw custom error
throw createError('Resource not found', 404);

// Validation error
throw createValidationError('Invalid input data');
```

### Error Middleware
```javascript
// Global error handler
app.use(errorHandler);

// 404 handler
app.use(notFoundHandler);
```

## Logging

### Using Logger
```javascript
import { logger } from '../utils/logger/logger.js';

// Log information
logger.info('User created successfully');

// Log errors
logger.error('Database connection failed', error);

// Log with metadata
logger.info('API request', { method: 'GET', url: '/api/users' });
```

## Email Services

### Sending Emails
```javascript
import { sendCustomEmail } from '../utils/mailer.js';

await sendCustomEmail({
  to: 'user@example.com',
  subject: 'Welcome',
  html: '<h1>Welcome to our platform!</h1>'
});
```

## Testing

### Unit Tests
```javascript
// tests/controllers/userController.test.js
import { createUser } from '../../src/controllers/userController.js';

describe('User Controller', () => {
  test('should create user', async () => {
    const req = { body: { name: 'John', email: 'john@example.com' } };
    const res = { status: jest.fn().mockReturnThis(), json: jest.fn() };
    
    await createUser(req, res);
    
    expect(res.status).toHaveBeenCalledWith(201);
  });
});
```

### Integration Tests
```javascript
// tests/integration/auth.test.js
import request from 'supertest';
import app from '../../src/app.js';

describe('Authentication', () => {
  test('should login user', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({ userid: 'test', password: 'password' });
    
    expect(response.status).toBe(200);
    expect(response.body.accessToken).toBeDefined();
  });
});
```

## Performance Optimization

### Database Queries
```javascript
// Use relations to avoid N+1 queries
const users = await userRepo.find({
  relations: ['roles', 'department']
});

// Use query builder for complex queries
const users = await userRepo
  .createQueryBuilder('user')
  .leftJoinAndSelect('user.roles', 'roles')
  .where('user.isActive = :active', { active: true })
  .getMany();
```

### Caching
```javascript
// Implement caching for frequently accessed data
const cacheKey = `user:${userId}`;
let user = await cache.get(cacheKey);

if (!user) {
  user = await userRepo.findOne({ where: { id: userId } });
  await cache.set(cacheKey, user, 3600); // 1 hour
}
```

## Security Best Practices

### Input Sanitization
```javascript
import { sanitizeInput } from '../utils/validation.js';

const cleanInput = sanitizeInput(req.body.name);
```

### Password Security
```javascript
import bcrypt from 'bcrypt';

// Hash password
const hashedPassword = await bcrypt.hash(password, 10);

// Verify password
const isValid = await bcrypt.compare(password, hashedPassword);
```

### Rate Limiting
```javascript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api/', limiter);
```

## Deployment

### Environment Variables
```bash
# Production environment
NODE_ENV=production
PORT=5001
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=your_database
```

### PM2 Configuration
```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'your-app',
    script: 'src/server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production'
    }
  }]
};
```

### Docker Configuration
```dockerfile
# Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 5001
CMD ["npm", "start"]
```

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check database credentials
   - Verify database is running
   - Check network connectivity

2. **Authentication Errors**
   - Verify JWT secrets
   - Check token expiry
   - Validate user permissions

3. **File Upload Issues**
   - Check file size limits
   - Verify upload directory permissions
   - Validate file types

4. **Performance Issues**
   - Check database queries
   - Monitor memory usage
   - Optimize database indexes

### Debugging

```javascript
// Enable debug logging
process.env.LOG_LEVEL = 'debug';

// Use console.log for debugging
console.log('Debug info:', data);

// Use logger for structured logging
logger.debug('Debug info', { data });
```

## Best Practices

1. **Code Organization**
   - Keep controllers thin
   - Use services for business logic
   - Follow consistent naming conventions

2. **Error Handling**
   - Always handle errors
   - Provide meaningful error messages
   - Log errors appropriately

3. **Security**
   - Validate all input
   - Use parameterized queries
   - Implement proper authentication

4. **Performance**
   - Optimize database queries
   - Use caching where appropriate
   - Monitor application performance

5. **Testing**
   - Write unit tests
   - Test edge cases
   - Use integration tests

## Resources

- [Express.js Documentation](https://expressjs.com/)
- [TypeORM Documentation](https://typeorm.io/)
- [JWT Best Practices](https://tools.ietf.org/html/rfc7519)
- [Node.js Security](https://nodejs.org/en/docs/guides/security/)
- [Winston Logging](https://github.com/winstonjs/winston)
