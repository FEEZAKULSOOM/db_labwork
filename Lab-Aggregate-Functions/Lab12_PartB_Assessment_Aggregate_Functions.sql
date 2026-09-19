-- ============================================================
-- DATABASE SYSTEMS - LAB 12
-- Aggregate Functions - Part B + Assessment
-- GROUP BY, HAVING, JOINs and University Assessment
-- Manual Sections 6, 7, 9 and 11
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
-- PART B - GROUP BY, HAVING AND AGGREGATES WITH JOINs
-- ============================================================

-- Task B1: GROUP BY - counts customers in each city.
SELECT City, COUNT(*) AS NumCustomers
FROM Customer
GROUP BY City
ORDER BY NumCustomers DESC;


-- Task B2: GROUP BY - counts products in each category.
SELECT Category, COUNT(*) AS NumProducts
FROM Product
GROUP BY Category
ORDER BY NumProducts DESC;


-- Task B3: GROUP BY + MIN/MAX/AVG - summarizes prices by category.
SELECT Category,
       ROUND(AVG(Price), 2) AS AvgPrice,
       MIN(Price) AS MinPrice,
       MAX(Price) AS MaxPrice
FROM Product
GROUP BY Category
ORDER BY AvgPrice DESC;


-- Task B4: GROUP BY + SUM - calculates stock per category.
SELECT Category,
       SUM(StockQty) AS TotalStock
FROM Product
GROUP BY Category
ORDER BY TotalStock DESC;


-- Task B5: GROUP BY + YEAR - counts orders placed in each year.
SELECT YEAR(OrderDate) AS OrderYear,
       COUNT(*) AS NumOrders
FROM OrderItem
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;


-- Task B6: WHERE + GROUP BY - counts orders in each month of 2024.
SELECT MONTH(OrderDate) AS OrderMonth,
       COUNT(*) AS NumOrders
FROM OrderItem
WHERE YEAR(OrderDate) = 2024
GROUP BY MONTH(OrderDate)
ORDER BY OrderMonth;


-- Task B7: GROUP BY + HAVING - finds categories with average price > 5000.
SELECT Category,
       ROUND(AVG(Price), 2) AS AvgPrice
FROM Product
GROUP BY Category
HAVING AVG(Price) > 5000
ORDER BY AvgPrice DESC;


-- Task B8: WHERE + GROUP BY + HAVING - finds cities with more than one customer.
SELECT City,
       COUNT(*) AS NumCustomers
FROM Customer
WHERE City IS NOT NULL
GROUP BY City
HAVING COUNT(*) > 1
ORDER BY NumCustomers DESC;


-- Task B9: LEFT JOIN + COUNT - includes customers with zero orders.
SELECT c.CustID,
       c.CustName,
       COUNT(o.OrderID) AS NumOrders
FROM Customer c
LEFT JOIN OrderItem o ON c.CustID = o.CustID
GROUP BY c.CustID, c.CustName
ORDER BY NumOrders DESC, c.CustID;


-- Task B10: LEFT JOIN + SUM - includes products never sold.
SELECT p.ProdName,
       COALESCE(SUM(o.Quantity), 0) AS TotalQty
FROM Product p
LEFT JOIN OrderItem o ON p.ProdID = o.ProdID
GROUP BY p.ProdID, p.ProdName
ORDER BY TotalQty DESC;


-- Task B11: JOIN + GROUP BY + SUM - calculates revenue by category.
SELECT p.Category,
       SUM(o.Quantity * p.Price) AS Revenue
FROM OrderItem o
JOIN Product p ON o.ProdID = p.ProdID
GROUP BY p.Category
ORDER BY Revenue DESC;


-- Task B12: LEFT JOIN + SUM - calculates total spend per customer.
SELECT c.CustName,
       COALESCE(SUM(o.Quantity * p.Price), 0) AS TotalSpend
FROM Customer c
LEFT JOIN OrderItem o ON c.CustID = o.CustID
LEFT JOIN Product p ON o.ProdID = p.ProdID
GROUP BY c.CustID, c.CustName
ORDER BY TotalSpend DESC;


-- Task B13: GROUP BY + HAVING - finds customers spending over 50000.
SELECT c.CustName,
       SUM(o.Quantity * p.Price) AS TotalSpend
FROM Customer c
JOIN OrderItem o ON c.CustID = o.CustID
JOIN Product p ON o.ProdID = p.ProdID
GROUP BY c.CustID, c.CustName
HAVING SUM(o.Quantity * p.Price) > 50000
ORDER BY TotalSpend DESC;


