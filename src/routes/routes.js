// API Routes Configuration
// Main routes file that imports and configures all route modules

import express from 'express';
import authRoutes from './auth.js';
import userRoutes from './user.js';
// Import other route modules as needed
// import productRoutes from './product.js';
// import orderRoutes from './order.js';

const router = express.Router();

// Mount route modules
router.use('/auth', authRoutes);
router.use('/user', userRoutes);
// Mount other routes
// router.use('/products', productRoutes);
// router.use('/orders', orderRoutes);

export default router;
