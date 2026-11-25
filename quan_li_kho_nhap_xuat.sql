-- phpMyAdmin SQL Dump
-- OSWA-INV v2 - Database Dump (Optimized & Fixed)
-- Hệ thống Quản lý Kho hàng & Bán hàng

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET FOREIGN_KEY_CHECKS = 0;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Tạo và sử dụng Cơ sở dữ liệu: `oswa_inv`
--
CREATE DATABASE IF NOT EXISTS `oswa_inv` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `oswa_inv`;

-- --------------------------------------------------------
-- Xóa bảng cũ nếu đã tồn tại để tránh lỗi trùng lặp khi import lại
-- --------------------------------------------------------
DROP TABLE IF EXISTS `sales`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `media`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `user_groups`;

-- --------------------------------------------------------
-- Cấu trúc bảng cho bảng `user_groups`
-- --------------------------------------------------------
CREATE TABLE `user_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `group_level` int NOT NULL,
  `group_status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_level` (`group_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user_groups`
--
INSERT INTO `user_groups` (`id`, `group_name`, `group_level`, `group_status`) VALUES
(1, 'Admin', 1, 1),
(2, 'Special', 2, 1),
(3, 'User', 3, 1);

-- --------------------------------------------------------
-- Cấu trúc bảng cho bảng `users`
-- --------------------------------------------------------
CREATE TABLE `users` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `user_level` int NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_user_group` (`user_level`),
  CONSTRAINT `fk_user_group` FOREIGN KEY (`user_level`) REFERENCES `user_groups` (`group_level`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
-- (Mật khẩu: admin/admin, special/special, user/user)
--
INSERT INTO `users` (`id`, `name`, `username`, `password`, `user_level`, `status`) VALUES
(1, 'Admin User', 'admin', 'admin', 1, 1),
(2, 'Special User', 'special', 'special', 2, 1),
(3, 'Default User', 'user', 'user', 3, 1);

-- --------------------------------------------------------
-- Cấu trúc bảng cho bảng `categories`
-- --------------------------------------------------------
CREATE TABLE `categories` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(60) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--
INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Điện thoại'),
(2, 'Máy tính'),
(3, 'Âm thanh, mic thu âm'),
(4, 'Đồng hồ, camera'),
(5, 'Phụ kiện');

-- --------------------------------------------------------
-- Cấu trúc bảng cho bảng `media`
-- --------------------------------------------------------
CREATE TABLE `media` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `file_type` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `media`
-- (Bao gồm id = 0 để tránh lỗi khóa ngoại khi sản phẩm không chọn ảnh)
--
INSERT INTO `media` (`id`, `file_name`, `file_type`) VALUES
(0, 'no_image.jpg', 'image/jpeg'),
(1, 'anh.jpg', 'image/jpeg'),
(2, 'ip-15.jpg', 'image/webp'),
(3, 'ip-17pro.jpg', 'image/webp');

-- --------------------------------------------------------
-- Cấu trúc bảng cho bảng `products`
-- --------------------------------------------------------
CREATE TABLE `products` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `quantity` int DEFAULT '0',
  `buy_price` decimal(10,2) DEFAULT '0.00',
  `sale_price` decimal(10,2) NOT NULL,
  `categorie_id` int UNSIGNED NOT NULL,
  `media_id` int UNSIGNED DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_product_category` (`categorie_id`),
  KEY `fk_product_media` (`media_id`),
  CONSTRAINT `fk_product_category` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_media` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--
INSERT INTO `products` (`id`, `name`, `quantity`, `buy_price`, `sale_price`, `categorie_id`, `media_id`, `created_at`) VALUES
(1, 'iPhone 17 Pro 256GB', 999, 40000000.00, 35000000.00, 1, 3, '2026-05-25 09:45:38'),
(2, 'iPhone 15 128GB', 9, 15000000.00, 20000000.00, 1, 2, '2026-06-01 09:52:44'),
(3, 'MacBook Air M2 256GB', 15, 22000000.00, 26000000.00, 2, 1, '2026-06-05 10:15:00');

-- --------------------------------------------------------
-- Cấu trúc bảng cho bảng `sales`
-- --------------------------------------------------------
CREATE TABLE `sales` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` int UNSIGNED NOT NULL,
  `qty` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sales_product` (`product_id`),
  CONSTRAINT `fk_sales_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `sales`
--
INSERT INTO `sales` (`id`, `product_id`, `qty`, `price`, `date`) VALUES
(1, 2, 1, 20000000.00, '2026-06-01'),
(2, 2, 1, 20000000.00, '2026-06-09'),
(3, 2, 1, 20000000.00, '2026-06-10');

-- Khôi phục kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
