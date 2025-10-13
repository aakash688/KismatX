// Authentication Routes
// Handles user authentication endpoints

import express from 'express';
import { 
  login, 
  logout, 
  refreshToken, 
  requestPasswordReset, 
  resetPassword 
} from '../controllers/authController.js';
import { validateRequest } from '../middleware/validate.js';
import { commonSchemas } from '../middleware/validate.js';

const router = express.Router();

// Public authentication routes
router.post('/login', validateRequest(commonSchemas.login), login);
router.post('/logout', logout);
router.post('/refresh', refreshToken);
router.post('/request-password-reset', requestPasswordReset);
router.post('/reset-password/:token', resetPassword);

export default router;
