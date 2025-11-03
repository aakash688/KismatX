# KismatX API Summary

## Project Overview

**KismatX** is a gaming platform API built with Node.js and Express, featuring comprehensive user management, wallet transactions, game management, and betting functionality.

---

## Technology Stack

### Core Technologies
- **Runtime**: Node.js (ES Modules)
- **Web Framework**: Express.js v4.21.2
- **Database**: MariaDB/MySQL v3.14.1
- **ORM**: TypeORM v0.3.20
- **Authentication**: JWT (jsonwebtoken v9.0.2)

### Key Dependencies
- **Password Hashing**: bcrypt v5.1.1
- **Validation**: joi v17.13.3
- **Logging**: winston v3.17.0, morgan v1.10.0
- **Email**: nodemailer v6.10.0
- **File Upload**: express-fileupload v1.5.1
- **CORS**: cors v2.8.5
- **Cookies**: cookie-parser v1.4.7
- **Monitoring**: express-status-monitor v1.3.4, prom-client v15.1.3
- **Date Utilities**: date-fns v4.1.0, date-fns-tz v4.1.0, moment v2.30.1
- **Documentation**: swagger-jsdoc v6.2.8, swagger-ui-express v5.0.1
- **Cron Jobs**: node-cron (latest)
- **UUID**: uuid v11.1.0

### Development Tools
- **Hot Reload**: nodemon v3.1.9
- **Testing**: 
  - Jest v30.0.3, supertest v7.1.1 (unit/integration tests)
  - Python requests (automated end-to-end tests)
  - Node.js test scripts (critical functionality tests)
- **TypeScript**: TypeScript v5.8.3 (for type checking)

---

## ORM Configuration (TypeORM)

### Database Connection
- **Type**: MariaDB (MySQL compatible)
- **Host**: Configurable via `DB_HOST` env variable (default: localhost)
- **Port**: Configurable via `DB_PORT` env variable (default: 3306)
- **Database**: Configurable via `DB_NAME` env variable
- **Connection Pool**: 20 connections
- **Synchronization**: Disabled (use migrations)

### ORM Features
- **Entity Location**: `src/entities/**/*.js`
- **Migrations**: `src/migrations/*.js`
- **Logging**: Custom TypeORM logger (development mode only)
- **Big Numbers Support**: Enabled

### Migration Commands
```bash
npm run migration:generate -- -n MigrationName
npm run migration:run
npm run migration:revert
```

---

## Database Entities

### User Management Entities
1. **User** (`src/entities/user/User.js`)
   - Core user information
   - Wallet balance (deposit_amount)
   - Profile information
   - Relationship with roles

2. **Role** (`src/entities/user/Role.js`)
   - Role definitions
   - Permission assignments

3. **Permission** (`src/entities/user/Permission.js`)
   - Granular permissions
   - Resource-based access control

4. **RefreshToken** (`src/entities/user/RefreshToken.js`)
   - JWT refresh token storage
   - User session management

5. **LoginHistory** (`src/entities/user/LoginHistory.js`)
   - User login tracking
   - IP and device information

6. **AuditLog** (`src/entities/user/AuditLog.js`)
   - Administrative action logging
   - Compliance and security tracking

7. **WalletLog** (`src/entities/user/WalletLog.js`)
   - Transaction history
   - Credit/debit tracking

### Game & Betting Entities
1. **Game** (`src/entities/game/Game.js`)
   - Game sessions
   - Status tracking (pending, active, completed)
   - Winning card and payout multiplier

2. **GameCardTotal** (`src/entities/game/GameCardTotal.js`)
   - Total bets per card per game
   - Aggregated betting statistics

3. **BetSlip** (`src/entities/game/BetSlip.js`)
   - User bet slips
   - Slip ID and barcode
   - Total amount and payout

4. **BetDetail** (`src/entities/game/BetDetail.js`)
   - Individual bet details
   - Card number and bet amount
   - Win status and payout amount

---

## API Endpoints

### Base URL
```
http://localhost:5001/api
```

### Authentication Headers
```
Authorization: Bearer <access_token>
```
OR via cookies:
```
accessToken: <access_token>
refreshToken: <refresh_token>
```

---

## 1. Health & Debug Endpoints

