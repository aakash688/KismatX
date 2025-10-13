// User Controller
// Handles user management operations

import { AppDataSource } from "../config/typeorm.config.js";
import { In, Between } from "typeorm";
import bcrypt from "bcrypt";
import path from "path";
import { ILike } from "typeorm";
import fs from 'fs';

const UserEntity = "User";

/**
 * Get user statistics
 * GET /api/user/stats
 */
export const userStats = async (req, res, next) => {
    try {
        const userRepo = AppDataSource.getRepository(UserEntity);
        
        // Get current date and first day of current month
        const now = new Date();
        const firstDayOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
        
        const [total, active, newUsers] = await Promise.all([
            userRepo.count(),
            userRepo.count({ where: { isActive: true } }),
            userRepo.count({
                where: {
                    createdAt: Between(firstDayOfMonth, now)
                }
            })
        ]);

        const inactive = total - active;

        return res.status(200).json({
            total,
            active,
            new: newUsers,
            inactive,
            analytic: {
                totalChange: 2.5,
                activeChange: 10.6,
                newChange: 6.5,
                inactiveChange: 6.9
            }
        });
    } catch(err) {
        next(err);
    }
}

/**
 * Get current user profile
 * GET /api/user/me
 */
export const getMe = async (req, res, next) => {
    try {
        const user = await AppDataSource
            .getRepository(UserEntity)
            .createQueryBuilder("user")
            .leftJoinAndSelect("user.roles", "roles")
            .leftJoinAndSelect("user.department", "department")
            .select(['user.id', 'user.fname', 'user.lname', 'user.email', 'user.userid', 'user.designation', 'user.mobileno', 'roles.name', 'department.name'])
            .where("user.id = :id", { id: req.user.id })
            .getOne()

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        user.roles = user.roles.map((role) => role.name)
        res.json(user);
    } catch (err) {
        next(err)
        console.error(err);
    }
};

/**
 * List users with optional filtering
 * GET /api/user
 * GET /api/user/:id
 */
export const ListUser = async (req, res, next) => {
    try {
        const userId = req.params.id;
        const filters = req.query;
        const userRepo = AppDataSource.getRepository(UserEntity);
        let queryFilters = {};

        const selectFields = {
            id: true,
            userid: true,
            fname: true,
            lname: true,
            email: true,
            designation: true,
            mobileno: true,
            isApproved: true,
            isActive: true,
            profilePhoto: true,
            lastLogin: true,
            bloodGroup: true,
            birthDate: true
        };

        const queryOptions = {
            select: selectFields,
            relations: ["roles", "department"]
        };

        if (userId) {
            const user = await userRepo.findOne({
                ...queryOptions,
                where: { id: userId }
            });

            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }
            const transformedUser = {
                ...user,
                roles: user.roles?.map(role => role.id) || [],
                department: user.department?.id || null,
                profilePhoto: user.profilePhoto ? `/profile/${user.profilePhoto}` : null,
            };
            return res.status(200).json(transformedUser);
        } else if (Object.keys(filters).length > 0) {
            for (const key in filters) {
                // Skip pagination params if present
                if (key === 'page' || key === 'limit') continue;
                
                // Handle relations filtering
                if (key === 'roles') {
                    queryFilters['roles'] = { id: In(filters[key].split(',')) };
                    continue;
                }
                if (key === 'department') {
                    queryFilters['department'] = { id: filters[key] };
                    continue;
                }
                
                // Handle regular fields
                if (typeof filters[key] === 'string') {
                    if (filters[key].toLowerCase() === 'true') {
                        queryFilters[key] = true;
                    } else if (filters[key].toLowerCase() === 'false') {
                        queryFilters[key] = false;
                    } else {
                        queryFilters[key] = ILike(`%${filters[key]}%`);
                    }
                } else {
                    queryFilters[key] = filters[key];
                }
            }
            
            // Apply filters to queryOptions
            queryOptions.where = queryFilters;
        }

        const users = await userRepo.find(queryOptions);
        
        // Transform relations to strings
        const transformedUsers = users.map(user => ({
            ...user,
            roles: user.roles?.map(role => role.name).join(', ') || '',
            department: user.department?.name || null,
            profilePhoto: user.profilePhoto ? `/profile/${user.profilePhoto}` : null,
        }));

        return res.status(200).json({ 
            data: userId ? transformedUsers[0] : transformedUsers 
        });

    } catch (err) {
        next(err);
    }
}

/**
 * Approve a user (admin approval)
 * PUT /api/user/:id/approve
 */
export const approveUser = async (req, res, next) => {
    try {
        const userId = req.params.id;
        const userRepo = AppDataSource.getRepository(UserEntity);
        let user = await userRepo.findOne({ where: { id: userId } });
        
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }
        
        user.isApproved = true;
        await userRepo.save(user);
        res.json({ message: "User approved" });
    } catch (err) {
        next(err)
        console.error(err);
    }
};

/**
 * Change user status
 * PUT /api/user/:id/status
 */
export const changeUserStatus = async (req, res, next) => {
    try {
        const userId = req.params.id;
        const status = req.body.status;
        const userRepo = AppDataSource.getRepository(UserEntity);
        let user = await userRepo.findOne({ where: { id: userId } });
        
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }
        
        user.isActive = status;
        await userRepo.save(user);
        res.json({ message: `User ${status ? ('activated') : ('deactivated')}` });
    } catch (err) {
        next(err)
        console.error(err);
    }
};

