# Quick Test Execution Guide

## 🚀 Run Automated Tests

### Step 1: Ensure Server is Running

```bash
# In project root, start the API server
npm run dev
```

**Verify server is running:**
- Should see "Server running on port 5001"
- Database should be connected
- Cron jobs should be initialized

### Step 2: Install Python Dependencies

```bash
pip install -r requirements_test.txt
```

Or simply:
```bash
pip install requests
```

### Step 3: Run Test Suite

```bash
python test_kismatx_automated.py
```

### Step 4: Review Results

The script will:
1. ✅ Display real-time test results in console
2. ✅ Generate a JSON report: `test_report_YYYYMMDD_HHMMSS.json`
3. ✅ Show a summary at the end

## 📊 What Gets Tested

### Automatic Actions:
1. ✅ Health check
2. ✅ Login as player (player001)
3. ✅ Login as admin (admin001)
4. ✅ Recharge wallet: **+1000 credits** (total becomes 1100)
5. ✅ Find active game
6. ✅ Place bet: Card 5 (100) + Card 7 (150) = 250 total
7. ✅ Test idempotency (duplicate request handling)
8. ✅ Settle game (Card 7 wins)
9. ✅ Claim winnings: 1500 credits
10. ✅ Test duplicate claim prevention
11. ✅ Admin functions (games, stats, settings)
12. ✅ Security tests (unauthorized access, validation)

### Expected Wallet Balance Flow:

```
Initial:     100
+ Recharge: +1000
            -----
            1100
- Bet:      -250
            -----
             850
+ Claim:   +1500
            -----
            2350 (final)
```

## ⚠️ Important Notes

### Active Game Required

The script needs an **active game** for betting tests. If no active game is found:
- Betting tests will be **skipped** (not failed)
- Check the console output for warnings

**To create an active game:**
1. Wait for automatic game creation (07:55 IST daily)
2. Use admin panel to manually create a game
3. Or wait for the next scheduled game

### Credentials Used

The script uses these credentials (hardcoded for testing):
- **Player**: player001 / password123
- **Admin**: admin001 / admin123

### Test Report Location

After execution, find the detailed report at:
```
test_report_YYYYMMDD_HHMMSS.json
```

## 🔍 Troubleshooting

### "Connection refused" Error

**Problem**: Can't connect to API server

**Solution**:
```bash
# Check if server is running
curl http://localhost:5001/api/health

# If not, start the server
npm run dev
```

### "No active game" Warning

**Problem**: Betting tests are skipped

**Solution**: 
- Wait for automatic game creation (runs at 07:55 IST)
- Or manually create a game via admin panel
- Or modify test to wait/retry

### "401 Unauthorized" Error

**Problem**: Login fails

**Solution**:
- Verify credentials in script configuration
- Check if user exists in database
- Ensure user account is active

### "403 Forbidden" Error

**Problem**: Admin route access denied

**Solution**:
- Verify admin login is successful
- Check if user has admin role assigned
- Run `npm run scripts/assign-admin-role.js` if needed

## 📝 Customization

### Change API URL

Edit `test_kismatx_automated.py`:

```python
BASE_URL = "http://your-server:port/api"
```

### Change Credentials

Edit `test_kismatx_automated.py`:

```python
PLAYER_USERID = "your_player"
PLAYER_PASSWORD = "your_password"
ADMIN_USERID = "your_admin"
ADMIN_PASSWORD = "your_admin_password"
```

### Change Recharge Amount

Edit `test_kismatx_automated.py`:

```python
WALLET_RECHARGE_AMOUNT = 5000  # Change to your preferred amount
```

## ✅ Success Indicators

### All Tests Pass

```
🎉 ALL TESTS PASSED!
Tests Run:       25
✅ Passed:       23
⏭️  Skipped:      2
📈 Pass Rate:    92.0%
```

### Partial Success

```
⚠️  MOSTLY PASSED - Review failures above
Tests Run:       25
✅ Passed:       20
❌ Failed:       3
⏭️  Skipped:      2
📈 Pass Rate:    80.0%
```

## 📞 Need Help?

1. Check console output for specific error messages
2. Review JSON test report for detailed results
3. Verify server logs in `logs/combined.log`
4. Ensure all prerequisites are met

---

**Happy Testing! 🧪**





