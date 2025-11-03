# Test Scripts

This directory contains automated test scripts for critical functionality testing.

## Prerequisites

1. **Environment Variables:**
   ```bash
   export ACCESS_TOKEN="your_jwt_access_token"
   export API_BASE_URL="http://localhost:5001/api"  # Optional, defaults to localhost:5001
   ```

2. **Dependencies:**
   - Node.js with ES modules support
   - `axios` package (install with `npm install axios`)
   - `uuid` package (install with `npm install uuid`)

3. **Server Running:**
   - Ensure the backend server is running on port 5001 (or adjust API_BASE_URL)

## Test Scripts

### 1. Race Condition Test
**File:** `test-betting-race-condition.js`

Tests that pessimistic locking prevents race conditions when placing simultaneous bets.

**Usage:**
```bash
export ACCESS_TOKEN="your_token"
node tests/test-betting-race-condition.js <userId> <gameId> [userBalance]
```

**Example:**
```bash
node tests/test-betting-race-condition.js 1 202412011200 100
```

**What it does:**
- Sends 2 simultaneous bet requests from the same user
- Each bet is 80% of user balance
- Verifies only 1 bet succeeds
- Verifies balance is correct
- Verifies balance never goes negative

**Expected Result:**
- ✅ One bet succeeds (201 Created)
- ✅ One bet fails (400 Insufficient balance)
- ✅ Final balance is correct (initial - bet amount)
- ✅ No negative balance

---

### 2. Idempotency Test
**File:** `test-idempotency.js`

Tests that duplicate requests with the same idempotency key are handled correctly.

**Usage:**
```bash
export ACCESS_TOKEN="your_token"
node tests/test-idempotency.js <userId> <gameId>
```

**Example:**
```bash
node tests/test-idempotency.js 1 202412011200
```

**What it does:**
- Sends first bet request with idempotency key
- Sends second identical request with same idempotency key
- Verifies second request returns existing slip
- Verifies balance deducted only once

**Expected Result:**
- ✅ First request: 201 Created
- ✅ Second request: 200 OK (duplicate detected)
- ✅ Same slip ID returned
- ✅ Balance deducted once

---

### 3. Settlement Accuracy Test
**File:** `test-settlement-accuracy.js`

Tests that payout calculations are correct after game settlement.

**Usage:**
```bash
export ACCESS_TOKEN="your_admin_token"
node tests/test-settlement-accuracy.js <gameId> <winningCard> [adminId]
```

**Example:**
```bash
node tests/test-settlement-accuracy.js 202412011200 7 1
```

**What it does:**
- Fetches game details
- Settles the game with specified winning card
- Verifies all bet slips have correct payout amounts
- Verifies slip statuses are correct (won/lost)
- Verifies total payout calculations

**Expected Result:**
- ✅ Winner bets have correct payout (bet_amount × multiplier)
- ✅ Loser bets have payout = 0
- ✅ Slip statuses are correct (won/lost)
- ✅ Total payout matches expected

---

### 4. Claim Duplicate Prevention Test
**File:** `test-claim-duplicate.js`

Tests that winnings cannot be claimed twice.

**Usage:**
```bash
export ACCESS_TOKEN="your_token"
node tests/test-claim-duplicate.js <userId> <slipIdOrBarcode>
```

**Example:**
```bash
node tests/test-claim-duplicate.js 1 abc-123-def-456
```

**What it does:**
- Attempts to claim winnings first time
- Attempts to claim same slip second time
- Verifies second claim is rejected
- Verifies balance increased only once
- Verifies slip marked as claimed

**Expected Result:**
- ✅ First claim: Success
- ✅ Second claim: Error "Already claimed"
- ✅ Balance increased only once
- ✅ Slip.claimed = true

---

## Running All Tests

To run all tests in sequence:

```bash
# Set your access token
export ACCESS_TOKEN="your_token_here"

# Run tests (adjust parameters as needed)
node tests/test-idempotency.js 1 202412011200
node tests/test-claim-duplicate.js 1 slip-123-abc
node tests/test-settlement-accuracy.js 202412011200 7 1
```

## Test Results

All test scripts exit with:
- **Exit code 0**: Test passed ✅
- **Exit code 1**: Test failed ❌

## Notes

1. **Authentication**: You need a valid JWT access token. Get one by logging in via `/api/auth/login`

2. **Test Data**: Ensure you have:
   - Valid user IDs
   - Active games
   - Sufficient user balance
   - Winning bet slips (for claim test)

3. **Admin Token**: Some tests (like settlement) require an admin token with appropriate permissions

4. **Server State**: Tests may modify database state. Consider using a test database or restoring data after tests.

5. **Timing**: Some tests include small delays to ensure database consistency. This is normal.

## Troubleshooting

**Error: "ACCESS_TOKEN environment variable not set"**
- Set the token: `export ACCESS_TOKEN="your_token"`

**Error: "ECONNREFUSED"**
- Ensure the server is running on port 5001
- Check API_BASE_URL if using a different port

**Error: "401 Unauthorized"**
- Token may have expired. Get a new token by logging in
- Ensure token is for the correct user (some tests need admin token)

**Error: "Game not found"**
- Ensure the game ID exists
- Check that the game is in the correct state (completed for settlement)

**Test fails but logic seems correct:**
- Check server logs for detailed error messages
- Verify database state matches expectations
- Ensure all required data exists (users, games, bets)
