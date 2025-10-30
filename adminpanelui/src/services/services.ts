import apiClient from './api';
import { API_CONFIG } from '../config/api';

// Types
export interface User {
  id: number;
  user_id: string;
  first_name: string;
  last_name: string;
  email: string;
  mobile: string;
  alternate_mobile?: string;
  address?: string;
  city?: string;
  state?: string;
  pin_code?: string;
  region?: string;
  status: 'active' | 'inactive' | 'banned' | 'pending';
  deposit_amount?: number;
  profile_pic?: string;
  user_type: 'admin' | 'moderator' | 'player';
  created_at: string;
  updated_at: string;
  last_login?: string;
  email_verified: boolean;
  mobile_verified: boolean;
  is_email_verified_by_admin: boolean;
  is_mobile_verified_by_admin: boolean;
  roles?: Role[];
}

export interface Role {
  id: number;
  name: string;
  description: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
  permissions?: Permission[];
}

export interface Permission {
  id: number;
  name: string;
  description: string;
  resource: string;
  action: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface LoginRequest {
  user_id: string;
  password: string;
}

export interface LoginResponse {
  success: boolean;
  message: string;
  accessToken: string;
  refreshToken: string;
  user: User;
}

export interface RegisterRequest {
  user_id: string;
  first_name: string;
  last_name: string;
  email: string;
  mobile: string;
  password: string;
  user_type: 'admin' | 'moderator' | 'player';
  deposit_amount?: number;
  profile_pic?: string;
  alternate_mobile?: string;
  address?: string;
  city?: string;
  state?: string;
  pin_code?: string;
  region?: string;
}

export interface DashboardStats {
  totalUsers: number;
  activeUsers: number;
  bannedUsers: number;
  totalDeposits: number;
  recentLogins: number;
  adminActions: number;
}

export interface AuditLog {
  id: number;
  user_id?: number;
  admin_id?: number;
  action: string;
  target_type: string;
  target_id?: number;
  details: string;
  ip_address?: string;
  user_agent?: string;
  created_at: string;
}

export interface LoginHistory {
  id: number;
  user_id?: number;
  login_time: string;
  ip_address?: string;
  device_info?: string;
  user_agent?: string;
  login_method: string;
  is_successful: boolean;
  failure_reason?: string;
}

export interface PaginationMeta {
  page: number;
  limit: number;
  total: number;
  pages: number;
}

// Auth Services moved to authService.ts to avoid circular dependency

// User Services
export const userService = {
  getProfile: async (): Promise<User> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.USER.PROFILE);
    return response.data.user;
  },

  updateProfile: async (data: Partial<User>): Promise<User> => {
    const response = await apiClient.put(API_CONFIG.ENDPOINTS.USER.UPDATE_PROFILE, data);
    return response.data.user;
  },

  changePassword: async (currentPassword: string, newPassword: string): Promise<void> => {
    await apiClient.post(API_CONFIG.ENDPOINTS.USER.CHANGE_PASSWORD, {
      currentPassword,
      newPassword
    });
  },

  getPermissions: async (): Promise<Permission[]> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.USER.PERMISSIONS);
    return response.data.permissions;
  }
};

// Admin Services
export const adminService = {
  getDashboard: async (): Promise<DashboardStats> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.DASHBOARD);
    return response.data;
  },

  getUsers: async (params?: {
    page?: number;
    limit?: number;
    status?: string;
    search?: string;
  }): Promise<{ users: User[]; total: number; page: number; limit: number }> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.USERS, { params });
    return response.data;
  },

  getUserById: async (id: string): Promise<User> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.USER_BY_ID(id));
    return response.data.user;
  },

  createUser: async (userData: RegisterRequest): Promise<User> => {
    const response = await apiClient.post(API_CONFIG.ENDPOINTS.ADMIN.USERS, userData);
    return response.data.user;
  },

  updateUser: async (id: string, data: Partial<User>): Promise<User> => {
    console.log('🌐 Updating user via API:', id, data);
    const response = await apiClient.put(API_CONFIG.ENDPOINTS.ADMIN.USER_BY_ID(id), data);
    console.log('📊 Update user API response:', response.data);
    return response.data.user;
  },

  updateUserStatus: async (id: string, status: string): Promise<User> => {
    const response = await apiClient.put(API_CONFIG.ENDPOINTS.ADMIN.USER_STATUS(id), { status });
    return response.data.user;
  },

  resetUserPassword: async (id: string, newPassword: string): Promise<void> => {
    await apiClient.post(API_CONFIG.ENDPOINTS.ADMIN.USER_RESET_PASSWORD(id), { newPassword });
  },

  verifyUserEmail: async (id: string): Promise<User> => {
    const response = await apiClient.put(API_CONFIG.ENDPOINTS.ADMIN.USER_VERIFY_EMAIL(id));
    return response.data.user;
  },

  verifyUserMobile: async (id: string): Promise<User> => {
    const response = await apiClient.put(API_CONFIG.ENDPOINTS.ADMIN.USER_VERIFY_MOBILE(id));
    return response.data.user;
  },

  getUserLoginHistory: async (id: string, params?: {
    page?: number;
    limit?: number;
  }): Promise<{ logins: LoginHistory[]; total: number }> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.USER_LOGIN_HISTORY(id), { params });
    return response.data;
  },

  getUserActiveSessions: async (user_id: string): Promise<{ activeSessions: number }> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.USER_SESSIONS_ACTIVE(user_id));
    return response.data;
  },

  killUserSessions: async (user_id: string): Promise<{ revokedCount: number }> => {
    const response = await apiClient.post(API_CONFIG.ENDPOINTS.ADMIN.USER_SESSIONS_KILL(user_id));
    return response.data;
  },

  getRoles: async (): Promise<Role[]> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.ROLES);
    return response.data.roles;
  },

  createRole: async (roleData: Partial<Role>): Promise<Role> => {
    const response = await apiClient.post(API_CONFIG.ENDPOINTS.ADMIN.ROLES, roleData);
    return response.data.role;
  },

  updateRole: async (id: string, data: Partial<Role>): Promise<Role> => {
    const response = await apiClient.put(API_CONFIG.ENDPOINTS.ADMIN.ROLE_BY_ID(id), data);
    return response.data.role;
  },

  assignRolePermissions: async (id: string, permissionIds: number[]): Promise<void> => {
    await apiClient.post(API_CONFIG.ENDPOINTS.ADMIN.ROLE_PERMISSIONS(id), { permission_ids: permissionIds });
  },

  getUserRoles: async (id: string): Promise<Role[]> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.USER_ROLES(id));
    return response.data.roles;
  },

  assignUserRoles: async (id: string, roleIds: number[]): Promise<void> => {
    await apiClient.post(API_CONFIG.ENDPOINTS.ADMIN.USER_ROLES(id), { role_ids: roleIds });
  },

  getPermissions: async (): Promise<Permission[]> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.PERMISSIONS);
    return response.data.permissions;
  },

  createPermission: async (permissionData: Partial<Permission>): Promise<Permission> => {
    const response = await apiClient.post(API_CONFIG.ENDPOINTS.ADMIN.PERMISSIONS, permissionData);
    return response.data.permission;
  },

  updatePermission: async (id: string, data: Partial<Permission>): Promise<Permission> => {
    const response = await apiClient.put(API_CONFIG.ENDPOINTS.ADMIN.PERMISSION_BY_ID(id), data);
    return response.data.permission;
  },

  getAuditLogs: async (params?: {
    page?: number;
    limit?: number;
    action?: string;
    user_id?: number;
  }): Promise<{ logs: AuditLog[]; total: number }> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.ADMIN.AUDIT_LOGS, { params });
    return response.data;
  },

  getLoginHistory: async (params?: {
    page?: number;
    limit?: number;
    search?: string;
  }): Promise<{ logins: LoginHistory[]; total: number }> => {
    const response = await apiClient.get('/api/admin/logins', { params });
    return response.data;
  }
};

