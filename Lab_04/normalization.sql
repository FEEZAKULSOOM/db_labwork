-- ======================================================
-- DATABASE NORMALIZATION LAB
-- Student: Feeza Kulsoom
-- Roll No: 2024-SE-03
-- Reg No: 2024-UMDB-004738
-- ======================================================

-- ======================================================
-- TASK 2: 1NF TABLE
-- ======================================================

CREATE DATABASE bookstore_normalization;
USE bookstore_normalization;

CREATE TABLE OrderBook_1NF (
    OrderID VARCHAR(10),
    OrderDate DATE,
    CustID VARCHAR(10),
    CustName VARCHAR(50),
    CustEmail VARCHAR(50),
    BookID VARCHAR(10),
    BookTitle VARCHAR(100),
    Publisher VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Qty INT,
    PRIMARY KEY (OrderID, BookID)
);

INSERT INTO OrderBook_1NF VALUES
('O-501', '2026-04-02', 'C-11', 'Bilal', 'bilal@x.com', 'B-1', 'SQL Basics', 'Pearson', 1200, 1),
('O-501', '2026-04-02', 'C-11', 'Bilal', 'bilal@x.com', 'B-2', 'Python 101', 'OReilly', 1500, 2),
('O-502', '2026-04-03', 'C-12', 'Areeba', 'areeba@x.com', 'B-1', 'SQL Basics', 'Pearson', 1200, 3),
('O-503', '2026-04-05', 'C-11', 'Bilal', 'bilal@x.com', 'B-3', 'Networks', 'Pearson', 1800, 1),
('O-503', '2026-04-05', 'C-11', 'Bilal', 'bilal@x.com', 'B-2', 'Python 101', 'OReilly', 1500, 1);

-- Verify 1NF Table
SELECT * FROM OrderBook_1NF;

-- ======================================================
-- TASK 3: 2NF TABLES
-- ======================================================

CREATE TABLE Orders_2NF (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE,
    CustID VARCHAR(10),
    CustName VARCHAR(50),
    CustEmail VARCHAR(50)
);

CREATE TABLE Books_2NF (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(100),
    Publisher VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE OrderDetails_2NF (
    OrderID VARCHAR(10),
    BookID VARCHAR(10),
    Qty INT,
    PRIMARY KEY (OrderID, BookID),
    FOREIGN KEY (OrderID) REFERENCES Orders_2NF(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books_2NF(BookID)
);

INSERT INTO Orders_2NF VALUES
('O-501', '2026-04-02', 'C-11', 'Bilal', 'bilal@x.com'),
('O-502', '2026-04-03', 'C-12', 'Areeba', 'areeba@x.com'),
('O-503', '2026-04-05', 'C-11', 'Bilal', 'bilal@x.com');

INSERT INTO Books_2NF VALUES
('B-1', 'SQL Basics', 'Pearson', 1200),
('B-2', 'Python 101', 'OReilly', 1500),
('B-3', 'Networks', 'Pearson', 1800);

INSERT INTO OrderDetails_2NF VALUES
('O-501', 'B-1', 1),
('O-501', 'B-2', 2),
('O-502', 'B-1', 3),
('O-503', 'B-3', 1),
('O-503', 'B-2', 1);

-- Verify 2NF Tables
SELECT * FROM Orders_2NF;
SELECT * FROM Books_2NF;
SELECT * FROM OrderDetails_2NF;

-- ======================================================
-- TASK 4: 3NF TABLES
-- ======================================================

CREATE TABLE Customers_3NF (
    CustID VARCHAR(10) PRIMARY KEY,
    CustName VARCHAR(50),
    CustEmail VARCHAR(50)
);

CREATE TABLE Orders_3NF (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE,
    CustID VARCHAR(10),
    FOREIGN KEY (CustID) REFERENCES Customers_3NF(CustID)
);

CREATE TABLE Books_3NF (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(100),
    Publisher VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE OrderDetails_3NF (
    OrderID VARCHAR(10),
    BookID VARCHAR(10),
    Qty INT,
    PRIMARY KEY (OrderID, BookID),
    FOREIGN KEY (OrderID) REFERENCES Orders_3NF(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books_3NF(BookID)
);

INSERT INTO Customers_3NF VALUES
('C-11', 'Bilal', 'bilal@x.com'),
('C-12', 'Areeba', 'areeba@x.com');

INSERT INTO Orders_3NF VALUES
('O-501', '2026-04-02', 'C-11'),
('O-502', '2026-04-03', 'C-12'),
('O-503', '2026-04-05', 'C-11');

INSERT INTO Books_3NF VALUES
('B-1', 'SQL Basics', 'Pearson', 1200),
('B-2', 'Python 101', 'OReilly', 1500),
('B-3', 'Networks', 'Pearson', 1800);

INSERT INTO OrderDetails_3NF VALUES
('O-501', 'B-1', 1),
('O-501', 'B-2', 2),
('O-502', 'B-1', 3),
('O-503', 'B-3', 1),
('O-503', 'B-2', 1);

-- Verify 3NF Tables
SELECT * FROM Customers_3NF;
SELECT * FROM Orders_3NF;
SELECT * FROM Books_3NF;
SELECT * FROM OrderDetails_3NF;

-- ======================================================
-- TASK 5: VERIFICATION QUERIES
-- ======================================================

-- Query 1: Reproduce original report
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
JOIN Customers_3NF c ON o.CustID = c.CustID
JOIN OrderDetails_3NF od ON o.OrderID = od.OrderID
JOIN Books_3NF b ON od.BookID = b.BookID
ORDER BY o.OrderID, b.BookID;

-- Query 2: Customer total spend
SELECT 
    c.CustID,
    c.CustName,
    SUM(od.Qty * b.UnitPrice) AS TotalSpend
FROM Customers_3NF c
JOIN Orders_3NF o ON c.CustID = o.CustID
JOIN OrderDetails_3NF od ON o.OrderID = od.OrderID
JOIN Books_3NF b ON od.BookID = b.BookID
GROUP BY c.CustID, c.CustName
ORDER BY TotalSpend DESC;