# How to Check Bet Slip Result by Barcode

## 📋 Quick Answer

Use the API endpoint:
```
GET /api/bets/slip/:identifier
```

Where `:identifier` can be:
- **Barcode** (e.g., `KX-20251102-ABC123`)
- **Slip ID** (UUID format)

---

## 🔧 API Details

### **Endpoint:**
```
GET /api/bets/slip/:identifier
```

### **Authentication:**
✅ **Required** - Must be logged in (Player or Admin)

### **Parameters:**
- `identifier` (path parameter) - The barcode or slip ID

### **Example Request:**

#### **Using Barcode:**
```bash
GET /api/bets/slip/KX-20251102-ABC123
Authorization: Bearer YOUR_ACCESS_TOKEN
```

#### **Using Slip ID:**
```bash
GET /api/bets/slip/550e8400-e29b-41d4-a716-446655440000
Authorization: Bearer YOUR_ACCESS_TOKEN
```

---

## 📤 Response Format

### **Success Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "slip_id": "550e8400-e29b-41d4-a716-446655440000",
    "barcode": "KX-20251102-ABC123",
    "game_id": "202511021400",
    "total_amount": 250.00,
    "payout_amount": 2500.00,
    "status": "won",
    "claimed": false,
    "claimed_at": null,
    "created_at": "2025-11-02 14:01:30",
    "game": {
      "game_id": "202511021400",
      "start_time": "2025-11-02 14:00:00",
      "end_time": "2025-11-02 14:05:00",
      "status": "completed",
      "winning_card": 5,
      "settlement_status": "settled",
      "payout_multiplier": 10
    },
    "bets": [
      {
        "card_number": 5,
        "bet_amount": 150.00,
        "is_winner": true,
        "payout_amount": 1500.00
      },
      {
        "card_number": 7,
        "bet_amount": 100.00,
        "is_winner": false,
        "payout_amount": 0
      }
    ]
  }
}
```

### **Error Responses:**

#### **Slip Not Found (404):**
```json
{
  "success": false,
  "message": "Bet slip not found"
}
```

#### **Unauthorized (401):**
```json
{
  "message": "User Unauthorized"
}
```

#### **Access Denied (404 - if not owner and not admin):**
```json
{
  "success": false,
  "message": "Bet slip not found"
}
```

---

## 🔍 Response Fields Explained

| Field | Description | Example |
|-------|-------------|---------|
| `slip_id` | Unique slip identifier (UUID) | `550e8400-...` |
| `barcode` | Human-readable barcode | `KX-20251102-ABC123` |
| `game_id` | Game ID this bet was placed in | `202511021400` |
| `total_amount` | Total amount bet on this slip | `250.00` |
| `payout_amount` | Total winnings (0 if lost) | `2500.00` |
| `status` | Slip status: `pending`, `won`, `lost` | `won` |
| `claimed` | Whether player has claimed winnings | `false` |
| `claimed_at` | When winnings were claimed (if claimed) | `null` or timestamp |
| `created_at` | When bet was placed | `2025-11-02 14:01:30` |
| `game.winning_card` | The winning card for this game | `5` |
| `game.settlement_status` | Game settlement status | `settled` |
| `bets[]` | Array of individual bets on this slip | See below |

### **Bet Details Array:**
Each bet shows:
- `card_number`: Which card was bet on (1-12)
- `bet_amount`: How much was bet on this card
- `is_winner`: Whether this bet won (true/false)
- `payout_amount`: Winnings for this bet (bet_amount × multiplier)

---

## 📱 Usage Examples

### **1. Using cURL:**
```bash
curl -X GET "http://localhost:5000/api/bets/slip/KX-20251102-ABC123" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json"
```

### **2. Using JavaScript/Fetch:**
```javascript
async function checkSlipByBarcode(barcode, accessToken) {
  try {
    const response = await fetch(`http://localhost:5000/api/bets/slip/${barcode}`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json'
      }
    });

    const data = await response.json();
    
    if (data.success) {
      console.log('Bet Slip Details:');
      console.log('Status:', data.data.status); // won/lost/pending
      console.log('Total Bet:', data.data.total_amount);
      console.log('Payout:', data.data.payout_amount);
      console.log('Winning Card:', data.data.game.winning_card);
      console.log('Claimed:', data.data.claimed);
      
      // Show individual bets
      data.data.bets.forEach(bet => {
        console.log(`Card ${bet.card_number}: ₹${bet.bet_amount} - ${bet.is_winner ? 'WON' : 'LOST'} - Payout: ₹${bet.payout_amount}`);
      });
    } else {
      console.error('Error:', data.message);
    }
  } catch (error) {
    console.error('Request failed:', error);
  }
}

// Usage
checkSlipByBarcode('KX-20251102-ABC123', 'your-access-token');
```

### **3. Using Python (requests):**
```python
import requests

def check_slip_by_barcode(barcode, access_token):
    url = f"http://localhost:5000/api/bets/slip/{barcode}"
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    
    response = requests.get(url, headers=headers)
    data = response.json()
    
    if data.get("success"):
        slip_data = data["data"]
        print(f"Bet Slip: {slip_data['barcode']}")
        print(f"Status: {slip_data['status']}")
        print(f"Total Bet: ₹{slip_data['total_amount']}")
        print(f"Payout: ₹{slip_data['payout_amount']}")
        print(f"Winning Card: {slip_data['game']['winning_card']}")
        print(f"Claimed: {slip_data['claimed']}")
        
        # Show individual bets
        for bet in slip_data['bets']:
            status = "WON" if bet['is_winner'] else "LOST"
            print(f"Card {bet['card_number']}: ₹{bet['bet_amount']} - {status} - Payout: ₹{bet['payout_amount']}")
    else:
        print(f"Error: {data.get('message')}")

