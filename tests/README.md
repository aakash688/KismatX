# Tests Directory

This directory contains all test files and test-related resources for the Node.js backend project.

## Purpose

The tests directory provides:
- **Unit tests** for individual components
- **Integration tests** for API endpoints
- **End-to-end tests** for complete workflows
- **Test fixtures** and mock data
- **Test utilities** and helpers

## Structure

```
tests/
├── unit/                        # Unit tests
│   ├── controllers/             # Controller unit tests
│   ├── services/               # Service unit tests
│   ├── utils/                  # Utility function tests
│   └── middleware/             # Middleware tests
├── integration/                 # Integration tests
│   ├── api/                    # API endpoint tests
│   ├── database/               # Database integration tests
│   └── auth/                   # Authentication tests
├── e2e/                        # End-to-end tests
│   ├── user-workflows/         # User journey tests
│   ├── admin-workflows/        # Admin workflow tests
│   └── api-workflows/          # API workflow tests
├── fixtures/                   # Test data and fixtures
│   ├── users.json              # User test data
│   ├── products.json           # Product test data
│   └── mock-responses/         # Mock API responses
├── helpers/                    # Test utilities and helpers
│   ├── test-setup.js           # Test environment setup
│   ├── mock-data.js            # Mock data generators
│   └── api-client.js           # API testing client
└── README.md                   # This file
```

## Test Types

### Unit Tests
- **Purpose**: Test individual functions and methods
- **Scope**: Single component or function
- **Dependencies**: Mocked external dependencies
- **Speed**: Fast execution
- **Coverage**: High code coverage

### Integration Tests
- **Purpose**: Test component interactions
- **Scope**: Multiple components working together
- **Dependencies**: Real database and services
- **Speed**: Medium execution time
- **Coverage**: API endpoint coverage

### End-to-End Tests
- **Purpose**: Test complete user workflows
- **Scope**: Full application functionality
- **Dependencies**: Complete system setup
- **Speed**: Slow execution
- **Coverage**: User journey coverage

## Test Configuration

### Jest Configuration
```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'node',
  roots: ['<rootDir>/tests'],
  testMatch: [
    '**/__tests__/**/*.js',
    '**/?(*.)+(spec|test).js'
  ],
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/**/*.test.js',
    '!src/**/*.spec.js'
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  setupFilesAfterEnv: ['<rootDir>/tests/helpers/test-setup.js']
};
```

### Test Environment Setup
```javascript
// tests/helpers/test-setup.js
import { AppDataSource } from '../../src/config/typeorm.config.js';

beforeAll(async () => {
  // Setup test database
  await AppDataSource.initialize();
});

afterAll(async () => {
  // Cleanup test database
  await AppDataSource.destroy();
});

beforeEach(async () => {
  // Clean database before each test
  await AppDataSource.synchronize(true);
});
```

## Unit Tests

### Controller Tests
```javascript
// tests/unit/controllers/userController.test.js
import { createUser, getUser } from '../../../src/controllers/userController.js';
import { AppDataSource } from '../../../src/config/typeorm.config.js';

describe('User Controller', () => {
  beforeEach(async () => {
    await AppDataSource.synchronize(true);
  });

  test('should create user successfully', async () => {
    const req = {
      body: {
        fname: 'John',
        lname: 'Doe',
        email: 'john@example.com',
        userid: 'john.doe',
        password: 'password123'
      }
    };
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };

    await createUser(req, res);

    expect(res.status).toHaveBeenCalledWith(201);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        message: 'User created successfully'
      })
    );
  });

  test('should return user by ID', async () => {
    const req = { params: { id: 1 } };
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };

    await getUser(req, res);

    expect(res.status).toHaveBeenCalledWith(200);
  });
});
```

