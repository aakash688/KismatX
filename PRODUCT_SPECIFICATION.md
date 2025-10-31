## Product Specification — KismatX

### 1. Overview
KismatX is a gaming platform with an admin panel for managing users, wallets, games, and betting, backed by a Node.js/Express API using TypeORM. The system emphasizes secure auth, role/permission controls, wallet operations, auditing, and operational visibility.

### 2. Goals
- **Secure admin portal** for users, roles/permissions, wallets, and games
- **Wallet operations**: credit/debit with logs and reconciliation
- **Robust API** for auth, users, wallets, admin, and games
- **Full auditing** and login history
- **Observability**: structured logs and metrics

### 3. Non-Goals
- Player-facing gameplay UI beyond admin tools
- Payment processor integrations
- Complex odds engines or external sportsbook integrations

### 4. Users & Personas
- **Admin**: Full control; creates games; manages roles/permissions; audits
- **Support Ops**: User account help; wallet adjustments; histories
- **Analyst**: Audits/wallet reporting; exports
- **Developer/DevOps**: Setup, observability, migrations

### 5. Architecture
- **Frontend**: `adminpanelui` (React + Vite + TS + Tailwind + shadcn/ui)
- **Backend**: Node.js/Express, TypeORM, JWT auth, modular controllers/services
- **Database**: Relational via TypeORM entities (user, wallet, game, betting)
- **Utilities**: Audit logger, token manager, validation, pagination

### 6. User Stories
- Admin logs in and manages users, roles, permissions
- Support searches users, resets passwords, views login history
- Admin credits/debits wallets; reviews wallet logs
- Admin creates/activates/closes games; views bet slips/details
- Analyst filters/exports audit logs
- DevOps reviews logs/metrics

### 7. Functional Requirements
#### 7.1 Auth & Authorization
- Email/password login; JWT access + refresh; rotation & revocation
- Roles (Admin, Support, Analyst) and fine-grained permissions
- Session/login history with IP, UA, timestamp, outcome
- Admin-triggered password reset supported in UI

#### 7.2 User Management
- CRUD users; status toggle; assign/revoke roles/permissions
- View audit trails and login history per user
- Search, filter, pagination

#### 7.3 Wallet Management
- View balances and wallet logs
- Credit/debit with reason, actor, idempotency key; transactional safety
- Filter/export logs by date, user, type

#### 7.4 Game & Betting Management
- Define games: name, status (draft/active/closed), metadata
- View/manage bet slips and details; settlement workflow
- Constraints: immutable closed games; safe concurrent updates

#### 7.5 Auditing & Logs
- Record who/what/when, before/after for admin actions
- View with filters, pagination, export (CSV)
- Error/combined logs and basic metrics available

#### 7.6 Admin Panel UI
- Pages: Dashboard, Users, User Profile, Wallet Management, Deposits, Login History, Audit Logs
- Consistent, responsive UI; shadcn components; route guards by role
- Form validation; clear error and empty states

### 8. Representative API Endpoints
- **Auth**: `POST /auth/login`, `POST /auth/refresh`, `POST /auth/logout`
- **Users**: `GET/POST/PATCH /users`, `GET /users/:id`, roles/permissions subroutes
- **Wallet**: `GET /wallet/:userId`, `POST /wallet/:userId/credit`, `POST /wallet/:userId/debit`, `GET /wallet/:userId/logs`
- **Game**: `POST /game`, `GET /game`, `PATCH /game/:id`, `POST /game/:id/close`, `GET /bet-slips`, `GET /bet-details`
- **Admin**: `GET /audit-logs`, `GET /login-history`

Note: Exact routes align with `src/routes/*.js` and controllers in `src/controllers/*.js`.

### 9. Data Model (Key Entities)
- **User**: id, email, passwordHash, roles, status, createdAt, updatedAt
- **Role**: id, name, permissions[]
- **Permission**: id, key, description
- **RefreshToken**: id, userId, token, expiresAt, revoked
- **WalletLog**: id, userId, delta, balanceAfter, reason, actorId, createdAt
- **Game**: id, name, status, metadata, createdAt, updatedAt
- **BetSlip**: id, userId, gameId, stake, status, createdAt, settledAt
- **BetDetail**: id, betSlipId, selection, odds, result
- **AuditLog**: id, actorId, action, entityType, entityId, before, after, createdAt
- **LoginHistory**: id, userId, ip, ua, success, createdAt

### 10. Non-Functional Requirements
- **Security**: OWASP, strong hashing, JWT best practices, input validation, auth rate limiting
- **Performance**: Paginated lists; avoid N+1 via relations; typical admin loads
- **Reliability**: Idempotent wallet actions; DB transactions for credit/debit and settlement
- **Observability**: Structured logs, error logs, metrics; correlation IDs
- **Privacy**: PII protection; configurable log retention

### 11. UX Requirements
- Clear navigation and consistent layouts
- Inline validation and descriptive errors
- Confirmation dialogs for destructive actions
- Tables with sorting, filtering, pagination; accessibility considerations

### 12. Error Handling & Validation
- Middleware validation; typed client-side validation
- Consistent server error shape and user-friendly messages
- Audit successful admin actions; log server errors with stack traces

### 13. Metrics
- Route-level counts, latency, error rates
- Admin activity summary; wallet adjustment volumes; game lifecycle metrics

### 14. Risks & Mitigations
- Concurrent wallet updates → transactions + idempotency
- Privilege escalation → strict server checks + route guards
- Settlement integrity → atomic operations; validated status transitions
- Token theft → short-lived access tokens; refresh rotation; revoke on logout

### 15. Release Plan
- Phase 1: Auth, Users, Roles/Permissions, basic Wallet views
- Phase 2: Wallet credit/debit, Audit Logs, Login History
- Phase 3: Games lifecycle, Bet slips view
- Phase 4: Exports, metrics dashboard, polish and docs

### 16. Success Metrics
- p95 < 300ms for primary list endpoints under nominal load
- No known privilege bypass vulnerabilities
- 100% admin actions recorded in Audit Logs
- Zero wallet reconciliation discrepancies post settlement

### 17. Open Questions
- PSP integration vs. manual deposits/withdrawals?
- Audit/login log retention period?
- Multi-tenant/operator isolation needs?
- Export formats required (CSV/XLSX/JSON)?
- SLA targets and alert thresholds?


