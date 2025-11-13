# Implementation Reference: Current Code Snippets

## 📍 File Locations

### Frontend Files
```
d:\Game\KismatX\adminpanelui\
├── src\
│   ├── pages\
│   │   ├── StatsPage.tsx              ← MAIN FILE TO ENHANCE
│   │   └── DashboardPage.tsx          ← PATTERN REFERENCE
│   ├── services\
│   │   ├── services.ts                ← Service layer
│   │   ├── api.ts                     ← Axios instance
│   │   └── authService.ts
│   ├── config\
│   │   └── api.js                     ← API endpoints config
│   ├── types\
│   │   └── api-config.d.ts
│   └── components\
│       └── ui\                        ← Radix UI components
│           ├── card.tsx
│           ├── button.tsx
│           └── select.tsx
├── package.json
└── vite.config.ts
```

### Backend Files
```
d:\Game\KismatX\
├── src\
│   ├── controllers\
│   │   ├── adminController.js         ← Existing dashboard
│   │   └── admin\
│   │       └── adminGameController.js ← Game stats reference
│   ├── routes\
│   │   ├── admin.js                   ← Route definitions
│   │   └── index.js
│   ├── entities\
│   │   ├── game\
│   │   │   └── Game.js
│   │   └── user\
│   │       └── User.js
│   ├── config\
│   │   └── typeorm.config.js
│   ├── utils\
│   │   ├── auditLogger.js
│   │   └── timezone.js
│   └── middleware\
│       └── auth.js
├── package.json
└── server.js
```

---

## 🔍 Current Implementation Analysis

### 1. StatsPage Component (Current)

**File**: `adminpanelui/src/pages/StatsPage.tsx`
**Status**: Placeholder with mock data
**Lines**: 241

#### Mock Data Implementation (Lines 59-70)
```typescript
const fetchStats = async () => {
  try {
    setIsLoading(true);
    // Note: This would need to be implemented in the backend service
    // For now, showing placeholder data
    const mockStats: StatsData = {
      totalUsers: 1250,
      activeUsers: 890,
      totalGames: 456,
      totalWagered: 1250000,
      totalPayouts: 1100000,
      profit: 150000,
    };
    setStats(mockStats);
  } catch (err: any) {
    console.error('Failed to load stats:', err);
  } finally {
    setIsLoading(false);
  }
};
```

#### Current State Definition (Lines 26-29)
```typescript
const [stats, setStats] = useState<StatsData | null>(null);
const [isLoading, setIsLoading] = useState(false);
const [users, setUsers] = useState<User[]>([]);
const [selectedUser, setSelectedUser] = useState<string>('all');
const [startDate, setStartDate] = useState<string>('');
const [endDate, setEndDate] = useState<string>('');
```

#### Stats Interface (Lines 10-17)
```typescript
interface StatsData {
  totalUsers: number;
  activeUsers: number;
  totalGames: number;
  totalWagered: number;
  totalPayouts: number;
  profit: number;
}
```

---

### 2. Admin Service (Current)

**File**: `adminpanelui/src/services/services.ts`
**Status**: Only has getDashboard(), needs statsService
**Lines**: 717

#### Existing Admin Service (Lines 155-157)
```typescript
export const adminService = {
  getDashboard: async (): Promise<DashboardStats> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.DASHBOARD);
    return response.data;
  },
```

#### What's Missing
- No `statsService` object
- No `getStats()` method
- No `StatsResponse` interface

---

### 3. API Configuration

**File**: `adminpanelui/src/config/api.js`
**Status**: Missing STATS endpoint
**Lines**: 122

#### Current Admin Endpoints (Lines 61-79)
```javascript
ADMIN: {
  DASHBOARD: '/api/admin/dashboard',
  USERS: '/api/admin/users',
  USER_BY_ID: (id) => `/api/admin/users/${id}`,
  USER_STATUS: (id) => `/api/admin/users/${id}/status`,
  USER_RESET_PASSWORD: (id) => `/api/admin/users/${id}/reset-password`,
  USER_VERIFY_EMAIL: (id) => `/api/admin/users/${id}/verify-email`,
  USER_VERIFY_MOBILE: (id) => `/api/admin/users/${id}/verify-mobile`,
  USER_LOGIN_HISTORY: (id) => `/api/admin/users/${id}/logins`,
  USER_ROLES: (id) => `/api/admin/users/${id}/roles`,
  // Missing: STATS endpoint
}
```