### Service Tests
```javascript
// tests/unit/services/userService.test.js
import { UserService } from '../../../src/services/userService.js';

describe('User Service', () => {
  let userService;

  beforeEach(() => {
    userService = new UserService();
  });

  test('should create user with valid data', async () => {
    const userData = {
      fname: 'John',
      lname: 'Doe',
      email: 'john@example.com',
      userid: 'john.doe',
      password: 'password123'
    };

    const user = await userService.createUser(userData);

    expect(user).toBeDefined();
    expect(user.fname).toBe('John');
    expect(user.email).toBe('john@example.com');
  });

  test('should throw error for duplicate user', async () => {
    const userData = {
      fname: 'John',
      lname: 'Doe',
      email: 'john@example.com',
      userid: 'john.doe',
      password: 'password123'
    };

    await userService.createUser(userData);

    await expect(userService.createUser(userData))
      .rejects.toThrow('User ID already exists');
  });
});
```

### Utility Tests
```javascript
// tests/unit/utils/validation.test.js
import { isValidEmail, validatePassword } from '../../../src/utils/validation.js';

describe('Validation Utils', () => {
  test('should validate email format', () => {
    expect(isValidEmail('test@example.com')).toBe(true);
    expect(isValidEmail('invalid-email')).toBe(false);
    expect(isValidEmail('')).toBe(false);
  });

  test('should validate password strength', () => {
    const result = validatePassword('Password123!');
    
    expect(result.isValid).toBe(true);
    expect(result.strength).toBeGreaterThan(2);
    expect(result.requirements.hasUpperCase).toBe(true);
    expect(result.requirements.hasNumbers).toBe(true);
  });
});
```

## Integration Tests

### API Endpoint Tests
```javascript
// tests/integration/api/user.test.js
import request from 'supertest';
import app from '../../../src/app.js';

describe('User API', () => {
  let authToken;

  beforeAll(async () => {
    // Login to get auth token
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        userid: 'admin',
        password: 'admin123'
      });
    
    authToken = response.body.accessToken;
  });

  test('GET /api/user/me should return current user', async () => {
    const response = await request(app)
      .get('/api/user/me')
      .set('Authorization', `Bearer ${authToken}`);

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('id');
    expect(response.body).toHaveProperty('email');
  });

  test('POST /api/user should create new user', async () => {
    const userData = {
      fname: 'Test',
      lname: 'User',
      email: 'test@example.com',
      userid: 'test.user',
      password: 'password123',
      roleNames: '[1]',
      department: 1
    };

    const response = await request(app)
      .post('/api/user')
      .set('Authorization', `Bearer ${authToken}`)
      .send(userData);

    expect(response.status).toBe(201);
    expect(response.body.message).toBe('User created successfully');
  });
});
```

### Database Integration Tests
```javascript
// tests/integration/database/user.test.js
import { AppDataSource } from '../../../src/config/typeorm.config.js';

describe('User Database Integration', () => {
  beforeAll(async () => {
    await AppDataSource.initialize();
  });

  afterAll(async () => {
    await AppDataSource.destroy();
  });

  beforeEach(async () => {
    await AppDataSource.synchronize(true);
  });

  test('should create user in database', async () => {
    const userRepo = AppDataSource.getRepository('User');
    
    const user = userRepo.create({
      fname: 'John',
      lname: 'Doe',
      email: 'john@example.com',
      userid: 'john.doe',
      password: 'hashedpassword'
    });

    const savedUser = await userRepo.save(user);

    expect(savedUser.id).toBeDefined();
    expect(savedUser.fname).toBe('John');
    expect(savedUser.email).toBe('john@example.com');
  });

  test('should find user by email', async () => {
    const userRepo = AppDataSource.getRepository('User');
    
    const user = userRepo.create({
      fname: 'Jane',
      lname: 'Doe',
      email: 'jane@example.com',
      userid: 'jane.doe',
      password: 'hashedpassword'
    });

    await userRepo.save(user);

    const foundUser = await userRepo.findOne({
      where: { email: 'jane@example.com' }
    });

    expect(foundUser).toBeDefined();
    expect(foundUser.fname).toBe('Jane');
  });
});
```

## End-to-End Tests

