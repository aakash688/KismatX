// Enhanced Authentication Controller
// Handles comprehensive auth with audit logging and security features

import { AppDataSource } from "../config/typeorm.config.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { generateAccessToken, generateRefreshToken } from "../utils/token.js";
import { sendResetPasswordEmail, sendWelcomeEmail } from "../utils/mailer.js";
import { auditLog } from "../utils/auditLogger.js";

const UserEntity = "User";
const RefreshTokenEntity = "RefreshToken";
const LoginHistoryEntity = "LoginHistory";

/**
 * Register a new user
 * POST /api/auth/register
 */
export const register = async (req, res, next) => {
    try {
        const { 
            first_name, 
            last_name, 
            email, 
            mobile, 
            password, 
            user_id,
            alternate_mobile,
            address,
            city,
            state,
            pin_code,
            region
        } = req.body;

        // Validation
        if (!first_name || !last_name || !email || !mobile || !password || !user_id) {
            return res.status(400).json({ 
                message: "Missing required fields: first_name, last_name, email, mobile, password, user_id" 
            });
        }

        const userRepo = AppDataSource.getRepository(UserEntity);

        // Check if user already exists
        const existingUser = await userRepo.findOne({
            where: [
                { email: email },
                { mobile: mobile },
                { user_id: user_id }
            ]
        });

        if (existingUser) {
            return res.status(400).json({ 
                message: "User already exists with this email, mobile, or user_id" 
            });
        }

        // Hash password
        const saltRounds = 12;
        const password_hash = await bcrypt.hash(password, saltRounds);
        const password_salt = await bcrypt.genSalt(saltRounds);

        // Create user
        const newUser = userRepo.create({
            user_id,
            first_name,
            last_name,
            mobile,
            alternate_mobile,
            email,
            address,
            city,
            state,
            pin_code,
            region,
            password_hash,
            password_salt,
            user_type: "player",
            status: "active"
        });

        const savedUser = await userRepo.save(newUser);

        // Log registration
        await auditLog({
            user_id: savedUser.id,
            action: "user_registered",
            details: `User registered with email: ${email}`,
            ip_address: req.ip,
            user_agent: req.get('User-Agent')
        });

        // Send welcome email (optional)
        try {
            await sendWelcomeEmail(savedUser);
        } catch (emailError) {
            console.log("Welcome email failed:", emailError.message);
        }

        res.status(201).json({
            message: "User registered successfully",
            user: {
                id: savedUser.id,
                user_id: savedUser.user_id,
                first_name: savedUser.first_name,
                last_name: savedUser.last_name,
                email: savedUser.email,
                mobile: savedUser.mobile,
                user_type: savedUser.user_type,
                status: savedUser.status
            }
        });

    } catch (err) {
        next(err);
    }
};

/**
 * Login user
 * POST /api/auth/login
 */
