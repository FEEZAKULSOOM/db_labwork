-- ============================================================
-- DATABASE SYSTEMS - LAB 12
-- Aggregate Functions - Part A
-- Whole-Table Aggregates and COUNT Variations
-- Manual Sections 3, 4 and 5
-- ============================================================

-- Create the RetailStore database and load the lab data.
CREATE DATABASE IF NOT EXISTS agg_lab;
USE agg_lab;

DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    CustID    INT PRIMARY KEY,
    CustName  VARCHAR(60) NOT NULL,
    City      VARCHAR(30),
    JoinDate  DATE
);

CREATE TABLE Product (
    ProdID    INT PRIMARY KEY,
    ProdName  VARCHAR(60) NOT NULL,
    Category  VARCHAR(30),
    Price     DECIMAL(10,2),
    StockQty  INT
);

CREATE TABLE OrderItem (
    OrderID   INT PRIMARY KEY,
    CustID    INT,
    ProdID    INT,
    Quantity  INT,
    OrderDate DATE,
    FOREIGN KEY (CustID) REFERENCES Customer(CustID),
    FOREIGN KEY (ProdID) REFERENCES Product(ProdID)
);

-- Insert the customer data from the lab manual.
INSERT INTO Customer VALUES
(1, 'Ali Khan',     'Lahore',    '2022-01-15'),
(2, 'Sara Iqbal',   'Karachi',   '2022-04-22'),
(3, 'Hamza Raza',   'Lahore',    '2023-02-10'),
(4, 'Ayesha Noor',  'Islamabad', '2023-05-18'),
(5, 'Bilal Ahmed',  'Karachi',   '2023-09-01'),
(6, 'Fatima Sheikh', NULL,       '2024-01-12'),
(7, 'Usman Tariq',  'Lahore',    '2024-06-30'),
(8, 'Maira Javed',  'Islamabad', '2024-08-25');

-- Insert the product data from the lab manual.
INSERT INTO Product VALUES
(101, 'Laptop Pro 15',      'Electronics', 185000.00, 12),
(102, 'Wireless Mouse',     'Electronics',   2500.00, 50),
(103, 'USB-C Cable',        'Electronics',    800.00, 100),
(104, 'Office Chair',       'Furniture',    18500.00, 8),
(105, 'Standing Desk',      'Furniture',    45000.50, 5),
(106, 'Notebook A4',        'Stationery',     350.00, 200),
(107, 'Ballpoint Pen 10pk', 'Stationery',     450.00, 150),
(108, 'Coffee Beans 1kg',   'Grocery',       1899.99, 30),
(109, 'Green Tea Box',      'Grocery',        650.00, 45),
(110, 'Bluetooth Speaker',  'Electronics',   7500.00, 18);

-- Insert the order data from the lab manual.
INSERT INTO OrderItem VALUES
(1001, 1, 101, 1,  '2023-03-10'),
(1002, 1, 102, 2,  '2023-03-10'),
(1003, 2, 104, 1,  '2023-05-22'),
(1004, 2, 106, 5,  '2023-05-22'),
(1005, 3, 101, 1,  '2023-08-15'),
(1006, 3, 110, 1,  '2023-08-15'),
(1007, 4, 108, 3,  '2023-11-02'),
(1008, 5, 103, 4,  '2024-01-20'),
(1009, 5, 102, 1,  '2024-01-20'),
(1010, 6, 105, 1,  '2024-02-14'),
(1011, 7, 107, 2,  '2024-04-08'),
(1012, 7, 106, 10, '2024-04-08'),
(1013, 7, 109, 3,  '2024-07-19'),
(1014, 2, 110, 1,  '2024-09-05'),
(1015, 3, 108, 2,  '2024-10-11');


-- ============================================================
-- PART A - WHOLE-TABLE AGGREGATES & COUNT VARIATIONS
-- ============================================================

-- Task A1: COUNT(*) - counts all customers, products and orders.
SELECT COUNT(*) AS TotalCustomers
FROM Customer;

SELECT COUNT(*) AS TotalProducts
FROM Product;

SELECT COUNT(*) AS TotalOrders
FROM OrderItem;


-- Task A2: MIN/MAX - finds the cheapest and most expensive products.
SELECT MIN(Price) AS MinPrice,
       MAX(Price) AS MaxPrice
FROM Product;


-- Task A3: AVG - calculates the average product price.
SELECT ROUND(AVG(Price), 2) AS AveragePrice
FROM Product;


-- Task A4: SUM - calculates the total stock quantity.
SELECT SUM(StockQty) AS TotalStock
FROM Product;


-- Task A5: COUNT(DISTINCT) - counts unique non-NULL customer cities.
SELECT COUNT(DISTINCT City) AS DistinctCities
FROM Customer;


-- Task A6: COUNT(DISTINCT) - counts unique product categories.
SELECT COUNT(DISTINCT Category) AS DistinctCategories
FROM Product;


-- Task A7: COUNT(col) - compares customers with and without a city.
SELECT COUNT(City) AS CustomersWithCity,
       COUNT(*) - COUNT(City) AS CustomersWithoutCity
FROM Customer;


-- Task A8: MIN/MAX - finds the earliest and latest order dates.
SELECT MIN(OrderDate) AS EarliestOrderDate,
       MAX(OrderDate) AS LatestOrderDate
FROM OrderItem;


-- Task A9: SUM + JOIN - calculates total revenue from all orders.
SELECT SUM(o.Quantity * p.Price) AS TotalRevenue
FROM OrderItem o
JOIN Product p ON o.ProdID = p.ProdID;


-- Task A10: AVG - calculates the average quantity per order.
SELECT ROUND(AVG(Quantity), 2) AS AverageQuantity
FROM OrderItem;
