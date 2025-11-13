# ✅ Total Scanned & Claimed Amount Display - UPDATED

## 📊 What Changed

You now see **both** scanned and claimed amounts separately on the Stats page:

### Before (4 Cards):
```
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│  Total Wagered   │ │ Total Scanned    │ │    Margin        │ │  Net To Pay      │
│  1,250,000 pts   │ │ 780,000 pts      │ │ 75,000 pts       │ │ 395,000 pts      │
└──────────────────┘ └──────────────────┘ └──────────────────┘ └──────────────────┘
```

### After (5 Cards):
```
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│  Total Wagered   │ │ Total Scanned    │ │ Total Claimed    │ │    Margin        │ │  Net To Pay      │
│  1,250,000 pts   │ │ 780,000 pts      │ │ 750,000 pts      │ │ 75,000 pts       │ │ 395,000 pts      │
└──────────────────┘ └──────────────────┘ └──────────────────┘ └──────────────────┘ └──────────────────┘
```

---

## 🔍 What Each Card Shows

### 1. **Total Wagered** (Blue) 💙
- Sum of all `bet_slip.total_amount` placed by users
- All bets in the selected date range
- Formula: `SUM(BetSlip.total_amount)`

### 2. **Total Scanned** (Orange) 🟠
- Sum of `bet_slip.payout_amount` where `claimed = true`
- Actual winnings amounts that were claimed by players
- Formula: `SUM(BetSlip.payout_amount WHERE claimed = true)`

### 3. **Total Claimed** (Red) ❤️
- Sum from `wallet_log.amount` where `reference_type = 'game_win'` AND `transaction_direction = 'credit'`
- Verification/double-check of claimed amounts
- Formula: `SUM(WalletLog.amount WHERE reference_type = 'game_win' AND transaction_direction = 'credit')`

### 4. **Margin** (Yellow) 🟡
- 6% of Total Wagered
- Formula: `Total Wagered × 0.06`

### 5. **Net To Pay** (Green/Red) 💚❤️
- Amount the platform needs to pay
- Formula: `Total Wagered - Total Scanned - Margin`
- Green if positive (platform makes money)
- Red if negative (platform loses money)

---

## 🔧 Technical Details

### Backend Changes

**File**: `/src/controllers/admin/adminStatsController.js`

**New Query 3**: Get total scanned from BetSlip
```javascript
// Get claimed payout amounts from BetSlip (scanned/winning amounts)
let claimedBetsWhereCondition = `bet_slip.created_at >= :startDate AND bet_slip.created_at <= :endDate AND bet_slip.claimed = true`;

const claimedBetsResult = await betSlipRepo
  .createQueryBuilder("bet_slip")
  .select("SUM(CAST(bet_slip.payout_amount AS DECIMAL(15,2)))", "total")
  .where(claimedBetsWhereCondition, claimedBetsParams)
  .getRawOne();

const totalScanned = parseFloat(claimedBetsResult?.total || 0);
```

**New Query 4**: Keep existing WalletLog query for claimed amounts
```javascript
// This remains as verification/reference for claimed amounts
const totalClaimedWalletLog = parseFloat(claimedWinnings?.total || 0);
```

**Response Updated**:
```json
{
  "success": true,
  "data": {
    "summary": {
      "totalWagered": 1250000,
      "totalScanned": 780000,
      "totalClaimedWalletLog": 750000,
      "margin": 75000,
      "netToPay": 395000
    },
    "userStats": [...]
  }
}
```

### Frontend Changes

**File**: `adminpanelui/src/services/services.ts`

Updated `StatsData` interface:
```typescript
export interface StatsData {
  totalWagered: number;
  totalScanned: number;
  totalClaimedWalletLog: number;  // ✅ NEW
  margin: number;
  netToPay: number;
}
```

**File**: `adminpanelui/src/pages/StatsPage.tsx`

Updated stats cards grid from `lg:grid-cols-4` to `lg:grid-cols-5`:
```tsx
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6">
  {[
    { title: "Total Wagered", value: stats.totalWagered, ... },
    { title: "Total Scanned", value: stats.totalScanned, ... },
    { title: "Total Claimed", value: stats.totalClaimedWalletLog, ... },  // ✅ NEW
    { title: "Margin", value: stats.margin, ... },
    { title: "Net To Pay", value: stats.netToPay, ... },
  ]}
</div>
```

---

## 📱 Responsive Design

The cards adapt to screen size:

### Mobile (1 column):
```
┌─────────────────────────────┐
│  Total Wagered              │
│  1,250,000 pts              │
├─────────────────────────────┤
│  Total Scanned              │
│  780,000 pts                │
├─────────────────────────────┤
│  Total Claimed              │
│  750,000 pts                │
├─────────────────────────────┤
│  Margin                     │
│  75,000 pts                 │
├─────────────────────────────┤
│  Net To Pay                 │
│  395,000 pts                │
└─────────────────────────────┘
```

### Tablet (2 columns):
```
┌──────────────────┐ ┌──────────────────┐
│  Total Wagered   │ │ Total Scanned    │
│  1,250,000 pts   │ │ 780,000 pts      │
└──────────────────┘ └──────────────────┘
┌──────────────────┐ ┌──────────────────┐
│  Total Claimed   │ │    Margin        │
│  750,000 pts     │ │ 75,000 pts       │
└──────────────────┘ └──────────────────┘
┌──────────────────┐
│  Net To Pay      │
│  395,000 pts     │
└──────────────────┘
```

### Desktop (5 columns):
```
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│  Wagered │ │ Scanned  │ │ Claimed  │ │  Margin  │ │Net To Pay│
│1,250,000 │ │  780,000 │ │  750,000 │ │  75,000  │ │ 395,000  │
└──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘
```

---

## 🎨 Color Coding

| Card | Color | Meaning |
|------|-------|---------|
| Total Wagered | Blue `text-blue-600` | Money wagered by players |
| Total Scanned | Orange `text-orange-600` | Winnings claimed (BetSlip source) |
| Total Claimed | Red `text-red-600` | Winnings claimed (WalletLog verification) |
| Margin | Yellow `text-yellow-600` | Platform commission (6%) |
| Net To Pay | Green/Red | Platform profit/loss |

---

## 🔄 Data Flow

```
User Changes Filter
    ↓
statsService.getStats(startDate, endDate, userId)
    ↓
POST /api/admin/stats
    ↓
Backend Queries:
  ✓ Query 1: Total wagered from BetSlip
  ✓ Query 2: Total scanned from BetSlip (claimed=true)
  ✓ Query 3: Total claimed from WalletLog (verification)
  ✓ Calculations: Margin (6%), Net To Pay
    ↓
Response with all 5 values
    ↓
Frontend displays 5 cards
    ↓
User sees all metrics together
```

---

## ✨ Benefits

✅ **Complete Visibility**: See all money flows at once
✅ **Verification**: Compare scanned vs claimed amounts for discrepancies
✅ **Transparency**: Clear breakdown of platform economics
✅ **Margin Clarity**: See exactly how much platform takes (6%)
✅ **Net Position**: Know profit/loss at a glance
✅ **Real Data**: All amounts from actual database queries
✅ **Responsive**: Works on mobile, tablet, and desktop
✅ **Industrial Grade**: Professional metrics dashboard

---

## 🧪 How to Test

### Test 1: View Default Stats
1. Open `http://localhost:3001/stats`
2. Should show today's date with all 5 cards
3. Should display real data from database

### Test 2: Verify Numbers
1. Check that `Total Claimed` and `Total Scanned` values make sense
2. They should be similar (both represent claimed winnings)
3. Note: May differ slightly due to wallet logging timing

### Test 3: Test Filters
1. Change date range
2. All 5 cards should update
3. Select a specific user
4. Cards should show only that user's stats

### Test 4: Verify Calculations
1. Manually calculate: `Margin = Total Wagered × 0.06`
2. Manually calculate: `Net To Pay = Total Wagered - Total Scanned - Margin`
3. Verify they match the displayed values

---

## 📊 Sample Data

```
Scenario: Today's stats with all users

Total Wagered:        1,250,000 pts
Total Scanned:          780,000 pts (claimed winnings)
Total Claimed:          750,000 pts (wallet log verification)
Margin (6%):             75,000 pts (platform commission)
Net To Pay:             395,000 pts (platform profit)

Calculation Check:
  Margin = 1,250,000 × 0.06 = 75,000 ✓
  Net = 1,250,000 - 780,000 - 75,000 = 395,000 ✓
```

---

## 🚀 Status: COMPLETE

The Stats page now displays:
- ✅ Total Wagered (all bets placed)
- ✅ Total Scanned (winnings from BetSlip)
- ✅ **Total Claimed (winnings from WalletLog) - NEW**
- ✅ Margin (6% of wagered)
- ✅ Net To Pay (profit/loss)

All in one professional dashboard view! 🎉