### GET `/api/health`
**Description**: Health check endpoint  
**Auth**: Public  
**Response**:
```json
{
  "status": "OK",
  "timestamp": "2024-01-01T10:00:00Z",
  "version": "1.0.0",
  "endpoints": {
    "auth": "/api/auth",
    "user": "/api/user",
    "admin": "/api/admin"
  }
}
```

### GET `/api/debug/refresh-tokens`
**Description**: Debug endpoint to check refresh tokens  
**Auth**: Public  
**Response**: List of refresh tokens with metadata

### GET `/metrics`
**Description**: Prometheus metrics endpoint  
**Auth**: Public  
**Response**: Prometheus metrics format

---

## 2. Authentication Endpoints (`/api/auth`)

### POST `/api/auth/register`
**Description**: Register new user  
**Auth**: Public  
**Request Body**:
```json
{
  "userid": "string",
  "password": "string",
  "email": "string",
  "mobileno": "string"
}
```

### POST `/api/auth/login`
**Description**: User login  
**Auth**: Public  
**Request Body**:
```json
{
  "userid": "string",
  "password": "string"
}
```
**Response**:
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "user": {
    "id": 1,
    "userid": "string",
    "email": "string"
  }
}
```

### POST `/api/auth/logout`
**Description**: User logout  
**Auth**: Required (Bearer Token)

### POST `/api/auth/refresh-token`
**Description**: Refresh access token  
**Auth**: Required (Bearer Token)  
**Request Body**:
```json
{
  "refreshToken": "string"
}
```

### POST `/api/auth/forgot-password`
**Description**: Request password reset  
**Auth**: Public  
**Request Body**:
```json
{
  "userid": "string"
}
```

### POST `/api/auth/reset-password`
**Description**: Reset password with token  
**Auth**: Public  
**Request Body**:
```json
{
  "token": "string",
  "password": "string"
}
```

### POST `/api/auth/change-password`
**Description**: Change password (authenticated)  
**Auth**: Required  
**Request Body**:
```json
{
  "oldPassword": "string",
  "newPassword": "string"
}
```

---

## 3. User Management Endpoints (`/api/user`)

### GET `/api/user/me`
**Description**: Get current user info  
**Auth**: Required  
**Response**: Current user details with roles

### GET `/api/user/profile`
**Description**: Get user profile  
**Auth**: Required  
**Response**: Complete user profile including profile photo

### PUT `/api/user/profile`
**Description**: Update user profile  
**Auth**: Required  
**Request Body**:
```json
{
  "fname": "string",
  "lname": "string",
  "email": "string",
  "mobileno": "string",
  "birthDate": "date",
  "bloodGroup": "string"
}
```

### POST `/api/user/profile/photo`
**Description**: Upload profile photo  
**Auth**: Required  
**Content-Type**: `multipart/form-data`  
**Body**: `profilePhoto` file

### PUT `/api/user/password`
**Description**: Update password  
**Auth**: Required  
**Request Body**:
```json
{
  "oldPassword": "string",
  "newPassword": "string"
}
```

### GET `/api/user/stats`
**Description**: Get user statistics (Admin only)  
**Auth**: Required (Admin)  
**Response**: User statistics with analytics

### GET `/api/user`
**Description**: List all users (Admin only)  
**Auth**: Required (Admin)  
**Query Parameters**:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 10)
- `isActive`: Filter by active status
- `roles`: Filter by roles (comma-separated)
- `department`: Filter by department

### GET `/api/user/:id`
**Description**: Get user by ID (Admin only)  
**Auth**: Required (Admin)

### POST `/api/user`
**Description**: Create new user (Admin only)  
**Auth**: Required (Admin)  
**Request Body**:
```json
{
  "fname": "string",
  "lname": "string",
  "email": "string",
  "userid": "string",
  "password": "string",
  "roleNames": "[1, 2]",
  "department": 1
}
```

### PUT `/api/user/:id`
**Description**: Update user (Admin only)  
**Auth**: Required (Admin)

### DELETE `/api/user/:id`
**Description**: Delete user (Admin only)  
**Auth**: Required (Admin)

### PUT `/api/user/:id/approve`
**Description**: Approve user (Admin only)  
**Auth**: Required (Admin)

### PUT `/api/user/:id/status`
**Description**: Change user status (Admin only)  
**Auth**: Required (Admin)  
**Request Body**:
```json
{
  "status": true
}
```

---

## 4. Admin Panel Endpoints (`/api/admin`)

**All admin endpoints require authentication and admin role.**

### Dashboard
- **GET `/api/admin/dashboard`**: Admin dashboard statistics

### User Management
- **POST `/api/admin/users`**: Create user
- **GET `/api/admin/users`**: List all users (with pagination)
- **GET `/api/admin/users/:id`**: Get user by ID
- **PUT `/api/admin/users/:id`**: Update user
- **DELETE `/api/admin/users/:id`**: Delete user
- **PUT `/api/admin/users/:id/status`**: Change user status
- **POST `/api/admin/users/:id/reset-password`**: Reset user password
- **PUT `/api/admin/users/:id/verify-email`**: Verify user email
- **PUT `/api/admin/users/:id/verify-mobile`**: Verify user mobile
- **GET `/api/admin/users/:id/logins`**: Get user login history
- **POST `/api/admin/users/:user_id/sessions/kill`**: Kill user sessions
- **GET `/api/admin/users/:user_id/sessions/active`**: Get active user sessions

### Role Management
- **POST `/api/admin/roles`**: Create role
- **GET `/api/admin/roles`**: List all roles
- **PUT `/api/admin/roles/:id`**: Update role
- **DELETE `/api/admin/roles/:id`**: Delete role
- **POST `/api/admin/roles/:id/permissions`**: Assign permissions to role
- **GET `/api/admin/roles/:id/permissions`**: Get role permissions

### User-Role Assignment
- **POST `/api/admin/users/:id/roles`**: Assign roles to user
- **GET `/api/admin/users/:id/roles`**: Get user roles

### Permission Management
- **POST `/api/admin/permissions`**: Create permission
- **GET `/api/admin/permissions`**: List all permissions
- **PUT `/api/admin/permissions/:id`**: Update permission
- **DELETE `/api/admin/permissions/:id`**: Delete permission

### Audit & Logging
- **GET `/api/admin/audit-logs`**: Get audit logs (with pagination and filters)

---

## 5. Wallet Management Endpoints (`/api/wallet`)

**All wallet endpoints require authentication.**

### GET `/api/wallet/logs`
**Description**: Get all wallet logs (Admin only)  
**Auth**: Required (Admin)  
**Query Parameters**:
- `page`: Page number
- `limit`: Items per page
- `user_id`: Filter by user
- `transaction_type`: Filter by type (recharge, withdrawal, game)
- `direction`: Filter by direction (credit, debit)
- `date_from`: Start date filter
- `date_to`: End date filter
- `search`: Search in user names and comments

### GET `/api/wallet/summary/:user_id`
**Description**: Get wallet summary for user (Admin only)  
**Auth**: Required (Admin)  
**Response**: Balance, total credits, total debits, transaction count

### POST `/api/wallet/transaction`
**Description**: Create wallet transaction (Admin only)  
**Auth**: Required (Admin)  
**Request Body**:
```json
{
  "user_id": 1,
  "transaction_type": "recharge|withdrawal|game",
  "amount": 1000.00,
  "transaction_direction": "credit|debit",
  "game_id": null,
  "comment": "Optional comment"
}
```

### GET `/api/wallet/transaction/:id`
**Description**: Get transaction by ID (Admin only)  
**Auth**: Required (Admin)

### PUT `/api/wallet/transaction/:id`
**Description**: Update transaction comment (Admin only)  
**Auth**: Required (Admin)  
**Request Body**:
```json
{
  "comment": "Updated comment"
}
```

### DELETE `/api/wallet/transaction/:id`
**Description**: Soft delete transaction (Admin only)  
**Auth**: Required (Admin)

### GET `/api/wallet/:user_id`
**Description**: Get user transactions  
**Auth**: Required (Users can only view own transactions, Admins can view any)  
**Query Parameters**:
- `page`: Page number
- `limit`: Items per page
- `transaction_type`: Filter by type
- `direction`: Filter by direction
- `date_from`: Start date
- `date_to`: End date

---

## 6. Game Management Endpoints (`/api/game`)

### GET `/api/game/current`
**Description**: Get current active game  
**Auth**: Public  
**Response**: Current game with card totals

### GET `/api/game/:gameId`
**Description**: Get game by ID  
**Auth**: Public  
**Response**: Game details with card totals

### POST `/api/game/create`
**Description**: Create new game (Admin only)  
**Auth**: Required (Admin)  
**Request Body**:
```json
{
  "payout_multiplier": 10.00
}
```
**Note**: Game ID is auto-generated (format: `GAME_HH-MM`)

### GET `/api/game`
**Description**: List all games (Admin only)  
**Auth**: Required (Admin)  
**Query Parameters**:
- `status`: Filter by status (pending, active, completed)
- `page`: Page number
- `limit`: Items per page

### PUT `/api/game/:gameId/start`
**Description**: Start game (change status to active)  
**Auth**: Required (Admin)

### PUT `/api/game/:gameId/result`
**Description**: Declare game result (set winning card)  
**Auth**: Required (Admin)  
**Request Body**:
```json
{
  "winning_card": 5
}
```
**Note**: Winning card must be between 1-12

### POST `/api/game/:gameId/settle`
**Description**: Settle all bets for a game  
**Auth**: Required (Admin)  
**Note**: Calculates payouts based on winning card and multiplier

### GET `/api/game/:gameId/stats`
**Description**: Get game statistics  
**Auth**: Required (Admin)  
**Response**: Total bets, payouts, profit, card totals

---

## 7. Core Services

### Game Service (`src/services/gameService.js`)
- **`createDailyGames()`**: Creates all games for current day at 5-minute intervals
- **`activatePendingGames()`**: Activates pending games when start_time arrives
- **`completeActiveGames()`**: Completes active games when end_time passes
- **`getCurrentGame()`**: Returns currently active game with card totals
- **`getGameById(gameId)`**: Retrieves specific game by ID with all details

### Betting Service (`src/services/bettingService.js`) ⚠️ CRITICAL
- **`placeBet(userId, gameId, bets, idempotencyKey, ipAddress, userAgent)`**: Atomic bet placement
  - Pessimistic locking on user wallet
  - Idempotency support for duplicate prevention
  - Comprehensive validations
  - Balance deduction
  - Bet slip and detail creation
  - Barcode generation
  - Wallet and audit logging

### Settlement Service (`src/services/settlementService.js`) ⚠️ CRITICAL
- **`settleGame(gameId, winningCard, adminId)`**: Atomic game settlement
  - Pessimistic locking on game
  - Bulk updates for performance
  - Payout calculations
  - Bet slip status updates
  - Settlement status tracking
  - Error handling with retry support

### Claim Service (`src/services/claimService.js`) ⚠️ CRITICAL
- **`claimWinnings(identifier, userId, ipAddress, userAgent)`**: Atomic winnings claim
  - Double locking (slip + wallet)
  - Duplicate claim prevention
  - Ownership verification
  - Balance crediting
  - Wallet and audit logging

---

## 8. Cron Job Schedulers

### Game Scheduler (`src/schedulers/gameScheduler.js`)

**Daily Game Creation**
- **Schedule**: 07:55 IST (02:25 UTC) - `'25 2 * * *'`
- **Purpose**: Create all games for the day before first game starts
- **Function**: Calls `createDailyGames()`
- **Timezone**: Asia/Kolkata

**Game State Management**
- **Schedule**: Every minute - `'* * * * *'`
- **Purpose**: Automatically transition game states
- **Functions**: 
  - `activatePendingGames()` - Activates games when start_time arrives
  - `completeActiveGames()` - Completes games when end_time passes
- **Timezone**: Asia/Kolkata

**Auto-Settlement** (Conditional)
- **Schedule**: Every minute - `'* * * * *'`
- **Condition**: Only runs if `game_result_type='auto'` in settings
- **Purpose**: Automatically settle completed games
- **Logic**: 
  - Finds games with `status='completed'` AND `settlement_status='not_settled'`
  - Generates random winning card (1-12)
  - Calls `settleGame()` for each game
- **Timezone**: Asia/Kolkata

**Initialization**: Schedulers are automatically initialized when server starts (non-test environments only)

---

## 9. Betting Endpoints (`/api/bets`)

**Note**: ✅ All betting routes are fully implemented and tested.

### POST `/api/bets/place`
**Description**: Place a bet  
**Auth**: Required  
**Request Body**:
```json
{
  "game_id": "GAME_12-00",
  "bets": [
    {
      "card_number": 5,
      "bet_amount": 100.00
    },
    {
      "card_number": 7,
      "bet_amount": 50.00
    }
  ]
}
```
**Validation**:
- Game must exist and be active
- Game must not have ended
- Card numbers must be 1-12
- User must have sufficient balance
- Bet amounts must be positive

**Response**:
```json
{
  "success": true,
  "message": "Bet placed successfully",
  "data": {
    "slip_id": "SLIP_20240101_120000_ABCD1234",
    "barcode": "BarcodeHash",
    "game_id": "GAME_12-00",
    "total_amount": 150.00,
    "bets": [...]
  }
}
```

### GET `/api/bets/slip/:identifier`
**Description**: Get bet slip by slip ID or barcode  
**Auth**: Required  
**Response**: Bet slip details with game info and bet details

### GET `/api/bets/my-bets`
**Description**: Get all bets for current user  
**Auth**: Required  
**Query Parameters**:
- `page`: Page number
- `limit`: Items per page (default: 20)
- `status`: Filter by status (pending, settled, lost)

### GET `/api/bets/game/:gameId`
**Description**: Get all bets for a game (Admin only)  
**Auth**: Required (Admin)  
**Query Parameters**:
- `page`: Page number
- `limit`: Items per page (default: 50)

### POST `/api/bets/claim`
**Description**: Claim winnings from a bet slip  
**Auth**: Required  
**Request Body**:
```json
{
  "identifier": "slip_id_or_barcode"
}
```
**Response**:
```json
{
  "success": true,
  "amount": 1500.00,
  "new_balance": 2350.00
}
```
**Note**: Adds winnings to user balance. Prevents duplicate claims.

### GET `/api/bets/stats`
**Description**: Get betting statistics for current user  
**Auth**: Required  
**Response**: Total slips, pending/won/lost counts, total bet amount, total winnings, net profit

---

## 10. Utility Functions

### Timezone Utility (`src/utils/timezone.js`)
- **`toUTC(date)`**: Convert IST date to UTC
- **`toIST(date)`**: Convert UTC date to IST
- **`formatIST(date, format)`**: Format date in IST timezone
- **`parseTimeString(timeString)`**: Parse time string (HH:MM) to object
- **`nowIST()`**: Get current time in IST

### Barcode Utility (`src/utils/barcode.js`)
- **`generateSecureBarcode(gameId, slipId)`**: Generate HMAC-secured barcode
- **`verifyBarcode(barcode, gameId, slipId)`**: Verify barcode integrity
- **`parseBarcode(barcode)`**: Parse barcode to extract components
- **Format**: `GAME_YYYYMMDDHHMM_UUID_HASH`

### Settings Utility (`src/utils/settings.js`)
- **`getSetting(key, defaultValue)`**: Get setting with caching (1-minute TTL)
- **`getSettingAsNumber(key, defaultValue)`**: Get setting as number
- **`getAllSettings()`**: Get all settings (cached)
- **`clearSettingsCache()`**: Clear settings cache

---

## 11. Postman Collection

### GET `/api/postman/postman-collection`
**Description**: Download Postman collection  
**Auth**: Public  
**Response**: JSON Postman collection v2.1.0 format

---

## Authentication & Authorization

### JWT Token System
- **Access Token**: Short-lived (typically 15 minutes)
- **Refresh Token**: Long-lived (typically 7 days)
- **Token Storage**: HTTP-only cookies or Authorization header
- **Token Rotation**: Implemented for security

### Role-Based Access Control (RBAC)
- **Roles**: Hierarchical permission system
- **Permissions**: Granular resource-based permissions
- **Middleware**: `verifyToken`, `isAdmin`, `isSuperAdmin`

### Security Features
- Password hashing with bcrypt (salt rounds)
- SQL injection prevention (TypeORM parameterized queries)
- XSS protection
- CSRF protection (SameSite cookies)
- Rate limiting support
- Audit logging for administrative actions

---

## Response Formats

### Success Response
```json
{
  "success": true,
  "data": {...},
  "message": "Operation successful"
}
```

### Paginated Response
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5,
    "hasNextPage": true,
    "hasPrevPage": false
  }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error (development only)"
}
```

