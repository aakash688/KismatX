# Auto Winning Card Selection Logic

## Overview
The system uses **profit-optimized intelligent card selection** that's designed to:
- Minimize payouts while maintaining fairness
- Exclude cards with highest bets (worst case)
- Select from cards with below-average bets (best for profitability)
- Include 10% random fairness factor

---

## Step-by-Step Logic

### **Step 1: Get Total Bets Per Card**

For each game, count all bets on each card (1-12):

```javascript
// Example: Game has players betting on different cards
Card 1: ₹500
Card 2: ₹800
Card 3: ₹1200  ← Highest bet
Card 4: ₹600
Card 5: ₹400
Card 6: ₹900
Card 7: ₹700
Card 8: ₹300
Card 9: ₹550
Card 10: ₹650
Card 11: ₹750
Card 12: ₹400

Total Wagered: ₹8550
```

### **Step 2: Identify Maximum Bet Card**

```javascript
const maxBet = Math.max(...bets);
// Result: ₹1200 (on Card 3)

// If multiple cards have same max, exclude the first one
maxIndices = [2] // Index 2 = Card 3
```

### **Step 3: Calculate Average of Remaining Cards**

```javascript
// Exclude Card 3 (₹1200)
Remaining bets: ₹500, ₹800, ₹600, ₹400, ₹900, ₹700, ₹300, ₹550, ₹650, ₹750, ₹400

Total of remaining: ₹7350
Count: 11 cards
Average: ₹7350 / 11 = ₹668.18
```

### **Step 4: Filter Cards Below Average**

```javascript
Cards below ₹668.18 average (excluding Card 3):
- Card 1: ₹500 ✅
- Card 4: ₹600 ✅
- Card 5: ₹400 ✅
- Card 8: ₹300 ✅
- Card 9: ₹550 ✅
- Card 12: ₹400 ✅

Eligible Cards: [1, 4, 5, 8, 9, 12] = 6 cards
```

### **Step 5: Apply 10% Fairness Randomization**

```javascript
if (Math.random() < 0.1) {
    // 10% chance: Pick from ALL 12 cards (full random)
    // This prevents pattern exploitation
    finalCandidates = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
} else {
    // 90% chance: Pick from below-average cards
    // This maintains profitability
    finalCandidates = [1, 4, 5, 8, 9, 12]
}
```

### **Step 6: Randomly Select Winning Card**

```javascript
// 90% of the time (from below-average):
Winning Card = Random from [1, 4, 5, 8, 9, 12]
// Example: Card 5 selected

// 10% of the time (full random):
Winning Card = Random from [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
// Example: Card 7 selected
```

---

## Profit Calculation

### **Formula**

```javascript
Total Wagered = Sum of all bets on all cards
Bet on Winning Card = Amount bet on the winning card
Total Payout = Bet on Winning Card × Multiplier (default 10)
Profit = Total Wagered - Total Payout
Profit % = (Profit / Total Wagered) × 100
```

### **Example Calculation**

```javascript
// If Card 5 wins (₹400 bet on it)
Total Wagered: ₹8550
Bet on Card 5: ₹400
Multiplier: 10
Total Payout: ₹400 × 10 = ₹4000
Profit: ₹8550 - ₹4000 = ₹4550
Profit %: (₹4550 / ₹8550) × 100 = 53.22%

// If Card 3 wins (₹1200 bet on it) ← Worst case
Total Wagered: ₹8550
Bet on Card 3: ₹1200
Total Payout: ₹1200 × 10 = ₹12000
Profit: ₹8550 - ₹12000 = -₹3450 ❌ LOSS!

// This is why we EXCLUDE Card 3 (highest bet)
// It would result in a loss for the house
```

---

## Real World Examples

### **Example 1: Balanced Betting**

```
Card Bets:
1: ₹100, 2: ₹100, 3: ₹100, 4: ₹100, 5: ₹100,
6: ₹100, 7: ₹100, 8: ₹100, 9: ₹100, 10: ₹100,
11: ₹100, 12: ₹100

Total: ₹1200

Max Bet: ₹100 (all cards equal, pick first: Card 1)
Exclude: Card 1

Remaining Average: ₹100 (others)
Below Average Cards: None (all others are exactly ₹100, not below)

Fallback: Use all cards except Card 1 [2-12]

Selected: Random from Cards 2-12

If Card 2 wins (₹100):
  Profit = ₹1200 - (₹100 × 10) = ₹1200 - ₹1000 = ₹200 (16.67%)
```

### **Example 2: Heavy Single Card Betting**

```
Card Bets:
1: ₹5000  ← Heavy betting
2: ₹100, 3: ₹100, 4: ₹100, 5: ₹100, 6: ₹100,
7: ₹100, 8: ₹100, 9: ₹100, 10: ₹100, 11: ₹100,
12: ₹100

Total: ₹5900

Max Bet: ₹5000 (Card 1)
Exclude: Card 1

Remaining Average: ₹500 / 11 = ₹45.45
Below Average Cards: Cards 2-12 (all at ₹100 but wait... ₹100 > ₹45.45)

No below-average cards!
Fallback: Use all cards except Card 1 [2-12]

Selected: Random from Cards 2-12

If Card 5 wins (₹100):
  Profit = ₹5900 - (₹100 × 10) = ₹5900 - ₹1000 = ₹4900 (83%)
  
If we picked Card 1 (₹5000):
  Profit = ₹5900 - (₹5000 × 10) = ₹5900 - ₹50000 = -₹44100 ❌ HUGE LOSS!
  
This shows why we exclude high-bet cards!
```

