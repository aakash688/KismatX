-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 03, 2025 at 09:30 AM
-- Server version: 12.0.2-MariaDB-ubu2404
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `KismatX`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `target_type` varchar(255) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `admin_id`, `action`, `target_type`, `target_id`, `details`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, NULL, 'user_registered', NULL, NULL, 'User registered with email: admin4@kismatx.com', '::1', 'PostmanRuntime/7.49.0', '2025-10-30 08:28:30'),
(2, 2, NULL, 'user_registered', NULL, NULL, 'User registered with email: admin3@kismatx.com', '::1', 'PostmanRuntime/7.49.0', '2025-10-30 08:28:47'),
(3, 3, NULL, 'user_registered', NULL, NULL, 'User registered with email: admin2@kismatx.com', '::1', 'PostmanRuntime/7.49.0', '2025-10-30 08:28:58'),
(4, 4, NULL, 'user_registered', NULL, NULL, 'User registered with email: admin1@kismatx.com', '::1', 'PostmanRuntime/7.49.0', '2025-10-30 08:29:14'),
(5, 5, NULL, 'user_registered', NULL, NULL, 'User registered with email: john.doe@example.com', '::1', 'PostmanRuntime/7.49.0', '2025-10-30 08:29:52'),
(6, 6, NULL, 'user_registered', NULL, NULL, 'User registered with email: john.doe2@example.com', '::1', 'PostmanRuntime/7.49.0', '2025-10-30 08:30:11'),
(7, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 08:32:46'),
(8, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 08:34:42'),
(9, 4, 3, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 08:34:50'),
(10, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 09:12:54'),
(11, 3, 4, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 09:13:06'),
(12, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 09:36:24'),
(13, 4, 3, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 09:36:29'),
(14, 2, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', '2025-10-30 09:51:47'),
(15, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', '2025-10-30 09:52:33'),
(16, 3, 4, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', '2025-10-30 09:52:41'),
(17, 2, 4, 'kill_sessions', 'User', 2, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', '2025-10-30 09:52:44'),
(18, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::ffff:192.168.1.108', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 10:31:31'),
(19, 3, 3, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 10:35:58'),
(20, 4, 3, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 10:36:21'),
(21, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::ffff:192.168.1.100', '::ffff:192.168.1.100', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 10:36:29'),
(22, 4, 4, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::ffff:192.168.1.100', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-30 10:36:43'),
(23, 6, 3, 'wallet_transaction', 'wallet', 1, 'withdrawal debit: ₹10.00 - test', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 10:44:57'),
(24, 6, 3, 'wallet_transaction', 'wallet', 2, 'recharge credit: ₹10.00 - Credited by admin', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 10:45:57'),
(25, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::ffff:192.168.1.108', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 10:46:44'),
(26, 6, 4, 'wallet_transaction', 'wallet', 3, 'recharge credit: ₹500.00 - Credited by admin', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 11:01:10'),
(27, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::ffff:192.168.1.108', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 11:01:55'),
(28, 4, 3, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 11:02:02'),
(29, 3, 3, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 11:02:04'),
(30, 6, 3, 'wallet_transaction', 'wallet', 4, 'withdrawal debit: ₹250.00 - User withdrawal', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 11:02:19'),
(31, 5, 3, 'wallet_transaction', 'wallet', 5, 'recharge credit: ₹49.50 - Credited by admin', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 11:08:33'),
(32, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::ffff:192.168.1.108', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 12:17:28'),
(33, 4, 4, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 12:20:37'),
(34, 4, NULL, 'user_logout', NULL, NULL, 'User logged out', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 12:20:40'),
(35, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::ffff:192.168.1.108', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-30 12:21:05'),
(36, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::ffff:192.168.1.108', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 12:21:25'),
(37, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::ffff:192.168.1.108', '::ffff:192.168.1.108', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 12:23:46'),
(38, 2, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 18:22:34'),
(39, 5, 2, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 18:22:41'),
(40, 3, 2, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 18:22:43'),
(41, 4, 2, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 18:22:45'),
(42, 2, 2, 'kill_sessions', 'User', 2, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 18:22:47'),
(43, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'python-requests/2.32.3', '2025-10-30 18:24:00'),
(44, 2, NULL, 'user_logout', NULL, NULL, 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-30 18:25:40'),
(45, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', '2025-10-30 18:28:35'),
(46, 4, 3, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', '2025-10-30 18:28:40'),
(47, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 07:55:53'),
(48, 3, 4, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 07:56:02'),
(49, 4, 4, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 07:56:05'),
(52, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 08:22:26'),
(53, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 10:12:42'),
(54, 3, 3, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 10:12:48'),
(55, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.0', '2025-10-31 11:06:33'),
(56, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.0', '2025-10-31 11:07:40'),
(57, 2, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 11:52:05'),
(58, 5, 2, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 11:52:12'),
(59, 4, 2, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 11:52:14'),
(60, 3, 2, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-10-31 11:52:16'),
(61, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 13:33:32'),
(62, 4, 4, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 13:33:36'),
(63, 2, 4, 'kill_sessions', 'User', 2, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 13:33:41'),
(64, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 13:58:53'),
(65, 4, 4, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 13:58:55'),
(66, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_multiplier\":\"10\",\"maximum_limit\":\"5000\",\"game_start_time\":\"08:00\",\"game_end_time\":\"22:00\",\"game_result_type\":\"auto\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 13:59:26'),
(67, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_multiplier\":\"10\",\"maximum_limit\":\"5000\",\"game_start_time\":\"08:00\",\"game_end_time\":\"22:00\",\"game_result_type\":\"auto\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 13:59:27'),
(68, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_multiplier\":\"101\",\"maximum_limit\":\"5000\",\"game_start_time\":\"08:00\",\"game_end_time\":\"22:00\",\"game_result_type\":\"auto\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 14:00:14'),
(69, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_multiplier\":\"10\",\"maximum_limit\":\"5000\",\"game_start_time\":\"08:00\",\"game_end_time\":\"22:00\",\"game_result_type\":\"auto\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 14:00:20'),
(70, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 15:00:44'),
(71, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_multiplier\":\"10.8\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 15:00:57'),
(72, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_multiplier\":\"10\",\"maximum_limit\":\"5001\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 15:01:54'),
(73, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"maximum_limit\":\"5000\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 15:02:14'),
(74, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:03'),
(75, 3, 3, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:06'),
(76, 4, 3, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:08'),
(77, NULL, 3, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_multiplier\":\"10\",\"maximum_limit\":\"5000\",\"game_start_time\":\"08:00\",\"game_end_time\":\"22:00\",\"game_result_type\":\"manual\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:34'),
(78, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 21:44:33'),
(79, 5, 3, 'wallet_transaction', 'wallet', 8, 'recharge credit: ₹300.00 - Credited by admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 21:44:50'),
(80, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'python-requests/2.31.0', '2025-11-02 08:29:37'),
(81, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 08:40:45'),
(82, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 08:40:51'),
(83, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 08:40:56'),
(84, 5, NULL, 'bet_placed', 'bet_slip', 1, 'Bet placed: Game 202511021410, Amount: 250, Cards: 2, Slip ID: 4ef83c66-f387-4931-928d-69ac9045ee59', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 08:41:59'),
(85, 2, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:05:05'),
(86, 4, 2, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:05:11'),
(87, 3, 2, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:05:14'),
(88, NULL, 2, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_multiplier\":\"10\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:05:31'),
(89, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:45:45'),
(90, 2, 4, 'kill_sessions', 'User', 2, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:45:51'),
(91, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:47:08'),
(92, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 09:47:16'),
(93, 5, NULL, 'bet_placed', 'bet_slip', 2, 'Bet placed: Game 202511021515, Amount: 250, Cards: 2, Slip ID: 128c3cf6-4ba7-4c2d-8f02-bde3eba584ed', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 09:47:20'),
(94, 5, NULL, 'bet_placed', 'bet_slip', 3, 'Bet placed: Game 202511021515, Amount: 250, Cards: 2, Slip ID: d73a84af-c050-45f7-9c12-0fbac39ee93d', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 09:47:30'),
(95, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_result_type\":\"auto\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:48:29'),
(96, NULL, 1, 'game_settled', 'game', 1, 'Game 202511021405 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(97, NULL, 1, 'game_settled', 'game', 2, 'Game 202511021410 settled. Winning card: 10. Winning slips: 0, Losing slips: 1, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(98, NULL, 1, 'game_settled', 'game', 3, 'Game 202511021415 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(99, NULL, 1, 'game_settled', 'game', 4, 'Game 202511021420 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(100, NULL, 1, 'game_settled', 'game', 5, 'Game 202511021425 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(101, NULL, 1, 'game_settled', 'game', 6, 'Game 202511021430 settled. Winning card: 11. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(102, NULL, 1, 'game_settled', 'game', 7, 'Game 202511021435 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(103, NULL, 1, 'game_settled', 'game', 8, 'Game 202511021440 settled. Winning card: 10. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(104, NULL, 1, 'game_settled', 'game', 9, 'Game 202511021445 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(105, NULL, 1, 'game_settled', 'game', 10, 'Game 202511021450 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:49:00'),
(106, NULL, 1, 'game_settled', 'game', 11, 'Game 202511021455 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:50:00'),
(107, NULL, 1, 'game_settled', 'game', 12, 'Game 202511021500 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:50:00'),
(108, NULL, 1, 'game_settled', 'game', 13, 'Game 202511021505 settled. Winning card: 11. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:50:00'),
(109, NULL, 1, 'game_settled', 'game', 14, 'Game 202511021510 settled. Winning card: 12. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:50:00'),
(110, NULL, 1, 'game_settled', 'game', 15, 'Game 202511021515 settled. Winning card: 9. Winning slips: 0, Losing slips: 2, Total payout: 0', NULL, NULL, '2025-11-02 09:51:00'),
(111, NULL, 1, 'game_settled', 'game', 16, 'Game 202511021520 settled. Winning card: 11. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 09:56:00'),
(112, NULL, 1, 'game_settled', 'game', 17, 'Game 202511021525 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:01:00'),
(113, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 10:01:02'),
(114, 4, 3, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 10:01:07'),
(115, NULL, 1, 'game_settled', 'game', 18, 'Game 202511021530 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:06:00'),
(116, NULL, 1, 'game_settled', 'game', 19, 'Game 202511021535 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:11:00'),
(117, NULL, 1, 'game_settled', 'game', 20, 'Game 202511021540 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:16:00'),
(118, NULL, 1, 'game_settled', 'game', 21, 'Game 202511021545 settled. Winning card: 5. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:21:00'),
(119, NULL, 1, 'game_settled', 'game', 22, 'Game 202511021550 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:26:00'),
(120, NULL, 1, 'game_settled', 'game', 23, 'Game 202511021555 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:31:00'),
(121, NULL, 1, 'game_settled', 'game', 24, 'Game 202511021600 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:36:00'),
(122, NULL, 1, 'game_settled', 'game', 25, 'Game 202511021605 settled. Winning card: 11. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:41:00'),
(123, NULL, 1, 'game_settled', 'game', 26, 'Game 202511021610 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:46:00'),
(124, NULL, 1, 'game_settled', 'game', 27, 'Game 202511021615 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:51:00'),
(125, NULL, 1, 'game_settled', 'game', 28, 'Game 202511021620 settled. Winning card: 11. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 10:56:00'),
(126, NULL, 1, 'game_settled', 'game', 29, 'Game 202511021625 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:01:00'),
(127, NULL, 1, 'game_settled', 'game', 30, 'Game 202511021630 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:06:00'),
(128, NULL, 1, 'game_settled', 'game', 31, 'Game 202511021635 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:11:00'),
(129, NULL, 1, 'game_settled', 'game', 32, 'Game 202511021640 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:16:00'),
(130, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 11:19:51'),
(131, 3, 4, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 11:20:02'),
(132, NULL, 1, 'game_settled', 'game', 33, 'Game 202511021645 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:21:00'),
(133, NULL, 1, 'game_settled', 'game', 35, 'Game 202511021655 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:30:12'),
(134, NULL, 1, 'game_settled', 'game', 36, 'Game 202511021700 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:35:12'),
(135, NULL, 1, 'game_settled', 'game', 37, 'Game 202511021705 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:40:12'),
(136, NULL, 1, 'game_settled', 'game', 38, 'Game 202511021710 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:45:13'),
(137, NULL, 1, 'game_settled', 'game', 39, 'Game 202511021715 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:50:13'),
(138, NULL, 1, 'game_settled', 'game', 40, 'Game 202511021720 settled. Winning card: 12. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 11:55:13'),
(139, NULL, 1, 'game_settled', 'game', 41, 'Game 202511021725 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:00:13'),
(140, NULL, 1, 'game_settled', 'game', 42, 'Game 202511021730 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:05:14'),
(141, NULL, 1, 'game_settled', 'game', 43, 'Game 202511021735 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:10:14'),
(142, NULL, 1, 'game_settled', 'game', 44, 'Game 202511021740 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:15:14'),
(143, NULL, 1, 'game_settled', 'game', 45, 'Game 202511021745 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:20:14'),
(144, NULL, 1, 'game_settled', 'game', 46, 'Game 202511021750 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:25:05'),
(145, NULL, 1, 'game_settled', 'game', 47, 'Game 202511021755 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:30:05'),
(146, NULL, 1, 'game_settled', 'game', 48, 'Game 202511021800 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:35:05'),
(147, NULL, 1, 'game_settled', 'game', 49, 'Game 202511021805 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:40:05'),
(148, NULL, 1, 'game_settled', 'game', 50, 'Game 202511021810 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:45:06'),
(149, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 12:46:01'),
(150, NULL, 1, 'game_settled', 'game', 51, 'Game 202511021815 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:50:09'),
(151, NULL, 1, 'game_settled', 'game', 52, 'Game 202511021820 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 12:55:08'),
(152, 5, 3, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 12:58:58'),
(153, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 12:59:02'),
(154, NULL, 1, 'game_settled', 'game', 53, 'Game 202511021825 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 13:00:08'),
(155, 2, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 13:02:34'),
(156, 4, 2, 'kill_sessions', 'User', 4, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 13:02:40'),
(157, 3, 2, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 13:02:42'),
(158, 5, 2, 'wallet_transaction', 'wallet', 12, 'recharge credit: ₹50000.00 - Credited by admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 13:02:59'),
(159, 5, NULL, 'bet_placed', 'bet_slip', 4, 'Bet placed: Game 202511021830, Amount: 1750, Cards: 12, Slip ID: f76365fc-20e4-45d0-868d-309d8fa63d19', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 13:03:05'),
(160, NULL, 1, 'game_settled', 'game', 54, 'Game 202511021830 settled. Winning card: 8. Winning slips: 1, Losing slips: 0, Total payout: 1500', NULL, NULL, '2025-11-02 13:05:08'),
(161, NULL, 1, 'game_settled', 'game', 55, 'Game 202511021835 settled. Winning card: 10. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 13:10:09'),
(162, NULL, 1, 'game_settled', 'game', 56, 'Game 202511021840 settled. Winning card: 12. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 13:15:05'),
(163, NULL, 1, 'game_settled', 'game', 57, 'Game 202511021845 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 13:20:07'),
(164, NULL, 1, 'game_settled', 'game', 58, 'Game 202511021850 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 13:25:07'),
(165, NULL, 1, 'game_settled', 'game', 59, 'Game 202511021855 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 13:30:08'),
(166, NULL, 1, 'game_settled', 'game', 60, 'Game 202511021900 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 13:35:08'),
(167, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 13:42:19'),
(168, 2, 3, 'kill_sessions', 'User', 2, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 13:42:24'),
(169, NULL, 3, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_result_type\":\"manual\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 13:42:50'),
(170, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:03:39'),
(171, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:03:42'),
(172, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:03:44'),
(173, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:03:45'),
(174, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:03:48'),
(175, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:03:50'),
(176, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:08:55'),
(177, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:30:23'),
(178, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 14:30:24'),
(179, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 14:59:39'),
(180, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 10 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 14:59:44'),
(181, 3, 4, 'kill_sessions', 'User', 3, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 14:59:46'),
(182, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 15:04:32'),
(183, 5, NULL, 'bet_placed', 'bet_slip', 5, 'Bet placed: Game 202511022035, Amount: 1750, Cards: 12, Slip ID: 5186b4d7-8c7d-46e7-befc-0aa7ff078c8c', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 15:05:15'),
(184, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_result_type\":\"auto\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 15:05:26'),
(185, NULL, 1, 'game_settled', 'game', 77, 'Game 202511022030 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:05:29'),
(186, NULL, 1, 'game_settled', 'game', 78, 'Game 202511022035 settled. Winning card: 11. Winning slips: 1, Losing slips: 0, Total payout: 1500', NULL, NULL, '2025-11-02 15:10:09'),
(187, NULL, 1, 'game_settled', 'game', 79, 'Game 202511022040 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:15:10'),
(188, NULL, 1, 'game_settled', 'game', 80, 'Game 202511022045 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:20:10'),
(189, NULL, 1, 'game_settled', 'game', 81, 'Game 202511022050 settled. Winning card: 10. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:25:10'),
(190, NULL, 1, 'game_settled', 'game', 82, 'Game 202511022055 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:30:10'),
(191, NULL, 1, 'game_settled', 'game', 83, 'Game 202511022100 settled. Winning card: 10. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:35:10'),
(192, NULL, 1, 'game_settled', 'game', 84, 'Game 202511022105 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:40:11'),
(193, NULL, 1, 'game_settled', 'game', 85, 'Game 202511022110 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:45:14'),
(194, NULL, 1, 'game_settled', 'game', 86, 'Game 202511022115 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:50:11'),
(195, NULL, 1, 'game_settled', 'game', 87, 'Game 202511022120 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 15:55:11'),
(196, NULL, 1, 'game_settled', 'game', 88, 'Game 202511022125 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 16:00:11'),
(197, NULL, 1, 'game_settled', 'game', 89, 'Game 202511022130 settled. Winning card: 10. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 16:05:12'),
(198, NULL, 1, 'game_settled', 'game', 90, 'Game 202511022135 settled. Winning card: 5. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 16:10:12'),
(199, NULL, 1, 'game_settled', 'game', 91, 'Game 202511022140 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 16:15:12'),
(200, NULL, 1, 'game_settled', 'game', 92, 'Game 202511022145 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 16:20:12'),
(201, NULL, 1, 'game_settled', 'game', 93, 'Game 202511022150 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 16:25:12'),
(202, NULL, 1, 'game_settled', 'game', 94, 'Game 202511022155 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 16:30:13'),
(203, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 17:09:41'),
(204, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_end_time\":\"23:55\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 17:10:13'),
(205, NULL, 1, 'game_settled', 'game', 95, 'Game 202511022245 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 17:20:10'),
(206, NULL, 1, 'game_settled', 'game', 96, 'Game 202511022250 settled. Winning card: 11. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 17:25:14'),
(207, NULL, 1, 'game_settled', 'game', 97, 'Game 202511022255 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 17:30:12'),
(208, 4, NULL, 'user_logout', NULL, NULL, 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 17:31:40'),
(209, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 17:31:57'),
(210, NULL, 1, 'game_settled', 'game', 98, 'Game 202511022300 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 17:35:12'),
(211, NULL, 1, 'game_settled', 'game', 99, 'Game 202511022305 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 17:40:13'),
(212, NULL, 1, 'game_settled', 'game', 100, 'Game 202511022310 settled. Winning card: 10. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 17:45:13'),
(213, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:32:25'),
(214, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:32:31'),
(215, 4, NULL, 'user_logout', NULL, NULL, 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:32:39'),
(216, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:32:49'),
(217, 4, NULL, 'user_logout', NULL, NULL, 'User logged out', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:32:56'),
(218, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:33:05'),
(219, 4, 4, 'kill_sessions', 'User', 4, 'Revoked 3 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:33:09'),
(220, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_result_type\":\"manual\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:37:42'),
(221, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 20:02:25'),
(222, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:03:00'),
(223, 5, 4, 'wallet_transaction', 'wallet', 15, 'recharge credit: ₹350.00 - Credited by admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:03:48'),
(224, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 20:11:10'),
(225, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:11:23'),
(226, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 20:11:54'),
(227, 3, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 20:12:35'),
(228, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_start_time\":\"01:00\",\"game_end_time\":\"22:00\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:13:38'),
(229, 5, NULL, 'bet_placed', 'bet_slip', 6, 'Bet placed: Game 202511030145, Amount: 1750, Cards: 12, Slip ID: dc3ea382-455d-4dec-912f-9c6bb7a1b858', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 20:15:40'),
(230, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:20:42'),
(231, NULL, 4, 'game_settled', 'game', 102, 'Game 202511030145 settled. Winning card: 1. Winning slips: 1, Losing slips: 0, Total payout: 1000', NULL, NULL, '2025-11-02 20:25:55'),
(232, NULL, 4, 'game_settled', 'game', 103, 'Game 202511030150 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 20:26:08'),
(233, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_result_type\":\"auto\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:27:14'),
(234, NULL, 1, 'game_settled', 'game', 104, 'Game 202511030155 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 20:30:10'),
(235, NULL, 1, 'game_settled', 'game', 105, 'Game 202511030200 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 20:35:10'),
(236, NULL, 1, 'game_settled', 'game', 106, 'Game 202511030205 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 20:40:10'),
(237, NULL, 1, 'game_settled', 'game', 107, 'Game 202511030210 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 20:45:11'),
(238, NULL, 1, 'game_settled', 'game', 108, 'Game 202511030215 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 20:50:11'),
(239, NULL, 1, 'game_settled', 'game', 109, 'Game 202511030220 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 20:55:11'),
(240, NULL, 1, 'game_settled', 'game', 111, 'Game 202511030225 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 21:00:11'),
(241, NULL, 1, 'game_settled', 'game', 121, 'Game 202511030230 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 21:05:08'),
(242, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_result_type\":\"manual\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 21:09:02'),
(243, NULL, 1, 'game_settled', 'game', 122, 'Game 202511030235 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 21:10:16'),
(244, NULL, 1, 'game_settled', 'game', 123, 'Game 202511030240 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 21:15:16'),
(245, NULL, 1, 'game_settled', 'game', 124, 'Game 202511030245 settled. Winning card: 5. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 21:20:16'),
(246, NULL, 4, 'game_settled', 'game', 125, 'Game 202511030250 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 21:21:43'),
(247, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 21:22:16'),
(248, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 21:22:19');
INSERT INTO `audit_logs` (`id`, `user_id`, `admin_id`, `action`, `target_type`, `target_id`, `details`, `ip_address`, `user_agent`, `created_at`) VALUES
(249, 5, NULL, 'bet_placed', 'bet_slip', 7, 'Bet placed: Game 202511030255, Amount: 1750, Cards: 12, Slip ID: dadd1175-453b-4d1e-8305-048274ed945f', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 21:26:04'),
(250, NULL, 4, 'game_settled', 'game', 126, 'Game 202511030255 settled. Winning card: 1. Winning slips: 1, Losing slips: 0, Total payout: 1000', NULL, NULL, '2025-11-02 21:26:15'),
(251, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 22:35:52'),
(252, NULL, 1, 'game_settled', 'game', 128, 'Game 202511030410 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 22:45:36'),
(253, NULL, 1, 'game_settled', 'game', 129, 'Game 202511030415 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 22:50:10'),
(254, NULL, 1, 'game_settled', 'game', 130, 'Game 202511030420 settled. Winning card: 10. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 22:55:10'),
(255, NULL, 1, 'game_settled', 'game', 131, 'Game 202511030425 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 23:00:18'),
(256, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 23:03:31'),
(257, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 23:03:34'),
(258, 5, NULL, 'bet_placed', 'bet_slip', 8, 'Bet placed: Game 202511030430, Amount: 300, Cards: 3, Slip ID: a48bcf1b-ea7e-4cfa-bd33-c240a450d833', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 23:03:50'),
(259, 5, NULL, 'bet_placed', 'bet_slip', 9, 'Bet placed: Game 202511030430, Amount: 100, Cards: 1, Slip ID: 160dc182-5b9a-4608-b90a-e1594da13b62', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 23:04:28'),
(260, 5, NULL, 'bet_placed', 'bet_slip', 10, 'Bet placed: Game 202511030430, Amount: 300, Cards: 3, Slip ID: 0c451954-255c-4d6f-88a7-1a25f3cba7b3', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 23:04:36'),
(261, NULL, 1, 'game_settled', 'game', 132, 'Game 202511030430 settled. Winning card: 10. Winning slips: 0, Losing slips: 3, Total payout: 0', NULL, NULL, '2025-11-02 23:05:18'),
(262, 5, NULL, 'bet_placed', 'bet_slip', 11, 'Bet placed: Game 202511030435, Amount: 250, Cards: 2, Slip ID: 0331908e-033e-4b9d-bbf0-75c9fe6fad49', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 23:06:49'),
(263, NULL, 1, 'game_settled', 'game', 133, 'Game 202511030435 settled. Winning card: 2. Winning slips: 0, Losing slips: 1, Total payout: 0', NULL, NULL, '2025-11-02 23:10:18'),
(264, NULL, 1, 'game_settled', 'game', 134, 'Game 202511030440 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 23:15:15'),
(265, NULL, 1, 'game_settled', 'game', 135, 'Game 202511030445 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 23:20:16'),
(266, NULL, 1, 'game_settled', 'game', 136, 'Game 202511030450 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 23:25:16'),
(267, NULL, 4, 'game_settled', 'game', 127, 'Game 202511030300 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 23:28:06'),
(268, NULL, 1, 'game_settled', 'game', 137, 'Game 202511030455 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 23:30:16'),
(269, NULL, 1, 'game_settled', 'game', 138, 'Game 202511030500 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 23:35:16'),
(270, 5, NULL, 'winnings_claimed', 'bet_slip', 6, 'Winnings claimed: Slip dc3ea382-455d-4dec-912f-9c6bb7a1b858, Amount: 1000, Game: 202511030145', '::1', 'PostmanRuntime/7.49.1', '2025-11-02 23:35:49'),
(271, NULL, 1, 'game_settled', 'game', 139, 'Game 202511030505 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-02 23:40:18'),
(272, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-03 06:13:18'),
(273, NULL, 4, 'settings_updated', 'settings', NULL, 'Updated settings: {\"game_start_time\":\"08:00\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-03 06:13:52'),
(274, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-03 06:16:38'),
(275, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 06:17:41'),
(277, 5, NULL, 'bet_placed', 'bet_slip', 13, 'Bet placed: Game 202511031145, Amount: 300, Cards: 3, Slip ID: 4c1c41d8-adf5-4955-80ce-0f2815e5567b', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 06:19:53'),
(278, NULL, 1, 'game_settled', 'game', 141, 'Game 202511031145 settled. Winning card: 9. Winning slips: 0, Losing slips: 1, Total payout: 0', NULL, NULL, '2025-11-03 06:20:17'),
(279, NULL, 1, 'game_settled', 'game', 142, 'Game 202511031150 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 06:25:17'),
(280, NULL, 1, 'game_settled', 'game', 143, 'Game 202511031155 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 06:30:17'),
(281, NULL, 1, 'game_settled', 'game', 144, 'Game 202511031200 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 06:35:10'),
(282, NULL, 1, 'game_settled', 'game', 145, 'Game 202511031205 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 06:40:17'),
(283, 5, NULL, 'bet_placed', 'bet_slip', 14, 'Bet placed: Game 202511031210, Amount: 300, Cards: 3, Slip ID: 0b8b6f1f-aa32-4d5e-b9f5-6ab1620f5877', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 06:44:42'),
(284, NULL, 1, 'game_settled', 'game', 146, 'Game 202511031210 settled. Winning card: 3. Winning slips: 0, Losing slips: 1, Total payout: 0', NULL, NULL, '2025-11-03 06:45:17'),
(285, 5, NULL, 'bet_placed', 'bet_slip', 15, 'Bet placed: Game 202511031215, Amount: 580, Cards: 12, Slip ID: 828681db-bc6a-4f81-adf6-aae486855346', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 06:49:50'),
(286, NULL, 1, 'game_settled', 'game', 147, 'Game 202511031215 settled. Winning card: 4. Winning slips: 1, Losing slips: 0, Total payout: 400', NULL, NULL, '2025-11-03 06:50:15'),
(287, 5, NULL, 'winnings_claimed', 'bet_slip', 15, 'Winnings claimed: Slip 828681db-bc6a-4f81-adf6-aae486855346, Amount: 400, Game: 202511031215', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 06:50:19'),
(288, 5, NULL, 'bet_placed', 'bet_slip', 16, 'Bet placed: Game 202511031220, Amount: 580, Cards: 12, Slip ID: 2724fbf3-eb59-4587-8347-e37521a3fb24', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 06:53:59'),
(289, 5, NULL, 'slip_cancelled', 'bet_slip', 16, 'Slip cancelled: 2724fbf3-eb59-4587-8347-e37521a3fb24 (GAME_202511031220_2724FBF3_60), Game: 202511031220, Refund: ₹580.00, Reason: Change of mind, Cancelled by: User', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 06:54:43'),
(290, NULL, 1, 'game_settled', 'game', 148, 'Game 202511031220 settled. Winning card: 1. Winning slips: 1, Losing slips: 0, Total payout: 100', NULL, NULL, '2025-11-03 06:55:15'),
(291, 5, NULL, 'winnings_claimed', 'bet_slip', 16, 'Winnings claimed: Slip 2724fbf3-eb59-4587-8347-e37521a3fb24, Amount: 100, Game: 202511031220', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 06:55:22'),
(292, 5, NULL, 'bet_placed', 'bet_slip', 17, 'Bet placed: Game 202511031235, Amount: 580, Cards: 12, Slip ID: f37c410f-4776-4de7-9111-f46f5baec571', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:05:15'),
(293, 5, NULL, 'slip_cancelled', 'bet_slip', 17, 'Slip cancelled: f37c410f-4776-4de7-9111-f46f5baec571 (GAME_202511031235_F37C410F_27), Game: 202511031235, Refund: ₹580.00, Reason: Change of mind, Cancelled by: User', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:05:25'),
(294, 5, NULL, 'bet_placed', 'bet_slip', 18, 'Bet placed: Game 202511031235, Amount: 580, Cards: 12, Slip ID: 5c52ec5f-db7a-468c-add6-5430dfeccf97', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:09:41'),
(295, 5, NULL, 'slip_cancelled', 'bet_slip', 18, 'Slip cancelled: 5c52ec5f-db7a-468c-add6-5430dfeccf97 (GAME_202511031235_5C52EC5F_7B), Game: 202511031235, Refund: ₹580.00, Reason: Change of mind, Cancelled by: User', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:09:54'),
(296, NULL, 1, 'game_settled', 'game', 150, 'Game 202511031235 settled. Winning card: 2. Winning slips: 0, Losing slips: 2, Total payout: 0', NULL, NULL, '2025-11-03 07:10:17'),
(297, NULL, 1, 'game_settled', 'game', 151, 'Game 202511031240 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 07:15:11'),
(298, NULL, 1, 'game_settled', 'game', 152, 'Game 202511031245 settled. Winning card: 4. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 07:20:11'),
(299, NULL, 1, 'game_settled', 'game', 153, 'Game 202511031250 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 07:25:11'),
(300, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-03 07:29:30'),
(301, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-03 07:29:37'),
(302, NULL, 1, 'game_settled', 'game', 154, 'Game 202511031255 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 07:30:15'),
(303, 6, 4, 'wallet_transaction', 'wallet', 35, 'recharge credit: ₹50000.00 - Credited by admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-03 07:30:31'),
(304, 5, 4, 'kill_sessions', 'User', 5, 'Revoked 1 active refresh tokens', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-03 07:33:50'),
(305, 5, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:33:54'),
(306, 5, NULL, 'bet_placed', 'bet_slip', 19, 'Bet placed: Game 202511031300, Amount: 580, Cards: 12, Slip ID: 3fdc2ee8-0cd3-4e89-983a-8c995ed7887d', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:34:00'),
(307, 5, NULL, 'bet_placed', 'bet_slip', 20, 'Bet placed: Game 202511031300, Amount: 580, Cards: 12, Slip ID: f0fef7e7-c1b5-444e-8337-7aa9b5bfa0ec', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:34:34'),
(308, NULL, 4, 'game_settled', 'game', 155, 'Game 202511031300 settled. Winning card: 12. Winning slips: 2, Losing slips: 0, Total payout: 400', NULL, NULL, '2025-11-03 07:35:15'),
(309, 5, NULL, 'winnings_claimed', 'bet_slip', 20, 'Winnings claimed: Slip f0fef7e7-c1b5-444e-8337-7aa9b5bfa0ec, Amount: 200, Game: 202511031300', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:35:40'),
(310, 5, NULL, 'bet_placed', 'bet_slip', 21, 'Bet placed: Game 202511031305, Amount: 580, Cards: 12, Slip ID: d149b0b2-2af4-421e-95ec-f12904b9822a', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:36:01'),
(311, 5, NULL, 'bet_placed', 'bet_slip', 22, 'Bet placed: Game 202511031305, Amount: 580, Cards: 12, Slip ID: 6a9ffffd-926e-4995-8641-3f69e8d66ba9', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:36:51'),
(312, 5, NULL, 'slip_cancelled', 'bet_slip', 22, 'Slip cancelled: 6a9ffffd-926e-4995-8641-3f69e8d66ba9 (GAME_202511031305_6A9FFFFD_8B), Game: 202511031305, Refund: ₹580.00, Reason: Change of mind, Cancelled by: User', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 07:37:01'),
(313, NULL, 1, 'game_settled', 'game', 156, 'Game 202511031305 settled. Winning card: 11. Winning slips: 1, Losing slips: 1, Total payout: 100', NULL, NULL, '2025-11-03 07:40:16'),
(314, NULL, 1, 'game_settled', 'game', 157, 'Game 202511031310 settled. Winning card: 12. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 07:45:16'),
(315, NULL, 1, 'game_settled', 'game', 158, 'Game 202511031315 settled. Winning card: 9. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 07:50:16'),
(316, NULL, 1, 'game_settled', 'game', 159, 'Game 202511031320 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 07:55:12'),
(317, NULL, 1, 'game_settled', 'game', 160, 'Game 202511031325 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:00:12'),
(318, NULL, 1, 'game_settled', 'game', 161, 'Game 202511031330 settled. Winning card: 10. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:05:12'),
(319, NULL, 1, 'game_settled', 'game', 162, 'Game 202511031335 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:10:13'),
(320, NULL, 1, 'game_settled', 'game', 163, 'Game 202511031340 settled. Winning card: 8. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:15:18'),
(321, 4, NULL, 'user_login', NULL, NULL, 'User logged in from ::1', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-03 08:15:20'),
(322, NULL, 4, 'game_settled', 'game', 149, 'Game 202511031225 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:15:33'),
(323, NULL, 4, 'game_settled', 'game', 140, 'Game 202511030510 settled. Winning card: 3. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:15:40'),
(324, NULL, 4, 'game_settled', 'game', 101, 'Game 202511022315 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:15:43'),
(325, NULL, 4, 'game_settled', 'game', 76, 'Game 202511022025 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:15:47'),
(326, NULL, 4, 'game_settled', 'game', 75, 'Game 202511022020 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:15:51'),
(327, NULL, 4, 'game_settled', 'game', 74, 'Game 202511022015 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:15:55'),
(328, NULL, 4, 'game_settled', 'game', 73, 'Game 202511022010 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:15:58'),
(329, NULL, 4, 'game_settled', 'game', 72, 'Game 202511022005 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:00'),
(330, NULL, 4, 'game_settled', 'game', 71, 'Game 202511022000 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:03'),
(331, NULL, 4, 'game_settled', 'game', 70, 'Game 202511021955 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:05'),
(332, NULL, 4, 'game_settled', 'game', 69, 'Game 202511021950 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:08'),
(333, NULL, 4, 'game_settled', 'game', 68, 'Game 202511021945 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:10'),
(334, NULL, 4, 'game_settled', 'game', 67, 'Game 202511021940 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:12'),
(335, NULL, 4, 'game_settled', 'game', 66, 'Game 202511021935 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:14'),
(336, NULL, 4, 'game_settled', 'game', 65, 'Game 202511021930 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:16'),
(337, NULL, 4, 'game_settled', 'game', 64, 'Game 202511021925 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:18'),
(338, NULL, 4, 'game_settled', 'game', 63, 'Game 202511021920 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:25'),
(339, NULL, 4, 'game_settled', 'game', 62, 'Game 202511021915 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:28'),
(340, NULL, 4, 'game_settled', 'game', 61, 'Game 202511021905 settled. Winning card: 2. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:16:31'),
(341, NULL, 4, 'game_settled', 'game', 34, 'Game 202511021650 settled. Winning card: 1. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:17:14'),
(342, NULL, 1, 'game_settled', 'game', 164, 'Game 202511031345 settled. Winning card: 6. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:20:18'),
(343, 5, NULL, 'bet_placed', 'bet_slip', 23, 'Bet placed: Game 202511031350, Amount: 580, Cards: 12, Slip ID: 8873e639-655c-4fd4-a9cd-d1002cbe03e7', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 08:24:07'),
(344, NULL, 4, 'game_settled', 'game', 165, 'Game 202511031350 settled. Winning card: 1. Winning slips: 1, Losing slips: 0, Total payout: 100', NULL, NULL, '2025-11-03 08:25:05'),
(345, 5, NULL, 'winnings_claimed', 'bet_slip', 23, 'Winnings claimed: Slip 8873e639-655c-4fd4-a9cd-d1002cbe03e7, Amount: 100, Game: 202511031350', '::1', 'PostmanRuntime/7.49.1', '2025-11-03 08:25:45'),
(346, NULL, 1, 'game_settled', 'game', 166, 'Game 202511031355 settled. Winning card: 7. Winning slips: 0, Losing slips: 0, Total payout: 0', NULL, NULL, '2025-11-03 08:30:19');

-- --------------------------------------------------------

--
-- Table structure for table `bet_details`
--

CREATE TABLE `bet_details` (
  `id` bigint(20) NOT NULL,
  `slip_id` bigint(20) NOT NULL,
  `card_number` tinyint(4) NOT NULL COMMENT 'Card number the user bet on (1-12)',
  `bet_amount` decimal(18,2) NOT NULL COMMENT 'Amount bet on this card',
  `is_winner` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'True if this bet won',
  `payout_amount` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT 'Amount won (0 if lost)',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `game_id` varchar(50) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `bet_details`
--

INSERT INTO `bet_details` (`id`, `slip_id`, `card_number`, `bet_amount`, `is_winner`, `payout_amount`, `created_at`, `game_id`, `user_id`, `updated_at`) VALUES
(1, 1, 5, 100.00, 0, 0.00, '2025-11-02 14:11:59', '202511021410', 5, '2025-11-02 14:11:59'),
(2, 1, 7, 150.00, 0, 0.00, '2025-11-02 14:11:59', '202511021410', 5, '2025-11-02 14:11:59'),
(3, 2, 5, 100.00, 0, 0.00, '2025-11-02 15:17:20', '202511021515', 5, '2025-11-02 15:17:20'),
(4, 2, 7, 150.00, 0, 0.00, '2025-11-02 15:17:20', '202511021515', 5, '2025-11-02 15:17:20'),
(5, 3, 5, 100.00, 0, 0.00, '2025-11-02 15:17:30', '202511021515', 5, '2025-11-02 15:17:30'),
(6, 3, 7, 150.00, 0, 0.00, '2025-11-02 15:17:30', '202511021515', 5, '2025-11-02 15:17:30'),
(7, 4, 1, 100.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(8, 4, 2, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(9, 4, 3, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(10, 4, 4, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(11, 4, 5, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(12, 4, 6, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(13, 4, 7, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(14, 4, 8, 150.00, 1, 1500.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 13:05:08'),
(15, 4, 9, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(16, 4, 10, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(17, 4, 11, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(18, 4, 12, 150.00, 0, 0.00, '2025-11-02 18:33:05', '202511021830', 5, '2025-11-02 18:33:05'),
(19, 5, 1, 100.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(20, 5, 2, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(21, 5, 3, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(22, 5, 4, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(23, 5, 5, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(24, 5, 6, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(25, 5, 7, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(26, 5, 8, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(27, 5, 9, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(28, 5, 10, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(29, 5, 11, 150.00, 1, 1500.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 15:10:09'),
(30, 5, 12, 150.00, 0, 0.00, '2025-11-02 20:35:15', '202511022035', 5, '2025-11-02 20:35:15'),
(31, 6, 1, 100.00, 1, 1000.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-02 20:25:55'),
(32, 6, 2, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(33, 6, 3, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(34, 6, 4, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(35, 6, 5, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(36, 6, 6, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(37, 6, 7, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(38, 6, 8, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(39, 6, 9, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(40, 6, 10, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(41, 6, 11, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(42, 6, 12, 150.00, 0, 0.00, '2025-11-03 01:45:40', '202511030145', 5, '2025-11-03 01:45:40'),
(43, 7, 1, 100.00, 1, 1000.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-02 21:26:15'),
(44, 7, 2, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(45, 7, 3, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(46, 7, 4, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(47, 7, 5, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(48, 7, 6, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(49, 7, 7, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(50, 7, 8, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(51, 7, 9, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(52, 7, 10, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(53, 7, 11, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(54, 7, 12, 150.00, 0, 0.00, '2025-11-03 02:56:04', '202511030255', 5, '2025-11-03 02:56:04'),
(55, 8, 5, 100.00, 0, 0.00, '2025-11-03 04:33:50', '202511030430', 5, '2025-11-03 04:33:50'),
(56, 8, 7, 150.00, 0, 0.00, '2025-11-03 04:33:50', '202511030430', 5, '2025-11-03 04:33:50'),
(57, 8, 12, 50.00, 0, 0.00, '2025-11-03 04:33:50', '202511030430', 5, '2025-11-03 04:33:50'),
(58, 9, 1, 100.00, 0, 0.00, '2025-11-03 04:34:28', '202511030430', 5, '2025-11-03 04:34:28'),
(59, 10, 5, 100.00, 0, 0.00, '2025-11-03 04:34:35', '202511030430', 5, '2025-11-03 04:34:35'),
(60, 10, 7, 150.00, 0, 0.00, '2025-11-03 04:34:35', '202511030430', 5, '2025-11-03 04:34:35'),
(61, 10, 12, 50.00, 0, 0.00, '2025-11-03 04:34:35', '202511030430', 5, '2025-11-03 04:34:35'),
(62, 11, 5, 100.00, 0, 0.00, '2025-11-03 04:36:49', '202511030435', 5, '2025-11-03 04:36:49'),
(63, 11, 7, 150.00, 0, 0.00, '2025-11-03 04:36:49', '202511030435', 5, '2025-11-03 04:36:49'),
(67, 13, 5, 100.00, 0, 0.00, '2025-11-03 11:49:53', '202511031145', 5, '2025-11-03 11:49:53'),
(68, 13, 7, 150.00, 0, 0.00, '2025-11-03 11:49:53', '202511031145', 5, '2025-11-03 11:49:53'),
(69, 13, 12, 50.00, 0, 0.00, '2025-11-03 11:49:53', '202511031145', 5, '2025-11-03 11:49:53'),
(70, 14, 5, 100.00, 0, 0.00, '2025-11-03 12:14:42', '202511031210', 5, '2025-11-03 12:14:42'),
(71, 14, 7, 150.00, 0, 0.00, '2025-11-03 12:14:42', '202511031210', 5, '2025-11-03 12:14:42'),
(72, 14, 12, 50.00, 0, 0.00, '2025-11-03 12:14:42', '202511031210', 5, '2025-11-03 12:14:42'),
(73, 15, 1, 10.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(74, 15, 2, 20.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(75, 15, 3, 30.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(76, 15, 4, 40.00, 1, 400.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 06:50:15'),
(77, 15, 5, 50.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(78, 15, 6, 60.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(79, 15, 7, 70.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(80, 15, 8, 80.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(81, 15, 9, 90.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(82, 15, 10, 100.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(83, 15, 11, 10.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(84, 15, 12, 20.00, 0, 0.00, '2025-11-03 12:19:50', '202511031215', 5, '2025-11-03 12:19:50'),
(85, 16, 1, 10.00, 1, 100.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 06:55:15'),
(86, 16, 2, 20.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(87, 16, 3, 30.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(88, 16, 4, 40.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(89, 16, 5, 50.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(90, 16, 6, 60.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(91, 16, 7, 70.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(92, 16, 8, 80.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(93, 16, 9, 90.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(94, 16, 10, 100.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(95, 16, 11, 10.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(96, 16, 12, 20.00, 0, 0.00, '2025-11-03 12:23:59', '202511031220', 5, '2025-11-03 12:23:59'),
(97, 17, 1, 10.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(98, 17, 2, 20.00, 1, 200.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 07:10:17'),
(99, 17, 3, 30.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(100, 17, 4, 40.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(101, 17, 5, 50.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(102, 17, 6, 60.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(103, 17, 7, 70.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(104, 17, 8, 80.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(105, 17, 9, 90.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(106, 17, 10, 100.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(107, 17, 11, 10.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(108, 17, 12, 20.00, 0, 0.00, '2025-11-03 12:35:15', '202511031235', 5, '2025-11-03 12:35:15'),
(109, 18, 1, 10.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(110, 18, 2, 20.00, 1, 200.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 07:10:17'),
(111, 18, 3, 30.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(112, 18, 4, 40.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(113, 18, 5, 50.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(114, 18, 6, 60.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(115, 18, 7, 70.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(116, 18, 8, 80.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(117, 18, 9, 90.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(118, 18, 10, 100.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(119, 18, 11, 10.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(120, 18, 12, 20.00, 0, 0.00, '2025-11-03 12:39:41', '202511031235', 5, '2025-11-03 12:39:41'),
(121, 19, 1, 10.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(122, 19, 2, 20.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(123, 19, 3, 30.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(124, 19, 4, 40.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(125, 19, 5, 50.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(126, 19, 6, 60.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(127, 19, 7, 70.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(128, 19, 8, 80.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(129, 19, 9, 90.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(130, 19, 10, 100.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(131, 19, 11, 10.00, 0, 0.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 13:04:00'),
(132, 19, 12, 20.00, 1, 200.00, '2025-11-03 13:04:00', '202511031300', 5, '2025-11-03 07:35:15'),
(133, 20, 1, 10.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(134, 20, 2, 20.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(135, 20, 3, 30.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(136, 20, 4, 40.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(137, 20, 5, 50.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(138, 20, 6, 60.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(139, 20, 7, 70.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(140, 20, 8, 80.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(141, 20, 9, 90.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(142, 20, 10, 100.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(143, 20, 11, 10.00, 0, 0.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 13:04:34'),
(144, 20, 12, 20.00, 1, 200.00, '2025-11-03 13:04:34', '202511031300', 5, '2025-11-03 07:35:15'),
(145, 21, 1, 10.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(146, 21, 2, 20.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(147, 21, 3, 30.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(148, 21, 4, 40.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(149, 21, 5, 50.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(150, 21, 6, 60.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(151, 21, 7, 70.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(152, 21, 8, 80.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(153, 21, 9, 90.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(154, 21, 10, 100.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(155, 21, 11, 10.00, 1, 100.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 07:40:16'),
(156, 21, 12, 20.00, 0, 0.00, '2025-11-03 13:06:01', '202511031305', 5, '2025-11-03 13:06:01'),
(157, 22, 1, 10.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(158, 22, 2, 20.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(159, 22, 3, 30.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(160, 22, 4, 40.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(161, 22, 5, 50.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(162, 22, 6, 60.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(163, 22, 7, 70.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(164, 22, 8, 80.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(165, 22, 9, 90.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(166, 22, 10, 100.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(167, 22, 11, 10.00, 1, 100.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 07:40:16'),
(168, 22, 12, 20.00, 0, 0.00, '2025-11-03 13:06:50', '202511031305', 5, '2025-11-03 13:06:50'),
(169, 23, 1, 10.00, 1, 100.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 08:25:05'),
(170, 23, 2, 20.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(171, 23, 3, 30.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(172, 23, 4, 40.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(173, 23, 5, 50.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(174, 23, 6, 60.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(175, 23, 7, 70.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(176, 23, 8, 80.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(177, 23, 9, 90.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(178, 23, 10, 100.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(179, 23, 11, 10.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07'),
(180, 23, 12, 20.00, 0, 0.00, '2025-11-03 13:54:07', '202511031350', 5, '2025-11-03 13:54:07');

-- --------------------------------------------------------

--
-- Table structure for table `bet_slips`
--

CREATE TABLE `bet_slips` (
  `id` bigint(20) NOT NULL,
  `slip_id` varchar(36) NOT NULL COMMENT 'UUID v4',
  `user_id` int(11) NOT NULL,
  `game_id` varchar(50) NOT NULL,
  `total_amount` decimal(18,2) NOT NULL COMMENT 'Sum of all bets in this slip',
  `barcode` varchar(255) NOT NULL COMMENT 'Barcode for slip verification',
  `payout_amount` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT 'Sum of winnings for this slip',
  `status` enum('pending','won','lost','settled') NOT NULL DEFAULT 'pending' COMMENT 'Indicates payout status',
  `claimed` tinyint(4) NOT NULL DEFAULT 0,
  `claimed_at` datetime DEFAULT NULL,
  `idempotency_key` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `bet_slips`
--

INSERT INTO `bet_slips` (`id`, `slip_id`, `user_id`, `game_id`, `total_amount`, `barcode`, `payout_amount`, `status`, `claimed`, `claimed_at`, `idempotency_key`, `created_at`, `updated_at`) VALUES
(1, '4ef83c66-f387-4931-928d-69ac9045ee59', 5, '202511021410', 250.00, 'GAME_202511021410_4EF83C66_55', 0.00, 'lost', 0, NULL, 'bet-271240b4-3852-4204-ac2b-70aed686ec85', '2025-11-02 14:11:59', '2025-11-02 09:49:00'),
(2, '128c3cf6-4ba7-4c2d-8f02-bde3eba584ed', 5, '202511021515', 250.00, 'GAME_202511021515_128C3CF6_E5', 0.00, 'lost', 0, NULL, 'bet-3de50500-99b3-4913-909d-1ad24dcb463c', '2025-11-02 15:17:20', '2025-11-02 09:51:00'),
(3, 'd73a84af-c050-45f7-9c12-0fbac39ee93d', 5, '202511021515', 250.00, 'GAME_202511021515_D73A84AF_13', 0.00, 'lost', 0, NULL, 'bet-b532f14e-9ada-4a8b-9f81-93c8759bc9f1', '2025-11-02 15:17:30', '2025-11-02 09:51:00'),
(4, 'f76365fc-20e4-45d0-868d-309d8fa63d19', 5, '202511021830', 1750.00, 'GAME_202511021830_F76365FC_87', 1500.00, 'won', 0, NULL, 'bet-c8a44aea-b945-491b-972d-6b7aac98d3c9', '2025-11-02 18:33:05', '2025-11-02 13:05:08'),
(5, '5186b4d7-8c7d-46e7-befc-0aa7ff078c8c', 5, '202511022035', 1750.00, 'GAME_202511022035_5186B4D7_95', 1500.00, 'won', 0, NULL, 'bet-bba9b02e-fc09-4666-9669-bf8f7cb89861', '2025-11-02 20:35:15', '2025-11-02 15:10:09'),
(6, 'dc3ea382-455d-4dec-912f-9c6bb7a1b858', 5, '202511030145', 1750.00, 'GAME_202511030145_DC3EA382_1D', 1000.00, 'won', 1, '2025-11-03 05:05:49', 'bet-562f8cd0-b944-4a75-afb8-9f7b145b0d5b', '2025-11-03 01:45:40', '2025-11-02 23:35:49'),
(7, 'dadd1175-453b-4d1e-8305-048274ed945f', 5, '202511030255', 1750.00, 'GAME_202511030255_DADD1175_46', 1000.00, 'won', 0, NULL, 'bet-362e4c09-d9e4-4c08-b417-abafdef3e27b', '2025-11-03 02:56:04', '2025-11-02 21:26:15'),
(8, 'a48bcf1b-ea7e-4cfa-bd33-c240a450d833', 5, '202511030430', 300.00, 'GAME_202511030430_A48BCF1B_0C', 0.00, 'lost', 0, NULL, 'bet-73a21a9f-a6c9-4f13-a4ac-fd3ce39cdedb', '2025-11-03 04:33:50', '2025-11-02 23:05:18'),
(9, '160dc182-5b9a-4608-b90a-e1594da13b62', 5, '202511030430', 100.00, 'GAME_202511030430_160DC182_C8', 0.00, 'lost', 0, NULL, 'bet-45c1b08d-65d2-44b7-8f85-086fb95b078e', '2025-11-03 04:34:28', '2025-11-02 23:05:18'),
(10, '0c451954-255c-4d6f-88a7-1a25f3cba7b3', 5, '202511030430', 300.00, 'GAME_202511030430_0C451954_48', 0.00, 'lost', 0, NULL, 'bet-570f6f88-1e33-40d0-afd5-d384bc7f8ad3', '2025-11-03 04:34:35', '2025-11-02 23:05:18'),
(11, '0331908e-033e-4b9d-bbf0-75c9fe6fad49', 5, '202511030435', 250.00, 'GAME_202511030435_0331908E_68', 0.00, 'lost', 0, NULL, 'bet-bfc38603-ad97-4c40-aa29-e917787d2f77', '2025-11-03 04:36:49', '2025-11-02 23:10:18'),
(13, '4c1c41d8-adf5-4955-80ce-0f2815e5567b', 5, '202511031145', 300.00, 'GAME_202511031145_4C1C41D8_DD', 0.00, 'lost', 0, NULL, 'bet-da34c574-d86a-447f-a545-3fcdf128cd5c', '2025-11-03 11:49:53', '2025-11-03 06:20:17'),
(14, '0b8b6f1f-aa32-4d5e-b9f5-6ab1620f5877', 5, '202511031210', 300.00, 'GAME_202511031210_0B8B6F1F_F2', 0.00, 'lost', 0, NULL, 'bet-43c1e626-098b-410e-8c86-13d4b1356c9d', '2025-11-03 12:14:42', '2025-11-03 06:45:17'),
(15, '828681db-bc6a-4f81-adf6-aae486855346', 5, '202511031215', 580.00, 'GAME_202511031215_828681DB_26', 400.00, 'won', 1, '2025-11-03 12:20:19', 'bet-d2f66f68-e4d0-4868-af2f-54f692e27467', '2025-11-03 12:19:50', '2025-11-03 06:50:19'),
(16, '2724fbf3-eb59-4587-8347-e37521a3fb24', 5, '202511031220', 580.00, 'GAME_202511031220_2724FBF3_60', 100.00, 'won', 1, '2025-11-03 12:25:22', 'bet-6573d297-bbfb-4c9d-ad61-b4cb3adcac6b', '2025-11-03 12:23:59', '2025-11-03 06:55:22'),
(17, 'f37c410f-4776-4de7-9111-f46f5baec571', 5, '202511031235', 580.00, 'GAME_202511031235_F37C410F_27', 0.00, 'lost', 0, NULL, 'bet-36022906-4b0c-45c5-9aba-3cc932444391', '2025-11-03 12:35:15', '2025-11-03 07:05:25'),
(18, '5c52ec5f-db7a-468c-add6-5430dfeccf97', 5, '202511031235', 580.00, 'GAME_202511031235_5C52EC5F_7B', 0.00, 'lost', 0, NULL, 'bet-b75b2cfb-8731-424d-b573-1e4f8a5fd79a', '2025-11-03 12:39:40', '2025-11-03 07:09:54'),
(19, '3fdc2ee8-0cd3-4e89-983a-8c995ed7887d', 5, '202511031300', 580.00, 'GAME_202511031300_3FDC2EE8_2F', 200.00, 'won', 0, NULL, 'bet-b801032a-b0a8-4bf1-8a5f-38ed904028c3', '2025-11-03 13:04:00', '2025-11-03 07:35:15'),
(20, 'f0fef7e7-c1b5-444e-8337-7aa9b5bfa0ec', 5, '202511031300', 580.00, 'GAME_202511031300_F0FEF7E7_DE', 200.00, 'won', 1, '2025-11-03 13:05:40', 'bet-4f7ec921-6649-4203-b176-8b7291016629', '2025-11-03 13:04:34', '2025-11-03 07:35:40'),
(21, 'd149b0b2-2af4-421e-95ec-f12904b9822a', 5, '202511031305', 580.00, 'GAME_202511031305_D149B0B2_2A', 100.00, 'won', 0, NULL, 'bet-bcebd788-7e9d-49d7-8d57-0414ea4a7f7a', '2025-11-03 13:06:01', '2025-11-03 07:40:16'),
(22, '6a9ffffd-926e-4995-8641-3f69e8d66ba9', 5, '202511031305', 580.00, 'GAME_202511031305_6A9FFFFD_8B', 0.00, 'lost', 0, NULL, 'bet-bbe0764d-ba20-46f7-960e-b68536140c3f', '2025-11-03 13:06:50', '2025-11-03 07:37:01'),
(23, '8873e639-655c-4fd4-a9cd-d1002cbe03e7', 5, '202511031350', 580.00, 'GAME_202511031350_8873E639_9B', 100.00, 'won', 1, '2025-11-03 13:55:45', 'bet-f6fc8ace-5ae2-40bf-a931-7b8b67eb88db', '2025-11-03 13:54:07', '2025-11-03 08:25:45');

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` bigint(20) NOT NULL,
  `game_id` varchar(50) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `status` enum('pending','active','completed') NOT NULL DEFAULT 'pending',
  `winning_card` tinyint(4) DEFAULT NULL COMMENT 'Winning card number (1-12)',
  `payout_multiplier` decimal(5,2) NOT NULL DEFAULT 10.00 COMMENT 'Payout multiplier for winning bets',
  `settlement_status` enum('not_settled','settling','settled','failed') NOT NULL DEFAULT 'not_settled',
  `settlement_started_at` datetime DEFAULT NULL,
  `settlement_completed_at` datetime DEFAULT NULL,
  `settlement_error` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `game_id`, `start_time`, `end_time`, `status`, `winning_card`, `payout_multiplier`, `settlement_status`, `settlement_started_at`, `settlement_completed_at`, `settlement_error`, `created_at`, `updated_at`) VALUES
(1, '202511021405', '2025-11-02 14:05:00', '2025-11-02 14:10:00', 'completed', 2, 11.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:05:00', '2025-11-02 08:40:00'),
(2, '202511021410', '2025-11-02 14:10:00', '2025-11-02 14:15:00', 'completed', 10, 11.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:10:00', '2025-11-02 08:45:00'),
(3, '202511021415', '2025-11-02 14:15:00', '2025-11-02 14:20:00', 'completed', 4, 11.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:15:00', '2025-11-02 08:50:00'),
(4, '202511021420', '2025-11-02 14:20:00', '2025-11-02 14:25:00', 'completed', 2, 11.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:20:00', '2025-11-02 08:55:00'),
(5, '202511021425', '2025-11-02 14:25:00', '2025-11-02 14:30:00', 'completed', 9, 11.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:25:00', '2025-11-02 09:00:00'),
(6, '202511021430', '2025-11-02 14:30:00', '2025-11-02 14:35:00', 'completed', 11, 11.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:30:00', '2025-11-02 09:05:00'),
(7, '202511021435', '2025-11-02 14:35:00', '2025-11-02 14:40:00', 'completed', 9, 11.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:35:00', '2025-11-02 09:10:00'),
(8, '202511021440', '2025-11-02 14:40:00', '2025-11-02 14:45:00', 'completed', 10, 10.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:40:00', '2025-11-02 09:15:00'),
(9, '202511021445', '2025-11-02 14:45:00', '2025-11-02 14:50:00', 'completed', 6, 10.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:45:00', '2025-11-02 09:20:00'),
(10, '202511021450', '2025-11-02 14:50:00', '2025-11-02 14:55:00', 'completed', 9, 10.00, 'settled', '2025-11-02 15:19:00', '2025-11-02 15:19:00', NULL, '2025-11-02 14:50:00', '2025-11-02 09:25:00'),
(11, '202511021455', '2025-11-02 14:55:00', '2025-11-02 15:00:00', 'completed', 6, 10.00, 'settled', '2025-11-02 15:20:00', '2025-11-02 15:20:00', NULL, '2025-11-02 14:55:00', '2025-11-02 09:30:00'),
(12, '202511021500', '2025-11-02 15:00:00', '2025-11-02 15:05:00', 'completed', 6, 10.00, 'settled', '2025-11-02 15:20:00', '2025-11-02 15:20:00', NULL, '2025-11-02 15:00:00', '2025-11-02 09:35:00'),
(13, '202511021505', '2025-11-02 15:05:00', '2025-11-02 15:10:00', 'completed', 11, 10.00, 'settled', '2025-11-02 15:20:00', '2025-11-02 15:20:00', NULL, '2025-11-02 15:05:00', '2025-11-02 09:40:00'),
(14, '202511021510', '2025-11-02 15:10:00', '2025-11-02 15:15:00', 'completed', 12, 10.00, 'settled', '2025-11-02 15:20:00', '2025-11-02 15:20:00', NULL, '2025-11-02 15:10:00', '2025-11-02 09:45:00'),
(15, '202511021515', '2025-11-02 15:15:00', '2025-11-02 15:20:00', 'completed', 9, 10.00, 'settled', '2025-11-02 15:21:00', '2025-11-02 15:21:00', NULL, '2025-11-02 15:15:00', '2025-11-02 09:50:00'),
(16, '202511021520', '2025-11-02 15:20:00', '2025-11-02 15:25:00', 'completed', 11, 10.00, 'settled', '2025-11-02 15:26:00', '2025-11-02 15:26:00', NULL, '2025-11-02 15:20:00', '2025-11-02 09:55:00'),
(17, '202511021525', '2025-11-02 15:25:00', '2025-11-02 15:30:00', 'completed', 6, 10.00, 'settled', '2025-11-02 15:31:00', '2025-11-02 15:31:00', NULL, '2025-11-02 15:25:00', '2025-11-02 10:00:00'),
(18, '202511021530', '2025-11-02 15:30:00', '2025-11-02 15:35:00', 'completed', 6, 10.00, 'settled', '2025-11-02 15:36:00', '2025-11-02 15:36:00', NULL, '2025-11-02 15:30:00', '2025-11-02 10:05:00'),
(19, '202511021535', '2025-11-02 15:35:00', '2025-11-02 15:40:00', 'completed', 4, 10.00, 'settled', '2025-11-02 15:41:00', '2025-11-02 15:41:00', NULL, '2025-11-02 15:35:00', '2025-11-02 10:10:00'),
(20, '202511021540', '2025-11-02 15:40:00', '2025-11-02 15:45:00', 'completed', 6, 10.00, 'settled', '2025-11-02 15:46:00', '2025-11-02 15:46:00', NULL, '2025-11-02 15:40:00', '2025-11-02 10:15:00'),
(21, '202511021545', '2025-11-02 15:45:00', '2025-11-02 15:50:00', 'completed', 5, 10.00, 'settled', '2025-11-02 15:51:00', '2025-11-02 15:51:00', NULL, '2025-11-02 15:45:00', '2025-11-02 10:20:00'),
(22, '202511021550', '2025-11-02 15:50:00', '2025-11-02 15:55:00', 'completed', 3, 10.00, 'settled', '2025-11-02 15:56:00', '2025-11-02 15:56:00', NULL, '2025-11-02 15:50:00', '2025-11-02 10:25:00'),
(23, '202511021555', '2025-11-02 15:55:00', '2025-11-02 16:00:00', 'completed', 8, 10.00, 'settled', '2025-11-02 16:01:00', '2025-11-02 16:01:00', NULL, '2025-11-02 15:55:00', '2025-11-02 10:30:00'),
(24, '202511021600', '2025-11-02 16:00:00', '2025-11-02 16:05:00', 'completed', 6, 10.00, 'settled', '2025-11-02 16:06:00', '2025-11-02 16:06:00', NULL, '2025-11-02 16:00:00', '2025-11-02 10:35:00'),
(25, '202511021605', '2025-11-02 16:05:00', '2025-11-02 16:10:00', 'completed', 11, 10.00, 'settled', '2025-11-02 16:11:00', '2025-11-02 16:11:00', NULL, '2025-11-02 16:05:00', '2025-11-02 10:40:00'),
(26, '202511021610', '2025-11-02 16:10:00', '2025-11-02 16:15:00', 'completed', 1, 10.00, 'settled', '2025-11-02 16:16:00', '2025-11-02 16:16:00', NULL, '2025-11-02 16:10:00', '2025-11-02 10:45:00'),
(27, '202511021615', '2025-11-02 16:15:00', '2025-11-02 16:20:00', 'completed', 1, 10.00, 'settled', '2025-11-02 16:21:00', '2025-11-02 16:21:00', NULL, '2025-11-02 16:15:00', '2025-11-02 10:50:00'),
(28, '202511021620', '2025-11-02 16:20:00', '2025-11-02 16:25:00', 'completed', 11, 10.00, 'settled', '2025-11-02 16:26:00', '2025-11-02 16:26:00', NULL, '2025-11-02 16:20:00', '2025-11-02 10:55:00'),
(29, '202511021625', '2025-11-02 16:25:00', '2025-11-02 16:30:00', 'completed', 2, 10.00, 'settled', '2025-11-02 16:31:00', '2025-11-02 16:31:00', NULL, '2025-11-02 16:25:00', '2025-11-02 11:00:00'),
(30, '202511021630', '2025-11-02 16:30:00', '2025-11-02 16:35:00', 'completed', 2, 10.00, 'settled', '2025-11-02 16:36:00', '2025-11-02 16:36:00', NULL, '2025-11-02 16:30:00', '2025-11-02 11:05:00'),
(31, '202511021635', '2025-11-02 16:35:00', '2025-11-02 16:40:00', 'completed', 4, 10.00, 'settled', '2025-11-02 16:41:00', '2025-11-02 16:41:00', NULL, '2025-11-02 16:35:00', '2025-11-02 11:10:00'),
(32, '202511021640', '2025-11-02 16:40:00', '2025-11-02 16:45:00', 'completed', 4, 10.00, 'settled', '2025-11-02 16:46:00', '2025-11-02 16:46:00', NULL, '2025-11-02 16:40:00', '2025-11-02 11:15:00'),
(33, '202511021645', '2025-11-02 16:45:00', '2025-11-02 16:50:00', 'completed', 7, 10.00, 'settled', '2025-11-02 16:51:00', '2025-11-02 16:51:00', NULL, '2025-11-02 16:45:00', '2025-11-02 11:20:00'),
(34, '202511021650', '2025-11-02 16:50:00', '2025-11-02 16:55:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:47:14', '2025-11-03 13:47:14', NULL, '2025-11-02 16:50:00', '2025-11-02 11:25:00'),
(35, '202511021655', '2025-11-02 16:55:00', '2025-11-02 17:00:00', 'completed', 3, 10.00, 'settled', '2025-11-02 17:00:12', '2025-11-02 17:00:12', NULL, '2025-11-02 16:55:00', '2025-11-02 11:30:00'),
(36, '202511021700', '2025-11-02 17:00:00', '2025-11-02 17:05:00', 'completed', 3, 10.00, 'settled', '2025-11-02 17:05:12', '2025-11-02 17:05:12', NULL, '2025-11-02 17:00:00', '2025-11-02 11:35:00'),
(37, '202511021705', '2025-11-02 17:05:00', '2025-11-02 17:10:00', 'completed', 9, 10.00, 'settled', '2025-11-02 17:10:12', '2025-11-02 17:10:12', NULL, '2025-11-02 17:05:00', '2025-11-02 11:40:00'),
(38, '202511021710', '2025-11-02 17:10:00', '2025-11-02 17:15:00', 'completed', 7, 10.00, 'settled', '2025-11-02 17:15:13', '2025-11-02 17:15:13', NULL, '2025-11-02 17:10:00', '2025-11-02 11:45:00'),
(39, '202511021715', '2025-11-02 17:15:00', '2025-11-02 17:20:00', 'completed', 3, 10.00, 'settled', '2025-11-02 17:20:13', '2025-11-02 17:20:13', NULL, '2025-11-02 17:15:00', '2025-11-02 11:50:00'),
(40, '202511021720', '2025-11-02 17:20:00', '2025-11-02 17:25:00', 'completed', 12, 10.00, 'settled', '2025-11-02 17:25:13', '2025-11-02 17:25:13', NULL, '2025-11-02 17:20:00', '2025-11-02 11:55:00'),
(41, '202511021725', '2025-11-02 17:25:00', '2025-11-02 17:30:00', 'completed', 9, 10.00, 'settled', '2025-11-02 17:30:13', '2025-11-02 17:30:13', NULL, '2025-11-02 17:25:00', '2025-11-02 12:00:00'),
(42, '202511021730', '2025-11-02 17:30:00', '2025-11-02 17:35:00', 'completed', 4, 10.00, 'settled', '2025-11-02 17:35:14', '2025-11-02 17:35:14', NULL, '2025-11-02 17:30:00', '2025-11-02 12:05:00'),
(43, '202511021735', '2025-11-02 17:35:00', '2025-11-02 17:40:00', 'completed', 3, 10.00, 'settled', '2025-11-02 17:40:14', '2025-11-02 17:40:14', NULL, '2025-11-02 17:35:00', '2025-11-02 12:10:00'),
(44, '202511021740', '2025-11-02 17:40:00', '2025-11-02 17:45:00', 'completed', 9, 10.00, 'settled', '2025-11-02 17:45:14', '2025-11-02 17:45:14', NULL, '2025-11-02 17:40:00', '2025-11-02 12:15:00'),
(45, '202511021745', '2025-11-02 17:45:00', '2025-11-02 17:50:00', 'completed', 9, 10.00, 'settled', '2025-11-02 17:50:14', '2025-11-02 17:50:14', NULL, '2025-11-02 17:45:00', '2025-11-02 12:20:00'),
(46, '202511021750', '2025-11-02 17:50:00', '2025-11-02 17:55:00', 'completed', 1, 10.00, 'settled', '2025-11-02 17:55:05', '2025-11-02 17:55:05', NULL, '2025-11-02 17:50:00', '2025-11-02 12:25:00'),
(47, '202511021755', '2025-11-02 17:55:00', '2025-11-02 18:00:00', 'completed', 3, 10.00, 'settled', '2025-11-02 18:00:05', '2025-11-02 18:00:05', NULL, '2025-11-02 17:55:00', '2025-11-02 12:30:00'),
(48, '202511021800', '2025-11-02 18:00:00', '2025-11-02 18:05:00', 'completed', 8, 10.00, 'settled', '2025-11-02 18:05:05', '2025-11-02 18:05:05', NULL, '2025-11-02 18:00:00', '2025-11-02 12:35:00'),
(49, '202511021805', '2025-11-02 18:05:00', '2025-11-02 18:10:00', 'completed', 2, 10.00, 'settled', '2025-11-02 18:10:05', '2025-11-02 18:10:05', NULL, '2025-11-02 18:05:00', '2025-11-02 12:40:00'),
(50, '202511021810', '2025-11-02 18:10:00', '2025-11-02 18:15:00', 'completed', 3, 10.00, 'settled', '2025-11-02 18:15:06', '2025-11-02 18:15:06', NULL, '2025-11-02 18:10:00', '2025-11-02 12:45:00'),
(51, '202511021815', '2025-11-02 18:15:00', '2025-11-02 18:20:00', 'completed', 8, 10.00, 'settled', '2025-11-02 18:20:09', '2025-11-02 18:20:09', NULL, '2025-11-02 18:15:00', '2025-11-02 12:50:00'),
(52, '202511021820', '2025-11-02 18:20:00', '2025-11-02 18:25:00', 'completed', 2, 10.00, 'settled', '2025-11-02 18:25:08', '2025-11-02 18:25:08', NULL, '2025-11-02 18:20:00', '2025-11-02 12:55:00'),
(53, '202511021825', '2025-11-02 18:25:00', '2025-11-02 18:30:00', 'completed', 7, 10.00, 'settled', '2025-11-02 18:30:08', '2025-11-02 18:30:08', NULL, '2025-11-02 18:25:00', '2025-11-02 13:00:00'),
(54, '202511021830', '2025-11-02 18:30:00', '2025-11-02 18:35:00', 'completed', 8, 10.00, 'settled', '2025-11-02 18:35:08', '2025-11-02 18:35:08', NULL, '2025-11-02 18:30:00', '2025-11-02 13:05:00'),
(55, '202511021835', '2025-11-02 18:35:00', '2025-11-02 18:40:00', 'completed', 10, 10.00, 'settled', '2025-11-02 18:40:09', '2025-11-02 18:40:09', NULL, '2025-11-02 18:35:00', '2025-11-02 13:10:00'),
(56, '202511021840', '2025-11-02 18:40:00', '2025-11-02 18:45:00', 'completed', 12, 10.00, 'settled', '2025-11-02 18:45:05', '2025-11-02 18:45:05', NULL, '2025-11-02 18:40:00', '2025-11-02 13:15:00'),
(57, '202511021845', '2025-11-02 18:45:00', '2025-11-02 18:50:00', 'completed', 3, 10.00, 'settled', '2025-11-02 18:50:07', '2025-11-02 18:50:07', NULL, '2025-11-02 18:45:00', '2025-11-02 13:20:00'),
(58, '202511021850', '2025-11-02 18:50:00', '2025-11-02 18:55:00', 'completed', 4, 10.00, 'settled', '2025-11-02 18:55:07', '2025-11-02 18:55:07', NULL, '2025-11-02 18:50:00', '2025-11-02 13:25:00'),
(59, '202511021855', '2025-11-02 18:55:00', '2025-11-02 19:00:00', 'completed', 6, 10.00, 'settled', '2025-11-02 19:00:07', '2025-11-02 19:00:08', NULL, '2025-11-02 18:55:00', '2025-11-02 13:30:00'),
(60, '202511021900', '2025-11-02 19:00:00', '2025-11-02 19:05:00', 'completed', 1, 10.00, 'settled', '2025-11-02 19:05:08', '2025-11-02 19:05:08', NULL, '2025-11-02 19:00:00', '2025-11-02 13:35:00'),
(61, '202511021905', '2025-11-02 19:05:00', '2025-11-02 19:10:00', 'completed', 2, 10.00, 'settled', '2025-11-03 13:46:31', '2025-11-03 13:46:31', NULL, '2025-11-02 19:05:00', '2025-11-02 13:41:00'),
(62, '202511021915', '2025-11-02 19:15:00', '2025-11-02 19:20:00', 'completed', 2, 10.00, 'settled', '2025-11-03 13:46:28', '2025-11-03 13:46:28', NULL, '2025-11-02 19:15:00', '2025-11-02 13:50:00'),
(63, '202511021920', '2025-11-02 19:20:00', '2025-11-02 19:25:00', 'completed', 2, 10.00, 'settled', '2025-11-03 13:46:25', '2025-11-03 13:46:25', NULL, '2025-11-02 19:20:00', '2025-11-02 13:55:00'),
(64, '202511021925', '2025-11-02 19:25:00', '2025-11-02 19:30:00', 'completed', 2, 10.00, 'settled', '2025-11-03 13:46:18', '2025-11-03 13:46:18', NULL, '2025-11-02 19:25:00', '2025-11-02 14:00:00'),
(65, '202511021930', '2025-11-02 19:30:00', '2025-11-02 19:35:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:46:16', '2025-11-03 13:46:16', NULL, '2025-11-02 19:30:00', '2025-11-02 14:05:00'),
(66, '202511021935', '2025-11-02 19:35:00', '2025-11-02 19:40:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:46:14', '2025-11-03 13:46:14', NULL, '2025-11-02 19:35:00', '2025-11-02 14:10:00'),
(67, '202511021940', '2025-11-02 19:40:00', '2025-11-02 19:45:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:46:12', '2025-11-03 13:46:12', NULL, '2025-11-02 19:40:00', '2025-11-02 14:15:00'),
(68, '202511021945', '2025-11-02 19:45:00', '2025-11-02 19:50:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:46:10', '2025-11-03 13:46:10', NULL, '2025-11-02 19:45:00', '2025-11-02 14:20:00'),
(69, '202511021950', '2025-11-02 19:50:00', '2025-11-02 19:55:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:46:08', '2025-11-03 13:46:08', NULL, '2025-11-02 19:50:00', '2025-11-02 14:25:00'),
(70, '202511021955', '2025-11-02 19:55:00', '2025-11-02 20:00:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:46:05', '2025-11-03 13:46:05', NULL, '2025-11-02 19:55:00', '2025-11-02 14:30:00'),
(71, '202511022000', '2025-11-02 20:00:00', '2025-11-02 20:05:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:46:03', '2025-11-03 13:46:03', NULL, '2025-11-02 20:00:00', '2025-11-02 14:35:00'),
(72, '202511022005', '2025-11-02 20:05:00', '2025-11-02 20:10:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:46:00', '2025-11-03 13:46:00', NULL, '2025-11-02 20:05:00', '2025-11-02 14:40:00'),
(73, '202511022010', '2025-11-02 20:10:00', '2025-11-02 20:15:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:45:58', '2025-11-03 13:45:58', NULL, '2025-11-02 20:10:00', '2025-11-02 14:45:00'),
(74, '202511022015', '2025-11-02 20:15:00', '2025-11-02 20:20:00', 'completed', 2, 10.00, 'settled', '2025-11-03 13:45:55', '2025-11-03 13:45:55', NULL, '2025-11-02 20:15:00', '2025-11-02 14:50:00'),
(75, '202511022020', '2025-11-02 20:20:00', '2025-11-02 20:25:00', 'completed', 2, 10.00, 'settled', '2025-11-03 13:45:51', '2025-11-03 13:45:51', NULL, '2025-11-02 20:20:00', '2025-11-02 14:55:00'),
(76, '202511022025', '2025-11-02 20:25:00', '2025-11-02 20:30:00', 'completed', 2, 10.00, 'settled', '2025-11-03 13:45:47', '2025-11-03 13:45:47', NULL, '2025-11-02 20:25:00', '2025-11-02 15:00:00'),
(77, '202511022030', '2025-11-02 20:30:00', '2025-11-02 20:35:00', 'completed', 8, 10.00, 'settled', '2025-11-02 20:35:29', '2025-11-02 20:35:29', NULL, '2025-11-02 20:30:00', '2025-11-02 15:05:00'),
(78, '202511022035', '2025-11-02 20:35:00', '2025-11-02 20:40:00', 'completed', 11, 10.00, 'settled', '2025-11-02 20:40:09', '2025-11-02 20:40:09', NULL, '2025-11-02 20:35:00', '2025-11-02 15:10:00'),
(79, '202511022040', '2025-11-02 20:40:00', '2025-11-02 20:45:00', 'completed', 4, 10.00, 'settled', '2025-11-02 20:45:10', '2025-11-02 20:45:10', NULL, '2025-11-02 20:40:00', '2025-11-02 15:15:00'),
(80, '202511022045', '2025-11-02 20:45:00', '2025-11-02 20:50:00', 'completed', 3, 10.00, 'settled', '2025-11-02 20:50:10', '2025-11-02 20:50:10', NULL, '2025-11-02 20:45:00', '2025-11-02 15:20:00'),
(81, '202511022050', '2025-11-02 20:50:00', '2025-11-02 20:55:00', 'completed', 10, 10.00, 'settled', '2025-11-02 20:55:10', '2025-11-02 20:55:10', NULL, '2025-11-02 20:50:00', '2025-11-02 15:25:00'),
(82, '202511022055', '2025-11-02 20:55:00', '2025-11-02 21:00:00', 'completed', 4, 10.00, 'settled', '2025-11-02 21:00:10', '2025-11-02 21:00:10', NULL, '2025-11-02 20:55:00', '2025-11-02 15:30:00'),
(83, '202511022100', '2025-11-02 21:00:00', '2025-11-02 21:05:00', 'completed', 10, 10.00, 'settled', '2025-11-02 21:05:10', '2025-11-02 21:05:10', NULL, '2025-11-02 21:00:00', '2025-11-02 15:35:00'),
(84, '202511022105', '2025-11-02 21:05:00', '2025-11-02 21:10:00', 'completed', 1, 10.00, 'settled', '2025-11-02 21:10:11', '2025-11-02 21:10:11', NULL, '2025-11-02 21:05:00', '2025-11-02 15:40:00'),
(85, '202511022110', '2025-11-02 21:10:00', '2025-11-02 21:15:00', 'completed', 9, 10.00, 'settled', '2025-11-02 21:15:14', '2025-11-02 21:15:14', NULL, '2025-11-02 21:10:00', '2025-11-02 15:45:00'),
(86, '202511022115', '2025-11-02 21:15:00', '2025-11-02 21:20:00', 'completed', 8, 10.00, 'settled', '2025-11-02 21:20:11', '2025-11-02 21:20:11', NULL, '2025-11-02 21:15:00', '2025-11-02 15:50:00'),
(87, '202511022120', '2025-11-02 21:20:00', '2025-11-02 21:25:00', 'completed', 7, 10.00, 'settled', '2025-11-02 21:25:11', '2025-11-02 21:25:11', NULL, '2025-11-02 21:20:00', '2025-11-02 15:55:00'),
(88, '202511022125', '2025-11-02 21:25:00', '2025-11-02 21:30:00', 'completed', 7, 10.00, 'settled', '2025-11-02 21:30:11', '2025-11-02 21:30:11', NULL, '2025-11-02 21:25:00', '2025-11-02 16:00:00'),
(89, '202511022130', '2025-11-02 21:30:00', '2025-11-02 21:35:00', 'completed', 10, 10.00, 'settled', '2025-11-02 21:35:12', '2025-11-02 21:35:12', NULL, '2025-11-02 21:30:00', '2025-11-02 16:05:00'),
(90, '202511022135', '2025-11-02 21:35:00', '2025-11-02 21:40:00', 'completed', 5, 10.00, 'settled', '2025-11-02 21:40:12', '2025-11-02 21:40:12', NULL, '2025-11-02 21:35:00', '2025-11-02 16:10:00'),
(91, '202511022140', '2025-11-02 21:40:00', '2025-11-02 21:45:00', 'completed', 3, 10.00, 'settled', '2025-11-02 21:45:12', '2025-11-02 21:45:12', NULL, '2025-11-02 21:40:00', '2025-11-02 16:15:00'),
(92, '202511022145', '2025-11-02 21:45:00', '2025-11-02 21:50:00', 'completed', 9, 10.00, 'settled', '2025-11-02 21:50:12', '2025-11-02 21:50:12', NULL, '2025-11-02 21:45:00', '2025-11-02 16:20:00'),
(93, '202511022150', '2025-11-02 21:50:00', '2025-11-02 21:55:00', 'completed', 3, 10.00, 'settled', '2025-11-02 21:55:12', '2025-11-02 21:55:12', NULL, '2025-11-02 21:50:00', '2025-11-02 16:25:00'),
(94, '202511022155', '2025-11-02 21:55:00', '2025-11-02 22:00:00', 'completed', 1, 10.00, 'settled', '2025-11-02 22:00:13', '2025-11-02 22:00:13', NULL, '2025-11-02 21:55:00', '2025-11-02 16:30:00'),
(95, '202511022245', '2025-11-02 22:45:00', '2025-11-02 22:50:00', 'completed', 3, 10.00, 'settled', '2025-11-02 22:50:10', '2025-11-02 22:50:10', NULL, '2025-11-02 22:45:00', '2025-11-02 17:20:00'),
(96, '202511022250', '2025-11-02 22:50:00', '2025-11-02 22:55:00', 'completed', 11, 10.00, 'settled', '2025-11-02 22:55:14', '2025-11-02 22:55:14', NULL, '2025-11-02 22:50:00', '2025-11-02 17:25:00'),
(97, '202511022255', '2025-11-02 22:55:00', '2025-11-02 23:00:00', 'completed', 7, 10.00, 'settled', '2025-11-02 23:00:12', '2025-11-02 23:00:12', NULL, '2025-11-02 22:55:00', '2025-11-02 17:30:00'),
(98, '202511022300', '2025-11-02 23:00:00', '2025-11-02 23:05:00', 'completed', 4, 10.00, 'settled', '2025-11-02 23:05:12', '2025-11-02 23:05:12', NULL, '2025-11-02 23:00:00', '2025-11-02 17:35:00'),
(99, '202511022305', '2025-11-02 23:05:00', '2025-11-02 23:10:00', 'completed', 9, 10.00, 'settled', '2025-11-02 23:10:12', '2025-11-02 23:10:13', NULL, '2025-11-02 23:05:00', '2025-11-02 17:40:00'),
(100, '202511022310', '2025-11-02 23:10:00', '2025-11-02 23:15:00', 'completed', 10, 10.00, 'settled', '2025-11-02 23:15:13', '2025-11-02 23:15:13', NULL, '2025-11-02 23:10:00', '2025-11-02 17:45:00'),
(101, '202511022315', '2025-11-02 23:15:00', '2025-11-02 23:20:00', 'completed', 2, 10.00, 'settled', '2025-11-03 13:45:43', '2025-11-03 13:45:43', NULL, '2025-11-02 23:15:00', '2025-11-02 19:31:00'),
(102, '202511030145', '2025-11-03 01:45:00', '2025-11-03 01:50:00', 'completed', 1, 10.00, 'settled', '2025-11-03 01:55:55', '2025-11-03 01:55:55', NULL, '2025-11-03 01:45:00', '2025-11-02 20:20:00'),
(103, '202511030150', '2025-11-03 01:50:00', '2025-11-03 01:55:00', 'completed', 9, 10.00, 'settled', '2025-11-03 01:56:08', '2025-11-03 01:56:08', NULL, '2025-11-03 01:50:00', '2025-11-02 20:25:00'),
(104, '202511030155', '2025-11-03 01:55:00', '2025-11-03 02:00:00', 'completed', 1, 10.00, 'settled', '2025-11-03 02:00:10', '2025-11-03 02:00:10', NULL, '2025-11-03 01:55:00', '2025-11-02 20:30:00'),
(105, '202511030200', '2025-11-03 02:00:00', '2025-11-03 02:05:00', 'completed', 3, 10.00, 'settled', '2025-11-03 02:05:10', '2025-11-03 02:05:10', NULL, '2025-11-03 02:00:00', '2025-11-02 20:35:00'),
(106, '202511030205', '2025-11-03 02:05:00', '2025-11-03 02:10:00', 'completed', 1, 10.00, 'settled', '2025-11-03 02:10:10', '2025-11-03 02:10:10', NULL, '2025-11-03 02:05:00', '2025-11-02 20:40:00'),
(107, '202511030210', '2025-11-03 02:10:00', '2025-11-03 02:15:00', 'completed', 6, 10.00, 'settled', '2025-11-03 02:15:11', '2025-11-03 02:15:11', NULL, '2025-11-03 02:10:00', '2025-11-02 20:45:00'),
(108, '202511030215', '2025-11-03 02:15:00', '2025-11-03 02:20:00', 'completed', 4, 10.00, 'settled', '2025-11-03 02:20:11', '2025-11-03 02:20:11', NULL, '2025-11-03 02:15:00', '2025-11-02 20:50:00'),
(109, '202511030220', '2025-11-03 02:20:00', '2025-11-03 02:25:00', 'completed', 1, 10.00, 'settled', '2025-11-03 02:25:11', '2025-11-03 02:25:11', NULL, '2025-11-03 02:20:00', '2025-11-02 20:55:00'),
(111, '202511030225', '2025-11-03 02:25:00', '2025-11-03 02:30:00', 'completed', 2, 10.00, 'settled', '2025-11-03 02:30:11', '2025-11-03 02:30:11', NULL, '2025-11-03 02:25:00', '2025-11-02 21:00:00'),
(121, '202511030230', '2025-11-03 02:30:00', '2025-11-03 02:35:00', 'completed', 6, 10.00, 'settled', '2025-11-03 02:35:08', '2025-11-03 02:35:08', NULL, '2025-11-03 02:30:00', '2025-11-02 21:05:00'),
(122, '202511030235', '2025-11-03 02:35:00', '2025-11-03 02:40:00', 'completed', 9, 10.00, 'settled', '2025-11-03 02:40:16', '2025-11-03 02:40:16', NULL, '2025-11-03 02:35:00', '2025-11-02 21:10:00'),
(123, '202511030240', '2025-11-03 02:40:00', '2025-11-03 02:45:00', 'completed', 9, 10.00, 'settled', '2025-11-03 02:45:16', '2025-11-03 02:45:16', NULL, '2025-11-03 02:40:00', '2025-11-02 21:15:00'),
(124, '202511030245', '2025-11-03 02:45:00', '2025-11-03 02:50:00', 'completed', 5, 10.00, 'settled', '2025-11-03 02:50:16', '2025-11-03 02:50:16', NULL, '2025-11-03 02:45:00', '2025-11-02 21:20:00'),
(125, '202511030250', '2025-11-03 02:50:00', '2025-11-03 02:55:00', 'completed', 4, 10.00, 'settled', '2025-11-03 02:51:43', '2025-11-03 02:51:43', NULL, '2025-11-03 02:50:00', '2025-11-03 02:50:00'),
(126, '202511030255', '2025-11-03 02:55:00', '2025-11-03 03:00:00', 'completed', 1, 10.00, 'settled', '2025-11-03 02:56:15', '2025-11-03 02:56:15', NULL, '2025-11-03 02:55:00', '2025-11-02 21:30:00'),
(127, '202511030300', '2025-11-03 03:00:00', '2025-11-03 03:05:00', 'completed', 2, 10.00, 'settled', '2025-11-03 04:58:06', '2025-11-03 04:58:06', NULL, '2025-11-03 03:00:00', '2025-11-02 21:36:00'),
(128, '202511030410', '2025-11-03 04:10:00', '2025-11-03 04:15:00', 'completed', 4, 10.00, 'settled', '2025-11-03 04:15:36', '2025-11-03 04:15:36', NULL, '2025-11-03 04:10:00', '2025-11-02 22:45:00'),
(129, '202511030415', '2025-11-03 04:15:00', '2025-11-03 04:20:00', 'completed', 9, 10.00, 'settled', '2025-11-03 04:20:10', '2025-11-03 04:20:10', NULL, '2025-11-03 04:15:00', '2025-11-02 22:50:00'),
(130, '202511030420', '2025-11-03 04:20:00', '2025-11-03 04:25:00', 'completed', 10, 10.00, 'settled', '2025-11-03 04:25:10', '2025-11-03 04:25:10', NULL, '2025-11-03 04:20:00', '2025-11-02 22:55:00'),
(131, '202511030425', '2025-11-03 04:25:00', '2025-11-03 04:30:00', 'completed', 8, 10.00, 'settled', '2025-11-03 04:30:18', '2025-11-03 04:30:18', NULL, '2025-11-03 04:25:00', '2025-11-02 23:00:00'),
(132, '202511030430', '2025-11-03 04:30:00', '2025-11-03 04:35:00', 'completed', 10, 10.00, 'settled', '2025-11-03 04:35:18', '2025-11-03 04:35:18', NULL, '2025-11-03 04:30:00', '2025-11-02 23:05:00'),
(133, '202511030435', '2025-11-03 04:35:00', '2025-11-03 04:40:00', 'completed', 2, 10.00, 'settled', '2025-11-03 04:40:18', '2025-11-03 04:40:18', NULL, '2025-11-03 04:35:00', '2025-11-02 23:10:00'),
(134, '202511030440', '2025-11-03 04:40:00', '2025-11-03 04:45:00', 'completed', 6, 10.00, 'settled', '2025-11-03 04:45:15', '2025-11-03 04:45:15', NULL, '2025-11-03 04:40:00', '2025-11-02 23:15:00'),
(135, '202511030445', '2025-11-03 04:45:00', '2025-11-03 04:50:00', 'completed', 6, 10.00, 'settled', '2025-11-03 04:50:16', '2025-11-03 04:50:16', NULL, '2025-11-03 04:45:00', '2025-11-02 23:20:00'),
(136, '202511030450', '2025-11-03 04:50:00', '2025-11-03 04:55:00', 'completed', 8, 10.00, 'settled', '2025-11-03 04:55:16', '2025-11-03 04:55:16', NULL, '2025-11-03 04:50:00', '2025-11-02 23:25:00'),
(137, '202511030455', '2025-11-03 04:55:00', '2025-11-03 05:00:00', 'completed', 9, 10.00, 'settled', '2025-11-03 05:00:16', '2025-11-03 05:00:16', NULL, '2025-11-03 04:55:00', '2025-11-02 23:30:00'),
(138, '202511030500', '2025-11-03 05:00:00', '2025-11-03 05:05:00', 'completed', 8, 10.00, 'settled', '2025-11-03 05:05:16', '2025-11-03 05:05:16', NULL, '2025-11-03 05:00:00', '2025-11-02 23:35:00'),
(139, '202511030505', '2025-11-03 05:05:00', '2025-11-03 05:10:00', 'completed', 9, 10.00, 'settled', '2025-11-03 05:10:18', '2025-11-03 05:10:18', NULL, '2025-11-03 05:05:00', '2025-11-02 23:40:00'),
(140, '202511030510', '2025-11-03 05:10:00', '2025-11-03 05:15:00', 'completed', 3, 10.00, 'settled', '2025-11-03 13:45:40', '2025-11-03 13:45:40', NULL, '2025-11-03 05:10:00', '2025-11-03 06:14:00'),
(141, '202511031145', '2025-11-03 11:45:00', '2025-11-03 11:50:00', 'completed', 9, 10.00, 'settled', '2025-11-03 11:50:17', '2025-11-03 11:50:17', NULL, '2025-11-03 11:45:00', '2025-11-03 06:20:00'),
(142, '202511031150', '2025-11-03 11:50:00', '2025-11-03 11:55:00', 'completed', 8, 10.00, 'settled', '2025-11-03 11:55:17', '2025-11-03 11:55:17', NULL, '2025-11-03 11:50:00', '2025-11-03 06:25:00'),
(143, '202511031155', '2025-11-03 11:55:00', '2025-11-03 12:00:00', 'completed', 2, 10.00, 'settled', '2025-11-03 12:00:17', '2025-11-03 12:00:17', NULL, '2025-11-03 11:55:00', '2025-11-03 06:30:00'),
(144, '202511031200', '2025-11-03 12:00:00', '2025-11-03 12:05:00', 'completed', 9, 10.00, 'settled', '2025-11-03 12:05:10', '2025-11-03 12:05:10', NULL, '2025-11-03 12:00:00', '2025-11-03 06:35:00'),
(145, '202511031205', '2025-11-03 12:05:00', '2025-11-03 12:10:00', 'completed', 2, 10.00, 'settled', '2025-11-03 12:10:17', '2025-11-03 12:10:17', NULL, '2025-11-03 12:05:00', '2025-11-03 06:40:00'),
(146, '202511031210', '2025-11-03 12:10:00', '2025-11-03 12:15:00', 'completed', 3, 10.00, 'settled', '2025-11-03 12:15:17', '2025-11-03 12:15:17', NULL, '2025-11-03 12:10:00', '2025-11-03 06:45:00'),
(147, '202511031215', '2025-11-03 12:15:00', '2025-11-03 12:20:00', 'completed', 4, 10.00, 'settled', '2025-11-03 12:20:15', '2025-11-03 12:20:15', NULL, '2025-11-03 12:15:00', '2025-11-03 06:50:00'),
(148, '202511031220', '2025-11-03 12:20:00', '2025-11-03 12:25:00', 'completed', 1, 10.00, 'settled', '2025-11-03 12:25:15', '2025-11-03 12:25:15', NULL, '2025-11-03 12:20:00', '2025-11-03 06:55:00'),
(149, '202511031225', '2025-11-03 12:25:00', '2025-11-03 12:30:00', 'completed', 3, 10.00, 'settled', '2025-11-03 13:45:33', '2025-11-03 13:45:33', NULL, '2025-11-03 12:25:00', '2025-11-03 07:03:00'),
(150, '202511031235', '2025-11-03 12:35:00', '2025-11-03 12:40:00', 'completed', 2, 10.00, 'settled', '2025-11-03 12:40:17', '2025-11-03 12:40:17', NULL, '2025-11-03 12:35:00', '2025-11-03 07:10:00'),
(151, '202511031240', '2025-11-03 12:40:00', '2025-11-03 12:45:00', 'completed', 4, 10.00, 'settled', '2025-11-03 12:45:11', '2025-11-03 12:45:11', NULL, '2025-11-03 12:40:00', '2025-11-03 07:15:00'),
(152, '202511031245', '2025-11-03 12:45:00', '2025-11-03 12:50:00', 'completed', 4, 10.00, 'settled', '2025-11-03 12:50:11', '2025-11-03 12:50:11', NULL, '2025-11-03 12:45:00', '2025-11-03 07:20:00'),
(153, '202511031250', '2025-11-03 12:50:00', '2025-11-03 12:55:00', 'completed', 2, 10.00, 'settled', '2025-11-03 12:55:11', '2025-11-03 12:55:11', NULL, '2025-11-03 12:50:00', '2025-11-03 07:25:00'),
(154, '202511031255', '2025-11-03 12:55:00', '2025-11-03 13:00:00', 'completed', 6, 10.00, 'settled', '2025-11-03 13:00:15', '2025-11-03 13:00:15', NULL, '2025-11-03 12:55:00', '2025-11-03 07:30:00'),
(155, '202511031300', '2025-11-03 13:00:00', '2025-11-03 13:05:00', 'completed', 12, 10.00, 'settled', '2025-11-03 13:05:15', '2025-11-03 13:05:15', NULL, '2025-11-03 13:00:00', '2025-11-03 07:35:00'),
(156, '202511031305', '2025-11-03 13:05:00', '2025-11-03 13:10:00', 'completed', 11, 10.00, 'settled', '2025-11-03 13:10:16', '2025-11-03 13:10:16', NULL, '2025-11-03 13:05:00', '2025-11-03 07:40:00'),
(157, '202511031310', '2025-11-03 13:10:00', '2025-11-03 13:15:00', 'completed', 12, 10.00, 'settled', '2025-11-03 13:15:16', '2025-11-03 13:15:16', NULL, '2025-11-03 13:10:00', '2025-11-03 07:45:00'),
(158, '202511031315', '2025-11-03 13:15:00', '2025-11-03 13:20:00', 'completed', 9, 10.00, 'settled', '2025-11-03 13:20:16', '2025-11-03 13:20:16', NULL, '2025-11-03 13:15:00', '2025-11-03 07:50:00'),
(159, '202511031320', '2025-11-03 13:20:00', '2025-11-03 13:25:00', 'completed', 7, 10.00, 'settled', '2025-11-03 13:25:12', '2025-11-03 13:25:12', NULL, '2025-11-03 13:20:00', '2025-11-03 07:55:00'),
(160, '202511031325', '2025-11-03 13:25:00', '2025-11-03 13:30:00', 'completed', 7, 10.00, 'settled', '2025-11-03 13:30:12', '2025-11-03 13:30:12', NULL, '2025-11-03 13:25:00', '2025-11-03 08:00:00'),
(161, '202511031330', '2025-11-03 13:30:00', '2025-11-03 13:35:00', 'completed', 10, 10.00, 'settled', '2025-11-03 13:35:12', '2025-11-03 13:35:12', NULL, '2025-11-03 13:30:00', '2025-11-03 08:05:00'),
(162, '202511031335', '2025-11-03 13:35:00', '2025-11-03 13:40:00', 'completed', 3, 10.00, 'settled', '2025-11-03 13:40:13', '2025-11-03 13:40:13', NULL, '2025-11-03 13:35:00', '2025-11-03 08:10:00'),
(163, '202511031340', '2025-11-03 13:40:00', '2025-11-03 13:45:00', 'completed', 8, 10.00, 'settled', '2025-11-03 13:45:18', '2025-11-03 13:45:18', NULL, '2025-11-03 13:40:00', '2025-11-03 08:15:00'),
(164, '202511031345', '2025-11-03 13:45:00', '2025-11-03 13:50:00', 'completed', 6, 10.00, 'settled', '2025-11-03 13:50:18', '2025-11-03 13:50:18', NULL, '2025-11-03 13:45:00', '2025-11-03 08:20:00'),
(165, '202511031350', '2025-11-03 13:50:00', '2025-11-03 13:55:00', 'completed', 1, 10.00, 'settled', '2025-11-03 13:55:05', '2025-11-03 13:55:05', NULL, '2025-11-03 13:50:00', '2025-11-03 08:25:00'),
(166, '202511031355', '2025-11-03 13:55:00', '2025-11-03 14:00:00', 'completed', 7, 10.00, 'settled', '2025-11-03 14:00:19', '2025-11-03 14:00:19', NULL, '2025-11-03 13:55:00', '2025-11-03 08:30:00'),
(167, '202511031400', '2025-11-03 14:00:00', '2025-11-03 14:05:00', 'active', NULL, 10.00, 'not_settled', NULL, NULL, NULL, '2025-11-03 14:00:00', '2025-11-03 14:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `game_card_totals`
--

CREATE TABLE `game_card_totals` (
  `id` bigint(20) NOT NULL,
  `game_id` varchar(50) NOT NULL,
  `card_number` tinyint(4) NOT NULL COMMENT 'Card number (1-12)',
  `total_bet_amount` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT 'Total amount bet on this card in this game',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `game_card_totals`
--

INSERT INTO `game_card_totals` (`id`, `game_id`, `card_number`, `total_bet_amount`, `created_at`, `updated_at`) VALUES
(1, '202511021410', 5, 100.00, '2025-11-02 14:11:59', '2025-11-02 14:11:59'),
(2, '202511021410', 7, 150.00, '2025-11-02 14:11:59', '2025-11-02 14:11:59'),
(3, '202511021515', 5, 200.00, '2025-11-02 15:17:20', '2025-11-02 09:47:30'),
(4, '202511021515', 7, 300.00, '2025-11-02 15:17:20', '2025-11-02 09:47:30'),
(5, '202511021830', 1, 100.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(6, '202511021830', 2, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(7, '202511021830', 3, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(8, '202511021830', 4, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(9, '202511021830', 5, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(10, '202511021830', 6, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(11, '202511021830', 7, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(12, '202511021830', 8, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(13, '202511021830', 9, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(14, '202511021830', 10, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(15, '202511021830', 11, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(16, '202511021830', 12, 150.00, '2025-11-02 18:33:05', '2025-11-02 18:33:05'),
(17, '202511022035', 1, 100.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(18, '202511022035', 2, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(19, '202511022035', 3, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(20, '202511022035', 4, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(21, '202511022035', 5, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(22, '202511022035', 6, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(23, '202511022035', 7, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(24, '202511022035', 8, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(25, '202511022035', 9, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(26, '202511022035', 10, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(27, '202511022035', 11, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(28, '202511022035', 12, 150.00, '2025-11-02 20:35:15', '2025-11-02 20:35:15'),
(29, '202511030145', 1, 100.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(30, '202511030145', 2, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(31, '202511030145', 3, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(32, '202511030145', 4, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(33, '202511030145', 5, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(34, '202511030145', 6, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(35, '202511030145', 7, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(36, '202511030145', 8, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(37, '202511030145', 9, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(38, '202511030145', 10, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(39, '202511030145', 11, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(40, '202511030145', 12, 150.00, '2025-11-03 01:45:40', '2025-11-03 01:45:40'),
(41, '202511030255', 1, 100.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(42, '202511030255', 2, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(43, '202511030255', 3, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(44, '202511030255', 4, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(45, '202511030255', 5, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(46, '202511030255', 6, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(47, '202511030255', 7, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(48, '202511030255', 8, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(49, '202511030255', 9, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(50, '202511030255', 10, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(51, '202511030255', 11, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(52, '202511030255', 12, 150.00, '2025-11-03 02:56:04', '2025-11-03 02:56:04'),
(53, '202511030430', 5, 200.00, '2025-11-03 04:33:50', '2025-11-02 23:04:36'),
(54, '202511030430', 7, 300.00, '2025-11-03 04:33:50', '2025-11-02 23:04:36'),
(55, '202511030430', 12, 100.00, '2025-11-03 04:33:50', '2025-11-02 23:04:36'),
(56, '202511030430', 1, 100.00, '2025-11-03 04:34:28', '2025-11-03 04:34:28'),
(57, '202511030435', 5, 100.00, '2025-11-03 04:36:49', '2025-11-03 04:36:49'),
(58, '202511030435', 7, 150.00, '2025-11-03 04:36:49', '2025-11-03 04:36:49'),
(62, '202511031145', 5, 100.00, '2025-11-03 11:49:53', '2025-11-03 11:49:53'),
(63, '202511031145', 7, 150.00, '2025-11-03 11:49:53', '2025-11-03 11:49:53'),
(64, '202511031145', 12, 50.00, '2025-11-03 11:49:53', '2025-11-03 11:49:53'),
(65, '202511031210', 5, 100.00, '2025-11-03 12:14:42', '2025-11-03 12:14:42'),
(66, '202511031210', 7, 150.00, '2025-11-03 12:14:42', '2025-11-03 12:14:42'),
(67, '202511031210', 12, 50.00, '2025-11-03 12:14:42', '2025-11-03 12:14:42'),
(68, '202511031215', 1, 10.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(69, '202511031215', 2, 20.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(70, '202511031215', 3, 30.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(71, '202511031215', 4, 40.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(72, '202511031215', 5, 50.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(73, '202511031215', 6, 60.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(74, '202511031215', 7, 70.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(75, '202511031215', 8, 80.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(76, '202511031215', 9, 90.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(77, '202511031215', 10, 100.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(78, '202511031215', 11, 10.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(79, '202511031215', 12, 20.00, '2025-11-03 12:19:50', '2025-11-03 12:19:50'),
(80, '202511031220', 1, 10.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(81, '202511031220', 2, 20.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(82, '202511031220', 3, 30.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(83, '202511031220', 4, 40.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(84, '202511031220', 5, 50.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(85, '202511031220', 6, 60.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(86, '202511031220', 7, 70.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(87, '202511031220', 8, 80.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(88, '202511031220', 9, 90.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(89, '202511031220', 10, 100.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(90, '202511031220', 11, 10.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(91, '202511031220', 12, 20.00, '2025-11-03 12:23:59', '2025-11-03 12:23:59'),
(92, '202511031235', 1, 10.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(93, '202511031235', 2, 20.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(94, '202511031235', 3, 30.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(95, '202511031235', 4, 40.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(96, '202511031235', 5, 50.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(97, '202511031235', 6, 60.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(98, '202511031235', 7, 70.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(99, '202511031235', 8, 80.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(100, '202511031235', 9, 90.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(101, '202511031235', 10, 100.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(102, '202511031235', 11, 10.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(103, '202511031235', 12, 20.00, '2025-11-03 12:35:15', '2025-11-03 07:09:54'),
(104, '202511031300', 1, 20.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(105, '202511031300', 2, 40.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(106, '202511031300', 3, 60.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(107, '202511031300', 4, 80.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(108, '202511031300', 5, 100.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(109, '202511031300', 6, 120.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(110, '202511031300', 7, 140.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(111, '202511031300', 8, 160.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(112, '202511031300', 9, 180.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(113, '202511031300', 10, 200.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(114, '202511031300', 11, 20.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(115, '202511031300', 12, 40.00, '2025-11-03 13:04:00', '2025-11-03 07:34:34'),
(116, '202511031305', 1, 10.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(117, '202511031305', 2, 20.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(118, '202511031305', 3, 30.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(119, '202511031305', 4, 40.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(120, '202511031305', 5, 50.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(121, '202511031305', 6, 60.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(122, '202511031305', 7, 70.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(123, '202511031305', 8, 80.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(124, '202511031305', 9, 90.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(125, '202511031305', 10, 100.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(126, '202511031305', 11, 10.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(127, '202511031305', 12, 20.00, '2025-11-03 13:06:01', '2025-11-03 07:37:01'),
(128, '202511031350', 1, 10.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(129, '202511031350', 2, 20.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(130, '202511031350', 3, 30.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(131, '202511031350', 4, 40.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(132, '202511031350', 5, 50.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(133, '202511031350', 6, 60.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(134, '202511031350', 7, 70.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(135, '202511031350', 8, 80.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(136, '202511031350', 9, 90.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(137, '202511031350', 10, 100.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(138, '202511031350', 11, 10.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07'),
(139, '202511031350', 12, 20.00, '2025-11-03 13:54:07', '2025-11-03 13:54:07');

-- --------------------------------------------------------

--
-- Table structure for table `login_history`
--

CREATE TABLE `login_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `login_time` datetime NOT NULL DEFAULT current_timestamp(),
  `ip_address` varchar(45) DEFAULT NULL,
  `device_info` text DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `login_method` varchar(50) DEFAULT NULL,
  `is_successful` tinyint(4) NOT NULL DEFAULT 1,
  `failure_reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `login_history`
--

INSERT INTO `login_history` (`id`, `user_id`, `login_time`, `ip_address`, `device_info`, `user_agent`, `login_method`, `is_successful`, `failure_reason`) VALUES
(1, 4, '2025-10-30 08:32:46', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(2, 3, '2025-10-30 08:34:42', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(3, 4, '2025-10-30 09:12:54', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(4, 4, '2025-10-30 09:36:21', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(5, 3, '2025-10-30 09:36:24', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(6, 2, '2025-10-30 09:51:47', '::1', NULL, 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(7, 4, '2025-10-30 09:52:33', '::1', NULL, 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(8, NULL, '2025-10-30 09:54:09', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(9, NULL, '2025-10-30 09:54:29', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(10, NULL, '2025-10-30 09:54:30', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(11, NULL, '2025-10-30 09:54:37', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(12, 3, '2025-10-30 09:55:33', '::1', NULL, 'axios/0.26.0', 'user_id', 0, 'Invalid password'),
(13, 4, '2025-10-30 09:55:52', '::1', NULL, 'axios/0.26.0', 'user_id', 0, 'Invalid password'),
(14, NULL, '2025-10-30 09:56:13', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(15, NULL, '2025-10-30 09:56:35', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(16, NULL, '2025-10-30 09:56:44', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(17, NULL, '2025-10-30 09:57:36', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(18, NULL, '2025-10-30 10:09:15', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(19, NULL, '2025-10-30 10:21:46', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(20, NULL, '2025-10-30 10:23:34', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(21, NULL, '2025-10-30 10:23:46', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(22, NULL, '2025-10-30 10:26:01', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(23, NULL, '2025-10-30 10:27:00', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(24, NULL, '2025-10-30 10:27:09', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(25, NULL, '2025-10-30 10:27:53', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(26, NULL, '2025-10-30 10:30:35', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(27, 4, '2025-10-30 10:30:52', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Invalid password'),
(28, 4, '2025-10-30 10:31:00', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Invalid password'),
(29, NULL, '2025-10-30 10:31:10', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(30, 4, '2025-10-30 10:31:29', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists'),
(31, 3, '2025-10-30 10:31:31', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(32, 4, '2025-10-30 10:36:13', '::ffff:192.168.1.100', NULL, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists'),
(33, 4, '2025-10-30 10:36:19', '::ffff:192.168.1.100', NULL, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists'),
(34, 4, '2025-10-30 10:36:29', '::ffff:192.168.1.100', NULL, 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(35, 4, '2025-10-30 10:46:44', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(36, 3, '2025-10-30 11:01:55', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(37, 4, '2025-10-30 12:17:28', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(38, NULL, '2025-10-30 12:20:51', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'User not found'),
(39, 5, '2025-10-30 12:21:00', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Invalid password'),
(40, 5, '2025-10-30 12:21:05', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(41, 4, '2025-10-30 12:21:25', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(42, 3, '2025-10-30 12:23:46', '::ffff:192.168.1.108', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(43, 4, '2025-10-30 18:22:32', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(44, 2, '2025-10-30 18:22:34', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(45, 4, '2025-10-30 18:24:00', '::1', NULL, 'python-requests/2.32.3', 'user_id', 1, NULL),
(46, NULL, '2025-10-30 18:25:46', '::1', NULL, 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'User not found'),
(47, 3, '2025-10-30 18:28:35', '::1', NULL, 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(48, 4, '2025-10-31 07:55:53', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(49, 4, '2025-10-31 08:22:26', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(50, 4, '2025-10-31 10:12:40', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists'),
(51, 3, '2025-10-31 10:12:42', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(52, 5, '2025-10-31 11:06:33', '::1', NULL, 'PostmanRuntime/7.49.0', 'user_id', 1, NULL),
(53, 4, '2025-10-31 11:07:31', '::1', NULL, 'PostmanRuntime/7.49.0', 'user_id', 0, 'Active session exists'),
(54, 3, '2025-10-31 11:07:40', '::1', NULL, 'PostmanRuntime/7.49.0', 'user_id', 1, NULL),
(55, 3, '2025-10-31 11:52:02', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists'),
(56, 2, '2025-10-31 11:52:05', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(57, 4, '2025-11-01 13:33:32', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(58, 4, '2025-11-01 13:58:53', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(59, 4, '2025-11-01 15:00:44', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(60, 4, '2025-11-01 20:52:59', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(61, 3, '2025-11-01 20:53:03', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(62, 3, '2025-11-01 21:44:33', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(63, 5, '2025-11-02 08:29:37', '::1', NULL, 'python-requests/2.31.0', 'user_id', 1, NULL),
(64, 5, '2025-11-02 08:40:18', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists'),
(65, 4, '2025-11-02 08:40:44', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(66, 5, '2025-11-02 08:40:56', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(67, 4, '2025-11-02 09:05:00', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(68, 3, '2025-11-02 09:05:03', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(69, 2, '2025-11-02 09:05:05', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(70, 4, '2025-11-02 09:45:45', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(71, 5, '2025-11-02 09:46:59', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists'),
(72, 5, '2025-11-02 09:47:16', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(73, 4, '2025-11-02 10:00:59', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(74, 3, '2025-11-02 10:01:02', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(75, 4, '2025-11-02 11:19:51', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(76, 4, '2025-11-02 12:45:58', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(77, 3, '2025-11-02 12:46:01', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(78, 5, '2025-11-02 12:58:48', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists'),
(79, 5, '2025-11-02 12:59:02', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(80, 4, '2025-11-02 13:02:26', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(81, 3, '2025-11-02 13:02:28', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(82, 3, '2025-11-02 13:02:31', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists'),
(83, 2, '2025-11-02 13:02:34', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(84, 3, '2025-11-02 13:42:19', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(85, 5, '2025-11-02 14:03:39', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(86, 5, '2025-11-02 14:03:42', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(87, 5, '2025-11-02 14:03:44', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(88, 5, '2025-11-02 14:03:45', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(89, 5, '2025-11-02 14:03:48', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(90, 5, '2025-11-02 14:03:50', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(91, 5, '2025-11-02 14:08:55', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(92, 5, '2025-11-02 14:30:23', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(93, 5, '2025-11-02 14:30:24', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(94, 5, '2025-11-02 14:58:57', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(95, 4, '2025-11-02 14:59:39', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(96, 5, '2025-11-02 15:04:32', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(97, 5, '2025-11-02 15:04:35', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(98, 4, '2025-11-02 17:09:32', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Invalid password'),
(99, 4, '2025-11-02 17:09:36', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(100, 4, '2025-11-02 17:09:41', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(101, 4, '2025-11-02 17:31:47', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(102, 4, '2025-11-02 17:31:57', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', 'user_id', 1, NULL),
(103, 5, '2025-11-02 17:32:14', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(104, 5, '2025-11-02 17:32:15', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(105, 5, '2025-11-02 19:30:31', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(106, 5, '2025-11-02 19:30:33', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(107, 5, '2025-11-02 19:30:36', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(108, 5, '2025-11-02 19:30:37', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(109, 5, '2025-11-02 19:30:38', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(110, 5, '2025-11-02 19:30:38', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(111, 5, '2025-11-02 19:30:39', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(112, 5, '2025-11-02 19:30:40', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(113, 5, '2025-11-02 19:30:40', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(114, 5, '2025-11-02 19:30:41', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(115, 5, '2025-11-02 19:31:43', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(116, 4, '2025-11-02 19:32:02', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(117, 4, '2025-11-02 19:32:12', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(118, 4, '2025-11-02 19:32:22', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(119, 4, '2025-11-02 19:32:25', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 1, NULL),
(120, 4, '2025-11-02 19:32:48', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(121, 4, '2025-11-02 19:32:49', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 1, NULL),
(122, 4, '2025-11-02 19:33:01', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(123, 4, '2025-11-02 19:33:05', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 1, NULL),
(124, 4, '2025-11-02 19:38:16', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(125, 4, '2025-11-02 19:38:53', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(126, 4, '2025-11-02 19:39:39', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(127, 4, '2025-11-02 19:39:42', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(128, 4, '2025-11-02 19:45:32', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(129, 4, '2025-11-02 19:45:39', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(130, 4, '2025-11-02 19:45:43', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(131, 4, '2025-11-02 19:50:17', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(132, 4, '2025-11-02 19:50:18', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(133, 4, '2025-11-02 19:50:19', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(134, 4, '2025-11-02 19:50:20', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(135, 3, '2025-11-02 19:50:25', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(136, 2, '2025-11-02 19:50:27', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(137, 2, '2025-11-02 19:52:09', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(138, 4, '2025-11-02 19:57:49', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Failed to revoke existing sessions'),
(139, 4, '2025-11-02 20:02:25', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 1, NULL),
(140, 4, '2025-11-02 20:02:48', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists on another device'),
(141, 4, '2025-11-02 20:03:00', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(142, 4, '2025-11-02 20:11:09', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(143, 4, '2025-11-02 20:11:10', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 1, NULL),
(144, 4, '2025-11-02 20:11:21', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists on another device'),
(145, 4, '2025-11-02 20:11:23', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(146, 5, '2025-11-02 20:11:54', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(147, 4, '2025-11-02 20:12:23', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(148, 3, '2025-11-02 20:12:35', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(149, 5, '2025-11-02 20:13:04', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(150, 5, '2025-11-02 20:13:06', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(151, 4, '2025-11-02 20:20:40', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists on another device'),
(152, 4, '2025-11-02 20:20:42', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(153, 5, '2025-11-02 21:22:11', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(154, 5, '2025-11-02 21:22:19', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(155, 4, '2025-11-02 22:35:50', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists on another device'),
(156, 4, '2025-11-02 22:35:52', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(157, 5, '2025-11-02 23:02:56', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(158, 5, '2025-11-02 23:03:34', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(159, 4, '2025-11-03 06:13:16', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists on another device'),
(160, 4, '2025-11-03 06:13:18', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL),
(161, 5, '2025-11-03 06:16:17', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(162, 5, '2025-11-03 06:17:41', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(163, NULL, '2025-11-03 07:29:11', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'User not found'),
(164, 5, '2025-11-03 07:29:22', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(165, 5, '2025-11-03 07:29:26', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 0, 'Active session exists on another device'),
(166, 5, '2025-11-03 07:29:37', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'user_id', 1, NULL),
(167, 5, '2025-11-03 07:33:45', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 0, 'Active session exists on another device'),
(168, 5, '2025-11-03 07:33:54', '::1', NULL, 'PostmanRuntime/7.49.1', 'user_id', 1, NULL),
(169, 4, '2025-11-03 08:15:19', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 0, 'Active session exists on another device'),
(170, 4, '2025-11-03 08:15:20', '::1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'user_id', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(11) NOT NULL,
  `timestamp` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `resource` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `isActive` tinyint(4) NOT NULL DEFAULT 1,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expiresAt` datetime NOT NULL,
  `revoked` tinyint(4) NOT NULL DEFAULT 0,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`id`, `token`, `expiresAt`, `revoked`, `createdAt`, `updatedAt`, `user_id`) VALUES
(1, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MTMxNjYsImV4cCI6MTc2MjQxNzk2NiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.jlNQKOFDEj_AZf_x1cpqU08j3PkzGg-HeHeVDkEbjJI', '2025-11-06 14:02:46', 1, '2025-10-30 08:32:46.017742', '2025-10-30 08:34:50.000000', 4),
(2, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MTMyODIsImV4cCI6MTc2MjQxODA4MiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.9qEsCuWISHptwo3W1PABRB-lrHMBi3zfLrhZxYP3hB8', '2025-11-06 14:04:42', 1, '2025-10-30 08:34:42.764525', '2025-10-30 09:13:06.000000', 3),
(3, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MTU1NzQsImV4cCI6MTc2MjQyMDM3NCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.poJsVY9t4FA2cvq4JrWOv9kTiEj_AzulyR2cb6lS6Yo', '2025-11-06 14:42:54', 1, '2025-10-30 09:12:54.885488', '2025-10-30 09:36:29.000000', 4),
(4, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MTY5ODQsImV4cCI6MTc2MjQyMTc4NCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.5ZGM5eTBoYC30ClcfnOYxrTW8eVsLevUnzBDIrt3wPI', '2025-11-06 15:06:24', 1, '2025-10-30 09:36:24.248781', '2025-10-30 09:52:41.000000', 3),
(5, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcl9pZCI6ImFkbWluMDAzIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MTc5MDcsImV4cCI6MTc2MjQyMjcwNywiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.RNyujYGAvI1MQLCZjYxnJvu9LpqAhkxvpnL4QJJPdOA', '2025-11-06 15:21:47', 1, '2025-10-30 09:51:47.308541', '2025-10-30 09:52:44.000000', 2),
(6, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MTc5NTMsImV4cCI6MTc2MjQyMjc1MywiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.zfdZ959gQG7hBfoYiXQBvqAusFupL9vA02BqbEO6wgY', '2025-11-06 15:22:33', 1, '2025-10-30 09:52:33.803249', '2025-10-30 10:36:21.000000', 4),
(7, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MjAyOTEsImV4cCI6MTc2MjQyNTA5MSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.Ko2PHwyomkUv3i9XrC_CUwwEW54D0jfD0QQk-a_tTIc', '2025-11-06 16:01:31', 1, '2025-10-30 10:31:31.941259', '2025-10-30 10:35:58.000000', 3),
(8, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MjA1ODksImV4cCI6MTc2MjQyNTM4OSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.QxlACQHrng7PfOqwQoBArH8Z_wdn34XCs_mbuO5fteM', '2025-11-06 16:06:29', 1, '2025-10-30 10:36:29.806512', '2025-10-30 10:36:43.000000', 4),
(9, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MjEyMDQsImV4cCI6MTc2MjQyNjAwNCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.4apITe_XPPnteVmznzzvfjMwnAWJQZAOcnqvISdPc5Y', '2025-11-06 16:16:44', 1, '2025-10-30 10:46:44.358033', '2025-10-30 11:02:02.000000', 4),
(10, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MjIxMTUsImV4cCI6MTc2MjQyNjkxNSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.g_HgcNll9O13kRr2Jko2jHEAc0DfKLR94Zyr5gYvDn0', '2025-11-06 16:31:55', 1, '2025-10-30 11:01:55.898443', '2025-10-30 11:02:04.000000', 3),
(12, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxODI2ODY1LCJleHAiOjE3NjI0MzE2NjUsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.ZhKUGj2InrX3V0AeoMcI-eOY8aUljNe8CE_7XFyn260', '2025-11-06 17:51:05', 1, '2025-10-30 12:21:05.155843', '2025-10-30 18:22:41.000000', 5),
(13, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MjY4ODUsImV4cCI6MTc2MjQzMTY4NSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.xByjA2kZUvPQWlgqrrqvDxSwhTRayf_20YQtedQqAo4', '2025-11-06 17:51:25', 1, '2025-10-30 12:21:25.579726', '2025-10-30 18:22:45.000000', 4),
(14, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4MjcwMjYsImV4cCI6MTc2MjQzMTgyNiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.IpEG1FUpm-SfDZueRkKE3eXJtsdJkN8rWnQJF1yzJFo', '2025-11-06 17:53:46', 1, '2025-10-30 12:23:46.180006', '2025-10-30 18:22:43.000000', 3),
(16, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4NDg2NDAsImV4cCI6MTc2MjQ1MzQ0MCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.jRrBnYuGzw2qGWaUtzwVyvsDq5dCixEA55mRECk5448', '2025-11-06 23:54:00', 1, '2025-10-30 18:24:00.593715', '2025-10-30 18:28:40.000000', 4),
(17, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4NDg5MTUsImV4cCI6MTc2MjQ1MzcxNSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.TOsVSbNqs2d7USVx33x6_vzWJA4DhRyvgl6V84xplXM', '2025-11-06 23:58:35', 1, '2025-10-30 18:28:35.269428', '2025-10-31 07:56:02.000000', 3),
(18, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4OTczNTMsImV4cCI6MTc2MjUwMjE1MywiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.DozVM_QHEjNFuLOlnbq6gHs0NJ6i8bGlvqPcjgPvUjw', '2025-11-07 13:25:53', 1, '2025-10-31 07:55:53.678164', '2025-10-31 07:56:05.000000', 4),
(19, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE4OTg5NDYsImV4cCI6MTc2MjUwMzc0NiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.95wOHfWYfovbXubelzc6YqDdH74wu_PWLR1ARTBC9Ss', '2025-11-07 13:52:26', 1, '2025-10-31 08:22:26.014508', '2025-10-31 11:52:14.000000', 4),
(20, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE5MDU1NjIsImV4cCI6MTc2MjUxMDM2MiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.oT10Oa6OL-jviOI_fdxyM-DYsTzcUgz7HmDVkqBnwNA', '2025-11-07 15:42:42', 1, '2025-10-31 10:12:42.682653', '2025-10-31 10:12:48.000000', 3),
(21, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxOTA4NzkzLCJleHAiOjE3NjI1MTM1OTMsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.BPrmyfhdCsZr3W_qj0oSiPGzDRDr7TbFw_g8gPijKjU', '2025-11-07 16:36:33', 1, '2025-10-31 11:06:33.501192', '2025-10-31 11:52:12.000000', 5),
(22, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE5MDg4NjAsImV4cCI6MTc2MjUxMzY2MCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.gfIkuogVJarCg9pZPIJixAFC63HwgaiJxJh1nvQwkn4', '2025-11-07 16:37:40', 1, '2025-10-31 11:07:40.160683', '2025-10-31 11:52:16.000000', 3),
(23, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcl9pZCI6ImFkbWluMDAzIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjE5MTE1MjUsImV4cCI6MTc2MjUxNjMyNSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.T327JjQCSJfw1i8tweMsUigb1bdN2s1Bt8VJQKAws5o', '2025-11-07 17:22:05', 1, '2025-10-31 11:52:05.763064', '2025-11-01 13:33:41.000000', 2),
(24, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwMDQwMTIsImV4cCI6MTc2MjYwODgxMiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.v4-8krvfaqPBWYzap9z9sxfg9GdMwUOPqb0XDDWjHu4', '2025-11-08 19:03:32', 1, '2025-11-01 13:33:32.866760', '2025-11-01 13:33:36.000000', 4),
(25, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwMDU1MzMsImV4cCI6MTc2MjYxMDMzMywiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.Gaf5WqiWnQxxG3kfIBhQZoGBhVabqwXsfGv2PFVwMRg', '2025-11-08 19:28:53', 1, '2025-11-01 13:58:53.018204', '2025-11-01 13:58:55.000000', 4),
(26, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwMDkyNDQsImV4cCI6MTc2MjYxNDA0NCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.E12nfO2kwZiK8nZU80T7TGadX4p-y1wdh8zx6u18Vgg', '2025-11-08 20:30:44', 1, '2025-11-01 15:00:44.612206', '2025-11-01 20:53:08.000000', 4),
(27, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwMzAzODMsImV4cCI6MTc2MjYzNTE4MywiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.rgb8Y9E8prUVPPm66176c3maEUGBFKCqtgRAcbnL1W4', '2025-11-09 02:23:03', 1, '2025-11-01 20:53:03.019928', '2025-11-01 20:53:06.000000', 3),
(28, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwMzM0NzMsImV4cCI6MTc2MjYzODI3MywiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.fIlI-XFT-rMNsv7bVdXtvPUb94K8FzI-HCAZRjvsOH4', '2025-11-09 03:14:33', 1, '2025-11-01 21:44:33.778496', '2025-11-02 09:05:14.000000', 3),
(29, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDcyMTc3LCJleHAiOjE3NjI2NzY5NzcsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.aQuepzD23drE-vm0N7nOdbOvmueuzATQOiMf8PL_v1Q', '2025-11-09 13:59:37', 1, '2025-11-02 08:29:37.586011', '2025-11-02 08:40:51.000000', 5),
(30, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwNzI4NDQsImV4cCI6MTc2MjY3NzY0NCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.81mEBJLHw2ied5oXowX4GVXaIkLYq-oja65nyAN3OZU', '2025-11-09 14:10:44', 1, '2025-11-02 08:40:44.982714', '2025-11-02 09:05:11.000000', 4),
(31, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDcyODU2LCJleHAiOjE3NjI2Nzc2NTYsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.PxUD2QQL9uQIkkNx502ZzWxfoskyZ0Hdpa278q7Eb1o', '2025-11-09 14:10:56', 1, '2025-11-02 08:40:56.180245', '2025-11-02 09:47:08.000000', 5),
(32, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcl9pZCI6ImFkbWluMDAzIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwNzQzMDUsImV4cCI6MTc2MjY3OTEwNSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.maux1_Yq7mskL_IxuLdJYGRb4ZYszJvsMDvo8m14A3E', '2025-11-09 14:35:05', 1, '2025-11-02 09:05:05.757000', '2025-11-02 09:45:51.000000', 2),
(33, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwNzY3NDUsImV4cCI6MTc2MjY4MTU0NSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.5lZimGpIhZPV2KM0C3n_NuZMLadjFYds2YMuMF1Nekk', '2025-11-09 15:15:45', 1, '2025-11-02 09:45:45.153487', '2025-11-02 10:01:07.000000', 4),
(34, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDc2ODM2LCJleHAiOjE3NjI2ODE2MzYsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.LXfIidqKd9KEEZUrLeK2RnE-dGAN4m713D3TOvW5lT4', '2025-11-09 15:17:16', 1, '2025-11-02 09:47:16.205992', '2025-11-02 12:58:58.000000', 5),
(35, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwNzc2NjIsImV4cCI6MTc2MjY4MjQ2MiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.q2GXLDKEZXezdnh-dL4uyA5nzHnw_FYEX4eNw-pZcOM', '2025-11-09 15:31:02', 1, '2025-11-02 10:01:02.201096', '2025-11-02 11:20:02.000000', 3),
(36, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwODIzOTEsImV4cCI6MTc2MjY4NzE5MSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.E5LtE30nZM_wYP53EHHtFbR35L8Se8bXX46BBrE8CeQ', '2025-11-09 16:49:51', 1, '2025-11-02 11:19:51.536467', '2025-11-02 13:02:40.000000', 4),
(37, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwODc1NjAsImV4cCI6MTc2MjY5MjM2MCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.WkWTmtGMF9O1zY_DV0uM-OliBBbG55Zv6xaiJgV3bJ0', '2025-11-09 18:16:00', 1, '2025-11-02 12:46:01.064773', '2025-11-02 13:02:42.000000', 3),
(38, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDg4MzQyLCJleHAiOjE3NjI2OTMxNDIsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.nNtMWrhLRPvxXpVVX8qG4U4vkxr35Ttc-QpXnC3aRvY', '2025-11-09 18:29:02', 1, '2025-11-02 12:59:02.596465', '2025-11-02 14:59:44.000000', 5),
(39, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcl9pZCI6ImFkbWluMDAzIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwODg1NTQsImV4cCI6MTc2MjY5MzM1NCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.9Eq_0ZuN5vG9DZvFhCtjvGGTIUFT-AFWYxtNdXq_8JQ', '2025-11-09 18:32:34', 1, '2025-11-02 13:02:34.017530', '2025-11-02 13:42:24.000000', 2),
(40, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwOTA5MzksImV4cCI6MTc2MjY5NTczOSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.s8W7xLnnaMRg89T36S3kjloMDLyptTNJdGyEAH95j7g', '2025-11-09 19:12:19', 1, '2025-11-02 13:42:19.824708', '2025-11-02 14:59:46.000000', 3),
(41, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkyMjE5LCJleHAiOjE3NjI2OTcwMTksImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.55P3m4cSX-s3-5m9s57_knAj_sxB3rXorIkmxOsq69I', '2025-11-09 19:33:39', 1, '2025-11-02 14:03:39.819319', '2025-11-02 14:59:44.000000', 5),
(42, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkyMjIyLCJleHAiOjE3NjI2OTcwMjIsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.O27ZZuJW2FhUJkJUhKuvMa-uwhEmmkqZrWslCCMBGfs', '2025-11-09 19:33:42', 1, '2025-11-02 14:03:42.958711', '2025-11-02 14:59:44.000000', 5),
(43, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkyMjI0LCJleHAiOjE3NjI2OTcwMjQsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.kfE3tWde2bgrmnkvTB8gKEejaoavD8TBLAVwhEW2DBk', '2025-11-09 19:33:44', 1, '2025-11-02 14:03:44.378761', '2025-11-02 14:59:44.000000', 5),
(44, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkyMjI1LCJleHAiOjE3NjI2OTcwMjUsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.X2X_DDBbeNUC_RbjbJuogPWb6Dqgo7W-Mvalnr_CuOo', '2025-11-09 19:33:45', 1, '2025-11-02 14:03:45.447954', '2025-11-02 14:59:44.000000', 5),
(45, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkyMjI4LCJleHAiOjE3NjI2OTcwMjgsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.KSjBZnKIdz0tO9ZuqOvKGG0TUwH2IkEfW7xOr0v9bYI', '2025-11-09 19:33:48', 1, '2025-11-02 14:03:48.455265', '2025-11-02 14:59:44.000000', 5),
(46, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkyMjMwLCJleHAiOjE3NjI2OTcwMzAsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.5Fq79nqb7SYz36g3JRh8qwcHFh1FNOo4vioFqHQMO9g', '2025-11-09 19:33:50', 1, '2025-11-02 14:03:50.024315', '2025-11-02 14:59:44.000000', 5),
(47, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkyNTM1LCJleHAiOjE3NjI2OTczMzUsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.Tl-sJx35c-ZpawTeTVYZbzWGb8CO-m4VyP-QRlZsw1k', '2025-11-09 19:38:55', 1, '2025-11-02 14:08:55.293938', '2025-11-02 14:59:44.000000', 5),
(48, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkzODIzLCJleHAiOjE3NjI2OTg2MjMsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.3tQket-7EraYFJyYvRPzmmjwSdaihXlFZ6SVSsrTIU0', '2025-11-09 20:00:23', 1, '2025-11-02 14:30:23.114537', '2025-11-02 14:59:44.000000', 5),
(49, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDkzODI0LCJleHAiOjE3NjI2OTg2MjQsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.GC4eYVojI-z1nIAsd18-H4TFLMW6CyHmCTPToMFub3I', '2025-11-09 20:00:24', 1, '2025-11-02 14:30:24.916156', '2025-11-02 14:59:44.000000', 5),
(50, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIwOTU1NzksImV4cCI6MTc2MjcwMDM3OSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.pRNtmXr1AqaRQazQWREbLtR9WpH_fx9hxZPW7V_0XgM', '2025-11-09 20:29:39', 1, '2025-11-02 14:59:39.223528', '2025-11-02 19:33:09.000000', 4),
(51, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMDk1ODcyLCJleHAiOjE3NjI3MDA2NzIsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.ozjC9N3HANJkLLenabsndHmgpfy6kC-DtcJ40OIqwj4', '2025-11-09 20:34:32', 1, '2025-11-02 15:04:32.496695', '2025-11-02 19:32:31.000000', 5),
(53, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMDQ3MTcsImV4cCI6MTc2MjcwOTUxNywiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.MXi6CAg-iTJ6u40k0cjiRPpxvKtbMjzDHTJYvKvigwE', '2025-11-09 23:01:57', 1, '2025-11-02 17:31:57.682310', '2025-11-02 19:33:09.000000', 4),
(56, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMTE5ODUsImV4cCI6MTc2MjcxNjc4NSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.I3I8VNqzcmOXiESE4bWwz0Ocra8K5tFp0R3yniIQBNs', '2025-11-10 01:03:05', 1, '2025-11-02 19:33:05.718062', '2025-11-02 19:33:09.000000', 4),
(57, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMTM3NDUsImV4cCI6MTc2MjcxODU0NSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.a4k2Wio1aDd1LJP0yYnee8TF9vwnHgS9omwkKQE8eXs', '2025-11-10 01:32:25', 1, '2025-11-02 20:02:25.899239', '2025-11-02 20:03:00.000000', 4),
(58, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMTM3ODAsImV4cCI6MTc2MjcxODU4MCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.wOie3gQDhnwo3irXvlEvX9Cbn-QAmnMRV1M4iQW0o3k', '2025-11-10 01:33:00', 1, '2025-11-02 20:03:00.941226', '2025-11-02 20:11:10.000000', 4),
(59, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMTQyNzAsImV4cCI6MTc2MjcxOTA3MCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.hBQbst4Yxv3uMO-fyswpW4qZljje4L9hDc6UoUJEigM', '2025-11-10 01:41:10', 1, '2025-11-02 20:11:10.706869', '2025-11-02 20:11:23.000000', 4),
(60, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMTQyODMsImV4cCI6MTc2MjcxOTA4MywiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.xYmXqaQKhyv3JPpO-C-bZhsufC3rKPgU6rxaYOx2-GA', '2025-11-10 01:41:23', 1, '2025-11-02 20:11:23.640054', '2025-11-02 20:20:41.000000', 4),
(61, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMTE0MzE0LCJleHAiOjE3NjI3MTkxMTQsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.Ez_4CXZ3iD8t0Btn9mJH6dnIcg7k654Cq4DtUYXPGeU', '2025-11-10 01:41:54', 1, '2025-11-02 20:11:54.965506', '2025-11-02 21:22:16.000000', 5),
(62, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywidXNlcl9pZCI6ImFkbWluMDAyIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMTQzNTUsImV4cCI6MTc2MjcxOTE1NSwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.6bi1eiDO3znpL6QFecUUk_G7lXBb8K_oxojHSsGfsLw', '2025-11-10 01:42:35', 0, '2025-11-02 20:12:35.014358', '2025-11-02 20:12:35.014358', 3),
(63, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMTQ4NDIsImV4cCI6MTc2MjcxOTY0MiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.2zvAthEcU4YJ3BV8ik9SG7I09fGAx-iCzlLNtXU_8EM', '2025-11-10 01:50:42', 1, '2025-11-02 20:20:42.032925', '2025-11-02 22:35:52.000000', 4),
(64, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMTE4NTM5LCJleHAiOjE3NjI3MjMzMzksImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.olKSLKBW8aSv7xe--WAAkH8OC_8KD23BfFdT2HL70kk', '2025-11-10 02:52:19', 1, '2025-11-02 21:22:19.644964', '2025-11-02 23:03:31.000000', 5),
(65, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxMjI5NTIsImV4cCI6MTc2MjcyNzc1MiwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.F6BXgE5furQrjRogi8vHDY0W37g6gwYmEUqR-p1e8B0', '2025-11-10 04:05:52', 1, '2025-11-02 22:35:52.156595', '2025-11-03 06:13:18.000000', 4),
(66, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMTI0NjE0LCJleHAiOjE3NjI3Mjk0MTQsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.1R_pC4v1gCoPHMHctRRBXceAyMooX_EMU5KHsTU8KF4', '2025-11-10 04:33:34', 1, '2025-11-02 23:03:34.864264', '2025-11-03 06:16:37.000000', 5),
(67, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxNTAzOTgsImV4cCI6MTc2Mjc1NTE5OCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.u9qNb_TWBydB9-6uCEC7I4HpQ-3Lr6_T31jYk2HoRUs', '2025-11-10 11:43:18', 1, '2025-11-03 06:13:18.375953', '2025-11-03 08:15:20.000000', 4),
(68, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMTUwNjYxLCJleHAiOjE3NjI3NTU0NjEsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.eoChUqj5GE2Q1e11uM6mlk4mlEAp66g_ASr3gemB-wc', '2025-11-10 11:47:41', 1, '2025-11-03 06:17:41.581671', '2025-11-03 07:29:30.000000', 5),
(69, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMTU0OTc3LCJleHAiOjE3NjI3NTk3NzcsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.vkmJVeYMc6dMdmyoq6kx0sZ_tX3fEPACmTUGUmpUeSI', '2025-11-10 12:59:37', 1, '2025-11-03 07:29:37.794581', '2025-11-03 07:33:50.000000', 5),
(70, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl9pZCI6InBsYXllcjAwMSIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMTU1MjM0LCJleHAiOjE3NjI3NjAwMzQsImF1ZCI6InlvdXItYXBwLXVzZXJzIiwiaXNzIjoieW91ci1hcHAtbmFtZSJ9.QvKja9HrUrtZisOxVF5RfEG9AlhQl2eZCDjPKn02VhE', '2025-11-10 13:03:54', 0, '2025-11-03 07:33:54.124582', '2025-11-03 07:33:54.124582', 5),
(71, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwidXNlcl9pZCI6ImFkbWluMDAxIiwidHlwZSI6InJlZnJlc2giLCJpYXQiOjE3NjIxNTc3MjAsImV4cCI6MTc2Mjc2MjUyMCwiYXVkIjoieW91ci1hcHAtdXNlcnMiLCJpc3MiOiJ5b3VyLWFwcC1uYW1lIn0.-M89ybAbkM8v1Wko2Mz4SbypWdRhf0IkU1NxR7lrdck', '2025-11-10 13:45:20', 0, '2025-11-03 08:15:20.504954', '2025-11-03 08:15:20.504954', 4);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `isActive` tinyint(4) NOT NULL DEFAULT 1,
  `createdAt` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updatedAt` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `isActive`, `createdAt`, `updatedAt`) VALUES
(1, 'Admin', 'Admin role', 1, '2025-10-30 08:28:30.491921', '2025-10-30 08:28:30.491921'),
(2, 'Moderator', 'Moderator role', 1, '2025-10-30 08:28:30.508578', '2025-10-30 08:28:30.508578'),
(3, 'Player', 'Player role', 1, '2025-10-30 08:28:30.521574', '2025-10-30 08:28:30.521574');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `description`, `created_at`, `updated_at`) VALUES
(1, 'game_multiplier', '10', 'Multiplier for winnings or scoring', '2025-11-01 20:55:23', '2025-11-02 09:05:31'),
(2, 'maximum_limit', '5000', 'Maximum bet amount per card', '2025-11-01 20:55:23', '2025-11-01 20:55:23'),
(3, 'game_start_time', '08:00', 'When the game opens (HH:MM format)', '2025-11-01 20:55:23', '2025-11-03 06:13:52'),
(4, 'game_end_time', '22:00', 'When the game closes (HH:MM format)', '2025-11-01 20:55:23', '2025-11-02 20:13:38'),
(5, 'game_result_type', 'manual', 'Auto-generated or manually set game results', '2025-11-01 20:55:23', '2025-11-02 21:09:02');

-- --------------------------------------------------------

--
-- Table structure for table `settings_logs`
--

CREATE TABLE `settings_logs` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `previous_value` text DEFAULT NULL,
  `new_value` text NOT NULL,
  `admin_id` int(11) NOT NULL,
  `admin_user_id` varchar(100) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `settings_logs`
--

INSERT INTO `settings_logs` (`id`, `setting_key`, `previous_value`, `new_value`, `admin_id`, `admin_user_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 'game_multiplier', NULL, '10', 3, 'admin002', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:34'),
(2, 'maximum_limit', NULL, '5000', 3, 'admin002', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:34'),
(3, 'game_start_time', NULL, '08:00', 3, 'admin002', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:34'),
(4, 'game_end_time', NULL, '22:00', 3, 'admin002', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:34'),
(5, 'game_result_type', NULL, 'manual', 3, 'admin002', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-01 20:53:34'),
(6, 'game_multiplier', '11', '10', 2, 'admin003', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:05:31'),
(7, 'game_result_type', 'manual', 'auto', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 09:48:29'),
(8, 'game_result_type', 'auto', 'manual', 3, 'admin002', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 13:42:50'),
(9, 'game_result_type', 'manual', 'auto', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 15:05:26'),
(10, 'game_end_time', '22:00', '23:55', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-11-02 17:10:13'),
(11, 'game_result_type', 'auto', 'manual', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', '2025-11-02 19:37:42'),
(12, 'game_start_time', '08:00', '01:00', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:13:38'),
(13, 'game_end_time', '23:55', '22:00', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:13:38'),
(14, 'game_result_type', 'manual', 'auto', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 20:27:14'),
(15, 'game_result_type', 'auto', 'manual', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-02 21:09:02'),
(16, 'game_start_time', '01:00', '08:00', 4, 'admin001', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-03 06:13:52');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `alternate_mobile` varchar(15) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pin_code` varchar(10) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `status` enum('active','inactive','banned') NOT NULL DEFAULT 'active',
  `deposit_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `profile_pic` varchar(255) DEFAULT NULL,
  `password_hash` text NOT NULL,
  `password_salt` text NOT NULL,
  `user_type` enum('player','admin','moderator') NOT NULL DEFAULT 'player',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_login` datetime DEFAULT NULL,
  `email_verified` tinyint(4) NOT NULL DEFAULT 0,
  `mobile_verified` tinyint(4) NOT NULL DEFAULT 0,
  `is_email_verified_by_admin` tinyint(4) NOT NULL DEFAULT 0,
  `is_mobile_verified_by_admin` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_id`, `first_name`, `last_name`, `mobile`, `alternate_mobile`, `email`, `address`, `city`, `state`, `pin_code`, `region`, `status`, `deposit_amount`, `profile_pic`, `password_hash`, `password_salt`, `user_type`, `created_at`, `updated_at`, `last_login`, `email_verified`, `mobile_verified`, `is_email_verified_by_admin`, `is_mobile_verified_by_admin`) VALUES
(1, 'admin004', 'Admin', 'User', '98765432104', '1234567890', 'admin4@kismatx.com', 'Admin Office', 'Delhi', 'Delhi', '110001', 'North', 'active', 0.00, NULL, '$2b$12$B2cpS9pP33B.7lKjtr6yLu3KEK0j76dbNawuLxRrrhbZTQ9wW3dXu', '$2b$12$TWqFaJUPbZ3lpuDZpm81o.', 'admin', '2025-10-30 08:28:30', '2025-10-30 08:28:30', NULL, 0, 0, 0, 0),
(2, 'admin003', 'Admin', 'User', '9876543210', '1234567890', 'admin3@kismatx.com', 'Admin Office', 'Delhi', 'Delhi', '110001', 'North', 'active', 0.00, NULL, '$2b$12$2Er6cgnzAjcFFKHfUoy7dOBSeFFDb4nfV4d1CAq8RuV4Zf0lljHza', '$2b$12$fAxd2qRa/rblgJS0l3Dh0O', 'admin', '2025-10-30 08:28:47', '2025-11-02 13:02:34', '2025-11-02 18:32:34', 0, 0, 0, 0),
(3, 'admin002', 'Admin', 'User', '98765432102', '1234567890', 'admin2@kismatx.com', 'Admin Office', 'Delhi', 'Delhi', '110001', 'North', 'active', 0.00, NULL, '$2b$12$GWeg544/i2OmF1ElPAfDC.Ep4f4m6bnAt0NLrKj6WIcQjwPbWoVy.', '$2b$12$fVbpTUGYEaJO/s3jDFUR2u', 'admin', '2025-10-30 08:28:58', '2025-11-02 20:12:34', '2025-11-03 01:42:34', 0, 0, 0, 0),
(4, 'admin001', 'Admin', 'User', '98765432101', '1234567890', 'admin1@kismatx.com', 'Admin Office', 'Delhi', 'Delhi', '110001', 'North', 'active', 0.00, NULL, '$2b$12$vsT143MKs4TSs40sxIIH4eRA8WBouukPdENo7.iHZRCsE/DAZw3O.', '$2b$12$RJpE.VDy8POmvrot7mKdWe', 'admin', '2025-10-30 08:29:14', '2025-11-03 08:15:20', '2025-11-03 13:45:20', 0, 0, 0, 0),
(5, 'player001', 'Player', 'One', '1234567890', '9876543210', 'john.doe@example.com', '123 Gaming Street', 'Mumbai', 'Maharashtra', '400001', 'West', 'active', 40950.00, NULL, '$2b$12$GNIxW4aVvB09HknqCVnYhuMhmMDe8N.kVKJe7eBvVekwLUBevj5aO', '$2b$12$SHGrzi4cadxShCeJE.8VRe', 'player', '2025-10-30 08:29:52', '2025-11-03 08:25:45', '2025-11-03 13:03:54', 0, 0, 0, 0),
(6, 'player002', 'John', 'Doe', '12345678902', '9876543210', 'john.doe2@example.com', '123 Gaming Street', 'Mumbai', 'Maharashtra', '400001', 'West', 'active', 50500.50, NULL, '$2b$12$MwV8TbhIlU6rZ0ITBpVrPuDOKpUDIhG0K9n/pj4SfOZEjN0xLrpQm', '$2b$12$I4SfNtty8kjJhlUR.BdCKu', 'player', '2025-10-30 08:30:11', '2025-11-03 07:30:31', NULL, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 3),
(6, 3);

-- --------------------------------------------------------

--
-- Table structure for table `wallet_logs`
--

CREATE TABLE `wallet_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `transaction_type` enum('recharge','withdrawal','game') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `transaction_direction` enum('credit','debit') NOT NULL,
  `game_id` int(11) DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `reference_type` varchar(50) DEFAULT NULL COMMENT 'bet_placement, settlement, claim',
  `reference_id` varchar(255) DEFAULT NULL COMMENT 'slip_id or game_id',
  `status` enum('pending','completed','failed') NOT NULL DEFAULT 'completed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `wallet_logs`
--

INSERT INTO `wallet_logs` (`id`, `user_id`, `transaction_type`, `amount`, `transaction_direction`, `game_id`, `comment`, `created_at`, `reference_type`, `reference_id`, `status`) VALUES
(1, 6, 'withdrawal', 10.00, 'debit', NULL, 'test', '2025-10-30 10:44:57', NULL, NULL, 'completed'),
(2, 6, 'recharge', 10.00, 'credit', NULL, 'Credited by admin', '2025-10-30 10:45:57', NULL, NULL, 'completed'),
(3, 6, 'recharge', 500.00, 'credit', NULL, 'Credited by admin', '2025-10-30 11:01:10', NULL, NULL, 'completed'),
(4, 6, 'withdrawal', 250.00, 'debit', NULL, 'User withdrawal', '2025-10-30 11:02:19', NULL, NULL, 'completed'),
(5, 5, 'recharge', 49.50, 'credit', NULL, 'Credited by admin', '2025-10-30 11:08:33', NULL, NULL, 'completed'),
(6, 5, 'recharge', 200.00, 'credit', NULL, 'Credited by admin', '2025-10-31 07:58:13', NULL, NULL, 'completed'),
(7, 5, 'recharge', 200.00, 'credit', NULL, 't', '2025-10-31 07:59:15', NULL, NULL, 'completed'),
(8, 5, 'recharge', 300.00, 'credit', NULL, 'Credited by admin', '2025-11-01 21:44:50', NULL, NULL, 'completed'),
(9, 5, 'game', 250.00, 'debit', NULL, 'Bet placed on game 202511021410', '2025-11-02 14:11:59', 'bet_placement', '4ef83c66-f387-4931-928d-69ac9045ee59', 'completed'),
(10, 5, 'game', 250.00, 'debit', NULL, 'Bet placed on game 202511021515', '2025-11-02 15:17:20', 'bet_placement', '128c3cf6-4ba7-4c2d-8f02-bde3eba584ed', 'completed'),
(11, 5, 'game', 250.00, 'debit', NULL, 'Bet placed on game 202511021515', '2025-11-02 15:17:30', 'bet_placement', 'd73a84af-c050-45f7-9c12-0fbac39ee93d', 'completed'),
(12, 5, 'recharge', 50000.00, 'credit', NULL, 'Credited by admin', '2025-11-02 13:02:59', NULL, NULL, 'completed'),
(13, 5, 'game', 1750.00, 'debit', NULL, 'Bet placed on game 202511021830', '2025-11-02 18:33:05', 'bet_placement', 'f76365fc-20e4-45d0-868d-309d8fa63d19', 'completed'),
(14, 5, 'game', 1750.00, 'debit', NULL, 'Bet placed on game 202511022035', '2025-11-02 20:35:15', 'bet_placement', '5186b4d7-8c7d-46e7-befc-0aa7ff078c8c', 'completed'),
(15, 5, 'recharge', 350.00, 'credit', NULL, 'Credited by admin', '2025-11-02 20:03:48', NULL, NULL, 'completed'),
(16, 5, 'game', 1750.00, 'debit', NULL, 'Bet placed on game 202511030145', '2025-11-03 01:45:40', 'bet_placement', 'dc3ea382-455d-4dec-912f-9c6bb7a1b858', 'completed'),
(17, 5, 'game', 1750.00, 'debit', NULL, 'Bet placed on game 202511030255', '2025-11-03 02:56:04', 'bet_placement', 'dadd1175-453b-4d1e-8305-048274ed945f', 'completed'),
(18, 5, 'game', 300.00, 'debit', NULL, 'Bet placed on game 202511030430', '2025-11-03 04:33:50', 'bet_placement', 'a48bcf1b-ea7e-4cfa-bd33-c240a450d833', 'completed'),
(19, 5, 'game', 100.00, 'debit', NULL, 'Bet placed on game 202511030430', '2025-11-03 04:34:28', 'bet_placement', '160dc182-5b9a-4608-b90a-e1594da13b62', 'completed'),
(20, 5, 'game', 300.00, 'debit', NULL, 'Bet placed on game 202511030430', '2025-11-03 04:34:36', 'bet_placement', '0c451954-255c-4d6f-88a7-1a25f3cba7b3', 'completed'),
(21, 5, 'game', 250.00, 'debit', NULL, 'Bet placed on game 202511030435', '2025-11-03 04:36:49', 'bet_placement', '0331908e-033e-4b9d-bbf0-75c9fe6fad49', 'completed'),
(22, 5, 'game', 1000.00, 'credit', NULL, 'Winnings claimed for slip dc3ea382-455d-4dec-912f-9c6bb7a1b858 (GAME_202511030145_DC3EA382_1D), Game: 202511030145', '2025-11-03 05:05:49', 'claim', 'dc3ea382-455d-4dec-912f-9c6bb7a1b858', 'completed'),
(24, 5, 'game', 300.00, 'debit', NULL, 'Bet placed on game 202511031145', '2025-11-03 11:49:53', 'bet_placement', '4c1c41d8-adf5-4955-80ce-0f2815e5567b', 'completed'),
(25, 5, 'game', 300.00, 'debit', NULL, 'Bet placed on game 202511031210', '2025-11-03 12:14:42', 'bet_placement', '0b8b6f1f-aa32-4d5e-b9f5-6ab1620f5877', 'completed'),
(26, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031215', '2025-11-03 12:19:50', 'bet_placement', '828681db-bc6a-4f81-adf6-aae486855346', 'completed'),
(27, 5, 'game', 400.00, 'credit', NULL, 'Winnings claimed for slip 828681db-bc6a-4f81-adf6-aae486855346 (GAME_202511031215_828681DB_26), Game: 202511031215', '2025-11-03 12:20:19', 'claim', '828681db-bc6a-4f81-adf6-aae486855346', 'completed'),
(28, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031220', '2025-11-03 12:23:59', 'bet_placement', '2724fbf3-eb59-4587-8347-e37521a3fb24', 'completed'),
(29, 5, 'game', 580.00, 'credit', NULL, 'Refund for cancelled slip 2724fbf3-eb59-4587-8347-e37521a3fb24 (GAME_202511031220_2724FBF3_60), Game: 202511031220. Reason: Change of mind', '2025-11-03 12:24:43', 'cancellation', '2724fbf3-eb59-4587-8347-e37521a3fb24', 'completed'),
(30, 5, 'game', 100.00, 'credit', NULL, 'Winnings claimed for slip 2724fbf3-eb59-4587-8347-e37521a3fb24 (GAME_202511031220_2724FBF3_60), Game: 202511031220', '2025-11-03 12:25:22', 'claim', '2724fbf3-eb59-4587-8347-e37521a3fb24', 'completed'),
(31, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031235', '2025-11-03 12:35:15', 'bet_placement', 'f37c410f-4776-4de7-9111-f46f5baec571', 'completed'),
(32, 5, 'game', 580.00, 'credit', NULL, 'Refund for cancelled slip f37c410f-4776-4de7-9111-f46f5baec571 (GAME_202511031235_F37C410F_27), Game: 202511031235. Reason: Change of mind', '2025-11-03 12:35:25', 'cancellation', 'f37c410f-4776-4de7-9111-f46f5baec571', 'completed'),
(33, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031235', '2025-11-03 12:39:41', 'bet_placement', '5c52ec5f-db7a-468c-add6-5430dfeccf97', 'completed'),
(34, 5, 'game', 580.00, 'credit', NULL, 'Refund for cancelled slip 5c52ec5f-db7a-468c-add6-5430dfeccf97 (GAME_202511031235_5C52EC5F_7B), Game: 202511031235. Reason: Change of mind', '2025-11-03 12:39:54', 'cancellation', '5c52ec5f-db7a-468c-add6-5430dfeccf97', 'completed'),
(35, 6, 'recharge', 50000.00, 'credit', NULL, 'Credited by admin', '2025-11-03 07:30:31', NULL, NULL, 'completed'),
(36, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031300', '2025-11-03 13:04:00', 'bet_placement', '3fdc2ee8-0cd3-4e89-983a-8c995ed7887d', 'completed'),
(37, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031300', '2025-11-03 13:04:34', 'bet_placement', 'f0fef7e7-c1b5-444e-8337-7aa9b5bfa0ec', 'completed'),
(38, 5, 'game', 200.00, 'credit', NULL, 'Winnings claimed for slip f0fef7e7-c1b5-444e-8337-7aa9b5bfa0ec (GAME_202511031300_F0FEF7E7_DE), Game: 202511031300', '2025-11-03 13:05:40', 'claim', 'f0fef7e7-c1b5-444e-8337-7aa9b5bfa0ec', 'completed'),
(39, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031305', '2025-11-03 13:06:01', 'bet_placement', 'd149b0b2-2af4-421e-95ec-f12904b9822a', 'completed'),
(40, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031305', '2025-11-03 13:06:51', 'bet_placement', '6a9ffffd-926e-4995-8641-3f69e8d66ba9', 'completed'),
(41, 5, 'game', 580.00, 'credit', NULL, 'Refund for cancelled slip 6a9ffffd-926e-4995-8641-3f69e8d66ba9 (GAME_202511031305_6A9FFFFD_8B), Game: 202511031305. Reason: Change of mind', '2025-11-03 13:07:01', 'cancellation', '6a9ffffd-926e-4995-8641-3f69e8d66ba9', 'completed'),
(42, 5, 'game', 580.00, 'debit', NULL, 'Bet placed on game 202511031350', '2025-11-03 13:54:07', 'bet_placement', '8873e639-655c-4fd4-a9cd-d1002cbe03e7', 'completed'),
(43, 5, 'game', 100.00, 'credit', NULL, 'Winnings claimed for slip 8873e639-655c-4fd4-a9cd-d1002cbe03e7 (GAME_202511031350_8873E639_9B), Game: 202511031350', '2025-11-03 13:55:45', 'claim', '8873e639-655c-4fd4-a9cd-d1002cbe03e7', 'completed');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bet_details`
--
ALTER TABLE `bet_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_game_card` (`game_id`,`card_number`),
  ADD KEY `idx_game_winner` (`game_id`,`is_winner`),
  ADD KEY `idx_slip` (`slip_id`);

--
-- Indexes for table `bet_slips`
--
ALTER TABLE `bet_slips`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_5f234d60a8851fc180a1eafa04` (`slip_id`),
  ADD UNIQUE KEY `IDX_cade00d17ff0016f0b92c3715d` (`barcode`),
  ADD UNIQUE KEY `IDX_ce29b83681875a975827c54fba` (`idempotency_key`),
  ADD KEY `idx_user_game` (`user_id`,`game_id`),
  ADD KEY `idx_claim` (`game_id`,`claimed`),
  ADD KEY `idx_idempotency` (`idempotency_key`),
  ADD KEY `idx_barcode` (`barcode`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_00f32d6507b00b23b8cd327fba` (`game_id`),
  ADD KEY `idx_settlement` (`settlement_status`,`game_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_time_range` (`start_time`,`end_time`);

--
-- Indexes for table `game_card_totals`
--
ALTER TABLE `game_card_totals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login_history`
--
ALTER TABLE `login_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_48ce552495d14eae9b187bb671` (`name`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_4542dd2f38a61354a040ba9fd5` (`token`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_648e3f5447f725579d7d4ffdfb` (`name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `IDX_178199805b901ccd220ab7740e` (`role_id`),
  ADD KEY `IDX_17022daf3f885f7d35423e9971` (`permission_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_settings_key` (`key`),
  ADD UNIQUE KEY `IDX_c8639b7626fa94ba8265628f21` (`key`);

--
-- Indexes for table `settings_logs`
--
ALTER TABLE `settings_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_settings_logs_setting_key` (`setting_key`),
  ADD KEY `IDX_settings_logs_admin_id` (`admin_id`),
  ADD KEY `IDX_settings_logs_created_at` (`created_at`),
  ADD KEY `IDX_settings_logs_key_created` (`setting_key`,`created_at`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `IDX_96aac72f1574b88752e9fb0008` (`user_id`),
  ADD UNIQUE KEY `IDX_d376a9f93bba651f32a2c03a7d` (`mobile`),
  ADD UNIQUE KEY `IDX_97672ac88f789774dd47f7c8be` (`email`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `IDX_87b8888186ca9769c960e92687` (`user_id`),
  ADD KEY `IDX_b23c65e50a758245a33ee35fda` (`role_id`);

--
-- Indexes for table `wallet_logs`
--
ALTER TABLE `wallet_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_wallet_logs_user_id` (`user_id`),
  ADD KEY `IDX_wallet_logs_transaction_type` (`transaction_type`),
  ADD KEY `IDX_wallet_logs_created_at` (`created_at`),
  ADD KEY `IDX_wallet_logs_user_created` (`user_id`,`created_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=347;

--
-- AUTO_INCREMENT for table `bet_details`
--
ALTER TABLE `bet_details`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=181;

--
-- AUTO_INCREMENT for table `bet_slips`
--
ALTER TABLE `bet_slips`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=168;

--
-- AUTO_INCREMENT for table `game_card_totals`
--
ALTER TABLE `game_card_totals`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=140;

--
-- AUTO_INCREMENT for table `login_history`
--
ALTER TABLE `login_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=171;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `settings_logs`
--
ALTER TABLE `settings_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `wallet_logs`
--
ALTER TABLE `wallet_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
