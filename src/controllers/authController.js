// Authentication Controller
// Handles user authentication, login, logout, and password management

import { getRepository, In } from "typeorm";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import crypto from "crypto";
import { sendResetPasswordEmail } from "../utils/mailer.js";
import { AppDataSource } from "../config/typeorm.config.js";
import { generateAccessToken, generateRefreshToken, refreshTokenExpiryMs } from "../utils/token.js";

const UserEntity = "User";
const REFRESH_TOKEN_SECRET = process.env.REFRESH_TOKEN_SECRET || "yourrefreshtokensecret";

// ===========================
// Public Endpoints
// ===========================

/**
 * Login a user and issue tokens
 * POST /api/auth/login
 */
export const login = async (req, res) => {
  try {
    const { userid, password } = req.body;
    const userRepo = AppDataSource.getRepository(UserEntity);
    const roleRepo = AppDataSource.getRepository("roles");
    const user = await userRepo.findOne({ where: { userid }, relations: ["roles"] });
    
    if (!user) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    if (!user.isApproved) {
      return res.status(403).json({ message: "User not approved by admin" });
    }

    if (!user.isActive) {
      return res.status(403).json({ message: "User is deactivated" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    const refreshTokenRepo = AppDataSource.getRepository("RefreshToken");

    // Generate new tokens
    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);

    // Save the new refresh token in the database
    const newTokenRecord = refreshTokenRepo.create({
      token: refreshToken,
      user: user,
      expiresAt: new Date(Date.now() + refreshTokenExpiryMs),
      revoked: false
    });
    await refreshTokenRepo.save(newTokenRecord);

    // set reset to 0 if login successful
    user.reset = 0;
    user.lastLogin = new Date();
    await userRepo.save(user);

    res.cookie("accessToken", accessToken, { httpOnly: true, sameSite: "Lax" });
    res.cookie("refreshToken", refreshToken, {httpOnly: true, sameSite: "Lax" });
    res.json({
      refreshToken,
      accessToken,
      user: { id: user.id, name: user.name, email: user.email }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Logout: clear the access token cookie
 * POST /api/auth/logout
 */
export const logout = async (req, res) => {
  res.clearCookie("accessToken");
  res.clearCookie("refreshToken");
  res.json({ message: "Logged out successfully" });
};

/**
 * Refresh access token using refresh token
 * POST /api/auth/refresh
 */
export const refreshToken = async (req, res) => {
  try {
    const { refreshToken } = req.cookies;
    if (!refreshToken) {
      return res.status(401).json({ message: "Refresh token required" });
    }

    // Look up the refresh token in the database
    const refreshTokenRepo = AppDataSource.getRepository("RefreshToken");
    const tokenRecord = await refreshTokenRepo.findOne({
      where: { token: refreshToken },
      relations: ["user", "user.roles"]
    });

    if (!tokenRecord) {
      return res.status(401).json({ message: "Invalid refresh token" });
    }

    // Check if the token is expired or revoked
    if (new Date() > tokenRecord.expiresAt || tokenRecord.revoked) {
      return res.status(401).json({ message: "Refresh token expired or revoked" });
    }

    // Verify the refresh token's signature
    jwt.verify(refreshToken, REFRESH_TOKEN_SECRET, async (err, decoded) => {
      if (err) {
        return res.status(401).json({ message: "Invalid refresh token" });
      }

      // Generate a new access token
      const user = tokenRecord.user;
      const newAccessToken = generateAccessToken(user);

      // Set the new access token in an HTTP-only cookie
      res.cookie("accessToken", newAccessToken, {
        httpOnly: process.env.HTTP_ONLY === "TRUE", 
        sameSite: "lax", 
        secure: process.env.NODE_ENV === "production"
      });

      // Return the new access token
      res.json({ accessToken: newAccessToken, refreshToken });
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Request a password reset (sends an email with a reset link)
 * POST /api/auth/request-password-reset
 */
export const requestPasswordReset = async (req, res) => {
  try {
    const { userid } = req.body;
    const userRepo = AppDataSource.getRepository(UserEntity);
    const user = await userRepo.findOne({ where: { userid } });
    
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    
    // Generate a reset token and set expiry (1 hour)
    const resetToken = crypto.randomBytes(20).toString("hex");
    user.resetPasswordToken = resetToken;
    user.resetPasswordExpires = new Date(Date.now() + 3600000);
    await userRepo.save(user);
    
    const resetLink = `${process.env.BASEURL || 'http://localhost:5000'}/api/auth/reset-password/${resetToken}`;
    await sendResetPasswordEmail(user, resetLink);
    
    res.json({ message: "Password reset email sent" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Reset the password using the token sent via email
 * POST /api/auth/reset-password/:token
 */
export const resetPassword = async (req, res) => {
  try {
    const { token } = req.params;
    const { password } = req.body;
    const userRepo = AppDataSource.getRepository(UserEntity);
    const user = await userRepo.findOne({ where: { resetPasswordToken: token } });
    
    if (!user || user.resetPasswordExpires < new Date()) {
      return res.status(400).json({ message: "Invalid or expired token" });
    }
    
    user.password = await bcrypt.hash(password, 10);
    user.resetPasswordToken = null;
    user.resetPasswordExpires = null;
    user.reset = 1; // Set Reset Flag to 1
    await userRepo.save(user);
    
    res.json({ message: "Password reset successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};
