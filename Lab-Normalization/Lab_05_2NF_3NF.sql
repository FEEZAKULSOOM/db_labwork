-- ============================================================
-- DATABASE SYSTEMS LAB 5
-- Topic: Database Normalization
-- Coverage: 2NF and 3NF
-- Scenario: Small Online Bookstore
-- ============================================================

USE Bookstore_Normalization;

-- ============================================================
-- PRE-REQUIREMENT: 1NF TABLE
-- ============================================================
-- This lab continues from LAB 2.
-- OrderBook_1NF must contain the 1NF data.

SELECT * FROM OrderBook_1NF;

-- ============================================================
-- TASK 3: CONVERT 1NF TO 2NF
-- ============================================================
--
-- 1NF primary key:
-- (OrderID, BookID)
--
-- Functional Dependencies:
-- OrderID -> OrderDate, CustID, CustName, CustEmail
-- BookID -> BookTitle, Publisher, UnitPrice
-- (OrderID, BookID) -> Qty
--
-- Partial dependencies:
-- 1. OrderID -> OrderDate, CustID, CustName, CustEmail
-- 2. BookID -> BookTitle, Publisher, UnitPrice
--
-- These are partial dependencies because non-key attributes
-- depend on only part of the composite key.
--
-- 2NF decomposition:
--
-- ORDERS_2NF
-- OrderID -> OrderDate, CustID, CustName, CustEmail
--
-- BOOKS_2NF
-- BookID -> BookTitle, Publisher, UnitPrice
--
-- ORDER_DETAILS_2NF
-- (OrderID, BookID) -> Qty

-- ------------------------------------------------------------
-- Remove old 2NF tables if script is rerun
-- ------------------------------------------------------------
DROP TABLE IF EXISTS OrderDetails_2NF;
DROP TABLE IF EXISTS Books_2NF;
DROP TABLE IF EXISTS Orders_2NF;

-- ------------------------------------------------------------
-- ORDERS_2NF
-- ------------------------------------------------------------
CREATE TABLE Orders_2NF (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustID VARCHAR(10) NOT NULL,
    CustName VARCHAR(100) NOT NULL,
    CustEmail VARCHAR(150) NOT NULL
);

-- ------------------------------------------------------------
-- BOOKS_2NF
-- ------------------------------------------------------------
CREATE TABLE Books_2NF (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(150) NOT NULL,
    Publisher VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL
);

-- ------------------------------------------------------------
-- ORDER DETAILS_2NF
-- ------------------------------------------------------------
CREATE TABLE OrderDetails_2NF (
    OrderID VARCHAR(10) NOT NULL,
    BookID VARCHAR(10) NOT NULL,
    Qty INT NOT NULL,
    PRIMARY KEY (OrderID, BookID),
    CONSTRAINT fk_2nf_order
        FOREIGN KEY (OrderID)
        REFERENCES Orders_2NF(OrderID),
    CONSTRAINT fk_2nf_book
        FOREIGN KEY (BookID)
        REFERENCES Books_2NF(BookID)
);

-- ------------------------------------------------------------
-- LOAD DATA INTO 2NF TABLES
-- ------------------------------------------------------------

INSERT INTO Orders_2NF
    (OrderID, OrderDate, CustID, CustName, CustEmail)
SELECT DISTINCT
    OrderID,
    OrderDate,
    CustID,
    CustName,
    CustEmail
FROM OrderBook_1NF;

INSERT INTO Books_2NF
    (BookID, BookTitle, Publisher, UnitPrice)
SELECT DISTINCT
    BookID,
    BookTitle,
    Publisher,
    UnitPrice
FROM OrderBook_1NF;

INSERT INTO OrderDetails_2NF
    (OrderID, BookID, Qty)
SELECT
    OrderID,
    BookID,
    Qty
FROM OrderBook_1NF;

-- ------------------------------------------------------------
-- VERIFY 2NF
-- ------------------------------------------------------------
SELECT * FROM Orders_2NF;
SELECT * FROM Books_2NF;
SELECT * FROM OrderDetails_2NF;

-- Verify foreign-key relationships
SELECT
    od.OrderID,
    od.BookID,
    od.Qty,
    o.OrderDate,
    b.BookTitle,
    b.Publisher,
    b.UnitPrice
FROM OrderDetails_2NF od
JOIN Orders_2NF o
    ON od.OrderID = o.OrderID
JOIN Books_2NF b
    ON od.BookID = b.BookID
ORDER BY od.OrderID, od.BookID;

-- ============================================================
-- TASK 4: CONVERT 2NF TO 3NF
-- ============================================================
--
-- Transitive dependency remaining in Orders_2NF:
--
-- OrderID -> CustID
-- CustID -> CustName, CustEmail
--
-- Therefore:
-- OrderID -> CustID -> CustName, CustEmail
--
-- CustName and CustEmail depend transitively on OrderID
-- through CustID.
--
-- To achieve 3NF:
--
-- CUSTOMERS
-- CustID -> CustName, CustEmail
--
-- ORDERS_3NF
-- OrderID -> OrderDate, CustID
--
-- BOOKS_3NF
-- BookID -> BookTitle, Publisher, UnitPrice
--
-- ORDER_DETAILS_3NF
-- (OrderID, BookID) -> Qty

-- ------------------------------------------------------------
-- Remove old 3NF tables if script is rerun
-- ------------------------------------------------------------
DROP TABLE IF EXISTS OrderDetails_3NF;
DROP TABLE IF EXISTS Orders_3NF;
DROP TABLE IF EXISTS Books_3NF;
DROP TABLE IF EXISTS Customers_3NF;