---

## Error Status Codes

- **200**: Success
- **201**: Created
- **400**: Bad Request (Validation errors)
- **401**: Unauthorized (Authentication required)
- **403**: Forbidden (Permission denied)
- **404**: Not Found
- **429**: Too Many Requests (Rate limit exceeded)
- **500**: Internal Server Error

---

## File Upload

### Supported Types
- **Profile Photos**: JPEG, PNG, GIF
- **Maximum Size**: 50MB (configurable via `MAX_FILE_SIZE` env)

### Upload Endpoints
- `/api/user/profile/photo`: Profile photo upload

---

## Logging & Monitoring

### Logging Levels
- **Error**: Critical errors
- **Warn**: Warnings
- **Info**: General information
- **Debug**: Detailed debugging

### Log Destinations
- **Console**: Development mode
- **Files**: `logs/combined.log`, `logs/error.log`
- **Winston**: Structured logging

### Monitoring
- **Express Status Monitor**: `/status` endpoint
- **Prometheus Metrics**: `/metrics` endpoint
- **Request Duration Tracking**: HTTP request timing
- **Error Tracking**: Comprehensive error logging

---

## Environment Variables

### Required Environment Variables
```env
# Database
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=KismatX

# JWT
JWT_SECRET=your_jwt_secret
JWT_REFRESH_SECRET=your_refresh_secret
JWT_EXPIRE=15m
JWT_REFRESH_EXPIRE=7d

# Server
PORT=5001
NODE_ENV=development

# CORS
CORS_ORIGIN=http://localhost:3000

# File Upload
MAX_FILE_SIZE=52428800
```