-- Task B14: LEFT JOIN + GROUP BY + HAVING - summarizes each city.
SELECT c.City,
       COUNT(DISTINCT c.CustID) AS NumCustomers,
       COALESCE(SUM(o.Quantity * p.Price), 0) AS CityRevenue
FROM Customer c
LEFT JOIN OrderItem o ON c.CustID = o.CustID
LEFT JOIN Product p ON o.ProdID = p.ProdID
GROUP BY c.City
HAVING COUNT(DISTINCT c.CustID) > 1
ORDER BY CityRevenue DESC;


-- Task B15: GROUP BY + ORDER BY + LIMIT - finds the top 3 products by quantity.
SELECT p.ProdName,
       SUM(o.Quantity) AS TotalQty
FROM OrderItem o
JOIN Product p ON o.ProdID = p.ProdID
GROUP BY p.ProdID, p.ProdName
ORDER BY TotalQty DESC
LIMIT 3;


-- Task B16: JOIN + GROUP BY - calculates revenue for each year.
SELECT YEAR(o.OrderDate) AS OrderYear,
       SUM(o.Quantity * p.Price) AS Revenue
FROM OrderItem o
JOIN Product p ON o.ProdID = p.ProdID
GROUP BY YEAR(o.OrderDate)
ORDER BY OrderYear;


-- Task B17: Subquery + GROUP BY + AVG - calculates average order value.
SELECT ROUND(AVG(OrderValue), 2) AS AverageOrderValue
FROM (
    SELECT o.OrderID,
           SUM(o.Quantity * p.Price) AS OrderValue
    FROM OrderItem o
    JOIN Product p ON o.ProdID = p.ProdID
    GROUP BY o.OrderID
) AS OrderTotals;


-- ============================================================
-- ASSESSMENT - UNIVERSITY DATABASE
-- ============================================================

-- Create the University database and load the assessment data.
CREATE DATABASE IF NOT EXISTS uni_lab;
USE uni_lab;

DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
    StudentID  INT PRIMARY KEY,
    FullName   VARCHAR(60) NOT NULL,
    City       VARCHAR(30),
    EnrollDate DATE
);

CREATE TABLE Course (
    CourseID   VARCHAR(10) PRIMARY KEY,
    CourseName VARCHAR(60) NOT NULL,
    Department VARCHAR(30),
    Credits    INT,
    Fee        DECIMAL(10,2)
);

