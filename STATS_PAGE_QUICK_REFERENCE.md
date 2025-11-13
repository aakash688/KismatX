# StatsPage - Quick Reference Guide

## 🎯 Current State vs Target State

### CURRENT STATE ❌
```
StatsPage Component
├── State: Mock data (hardcoded)
├── Filters: UI only (not functional)
├── Stats Displayed:
│   ├── totalUsers (1250)
│   ├── activeUsers (890)
│   ├── totalGames (456)
│   ├── totalWagered (1250000)
│   ├── totalPayouts (1100000)
│   └── profit (150000)
├── API: NONE (uses mock)
└── Visualization: Card layout only
```

### TARGET STATE ✅
```
StatsPage Component
├── State: Real data from API
├── Filters: Fully functional (date range + user)
├── Stats Displayed:
│   ├── All current stats (real data)
│   ├── Card statistics (per-card breakdown)
│   ├── User statistics (per-user breakdown)
│   ├── Win rate & margins
│   └── Trend data (for charts)
├── API: POST /api/admin/stats
├── Visualization: Cards + Charts + Tables
└── Export: PDF/Excel reports
```

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     ADMIN PANEL UI                          │
│           (React + TypeScript + Tailwind)                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  StatsPage.tsx                                              │
│  ├─ useEffect: fetch data on mount                         │
│  ├─ Filters: startDate, endDate, userId                    │
│  └─ Components:                                            │
│      ├─ Filter Card (input controls)                       │
│      ├─ Stats Cards (6 cards in 3-col grid)                │
│      ├─ (NEW) Charts (line, bar, pie)                      │
│      └─ (NEW) Tables (card stats, user stats)              │
│                                                              │
│  services/services.ts                                       │
│  └─ statsService.getStats(filters)                         │
│                                                              │
│  services/api.ts (Axios)                                    │
│  ├─ Interceptor: Adds Bearer token                         │
│  └─ Base URL: http://localhost:5001                        │
│                                                              │
└──────────────┬──────────────────────────────────────────────┘
               │ HTTP POST
               │ /api/admin/stats
               │
┌──────────────▼──────────────────────────────────────────────┐
│                    BACKEND API                              │
│           (Express + TypeORM + MySQL)                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  routes/admin.js                                            │
│  └─ POST /api/admin/stats ──────────────────┐              │
│                                              │              │
│  controllers/admin/adminStatsController.js   │              │
│  └─ getStats(req, res, next) ◄──────────────┘              │
│     ├─ Parse filters (startDate, endDate, userId)          │
│     ├─ Build WHERE clauses                                 │
│     └─ Execute queries:                                    │
│         ├─ Query 1: Total games, wagered, payouts          │
│         ├─ Query 2: Per-card statistics                    │
│         ├─ Query 3: Per-user statistics                    │
│         └─ Query 4: Unique user count                      │
│                                                              │
│  Database Queries:                                          │
│  ├─ games table (filtered by date range)                   │
│  ├─ bet_slips table (aggregates)                           │
│  ├─ users table (user info)                                │
│  └─ game_card_totals table (card breakdown)                │
│                                                              │
└──────────────┬──────────────────────────────────────────────┘
               │ JSON Response
               │ {success, data{totalGames, totalWagered, ...}}
               │
               └──────────────────────────────────────────────┐
                                                              │
                                          (Response arrives)  │
                                          StatsPage updates   │
                                          state & re-renders