---

## Project Structure

```
KismatX/
├── src/
│   ├── server.js              # Server entry point
│   ├── app.js                 # Express app configuration
│   ├── config/
│   │   └── typeorm.config.js  # TypeORM configuration
│   ├── controllers/           # Route controllers
│   │   ├── authController.js
│   │   ├── userController.js
│   │   ├── adminController.js
│   │   ├── walletController.js
│   │   ├── gameController.js
│   │   ├── bettingController.js
│   │   ├── roleController.js
│   │   ├── permissionController.js
│   │   └── settingsController.js
│   ├── entities/              # TypeORM entities
│   │   ├── user/
│   │   ├── game/
│   │   ├── Settings.js
│   │   └── SettingsLog.js
│   ├── middleware/            # Express middleware
│   │   ├── auth.js
│   │   ├── validate.js
│   │   ├── errorHandler.js
│   │   ├── formatDates.js
│   │   └── validation/
│   │       └── betValidation.js
│   ├── routes/                # API routes
│   │   ├── routes.js
│   │   ├── auth.js
│   │   ├── user.js
│   │   ├── admin.js
│   │   ├── wallet.js
│   │   ├── game.js
│   │   ├── betting.js
│   │   └── postman.js
│   ├── services/              # Business logic
│   │   ├── userService.js
│   │   ├── gameService.js
│   │   ├── bettingService.js
│   │   ├── settlementService.js
│   │   └── claimService.js
│   ├── schedulers/            # Cron job schedulers
│   │   └── gameScheduler.js
│   ├── migrations/            # Database migrations
│   │   ├── 20241201120000-AddSettlementToGames.js
│   │   ├── 20241201130000-UpdateBetSlipsForClaim.js
│   │   ├── 20241201140000-AddIndexesToBetDetails.js
│   │   └── 20241201150000-AddReferenceToWalletLogs.js
│   └── utils/                 # Utilities
│       ├── logger/
│       ├── token.js
│       ├── mailer.js
│       ├── auditLogger.js
│       ├── timezone.js
│       ├── barcode.js
│       └── settings.js
├── tests/                     # Node.js test scripts
│   ├── test-betting-race-condition.js
│   ├── test-idempotency.js
│   ├── test-settlement-accuracy.js
│   ├── test-claim-duplicate.js
│   └── README.md
├── test_kismatx_automated.py  # Python automated test suite
├── requirements_test.txt      # Python test dependencies
├── TEST_AUTOMATION_README.md  # Testing documentation
├── RUN_TESTS.md               # Quick test guide
├── public/                    # Static files
├── uploads/                   # File uploads
├── logs/                      # Application logs
└── package.json
```

