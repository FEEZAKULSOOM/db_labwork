-- ============================================================
-- DATABASE SYSTEMS - LAB 7
-- Topic: SQL Filters
-- Coverage: Part B - BETWEEN, IN, LIKE, IS NULL, ORDER BY, LIMIT + Assessment Problem
-- ============================================================

USE filters_lab;

-- ==================== TASK B1 ====================
SELECT EmpID, EmpName, Salary
FROM Employee
WHERE Salary BETWEEN 75000 AND 100000
ORDER BY Salary ASC;

-- ==================== TASK B2 ====================
SELECT EmpID, EmpName, HireDate
FROM Employee
WHERE HireDate BETWEEN '2020-01-01' AND '2022-12-31'
ORDER BY HireDate ASC;

-- ==================== TASK B3 ====================
SELECT EmpID, EmpName, Salary
FROM Employee
WHERE Salary NOT BETWEEN 80000 AND 100000;

-- ==================== TASK B4 ====================
SELECT EmpID, EmpName, City, Salary
FROM Employee
WHERE City IN ('Lahore', 'Islamabad')
ORDER BY City ASC, Salary DESC;

-- ==================== TASK B5 ====================
SELECT EmpID, EmpName, DeptName
FROM Employee
WHERE DeptName NOT IN ('Engineering', 'Sales', 'HR');

-- ==================== TASK B6 ====================
SELECT EmpName
FROM Employee
WHERE EmpName LIKE 'M%';

-- ==================== TASK B7 ====================
SELECT EmpID, EmpName
FROM Employee
WHERE EmpName LIKE '%a%';

-- ==================== TASK B8 ====================
SELECT EmpID, EmpName
FROM Employee
WHERE EmpName LIKE '%an';

-- ==================== TASK B9 ====================
SELECT EmpID, EmpName, JobTitle, DeptName
FROM Employee
WHERE JobTitle LIKE '%Engineer%'
  AND DeptName != 'Engineering';

-- ==================== TASK B10 ====================
SELECT EmpID, EmpName
FROM Employee
WHERE City IS NULL;

-- ==================== TASK B11 ====================
SELECT EmpID, EmpName, City
FROM Employee
WHERE City IS NOT NULL
ORDER BY City ASC;

-- ==================== TASK B12 ====================
SELECT EmpName, Salary
FROM Employee
ORDER BY Salary DESC
LIMIT 3;

-- ==================== TASK B13 ====================
SELECT EmpID, EmpName, HireDate
FROM Employee
ORDER BY HireDate DESC
LIMIT 5;

-- ==================== TASK B14 ====================
SELECT EmpID, EmpName, Salary
FROM Employee
ORDER BY Salary ASC
LIMIT 3;

-- ==================== TASK B15 ====================
SELECT EmpID, EmpName, DeptName, HireDate
FROM Employee
ORDER BY DeptName ASC, HireDate ASC;

-- ============================================================
-- ASSESSMENT: ONLINE BOOKSTORE
-- ============================================================

CREATE DATABASE IF NOT EXISTS bookstore_lab;
USE bookstore_lab;

DROP TABLE IF EXISTS Book;

CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(80) NOT NULL,
    Author VARCHAR(60),
    Genre VARCHAR(30),
    Price DECIMAL(8,2),
    StockQty INT,
    PublishedYear INT,
    Publisher VARCHAR(40),
    Language VARCHAR(20)
);

INSERT INTO Book
    (BookID, Title, Author, Genre, Price, StockQty,
     PublishedYear, Publisher, Language)
VALUES
(1,'Pride and Prejudice','Jane Austen','Fiction',850,12,1813,'Penguin','English'),
(2,'Emma','Jane Austen','Fiction',900,8,1815,'Penguin','English'),
(3,'Things Fall Apart','Chinua Achebe','Fiction',1100,5,1958,'Heinemann','English'),
(4,'Norwegian Wood','Haruki Murakami','Fiction',1500,3,1987,'Vintage','English'),
(5,'Kafka on the Shore','Haruki Murakami','Fiction',1700,0,2002,'Vintage','English'),
(6,'Ice-Candy-Man','Bapsi Sidhwa','Fiction',1200,15,1988,'Penguin','English'),
(7,'The Reluctant Fundamentalist','Mohsin Hamid','Fiction',1300,9,2007,'Penguin','English'),
(8,'Exit West','Mohsin Hamid','Fiction',1450,6,2017,'Riverhead','English'),
(9,'Atomic Habits','James Clear','Self-help',1800,20,2018,'Avery','English'),
(10,'The Power of Habit','Charles Duhigg','Self-help',1600,11,2012,'Random House','English'),
(11,'Sapiens','Yuval Harari','History',2200,7,2011,'Harper','English'),
(12,'Rich Dad Poor Dad','Robert Kiyosaki','Finance',1100,25,1997,'Plata','English'),
(13,'Aab-e-Hayat','Ibn-e-Safi','Mystery',650,18,1955,'Asrar','Urdu'),
(14,'Raja Gidh','Bano Qudsia','Fiction',900,14,1981,'Sang-e-Meel','Urdu'),
(15,'Mystery Title',NULL,'Mystery',950,4,2020,NULL,'English');

SELECT * FROM Book;

-- ==================== ASSESSMENT Q1 ====================
SELECT Title, Price
FROM Book
WHERE Price > 1500;

-- ==================== ASSESSMENT Q2 ====================
SELECT Title, PublishedYear
FROM Book
WHERE PublishedYear BETWEEN 1900 AND 2000
ORDER BY PublishedYear ASC;

-- ==================== ASSESSMENT Q3 ====================
SELECT BookID, Title, Genre, StockQty
FROM Book
WHERE Genre IN ('Fiction', 'Mystery')
  AND StockQty > 5;

-- ==================== ASSESSMENT Q4 ====================
SELECT Title, Author
FROM Book
WHERE Title LIKE '%the%';

-- ==================== ASSESSMENT Q5 ====================
SELECT BookID, Title
FROM Book
WHERE Title LIKE 'A%'
   OR Title LIKE '%t';

-- ==================== ASSESSMENT Q6 ====================
SELECT Title
FROM Book
WHERE Author IS NULL;

-- ==================== ASSESSMENT Q7 ====================
SELECT BookID, Title, StockQty, Publisher
FROM Book
WHERE StockQty = 0
   OR Publisher IS NULL;

-- ==================== ASSESSMENT Q8 ====================
SELECT Title, Price, StockQty
FROM Book
WHERE StockQty > 0
ORDER BY Price DESC
LIMIT 3;

-- ==================== ASSESSMENT Q9 ====================
SELECT BookID, Title, Author, PublishedYear
FROM Book
WHERE Language = 'Urdu'
ORDER BY PublishedYear ASC;

-- ==================== ASSESSMENT Q10 ====================
SELECT BookID, Title, Genre, Price, PublishedYear
FROM Book
WHERE PublishedYear < 2000
  AND Price < 1200
ORDER BY Genre ASC, Title ASC;

-- ============================================================
-- END OF LAB 7
-- ============================================================