---

### 4. Backend Admin Controller (Reference Pattern)

**File**: `src/controllers/adminController.js`
**Status**: Has getDashboard() - good reference
**Lines**: 912

#### getDashboard Implementation (Lines 13-59)
```javascript
export const getDashboard = async (req, res, next) => {
    try {
        console.log('📊 Dashboard request received');
        const userRepo = AppDataSource.getRepository(UserEntity);
        
        // Get basic counts
        const totalUsers = await userRepo.count();
        const activeUsers = await userRepo.count({ where: { status: "active" } });
        const bannedUsers = await userRepo.count({ where: { status: "banned" } });
        
        // Get total deposits
        const depositResult = await userRepo
            .createQueryBuilder("user")
            .select("SUM(user.deposit_amount)", "total")
            .getRawOne();
        const totalDeposits = parseFloat(depositResult?.total) || 0;
        
        const dashboardData = {
            totalUsers,
            activeUsers,
            bannedUsers,
            totalDeposits,
            recentLogins,
            adminActions
        };
        
        res.json(dashboardData);
    } catch (err) {
        console.error('❌ Dashboard error:', err);
        next(err);
    }
};
```

---

### 5. Admin Routes

**File**: `src/routes/admin.js`
**Status**: Has dashboard route, missing stats route
**Lines**: 119

#### Current Routes (Lines 50-66)
```javascript
// Dashboard
router.get('/dashboard', getDashboard);

// User Management
router.post('/users', createUser);
router.get('/users', getAllUsers);
router.get('/users/:id', getUserById);
router.put('/users/:id', updateUser);
router.delete('/users/:id', deleteUser);
// ... more user routes

// Missing: stats route
```

---

### 6. Game Admin Controller (Advanced Reference)

**File**: `src/controllers/admin/adminGameController.js`
**Status**: Has complex queries - reference for stats building
**Lines**: 1005

#### getGameUserStats (Lines 35-133)
This function shows how to:
- Query multiple repositories
- Filter by game_id
- Aggregate data by user_id
- Fetch related user information
- Return formatted response

```javascript
export const getGameUserStats = async (req, res, next) => {
    try {
        const { gameId } = req.params;
        const gameRepo = AppDataSource.getRepository(GameEntity);
        const betSlipRepo = AppDataSource.getRepository(BetSlipEntity);
        const userRepo = AppDataSource.getRepository(UserEntity);

        // Get all bet slips for this game
        const allBetSlips = await betSlipRepo.find({
            where: { game_id: gameId }
        });

        // Aggregate by user_id
        const userIdToTotals = new Map();
        betSlips.forEach(slip => {
            const key = slip.user_id;
            const entry = userIdToTotals.get(key) || {
                total_bet_amount: 0,
                total_winning_amount: 0,
                total_claimed_amount: 0
            };
            // ... aggregation logic
            userIdToTotals.set(key, entry);
        });

        // Build response array
        const result = involvedUserIds.map(uid => {
            // ... format user data
        });

        return res.status(200).json({
            success: true,
            data: result
        });
    } catch (error) {
        console.error('❌ Error:', error);
        next(error);
    }
};
```

---

### 7. Dashboard Page (UI Pattern Reference)

**File**: `adminpanelui/src/pages/DashboardPage.tsx`
**Status**: Working example of stats display
**Lines**: 222

#### Component Pattern (Lines 13-31)
```typescript
const DashboardPage: React.FC = () => {
  const navigate = useNavigate();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const data = await adminService.getDashboard();
        setStats(data);
      } catch (err: any) {
        setError(err.response?.data?.message || err.message);
      } finally {
        setIsLoading(false);
      }
    };
    fetchStats();
  }, []);
```

#### Stats Card Pattern (Lines 82-103)
```typescript
const statCards = [
    {
      title: 'Total Users',
      value: stats?.totalUsers || 0,
      icon: Users,
      description: 'All registered users',
      color: 'text-blue-600',
      bgColor: 'bg-blue-50',
      statType: 'totalUsers',
    },
    // ... more cards
];

return (
  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    {statCards.map((stat, index) => {
      const Icon = stat.icon;
      return (
        <Card key={index} onClick={() => handleStatClick(stat.statType)}>
          {/* Card content */}
        </Card>
      );
    })}
  </div>
);
```