---

## Development Commands

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start

# Initialize database
npm run init-db

# Setup (init-db + dev)
npm run setup

# Generate migration
npm run migration:generate -- -n MigrationName

# Run migrations
npm run migration:run

# Revert migration
npm run migration:revert

# Run automated test suite (Python)
pip install -r requirements_test.txt
python test_kismatx_automated.py

# Run Node.js test scripts
export ACCESS_TOKEN="your_token"
node tests/test-betting-race-condition.js <userId> <gameId>
node tests/test-idempotency.js <userId> <gameId>
node tests/test-settlement-accuracy.js <gameId> <winningCard>
node tests/test-claim-duplicate.js <userId> <slipId>
```

---

## API Documentation Access

- **Interactive Docs**: `http://localhost:5001/public/api_documentation.html`
- **API Page**: `http://localhost:5001/api`
- **Postman Collection**: `http://localhost:5001/api/postman/postman-collection`

---

## Notes

1. **Database Synchronization**: TypeORM synchronization is disabled. Always use migrations for schema changes.

2. **Game IDs**: Automatically generated based on time (format: `YYYYMMDDHHMM`, e.g., `202412011200` for 2024-12-01 at 12:00 IST).

3. **Bet Slip IDs**: Generated as UUID v4 (format: `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`).

