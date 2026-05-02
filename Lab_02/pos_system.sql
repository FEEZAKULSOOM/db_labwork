-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 02, 2026 at 06:15 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pos_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `description`) VALUES
(1, 'Electronics', 'Gadgets and devices'),
(2, 'Clothing', 'Apparel and fashion'),
(3, 'Groceries', 'Food and daily items'),
(4, 'Books', 'Educational and fiction'),
(5, 'Furniture', 'Home and office furniture'),
(6, 'Sports', 'Sports equipment'),
(7, 'Toys', 'Kids toys and games'),
(8, 'Beauty', 'Cosmetics and skincare'),
(9, 'Automotive', 'Car accessories'),
(10, 'Stationery', 'Office supplies');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone1` varchar(20) NOT NULL,
  `phone2` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `loyalty_points` int(11) NOT NULL DEFAULT 0,
  `discount_percent` decimal(5,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `user_id`, `full_name`, `phone1`, `phone2`, `address`, `loyalty_points`, `discount_percent`) VALUES
(1, 6, 'Ahmed Khan', '03001234567', '0211234567', 'Karachi', 425, 4.00),
(2, 7, 'Fatima Ali', '03017654321', NULL, 'Lahore', 266, 2.00),
(3, 8, 'Omar Farooq', '03111234567', '0422345678', 'Islamabad', 127, 1.00),
(4, 9, 'Aisha Siddiqui', '03331234567', NULL, 'Rawalpindi', 544, 5.00),
(5, 10, 'Bilal Ahmed', '03451234567', '0513456789', 'Faisalabad', 86, 0.00),
(6, 6, 'Zainab Abbas', '03561234567', NULL, 'Multan', 225, 2.00),
(7, 7, 'Hassan Raza', '03671234567', '0614567890', 'Quetta', 15, 0.00),
(8, 8, 'Sana Mirza', '03781234567', NULL, 'Peshawar', 221, 2.00),
(9, 9, 'Usman Ghani', '03891234567', '0715678901', 'Sialkot', 546, 5.00),
(10, 10, 'Hira Khan', '03901234567', NULL, 'Hyderabad', 45, 0.00);

--
-- Triggers `customers`
--
DELIMITER $$
CREATE TRIGGER `set_discount_percent_on_insert` BEFORE INSERT ON `customers` FOR EACH ROW BEGIN
    SET NEW.discount_percent = LEAST(FLOOR(NEW.loyalty_points / 100), 20);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_data` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `final_amount` decimal(10,2) GENERATED ALWAYS AS (`total_amount` - `discount`) STORED,
  `payment_method` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `user_id`, `order_data`, `total_amount`, `discount`, `payment_method`) VALUES