```

---

## 📊 Data Model

### API Request
```typescript
POST /api/admin/stats
{
  "startDate": "2024-11-01",      // YYYY-MM-DD
  "endDate": "2024-11-12",        // YYYY-MM-DD
  "userId": null                  // optional, for single-user stats
}
```

### API Response
```typescript
{
  "success": true,
  "data": {
    // Aggregates
    "totalGames": 288,
    "totalWagered": 1250000,
    "totalPayouts": 1100000,
    "profit": 150000,
    "profitMargin": "12.00%",
    "uniqueUsers": 450,
    "averageBet": 4340.28,
    "winRate": "45.5%",

    // Per-card breakdown
    "cardStats": [
      {
        "card": 1,
        "totalBets": 100000,
        "totalPayouts": 90000,
        "betCount": 23,
        "winCount": 10
      },
      // ... cards 2-12
    ],

    // Per-user breakdown
    "userStats": [
      {
        "userId": "USER123",
        "userName": "John Doe",
        "gameCount": 45,
        "totalBet": 50000,
        "totalWon": 45000,
        "netProfit": -5000
      },
      // ... top users
    ]
  }
}
```

---

## 🔄 Component State & Effects

### State Variables
```typescript
const [stats, setStats] = useState<StatsData | null>(null);
const [isLoading, setIsLoading] = useState(false);
const [error, setError] = useState('');
const [users, setUsers] = useState<User[]>([]);
const [selectedUser, setSelectedUser] = useState<string>('all');
const [startDate, setStartDate] = useState<string>('');
const [endDate, setEndDate] = useState<string>('');

// NEW STATE ADDITIONS:
const [chartData, setChartData] = useState([]); // For Recharts
const [cardStats, setCardStats] = useState([]); // Card breakdown
const [userStats, setUserStats] = useState([]); // User breakdown
```

### Effects
```typescript
// Effect 1: Initialize users and date range on mount
useEffect(() => {
  fetchUsers();
  // Set default date range to last 30 days
  const today = new Date();
  const thirtyDaysAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);
  setEndDate(today.toISOString().split('T')[0]);
  setStartDate(thirtyDaysAgo.toISOString().split('T')[0]);
}, []);

// Effect 2: Fetch stats when filters change
useEffect(() => {
  if (startDate && endDate) {
    fetchStats();
  }
}, [startDate, endDate, selectedUser]);
```

### Fetch Functions
```typescript
const fetchUsers = async () => {
  // Fetch all users for dropdown
  const response = await adminService.getUsers({ limit: 1000 });
  setUsers(response.users || []);
};

const fetchStats = async () => {
  try {
    setIsLoading(true);
    // NEW: Call real API instead of setting mock data
    const response = await statsService.getStats({
      startDate,
      endDate,
      userId: selectedUser === 'all' ? null : selectedUser
    });
    setStats(response.data);
    // Also set chart/table data from response
  } catch (err: any) {
    setError(err.message);
  } finally {
    setIsLoading(false);
  }
};
```

---

## 🗄️ Database Tables Used

### games
```
id (PK)
game_id (UNIQUE)
start_time
end_time
status ['pending', 'active', 'completed']
winning_card
settlement_status ['not_settled', 'settling', 'settled', 'failed']
settlement_completed_at
created_at
updated_at
```

### bet_slips
```
id (PK)
slip_id (UNIQUE)
user_id (FK)
game_id (FK)
total_amount
payout_amount
claimed (bool)
created_at
```

### game_card_totals
```
id (PK)
game_id (FK)
card_number (1-12)
total_bet_amount
```

### users
```
id (PK)
user_id (UNIQUE)
first_name
last_name
status
```

---

## 💾 Service Layer Pattern

### Current Pattern
```typescript
export const adminService = {
  getDashboard: async (): Promise<DashboardStats> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.DASHBOARD);
    return response.data;
  }
};
```

### New Pattern (To Add)
```typescript
export interface StatsFilters {
  startDate: string;
  endDate: string;
  userId?: string | null;
}

export interface StatsResponse {
  totalGames: number;
  totalWagered: number;
  totalPayouts: number;
  profit: number;
  // ... more fields
}