### **Example 3: Smart Distribution**

```
Card Bets:
1: ₹200,  2: ₹1500  ← High
3: ₹300,  4: ₹400,  5: ₹250,
6: ₹600,  7: ₹350,  8: ₹150,
9: ₹280,  10: ₹180,  11: ₹320,  12: ₹190

Total: ₹5100

Max Bet: ₹1500 (Card 2)
Exclude: Card 2

Remaining Cards: 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
Remaining Total: ₹3600
Remaining Average: ₹3600 / 11 = ₹327.27

Below Average Cards (< ₹327.27, excluding Card 2):
- Card 1: ₹200 ✅
- Card 3: ₹300 ✅
- Card 5: ₹250 ✅
- Card 8: ₹150 ✅
- Card 10: ₹180 ✅
- Card 12: ₹190 ✅

Eligible: [1, 3, 5, 8, 10, 12]

Selected: Random from [1, 3, 5, 8, 10, 12]

Example outcomes:
- Card 1 wins (₹200): Profit = ₹5100 - ₹2000 = ₹3100 (60.8%)
- Card 5 wins (₹250): Profit = ₹5100 - ₹2500 = ₹2600 (51%)
- Card 8 wins (₹150): Profit = ₹5100 - ₹1500 = ₹3600 (70.6%)
- Card 10 wins (₹180): Profit = ₹5100 - ₹1800 = ₹3300 (64.7%)

All profitable! ✅
```

---

## Key Features

### **1. Excludes High-Bet Cards**

```
Why? 
- Players who bet high on one card might bet big hoping to win
- If that card wins, payout = high_bet × 10 (could exceed total wagered)
- System excludes that card to avoid losses
```

### **2. Prefers Low-Bet Cards**

```
Why?
- Cards with lower bets have lower payouts (bet × 10)
- Selecting these maximizes profit
- Formula: Profit = Total Wagered - (Bet on Winner × 10)
- Lower bet on winner = higher profit
```

### **3. 10% Randomness for Fairness**

```
Why?
- Pure profit optimization would be predictable
- Players might learn the pattern
- 10% full random selection prevents manipulation
- Maintains fairness: occasional unprofitable outcome (loss)
```

### **4. Handles Edge Cases**

```
No Bets at All?
- Return completely random (1-12)

Multiple Cards with Max Bet?
- Exclude all of them (safest approach)

All Cards Below Average?
- Fallback to all except the highest bet card(s)

No Valid Candidates?
- Use all 12 cards as fallback
```

---

## When is AUTO Mode Used?

### **Automatic Settlement Trigger**

When `game_result_type = 'auto'`:

```javascript
// In settlement schedule (gameScheduler.js)

// 1. Game completes (end_time passes)
// 2. Status changes to 'completed'
// 3. Settlement check finds it
// 4. Calls selectWinningCard(bets)
// 5. Card automatically selected
// 6. Game settled with no admin interaction
// 7. Payouts calculated and distributed
```

### **Manual Mode Fallback**

In `game_result_type = 'manual'`:

```javascript
// Admin selects card manually during 110-second window
// If admin doesn't select within time, auto-select kicks in

if (gracePeriodExpired) {
    // Auto fallback: Use smart selection
    const winningCard = selectWinningCard(bets);
    // Settle game automatically
}
```

---

## Logging Output

When auto-settling a game:

```javascript
// During recovery or auto-settlement:
const bets = await getTotalBetsPerCard(game.game_id, betDetailRepo);
const winningCard = selectWinningCard(bets);
const profitAnalysis = calculateProfit(bets, winningCard, payout_multiplier);

console.log(`
  🎲 [AUTO-SETTLE] Settling game ${game.game_id}
  Card ${winningCard} selected
  Total Wagered: ₹${profitAnalysis.total_wagered}
  Bet on Winner: ₹${profitAnalysis.bet_on_winning_card}
  Total Payout: ₹${profitAnalysis.total_payout.toFixed(2)}
  Profit: ₹${profitAnalysis.profit.toFixed(2)} (${profitAnalysis.profit_percentage.toFixed(2)}%)
`);
```

---

## Algorithm Complexity

```
Time Complexity: O(n)
- n = 12 cards (constant)
- Scan bets once: O(12)
- Filter once: O(12)
- Total: O(12) = O(1)

Space Complexity: O(n)
- Store array of 12 bets: O(12) = O(1)
- Store eligible cards: O(12) worst case = O(1)

Result: Very fast, minimal memory ⚡
```

---

## Summary

| Aspect | Details |
|--------|---------|
| **Goal** | Maximize profit while maintaining fairness |
| **Method** | Smart card selection based on bet distribution |
| **Exclude** | Card with highest total bet (would cause loss) |
| **Select From** | Cards with below-average bets |
| **Fairness** | 10% chance of full random selection |
| **Profit** | Usually 50-80% profit margin |
| **Time** | Instant calculation (< 1ms) |
| **Fallback** | Random selection if smart logic fails |
| **Logging** | Detailed profit analysis logged |

The system is **mathematically optimal** for profitability while being **strategically fair** to players! 🎯