4. **Barcode Format**: `GAME_YYYYMMDDHHMM_UUID_HASH` - Secured with HMAC-SHA256.

5. **Card Numbers**: Valid range is 1-12 for game betting.

6. **Transaction Types**: `recharge`, `withdrawal`, `game`

7. **Transaction Directions**: `credit` (add money), `debit` (deduct money)

8. **Game Statuses**: `pending`, `active`, `completed`

9. **Bet Slip Statuses**: `pending`, `won`, `lost`

10. **Settlement Statuses**: `not_settled`, `settling`, `settled`, `failed`

11. **Game Result Type**: Can be `auto` (automatic random card) or `manual` (admin declares)

12. **Cron Jobs**: Automatically initialize on server start (disabled in test environment)

13. **Race Condition Protection**: All critical operations use pessimistic row-level locking and atomic transactions

14. **Automated Testing**: Comprehensive test suite available:
    - Python automated end-to-end test suite
    - Node.js test scripts for critical functionality
    - Race condition, idempotency, settlement, and claim tests
    - JSON test reports with detailed results

---

## Future Enhancements

- Real-time game updates via WebSocket
- Payment gateway integration
- Mobile app API endpoints
- Advanced analytics dashboard
- ✅ Automated game scheduling (Implemented)
- ✅ Automated testing suite (Implemented)
- Multi-language support
- Push notifications
- Admin panel game management UI
- Real-time betting statistics
- Email/SMS notifications for game results
- Load testing & performance optimization
- Integration with CI/CD pipeline