export const login = async (req, res, next) => {
    try {
        const { user_id, password } = req.body;

        if (!user_id || !password) {
            return res.status(400).json({ 
                message: "user_id and password are required" 
            });
        }

        const userRepo = AppDataSource.getRepository(UserEntity);
        const loginHistoryRepo = AppDataSource.getRepository(LoginHistoryEntity);

        // Find user strictly by user_id
        const user = await userRepo.findOne({
            where: { user_id },
            relations: ["roles"]
        });

        if (!user) {
            // Log failed login attempt
            await loginHistoryRepo.save({
                user_id: null,
                login_method: "user_id",
                is_successful: false,
                failure_reason: "User not found",
                ip_address: req.ip,
                user_agent: req.get('User-Agent')
            });

            return res.status(401).json({ 
                message: "Invalid credentials" 
            });
        }

        // Check if user is active
        if (user.status !== "active") {
            await loginHistoryRepo.save({
                user_id: user.id,
                login_method: "user_id",
                is_successful: false,
                failure_reason: `Account ${user.status}`,
                ip_address: req.ip,
                user_agent: req.get('User-Agent')
            });

            return res.status(401).json({ 
                message: `Account is ${user.status}` 
            });
        }

        // Verify password
        const isPasswordValid = await bcrypt.compare(password, user.password_hash);
        if (!isPasswordValid) {
            await loginHistoryRepo.save({
                user_id: user.id,
                login_method: "user_id",
                is_successful: false,
                failure_reason: "Invalid password",
                ip_address: req.ip,
                user_agent: req.get('User-Agent')
            });

            return res.status(401).json({ 
                message: "Invalid credentials" 
            });
        }

        // Enforce single active session: if an active refresh token exists for this user, block new login
        const refreshTokenRepo = AppDataSource.getRepository(RefreshTokenEntity);
        const existingActiveToken = await refreshTokenRepo
            .createQueryBuilder('rt')
            .where('rt.user_id = :userId', { userId: user.id })
            .andWhere('rt.revoked = :revoked', { revoked: false })
            .andWhere('rt.expiresAt > :now', { now: new Date() })
            .getOne();

        if (existingActiveToken) {
            // Log blocked login attempt due to existing active session
            await loginHistoryRepo.save({
                user_id: user.id,
                login_method: "user_id",
                is_successful: false,
                failure_reason: "Active session exists",
                ip_address: req.ip,
                user_agent: req.get('User-Agent')
            });

            return res.status(409).json({
                message: "Active session detected. Please logout from the previous device and try again.",
                expiresAt: existingActiveToken.expiresAt
            });
        }

        // Generate tokens
        const accessToken = generateAccessToken(user);
        const refreshToken = generateRefreshToken(user);

        // Save refresh token
        try {
            const savedToken = await refreshTokenRepo.save({
                user: user, // Use the user object instead of user_id
                token: refreshToken,
                expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 days
            });
            console.log("Refresh token saved successfully:", savedToken.id);
        } catch (error) {
            console.error("Error saving refresh token:", error);
            // Continue with login even if refresh token save fails
        }

        // Log successful login
        await loginHistoryRepo.save({
            user_id: user.id,
            login_method: "user_id",
            is_successful: true,
            ip_address: req.ip,
            user_agent: req.get('User-Agent')
        });

        // Update last login
        user.last_login = new Date();
        await userRepo.save(user);

        // Log login action
        await auditLog({
            user_id: user.id,
            action: "user_login",
            details: `User logged in from ${req.ip}`,
            ip_address: req.ip,
            user_agent: req.get('User-Agent')
        });

        res.json({
            message: "Login successful",
            accessToken,
            refreshToken,
            user: {
                id: user.id,
                user_id: user.user_id,
                first_name: user.first_name,
                last_name: user.last_name,
                email: user.email,
                mobile: user.mobile,
                user_type: user.user_type,
                status: user.status,
                roles: user.roles?.map(role => role.name) || []
            }
        });

    } catch (err) {
        next(err);
    }
};

/**
 * Logout user
 * POST /api/auth/logout
 */
export const logout = async (req, res, next) => {
    try {
        const { refreshToken } = req.body;

        if (refreshToken) {
            const refreshTokenRepo = AppDataSource.getRepository(RefreshTokenEntity);
            await refreshTokenRepo.delete({ token: refreshToken });
        }

        // Log logout action
        await auditLog({
            user_id: req.user?.id,
            action: "user_logout",
            details: "User logged out",
            ip_address: req.ip,
            user_agent: req.get('User-Agent')
        });

        res.json({ message: "Logout successful" });

    } catch (err) {
        next(err);
    }
};

/**
 * Refresh access token
 * POST /api/auth/refresh-token
 */
export const refreshToken = async (req, res, next) => {
    try {
        const { refreshToken } = req.body;

        if (!refreshToken) {
            return res.status(400).json({ message: "Refresh token is required" });
        }

        const refreshTokenRepo = AppDataSource.getRepository(RefreshTokenEntity);
        const userRepo = AppDataSource.getRepository(UserEntity);

        const tokenRecord = await refreshTokenRepo.findOne({
            where: { token: refreshToken },
            relations: ["user", "user.roles"]
        });

        console.log("Refresh token lookup result:", tokenRecord ? "Found" : "Not found");
        if (tokenRecord) {
            console.log("Token record user:", tokenRecord.user ? "User exists" : "User is null");
            console.log("Token expires at:", tokenRecord.expiresAt);
            console.log("Current time:", new Date());
        }

        if (!tokenRecord || tokenRecord.expiresAt < new Date()) {
            return res.status(401).json({ message: "Invalid or expired refresh token" });
        }

        // Check if user relationship exists
        if (!tokenRecord.user || !tokenRecord.user.id) {
            return res.status(401).json({ message: "Invalid refresh token - user not found" });
        }

        // Fetch user with roles for token generation
        const user = await userRepo.findOne({
            where: { id: tokenRecord.user.id },
            relations: ["roles"]
        });

        if (!user) {
            return res.status(401).json({ message: "User not found" });
        }

        // Generate new access token
        const accessToken = generateAccessToken(user);

        res.json({
            message: "Token refreshed successfully",
            accessToken
        });

    } catch (err) {
        next(err);
    }
};

