# KismatX Admin Panel

A modern React-based admin panel for the KismatX gaming platform, built with TypeScript, Vite, and Shadcn/UI components.

## Features

- 🔐 **Authentication**: Secure login with user_id and password
- 👥 **User Management**: Complete CRUD operations for user accounts
- 🛡️ **Role-Based Access Control**: Manage roles and permissions
- 📊 **Dashboard**: Real-time statistics and system overview
- 📝 **Audit Logging**: Track all administrative actions
- 📱 **Responsive Design**: Works on desktop and mobile devices
- 🎨 **Modern UI**: Built with Shadcn/UI components

## Tech Stack

- **React 18** with TypeScript
- **Vite** for fast development and building
- **React Router** for navigation
- **Axios** for API communication
- **Shadcn/UI** for beautiful components
- **Tailwind CSS** for styling
- **Lucide React** for icons

## Quick Start

### Prerequisites

- Node.js 18+ 
- npm or yarn
- KismatX API server running on `http://localhost:5001`

### Installation

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Configure API endpoint:**
   Create a `.env` file in the root directory:
   ```bash
   cp env.example .env
   ```
   
   Update the `VITE_API_BASE_URL` in `.env` if your API is running on a different port:
   ```
   VITE_API_BASE_URL=http://localhost:5001
   ```

3. **Start the development server:**
   ```bash
   npm run dev
   ```

4. **Open your browser:**
   Navigate to `http://localhost:3000`

### Demo Credentials

- **Admin:** `admin001` / `admin123`
- **Player:** `player001` / `password123`

## Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── ui/             # Shadcn/UI components
│   └── Layout.tsx      # Main layout component
├── contexts/           # React contexts
│   └── AuthContext.tsx # Authentication context
├── pages/              # Page components
│   ├── LoginPage.tsx
│   ├── DashboardPage.tsx
│   └── UsersPage.tsx
├── services/           # API services
│   ├── api.ts         # Axios configuration
│   └── services.ts    # API service functions
├── config/             # Configuration files
│   └── api.ts         # API endpoints configuration
├── lib/                # Utility functions
│   └── utils.ts       # Common utilities
└── App.tsx            # Main app component
```

## API Integration

The admin panel integrates with all KismatX API endpoints:

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout
- `POST /api/auth/refresh-token` - Token refresh

### User Management
- `GET /api/admin/users` - List users
- `POST /api/admin/users` - Create user
- `PUT /api/admin/users/:id` - Update user
- `PUT /api/admin/users/:id/status` - Change user status
- `POST /api/admin/users/:user_id/sessions/kill` - Kill user sessions

### Admin Features
- `GET /api/admin/dashboard` - Dashboard statistics
- `GET /api/admin/audit-logs` - Audit logs
- `GET /api/admin/roles` - Role management
- `GET /api/admin/permissions` - Permission management

## Configuration

### Changing API Base URL

To change the API server URL, update the `.env` file:

```bash
# For production
VITE_API_BASE_URL=https://api.kismatx.com

# For different local port
VITE_API_BASE_URL=http://localhost:3001
```

The application will automatically use the new URL for all API calls.

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `VITE_API_BASE_URL` | Base URL for the KismatX API | `http://localhost:5001` |
| `NODE_ENV` | Environment mode | `development` |

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

## Features Overview

### Dashboard
- Real-time user statistics
- System health status
- Quick action buttons
- Recent activity overview

### User Management
- View all users with pagination
- Search and filter users
- Create new users
- Update user information
- Change user status (active/banned)
- Verify email and mobile
- Kill user sessions
- View user login history

### Role Management (Coming Soon)
- Create and manage roles
- Assign permissions to roles
- Assign roles to users

### Audit Logs (Coming Soon)
- View all administrative actions
- Filter by action type
- Track user activities

## Development

### Adding New Pages

1. Create a new component in `src/pages/`
2. Add the route to `src/App.tsx`
3. Add navigation link to `src/components/Layout.tsx`

### Adding New API Services

1. Add the endpoint to `src/config/api.ts`
2. Create service functions in `src/services/services.ts`
3. Use the service in your components

### Styling

The project uses Tailwind CSS with Shadcn/UI components. You can:

- Use existing Shadcn/UI components from `src/components/ui/`
- Add custom styles using Tailwind classes
- Extend the theme in `tailwind.config.js`

## Troubleshooting

### Common Issues

1. **API Connection Failed**
   - Ensure the KismatX API server is running
   - Check the `VITE_API_BASE_URL` in `.env`
   - Verify CORS settings on the API server

2. **Login Issues**
   - Check if the user has admin privileges
   - Verify the user exists in the database
   - Check browser console for error messages

3. **Build Errors**
   - Clear node_modules and reinstall: `rm -rf node_modules && npm install`
   - Check TypeScript errors: `npm run lint`

### Debug Mode

Enable debug logging by opening browser DevTools and checking the Console tab for detailed error messages.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is part of the KismatX gaming platform.