CREATE TABLE Enrollment (
    EnrollID       INT PRIMARY KEY,
    StudentID      INT,
    CourseID       VARCHAR(10),
    Marks          INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Insert the student data from the assessment.
INSERT INTO Student VALUES
(1001, 'Ahmad Raza',    'Lahore',    '2022-09-01'),
(1002, 'Sara Imran',    'Karachi',   '2022-09-01'),
(1003, 'Bilal Khan',    'Lahore',    '2023-09-01'),
(1004, 'Fatima Ali',    'Islamabad', '2022-09-01'),
(1005, 'Hira Yousaf',   NULL,        '2024-09-01'),
(1006, 'Zain Abbas',    'Karachi',   '2023-09-01'),
(1007, 'Mehwish Anwar', 'Lahore',    '2022-09-01'),
(1008, 'Talha Hussain', 'Islamabad', '2024-09-01'),
(1009, 'Areeba Yasin',  'Lahore',    '2023-09-01');

-- Insert the course data from the assessment.
INSERT INTO Course VALUES
('CS101', 'Intro to Programming', 'Computer Science', 3, 25000),
('CS201', 'Database Systems',     'Computer Science', 3, 28000),
('CS301', 'Operating Systems',    'Computer Science', 4, 30000),
('MT101', 'Calculus I',           'Mathematics',      3, 22000),
('EE201', 'Digital Logic',        'Electrical Engg',  3, 26000),
('BB301', 'Marketing Basics',     'Business',         3, 24000);

-- Insert the enrollment data from the assessment.
INSERT INTO Enrollment VALUES
(1,  1001, 'CS101', 78, '2022-09-15'),
(2,  1001, 'CS201', 85, '2023-09-15'),
(3,  1001, 'MT101', 90, '2022-09-15'),
(4,  1002, 'CS101', 65, '2022-09-15'),
(5,  1002, 'CS201', 72, '2023-09-15'),
(6,  1003, 'CS101', 88, '2023-09-15'),
(7,  1003, 'EE201', 80, '2023-09-15'),
(8,  1004, 'MT101', 95, '2022-09-15'),
(9,  1004, 'CS201', 70, '2023-09-15'),
(10, 1005, 'CS101', 55, '2024-09-15'),
(11, 1006, 'CS101', 82, '2023-09-15'),
(12, 1006, 'CS301', 76, '2024-09-15'),
(13, 1007, 'CS201', 91, '2023-09-15'),
(14, 1007, 'CS301', 86, '2024-09-15'),
(15, 1008, 'CS101', 60, '2024-09-15'),
(16, 1008, 'MT101', 68, '2024-09-15');


-- ============================================================
-- ASSESSMENT QUESTIONS
-- ============================================================

-- Q1: COUNT(*) - counts the total students and courses.
SELECT
    (SELECT COUNT(*) FROM Student) AS TotalStudents,
    (SELECT COUNT(*) FROM Course) AS TotalCourses;


-- Q2: COUNT(DISTINCT) - counts unique non-NULL student cities.
SELECT COUNT(DISTINCT City) AS DistinctCities
FROM Student;


-- Q3: AVG/MIN/MAX - summarizes marks across all enrollments.
SELECT ROUND(AVG(Marks), 2) AS AvgMarks,
       MIN(Marks) AS MinMarks,
       MAX(Marks) AS MaxMarks
FROM Enrollment;


-- Q4: GROUP BY - counts students in each city, including NULL.
SELECT City,
       COUNT(*) AS NumStudents
FROM Student
GROUP BY City
ORDER BY
    City IS NOT NULL DESC,
    NumStudents DESC;


-- Q5: GROUP BY - counts courses offered by each department.
SELECT Department,
       COUNT(*) AS NumCourses
FROM Course
GROUP BY Department
ORDER BY NumCourses DESC;


-- Q6: LEFT JOIN + GROUP BY - counts enrollments and averages marks per course.
SELECT c.CourseName,
       COUNT(e.EnrollID) AS NumStudents,
       ROUND(AVG(e.Marks), 2) AS AvgMarks
FROM Course c
LEFT JOIN Enrollment e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
ORDER BY AvgMarks DESC;


-- Q7: GROUP BY + HAVING - finds courses with average marks above 80.
SELECT c.CourseName,
       ROUND(AVG(e.Marks), 2) AS AvgMarks
FROM Course c
JOIN Enrollment e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName
HAVING AVG(e.Marks) > 80
ORDER BY AvgMarks DESC;


-- Q8: JOIN + GROUP BY + SUM - calculates fee revenue by department.
SELECT c.Department,
       SUM(c.Fee) AS TotalRevenue
FROM Course c
JOIN Enrollment e ON c.CourseID = e.CourseID
GROUP BY c.Department
ORDER BY TotalRevenue DESC;


-- Q9: LEFT JOIN + GROUP BY - includes students with no enrollments.
SELECT s.FullName,
       COUNT(e.EnrollID) AS NumCourses,
       ROUND(AVG(e.Marks), 2) AS AvgMarks
FROM Student s
LEFT JOIN Enrollment e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.FullName
ORDER BY NumCourses DESC, s.FullName;


-- Q10: GROUP BY + HAVING + MAX - finds students scoring above 85.
SELECT s.FullName,
       MAX(e.Marks) AS HighestMark
FROM Student s
JOIN Enrollment e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.FullName
HAVING MAX(e.Marks) > 85
ORDER BY HighestMark DESC;


-- Q11: JOIN + GROUP BY + HAVING - finds departments with average marks below 75.
SELECT c.Department,
       ROUND(AVG(e.Marks), 2) AS OverallAvgMarks
FROM Course c
JOIN Enrollment e ON c.CourseID = e.CourseID
GROUP BY c.Department
HAVING AVG(e.Marks) < 75
ORDER BY OverallAvgMarks;


-- Q12: JOIN + GROUP BY + ORDER BY + LIMIT - finds top 3 students by paid fees.
SELECT s.FullName,
       SUM(c.Fee) AS TotalFee
FROM Student s
JOIN Enrollment e ON s.StudentID = e.StudentID
JOIN Course c ON e.CourseID = c.CourseID
GROUP BY s.StudentID, s.FullName
ORDER BY TotalFee DESC
LIMIT 3;