---

---

## 12. Database Schema Updates

### Games Table
- Added `settlement_status` (enum: not_settled, settling, settled, failed)
- Added `settlement_started_at` (datetime)
- Added `settlement_completed_at` (datetime)
- Added `settlement_error` (text)
- Indexes: `idx_settlement`, `idx_status`, `idx_time_range`

### Bet Slips Table
- `slip_id` changed to VARCHAR(36) for UUID
- Added `claimed` (boolean)
- Added `claimed_at` (datetime)
- Added `idempotency_key` (varchar, unique)
- `status` enum updated to include 'won'
- Renamed `total_payout` to `payout_amount`
- Indexes: `idx_user_game`, `idx_claim`, `idx_idempotency`, `idx_barcode`

### Bet Details Table
- Added `game_id` (varchar)
- Added `user_id` (bigint)
- Added foreign key on `slip_id` with CASCADE delete
- Indexes: `idx_game_card`, `idx_game_winner`, `idx_slip`

### Wallet Logs Table
- Added `reference_type` (varchar) - Type of reference (bet_placement, claim, etc.)
- Added `reference_id` (varchar) - ID of referenced entity (slip_id, etc.)
- Added `status` (varchar) - Transaction status

### Settings Table
- Stores game configuration (multiplier, limits, times, result type)
- Cached in-memory with 1-minute TTL for performance

---

## 13. Security Features

### Race Condition Protection
- **Pessimistic Write Locks**: All critical operations use row-level locking
- **Atomic Transactions**: All-or-nothing database operations
- **Idempotency Keys**: Prevents duplicate operations
- **Double Locking**: Claim service locks both slip and wallet

### Transaction Safety
- Betting: User locked → Balance checked → Deducted → Bet created (all atomic)
- Settlement: Game locked → Status checked → Updates → Complete (all atomic)
- Claim: Slip locked → Wallet locked → Credit → Mark claimed (all atomic)

---

## 14. Testing Infrastructure

### Automated Test Suite

