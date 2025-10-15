// JWT Token Utilities
// Handles JWT token generation and validation

import jwt from 'jsonwebtoken';

const ACCESS_TOKEN_SECRET = process.env.ACCESS_TOKEN_SECRET || "youraccesstokensecret";
const REFRESH_TOKEN_SECRET = process.env.REFRESH_TOKEN_SECRET || "yourrefreshtokensecret";

// Token expiry times
export const accessTokenExpiryMs = 15 * 60 * 1000; // 15 minutes
export const refreshTokenExpiryMs = 7 * 24 * 60 * 60 * 1000; // 7 days

/**
 * Generate access token
 * @param {Object} user - User object
 * @returns {string} Access token
 */
export const generateAccessToken = (user) => {
  try {
    const payload = {
      id: user.id,
      user_id: user.user_id,
      email: user.email,
      role: user.roles ? user.roles.map(role => role.id) : []
    };

    return jwt.sign(payload, ACCESS_TOKEN_SECRET, {
      expiresIn: '15m',
      issuer: 'your-app-name',
      audience: 'your-app-users'
    });
  } catch (error) {
    throw new Error('Failed to generate access token');
  }
};

/**
 * Generate refresh token
 * @param {Object} user - User object
 * @returns {string} Refresh token
 */
export const generateRefreshToken = (user) => {
  try {
    const payload = {
      id: user.id,
      user_id: user.user_id,
      type: 'refresh'
    };

    return jwt.sign(payload, REFRESH_TOKEN_SECRET, {
      expiresIn: '7d',
      issuer: 'your-app-name',
      audience: 'your-app-users'
    });
  } catch (error) {
    throw new Error('Failed to generate refresh token');
  }
};

/**
 * Verify access token
 * @param {string} token - Access token
 * @returns {Object} Decoded token payload
 */
export const verifyAccessToken = (token) => {
  try {
    return jwt.verify(token, ACCESS_TOKEN_SECRET);
  } catch (error) {
    throw new Error('Invalid access token');
  }
};

/**
 * Verify refresh token
 * @param {string} token - Refresh token
 * @returns {Object} Decoded token payload
 */
export const verifyRefreshToken = (token) => {
  try {
    return jwt.verify(token, REFRESH_TOKEN_SECRET);
  } catch (error) {
    throw new Error('Invalid refresh token');
  }
};

/**
 * Decode token without verification
 * @param {string} token - JWT token
 * @returns {Object} Decoded token payload
 */
export const decodeToken = (token) => {
  try {
    return jwt.decode(token);
  } catch (error) {
    throw new Error('Failed to decode token');
  }
};

/**
 * Check if token is expired
 * @param {string} token - JWT token
 * @returns {boolean} Expired status
 */
export const isTokenExpired = (token) => {
  try {
    const decoded = decodeToken(token);
    if (!decoded || !decoded.exp) return true;
    
    const currentTime = Math.floor(Date.now() / 1000);
    return decoded.exp < currentTime;
  } catch (error) {
    return true;
  }
};

/**
 * Get token expiry time
 * @param {string} token - JWT token
 * @returns {Date} Expiry date
 */
export const getTokenExpiry = (token) => {
  try {
    const decoded = decodeToken(token);
    if (!decoded || !decoded.exp) return null;
    
    return new Date(decoded.exp * 1000);
  } catch (error) {
    return null;
  }
};

/**
 * Generate token pair (access + refresh)
 * @param {Object} user - User object
 * @returns {Object} Token pair
 */
export const generateTokenPair = (user) => {
  try {
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);
    
    return {
      accessToken,
      refreshToken,
      accessTokenExpiry: new Date(Date.now() + accessTokenExpiryMs),
      refreshTokenExpiry: new Date(Date.now() + refreshTokenExpiryMs)
    };
  } catch (error) {
    throw new Error('Failed to generate token pair');
  }
};