### User Workflow Tests
```javascript
// tests/e2e/user-workflows/registration.test.js
import request from 'supertest';
import app from '../../../src/app.js';

describe('User Registration Workflow', () => {
  test('complete user registration and login flow', async () => {
    // Step 1: Create user
    const userData = {
      fname: 'New',
      lname: 'User',
      email: 'newuser@example.com',
      userid: 'new.user',
      password: 'password123',
      roleNames: '[2]',
      department: 1
    };

    const createResponse = await request(app)
      .post('/api/user')
      .send(userData);

    expect(createResponse.status).toBe(201);

    // Step 2: Approve user (admin action)
    const approveResponse = await request(app)
      .put(`/api/user/${createResponse.body.userId}/approve`);

    expect(approveResponse.status).toBe(200);

    // Step 3: User login
    const loginResponse = await request(app)
      .post('/api/auth/login')
      .send({
        userid: 'new.user',
        password: 'password123'
      });

    expect(loginResponse.status).toBe(200);
    expect(loginResponse.body.accessToken).toBeDefined();

    // Step 4: Access protected resource
    const profileResponse = await request(app)
      .get('/api/user/me')
      .set('Authorization', `Bearer ${loginResponse.body.accessToken}`);

    expect(profileResponse.status).toBe(200);
    expect(profileResponse.body.userid).toBe('new.user');
  });
});
```

## Test Fixtures

### Mock Data
```javascript
// tests/fixtures/users.json
{
  "admin": {
    "fname": "Admin",
    "lname": "User",
    "email": "admin@example.com",
    "userid": "admin",
    "password": "admin123",
    "roles": [1],
    "department": 1
  },
  "regularUser": {
    "fname": "Regular",
    "lname": "User",
    "email": "user@example.com",
    "userid": "user",
    "password": "user123",
    "roles": [2],
    "department": 2
  }
}
```

### Test Helpers
```javascript
// tests/helpers/api-client.js
export class ApiClient {
  constructor(baseURL = 'http://localhost:5001/api') {
    this.baseURL = baseURL;
    this.token = null;
  }

  async login(userid, password) {
    const response = await fetch(`${this.baseURL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userid, password })
    });

    const data = await response.json();
    this.token = data.accessToken;
    return data;
  }

  async request(endpoint, options = {}) {
    const headers = {
      'Content-Type': 'application/json',
      ...options.headers
    };

    if (this.token) {
      headers.Authorization = `Bearer ${this.token}`;
    }

    const response = await fetch(`${this.baseURL}${endpoint}`, {
      ...options,
      headers
    });

    return response.json();
  }
}
```

## Test Commands

### Running Tests
```bash
# Run all tests
npm test

# Run unit tests only
npm run test:unit

# Run integration tests only
npm run test:integration

# Run e2e tests only
npm run test:e2e

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode
npm run test:watch
```

### Test Scripts
```json
{
  "scripts": {
    "test": "jest",
    "test:unit": "jest tests/unit",
    "test:integration": "jest tests/integration",
    "test:e2e": "jest tests/e2e",
    "test:coverage": "jest --coverage",
    "test:watch": "jest --watch",
    "test:ci": "jest --ci --coverage --watchAll=false"
  }
}
```

## Best Practices

### Test Organization
1. **Group related tests** in describe blocks
2. **Use descriptive test names** that explain the scenario
3. **Follow AAA pattern**: Arrange, Act, Assert
4. **Keep tests independent** and isolated
5. **Clean up after tests** to avoid side effects

### Test Data Management
1. **Use fixtures** for consistent test data
2. **Create test data** in beforeEach hooks
3. **Clean up test data** in afterEach hooks
4. **Use factories** for dynamic test data generation
5. **Mock external dependencies** appropriately

### Performance Considerations
1. **Run unit tests** frequently during development
2. **Run integration tests** before commits
3. **Run e2e tests** before deployments
4. **Use parallel execution** for faster test runs
5. **Monitor test execution time** and optimize slow tests

## Coverage and Quality

### Coverage Goals
- **Unit tests**: 90%+ code coverage
- **Integration tests**: 80%+ API endpoint coverage
- **E2E tests**: 70%+ user workflow coverage

### Quality Metrics
- **Test reliability**: Tests should be stable and repeatable
- **Test maintainability**: Tests should be easy to update
- **Test performance**: Tests should run quickly
- **Test clarity**: Tests should be easy to understand
- **Test coverage**: Tests should cover critical functionality
