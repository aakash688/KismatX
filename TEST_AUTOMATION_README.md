# KismatX Automated Test Suite

Comprehensive Python test script that automatically validates all API endpoints and functionality for the KismatX platform.

## 📋 Overview

This automated test suite covers:
- ✅ Health checks
- ✅ Authentication (Player & Admin)
- ✅ Wallet management (Recharge)
- ✅ Game operations
- ✅ Betting flow (Place, Idempotency)
- ✅ Settlement & Claims
- ✅ Admin functions
- ✅ Security validation
- ✅ Input validation

## 🚀 Quick Start

### Prerequisites

1. **Python 3.7+** installed
2. **KismatX API Server** running on `http://localhost:5001`
3. **Database** configured and accessible
4. **Active game** available (or script will skip betting tests)

### Installation

```bash
# Install required Python packages
pip install -r requirements_test.txt

# Or install directly
pip install requests
```

### Configuration

Edit the configuration at the top of `test_kismatx_automated.py` if needed:

```python
BASE_URL = "http://localhost:5001/api"  # Change if your API is on different port
PLAYER_USERID = "player001"
PLAYER_PASSWORD = "password123"
ADMIN_USERID = "admin001"
ADMIN_PASSWORD = "admin123"
WALLET_RECHARGE_AMOUNT = 1000
```

### Running Tests

```bash
# Run the test suite
python test_kismatx_automated.py
```

Or on Linux/Mac:

```bash
chmod +x test_kismatx_automated.py
./test_kismatx_automated.py
```

## 📊 Test Coverage

### Step 1: Pre-Flight Checks
- Health check endpoint
- Current game availability

### Step 2: Authentication
- Player login
- Admin login

### Step 3: Wallet Management
- Wallet recharge (1000 credits)
- Get user transactions

### Step 4: Game & Betting
- Get current active game
- Place bet (Card 5: 100, Card 7: 150)
- Idempotency check (duplicate request handling)
- Get bet history
- Get bet slip details

### Step 5: Settlement & Claims
- Settle game (Card 7 wins)
- Claim winnings
- Duplicate claim prevention

### Step 6: Admin Functions
- List all games
- Game statistics
- Settlement report
- Get settings
- Update settings

### Step 7: User Profile
- Get user profile

### Step 8: Security Tests
- Unauthorized access protection
- Admin route protection
- Input validation (invalid card number)
- Input validation (negative bet amount)

## 📄 Test Report

After execution, the script generates:

1. **Console Output**: Real-time test results with status indicators
2. **JSON Report**: `test_report_YYYYMMDD_HHMMSS.json` with detailed results

### Report Format

```json
{
  "start_time": "2024-12-01T10:30:00",
  "end_time": "2024-12-01T10:35:00",
  "duration_seconds": 300.5,
  "tests_run": 25,
  "tests_passed": 23,
  "tests_failed": 0,
  "tests_skipped": 2,
  "pass_rate": 92.0,
  "details": [
    {
      "name": "1.1 Health Check",
      "status": "✅ PASS",
      "message": "Server is healthy",
      "duration_ms": 45.2
    },
    ...
  ]
}
```

## 🔧 Test Execution Flow

```
1. Health Check
   ↓
2. Authentication (Player + Admin)
   ↓
3. Wallet Recharge (1000 credits)
   ↓
4. Get Active Game
   ↓
5. Place Bet (if game available)
   ↓
6. Test Idempotency
   ↓
7. Settle Game (Card 7)
   ↓
8. Claim Winnings
   ↓
9. Admin Functions
   ↓
10. Security Tests
   ↓
11. Generate Report
```

## ⚠️ Notes

### Active Game Required

Some tests require an active game to be available:
- If no active game is found, betting-related tests will be skipped
- To create an active game, either:
  1. Wait for automatic game creation (07:55 IST daily)
  2. Manually create a game via admin panel
  3. Use the manual game creation scripts in `tests/manual/`

### Wallet Balance

The script automatically recharges the player's wallet with **1000 credits**:
- Initial balance: 100
- After recharge: 1100
- After bet (250): 850
- After claim (1500): 2350

### Test Data

The script uses the following test data:
- **Player**: player001 / password123
- **Admin**: admin001 / admin123
- **Bet**: Card 5 (100) + Card 7 (150) = 250 total
- **Winning Card**: 7
- **Expected Payout**: 150 × 10 (multiplier) = 1,500

## 🐛 Troubleshooting

### Connection Error

```
❌ Request failed: Connection refused
```

**Solution**: Ensure the KismatX API server is running on port 5001

### Authentication Failed

```
❌ FAIL 2.1 Player Login
   → Expected 200, got 401
```

**Solution**: Verify player credentials are correct in the script configuration

### No Active Game

```
⏭️  SKIP 4.2 Place Bet
   → No active game available
```

**Solution**: 
- Wait for automatic game creation
- Or manually create a game via admin panel
- Or run the manual game creation script

### Settlement Fails

```
❌ FAIL 5.1 Settle Game
   → Expected 200, got 400
```

**Solution**: 
- Ensure game is in 'completed' status before settlement
- Check if game was already settled
- Verify admin token is valid

## 📝 Customization

### Add Custom Tests

To add custom tests, add a new method to the `KismatXTestSuite` class:

```python
def test_custom_endpoint(self, result: TestResult):
    """Test: Custom Endpoint"""
    response = self.make_request("GET", "/custom/endpoint",
                                use_player_token=True)
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

### Change Test Configuration

Modify the configuration constants at the top of the script:

```python
BASE_URL = "http://your-api-url:port/api"
PLAYER_USERID = "your_player"
PLAYER_PASSWORD = "your_password"
WALLET_RECHARGE_AMOUNT = 5000  # Change recharge amount
```

## 📈 Expected Results

### All Tests Pass

```
🎉 ALL TESTS PASSED!
Tests Run:       25
✅ Passed:       23
⏭️  Skipped:      2
📈 Pass Rate:    92.0%
```

### Some Tests Failed

```
⚠️  MOSTLY PASSED - Review failures above
Tests Run:       25
✅ Passed:       20
❌ Failed:       3
⏭️  Skipped:      2
📈 Pass Rate:    80.0%
```

## 🔐 Security Note

This test script uses hardcoded credentials for testing purposes. **Never commit credentials to production repositories**. Consider using environment variables:

```python
import os
PLAYER_USERID = os.getenv("TEST_PLAYER_USERID", "player001")
PLAYER_PASSWORD = os.getenv("TEST_PLAYER_PASSWORD", "password123")
```

## 📞 Support

For issues or questions:
1. Check the console output for detailed error messages
2. Review the JSON test report for specific test failures
3. Ensure all prerequisites are met
4. Verify API server is running and accessible

---

**Last Updated**: December 2024  
**Test Suite Version**: 1.0.0