// Wallet Transaction Interface
export interface WalletTransaction {
  id: number;
  user_id: number;
  user_name?: string;
  transaction_type: 'recharge' | 'withdrawal' | 'game';
  amount: number;
  transaction_direction: 'credit' | 'debit';
  game_id?: number;
  comment?: string;
  created_at: string;
}

export interface CreateTransactionRequest {
  user_id: number;
  transaction_type: 'recharge' | 'withdrawal' | 'game';
  amount: number;
  transaction_direction: 'credit' | 'debit';
  game_id?: number;
  comment?: string;
}

export interface TransactionResponse {
  transaction: WalletTransaction;
  user: {
    id: number;
    user_id: string;
    previous_balance: number;
    new_balance: number;
  };
}

export interface WalletLog {
  id: number;
  user_id: number;
  user_name: string;
  user_code?: string;
  transaction_type: 'recharge' | 'withdrawal' | 'game';
  amount: number;
  transaction_direction: 'credit' | 'debit';
  comment?: string;
  created_at: string;
}

export interface WalletSummary {
  user: { id: number; user_id: string; first_name: string; last_name: string };
  balance: number;
  total_credits: number;
  total_debits: number;
  total_transactions: number;
}

// Wallet Services
export const walletService = {
  createTransaction: async (data: CreateTransactionRequest): Promise<TransactionResponse> => {
    const response = await apiClient.post(API_CONFIG.ENDPOINTS.WALLET.TRANSACTION, data);
    return response.data;
  },

  getUserTransactions: async (
    user_id: string,
    params?: {
      page?: number;
      limit?: number;
      transaction_type?: string;
      direction?: string;
      date_from?: string;
      date_to?: string;
    }
  ): Promise<{ transactions: WalletTransaction[]; pagination: PaginationMeta }> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.WALLET.USER_TRANSACTIONS(user_id), { params });
    return response.data;
  },

  getTransactionById: async (id: string): Promise<{ transaction: WalletTransaction }> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.WALLET.TRANSACTION_BY_ID(id));
    return response.data;
  },

  updateTransaction: async (id: string, comment: string): Promise<{ transaction: WalletTransaction }> => {
    const response = await apiClient.put(API_CONFIG.ENDPOINTS.WALLET.TRANSACTION_BY_ID(id), { comment });
    return response.data;
  },

  deleteTransaction: async (id: string): Promise<{ message: string }> => {
    const response = await apiClient.delete(API_CONFIG.ENDPOINTS.WALLET.TRANSACTION_BY_ID(id));
    return response.data;
  },
  getAllWalletLogs: async (params?: {
    page?: number;
    limit?: number;
    user_id?: string|number;
    transaction_type?: string;
    direction?: string;
    date_from?: string;
    date_to?: string;
    search?: string;
  }): Promise<{ logs: WalletLog[]; pagination: PaginationMeta }> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.WALLET.LOGS, { params });
    return response.data;
  },
  getUserWalletSummary: async (user_id: string|number): Promise<WalletSummary> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.WALLET.SUMMARY(user_id.toString()));
    return response.data;
  }
};

// System Services
export const systemService = {
  healthCheck: async (): Promise<{ status: string; timestamp: string }> => {
    const response = await apiClient.get(API_CONFIG.ENDPOINTS.SYSTEM.HEALTH);
    return response.data;
  }
};
