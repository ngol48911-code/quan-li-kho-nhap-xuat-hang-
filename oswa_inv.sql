-- ========================================================
-- CƠ SỞ DỮ LIỆU: oswa_inv
-- DỰ ÁN: Quản lý kho Nhập - Xuất hàng (Bản chuẩn cho sinh viên)
-- Mật khẩu: KHÔNG MÃ HÓA (admin / admin, user / 123456)
-- ========================================================

CREATE DATABASE IF NOT EXISTS `oswa_inv` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `oswa_inv`;

-- Tắt kiểm tra khóa ngoại tạm thời để xóa và tạo bảng không bị xung đột
SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------
-- XÓA BẢNG CŨ (NẾU ĐÃ TỒN TẠI)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `imports`;
DROP TABLE IF EXISTS `sales`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `media`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `user_groups`;

-- --------------------------------------------------------
-- 1. BẢNG NHÓM QUYỀN (user_groups)
-- --------------------------------------------------------
CREATE TABLE `user_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_name` varchar(150) NOT NULL,
  `group_level` int NOT NULL,
  `group_status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_level` (`group_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `user_groups` (`id`, `group_name`, `group_level`, `group_status`) VALUES
(1, 'Admin', 1, 1),
(2, 'Special', 2, 1),
(3, 'User', 3, 1);

-- --------------------------------------------------------
-- 2. BẢNG NGƯỜI DÙNG (users) - MẬT KHẨU KHÔNG MÃ HÓA
-- --------------------------------------------------------
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_level` int NOT NULL DEFAULT '1',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tài khoản mẫu:
-- 1. admin / admin (Quyền quản trị)
-- 2. user / 123456 (Quyền nhân viên)
INSERT INTO `users` (`id`, `name`, `username`, `password`, `user_level`, `status`) VALUES
(1, 'Admin Quản Trị', 'admin', 'admin', 1, 1),
(2, 'Nhân Viên Kho', 'user', '123456', 3, 1);

-- --------------------------------------------------------
-- 3. BẢNG DANH MỤC SẢN PHẨM (categories)
-- --------------------------------------------------------
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Điện thoại'),
(2, 'Máy tính Laptop'),
(3, 'Phụ kiện');

-- --------------------------------------------------------
-- 4. BẢNG ẢNH SẢN PHẨM (media) - BẮT ĐẦU TỪ ID = 1
-- --------------------------------------------------------
CREATE TABLE `media` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) NOT NULL,
  `file_type` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `media` (`id`, `file_name`, `file_type`) VALUES
(1, 'no_image.jpg', 'image/jpeg'),
(2, 'ip-15.jpg', 'image/jpeg'),
(3, 'ip-17pro.jpg', 'image/jpeg');

-- --------------------------------------------------------
-- 5. BẢNG SẢN PHẨM (products)
-- --------------------------------------------------------
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',            -- Tồn kho hiện tại
  `buy_price` decimal(12,2) NOT NULL DEFAULT '0',  -- Giá nhập tham khảo
  `sale_price` decimal(12,2) NOT NULL DEFAULT '0', -- Giá xuất bán tham khảo
  `categorie_id` int NOT NULL,
  `media_id` int DEFAULT '1',                     -- Mặc định là 1 (no_image.jpg)
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `products` (`id`, `name`, `quantity`, `buy_price`, `sale_price`, `categorie_id`, `media_id`) VALUES
(1, 'iPhone 15 128GB', 20, 16000000.00, 19000000.00, 1, 2),
(2, 'iPhone 17 Pro 256GB', 15, 28000000.00, 32000000.00, 1, 3),
(3, 'MacBook Air M2', 10, 22000000.00, 25000000.00, 2, 1);

-- --------------------------------------------------------
-- 6. BẢNG NHẬP KHO (imports) - LƯU LỊCH SỬ CÁC LẦN NHẬP
-- --------------------------------------------------------
CREATE TABLE `imports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `qty` int NOT NULL,                             -- Số lượng nhập
  `price` decimal(12,2) NOT NULL,                 -- Giá nhập thực tế tại thời điểm đó
  `supplier` varchar(255) DEFAULT 'Nhà cung cấp', -- Tên nhà cung cấp
  `date` date NOT NULL,                           -- Ngày nhập hàng
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `imports` (`id`, `product_id`, `qty`, `price`, `supplier`, `date`) VALUES
(1, 1, 20, 16000000.00, 'Công ty Apple VN', '2026-11-01'),
(2, 2, 15, 28000000.00, 'Nhà phân phối FPT Synnex', '2026-11-05'),
(3, 3, 10, 22000000.00, 'Viễn Thông A', '2026-11-10');

-- --------------------------------------------------------
-- 7. BẢNG XUẤT KHO (sales) - LƯU LỊCH SỬ CÁC LẦN XUẤT / BÁN
-- --------------------------------------------------------
CREATE TABLE `sales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `qty` int NOT NULL,                             -- Số lượng xuất
  `price` decimal(12,2) NOT NULL,                 -- Giá xuất thực tế tại thời điểm đó
  `customer` varchar(255) DEFAULT 'Khách lẻ',     -- Tên khách hàng hoặc đại lý nhận
  `date` date NOT NULL,                           -- Ngày xuất hàng
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sales` (`id`, `product_id`, `qty`, `price`, `customer`, `date`) VALUES
(1, 1, 2, 19000000.00, 'Nguyễn Văn A', '2026-11-15'),
(2, 2, 1, 32000000.00, 'Cửa hàng Hoàng Hà', '2026-11-20');

-- Bật lại kiểm tra khóa ngoại sau khi hoàn tất
SET FOREIGN_KEY_CHECKS = 1;