/**
 * Forgot password
 * POST /api/auth/forgot-password
 */
export const forgotPassword = async (req, res, next) => {
    try {
        const { email_or_mobile } = req.body;

        if (!email_or_mobile) {
            return res.status(400).json({ message: "Email or mobile is required" });
        }

        const userRepo = AppDataSource.getRepository(UserEntity);
        const user = await userRepo.findOne({
            where: [
                { email: email_or_mobile },
                { mobile: email_or_mobile }
            ]
        });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        // Generate reset token (in real implementation, use crypto.randomBytes)
        const resetToken = jwt.sign(
            { userId: user.id, type: 'password_reset' },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: '1h' }
        );

        // Save reset token to user (you might want a separate table for this)
        user.resetPasswordToken = resetToken;
        user.resetPasswordExpires = new Date(Date.now() + 60 * 60 * 1000); // 1 hour
        await userRepo.save(user);

        // Send reset email
        const resetLink = `${process.env.BASEURL}/reset-password?token=${resetToken}`;
        await sendResetPasswordEmail(user, resetLink);

        // Log password reset request
        await auditLog({
            user_id: user.id,
            action: "password_reset_requested",
            details: `Password reset requested for ${email_or_mobile}`,
            ip_address: req.ip,
            user_agent: req.get('User-Agent')
        });

        res.json({ message: "Password reset instructions sent to your email/mobile" });

    } catch (err) {
        next(err);
    }
};

/**
 * Reset password
 * POST /api/auth/reset-password
 */
export const resetPassword = async (req, res, next) => {
    try {
        const { token, newPassword } = req.body;

        if (!token || !newPassword) {
            return res.status(400).json({ message: "Token and new password are required" });
        }

        const userRepo = AppDataSource.getRepository(UserEntity);

        // Verify token
        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
        if (decoded.type !== 'password_reset') {
            return res.status(400).json({ message: "Invalid token type" });
        }

        const user = await userRepo.findOne({
            where: { 
                id: decoded.userId,
                resetPasswordToken: token,
                resetPasswordExpires: { $gt: new Date() }
            }
        });

        if (!user) {
            return res.status(400).json({ message: "Invalid or expired token" });
        }

        // Hash new password
        const saltRounds = 12;
        const password_hash = await bcrypt.hash(newPassword, saltRounds);
        const password_salt = await bcrypt.genSalt(saltRounds);

        // Update password
        user.password_hash = password_hash;
        user.password_salt = password_salt;
        user.resetPasswordToken = null;
        user.resetPasswordExpires = null;
        await userRepo.save(user);

        // Log password reset
        await auditLog({
            user_id: user.id,
            action: "password_reset_completed",
            details: "Password reset completed successfully",
            ip_address: req.ip,
            user_agent: req.get('User-Agent')
        });

        res.json({ message: "Password reset successfully" });

    } catch (err) {
        if (err.name === 'JsonWebTokenError') {
            return res.status(400).json({ message: "Invalid token" });
        }
        if (err.name === 'TokenExpiredError') {
            return res.status(400).json({ message: "Token expired" });
        }
        next(err);
    }
};

/**
 * Change password (authenticated user)
 * POST /api/user/change-password
 */
export const changePassword = async (req, res, next) => {
    try {
        const { currentPassword, newPassword } = req.body;

        if (!currentPassword || !newPassword) {
            return res.status(400).json({ message: "Current password and new password are required" });
        }

        const userRepo = AppDataSource.getRepository(UserEntity);
        const user = await userRepo.findOne({ where: { id: req.user.id } });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        // Verify current password
        const isCurrentPasswordValid = await bcrypt.compare(currentPassword, user.password_hash);
        if (!isCurrentPasswordValid) {
            return res.status(400).json({ message: "Current password is incorrect" });
        }

        // Hash new password
        const saltRounds = 12;
        const password_hash = await bcrypt.hash(newPassword, saltRounds);
        const password_salt = await bcrypt.genSalt(saltRounds);

        // Update password
        user.password_hash = password_hash;
        user.password_salt = password_salt;
        await userRepo.save(user);

        // Log password change
        await auditLog({
            user_id: user.id,
            action: "password_changed",
            details: "User changed their password",
            ip_address: req.ip,
            user_agent: req.get('User-Agent')
        });

        res.json({ message: "Password changed successfully" });

    } catch (err) {
        next(err);
    }
};