**Python Automated Test Suite** (`test_kismatx_automated.py`)
- Comprehensive end-to-end API testing
- Automated test execution with detailed reporting
- JSON test report generation
- Real-time console output with status indicators

**Features:**
- ✅ Health checks
- ✅ Authentication (Player & Admin)
- ✅ Wallet management (Recharge, Transactions)
- ✅ Game operations (Get current game, List games)
- ✅ Betting flow (Place bet, Idempotency check)
- ✅ Settlement & Claims (Settle game, Claim winnings, Duplicate prevention)
- ✅ Admin functions (Games, Stats, Settings, Settlement reports)
- ✅ Security validation (Unauthorized access, Admin route protection, Input validation)
- ✅ User profile management

**Usage:**
```bash
# Install dependencies
pip install -r requirements_test.txt

# Run test suite
python test_kismatx_automated.py
```

**Configuration:**
```python
BASE_URL = "http://localhost:5001/api"
PLAYER_USERID = "player001"
PLAYER_PASSWORD = "password123"
ADMIN_USERID = "admin001"
ADMIN_PASSWORD = "admin123"
WALLET_RECHARGE_AMOUNT = 1000
```

**Test Report:**
- Console output with real-time results
- JSON report: `test_report_YYYYMMDD_HHMMSS.json`
- Summary statistics (pass rate, duration, etc.)

---

### Node.js Test Scripts (`tests/`)

**Race Condition Test** (`test-betting-race-condition.js`)
- Tests pessimistic locking prevents race conditions
- Simulates simultaneous bet requests
- Verifies balance correctness and no negative balances

**Idempotency Test** (`test-idempotency.js`)
- Tests duplicate request handling with idempotency keys
- Verifies same slip returned for duplicate requests
- Verifies balance deducted only once

**Settlement Accuracy Test** (`test-settlement-accuracy.js`)
- Tests payout calculations after game settlement
- Verifies bet slip statuses (won/lost)
- Verifies payout amounts match expected calculations

**Claim Duplicate Prevention Test** (`test-claim-duplicate.js`)
- Tests winnings cannot be claimed twice
- Verifies duplicate claim prevention
- Verifies balance updated only once

**Usage:**
```bash
# Set access token
export ACCESS_TOKEN="your_jwt_token"

# Run individual tests
node tests/test-betting-race-condition.js <userId> <gameId> [balance]
node tests/test-idempotency.js <userId> <gameId>
node tests/test-settlement-accuracy.js <gameId> <winningCard> [adminId]
node tests/test-claim-duplicate.js <userId> <slipId>
```

---

### Test Coverage

**API Endpoints:**
- ✅ Health & Debug endpoints
- ✅ Authentication endpoints (login, register, logout, refresh)
- ✅ User management endpoints
- ✅ Admin panel endpoints
- ✅ Wallet management endpoints
- ✅ Game management endpoints
- ✅ Betting endpoints (place, claim, history, slip retrieval)
- ✅ Settings management

**Critical Functionality:**
- ✅ Race condition protection (pessimistic locking)
- ✅ Idempotency handling
- ✅ Settlement accuracy
- ✅ Claim duplicate prevention
- ✅ Balance management (credit/debit)
- ✅ Transaction atomicity
- ✅ Authentication & authorization
- ✅ Input validation

**Security Testing:**
- ✅ Unauthorized access prevention
- ✅ Admin route protection
- ✅ Invalid input rejection
- ✅ Authentication token validation

---

### Test Documentation

**Files:**
- `TEST_AUTOMATION_README.md` - Comprehensive testing guide
- `RUN_TESTS.md` - Quick start guide for running tests
- `tests/README.md` - Node.js test scripts documentation
- `requirements_test.txt` - Python test dependencies

**Test Execution Flow:**
```
1. Health Check
   ↓
2. Authentication (Player + Admin)
   ↓
3. Wallet Recharge
   ↓
4. Get Active Game
   ↓
5. Place Bet
   ↓
6. Test Idempotency
   ↓
7. Settle Game
   ↓
8. Claim Winnings
   ↓
9. Admin Functions
   ↓
10. Security Tests
   ↓
11. Generate Report
```

---

**Last Updated**: 2024-12-01  
**API Version**: 1.0.0  
**Base URL**: `http://localhost:5001/api`  
**Development Status**: Phase 9/9 Complete (All Features Implemented & Tested)

