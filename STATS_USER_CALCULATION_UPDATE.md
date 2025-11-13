# ✅ User Stats - Per-User Calculations Applied

## 📊 What Changed

Applied the same calculation logic from the summary to the Users Stats table:

### Before:
- User Scanned was using WalletLog data
- Inconsistent with summary calculation
- Sometimes showing 0 when it shouldn't

### After:
- User Scanned now uses BetSlip payout_amount (claimed=true)
- **Consistent with summary calculation**
- Single source of truth for all metrics

---

## 🔧 Technical Change

**File**: `/src/controllers/admin/adminStatsController.js`

**Changed Query** (Per-User Claimed Winnings):
```javascript
// OLD: Using WalletLog
const claimedPerUser = await walletLogRepo
  .createQueryBuilder("wallet_log")
  .select("wallet_log.user_id", "user_id")
  .addSelect("SUM(CAST(wallet_log.amount AS DECIMAL(15,2)))", "total")
  .where(
    `wallet_log.created_at >= :startDate AND wallet_log.created_at <= :endDate 
     AND wallet_log.reference_type = 'game_win' 
     AND wallet_log.transaction_direction = 'credit'`,
    whereParams
  )
  .groupBy("wallet_log.user_id")
  .getRawMany();

// NEW: Using BetSlip (same as summary)
const claimedPerUser = await betSlipRepo
  .createQueryBuilder("bet_slip")
  .select("bet_slip.user_id", "user_id")
  .addSelect("SUM(CAST(bet_slip.payout_amount AS DECIMAL(15,2)))", "total")
  .where(
    `bet_slip.created_at >= :startDate AND bet_slip.created_at <= :endDate 
     AND bet_slip.claimed = true`,
    whereParams
  )
  .groupBy("bet_slip.user_id")
  .getRawMany();
```

---

## 📈 Per-User Calculation Logic

For **each user**, the same formulas apply:

```javascript
const userWagered = sum of all bet_slip.total_amount
const userScanned = sum of all bet_slip.payout_amount (claimed=true)
const userMargin = userWagered × 0.06
const userNetToPay = userWagered - userScanned - userMargin
```

### Example:
```
Player: John Doe
Wagered: 2,475 pts
Scanned: 180 pts (claimed winnings)
Margin: 148.5 pts (6% of 2,475)
Net To Pay: 2,146.5 pts (2,475 - 180 - 148.5)
```

---

## ✨ Benefits

✅ **Consistency**: Summary and per-user calculations now use the same source
✅ **Accuracy**: Both use BetSlip which is the authoritative source
✅ **Single Source of Truth**: No confusion about where numbers come from
✅ **No Discrepancies**: Summary should equal sum of all users' stats
✅ **Easy to Verify**: Admin can check per-user stats add up to summary

---

## 🔄 Complete Data Flow (Now Unified)

```
Summary Stats Query:
  └─ Total Scanned = SUM(BetSlip.payout_amount WHERE claimed=true)

Per-User Stats Query:
  └─ User Scanned = SUM(BetSlip.payout_amount WHERE claimed=true GROUP BY user_id)

Calculations (Same for Both):
  └─ Margin = Amount × 0.06
  └─ Net To Pay = Amount - Scanned - Margin
```

---

## 📊 Users Stats Table (Now Accurate)

```
User Name           | Wagered  | Scanned  | Margin  | Net To Pay
────────────────────────────────────────────────────────────────
Player One (001)    | 2,475    | 180      | 148.5   | 2,146.5
Player Two (002)    | 1,500    | 120      | 90.0    | 1,290.0
Player Three (003)  | 3,200    | 250      | 192.0   | 2,758.0
────────────────────────────────────────────────────────────────
TOTAL (Summary)     | 7,175    | 550      | 430.5   | 6,194.5
```

Note: Summary totals should equal the sum of all users

---

## 🧪 Testing

### Test 1: Verify Sum Equals Summary
1. Open Stats page with date range
2. Note the summary totals
3. Add up all user scanned amounts in the table
4. Should equal the summary total scanned ✓

### Test 2: Verify Calculations
1. Pick any user in the table
2. Manually calculate: `Margin = Wagered × 0.06`
3. Manually calculate: `Net To Pay = Wagered - Scanned - Margin`
4. Should match the displayed values ✓

### Test 3: Test Filters
1. Select a specific user
2. User's numbers should appear in both summary and table
3. Table shows only that user ✓

---

## ✅ Status: COMPLETE

Applied the same unified calculation to both:
- ✅ Summary Stats cards
- ✅ User Stats table

All metrics now use **BetSlip as the single source of truth** for claimed winnings!

The Stats page is now **fully consistent** across summary and per-user views. 🎉