(1, 1, 3, '2026-03-12 00:13:42', 26600.00, 1330.00, 'cash'),
(2, 2, 4, '2026-03-12 00:13:42', 1850.00, 37.00, 'card'),
(3, 3, 3, '2026-03-12 00:13:42', 7900.00, 79.00, 'cash'),
(4, 4, 5, '2026-03-12 00:13:42', 4850.00, 242.50, 'card'),
(5, 5, 3, '2026-03-12 00:13:42', 1200.00, 0.00, 'cash'),
(6, 6, 4, '2026-03-12 00:13:42', 2750.00, 55.00, 'card'),
(7, 7, 5, '2026-03-12 00:13:42', 1500.00, 0.00, 'cash'),
(8, 8, 3, '2026-03-12 00:13:42', 7400.00, 148.00, 'card'),
(9, 9, 4, '2026-03-12 00:13:42', 26600.00, 1862.00, 'cash'),
(10, 10, 5, '2026-03-12 00:13:42', 2100.00, 0.00, 'card'),
(11, 1, 6, '2026-03-12 01:12:53', 7740.00, 232.20, 'cash');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `set_order_discount_before_update` BEFORE UPDATE ON `orders` FOR EACH ROW BEGIN
    DECLARE cust_discount_percent DECIMAL(5,2);
    
    -- Only recalculate if total_amount changed
    IF NEW.total_amount != OLD.total_amount THEN
        -- Get customer's current discount percent
        SELECT discount_percent INTO cust_discount_percent
        FROM customers
        WHERE customer_id = NEW.customer_id;
        
        -- Convert percent to amount and store in discount column
        SET NEW.discount = ROUND(NEW.total_amount * (cust_discount_percent / 100), 2);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_loyalty_points_after_insert_on_order` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    UPDATE customers
    SET loyalty_points = loyalty_points + FLOOR(NEW.final_amount / 100)
    WHERE customer_id = NEW.customer_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_loyalty_points_after_order_update` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
    DECLARE points_earned INT;
    DECLARE new_discount_percent DECIMAL(5,2);
    
    IF NEW.final_amount != OLD.final_amount THEN
        -- Calculate points earned
        SET points_earned = FLOOR((NEW.final_amount - OLD.final_amount) / 100);
        
        -- Update customer loyalty points
        UPDATE customers
        SET loyalty_points = loyalty_points + points_earned
        WHERE customer_id = NEW.customer_id;
        
        -- Recalculate and update discount percent based on new points
        SELECT LEAST(FLOOR((loyalty_points + points_earned) / 100), 20) INTO new_discount_percent
        FROM customers
        WHERE customer_id = NEW.customer_id;
        
        UPDATE customers
        SET discount_percent = new_discount_percent
        WHERE customer_id = NEW.customer_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `price_per_unit` decimal(10,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(10,2) GENERATED ALWAYS AS (`quantity` * `price_per_unit`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `quantity`, `price_per_unit`) VALUES
(1, 1, 1, 1, 25000.00),
(2, 1, 2, 2, 800.00),
(3, 2, 3, 2, 450.00),
(4, 2, 4, 1, 350.00),
(5, 2, 10, 5, 120.00),
(6, 3, 5, 1, 5500.00),
(7, 3, 6, 2, 1200.00),
(8, 4, 7, 2, 1500.00),
(9, 4, 8, 3, 350.00),
(10, 4, 9, 1, 800.00),
(11, 5, 10, 10, 120.00),
(12, 6, 2, 2, 800.00),
(13, 6, 3, 1, 450.00),
(14, 6, 8, 2, 350.00),
(15, 7, 7, 1, 1500.00),
(16, 8, 4, 2, 350.00),
(17, 8, 5, 1, 5500.00),
(18, 8, 6, 1, 1200.00),
(19, 9, 1, 1, 25000.00),
(20, 9, 9, 2, 800.00),
(21, 10, 3, 2, 450.00),
(22, 10, 10, 10, 120.00),
(23, 11, 9, 6, 90.00),
(24, 11, 9, 9, 800.00);

--
-- Triggers `order_items`
--
DELIMITER $$
CREATE TRIGGER `adjust_stock_before_update` BEFORE UPDATE ON `order_items` FOR EACH ROW BEGIN
    IF NEW.quantity != OLD.quantity THEN
        UPDATE products
        SET stock_quantity = stock_quantity - (NEW.quantity - OLD.quantity)
        WHERE product_id = NEW.product_id;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `auto_fetch_price_before_insert` BEFORE INSERT ON `order_items` FOR EACH ROW BEGIN
    DECLARE product_price DECIMAL(10,2);
    
    SELECT price INTO product_price
    FROM products
    WHERE product_id = NEW.product_id;
    
    SET NEW.price_per_unit = product_price;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `reduce_stock_after_insert` AFTER INSERT ON `order_items` FOR EACH ROW UPDATE products
SET stock_quantity = stock_quantity - NEW.quantity
WHERE product_id = NEW.product_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `restore_stock_after_delete` AFTER DELETE ON `order_items` FOR EACH ROW UPDATE products
SET stock_quantity = stock_quantity + OLD.quantity
WHERE product_id = OLD.product_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_order_total_after_delete` AFTER DELETE ON `order_items` FOR EACH ROW UPDATE orders
SET total_amount = (
    SELECT IFNULL(SUM(subtotal), 0)
    FROM order_items
    WHERE order_id = OLD.order_id
)
WHERE order_id = OLD.order_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_order_total_after_insert` AFTER INSERT ON `order_items` FOR EACH ROW UPDATE orders
SET total_amount = (
    SELECT IFNULL(SUM(subtotal), 0)
    FROM order_items
    WHERE order_id = NEW.order_id
)
WHERE order_id = NEW.order_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_order_total_after_update` AFTER UPDATE ON `order_items` FOR EACH ROW UPDATE orders
SET total_amount = (
    SELECT IFNULL(SUM(subtotal), 0)
    FROM order_items
    WHERE order_id = NEW.order_id
)
WHERE order_id = NEW.order_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `category_id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `stock_quantity` int(11) NOT NULL DEFAULT 0,
  `barcode` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `category_id`, `price`, `stock_quantity`, `barcode`, `description`) VALUES
