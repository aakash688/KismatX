# KismatX Automated Test Suites

Comprehensive test suites for Admin Panel and Game UI APIs.

## 📁 Test Suites

### 1. Admin Panel API Tests (`test_admin_panel_apis.py`)
Tests all admin-only endpoints for managing the platform.

### 2. Game UI API Tests (`test_game_ui_apis.py`)
Tests all public game endpoints and player betting functionality.

## 🚀 Quick Start

### Prerequisites

```bash
pip install requests
```

### Run Tests

```bash
# Run Admin Panel tests
python autotest/test_admin_panel_apis.py

# Run Game UI tests
python autotest/test_game_ui_apis.py
```

## 📋 Test Coverage

### Admin Panel Tests

#### Authentication
- ✅ Admin Login

#### Dashboard
- ✅ Get Dashboard Statistics

#### User Management
- ✅ Get All Users (with pagination)
- ✅ Create New User
- ✅ Get User by ID
- ✅ Update User
- ✅ Change User Status
- ✅ Reset User Password
- ✅ Verify User Email
- ✅ Verify User Mobile
- ✅ Get User Login History
- ✅ Kill User Sessions
- ✅ Get User Active Sessions

#### Role Management
- ✅ Get All Roles
- ✅ Create Role
- ✅ Get Role Permissions
- ✅ Assign Roles to User

#### Permission Management
- ✅ Get All Permissions
- ✅ Create Permission

#### Settings Management
- ✅ Get All Settings
- ✅ Update Settings
- ✅ Get Settings Logs

#### Audit Logs
- ✅ Get Audit Logs (with filters)

#### Admin Game Management
- ✅ List All Games
- ✅ Get Game Statistics
- ✅ Get Game Bets
- ✅ Get Settlement Report

#### Security
- ✅ Unauthorized Access Protection

**Total: 30+ test cases**

---

### Game UI Tests

#### Authentication
- ✅ Player Login

#### Public Game Endpoints (No Auth)
- ✅ Get Current Active Game
- ✅ Get Game by ID

#### Player Profile
- ✅ Get My Profile
- ✅ Get User Profile
- ✅ Update User Profile

#### Betting
- ✅ Place Bet
- ✅ Get My Bets
- ✅ Get Bet Slip by Identifier
- ✅ Claim Winnings

#### Wallet
- ✅ Get User Transactions

#### Input Validation
- ✅ Place Bet - Invalid Card Number (13)
- ✅ Place Bet - Negative Amount
- ✅ Place Bet - Zero Amount

#### Security
- ✅ Unauthorized Bet Access Protection

**Total: 15+ test cases**

---

## 📊 Test Reports

Both test suites generate detailed JSON reports:

- `admin_panel_test_report_YYYYMMDD_HHMMSS.json`
- `game_ui_test_report_YYYYMMDD_HHMMSS.json`

### Report Format

```json
{
  "start_time": "2024-12-01T10:30:00",
  "end_time": "2024-12-01T10:35:00",
  "duration_seconds": 300.5,
  "tests_run": 30,
  "tests_passed": 28,
  "tests_failed": 0,
  "tests_skipped": 2,
  "pass_rate": 93.33,
  "details": [
    {
      "name": "Admin Login",
      "status": "✅ PASS",
      "message": "Admin logged in successfully",
      "duration_ms": 45.2
    }
  ]
}
```

## ⚙️ Configuration

Edit the configuration in each test file:

```python
# Admin Panel Tests
BASE_URL = "http://localhost:5001/api"
ADMIN_USERID = "admin001"
ADMIN_PASSWORD = "admin123"

# Game UI Tests
BASE_URL = "http://localhost:5001/api"
PLAYER_USERID = "player001"
PLAYER_PASSWORD = "password123"
```

## 📝 Test Notes

### Admin Panel Tests

- Tests require admin credentials
- Some tests may be skipped if prerequisites aren't met (e.g., no user ID)
- Test data is automatically cleaned up (tests create users, roles, etc.)

### Game UI Tests

- Tests require an active game for betting tests
- If no active game is available, betting tests will be skipped
- Public endpoints (game viewing) don't require authentication
- Player endpoints require player authentication

## 🔧 Customization

### Add Custom Tests

To add custom tests, add a new method to the test class:

```python
def test_custom_endpoint(self, result: TestResult):
    """Test: Custom Endpoint"""
    response = self.make_request("GET", "/custom/endpoint", use_player_token=True)
    if response.status_code == 200:
        result.status = TestStatus.PASS
        result.message = "Custom endpoint works"
    else:
        result.message = f"Expected 200, got {response.status_code}"
```

Then add it to `run_all_tests()`:

```python
self.run_test("Custom Test Name", self.test_custom_endpoint)
```

## ✅ Expected Results

### All Tests Pass

```
📊 ADMIN PANEL TEST SUMMARY
========================================
Tests Run:       30
✅ Passed:       28
⏭️  Skipped:      2
📈 Pass Rate:    93.33%
⏱️  Duration:     45.2s
```

### Some Tests Failed

```
📊 GAME UI TEST SUMMARY
========================================
Tests Run:       15
✅ Passed:       12
❌ Failed:       2
⏭️  Skipped:      1
📈 Pass Rate:    80.0%
```

## 🐛 Troubleshooting

### Connection Error

**Problem**: `Connection refused`

**Solution**: Ensure API server is running on port 5001

### Authentication Failed

**Problem**: `401 Unauthorized`

**Solution**: Verify credentials in test file configuration

### No Active Game

**Problem**: Betting tests skipped

**Solution**: 
- Wait for automatic game creation (07:55 IST daily)
- Or manually create a game via admin panel
- Or update test to use a specific game ID

### Test Data Issues

**Problem**: Tests fail due to missing data

**Solution**: 
- Ensure database is properly initialized
- Run `npm run init-db` to set up test data
- Check that admin and player users exist

---

**Last Updated**: December 2024  
**Test Suite Version**: 1.0.0




