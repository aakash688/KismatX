import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { User, authService } from '@/services/authService';
import { CookieManager } from '@/utils/cookieManager';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (user_id: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  refreshToken: () => Promise<void>;
  clearAuth: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const isAuthenticated = !!user;

  // Initialize auth state from cookies
  useEffect(() => {
    const initializeAuth = async () => {
      try {
        const tokens = CookieManager.getTokens();
        console.log('🔍 Checking cookies on page load:', tokens);

        if (tokens.accessToken && tokens.refreshToken) {
          console.log('✅ Found cookies, validating tokens...');
          // Set tokens in localStorage for axios interceptor
          localStorage.setItem('accessToken', tokens.accessToken);
          localStorage.setItem('refreshToken', tokens.refreshToken);
          
          // Verify token is still valid by getting user profile
          try {
            const userData = await authService.getProfile();
            console.log('✅ Token validation successful, user:', userData);
            if (userData && userData.user_id) {
              setUser(userData);
              CookieManager.saveUser(userData); // Update saved user data
            } else {
              console.log('❌ Invalid user data received');
              throw new Error('Invalid user data');
            }
          } catch (error) {
            console.log('❌ Token validation failed:', error);
            // Only clear auth if it's a definite auth error
            if (error && typeof error === 'object' && 'response' in error) {
              const httpError = error as any;
              if (httpError.response?.status === 401 || httpError.response?.status === 403) {
                console.log('🚫 Clearing invalid auth data');
                // Clear auth data for invalid tokens
                CookieManager.clearAll();
                localStorage.removeItem('accessToken');
                localStorage.removeItem('refreshToken');
                localStorage.removeItem('kismatx_auth_tokens');
                localStorage.removeItem('kismatx_user_data');
                setUser(null);
              }
            }
          }
        } else {
          console.log('⚠️ No cookies found');
        }
      } catch (error) {
        console.error('❌ Auth initialization error:', error);
      } finally {
        setIsLoading(false);
      }
    };

    initializeAuth();
  }, []);

  const clearAuth = () => {
    CookieManager.clearAll();
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('kismatx_auth_tokens');
    localStorage.removeItem('kismatx_user_data');
    setUser(null);
  };

  const login = async (user_id: string, password: string) => {
    try {
      const response = await authService.login({ user_id, password });
      console.log('🔐 Login successful, saving tokens to cookies...');
      
      // Save tokens to cookies and localStorage
      localStorage.setItem('accessToken', response.accessToken);
      localStorage.setItem('refreshToken', response.refreshToken);
      CookieManager.saveTokens(response.accessToken, response.refreshToken);
      CookieManager.saveUser(response.user);
      
      console.log('✅ Tokens saved to cookies:', CookieManager.getTokens());
      
      setUser(response.user);
    } catch (error) {
      throw error;
    }
  };

  const logout = async () => {
    try {
      const refreshToken = CookieManager.getTokens().refreshToken;
      if (refreshToken) {
        await authService.logout(refreshToken);
      }
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      clearAuth();
    }
  };

  const refreshToken = async () => {
    try {
      const tokens = CookieManager.getTokens();
      if (tokens.refreshToken) {
        const response = await authService.refreshToken(tokens.refreshToken);
        
        // Update tokens in both cookies and localStorage
        localStorage.setItem('accessToken', response.accessToken);
        CookieManager.saveTokens(response.accessToken, tokens.refreshToken);
      }
    } catch (error) {
      console.error('Token refresh failed:', error);
      clearAuth();
      throw error;
    }
  };

  const value: AuthContextType = {
    user,
    isAuthenticated,
    isLoading,
    login,
    logout,
    refreshToken,
    clearAuth,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