---

## 🔄 API Integration Pattern

### Current Pattern Used (from DashboardPage)

**Step 1**: Component mounts
```typescript
useEffect(() => {
  const fetchStats = async () => {
    try {
      const data = await adminService.getDashboard();
      setStats(data);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };
  fetchStats();
}, []);
```

**Step 2**: Service calls API
```typescript
export const adminService = {
  getDashboard: async (): Promise<DashboardStats> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.DASHBOARD);
    return response.data;
  }
};
```

**Step 3**: Axios sends request
```typescript
const apiClient = axios.create({
  baseURL: 'http://localhost:5001',
  timeout: 10000
});

// Interceptor adds token
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('accessToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

**Step 4**: Backend receives request
```javascript
// routes/admin.js
router.get('/dashboard', verifyToken, isAdmin, getDashboard);

// controllers/adminController.js
export const getDashboard = async (req, res, next) => {
  // Query database
  // Return response
};
```

**Step 5**: Response returns to component
```typescript
// Automatic state update
setStats(data);
// Component re-renders
```

---

## 📋 TypeScript Types Currently Used

### From services.ts
```typescript
export interface User {
  id: number;
  user_id: string;
  first_name: string;
  last_name: string;
  email: string;
  status: 'active' | 'inactive' | 'banned' | 'pending';
  user_type: 'admin' | 'moderator' | 'player';
  created_at: string;
  updated_at: string;
}

export interface DashboardStats {
  totalUsers: number;
  activeUsers: number;
  bannedUsers: number;
  totalDeposits: number;
  recentLogins: number;
  adminActions: number;
}
```

### To Be Added
```typescript
export interface StatsFilters {
  startDate: string;     // YYYY-MM-DD
  endDate: string;       // YYYY-MM-DD
  userId?: string | null;
}

export interface StatsData {
  totalUsers: number;
  activeUsers: number;
  totalGames: number;
  totalWagered: number;
  totalPayouts: number;
  profit: number;
  // NEW FIELDS:
  profitMargin: string;     // "12.00%"
  uniqueUsers: number;
  averageBet: number;
  winRate: string;          // "45.5%"
  cardStats: CardStat[];
  userStats: UserStat[];
}

export interface CardStat {
  card: number;
  totalBets: number;
  totalPayouts: number;
  betCount: number;
  winCount: number;
}

export interface UserStat {
  userId: string;
  userName: string;
  gameCount: number;
  totalBet: number;
  totalWon: number;
  netProfit: number;
}
```

---

## 🎨 UI Component Usage

### Cards (from Radix UI)
```tsx
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

<Card>
  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
    <CardTitle className="text-sm font-medium">Title</CardTitle>
    <Icon className="h-4 w-4 text-muted-foreground" />
  </CardHeader>
  <CardContent>
    <div className="text-2xl font-bold">{value}</div>
    <p className="text-xs text-muted-foreground">Subtitle</p>
  </CardContent>
</Card>
```

### Select Component
```tsx
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

<Select value={selectedUser} onValueChange={setSelectedUser}>
  <SelectTrigger>
    <SelectValue placeholder="Select user" />
  </SelectTrigger>
  <SelectContent>
    <SelectItem value="all">All Users</SelectItem>
    {users.map((user) => (
      <SelectItem key={user.id} value={user.id.toString()}>
        {user.first_name} {user.last_name}
      </SelectItem>
    ))}
  </SelectContent>
</Select>
```

### Input Component
```tsx
import { Input } from '@/components/ui/input';

<Input
  type="date"
  value={startDate}
  onChange={(e) => setStartDate(e.target.value)}
/>
```

---

## 🚀 Ready for Implementation

✅ **Analysis Complete**
- Frontend structure understood
- Backend patterns identified
- Database schema examined
- API patterns documented
- Coding standards extracted

📝 **Implementation Roadmap**
1. Create backend API endpoint
2. Add service layer method
3. Update component with real API
4. Add visualizations (charts/tables)
5. Add export functionality

---

Generated: 2024-11-12
Next Step: Awaiting confirmation to proceed with implementation