/**
 * Create a new user
 * POST /api/user
 */
export const CreateUser = async (req, res, next) => {
    try {
        const { fname, lname, mobileno, department, designation, userid, email, password, roleNames, bloodGroup, birthDate } = req.body;

        // Validate required fields first
        if (!fname || !lname || !userid || !email || !password || !roleNames) {
            return res.status(400).json({ message: "Invalid input data" });
        }

        const userRepo = AppDataSource.getRepository(UserEntity);
        const roleRepo = AppDataSource.getRepository("roles");

        // Check if email already exists
        const existingUser = await userRepo.findOne({ where: { userid } });
        if (existingUser) {
            return res.status(400).json({ message: "User ID already registered" });
        }

        const roleNames_ = JSON.parse(roleNames)

        // Roles are Mandatory
        if (roleNames_.length == 0) {
            return res.status(400).json({ message: "Roles not assigned." })
        }

        // Find Roles by their names
        let roles;
        try {
            roles = await roleRepo.find({
                where: { id: In(roleNames_) }
            });
        } catch (error) {
            return next({ status: 500, message: "Database error while fetching roles" })
        }

        if (roles.length !== roleNames_.length) {
            return res.status(400).json({ message: "Incorrect roles selection." });
        }

        // Only after all validations pass, handle file upload
        let profilePhotoPath = null;
        if (req.files && req.files.profilePhoto) {
            const file = req.files.profilePhoto;
            const ext = path.extname(file.name);
            const filename = `${Date.now()}-profilePhoto${ext}`;
            const uploadPath = path.join('uploads', 'profilePhoto', filename);

            try {
                await file.mv(uploadPath);
                profilePhotoPath = `${filename}`;
            } catch (err) {
                console.error('Error uploading file:', err);
                return res.status(500).json({ message: "Error uploading profile photo" });
            }
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = userRepo.create({
            fname,
            lname,
            mobileno,
            department,
            designation,
            userid,
            email,
            password: hashedPassword,
            roles,
            profilePhoto: profilePhotoPath,
            isApproved: false,
            isActive: false,
            birthDate: birthDate ? new Date(birthDate) : null,
            bloodGroup: bloodGroup || null
        });

        await userRepo.save(newUser);
        res.status(201).json({ message: "User created successfully" });
    } catch (err) {
        next(err)
        console.error(err);
    }
};

/**
 * Update user information
 * PUT /api/user/:id
 */
export const EditUser = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { fname, lname, department, email, designation, mobileno, roleNames, bloodGroup, birthDate } = req.body;

        const userRepo = AppDataSource.getRepository(UserEntity);
        const roleRepo = AppDataSource.getRepository("roles");

        let user = await userRepo.findOne({ where: { id }, relations: ["roles"] });

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        // Update fields if provided
        if (fname !== undefined) user.fname = fname;
        if (lname !== undefined) user.lname = lname;
        if (email !== undefined) user.email = email;
        if (designation !== undefined) user.designation = designation;
        if (mobileno !== undefined) user.mobileno = mobileno;
        if (department !== undefined) user.department = department;
        if (bloodGroup !== undefined) user.bloodGroup = bloodGroup || null;
        
        // Handle birthDate with proper validation
        if (birthDate !== undefined) {
            if (!birthDate || birthDate === '') {
                user.birthDate = null;
            } else {
                // Try to parse the date
                const parsedDate = new Date(birthDate);
                if (isNaN(parsedDate.getTime())) {
                    return res.status(400).json({ 
                        message: "Invalid birth date format. Please provide date in YYYY-MM-DD format"
                    });
                }
                // Format the date to YYYY-MM-DD to ensure consistent storage
                user.birthDate = parsedDate.toISOString().split('T')[0];
            }
        }

        // If roles are provided, update them
        if (roleNames) {
            const roleNames_ = JSON.parse(roleNames);
            // Fetch role entities by name
            const roleEntities = await roleRepo.find({
                where: { id: In(roleNames_) }
            });

            if (roleEntities.length !== roleNames_.length) {
                return res.status(400).json({ message: "One or more roles are invalid" });
            }

            user.roles = roleEntities;
        }

        // Handle profile photo update if provided
        if (req.files && req.files.profilePhoto) {
            const file = req.files.profilePhoto;
            const ext = path.extname(file.name);
            const filename = `${Date.now()}-profilePhoto${ext}`;
            const uploadPath = path.join('uploads', 'profilePhoto', filename);

            try {
                await file.mv(uploadPath);
                user.profilePhoto = `${filename}`;
            } catch (err) {
                console.error('Error uploading file:', err);
                return res.status(500).json({ message: "Error uploading profile photo" });
            }
        }

        await userRepo.save(user);
        res.json({ message: "User updated successfully", user });
    } catch (err) {
        next(err);
        console.error(err);
    }
};

/**
 * Delete user
 * DELETE /api/user/:id
 */
export const DeleteUser = async (req, res, next) => {
    try {
        const userId = req.params.id;
        const userRepo = AppDataSource.getRepository(UserEntity);
        
        let user = await userRepo.findOne({ where: { id: userId } });
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        await userRepo.delete(userId);
        res.status(200).json({ message: "User deleted successfully" });
    } catch (err) {
        console.error("Error deleting user:", err);
        next(err);
    }
}
