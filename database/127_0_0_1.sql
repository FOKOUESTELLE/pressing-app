-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 12 nov. 2026 à 15:32
-- Version du serveur : 8.4.7
-- Version de PHP : 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `pressing-app`
--
CREATE DATABASE IF NOT EXISTS `pressing-app` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pressing-app`;

-- --------------------------------------------------------

--
-- Structure de la table `cache`
--

DROP TABLE IF EXISTS `cache`;
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int UNSIGNED NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `actif` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `categories`
--

INSERT INTO `categories` (`id`, `name`, `price`, `description`, `created_at`, `updated_at`, `deleted_at`, `actif`) VALUES
(1, 'Chemises', 500, 'Catégorie de test pour PressingPro', '2026-10-23 08:33:31', '2026-10-30 12:15:49', NULL, 1),
(2, 'Rideaux', 1300, 'Lavage des rideaux pour decoration 1200 f la piece', '2026-10-30 11:27:31', '2026-11-07 13:04:32', NULL, 1),
(3, 'Veste', 1500, 'lavage des vestes', '2026-10-30 11:28:36', '2026-11-02 17:48:12', NULL, 1),
(4, 'T-shirts', 704, 'lavage des T-shirts', '2026-10-30 11:29:26', '2026-10-30 12:04:27', NULL, 1),
(5, 'Chemise', 500, 'Lavage des chemises', '2026-10-30 12:17:51', '2026-11-07 12:35:34', NULL, 1),
(14, 'draps', 1000, 'lavage des draps', '2026-11-07 13:20:35', '2026-11-07 13:21:01', NULL, 1),
(10, 'Jean', 1000, 'ertyui', '2026-11-02 17:54:30', '2026-11-07 12:35:55', NULL, 1),
(12, 'Pull', 1000, 'Lavage des pulls', '2026-11-03 09:05:36', '2026-11-03 09:05:36', NULL, 1),
(13, 'Pantalons', 500, 'Lavage de pantalons', '2026-11-06 10:00:05', '2026-11-06 10:00:05', NULL, 1);

-- --------------------------------------------------------

--
-- Structure de la table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_10_02_124455_create_categories_table', 1),
(5, '2026_10_02_130454_create_orders_table', 1),
(6, '2026_10_02_131000_create_order_items_table', 1),
(7, '2026_10_02_132746_create_missions_table', 1),
(8, '2026_10_02_133327_create_payments_table', 1),
(9, '2026_10_02_133846_create_receipts_table', 1),
(10, '2026_10_02_152118_create_personal_access_tokens_table', 1),
(11, '2026_10_08_125844_create_order_counters_table', 1),
(12, '2026_10_23_100249_add_manager_id_to_orders_table', 2),
(13, '2026_10_23_112957_add_recap_status_to_orders_table', 3),
(14, '2026_10_23_122539_add_correction_message_to_orders_table', 4),
(15, '2026_11_03_100818_add_actif_to_categories_table', 5),
(17, '2026_11_04_095730_remove_unique_from_payment_id_in_receipts_table', 6),
(18, '2026_11_11_104833_create_notifications_table', 6),
(19, '2026_11_12_143035_create_password_reset_tokens_table', 6);

-- --------------------------------------------------------

--
-- Structure de la table `missions`
--

DROP TABLE IF EXISTS `missions`;
CREATE TABLE IF NOT EXISTS `missions` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` enum('PICKUP','DELIVERY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `assigned_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `coursier_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `missions_order_id_foreign` (`order_id`),
  KEY `missions_coursier_id_foreign` (`coursier_id`),
  KEY `missions_status_index` (`status`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `missions`
--

INSERT INTO `missions` (`id`, `type`, `status`, `assigned_at`, `completed_at`, `address`, `order_id`, `coursier_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'PICKUP', 'PENDING', '2026-10-31 10:42:10', NULL, 'Douala, commande test correction', 5, 25, '2026-10-31 09:42:10', '2026-10-31 10:45:49', '2026-10-31 10:45:49'),
(2, 'PICKUP', 'PENDING', '2026-10-31 11:04:41', NULL, 'Douala, deuxième commande test', 2, 25, '2026-10-31 10:04:41', '2026-10-31 10:56:37', '2026-10-31 10:56:37'),
(3, 'PICKUP', 'PENDING', '2026-10-31 11:56:49', NULL, 'Douala, deuxième commande test', 2, 25, '2026-10-31 10:56:49', '2026-10-31 10:56:49', NULL),
(4, 'PICKUP', 'COMPLETED', '2026-10-31 11:56:58', '2026-11-05 09:35:05', 'Douala, troisieme commande test', 3, 25, '2026-10-31 10:56:58', '2026-11-05 08:35:05', NULL),
(5, 'PICKUP', 'PENDING', '2026-10-31 11:57:13', NULL, 'Douala, commande test correction', 5, 25, '2026-10-31 10:57:13', '2026-10-31 10:57:13', NULL),
(6, 'PICKUP', 'CANCELLED', '2026-11-03 14:02:19', NULL, 'bonapriso', 15, 25, '2026-11-03 13:02:19', '2026-11-03 13:37:21', NULL),
(7, 'DELIVERY', 'CANCELLED', '2026-11-03 14:08:04', NULL, 'akwa', 15, 25, '2026-11-03 13:08:04', '2026-11-03 13:26:01', NULL),
(8, 'DELIVERY', 'IN_PROGRESS', '2026-11-03 14:42:40', NULL, 'akwa', 13, 25, '2026-11-03 13:42:40', '2026-11-06 15:23:24', NULL),
(9, 'PICKUP', 'COMPLETED', '2026-11-03 14:57:47', '2026-11-06 16:20:05', 'Akwa', 20, 25, '2026-11-03 13:57:47', '2026-11-06 15:20:05', NULL),
(10, 'PICKUP', 'CANCELLED', '2026-11-04 17:28:11', NULL, 'bali', 14, 25, '2026-11-04 16:28:11', '2026-11-06 15:21:18', NULL),
(11, 'PICKUP', 'PENDING', '2026-11-06 16:27:44', NULL, 'Akwa', 22, 25, '2026-11-06 15:27:44', '2026-11-06 15:27:44', NULL),
(12, 'PICKUP', 'COMPLETED', '2026-11-11 14:13:37', '2026-11-11 14:42:59', 'akwa', 25, 33, '2026-11-11 13:13:37', '2026-11-11 13:42:59', NULL),
(13, 'PICKUP', 'IN_PROGRESS', '2026-11-11 15:29:48', NULL, 'bali', 27, 33, '2026-11-11 14:29:48', '2026-11-11 14:30:40', NULL),
(14, 'DELIVERY', 'AWAITING_CONFIRMATION', '2026-11-12 11:21:24', NULL, 'bali', 27, 33, '2026-11-12 10:21:24', '2026-11-12 10:32:34', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint UNSIGNED NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('1e12f967-310e-49a2-b00b-b0b53c7ca522', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 1, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":24,\"order_number\":\"CMD-20261111-000024\"}}', NULL, '2026-11-11 10:15:43', '2026-11-11 10:15:43'),
('24e691b0-3f98-447c-8298-b4f24b8cf5ca', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 23, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":24,\"order_number\":\"CMD-20261111-000024\"}}', NULL, '2026-11-11 10:15:43', '2026-11-11 10:15:43'),
('8903c504-2594-4dd8-a059-b79b4d9b4a45', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 30, '{\"titre\":\"R\\u00e9capitulatif disponible\",\"message\":\"Le r\\u00e9capitulatif de votre commande est pr\\u00eat. Veuillez le consulter et le confirmer.\",\"type\":\"RECAP_SENT\",\"donnees\":{\"order_id\":25,\"order_number\":\"CMD-20261111-000025\"}}', '2026-11-11 11:10:39', '2026-11-11 11:09:44', '2026-11-11 11:10:39'),
('f2e9f900-fa27-463f-961c-f64348713166', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 29, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":24,\"order_number\":\"CMD-20261111-000024\"}}', NULL, '2026-11-11 10:15:43', '2026-11-11 10:15:43'),
('472421d7-25ca-44c2-ae85-4d6e8ccb2422', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 1, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":25,\"order_number\":\"CMD-20261111-000025\"}}', NULL, '2026-11-11 11:06:36', '2026-11-11 11:06:36'),
('c9cb32c3-8f81-445e-a45d-1df76fe5e468', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 23, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":25,\"order_number\":\"CMD-20261111-000025\"}}', NULL, '2026-11-11 11:06:36', '2026-11-11 11:06:36'),
('081f757b-8f9c-4cfe-b853-bb1ae6eea8eb', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 29, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":25,\"order_number\":\"CMD-20261111-000025\"}}', NULL, '2026-11-11 11:06:36', '2026-11-11 11:06:36'),
('52780b9c-e502-4c54-ab7d-a2967bc2befe', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 28, '{\"titre\":\"Mission termin\\u00e9e\",\"message\":\"Le coursier a termin\\u00e9 la mission de la commande CMD-20261111-000025.\",\"type\":\"MISSION_COMPLETED\",\"donnees\":{\"mission_id\":12,\"order_id\":25,\"order_number\":\"CMD-20261111-000025\",\"mission_type\":\"PICKUP\"}}', '2026-11-11 14:28:40', '2026-11-11 13:42:59', '2026-11-11 14:28:40'),
('f2902da7-3245-429f-ba39-6713c03e7c29', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 1, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":26,\"order_number\":\"CMD-20261111-000026\"}}', NULL, '2026-11-11 11:34:51', '2026-11-11 11:34:51'),
('2cbb377a-fec7-4e65-99db-acd2707bdefb', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 23, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":26,\"order_number\":\"CMD-20261111-000026\"}}', NULL, '2026-11-11 11:34:51', '2026-11-11 11:34:51'),
('f05e2056-061a-4a80-b9f8-13594db66f3c', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 1, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":27,\"order_number\":\"CMD-20261111-000027\"}}', NULL, '2026-11-11 14:27:18', '2026-11-11 14:27:18'),
('113c5b75-e4b1-4f6e-82f1-4e7f5a3b027c', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 29, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":26,\"order_number\":\"CMD-20261111-000026\"}}', NULL, '2026-11-11 11:34:51', '2026-11-11 11:34:51'),
('d002c0ff-05a2-4200-8212-98f0466c9ca8', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 23, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":27,\"order_number\":\"CMD-20261111-000027\"}}', NULL, '2026-11-11 14:27:18', '2026-11-11 14:27:18'),
('c3b5f52e-a4d7-4013-a3c7-b25790891c81', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 33, '{\"titre\":\"Nouvelle mission attribu\\u00e9e\",\"message\":\"Une nouvelle mission vous a \\u00e9t\\u00e9 attribu\\u00e9e pour une commande.\",\"type\":\"NEW_MISSION\",\"donnees\":{\"mission_id\":12,\"order_id\":25,\"order_number\":\"CMD-20261111-000025\",\"mission_type\":\"PICKUP\"}}', '2026-11-11 13:40:30', '2026-11-11 13:13:37', '2026-11-11 13:40:30'),
('6c8597d6-f255-4085-a825-cc846883fef0', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 28, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":27,\"order_number\":\"CMD-20261111-000027\"}}', '2026-11-11 14:28:40', '2026-11-11 14:27:18', '2026-11-11 14:28:40'),
('b9a5e05e-b149-4fb0-b841-56830f99f9fa', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 29, '{\"titre\":\"Nouvelle commande\",\"message\":\"Une nouvelle commande vient d\\u2019\\u00eatre pass\\u00e9e.\",\"type\":\"NEW_ORDER\",\"donnees\":{\"order_id\":27,\"order_number\":\"CMD-20261111-000027\"}}', NULL, '2026-11-11 14:27:18', '2026-11-11 14:27:18'),
('c3a59aec-cea7-4010-9254-9b3a99699827', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 30, '{\"titre\":\"R\\u00e9capitulatif disponible\",\"message\":\"Le r\\u00e9capitulatif de votre commande est pr\\u00eat. Veuillez le consulter et le confirmer.\",\"type\":\"RECAP_SENT\",\"donnees\":{\"order_id\":27,\"order_number\":\"CMD-20261111-000027\"}}', '2026-11-11 14:32:12', '2026-11-11 14:29:12', '2026-11-11 14:32:12'),
('49af8641-2cc0-4cac-b1ba-618773fc710b', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 33, '{\"titre\":\"Nouvelle mission attribu\\u00e9e\",\"message\":\"Une nouvelle mission vous a \\u00e9t\\u00e9 attribu\\u00e9e pour une commande.\",\"type\":\"NEW_MISSION\",\"donnees\":{\"mission_id\":13,\"order_id\":27,\"order_number\":\"CMD-20261111-000027\",\"mission_type\":\"PICKUP\"}}', '2026-11-11 14:30:35', '2026-11-11 14:29:48', '2026-11-11 14:30:35'),
('a7559530-4949-4308-b92c-61187c2ee85d', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 28, '{\"titre\":\"R\\u00e9capitulatif confirm\\u00e9\",\"message\":\"Le client a confirm\\u00e9 le r\\u00e9capitulatif de sa commande.\",\"type\":\"RECAP_CONFIRMED\",\"donnees\":{\"order_id\":27,\"order_number\":\"CMD-20261111-000027\"}}', NULL, '2026-11-11 14:31:23', '2026-11-11 14:31:23'),
('77315c76-8b3d-4849-9ee7-a130467e052a', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 33, '{\"titre\":\"Nouvelle mission attribu\\u00e9e\",\"message\":\"Une nouvelle mission vous a \\u00e9t\\u00e9 attribu\\u00e9e pour une commande.\",\"type\":\"NEW_MISSION\",\"donnees\":{\"mission_id\":14,\"order_id\":27,\"order_number\":\"CMD-20261111-000027\",\"mission_type\":\"DELIVERY\"}}', '2026-11-12 10:22:34', '2026-11-12 10:21:26', '2026-11-12 10:22:34'),
('31418c9f-3d89-46a2-876c-0aeb72ebb4f8', 'App\\Notifications\\PressingProNotification', 'App\\Models\\User', 30, '{\"titre\":\"Confirmation de mission requise\",\"message\":\"Le coursier d\\u00e9clare avoir effectu\\u00e9 sa mission. Veuillez confirmer sa r\\u00e9alisation.\",\"type\":\"MISSION_AWAITING_CONFIRMATION\",\"donnees\":{\"mission_id\":14,\"order_id\":27,\"order_number\":\"CMD-20261111-000027\",\"mission_type\":\"DELIVERY\"}}', NULL, '2026-11-12 10:32:34', '2026-11-12 10:32:34');

-- --------------------------------------------------------

--
-- Structure de la table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_number` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_date` datetime NOT NULL,
  `pickup_address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recovery_mode` enum('ON_SITE','DELIVERY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `recap_status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `delivery_fee` int UNSIGNED NOT NULL DEFAULT '0',
  `total` int UNSIGNED NOT NULL DEFAULT '0',
  `customer_id` bigint UNSIGNED NOT NULL,
  `manager_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `correction_message` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `orders_order_number_unique` (`order_number`),
  KEY `orders_customer_id_foreign` (`customer_id`),
  KEY `orders_status_index` (`status`),
  KEY `orders_manager_id_foreign` (`manager_id`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `order_date`, `pickup_address`, `delivery_address`, `recovery_mode`, `status`, `recap_status`, `delivery_fee`, `total`, `customer_id`, `manager_id`, `created_at`, `updated_at`, `deleted_at`, `correction_message`) VALUES
(1, 'CMD-20261023-000001', '2026-10-23 10:39:54', 'Douala, adresse de test', NULL, 'ON_SITE', 'CANCELLED', 'DRAFT', 0, 0, 31, 1, '2026-10-23 08:39:54', '2026-10-30 14:17:16', NULL, NULL),
(2, 'CMD-20261023-000002', '2026-10-23 10:59:00', 'Douala, deuxième commande test', NULL, 'ON_SITE', 'PICKED_UP', 'DRAFT', 0, 0, 31, 1, '2026-10-23 08:59:00', '2026-10-30 13:38:30', NULL, NULL),
(3, 'CMD-20261023-000003', '2026-10-23 11:02:12', 'Douala, troisieme commande test', NULL, 'ON_SITE', 'IN_PROGRESS', 'CONFIRMED', 0, 1500, 31, 1, '2026-10-23 09:02:12', '2026-10-30 14:16:58', NULL, NULL),
(4, 'CMD-20261023-000004', '2026-10-23 12:04:49', 'Douala, commande test correction', NULL, 'ON_SITE', 'CANCELLED', 'CORRECTION_REQUESTED', 0, 1000, 31, 1, '2026-10-23 10:04:49', '2026-10-23 11:08:03', NULL, 'J\'ai déposé 3 chemises et non 2. Merci de corriger la quantité.'),
(5, 'CMD-20261023-000005', '2026-10-23 13:12:08', 'Douala, commande test correction', NULL, 'ON_SITE', 'IN_PROGRESS', 'CONFIRMED', 0, 2000, 31, 1, '2026-10-23 11:12:08', '2026-10-23 11:27:06', NULL, 'J\'ai déposé 3 chemises et non 2. Merci de corriger la quantité.'),
(6, 'CMD-20261023-000006', '2026-10-23 13:43:49', NULL, NULL, 'ON_SITE', 'READY', 'DRAFT', 0, 0, 31, NULL, '2026-10-23 11:43:49', '2026-10-30 12:47:02', NULL, NULL),
(7, 'CMD-20261023-000007', '2026-10-23 13:49:10', NULL, NULL, 'ON_SITE', 'DELIVERED', 'CONFIRMED', 0, 1500, 31, 1, '2026-10-23 11:49:10', '2026-10-30 12:55:35', NULL, NULL),
(8, 'CMD-20261023-000008', '2026-10-23 13:55:21', NULL, NULL, 'ON_SITE', 'CANCELLED', 'DRAFT', 0, 0, 31, NULL, '2026-10-23 11:55:21', '2026-10-30 13:29:28', NULL, NULL),
(9, 'CMD-20261023-000009', '2026-10-23 14:51:45', NULL, NULL, 'ON_SITE', 'READY', 'DRAFT', 0, 0, 31, 1, '2026-10-23 12:51:45', '2026-10-30 14:21:28', NULL, NULL),
(10, 'CMD-20261102-000010', '2026-11-02 10:52:26', 'Yassa', NULL, 'ON_SITE', 'IN_PROGRESS', 'DRAFT', 0, 0, 31, 29, '2026-11-02 09:52:26', '2026-11-02 17:07:47', NULL, NULL),
(11, 'CMD-20261102-000011', '2026-11-02 10:56:13', 'yassa', NULL, 'ON_SITE', 'PENDING', 'DRAFT', 0, 0, 31, NULL, '2026-11-02 09:56:13', '2026-11-02 11:13:45', NULL, NULL),
(12, 'CMD-20261102-000012', '2026-11-02 11:21:30', 'wwerty', NULL, 'ON_SITE', 'READY', 'DRAFT', 0, 0, 31, NULL, '2026-11-02 10:21:30', '2026-11-07 13:14:26', NULL, NULL),
(13, 'CMD-20261102-000013', '2026-11-02 11:25:16', 'yassa', 'akwa', 'DELIVERY', 'IN_PROGRESS', 'AWAITING_CONFIRMATION', 1000, 5000, 31, 28, '2026-11-02 10:25:16', '2026-11-03 11:32:48', NULL, NULL),
(14, 'CMD-20261102-000014', '2026-11-02 11:30:52', 'bali', NULL, 'ON_SITE', 'PENDING', 'DRAFT', 0, 1000, 31, 28, '2026-11-02 10:30:52', '2026-11-07 13:08:56', NULL, NULL),
(15, 'CMD-20261102-000015', '2026-11-02 11:31:35', 'bonapriso', 'akwa', 'DELIVERY', 'IN_PROGRESS', 'DRAFT', 1000, 1000, 31, 28, '2026-11-02 10:31:35', '2026-11-02 16:52:41', NULL, NULL),
(16, 'CMD-20261102-000016', '2026-11-02 11:33:27', 'japoma', NULL, 'ON_SITE', 'PENDING', 'DRAFT', 0, 0, 31, NULL, '2026-11-02 10:33:27', '2026-11-02 11:02:26', '2026-11-02 11:02:26', NULL),
(17, 'CMD-20261102-000017', '2026-11-02 11:35:18', 'yassa', NULL, 'ON_SITE', 'PENDING', 'DRAFT', 0, 0, 31, NULL, '2026-11-02 10:35:18', '2026-11-02 11:01:37', '2026-11-02 11:01:37', NULL),
(18, 'CMD-20261102-000018', '2026-11-02 12:20:46', 'bali', NULL, 'ON_SITE', 'PENDING', 'DRAFT', 0, 0, 31, NULL, '2026-11-02 11:20:46', '2026-11-02 11:20:57', '2026-11-02 11:20:57', NULL),
(24, 'CMD-20261111-000024', '2026-11-11 11:15:41', 'Akwa, Douala', 'Bonamoussadi, Douala', 'DELIVERY', 'PENDING', 'DRAFT', 1000, 1000, 30, NULL, '2026-11-11 10:15:41', '2026-11-11 10:15:41', NULL, NULL),
(19, 'CMD-20261103-000019', '2026-11-03 14:48:02', 'Yassa', 'Bonapriso', 'DELIVERY', 'PENDING', 'DRAFT', 1000, 1000, 30, NULL, '2026-11-03 13:48:02', '2026-11-03 13:49:10', '2026-11-03 13:49:10', NULL),
(20, 'CMD-20261103-000020', '2026-11-03 14:49:28', 'Akwa', 'Bonapriso', 'DELIVERY', 'READY', 'CONFIRMED', 1000, 5500, 30, 28, '2026-11-03 13:49:28', '2026-11-06 15:00:18', NULL, 'iwertytuiop'),
(21, 'CMD-20261105-000021', '2026-11-05 11:33:00', 'Akwa', 'Bali', 'DELIVERY', 'PENDING', 'DRAFT', 1000, 1000, 31, NULL, '2026-11-05 10:33:00', '2026-11-05 10:39:48', '2026-11-05 10:39:48', NULL),
(22, 'CMD-20261105-000022', '2026-11-05 11:40:05', 'Akwa', 'Bepanda', 'DELIVERY', 'PICKED_UP', 'CONFIRMED', 1000, 4204, 31, 28, '2026-11-05 10:40:05', '2026-11-07 13:36:19', NULL, NULL),
(23, 'CMD-20261105-000023', '2026-11-05 16:17:06', 'yassa', 'helf', 'DELIVERY', 'DELIVERED', 'CONFIRMED', 1000, 2500, 32, 28, '2026-11-05 15:17:06', '2026-11-06 11:10:54', NULL, 'ry\n\'jkljbhjbbhjkjhgvfghj'),
(25, 'CMD-20261111-000025', '2026-11-11 12:06:36', 'akwa', 'akwa', 'DELIVERY', 'IN_PROGRESS', 'CONFIRMED', 1000, 1704, 30, 28, '2026-11-11 11:06:36', '2026-11-11 11:33:39', NULL, NULL),
(26, 'CMD-20261111-000026', '2026-11-11 12:34:51', 'akwa', NULL, 'ON_SITE', 'IN_PROGRESS', 'AWAITING_CONFIRMATION', 0, 500, 28, 28, '2026-11-11 11:34:51', '2026-11-11 11:43:39', NULL, NULL),
(27, 'CMD-20261111-000027', '2026-11-11 15:27:17', 'bali', 'bali', 'DELIVERY', 'IN_PROGRESS', 'CONFIRMED', 1000, 2000, 30, 28, '2026-11-11 14:27:17', '2026-11-11 14:31:23', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `order_counters`
--

DROP TABLE IF EXISTS `order_counters`;
CREATE TABLE IF NOT EXISTS `order_counters` (
  `year` smallint UNSIGNED NOT NULL,
  `last_number` int UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`year`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `order_counters`
--

INSERT INTO `order_counters` (`year`, `last_number`) VALUES
(2026, 27);

-- --------------------------------------------------------

--
-- Structure de la table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `quantity` int UNSIGNED NOT NULL,
  `unit_price` int UNSIGNED NOT NULL,
  `subtotal` int UNSIGNED NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_category_id_foreign` (`category_id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `order_items`
--

INSERT INTO `order_items` (`id`, `quantity`, `unit_price`, `subtotal`, `description`, `order_id`, `category_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 3, 500, 1500, 'Chemises à laver et repasser', 3, 1, '2026-10-23 09:18:16', '2026-10-23 09:18:16', NULL),
(2, 2, 500, 1000, 'Chemises pour test de correction', 4, 1, '2026-10-23 10:21:34', '2026-10-23 10:21:34', NULL),
(3, 4, 500, 2000, 'Chemises pour test de correction', 5, 1, '2026-10-23 11:15:06', '2026-10-23 11:23:40', NULL),
(4, 3, 500, 1500, 'chemise rose', 7, 1, '2026-10-23 12:04:44', '2026-10-23 12:07:54', NULL),
(5, 3, 500, 1500, 'chemisee blanche', 9, 1, '2026-10-23 13:03:22', '2026-10-23 13:12:48', '2026-10-23 13:12:48'),
(6, 2, 500, 1000, 'chemise rose', 14, 1, '2026-11-03 10:24:24', '2026-11-03 10:29:12', NULL),
(7, 1, 1500, 1500, 'Veste bleue', 14, 3, '2026-11-03 10:24:24', '2026-11-03 10:29:12', '2026-11-03 10:29:12'),
(8, 2, 1500, 3000, 'veste rose pour femme', 13, 3, '2026-11-03 11:32:00', '2026-11-03 11:32:00', NULL),
(9, 1, 1000, 1000, 'pull beige coton', 13, 12, '2026-11-03 11:32:00', '2026-11-03 11:32:00', NULL),
(10, 2, 1500, 3000, 'Veste bleue etc', 20, 3, '2026-11-03 13:52:36', '2026-11-03 13:52:36', NULL),
(11, 3, 500, 1500, 'chemises roses cotons', 20, 1, '2026-11-03 13:52:36', '2026-11-03 13:52:36', NULL),
(12, 2, 500, 1000, 'Deux chemises blue et rose', 22, 1, '2026-11-05 10:54:36', '2026-11-05 10:54:36', NULL),
(13, 1, 1500, 1500, 'une veste noir taille xl', 22, 3, '2026-11-05 10:54:36', '2026-11-05 10:54:36', NULL),
(14, 1, 704, 704, 'un T-shirt rose', 22, 4, '2026-11-05 10:54:37', '2026-11-05 10:54:37', NULL),
(15, 1, 500, 500, 'qwwertyuiop', 23, 1, '2026-11-05 15:17:54', '2026-11-05 15:17:54', NULL),
(16, 1, 1000, 1000, 'wertyutyuiop', 23, 12, '2026-11-05 15:18:21', '2026-11-05 15:18:21', NULL),
(17, 1, 704, 704, 'qwertyisdfghjlwertyuip[sdfghjkl;', 25, 4, '2026-11-11 11:09:33', '2026-11-11 11:09:33', NULL),
(18, 1, 500, 500, 'qwertyuio[kjhgfdsdfghjl;lkjhretyui', 26, 5, '2026-11-11 11:43:36', '2026-11-11 11:43:36', NULL),
(19, 1, 1000, 1000, 'wrtyui;lkjhgfdvbnm,.mnbv', 27, 12, '2026-11-11 14:29:06', '2026-11-11 14:29:06', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`email`, `token`, `created_at`) VALUES
('kemayo34@gmail.com', '$2y$12$721S5YcXSuZmttZICzvVHuPv224CDHsyqMFVq1WYZfvSzQqBoi63K', '2026-11-12 14:23:29'),
('dadaleonardo00@gmail.com', '$2y$12$wSMo5ZLnseDmu/C1.15f5u56YM89xD8TJ3xSHzLpIWKBk.6NgOccG', '2026-11-12 14:36:41');

-- --------------------------------------------------------

--
-- Structure de la table `payments`
--

DROP TABLE IF EXISTS `payments`;
CREATE TABLE IF NOT EXISTS `payments` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `amount` int UNSIGNED NOT NULL,
  `payment_date` datetime NOT NULL,
  `payment_method` enum('CASH','MOBILE_MONEY','CARD') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `order_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payments_order_id_foreign` (`order_id`),
  KEY `payments_status_index` (`status`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `payments`
--

INSERT INTO `payments` (`id`, `amount`, `payment_date`, `payment_method`, `status`, `order_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2026-11-02 15:39:00', 'CASH', 'PARTIAL', 15, '2026-11-02 14:39:00', '2026-11-02 14:39:00', NULL),
(2, 4000, '2026-11-04 09:36:55', 'CASH', 'PAID', 20, '2026-11-04 08:36:55', '2026-11-06 11:21:14', NULL),
(3, 500, '2026-11-04 09:38:25', 'CASH', 'PARTIAL', 15, '2026-11-04 08:38:25', '2026-11-04 08:38:25', NULL),
(4, 499, '2026-11-04 09:38:59', 'CASH', 'PAID', 15, '2026-11-04 08:38:59', '2026-11-04 08:38:59', NULL),
(5, 1500, '2026-11-06 12:07:03', 'CASH', 'PARTIAL', 23, '2026-11-06 11:07:03', '2026-11-06 11:07:03', NULL),
(6, 1000, '2026-11-06 12:10:19', 'MOBILE_MONEY', 'PAID', 23, '2026-11-06 11:10:19', '2026-11-06 11:10:19', NULL),
(7, 1500, '2026-11-06 12:21:14', 'CASH', 'PAID', 20, '2026-11-06 11:21:14', '2026-11-06 11:21:14', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=MyISAM AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 2, 'pressing-app-token', '5ac821320d40790d75b7bc87b834c17d5dabc44923f442de9b7e9440cb2dd1c1', '[\"*\"]', '2026-10-23 09:02:31', NULL, '2026-10-23 08:36:33', '2026-10-23 09:02:31'),
(2, 'App\\Models\\User', 1, 'pressing-app-token', '42a2256cfd7f8034303c9fe3cef6dd166e3f6355b705443bbc356619a756ba20', '[\"*\"]', '2026-10-23 09:55:35', NULL, '2026-10-23 08:42:29', '2026-10-23 09:55:35'),
(3, 'App\\Models\\User', 1, 'pressing-app-token', '2e85bd444b47d12b1dbc2c9c3089dae939bb24168390a88356d8ad89dd959f66', '[\"*\"]', '2026-10-23 11:30:52', NULL, '2026-10-23 09:17:39', '2026-10-23 11:30:52'),
(4, 'App\\Models\\User', 2, 'pressing-app-token', '28e6724ed8c01cd3bc15ceab77502ffe2572c60b9304dcd97d6735dd75cdc26e', '[\"*\"]', '2026-10-23 11:24:14', NULL, '2026-10-23 09:55:49', '2026-10-23 11:24:14'),
(5, 'App\\Models\\User', 1, 'pressing-app-token', 'd6e8439de880bee4a9b6136d4895dc0f07e829453fb302274dc0214cafcd1abd', '[\"*\"]', '2026-10-23 10:55:38', NULL, '2026-10-23 10:20:22', '2026-10-23 10:55:38'),
(6, 'App\\Models\\User', 2, 'pressing-app-token', '5edf2e39da0c4eee2a929269845bb0817462cc0f578f0fcec43c65cb138f22b8', '[\"*\"]', '2026-10-23 11:48:06', NULL, '2026-10-23 11:11:31', '2026-10-23 11:48:06'),
(7, 'App\\Models\\User', 1, 'pressing-app-token', '8747acb7e1fda444974fbb4af452e39f6ec2be4d1e12f371d38696b9e4de8c68', '[\"*\"]', '2026-10-23 11:24:22', NULL, '2026-10-23 11:13:35', '2026-10-23 11:24:22'),
(8, 'App\\Models\\User', 2, 'pressing-app-token', '5094473e5a5c23063aa0c73a04e63bf5b53f0109f440901ca2970af836432efb', '[\"*\"]', '2026-10-23 11:40:09', NULL, '2026-10-23 11:32:18', '2026-10-23 11:40:09'),
(9, 'App\\Models\\User', 1, 'pressing-app-token', '918daff2fa9c7966ecc619a8ad58aee6317b15e3fc44e7add164d4efb1862acc', '[\"*\"]', '2026-10-23 12:11:03', NULL, '2026-10-23 11:40:26', '2026-10-23 12:11:03'),
(10, 'App\\Models\\User', 2, 'pressing-app-token', '78ce82848762757b4fa398b0b131a36b1f2e112b0b34e2913696095ae3d0c555', '[\"*\"]', '2026-10-23 11:49:10', NULL, '2026-10-23 11:48:45', '2026-10-23 11:49:10'),
(11, 'App\\Models\\User', 2, 'pressing-app-token', '1b1a2d2a1009489699d435e91e908e7eea9d1afdee894686be2ed53eb15ebe00', '[\"*\"]', '2026-10-23 12:10:19', NULL, '2026-10-23 11:54:34', '2026-10-23 12:10:19'),
(12, 'App\\Models\\User', 1, 'pressing-app-token', '32182f78506cd7c33da217d4c6c2d50c2bbca51d0a982429c3d4618a0d70b13b', '[\"*\"]', '2026-10-23 12:08:45', NULL, '2026-10-23 12:01:06', '2026-10-23 12:08:45'),
(13, 'App\\Models\\User', 3, 'pressing-app-token', 'eea4562271bf43ce792f8c99ad86ff588944545cdd527ddc04006dde5a7d4e55', '[\"*\"]', '2026-10-23 12:54:16', NULL, '2026-10-23 12:47:13', '2026-10-23 12:54:16'),
(14, 'App\\Models\\User', 2, 'pressing-app-token', '5ad65fbab019bc4d4540df7642c5f673a845f706203e3ad450f7d5f1d5be5646', '[\"*\"]', '2026-10-23 12:51:45', NULL, '2026-10-23 12:51:16', '2026-10-23 12:51:45'),
(15, 'App\\Models\\User', 1, 'pressing-app-token', 'f2595728062bcdc802a489673ca6dbd3eecc172e828315be94f0401bc5c63a3a', '[\"*\"]', '2026-10-27 12:39:31', NULL, '2026-10-23 12:52:41', '2026-10-27 12:39:31'),
(16, 'App\\Models\\User', 3, 'pressing-app-token', '12712ccde3366e4cbe4106a6ad690c0a341e312ce39c782219d93a877c0d062d', '[\"*\"]', '2026-10-23 12:55:44', NULL, '2026-10-23 12:55:03', '2026-10-23 12:55:44'),
(17, 'App\\Models\\User', 1, 'pressing-app-token', '1e159ab91c9841466d53c2adaa3d53693e93a990f8a8bc8da608a6b0a32c82cd', '[\"*\"]', '2026-10-23 13:03:22', NULL, '2026-10-23 13:02:03', '2026-10-23 13:03:22'),
(18, 'App\\Models\\User', 3, 'pressing-app-token', '7d75e5bddf54a44e5c7ea3d4186568528f4b6937ca44704c041262e5e96a36fd', '[\"*\"]', '2026-10-23 13:11:16', NULL, '2026-10-23 13:03:56', '2026-10-23 13:11:16'),
(19, 'App\\Models\\User', 1, 'pressing-app-token', 'fe2e515974a797934c686715bc71ac2cbc55f9d772ca8f1f0333ff68ba943504', '[\"*\"]', '2026-10-23 13:12:48', NULL, '2026-10-23 13:11:57', '2026-10-23 13:12:48'),
(20, 'App\\Models\\User', 1, 'pressing-app-token', '1a8fb81133ac23edcccc2ef3c3acd936cd5acdc0c2e872ada23ecae56930756a', '[\"*\"]', NULL, NULL, '2026-10-27 12:31:32', '2026-10-27 12:31:32'),
(21, 'App\\Models\\User', 4, 'pressing-app-token', 'fc43babba54761f7f8911aad22a516a2becccaf8f6ed61f8b6b06f26ef5e12f0', '[\"*\"]', '2026-10-27 14:32:25', NULL, '2026-10-27 14:30:14', '2026-10-27 14:32:25'),
(23, 'App\\Models\\User', 5, 'pressing-app-token', 'c312691edd1647b18a11451b49bd86c2e906eb55d5682c0832c842a80a1628e2', '[\"*\"]', '2026-10-28 09:01:55', NULL, '2026-10-28 08:51:11', '2026-10-28 09:01:55'),
(24, 'App\\Models\\User', 4, 'pressing-app-token', 'a4e19cb8050a929c48720dad659242319b1ec481eef23401fe669d9100bfa2b7', '[\"*\"]', '2026-10-28 09:02:38', NULL, '2026-10-28 08:56:46', '2026-10-28 09:02:38'),
(25, 'App\\Models\\User', 7, 'pressing-app-token', '895ad02716515abd529fca1400e237f4105f3630e7ca29c79efa5bd0b8b67012', '[\"*\"]', NULL, NULL, '2026-10-28 09:30:10', '2026-10-28 09:30:10'),
(26, 'App\\Models\\User', 8, 'pressing-app-token', '6da8fb89cefea76175da81c149ed521792ece44e802e3aeeb2cc84e585bd1681', '[\"*\"]', NULL, NULL, '2026-10-28 09:45:23', '2026-10-28 09:45:23'),
(27, 'App\\Models\\User', 9, 'pressing-app-token', 'f1d2116a9212869ccdbd86446f48a80d636f0a08a5b8cb42b8f4610b1a5b0639', '[\"*\"]', NULL, NULL, '2026-10-28 09:47:03', '2026-10-28 09:47:03'),
(28, 'App\\Models\\User', 10, 'pressing-app-token', 'eddd593d266f4f31d52dbde1d10f3f17ed8579d9c32d7f52bb2161d6198fcb21', '[\"*\"]', NULL, NULL, '2026-10-28 09:50:34', '2026-10-28 09:50:34'),
(29, 'App\\Models\\User', 11, 'pressing-app-token', '5c70e9f146f5c4ac1e36d5e2f8aa02757f5a62df10f02735195b5bf5917d31f6', '[\"*\"]', NULL, NULL, '2026-10-28 09:52:14', '2026-10-28 09:52:14'),
(30, 'App\\Models\\User', 12, 'pressing-app-token', 'c5334ba700353acd03617495f1245f5cb03ee7edc6c8a02fc7fa7ceffa39bb81', '[\"*\"]', NULL, NULL, '2026-10-28 09:53:06', '2026-10-28 09:53:06'),
(31, 'App\\Models\\User', 13, 'pressing-app-token', '4a4f5e1f98433b9acfc063af85257c65d486a9b397a18dcbf709b257d85c2d19', '[\"*\"]', NULL, NULL, '2026-10-28 09:54:04', '2026-10-28 09:54:04'),
(32, 'App\\Models\\User', 14, 'pressing-app-token', '558cd1d051c4d2995670466734c1acacb43bd4145e6ec45f85a4bda6ee341384', '[\"*\"]', NULL, NULL, '2026-10-28 09:56:41', '2026-10-28 09:56:41'),
(33, 'App\\Models\\User', 4, 'pressing-app-token', '501c8a57446edf4e14d160614949fdc1e17f453d556edfb088b52c6d28a4e5e3', '[\"*\"]', '2026-10-28 09:59:05', NULL, '2026-10-28 09:58:18', '2026-10-28 09:59:05'),
(34, 'App\\Models\\User', 15, 'pressing-app-token', '435e9a11708e0eee6229a759c78da0176b3fa15e7ff9ce23380dc367259d28c7', '[\"*\"]', NULL, NULL, '2026-10-28 10:15:23', '2026-10-28 10:15:23'),
(35, 'App\\Models\\User', 16, 'pressing-app-token', 'd0b6be1040a4a5cb8aeb5880ad1fb08467b5bb21356c8f57fe372d010fbf0e30', '[\"*\"]', '2026-10-28 10:38:57', NULL, '2026-10-28 10:16:52', '2026-10-28 10:38:57'),
(36, 'App\\Models\\User', 5, 'pressing-app-token', '3742b9e3212a33eb385831c2820ee98f1f7b589769b3cad2c1135881b04e3af7', '[\"*\"]', NULL, NULL, '2026-10-28 11:33:16', '2026-10-28 11:33:16'),
(37, 'App\\Models\\User', 5, 'pressing-app-token', 'c256bf7e4eba28f4155b1bc31152fd89f802fecd1804af1e32e247b1a5e83f39', '[\"*\"]', NULL, NULL, '2026-10-28 11:43:35', '2026-10-28 11:43:35'),
(38, 'App\\Models\\User', 5, 'pressing-app-token', '5cdc8e2f9829a26314a6c2b4cfec7f0da259bb2283ff5a8bfa425cea0f97d5b4', '[\"*\"]', '2026-10-30 08:14:51', NULL, '2026-10-28 11:52:19', '2026-10-30 08:14:51'),
(39, 'App\\Models\\User', 17, 'pressing-app-token', 'bd31926ddbb87721f965080f3182e3ab8b438bf53c9c6f5fb3d2f8fdb7449527', '[\"*\"]', '2026-10-30 08:17:18', NULL, '2026-10-30 08:16:10', '2026-10-30 08:17:18'),
(40, 'App\\Models\\User', 18, 'pressing-app-token', 'dee7d060dd0cd098cdeaffcbbdbcf91afd6c0fe15b1e2761b3dcdd832b06a2b6', '[\"*\"]', '2026-10-30 08:20:48', NULL, '2026-10-30 08:18:50', '2026-10-30 08:20:48'),
(41, 'App\\Models\\User', 5, 'pressing-app-token', '0066ff30d1c80b3d1b49f13c3a1f27ccbcaaef6b40be86c535163d57f1920e0d', '[\"*\"]', '2026-10-30 08:27:06', NULL, '2026-10-30 08:27:06', '2026-10-30 08:27:06'),
(42, 'App\\Models\\User', 19, 'pressing-app-token', '6c83bea0469fae93fe98a4bcd807697f171feb524419b1b8e40fd18de19fb6b2', '[\"*\"]', '2026-10-30 08:27:37', NULL, '2026-10-30 08:27:36', '2026-10-30 08:27:37'),
(43, 'App\\Models\\User', 20, 'pressing-app-token', '0d07b88ac1ae95a49a2971f62535c4d1f4bc00b191e1e3dd5888775ba2f5fb00', '[\"*\"]', '2026-10-30 08:28:02', NULL, '2026-10-30 08:28:01', '2026-10-30 08:28:02'),
(44, 'App\\Models\\User', 21, 'pressing-app-token', '2bee2cb9fe68ee151700d936928d9518cdaef539b77c02c453e9ead63092121f', '[\"*\"]', '2026-10-30 08:28:36', NULL, '2026-10-30 08:28:35', '2026-10-30 08:28:36'),
(45, 'App\\Models\\User', 22, 'pressing-app-token', 'da85192e7168606444b7e5d86b5670ee6ea773ac3f608c1eef52c0675819adc8', '[\"*\"]', '2026-10-30 09:28:48', NULL, '2026-10-30 08:29:48', '2026-10-30 09:28:48'),
(46, 'App\\Models\\User', 4, 'pressing-app-token', '53c4c9c941e35d6c1df30bfef0362121c735a51f675494edc2745f2402fccfa1', '[\"*\"]', '2026-10-30 10:40:25', NULL, '2026-10-30 09:29:27', '2026-10-30 10:40:25'),
(47, 'App\\Models\\User', 26, 'pressing-app-token', 'dcc9d8501184756f8c372115a707ad54f6b67539acad3a52ee7b2f4c52cf8e99', '[\"*\"]', '2026-10-31 09:28:37', NULL, '2026-10-30 10:51:53', '2026-10-31 09:28:37'),
(48, 'App\\Models\\User', 26, 'pressing-app-token', '3906efccfc5238bfc47e4308e54a1956fe79de4d653d4e5e81afa3c3549ad660', '[\"*\"]', '2026-10-31 09:28:37', NULL, '2026-10-30 12:01:36', '2026-10-31 09:28:37'),
(49, 'App\\Models\\User', 26, 'pressing-app-token', '55a63948df78f147183d8c15edd19ce17fdf27b9dc2a4399ce5068acb397028b', '[\"*\"]', '2026-11-05 14:18:52', NULL, '2026-10-30 16:07:53', '2026-11-05 14:18:52'),
(50, 'App\\Models\\User', 26, 'pressing-app-token', '8e2fa139a64e2f304a89a16ecffca2cc150284c261a6dff5e38684694610b4bf', '[\"*\"]', '2026-11-02 08:15:16', NULL, '2026-10-31 09:29:44', '2026-11-02 08:15:16'),
(51, 'App\\Models\\User', 26, 'pressing-app-token', 'd4d50537de1db997b7e2cf51e5a83dedf310e82baf4a07712a1e0102ddcb458a', '[\"*\"]', '2026-10-31 11:36:14', NULL, '2026-10-31 09:35:33', '2026-10-31 11:36:14'),
(52, 'App\\Models\\User', 27, 'pressing-app-token', '0db48133632ddf8e2c1931cf4ac6a06a443843aae1e787cf24e0b03f50e37a8b', '[\"*\"]', '2026-10-31 13:35:43', NULL, '2026-10-31 11:36:46', '2026-10-31 13:35:43'),
(53, 'App\\Models\\User', 27, 'pressing-app-token', '7869984ed554b923eb2aa2b0f7fbeb5d2d6004507981addd2da52796442bb125', '[\"*\"]', '2026-10-31 11:45:52', NULL, '2026-10-31 11:38:10', '2026-10-31 11:45:52'),
(54, 'App\\Models\\User', 26, 'pressing-app-token', '8e65606f8624ea2204b0c480a994d9fbf29501d4a722ec1ffbc02f1e0fa0db71', '[\"*\"]', '2026-10-31 12:47:59', NULL, '2026-10-31 12:47:23', '2026-10-31 12:47:59'),
(55, 'App\\Models\\User', 27, 'pressing-app-token', '2f81f5a4dbdac2b2f8eced9e724231b97cb2ee4fb1bffb5981bd2310467bcf0f', '[\"*\"]', '2026-11-02 15:07:13', NULL, '2026-11-02 08:16:51', '2026-11-02 15:07:13'),
(56, 'App\\Models\\User', 27, 'pressing-app-token', 'd442aba497b79e3c5928b453087bc839cbde612c9bdc337457dd1ddfa5bec457', '[\"*\"]', '2026-11-02 11:33:11', NULL, '2026-11-02 11:31:51', '2026-11-02 11:33:11'),
(57, 'App\\Models\\User', 26, 'pressing-app-token', '36f8723d7f583722d18518e0ea75b73d07bc2ac2db99ef5717577fe1ca5f4ab1', '[\"*\"]', '2026-11-02 15:22:28', NULL, '2026-11-02 15:21:28', '2026-11-02 15:22:28'),
(58, 'App\\Models\\User', 28, 'pressing-app-token', 'c154c5e319d4309c920a409587361d41433e8b214a88bb73e4fbc83b39aa7660', '[\"*\"]', '2026-11-02 16:09:32', NULL, '2026-11-02 15:22:53', '2026-11-02 16:09:32'),
(59, 'App\\Models\\User', 28, 'pressing-app-token', 'f976ae501bfeb0a913366be6994505529fb0536cc31196d1cbea69ec7455622a', '[\"*\"]', '2026-11-05 14:29:51', NULL, '2026-11-02 16:08:50', '2026-11-05 14:29:51'),
(60, 'App\\Models\\User', 27, 'pressing-app-token', '79da72dab587c225f9fe7e777cd2e086b648ab166d80c73e9e7a9f0973a34055', '[\"*\"]', '2026-11-02 16:09:34', NULL, '2026-11-02 16:09:33', '2026-11-02 16:09:34'),
(61, 'App\\Models\\User', 28, 'pressing-app-token', '2d17b94ab534c45b67e8d96e37b1c47f1c715d14c11ee233f1b54daed241467c', '[\"*\"]', '2026-11-02 17:04:48', NULL, '2026-11-02 16:09:59', '2026-11-02 17:04:48'),
(62, 'App\\Models\\User', 26, 'pressing-app-token', 'd354fd81a1b8e8da450c8aebebdec20b3aa645d095b6fa7f5fce5abf8a85d448', '[\"*\"]', '2026-11-02 17:06:36', NULL, '2026-11-02 17:05:17', '2026-11-02 17:06:36'),
(63, 'App\\Models\\User', 29, 'pressing-app-token', '91466e2932ecb78b9b557fe43d372176122e5f23aa8a26f83699764727c4d9fe', '[\"*\"]', '2026-11-02 17:07:58', NULL, '2026-11-02 17:06:54', '2026-11-02 17:07:58'),
(64, 'App\\Models\\User', 28, 'pressing-app-token', '08662b4b26a6c4bfcc51fa17b9e57ba5431ca731b4248ff2db5a712e1aeaba6d', '[\"*\"]', '2026-11-03 08:52:17', NULL, '2026-11-02 17:08:02', '2026-11-03 08:52:17'),
(65, 'App\\Models\\User', 28, 'pressing-app-token', '5589ec5cd4d2d8adf7c56220f0d25299a54656af1ae9436618b0011f56a992c2', '[\"*\"]', '2026-11-03 08:52:56', NULL, '2026-11-03 08:52:20', '2026-11-03 08:52:56'),
(66, 'App\\Models\\User', 28, 'pressing-app-token', '1145d00410447ad6e848816c40f32e82342e74deac30c97b422164501345ab8f', '[\"*\"]', '2026-11-03 13:43:24', NULL, '2026-11-03 08:59:43', '2026-11-03 13:43:24'),
(67, 'App\\Models\\User', 30, 'pressing-app-token', 'c4e4b5b52b5a415943b14f389cef03f6ad6cb8f0e5c50f2d2200d9c4c5125305', '[\"*\"]', '2026-11-03 13:50:27', NULL, '2026-11-03 13:46:42', '2026-11-03 13:50:27'),
(68, 'App\\Models\\User', 28, 'pressing-app-token', 'd63c34898930df45b3bac757e2af1eb62a94c5322e2c28cfe4c44526dd09382d', '[\"*\"]', '2026-11-03 13:54:07', NULL, '2026-11-03 13:51:07', '2026-11-03 13:54:07'),
(69, 'App\\Models\\User', 30, 'pressing-app-token', 'c0b9c830cbe7178f437d6006a11fc232a10575ed84312119b3d06a720b17524e', '[\"*\"]', '2026-11-03 13:55:37', NULL, '2026-11-03 13:54:16', '2026-11-03 13:55:37'),
(70, 'App\\Models\\User', 28, 'pressing-app-token', '86b2f6dd4c47a1abeb3c27dd35ab9bd5229e3b80abe720419cbb1f9347f7718f', '[\"*\"]', '2026-11-03 14:07:16', NULL, '2026-11-03 13:56:14', '2026-11-03 14:07:16'),
(71, 'App\\Models\\User', 28, 'pressing-app-token', '0101cf3568f66aee0add92962526ae4cae3e3e3932ba63c6931f3e15ba7a097a', '[\"*\"]', '2026-11-04 11:58:08', NULL, '2026-11-03 14:07:28', '2026-11-04 11:58:08'),
(72, 'App\\Models\\User', 30, 'pressing-app-token', '138511cb65cd729d10dc71d8fa2738555d3624a1c4c19eea943f11ab99f4eed0', '[\"*\"]', '2026-11-04 11:59:11', NULL, '2026-11-04 11:58:17', '2026-11-04 11:59:11'),
(73, 'App\\Models\\User', 28, 'pressing-app-token', '5d316b07be55dd560c14c4f00c6758b4f8f8c1e647d99a1d43ccc48a872721b2', '[\"*\"]', '2026-11-04 12:29:13', NULL, '2026-11-04 12:00:00', '2026-11-04 12:29:13'),
(74, 'App\\Models\\User', 30, 'pressing-app-token', 'ec74e5cfaef1557d61b80263b32df7642e944691bf9e07a2f9f84031d1c8567f', '[\"*\"]', '2026-11-04 12:44:01', NULL, '2026-11-04 12:29:23', '2026-11-04 12:44:01'),
(75, 'App\\Models\\User', 28, 'pressing-app-token', 'c74f87b5280d2db4e74a7804c693f06c129ab55b4b5d7d9b36525a8268b8482c', '[\"*\"]', '2026-11-04 15:08:24', NULL, '2026-11-04 12:52:36', '2026-11-04 15:08:24'),
(76, 'App\\Models\\User', 25, 'pressing-app-token', '2fa81f83afe6c154e01dea43bbb67867e6003fe2047fac1ea09050d5a9ec5209', '[\"*\"]', '2026-11-04 15:59:28', NULL, '2026-11-04 15:08:49', '2026-11-04 15:59:28'),
(77, 'App\\Models\\User', 28, 'pressing-app-token', '1a8713895de13930a0e022d9b38f494c427b6598b5aa64278e8e6b63918ccb5e', '[\"*\"]', '2026-11-04 16:00:50', NULL, '2026-11-04 15:59:32', '2026-11-04 16:00:50'),
(78, 'App\\Models\\User', 25, 'pressing-app-token', '6b7c868c0140b14999031ebd319608277910d3ba06f0b38a1c1701579539eac8', '[\"*\"]', '2026-11-04 16:02:13', NULL, '2026-11-04 16:01:51', '2026-11-04 16:02:13'),
(79, 'App\\Models\\User', 28, 'pressing-app-token', '8c72723c537cc00712c863ea8c4d3ba5060b934ae7191f25701e02dc32c87033', '[\"*\"]', '2026-11-04 16:02:43', NULL, '2026-11-04 16:02:23', '2026-11-04 16:02:43'),
(80, 'App\\Models\\User', 25, 'pressing-app-token', '317c7b151e801d1421ffc029f74d5ddfdd99851168372fdef21557dab5376f1a', '[\"*\"]', '2026-11-04 16:25:49', NULL, '2026-11-04 16:02:53', '2026-11-04 16:25:49'),
(81, 'App\\Models\\User', 28, 'pressing-app-token', 'f8dfd847d8eac878379a3aff116ecc1932b84f22f9b64a1a60992b51a60bcf86', '[\"*\"]', '2026-11-04 16:26:30', NULL, '2026-11-04 16:25:57', '2026-11-04 16:26:30'),
(82, 'App\\Models\\User', 25, 'pressing-app-token', 'cf1bba4f0f9e5a4f8d3c2f04226ba95ba9c2061f345c4b8baa1453c880e15c40', '[\"*\"]', '2026-11-04 16:27:31', NULL, '2026-11-04 16:26:37', '2026-11-04 16:27:31'),
(83, 'App\\Models\\User', 28, 'pressing-app-token', 'bda45c68443cc2b011f5e57252edb5b69108b6f61a1d1b869d01bdfa7c59eb0e', '[\"*\"]', '2026-11-04 16:28:16', NULL, '2026-11-04 16:27:38', '2026-11-04 16:28:16'),
(84, 'App\\Models\\User', 25, 'pressing-app-token', '1e8d197de6cd35defe96169fa1c101c901b91addc8363b0dbb39d8e4a70d732b', '[\"*\"]', '2026-11-05 07:45:01', NULL, '2026-11-04 16:28:26', '2026-11-05 07:45:01'),
(85, 'App\\Models\\User', 25, 'pressing-app-token', '56493172a5e0852ab66b955bbb11fc12e62c002faf6e403e9177b3fcfbdb313d', '[\"*\"]', '2026-11-05 10:20:27', NULL, '2026-11-05 07:45:08', '2026-11-05 10:20:27'),
(86, 'App\\Models\\User', 31, 'pressing-app-token', '04ce550a49aa5b07094512fbf64780c26718d6fd4db67e267b5d74a99dc0f9bc', '[\"*\"]', '2026-11-05 10:28:03', NULL, '2026-11-05 10:26:01', '2026-11-05 10:28:03'),
(87, 'App\\Models\\User', 31, 'pressing-app-token', 'b79a1a775ec3be49c18dcfa2ab779a028e3017eae054db86fd1876970626b730', '[\"*\"]', '2026-11-05 10:40:21', NULL, '2026-11-05 10:28:08', '2026-11-05 10:40:21'),
(88, 'App\\Models\\User', 28, 'pressing-app-token', 'dd4e84068a1485639d2654ffc085d19f592e4997acee43967fecef30634aabfd', '[\"*\"]', '2026-11-05 12:21:30', NULL, '2026-11-05 10:40:52', '2026-11-05 12:21:30'),
(89, 'App\\Models\\User', 31, 'pressing-app-token', '95833d66b80d59ec08e798caf19c0f8d41fb9c89f78c586172a2d50d50849432', '[\"*\"]', '2026-11-05 12:24:31', NULL, '2026-11-05 12:23:11', '2026-11-05 12:24:31'),
(90, 'App\\Models\\User', 30, 'pressing-app-token', 'fa60146533d96e7d6c17708565c221a23feb4c873831eb38479158e55cdc076e', '[\"*\"]', '2026-11-05 12:26:01', NULL, '2026-11-05 12:25:48', '2026-11-05 12:26:01'),
(91, 'App\\Models\\User', 30, 'pressing-app-token', '50407b118162cc709b19e7368d057b936121b286de00b593bcf4748b310c5b4b', '[\"*\"]', '2026-11-05 12:31:37', NULL, '2026-11-05 12:31:26', '2026-11-05 12:31:37'),
(92, 'App\\Models\\User', 28, 'pressing-app-token', 'd4959a0547f83e3ad3305f93c968682441f87979867c5b71e0817cfb3489fa5a', '[\"*\"]', '2026-11-05 12:39:04', NULL, '2026-11-05 12:31:55', '2026-11-05 12:39:04'),
(93, 'App\\Models\\User', 30, 'pressing-app-token', '25e070f975b6f9e18720ed71117b7663d6ab3197e98fff962517cfd7a123a9c9', '[\"*\"]', '2026-11-05 12:39:56', NULL, '2026-11-05 12:39:24', '2026-11-05 12:39:56'),
(94, 'App\\Models\\User', 28, 'pressing-app-token', '040ed50db455eb5df48f58b349873b897f2162f579a872f113d2241acfe03336', '[\"*\"]', '2026-11-05 13:38:03', NULL, '2026-11-05 12:46:30', '2026-11-05 13:38:03'),
(95, 'App\\Models\\User', 28, 'pressing-app-token', 'ddfdff850b7a1c6f2172bdecc6fe344da6c0c5490c17d0129a87c68f7e7ba24b', '[\"*\"]', '2026-11-05 15:15:12', NULL, '2026-11-05 13:38:14', '2026-11-05 15:15:12'),
(96, 'App\\Models\\User', 28, 'pressing-app-token', 'a959ac3157afb3a7bd5e28b67b83e6a7bb6aa3decb22539652fe7cadacaf584f', '[\"*\"]', '2026-11-05 14:24:07', NULL, '2026-11-05 14:23:17', '2026-11-05 14:24:07'),
(97, 'App\\Models\\User', 28, 'pressing-app-token', '366f61fa8510b9dde6785534086b9bee7107c9b8ab12c38c0893882ab382e64c', '[\"*\"]', '2026-11-05 14:32:32', NULL, '2026-11-05 14:30:11', '2026-11-05 14:32:32'),
(98, 'App\\Models\\User', 32, 'pressing-app-token', '964362ddb6fa91be989dcacc75d78e0555ab2d99f39add6b1f535bbf8dd5d3b4', '[\"*\"]', '2026-11-05 15:17:09', NULL, '2026-11-05 15:16:35', '2026-11-05 15:17:09'),
(99, 'App\\Models\\User', 28, 'pressing-app-token', 'd41e1713fe9e1afec6fc654fea4860c31531a912b7b55614b2ae59d3311547f8', '[\"*\"]', '2026-11-05 15:18:35', NULL, '2026-11-05 15:17:20', '2026-11-05 15:18:35'),
(100, 'App\\Models\\User', 32, 'pressing-app-token', 'ca1632d48399367f2a85f24ebf99f72d5e9aa94e277c6b5705bafaec4548a8c1', '[\"*\"]', '2026-11-05 15:19:53', NULL, '2026-11-05 15:19:26', '2026-11-05 15:19:53'),
(101, 'App\\Models\\User', 28, 'pressing-app-token', '66f96e78a3e8ba4cfb3de264f1fd8a9deaae5ff32b94fa7d33060678f415f30b', '[\"*\"]', '2026-11-05 15:26:25', NULL, '2026-11-05 15:20:07', '2026-11-05 15:26:25'),
(102, 'App\\Models\\User', 32, 'pressing-app-token', '50b366eb38f36291dfcc606de55699e214246c7544690095b2500d6f1d3cf785', '[\"*\"]', '2026-11-05 15:35:46', NULL, '2026-11-05 15:35:38', '2026-11-05 15:35:46'),
(103, 'App\\Models\\User', 28, 'pressing-app-token', 'bc7a33a14f12540b39254ae76957c8f1d3acbb9d75bb8d631b6aa8872723b3fe', '[\"*\"]', '2026-11-05 15:37:05', NULL, '2026-11-05 15:36:13', '2026-11-05 15:37:05'),
(104, 'App\\Models\\User', 28, 'pressing-app-token', 'a0654952066881a0c0584a3f5e0a51ca5b460b6cc94c4822e5a779e54e3066c1', '[\"*\"]', '2026-11-05 15:47:14', NULL, '2026-11-05 15:47:01', '2026-11-05 15:47:14'),
(105, 'App\\Models\\User', 32, 'pressing-app-token', '14248365abf17bf73a8644ee09ba012891e11fcd204409bacb8b7d3a2cf6947f', '[\"*\"]', '2026-11-05 15:48:06', NULL, '2026-11-05 15:47:26', '2026-11-05 15:48:06'),
(106, 'App\\Models\\User', 32, 'pressing-app-token', 'd24f1251810af1e7eea652dc703bc639a01b1e847200f0b5f2e229bc113114ae', '[\"*\"]', '2026-11-05 15:48:32', NULL, '2026-11-05 15:48:22', '2026-11-05 15:48:32'),
(107, 'App\\Models\\User', 28, 'pressing-app-token', 'b11409ef77f59881f243172cb3fc6155bdaca639cdddb0931368cefdab32cb46', '[\"*\"]', '2026-11-06 07:47:06', NULL, '2026-11-05 15:48:55', '2026-11-06 07:47:06'),
(108, 'App\\Models\\User', 32, 'pressing-app-token', '6d0d724225c79f232712ced0d078f3cbc7104bd1deca0f9920b8d926d8582246', '[\"*\"]', '2026-11-06 07:58:12', NULL, '2026-11-06 07:57:38', '2026-11-06 07:58:12'),
(109, 'App\\Models\\User', 32, 'pressing-app-token', 'c069aa602679bc4790343cfd39e5470d27349b6582d648dccd61e82625132d5d', '[\"*\"]', '2026-11-06 11:52:55', NULL, '2026-11-06 07:59:33', '2026-11-06 11:52:55'),
(110, 'App\\Models\\User', 32, 'pressing-app-token', '6c2eafe4589d75065b986e1a07983ca8461ec83dbab36fefb0faeadd38dd8d8c', '[\"*\"]', '2026-11-06 08:00:27', NULL, '2026-11-06 08:00:27', '2026-11-06 08:00:27'),
(111, 'App\\Models\\User', 28, 'pressing-app-token', '7e1892ae3888903441101491771118304ead932bf5bce53cc461a1a6c39b570b', '[\"*\"]', '2026-11-06 08:06:33', NULL, '2026-11-06 08:05:33', '2026-11-06 08:06:33'),
(112, 'App\\Models\\User', 30, 'pressing-app-token', '631c6a5cd4cf67a1e260e60726063de7547378d75401706e0f09ad945a85b7e6', '[\"*\"]', '2026-11-06 08:13:45', NULL, '2026-11-06 08:06:45', '2026-11-06 08:13:45'),
(113, 'App\\Models\\User', 28, 'pressing-app-token', 'f3c29e3a67c4231a63d3291702caa34e67cebc3cd6365f2cc3cc07f8644b2116', '[\"*\"]', '2026-11-06 08:16:40', NULL, '2026-11-06 08:16:27', '2026-11-06 08:16:40'),
(114, 'App\\Models\\User', 28, 'pressing-app-token', '19f738b4f6aab67c4c136a7d7fc066d458727749edae1683478d906f9051cadf', '[\"*\"]', '2026-11-06 14:14:38', NULL, '2026-11-06 08:17:40', '2026-11-06 14:14:38'),
(115, 'App\\Models\\User', 30, 'pressing-app-token', '32024a1a5335295260e248f2207056a07c0a11e794dfc870cf73ffb655502e65', '[\"*\"]', '2026-11-06 12:09:35', NULL, '2026-11-06 12:06:52', '2026-11-06 12:09:35'),
(116, 'App\\Models\\User', 28, 'pressing-app-token', '3e9f54db1224763ed05caccc02726c420a4ed8dc727dcbb9124f3f267e95cd90', '[\"*\"]', '2026-11-06 14:18:03', NULL, '2026-11-06 14:17:56', '2026-11-06 14:18:03'),
(117, 'App\\Models\\User', 25, 'pressing-app-token', '4f6ffd94ed5255fff13e7a7e161be29c8c98b8b59bfc8ba0d6362e27b466dc54', '[\"*\"]', '2026-11-06 14:58:15', NULL, '2026-11-06 14:22:18', '2026-11-06 14:58:15'),
(118, 'App\\Models\\User', 25, 'pressing-app-token', '3e184b361f87e11eac21f466535b50d5fa3c9573f98326c03b295a1526fdaf48', '[\"*\"]', '2026-11-06 14:58:26', NULL, '2026-11-06 14:58:26', '2026-11-06 14:58:26'),
(119, 'App\\Models\\User', 28, 'pressing-app-token', '78aa70a75a43d513bf4003dea10ca0b890276581cb6fedf32a567e761a5e48d7', '[\"*\"]', '2026-11-06 15:49:48', NULL, '2026-11-06 14:58:44', '2026-11-06 15:49:48'),
(120, 'App\\Models\\User', 26, 'pressing-app-token', '284e131e46660b268f1635c4b2d46b53efd87c55b1ad74747de95f2eb106f62f', '[\"*\"]', '2026-11-07 10:15:17', NULL, '2026-11-06 15:51:15', '2026-11-07 10:15:17'),
(121, 'App\\Models\\User', 30, 'pressing-app-token', 'f31fa32af2f9020537b9376e8f6177d45365493919d070f84a0ff89092c91c6a', '[\"*\"]', '2026-11-07 10:16:25', NULL, '2026-11-07 10:15:27', '2026-11-07 10:16:25'),
(122, 'App\\Models\\User', 28, 'pressing-app-token', '326936893bb13c2c9651df73582fdb3f00915a4101a8371a0b464fa5526fb371', '[\"*\"]', '2026-11-07 10:18:14', NULL, '2026-11-07 10:16:49', '2026-11-07 10:18:14'),
(123, 'App\\Models\\User', 26, 'pressing-app-token', 'd2bad5cd75c51dbfa392685a620bccd4372205cf7b345a0cb984aa28cfe61d66', '[\"*\"]', '2026-11-07 12:30:22', NULL, '2026-11-07 10:44:25', '2026-11-07 12:30:22'),
(124, 'App\\Models\\User', 28, 'pressing-app-token', '1183a45e4ae1957fc40156f10d756e138aca84dd25b7607b051e2bb4a7ecef1d', '[\"*\"]', '2026-11-07 12:36:53', NULL, '2026-11-07 12:35:13', '2026-11-07 12:36:53'),
(125, 'App\\Models\\User', 26, 'pressing-app-token', '273b3007317da775f8ebfc8a6340940a785396d9577c61b533e2b8e29f4fe8fe', '[\"*\"]', '2026-11-07 12:52:46', NULL, '2026-11-07 12:46:00', '2026-11-07 12:52:46'),
(126, 'App\\Models\\User', 28, 'pressing-app-token', '8ce73b455ab59ee0e2446a29f8b60b18b93aca1f45e9f7263bd6238bc55360e5', '[\"*\"]', '2026-11-07 12:53:56', NULL, '2026-11-07 12:53:33', '2026-11-07 12:53:56'),
(127, 'App\\Models\\User', 26, 'pressing-app-token', 'c5b85666581af1bf90617174dda2efc055f37ef890c5675d1204cf5b41dfc0ec', '[\"*\"]', '2026-11-07 12:56:19', NULL, '2026-11-07 12:54:06', '2026-11-07 12:56:19'),
(128, 'App\\Models\\User', 26, 'pressing-app-token', '3ea36213c3139b4313248eb1b248a91a949e411f01ff66c496bcf5b8403dbb49', '[\"*\"]', '2026-11-07 12:58:12', NULL, '2026-11-07 12:57:10', '2026-11-07 12:58:12'),
(129, 'App\\Models\\User', 26, 'pressing-app-token', '4b86d5661cbfccb8d45b4cd230ef795cd5f36c4ad0b104b50ff1d354c6e46538', '[\"*\"]', '2026-11-07 13:03:21', NULL, '2026-11-07 12:58:44', '2026-11-07 13:03:21'),
(130, 'App\\Models\\User', 26, 'pressing-app-token', '59bd150d61c6607594ebb30e289ac3d84e608264b74448bd3c040464ca5b3842', '[\"*\"]', '2026-11-07 13:14:46', NULL, '2026-11-07 13:04:01', '2026-11-07 13:14:46'),
(131, 'App\\Models\\User', 26, 'pressing-app-token', 'aebad6389e9c35b2907ed7a481d1d06ba31d3b652e46855b07749c25e72834aa', '[\"*\"]', '2026-11-07 13:15:17', NULL, '2026-11-07 13:15:16', '2026-11-07 13:15:17'),
(132, 'App\\Models\\User', 26, 'pressing-app-token', '96455499f9c5eec5af50fc1c78f89ecd007012a9351e301e15a7304acfb3b277', '[\"*\"]', '2026-11-07 13:19:42', NULL, '2026-11-07 13:19:40', '2026-11-07 13:19:42'),
(133, 'App\\Models\\User', 28, 'pressing-app-token', '89533b7bdd4ff138bace5792d0e30ec5351790c7a957c3aae30f8b90fdee1d0e', '[\"*\"]', '2026-11-07 13:21:01', NULL, '2026-11-07 13:19:52', '2026-11-07 13:21:01'),
(134, 'App\\Models\\User', 26, 'pressing-app-token', 'db0a962dc8417765e2cfdbae1957a4140112cbdbcdce5f97838e2ecd1ef59964', '[\"*\"]', '2026-11-07 13:42:19', NULL, '2026-11-07 13:35:12', '2026-11-07 13:42:19'),
(135, 'App\\Models\\User', 26, 'pressing-app-token', '70130e856196ffc47efc3d88f99dede6ee548ce5ac02637ed899b06b629b8c00', '[\"*\"]', '2026-11-07 13:55:05', NULL, '2026-11-07 13:44:39', '2026-11-07 13:55:05'),
(136, 'App\\Models\\User', 26, 'pressing-app-token', '3786e4aa589b2f81f66600dc850951a88c46086b6f803e1e0669e08ec7fdafd8', '[\"*\"]', '2026-11-11 09:58:05', NULL, '2026-11-07 13:44:51', '2026-11-11 09:58:05'),
(137, 'App\\Models\\User', 28, 'pressing-app-token', '71d943e51c774e306cfe889ce1f57871f3a720c603e041ec4df3d268e40e4fb3', '[\"*\"]', '2026-11-09 08:10:29', NULL, '2026-11-07 13:58:41', '2026-11-09 08:10:29'),
(138, 'App\\Models\\User', 28, 'pressing-app-token', 'be5401614469137ae39380af7590151ee1fad45f8e7cf28e94f35fe452d24c69', '[\"*\"]', '2026-11-09 08:18:12', NULL, '2026-11-09 08:10:28', '2026-11-09 08:18:12'),
(139, 'App\\Models\\User', 26, 'pressing-app-token', 'c7a24063b881b36cdf1e3a47e933e9e2a9141df91bfad36a330aa716d30b5a38', '[\"*\"]', '2026-11-11 11:04:35', NULL, '2026-11-09 08:18:49', '2026-11-11 11:04:35'),
(140, 'App\\Models\\User', 30, 'pressing-app-token', '6989384d07ea1b027664227ed91d5e34365b35500a576c3cb0feca0919ecb53a', '[\"*\"]', '2026-11-11 10:15:40', NULL, '2026-11-11 10:12:53', '2026-11-11 10:15:40'),
(141, 'App\\Models\\User', 30, 'pressing-app-token', '08110b51c1e8b89ba8746e900179878863822da96cc7741a83e4757c04546caf', '[\"*\"]', '2026-11-11 11:07:09', NULL, '2026-11-11 11:04:50', '2026-11-11 11:07:09'),
(142, 'App\\Models\\User', 28, 'pressing-app-token', '593b7a2eed50c12ed34be3f6133b34a72a03cb1d48e3f46ba016573cacb147f1', '[\"*\"]', '2026-11-11 11:10:27', NULL, '2026-11-11 11:07:28', '2026-11-11 11:10:27'),
(143, 'App\\Models\\User', 30, 'pressing-app-token', '6c6e16c094da5d8e6eaa9ef8d132985d129b4133e1e055c91d2675500f9af25a', '[\"*\"]', '2026-11-11 11:34:06', NULL, '2026-11-11 11:10:30', '2026-11-11 11:34:06'),
(144, 'App\\Models\\User', 28, 'pressing-app-token', '68d30d075607a670cdaf5ffb4120ed50c5a9becdd83bcaed8ce1dc73fb841693', '[\"*\"]', '2026-11-11 11:45:09', NULL, '2026-11-11 11:34:22', '2026-11-11 11:45:09'),
(145, 'App\\Models\\User', 30, 'pressing-app-token', 'f543ef9e8129c72d862dcc8ea3b6a3ec19918a4e4dd844501fc98dcfffcec071', '[\"*\"]', '2026-11-11 11:46:08', NULL, '2026-11-11 11:45:10', '2026-11-11 11:46:08'),
(146, 'App\\Models\\User', 28, 'pressing-app-token', '1c6536540d86e4b5a5f9d8311a0e05ef22c43d79b6d66a65dbf6b5a782c2ebf9', '[\"*\"]', '2026-11-11 13:11:55', NULL, '2026-11-11 11:46:13', '2026-11-11 13:11:55'),
(147, 'App\\Models\\User', 28, 'pressing-app-token', '71eba3e23e9ab1f02bc1678d175bb33bd5113376b68e37f02bda7a0d88422bff', '[\"*\"]', '2026-11-11 13:39:49', NULL, '2026-11-11 13:12:18', '2026-11-11 13:39:49'),
(148, 'App\\Models\\User', 33, 'pressing-app-token', '3e56b3b7fc5c5216cef4dcf69ce240e09467abb823a86f418a14671f8ecf0874', '[\"*\"]', '2026-11-11 14:24:50', NULL, '2026-11-11 13:40:18', '2026-11-11 14:24:50'),
(149, 'App\\Models\\User', 28, 'pressing-app-token', 'b825f49e7882e1938254d9dadec3b880afb751297bfddfc5a404413476701533', '[\"*\"]', '2026-11-11 14:25:27', NULL, '2026-11-11 14:25:03', '2026-11-11 14:25:27'),
(150, 'App\\Models\\User', 30, 'pressing-app-token', 'd5649bc06e038610169406a2f8846e133f8847fb5ce1b1fd954c3a736ea8f3c5', '[\"*\"]', '2026-11-11 14:28:09', NULL, '2026-11-11 14:25:41', '2026-11-11 14:28:09'),
(151, 'App\\Models\\User', 28, 'pressing-app-token', '90ae266251ba18b5e5d0cdaef9328aa8069634b0dd04b53fd280af94a8262424', '[\"*\"]', '2026-11-11 14:29:57', NULL, '2026-11-11 14:28:24', '2026-11-11 14:29:57'),
(152, 'App\\Models\\User', 33, 'pressing-app-token', '0ce36db945d7def1da5b4c735962c40c2bcb1387602f3a345e3354488d2c99df', '[\"*\"]', '2026-11-11 14:30:45', NULL, '2026-11-11 14:30:12', '2026-11-11 14:30:45'),
(153, 'App\\Models\\User', 30, 'pressing-app-token', '57858da5ed984d9fdd48f1e9c2f018be6b2bb12bfa0054a925fd3a824fbe2e41', '[\"*\"]', '2026-11-11 16:09:57', NULL, '2026-11-11 14:31:08', '2026-11-11 16:09:57'),
(154, 'App\\Models\\User', 30, 'pressing-app-token', '8a105aa502ba0a82b37760b955dd724cea9afe9626970667c2ab4ee362b77346', '[\"*\"]', '2026-11-12 10:19:42', NULL, '2026-11-12 10:13:58', '2026-11-12 10:19:42'),
(155, 'App\\Models\\User', 28, 'pressing-app-token', '1b7094d538a1f6a1440e3b7b0dbb9fae305772532f8f5f8b356c1d4aecbf3b1f', '[\"*\"]', '2026-11-12 10:21:48', NULL, '2026-11-12 10:20:26', '2026-11-12 10:21:48'),
(156, 'App\\Models\\User', 33, 'pressing-app-token', '2711bda3b417998c918bbac2f417bd752e71a77adfaa21a0191c7fb59caa8621', '[\"*\"]', '2026-11-12 10:32:34', NULL, '2026-11-12 10:22:20', '2026-11-12 10:32:34'),
(157, 'App\\Models\\User', 30, 'pressing-app-token', 'f4e649e11424a37de806f6d0d8f0d275249a6db924839b89b85426d8fd33f7b9', '[\"*\"]', '2026-11-12 11:31:26', NULL, '2026-11-12 10:32:55', '2026-11-12 11:31:26'),
(158, 'App\\Models\\User', 28, 'pressing-app-token', 'd5312dd80ff1ea40c103c466f3ce499b2f580d17ca6554f6fd73462a9a85898a', '[\"*\"]', '2026-11-12 11:59:33', NULL, '2026-11-12 11:31:40', '2026-11-12 11:59:33'),
(159, 'App\\Models\\User', 33, 'pressing-app-token', 'ae0593068883f75ebbc74aed24cec2140e51c5e20aed2686bfa2a31d83926b10', '[\"*\"]', '2026-11-12 12:19:30', NULL, '2026-11-12 11:59:46', '2026-11-12 12:19:30'),
(160, 'App\\Models\\User', 33, 'pressing-app-token', 'e223f9ae9a2b2149bfe776574ffb6919168948decc6b7f2f5982b3809119d0cb', '[\"*\"]', '2026-11-12 12:19:45', NULL, '2026-11-12 12:19:36', '2026-11-12 12:19:45'),
(161, 'App\\Models\\User', 33, 'pressing-app-token', '8d874847ce381b330f27389c7b11ee2f6463882e0817e32dae8dcfa338e84bb5', '[\"*\"]', '2026-11-12 12:22:21', NULL, '2026-11-12 12:19:51', '2026-11-12 12:22:21'),
(162, 'App\\Models\\User', 33, 'pressing-app-token', 'c542427373b12aedffe28aa1d9d384197ff6dd8b21d3a7b051e10109cce1b682', '[\"*\"]', '2026-11-12 12:26:09', NULL, '2026-11-12 12:22:46', '2026-11-12 12:26:09'),
(163, 'App\\Models\\User', 33, 'pressing-app-token', '28515d3ee9ab92c31555a5a12c9b8fbbcac49f03667d5c14b6176f321ea691ff', '[\"*\"]', '2026-11-12 12:26:31', NULL, '2026-11-12 12:26:19', '2026-11-12 12:26:31'),
(164, 'App\\Models\\User', 33, 'pressing-app-token', '6211f61caa32bc26b36d2cd4eb1865c94a952ff32cbdf0a739e2c2d876f6ba15', '[\"*\"]', '2026-11-12 13:02:38', NULL, '2026-11-12 12:26:38', '2026-11-12 13:02:38'),
(165, 'App\\Models\\User', 33, 'pressing-app-token', 'd84afe8fedc643d040efe5082bada00905749ed432c4958270b57c2707cdb5c7', '[\"*\"]', '2026-11-12 13:06:26', NULL, '2026-11-12 13:02:48', '2026-11-12 13:06:26'),
(166, 'App\\Models\\User', 33, 'pressing-app-token', '85b921f4d89d3b2763212cffa23ce4466a000fb9ab079e7959b0895ad2c3e173', '[\"*\"]', '2026-11-12 13:09:28', NULL, '2026-11-12 13:06:44', '2026-11-12 13:09:28'),
(167, 'App\\Models\\User', 33, 'pressing-app-token', 'aaa0bad89c43853cd8aae3f028bebdc4b58234b1d7295c8a00420472bca5d4c4', '[\"*\"]', '2026-11-12 13:50:22', NULL, '2026-11-12 13:09:47', '2026-11-12 13:50:22'),
(168, 'App\\Models\\User', 35, 'pressing-app-token', '57061cdf458ec357658e51c63318af6ed160ae87a15f8a4dea22d26a5ad8a2fb', '[\"*\"]', '2026-11-12 14:25:50', NULL, '2026-11-12 14:25:40', '2026-11-12 14:25:50'),
(169, 'App\\Models\\User', 36, 'pressing-app-token', 'e4659b599c7e001d0068573c0e8765e4783e60ac227be56bcefef214ef11ee36', '[\"*\"]', '2026-11-12 14:36:20', NULL, '2026-11-12 14:36:18', '2026-11-12 14:36:20'),
(170, 'App\\Models\\User', 35, 'pressing-app-token', '419078629a7f2c9b43d5b7fa85053dfe0487a6c23cb8a2349a32fd361c588215', '[\"*\"]', '2026-11-12 15:02:38', NULL, '2026-11-12 15:02:37', '2026-11-12 15:02:38');

-- --------------------------------------------------------

--
-- Structure de la table `receipts`
--

DROP TABLE IF EXISTS `receipts`;
CREATE TABLE IF NOT EXISTS `receipts` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `receipt_number` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issued_at` datetime NOT NULL,
  `amount` int UNSIGNED NOT NULL,
  `payment_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `receipts_receipt_number_unique` (`receipt_number`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `receipts`
--

INSERT INTO `receipts` (`id`, `receipt_number`, `issued_at`, `amount`, `payment_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'REC-20261102-000001', '2026-11-02 15:39:00', 1, 1, '2026-11-02 14:39:00', '2026-11-02 14:39:00', NULL),
(2, 'REC-20261104-000002', '2026-11-04 09:36:55', 4000, 2, '2026-11-04 08:36:55', '2026-11-04 08:36:55', NULL),
(3, 'REC-20261104-000003', '2026-11-04 09:38:25', 500, 3, '2026-11-04 08:38:25', '2026-11-04 08:38:25', NULL),
(4, 'REC-20261104-000004', '2026-11-04 09:38:59', 499, 4, '2026-11-04 08:38:59', '2026-11-04 08:38:59', NULL),
(5, 'REC-20261106-000005', '2026-11-06 12:07:03', 1500, 5, '2026-11-06 11:07:03', '2026-11-06 11:07:03', NULL),
(6, 'REC-20261106-000006', '2026-11-06 12:10:19', 1000, 6, '2026-11-06 11:10:19', '2026-11-06 11:10:19', NULL),
(7, 'REC-20261106-000007', '2026-11-06 12:21:14', 1500, 7, '2026-11-06 11:21:14', '2026-11-06 11:21:14', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('uOScDsHIjcQyWxE7dd2NYivJwtpvWHNPresobivc', NULL, '127.0.0.1', 'PostmanRuntime/2.12.2', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOUVJWHpnTWhVbVNOVWd2UU16dWVpSTRDNlNwcVZzajk0S3BuU3Q4OCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1793104796),
('4dlhqHgQFvsrGbGPbAwYlYVVhUITZTTq87rGtne7', NULL, '127.0.0.1', 'PostmanRuntime/2.12.2', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieWdsZFdhVllLamx4ZUpRSE1EcjlDS2hqbWUyMnUyVFZPeGI3eHdEMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1793181488),
('yoOm1rAOEk4LVZccetq2ZmdQGOhRO06ixuIyi96P', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMlpiWmFBazRWVE1NQjdLMGZYU3pXUmd6eGxkbGhhblh3Q3hqdWZYNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7czo0OiJob21lIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1793951193),
('4YJndQgy2ZCaEqOF4XV6YcJMDADamYdqOeW0j9ux', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRTRWM0FmNFdUZlV6ZGxWeGxjNnhRZkViWXI4UEVZbjRZQ1NqeU42diI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1794486355);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('CLIENT','COURSIER','RESPONSABLE','ADMIN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CLIENT',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `phone`, `address`, `role`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Responsable Test', 'responsable.test@pressingpro.local', NULL, '$2y$12$jE/40M7yP9.qk2mpRrYauOe64GHcaIth0tUBYyUuy7307DYlmpquS', '+237694469902', 'Akwa,2e rue fuller', 'RESPONSABLE', NULL, '2026-10-23 08:26:17', '2026-11-07 12:06:13', NULL),
(36, 'Leonardo', 'dadaleonardo00@gmail.com', NULL, '$2y$12$ZuSlVNZ1gc7U/e4Cn/R.L.PMKpii2d7tC88E5MW6qum.oQb9P02Pm', '+33612345678', 'Yassa', 'CLIENT', NULL, '2026-11-12 14:36:18', '2026-11-12 14:36:18', NULL),
(9, 'ESTELLE FOKOU', 'estellefokou19@gmail.com', NULL, '$2y$12$bQF9Lg45J2seAaey86UnV.8zMWsX4oQ0tBP3SpIJM4sn5tGjDIa0G', '3567890', 'Yassa', 'CLIENT', NULL, '2026-10-28 09:47:03', '2026-11-07 11:48:41', NULL),
(11, 'ESTELLE FOKOU', 'estellefokou912@gmail.com', NULL, '$2y$12$2UluQl.u/ppKUCBQ7GYIAe4eMAeiLbVBIPQZxil/0gnH.6/y7ysz.', '3567890', 'Yassa', 'CLIENT', NULL, '2026-10-28 09:52:14', '2026-11-07 11:48:50', NULL),
(35, 'ESTELLE FOKOU', 'estellefokou9@gmail.com', NULL, '$2y$12$phvDBNjgcF/nUy6iuJ9ZueNNixZwgHCHMRS7ZQboepoEcLK0Ayq2K', '+237694469902', 'Yassa', 'CLIENT', 'jAHqyfXc9i9aGFm1rZxGnGB2ReHRfkn42LUyOKeu2LfpyyyU91oukVXQLlUc', '2026-11-12 14:25:40', '2026-11-12 15:01:57', NULL),
(15, 'ESTELLE FOKOU', 'estellefokoua9@gmail.com', NULL, '$2y$12$GpX0KET1CgNKklna..8S8.4/mu2dGYvhiclr3F2SztQK/YfOI7s3e', '3567890', 'Yassa', 'CLIENT', NULL, '2026-10-28 10:15:23', '2026-11-07 11:14:37', NULL),
(17, 'Sandra Fotsing', 'sandra@pressing.com', NULL, '$2y$12$bj79rNLpi2ZvbKP8M71OhekAz4WmMAPfLoy41.jiRTq6Sb1D69B8C', '+237696785634', 'coursier.test@pressingpro.local', 'CLIENT', NULL, '2026-10-30 08:16:10', '2026-10-30 08:16:10', NULL),
(18, 'Yvana Nono', 'ivananono9@gmail.com', NULL, '$2y$12$FcYYVsvob2ucVPSjai/vveC1GFDYn7q6PASt/kgsQtpmdZjam9Pbu', '+33612345678', 'coursier.test@pressingpro.local', 'CLIENT', NULL, '2026-10-30 08:18:50', '2026-10-30 08:18:50', NULL),
(19, 'ESTELLE FOKOU', 'estellefokou92@gmail.com', NULL, '$2y$12$j9ztQ33nTiHR5ip8lroAG./4HfqkLu6ku7XKvKIDaC6wwiRouyxR2', '+33612345678', 'coursier.test@pressingpro.local', 'CLIENT', NULL, '2026-10-30 08:27:36', '2026-11-07 11:26:01', NULL),
(22, 'ESTELLE FOKOU', 'estellefokou9@gmail', NULL, '$2y$12$TFqTWTmLaEgTKgkSgtWRfOqGrdNrdTNeVxT90Rzrlaf32L9F.elGq', '+33612345678', 'estellefokou9@test.com', 'CLIENT', NULL, '2026-10-30 08:29:48', '2026-11-07 11:26:01', NULL),
(23, 'ESTELLE FOKOU', 'estellefokou934@gmail.com', NULL, '$2y$12$bcTIY4Pp6gPWTR9LVIpi9O/C9FDZEORz/SZBg7lAfvXcu2hm.tudy', '687904563', 'Yassa', 'RESPONSABLE', NULL, '2026-10-30 09:45:14', '2026-11-07 11:25:59', NULL),
(24, 'Magne', 'magne@gmail.com', NULL, '$2y$12$NSsFRa9Ur/.paA/Ba4i.DOQJYmMrTlv9Z4we61jnQm.qopnZC8KT.', '97453456789', 'Yassa', 'CLIENT', NULL, '2026-10-30 09:50:19', '2026-11-07 11:09:14', NULL),
(25, 'Serena NONO', 'serenanono9@gmail.com', NULL, '$2y$12$ERc4JtpZY.CJ0ZTzQ6OP4eyNV4eekUELGbrax2ovNAMUx6eZor8vy', '+23767557880', 'Yassa', 'COURSIER', NULL, '2026-10-30 10:09:08', '2026-10-30 10:09:08', NULL),
(26, 'Nom Administrateur', 'admin2@gmail.com', NULL, '$2y$12$Pf.o6mxhZvLtYu8l7QrWuuMq4.IX2sSE/5zXGWXLqQmgd9PyMoTQW', '+237699123456', 'Douala, Cameroun', 'ADMIN', NULL, '2026-10-30 10:46:42', '2026-10-30 10:46:42', NULL),
(28, 'Kemayo', 'kemayo34@gmail.com', NULL, '$2y$12$/rCHFdnQcG3YPKMx.T7r0eEdKC6JnQKMguKJDr0ydr55L9p5NVj9C', '+33612345678', 'Yassa', 'RESPONSABLE', NULL, '2026-11-02 15:22:17', '2026-11-02 15:22:17', NULL),
(29, 'Foping', 'foping32@gmail.com', NULL, '$2y$12$H4z4jFTJbwjBMxm6N0ZDb.uQLv15IN4GpWkq.hPokWkDf0kxTP036', '+33612345678', 'Akwa', 'RESPONSABLE', NULL, '2026-11-02 17:06:28', '2026-11-02 17:06:28', NULL),
(30, 'M YIMNYA SERGE', 'yimnyaserge@gmail.com', NULL, '$2y$12$SKSQRTqxEpuhtS3XZe0IK.C4qdUcCzqawdn9ObkDzFQi91mOX/7Dy', '+237694469902', 'Yassa', 'CLIENT', NULL, '2026-11-03 13:46:42', '2026-11-03 13:46:42', NULL),
(31, 'Danielle MBA', 'daniellemba@gmail.com', NULL, '$2y$12$OAa0.pWjiG4joJ8FMBoMJuX.eRM219bhSifrB1XCpgFi7WTVELR3W', '+237656522703', 'Yassa', 'CLIENT', NULL, '2026-11-05 10:26:01', '2026-11-05 10:31:24', NULL),
(32, 'Yango', 'yango@gmail.com', NULL, '$2y$12$qP5ZZNsscTYWZCqtWJEXOeXLd/e.uPljxG5d74Mz2H5LuFedxvKZu', '+33612345678', 'Yassa', 'CLIENT', NULL, '2026-11-05 15:16:35', '2026-11-07 13:55:05', NULL),
(33, 'KENNE Jores', 'kennejores@gmail.com', NULL, '$2y$12$KQ4ChkarJNSSo5RjacdWH.E.HIMRPXDETk0.Bcdv8NI4INK9DRKF2', '+33612345678', 'Yassa', 'COURSIER', NULL, '2026-11-06 16:10:57', '2026-11-06 16:10:57', NULL),
(34, 'FOTSING Junior', 'fotsingjunior@gmal.com', NULL, '$2y$12$yQ9typmzesY.dzh2wObOC.rBt7MH/bQpSARtVRH/eADApw/Zo4TAe', '+237696785634', 'Yassa', 'ADMIN', NULL, '2026-11-06 16:28:20', '2026-11-06 16:28:20', NULL);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
