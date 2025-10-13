// Authentication Middleware
// Handles JWT token verification and user authentication

import jwt from "jsonwebtoken";
import { AppDataSource } from "../config/typeorm.config.js";

const ACCESS_TOKEN_SECRET = process.env.ACCESS_TOKEN_SECRET || "youraccesstokensecret";
const REFRESH_TOKEN_SECRET = process.env.REFRESH_TOKEN_SECRET || "yourrefreshtokensecret";
const UserEntity = "User";

/**
 * Middleware to verify the access token from cookies or Authorization header
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
export const verifyToken = async (req, res, next) => {
  try {
    // Get token from either cookies or Authorization header
    let token = req.cookies && req.cookies.accessToken;
    
    // If no token in cookies, check Authorization header
    if (!token && req.headers.authorization) {
      const authHeader = req.headers.authorization;
      if (authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7); // Remove 'Bearer ' prefix
      }
    }

    if (!token) {
      return res.status(401).json({ message: "User Unauthorized" });
    }
    
    // Synchronously verify the token; throws if invalid
    const decoded = jwt.verify(token, ACCESS_TOKEN_SECRET);
    req.user = decoded; // decoded contains user id and role

    // Now you can use await because we're in an async function
    const userRepo = AppDataSource.getRepository(UserEntity);
    const user = await userRepo.findOne({ where: { id: req.user.id } });
    if (!user) {
      return res.status(401).json({ message: "Unauthorized." });
    }
    if (user.reset) {
      res.clearCookie("accessToken");
      const refreshTokenRepo = AppDataSource.getRepository("RefreshToken");
      await refreshTokenRepo
      .createQueryBuilder()
      .update()
      .set({ revoked: true })
      .where("userId = :userId", { userId: user.id })
      .execute();

      return res.status(401).json({ message: "Unauthorized." });
    }
    next();
  } catch (err) {
    console.error(err);
    return res.status(401).json({ message: "Invalid access token" });
  }
};

/**
 * Middleware to allow only admins and superadmins
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
export const isAdmin = (req, res, next) => {
  if (!req.user.role.includes(1) || !req.user.role.includes(2)) {
    return res.status(403).json({ message: "Permission Denied" });
  }
  next();
};

/**
 * Middleware to allow only superadmins
 * @param {Object} req - Express request object
 * @param {Object} res - Express response object
 * @param {Function} next - Express next function
 */
export const isSuperAdmin = (req, res, next) => {
  if (!req.user.role.includes(1)) {
    return res.status(403).json({ message: "Permission Denied" });
  }
  next();
};

/**
 * Middleware to check if user has specific permission
 * @param {string} permission - Permission to check
 * @returns {Function} Middleware function
 */
export const checkPermission = (permission) => {
  return async (req, res, next) => {
    try {
      // Get user with roles and permissions
      const userRepo = AppDataSource.getRepository(UserEntity);
      const user = await userRepo.findOne({
        where: { id: req.user.id },
        relations: ["roles", "roles.permissions"]
      });

      if (!user) {
        return res.status(401).json({ message: "User not found" });
      }

      // Check if user has the required permission
      const hasPermission = user.roles.some(role => 
        role.permissions.some(perm => perm.name === permission)
      );

      if (!hasPermission) {
        return res.status(403).json({ message: "Permission denied" });
      }

      next();
    } catch (err) {
      console.error(err);
      return res.status(500).json({ message: "Error checking permissions" });
    }
  };
};

/**
 * Middleware to check if user owns the resource or is admin
 * @param {string} resourceIdParam - Parameter name containing resource ID
 * @returns {Function} Middleware function
 */
export const checkOwnership = (resourceIdParam = 'id') => {
  return async (req, res, next) => {
    try {
      const resourceId = req.params[resourceIdParam];
      const userId = req.user.id;
      const userRole = req.user.role;

      // Allow admins to access any resource
      if (userRole.includes(1) || userRole.includes(2)) {
        return next();
      }

      // Check if user owns the resource
      if (resourceId !== userId) {
        return res.status(403).json({ message: "Access denied" });
      }

      next();
    } catch (err) {
      console.error(err);
      return res.status(500).json({ message: "Error checking ownership" });
    }
  };
};
