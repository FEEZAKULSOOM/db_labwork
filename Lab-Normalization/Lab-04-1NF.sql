-- ============================================================
-- DATABASE SYSTEMS LAB 4
-- Topic: Database Normalization
-- Coverage: Raw Data, Functional Dependencies, Anomalies, 1NF
-- Scenario: Small Online Bookstore
-- ============================================================

-- ------------------------------------------------------------
-- 0. CREATE DATABASE
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS Bookstore_Normalization;
USE Bookstore_Normalization;

-- ============================================================
-- TASK 1: IDENTIFY FUNCTIONAL DEPENDENCIES AND ANOMALIES
-- ============================================================

-- Functional Dependencies identified from the given data:
--
-- 1. OrderID -> OrderDate, CustID, CustName, CustEmail
-- 2. CustID -> CustName, CustEmail
-- 3. BookID -> BookTitle, Publisher, UnitPrice
-- 4. (OrderID, BookID) -> Qty
--
-- In the 1NF design, the candidate/primary key is:
-- (OrderID, BookID)
--
-- Anomalies in the unnormalized design:
--
-- INSERTION ANOMALY:
-- A new book/publisher cannot be recorded easily unless it is
-- part of an order, because book information is stored with
-- order information.
--
-- UPDATE ANOMALY:
-- If a customer's email changes, every order row containing
-- that customer must be updated. Missing one row creates
-- inconsistent customer information.
--
-- DELETION ANOMALY:
-- If the only order containing a book is deleted, the book's
-- information (BookID, title, publisher and price) can also
-- be lost.

-- ============================================================
-- TASK 2: CONVERT THE RAW DATA TO 1NF
-- ============================================================
--
-- 1NF requirements:
-- * Every field contains one atomic value.
-- * No multi-valued/repeating groups.
-- * Each row represents one book purchased in one order.
--
-- Primary Key:
-- (OrderID, BookID)
--
-- 1NF rows:
-- O-501 | 2026-04-02 | C-11 | Bilal  | bilal@x.com | B-1 | SQL Basics  | Pearson  | 1200 | 1
-- O-501 | 2026-04-02 | C-11 | Bilal  | bilal@x.com | B-2 | Python 101  | OReilly | 1500 | 2
-- O-502 | 2026-04-03 | C-12 | Areeba | areeba@x.com | B-1 | SQL Basics  | Pearson  | 1200 | 3
-- O-503 | 2026-04-05 | C-11 | Bilal  | bilal@x.com | B-3 | Networks    | Pearson  | 1800 | 1
-- O-503 | 2026-04-05 | C-11 | Bilal  | bilal@x.com | B-2 | Python 101  | OReilly | 1500 | 1

-- ------------------------------------------------------------
-- Remove old 1NF table if this script is rerun
-- ------------------------------------------------------------
DROP TABLE IF EXISTS OrderBook_1NF;

-- ------------------------------------------------------------
-- CREATE 1NF TABLE
-- ------------------------------------------------------------
CREATE TABLE OrderBook_1NF (
    OrderID VARCHAR(10) NOT NULL,
    OrderDate DATE NOT NULL,
    CustID VARCHAR(10) NOT NULL,
    CustName VARCHAR(100) NOT NULL,
    CustEmail VARCHAR(150) NOT NULL,
    BookID VARCHAR(10) NOT NULL,
    BookTitle VARCHAR(150) NOT NULL,
    Publisher VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Qty INT NOT NULL,
    PRIMARY KEY (OrderID, BookID)
);

-- ------------------------------------------------------------
-- INSERT ALL 1NF ROWS
-- ------------------------------------------------------------
INSERT INTO OrderBook_1NF
    (OrderID, OrderDate, CustID, CustName, CustEmail,
     BookID, BookTitle, Publisher, UnitPrice, Qty)
VALUES
    ('O-501', '2026-04-02', 'C-11', 'Bilal',  'bilal@x.com',
     'B-1', 'SQL Basics', 'Pearson', 1200.00, 1),

    ('O-501', '2026-04-02', 'C-11', 'Bilal',  'bilal@x.com',
     'B-2', 'Python 101', 'OReilly', 1500.00, 2),

    ('O-502', '2026-04-03', 'C-12', 'Areeba', 'areeba@x.com',
     'B-1', 'SQL Basics', 'Pearson', 1200.00, 3),

    ('O-503', '2026-04-05', 'C-11', 'Bilal',  'bilal@x.com',
     'B-3', 'Networks', 'Pearson', 1800.00, 1),

    ('O-503', '2026-04-05', 'C-11', 'Bilal',  'bilal@x.com',
     'B-2', 'Python 101', 'OReilly', 1500.00, 1);

-- ============================================================
-- 1NF VERIFICATION
-- ============================================================

-- Display all rows
SELECT * FROM OrderBook_1NF;

-- Display table structure and primary key
DESCRIBE OrderBook_1NF;

-- Verify there are no multi-valued cells
SELECT
    OrderID,
    BookID,
    BookTitle,
    Publisher,
    UnitPrice,
    Qty
FROM OrderBook_1NF
ORDER BY OrderID, BookID;

-- Verify order header data
SELECT DISTINCT
    OrderID,
    OrderDate,
    CustID,
    CustName,
    CustEmail
FROM OrderBook_1NF
ORDER BY OrderID;

-- Verify book data
SELECT DISTINCT
    BookID,
    BookTitle,
    Publisher,
    UnitPrice
FROM OrderBook_1NF
ORDER BY BookID;

-- ============================================================
-- END OF LAB 4
-- ============================================================