# Usage
check_slip_by_barcode("KX-20251102-ABC123", "your-access-token")
```

### **4. Using Postman:**

1. **Method**: GET
2. **URL**: `http://localhost:5000/api/bets/slip/KX-20251102-ABC123`
3. **Headers**:
   - `Authorization`: `Bearer YOUR_ACCESS_TOKEN`
   - `Content-Type`: `application/json`
4. **Send Request**

---

## 🔐 Access Control

### **Player Access:**
- ✅ Can check **their own** bet slips by barcode
- ❌ Cannot check other players' bet slips (returns 404)

### **Admin Access:**
- ✅ Can check **any** bet slip by barcode
- ✅ No ownership restriction

### **Security:**
- Must be authenticated (logged in)
- Returns 404 (not 403) if unauthorized to prevent information leakage

---

## 📊 Understanding the Results

### **Status Values:**

| Status | Meaning |
|--------|---------|
| `pending` | Game not settled yet, results unknown |
| `won` | At least one bet on this slip won |
| `lost` | All bets on this slip lost |

### **Settlement Status:**

| Game Settlement Status | Meaning |
|------------------------|---------|
| `not_settled` | Game ended, but winning card not declared yet |
| `settling` | Settlement in progress |
| `settled` | ✅ Results calculated, winning card known |
| `failed` | Settlement failed (needs admin retry) |

### **When Can You See Results?**

| Game Status | Settlement Status | Can See Results? |
|------------|-------------------|------------------|
| `active` | `not_settled` | ❌ No (game still running) |
| `completed` | `not_settled` | ❌ No (results not calculated) |
| `completed` | `settling` | ❌ No (calculation in progress) |
| `completed` | `settled` | ✅ **YES** (results available) |
| `completed` | `failed` | ❌ No (settlement failed) |

---

## 🎯 Common Use Cases

### **1. Player Checking Their Bet:**
```javascript
// After placing bet, player gets barcode: "KX-20251102-ABC123"
// They can check status anytime:
GET /api/bets/slip/KX-20251102-ABC123

// Response shows:
// - If game is settled, they see won/lost
// - If game not settled, status is "pending"
// - They can see payout_amount if they won
```

### **2. Scanning Barcode to Claim:**
```javascript
// First check the slip:
GET /api/bets/slip/KX-20251102-ABC123
// Returns: status: "won", payout_amount: 2500

// Then claim winnings:
POST /api/bets/claim
// Body: { "identifier": "KX-20251102-ABC123" }
```

### **3. Admin Verifying a Bet Slip:**
```javascript
// Admin can check any slip:
GET /api/bets/slip/KX-20251102-ABC123
// Returns full details regardless of ownership
```

---

## 🔍 What Information You Get

The response includes:

1. **Slip Information:**
   - Barcode & Slip ID
   - Total bet amount
   - Status (won/lost/pending)
   - Claim status

2. **Game Information:**
   - Game ID and timing
   - Winning card (if settled)
   - Settlement status
   - Payout multiplier

3. **Individual Bet Details:**
   - Each card bet on
   - Bet amount per card
   - Win/loss per bet
   - Payout per bet

4. **Payout Information:**
   - Total payout amount
   - Whether it's been claimed
   - When it was claimed (if applicable)

---

## ✅ Quick Checklist

To check a slip by barcode:

1. ✅ Login and get access token
2. ✅ Make GET request to `/api/bets/slip/{barcode}`
3. ✅ Include `Authorization: Bearer {token}` header
4. ✅ Check response for:
   - `status`: won/lost/pending
   - `payout_amount`: Your winnings (0 if lost)
   - `game.settlement_status`: Must be "settled" to see results
   - `game.winning_card`: The winning card number
   - `claimed`: Whether you've already claimed

---

## 🚨 Important Notes

1. **Authentication Required**: You must be logged in
2. **Ownership Check**: Players can only see their own slips (unless admin)
3. **Results Timing**: Results only available after game is `settled`
4. **Pending Status**: If `status = "pending"`, game is not settled yet
5. **Winning Card**: Only visible if `settlement_status = "settled"`

---

## 📝 Example Response Interpretation

### **Scenario 1: Game Not Settled Yet**
```json
{
  "status": "pending",
  "payout_amount": 0,
  "game": {
    "settlement_status": "not_settled",
    "winning_card": null
  }
}
```
**Meaning**: Game ended, but winning card not declared yet. Wait for settlement.

### **Scenario 2: You Won!**
```json
{
  "status": "won",
  "payout_amount": 2500.00,
  "claimed": false,
  "game": {
    "settlement_status": "settled",
    "winning_card": 5
  },
  "bets": [
    { "card_number": 5, "is_winner": true, "payout_amount": 2500.00 }
  ]
}
```
**Meaning**: You won! You have ₹2,500 waiting. Claim it using `/api/bets/claim`.

### **Scenario 3: You Lost**
```json
{
  "status": "lost",
  "payout_amount": 0,
  "game": {
    "settlement_status": "settled",
    "winning_card": 7
  },
  "bets": [
    { "card_number": 5, "is_winner": false, "payout_amount": 0 }
  ]
}
```
**Meaning**: You lost. The winning card was 7, but you bet on 5. No payout.

---

## 🎯 Summary

**To check a slip by barcode:**
```
GET /api/bets/slip/{barcode}
Authorization: Bearer {token}
```

**What you get:**
- ✅ Bet slip details
- ✅ Game information
- ✅ Winning card (if settled)
- ✅ Your results (won/lost)
- ✅ Payout amount
- ✅ Individual bet details

**Requirements:**
- ✅ Must be authenticated
- ✅ Must own the slip (or be admin)
- ✅ Game must be settled to see results

That's it! 🎉




