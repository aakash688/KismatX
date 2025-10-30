import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/contexts/AuthContext';
import { SessionManager } from '@/utils/sessionManager';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { AlertCircle, Loader2, RefreshCw } from 'lucide-react';

const LoginPage: React.FC = () => {
  const [user_id, setUserId] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [isClearingSessions, setIsClearingSessions] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');

    try {
      await login(user_id, password);
      navigate('/dashboard');
    } catch (err: any) {
      const errorMessage = err.response?.data?.message || err.message || 'Login failed. Please try again.';
      
      // Check if it's an "already logged in" error
      if (err.response?.status === 409 || errorMessage.includes('already logged in')) {
        setError(
          `User ${user_id} is already logged in from another session. Click "Clear Sessions" to force logout from all devices.`
        );
      } else {
        setError(errorMessage);
      }
    } finally {
      setIsLoading(false);
    }
  };

  const handleClearSessions = async () => {
    if (!user_id) {
      setError('Please enter your User ID first');
      return;
    }

    setIsClearingSessions(true);
    setError('');

    try {
      await SessionManager.handleAlreadyLoggedIn(user_id);
      setError('');
      // Show success message
      alert(`Successfully cleared all sessions for user ${user_id}. You can now login.`);
    } catch (err: any) {
      setError(err.message || 'Failed to clear sessions. Please try again.');
    } finally {
      setIsClearingSessions(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div className="text-center">
          <h2 className="mt-6 text-3xl font-extrabold text-gray-900">
            KismatX Admin Panel
          </h2>
          <p className="mt-2 text-sm text-gray-600">
            Sign in to your admin account
          </p>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Login</CardTitle>
            <CardDescription>
              Enter your user ID and password to access the admin panel
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
              {error && (
                <div className="flex items-center space-x-2 text-red-600 bg-red-50 p-3 rounded-md">
                  <AlertCircle className="h-4 w-4" />
                  <span className="text-sm">{error}</span>
                </div>
              )}

              <div className="space-y-2">
                <Label htmlFor="user_id">User ID</Label>
                <Input
                  id="user_id"
                  type="text"
                  value={user_id}
                  onChange={(e) => setUserId(e.target.value)}
                  placeholder="Enter your user ID"
                  required
                  disabled={isLoading}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="password">Password</Label>
                <Input
                  id="password"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Enter your password"
                  required
                  disabled={isLoading}
                />
              </div>

              <div className="space-y-3">
                <Button
                  type="submit"
                  className="w-full"
                  disabled={isLoading || isClearingSessions}
                >
                  {isLoading ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Signing in...
                    </>
                  ) : (
                    'Sign In'
                  )}
                </Button>

                <Button
                  type="button"
                  variant="outline"
                  className="w-full"
                  onClick={handleClearSessions}
                  disabled={isLoading || isClearingSessions || !user_id}
                >
                  {isClearingSessions ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Clearing Sessions...
                    </>
                  ) : (
                    <>
                      <RefreshCw className="mr-2 h-4 w-4" />
                      Clear Sessions
                    </>
                  )}
                </Button>
              </div>
            </form>
          </CardContent>
        </Card>

        <div className="text-center text-sm text-gray-600">
          <p>Demo Credentials:</p>
          <p><strong>Admin:</strong> admin001 / admin123</p>
          <p><strong>Player:</strong> player001 / password123</p>
          <div className="mt-4 p-3 bg-blue-50 rounded-md">
            <p className="text-blue-800 font-medium">💡 Session Management</p>
            <p className="text-blue-700 text-xs mt-1">
              If you get "already logged in" error, use "Clear Sessions" to force logout from all devices.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
