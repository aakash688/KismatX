/**
 * Barcode Generator Utility
 * Generate and verify secure barcodes for bet slips
 * 
 * @module utils/barcode
 */

import crypto from 'crypto';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// Barcode secret from environment variable
const BARCODE_SECRET = process.env.BARCODE_SECRET;

if (!BARCODE_SECRET || BARCODE_SECRET.length < 32) {
    console.warn('⚠️  WARNING: BARCODE_SECRET not set or too short. Using default (NOT SECURE FOR PRODUCTION).');
}

// Default secret for development (should be replaced in production)
const DEFAULT_SECRET = 'kismatx-barcode-secret-key-change-in-production-2024';

const SECRET_KEY = BARCODE_SECRET || DEFAULT_SECRET;

/**
 * Generate secure barcode for bet slip
 * 
 * Format: GAME_202511010800_F47AC10B_A3
 * - Prefix: "GAME_"
 * - Game ID: YYYYMMDDHHMM (12 digits)
 * - Slip UUID prefix: First 8 characters of slip_id
 * - HMAC checksum: 2 characters (first 2 of HMAC)
 * 
 * @param {string} gameId - Game ID in format YYYYMMDDHHMM
 * @param {string} slipId - UUID of the bet slip
 * @returns {string} Secure barcode string
 */
export function generateSecureBarcode(gameId, slipId) {
    if (!gameId || typeof gameId !== 'string') {
        throw new Error('gameId must be a non-empty string');
    }
    
    if (!slipId || typeof slipId !== 'string') {
        throw new Error('slipId must be a non-empty string');
    }
    
    // Validate gameId format (12 digits)
    if (!/^\d{12}$/.test(gameId)) {
        throw new Error(`Invalid gameId format: ${gameId}. Expected 12 digits (YYYYMMDDHHMM)`);
    }
    
    // Extract first 8 characters from UUID
    const slipPrefix = slipId.substring(0, 8).toUpperCase();
    
    // Create data string for HMAC
    const dataString = `${gameId}_${slipPrefix}`;
    
    // Generate HMAC-SHA256 hash
    const hmac = crypto.createHmac('sha256', SECRET_KEY);
    hmac.update(dataString);
    const hash = hmac.digest('hex');
    
    // Use first 2 characters of hash as checksum
    const checksum = hash.substring(0, 2).toUpperCase();
    
    // Construct barcode
    const barcode = `GAME_${gameId}_${slipPrefix}_${checksum}`;
    
    return barcode;
}

/**
 * Verify barcode integrity
 * 
 * @param {string} gameId - Game ID used to generate barcode
 * @param {string} slipId - UUID of the bet slip
 * @param {string} barcode - Barcode to verify
 * @returns {boolean} True if barcode is valid, false otherwise
 */
export function verifyBarcode(gameId, slipId, barcode) {
    if (!gameId || !slipId || !barcode) {
        return false;
    }
    
    try {
        // Parse the barcode
        const parsed = parseBarcode(barcode);
        
        // Verify game ID matches
        if (parsed.gameId !== gameId) {
            return false;
        }
        
        // Verify slip prefix matches
        const slipPrefix = slipId.substring(0, 8).toUpperCase();
        if (parsed.slipPrefix !== slipPrefix) {
            return false;
        }
        
        // Regenerate barcode and compare
        const expectedBarcode = generateSecureBarcode(gameId, slipId);
        return expectedBarcode === barcode;
        
    } catch (error) {
        console.error('Error verifying barcode:', error);
        return false;
    }
}

/**
 * Parse barcode and extract components
 * 
 * @param {string} barcode - Barcode string to parse
 * @returns {{gameId: string, slipPrefix: string, checksum: string, prefix: string}} Parsed barcode components
 * @throws {Error} If barcode format is invalid
 */
export function parseBarcode(barcode) {
    if (!barcode || typeof barcode !== 'string') {
        throw new Error('Barcode must be a non-empty string');
    }
    
    // Expected format: GAME_202511010800_F47AC10B_A3
    const barcodeRegex = /^GAME_(\d{12})_([A-F0-9]{8})_([A-F0-9]{2})$/;
    const match = barcode.match(barcodeRegex);
    
    if (!match) {
        throw new Error(`Invalid barcode format: ${barcode}. Expected format: GAME_YYYYMMDDHHMM_UUIDPREFIX_CHECKSUM`);
    }
    
    const [, gameId, slipPrefix, checksum] = match;
    
    return {
        prefix: 'GAME_',
        gameId,
        slipPrefix,
        checksum
    };
}