-- ------------------------------------------------------------
-- CUSTOMERS_3NF
-- ------------------------------------------------------------
CREATE TABLE Customers_3NF (
    CustID VARCHAR(10) PRIMARY KEY,
    CustName VARCHAR(100) NOT NULL,
    CustEmail VARCHAR(150) NOT NULL UNIQUE
);

-- ------------------------------------------------------------
-- BOOKS_3NF
-- ------------------------------------------------------------
CREATE TABLE Books_3NF (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(150) NOT NULL,
    Publisher VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL
);

-- ------------------------------------------------------------
-- ORDERS_3NF
-- ------------------------------------------------------------
CREATE TABLE Orders_3NF (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustID VARCHAR(10) NOT NULL,
    CONSTRAINT fk_3nf_order_customer
        FOREIGN KEY (CustID)
        REFERENCES Customers_3NF(CustID)
);

-- ------------------------------------------------------------
-- ORDER DETAILS_3NF
-- ------------------------------------------------------------
CREATE TABLE OrderDetails_3NF (
    OrderID VARCHAR(10) NOT NULL,
    BookID VARCHAR(10) NOT NULL,
    Qty INT NOT NULL,
    PRIMARY KEY (OrderID, BookID),
    CONSTRAINT fk_3nf_detail_order
        FOREIGN KEY (OrderID)
        REFERENCES Orders_3NF(OrderID),
    CONSTRAINT fk_3nf_detail_book
        FOREIGN KEY (BookID)
        REFERENCES Books_3NF(BookID)
);

-- ------------------------------------------------------------
-- LOAD CUSTOMER DATA
-- ------------------------------------------------------------
INSERT INTO Customers_3NF
    (CustID, CustName, CustEmail)
SELECT DISTINCT
    CustID,
    CustName,
    CustEmail
FROM OrderBook_1NF;

-- ------------------------------------------------------------
-- LOAD BOOK DATA
-- ------------------------------------------------------------
INSERT INTO Books_3NF
    (BookID, BookTitle, Publisher, UnitPrice)
SELECT DISTINCT
    BookID,
    BookTitle,
    Publisher,
    UnitPrice
FROM OrderBook_1NF;

-- ------------------------------------------------------------
-- LOAD ORDER DATA
-- ------------------------------------------------------------
INSERT INTO Orders_3NF
    (OrderID, OrderDate, CustID)
SELECT DISTINCT
    OrderID,
    OrderDate,
    CustID
FROM OrderBook_1NF;

-- ------------------------------------------------------------
-- LOAD ORDER DETAIL DATA
-- ------------------------------------------------------------
INSERT INTO OrderDetails_3NF
    (OrderID, BookID, Qty)
SELECT
    OrderID,
    BookID,
    Qty
FROM OrderBook_1NF;

-- ============================================================
-- TASK 5: VERIFICATION QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- 5A. Reproduce the original one-row-per-book report
-- ------------------------------------------------------------

SELECT
    o.OrderID,
    o.OrderDate,
    c.CustID,
    c.CustName,
    c.CustEmail,
    b.BookID,
    b.BookTitle,
    b.Publisher,
    b.UnitPrice,
    od.Qty
FROM Orders_3NF o
JOIN Customers_3NF c
    ON o.CustID = c.CustID
JOIN OrderDetails_3NF od
    ON o.OrderID = od.OrderID
JOIN Books_3NF b
    ON od.BookID = b.BookID
ORDER BY o.OrderID, b.BookID;

-- ------------------------------------------------------------
-- 5B. List every customer's total spend
-- ------------------------------------------------------------
-- Total = UnitPrice * Qty across all books purchased.

SELECT
    c.CustID,
    c.CustName,
    c.CustEmail,
    COALESCE(SUM(b.UnitPrice * od.Qty), 0) AS TotalSpend
FROM Customers_3NF c
LEFT JOIN Orders_3NF o
    ON c.CustID = o.CustID
LEFT JOIN OrderDetails_3NF od
    ON o.OrderID = od.OrderID
LEFT JOIN Books_3NF b
    ON od.BookID = b.BookID
GROUP BY
    c.CustID,
    c.CustName,
    c.CustEmail
ORDER BY c.CustID;

-- Expected totals from the supplied data:
-- Bilal (C-11):
-- O-501: 1200*1 + 1500*2 = 4200
-- O-503: 1800*1 + 1500*1 = 3300
-- Total = 7500
--
-- Areeba (C-12):
-- O-502: 1200*3 = 3600
-- Total = 3600

-- ============================================================
-- ADDITIONAL VERIFICATION
-- ============================================================

-- Customers
SELECT * FROM Customers_3NF;

-- Orders
SELECT * FROM Orders_3NF;

-- Books
SELECT * FROM Books_3NF;

-- Order details
SELECT * FROM OrderDetails_3NF;

-- Table structures
DESCRIBE Customers_3NF;
DESCRIBE Orders_3NF;
DESCRIBE Books_3NF;
DESCRIBE OrderDetails_3NF;

-- ============================================================
-- TASK 6: REFLECTION
-- ============================================================
--
-- The final 3NF schema reduces insertion anomalies by allowing
-- customers and books to be stored independently of orders.
-- Update anomalies are prevented because customer details are
-- stored once in Customers_3NF rather than being repeated in
-- every order row. Deletion anomalies are reduced because
-- deleting an order does not automatically remove the customer
-- or book information stored in their own tables. The
-- OrderDetails_3NF table stores only the relationship between
-- an order and a book, while foreign keys maintain referential
-- integrity. Overall, the 3NF design separates order, customer,
-- book, and purchase-line information according to their
-- functional dependencies.

-- ============================================================
-- END OF LAB 5
-- ============================================================
