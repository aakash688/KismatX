// Admin Routes
// Comprehensive admin-only endpoints with RBAC and audit logging

import express from 'express';
import {
    getDashboard,
    createUser,
    getAllUsers,
    getUserById,
    updateUser,
    deleteUser,
    changeUserStatus,
    resetUserPassword,
    verifyUserEmail,
    verifyUserMobile,
    getUserLoginHistory,
    getAuditLogs,
    killUserSessions,
    getUserActiveSessions
} from '../controllers/adminController.js';
import {
    createRole,
    getAllRoles,
    updateRole,
    deleteRole,
    assignPermissionsToRole,
    getRolePermissions,
    assignRolesToUser,
    getUserRoles
} from '../controllers/roleController.js';
import {
    createPermission,
    getAllPermissions,
    updatePermission,
    deletePermission
} from '../controllers/permissionController.js';
import { verifyToken, isAdmin } from '../middleware/auth.js';

const router = express.Router();

// All admin routes require authentication and admin role
router.use(verifyToken);
router.use(isAdmin);

// Dashboard
router.get('/dashboard', getDashboard);

// User Management
router.post('/users', createUser);
router.get('/users', getAllUsers);
router.get('/users/:id', getUserById);
router.put('/users/:id', updateUser);
router.delete('/users/:id', deleteUser);
router.put('/users/:id/status', changeUserStatus);
router.post('/users/:id/reset-password', resetUserPassword);
router.put('/users/:id/verify-email', verifyUserEmail);
router.put('/users/:id/verify-mobile', verifyUserMobile);
router.get('/users/:id/logins', getUserLoginHistory);
router.post('/users/:user_id/sessions/kill', killUserSessions);
router.get('/users/:user_id/sessions/active', getUserActiveSessions);

// Role Management
router.post('/roles', createRole);
router.get('/roles', getAllRoles);
router.put('/roles/:id', updateRole);
router.delete('/roles/:id', deleteRole);
router.post('/roles/:id/permissions', assignPermissionsToRole);
router.get('/roles/:id/permissions', getRolePermissions);

// User-Role Assignment
router.post('/users/:id/roles', assignRolesToUser);
router.get('/users/:id/roles', getUserRoles);

// Permission Management
router.post('/permissions', createPermission);
router.get('/permissions', getAllPermissions);
router.put('/permissions/:id', updatePermission);
router.delete('/permissions/:id', deletePermission);

// Audit and Logging
router.get('/audit-logs', getAuditLogs);

export default router;

