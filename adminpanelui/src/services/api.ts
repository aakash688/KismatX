import axios, { AxiosInstance, AxiosResponse } from 'axios';
import { API_CONFIG } from '../config/api';
import Cookies from 'js-cookie';

// Debug: Log the API base URL being used
console.log('🚀 Creating Axios instance with BASE_URL:', API_CONFIG.BASE_URL);
console.log('🚀 Full API_CONFIG:', API_CONFIG);

// Create axios instance
const apiClient: AxiosInstance = axios.create({
  baseURL: API_CONFIG.BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add request interceptor to log all requests
apiClient.interceptors.request.use(
  (config) => {
    console.log('📤 API Request:', {
      'Method': config.method?.toUpperCase(),
      'URL': config.url,
      'Full URL': `${config.baseURL}${config.url}`,
      'Base URL': config.baseURL
    });
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Request interceptor to add auth token from cookies
apiClient.interceptors.request.use(
  (config) => {
    const token = Cookies.get('kismatx_access_token') || localStorage.getItem('accessToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle token refresh and offline scenarios
apiClient.interceptors.response.use(
  (response: AxiosResponse) => {
    return response;
  },
  async (error) => {
    const originalRequest = error.config;

    // Handle network errors (backend offline)
    if (!error.response) {
      console.error('Network error - backend may be offline:', error.message);
      
      // If it's a critical request (like login), don't retry
      if (originalRequest.url?.includes('/auth/login')) {
        return Promise.reject(new Error('Unable to connect to server. Please check your internet connection.'));
      }
      
      // For other requests, show a user-friendly message
      return Promise.reject(new Error('Server is currently unavailable. Please try again later.'));
    }

    // Handle 401 errors (unauthorized)
    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshToken = Cookies.get('kismatx_refresh_token') || localStorage.getItem('refreshToken');
        if (refreshToken) {
          const response = await axios.post(
            `${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.AUTH.REFRESH}`,
            { refreshToken }
          );

          const { accessToken } = response.data;
          localStorage.setItem('accessToken', accessToken);
          Cookies.set('kismatx_access_token', accessToken, { expires: 7, path: '/' });

          // Retry original request with new token
          originalRequest.headers.Authorization = `Bearer ${accessToken}`;
          return apiClient(originalRequest);
        }
      } catch (refreshError) {
        console.error('Token refresh failed:', refreshError);
        
        // Clear all auth data and redirect to login
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        Cookies.remove('kismatx_access_token', { path: '/' });
        Cookies.remove('kismatx_refresh_token', { path: '/' });
        Cookies.remove('kismatx_user_data', { path: '/' });
        
        // Only redirect if we're not already on the login page
        if (!window.location.pathname.includes('/login')) {
          window.location.href = '/login';
        }
        
        return Promise.reject(refreshError);
      }
    }

    // Handle 409 errors (user already logged in)
    if (error.response?.status === 409) {
      const errorMessage = error.response.data?.message || 'User is already logged in from another session';
      return Promise.reject(new Error(errorMessage));
    }

    return Promise.reject(error);
  }
);

export default apiClient;