export const statsService = {
  getStats: async (filters: StatsFilters): Promise<StatsResponse> => {
    const response = await apiClient.post(
      API_CONFIG.ENDPOINTS.ADMIN.STATS,
      filters
    );
    return response.data.data; // Return nested data object
  }
};
```

---

## 📝 Code Quality Standards

### Frontend Standards
- ✅ TypeScript interfaces for all data types
- ✅ Functional components with React.FC
- ✅ Error handling with try-catch
- ✅ Loading states for all async operations
- ✅ Proper cleanup in useEffect (if needed)
- ✅ Tailwind classes for styling
- ✅ Responsive grids (mobile-first)
- ✅ Currency formatting with locale

### Backend Standards
- ✅ async/await (no callbacks)
- ✅ try-catch-next error pattern
- ✅ TypeORM QueryBuilder
- ✅ Audit logging for all admin actions
- ✅ Consistent response format {success, data, message}
- ✅ Proper HTTP status codes
- ✅ Request validation
- ✅ SQL injection prevention (parameterized queries)

---

## 🔐 Security Considerations

### Authentication
- ✅ JWT tokens in Authorization header
- ✅ Token refresh mechanism
- ✅ Stored in localStorage + cookies
- ✅ Verified on backend with isAdmin middleware

### Authorization
- ✅ verifyToken middleware (all admin routes)
- ✅ isAdmin middleware (checks user_type)
- ✅ Audit logging of who accessed what data
- ✅ IP address logging for forensics

### Data Protection
- ✅ No sensitive data in response (passwords, tokens)
- ✅ Date range filtering prevents data leakage
- ✅ User field filtering (only relevant fields)

---

## 🧪 Testing Checklist

### Functional Tests
- [ ] Filters work correctly (date range, user selection)
- [ ] API returns correct data for given filters
- [ ] Stats cards display correct numbers
- [ ] Charts render with real data
- [ ] Empty state shows when no data
- [ ] Loading state shows during fetch

### Edge Cases
- [ ] Date range with no games
- [ ] Single user with no activity
- [ ] Invalid date range (start > end)
- [ ] Large date ranges (month+ of data)
- [ ] Zero profit scenarios
- [ ] 100% win rate / 0% win rate

### Performance
- [ ] API response time < 2 seconds
- [ ] Component re-renders only when needed
- [ ] No memory leaks
- [ ] Charts render smoothly

---

## 📦 Dependencies Already Available

✅ axios - HTTP client
✅ recharts - Charts library (not yet used in StatsPage)
✅ lucide-react - Icons
✅ date-fns - Date utilities
✅ Tailwind CSS - Styling
✅ Radix UI - Components
✅ React 18.2 - Framework
✅ TypeScript - Type safety

---

## 🚀 Implementation Order

1. **Backend** (3-4 hours)
   - [ ] Create adminStatsController.js
   - [ ] Write SQL queries
   - [ ] Add route in admin.js
   - [ ] Test with Postman

2. **Frontend Services** (1 hour)
   - [ ] Add statsService in services.ts
   - [ ] Add StatsResponse interface
   - [ ] Update api.js config

3. **Frontend UI** (2-3 hours)
   - [ ] Replace mock data with API call
   - [ ] Remove hardcoded mock values
   - [ ] Update component to use real data
   - [ ] Test with real backend

4. **Charts & Tables** (2-3 hours)
   - [ ] Add Recharts components
   - [ ] Create card stats table
   - [ ] Create user stats table

5. **Export Feature** (2 hours)
   - [ ] Add PDF export
   - [ ] Add Excel export
   - [ ] Style exports properly

6. **Testing** (2 hours)
   - [ ] Unit tests
   - [ ] Integration tests
   - [ ] Manual QA

---

## 📞 Quick Reference

### Component File
`adminpanelui/src/pages/StatsPage.tsx` (241 lines)

### Service File
`adminpanelui/src/services/services.ts` (717 lines)

### API Config
`adminpanelui/src/config/api.js` (122 lines)

### Dashboard Reference (similar pattern)
`adminpanelui/src/pages/DashboardPage.tsx` (222 lines)

### Backend Controller Reference
`src/controllers/adminController.js` (912 lines)

### Database Schema
`src/entities/game/Game.js`

---

## ✨ Key Takeaways

1. **Current**: Placeholder component with mock data
2. **Issue**: No backend API exists for stats
3. **Solution**: Create `/api/admin/stats` endpoint + integrate frontend
4. **Tech Stack**: React + TypeScript + Axios frontend; Express + TypeORM backend
5. **Pattern**: Service layer → Axios → Backend → Database
6. **Quality**: TypeScript, error handling, loading states, accessibility
7. **Security**: JWT auth, audit logging, role-based access
8. **Timeline**: ~15 hours for complete implementation

---

Generated: 2024-11-12
Status: ✅ Analysis Complete, Ready for Implementation