(1, 'Smartphone', 1, 25000.00, 48, '123456789', 'Latest model smartphone'),
(2, 'T-Shirt', 2, 800.00, 196, '234567890', 'Cotton casual t-shirt'),
(3, 'Rice 5kg', 3, 450.00, 95, '345678901', 'Basmati rice 5kg bag'),
(4, 'Novel', 4, 350.00, 77, '456789012', 'Bestseller fiction novel'),
(5, 'Office Chair', 5, 5500.00, 23, '567890123', 'Ergonomic office chair'),
(6, 'Football', 6, 1200.00, 57, '678901234', 'Professional size football'),
(7, 'LEGO Set', 7, 1500.00, 37, '789012345', 'Building blocks toy set'),
(8, 'Lipstick', 8, 350.00, 145, '890123456', 'Matte finish lipstick'),
(9, 'Car Oil', 9, 900.00, 52, '901234567', 'Engine oil 1 liter'),
(10, 'Notebook', 10, 120.00, 275, '012345678', 'Spiral notebook 100 pages');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'Admin', 'Full system access'),
(2, 'Salesman', 'Can create orders'),
(3, 'Customer', 'Can view own orders');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `password`, `email`, `role_id`, `created_at`, `status`) VALUES
(1, 'admin1', '$2y$10$5jJKeeTbqzUNfq0YC9FUcuLmqJfEQZUFb/F3yqCGt9cHWpGnPyRqq', 'admin1@email.com', 1, '2026-03-12 00:12:49', 'active'),
(2, 'admin2', '$2y$10$WaDWFr5rI/LLfNC/zAPpHesHPLvehaW.rPD5VS./zOnHSWKKLdtXW', 'admin2@email.com', 1, '2026-03-12 00:12:49', 'active'),
(3, 'salesman1', '$2y$10$7yZ9F1TJDBAMFsFI0U4ha.S2D7cy1upmFO65gi7mDG9amxJuhU0Ku', 'sales1@email.com', 2, '2026-03-12 00:12:49', 'active'),
(4, 'salesman2', '$2y$10$4ABLm/hYYiSMz822Pq9DJOKqxvvLY8veE2WJPAO84P3pzX0fzf5WS', 'sales2@email.com', 2, '2026-03-12 00:12:49', 'active'),
(5, 'salesman3', '$2y$10$NXsJJhwxuJU86V/aosOA3uqQprieO0KY5p2sPdXNum2wJGCTZ0dJ6', 'sales3@email.com', 2, '2026-03-12 00:12:49', 'active'),
(6, 'customer1', '$2y$10$9ZfjF3qOGM8KCPzgml37q.sWxaXCfIv6pMd4XZ0fwecpqFrwx8VYu', 'cust1@email.com', 3, '2026-03-12 00:12:49', '$2y$10$3Xewk5on4Z6kh'),
(7, 'customer2', '$2y$10$YofyJ4k4L23ev0NdCCssVu3FJEIhblGdieUajvyrV/kVsKxi37rSO', 'cust2@email.com', 3, '2026-03-12 00:12:49', '$2y$10$/u7HCPqHRviH2'),
(8, 'customer3', '$2y$10$/hOmGkg2HzNvlNFoCAokVO9St/U.sjh9sDUizG8eQeSJvxx3n3VFe', 'cust3@email.com', 3, '2026-03-12 00:12:49', 'active'),
(9, 'customer4', '$2y$10$EOwOLNHD44Dkz0s3jGC6J.Yw0nOmmQLhHQK9jz.gpqBjDxoZ1jfZ2', 'cust4@email.com', 3, '2026-03-12 00:12:49', 'active'),
(10, 'customer5', '$2y$10$Fe3RYorOmwKGKZb/dK2dc.oelFxmoRutCcVW1Iw/rvaAFWHwpeyqi', 'cust5@email.com', 3, '2026-03-12 00:12:49', 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `fk_customers_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_order_items_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON UPDATE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
