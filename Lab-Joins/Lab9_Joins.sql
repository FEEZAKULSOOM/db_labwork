-- ============================================================
-- DATABASE SYSTEMS - LAB 9
-- SQL JOINS - PART B + ASSESSMENT
-- Run Lab 8 first for the joins_lab database and Company data.
-- ============================================================

USE joins_lab;

-- ------------------------------------------------------------
-- PART B - SELF JOINS, MULTI-TABLE JOINS, COMBINED CHALLENGES
-- ------------------------------------------------------------

-- Task B1: SELF JOIN — related to Section 10; connects each employee with their manager.
SELECT e.EmpName AS Employee, m.EmpName AS Manager
FROM Employee e
LEFT JOIN Employee m ON e.ManagerID = m.EmpID;

-- Task B2: SELF JOIN + WHERE — related to Section 10; compares employee salary with manager salary.
SELECT e.EmpName AS Employee, e.Salary AS EmpSalary,
       m.EmpName AS Manager, m.Salary AS MgrSalary
FROM Employee e
INNER JOIN Employee m ON e.ManagerID = m.EmpID
WHERE e.Salary > m.Salary;

-- Task B3: SELF JOIN + multiple joins — related to Sections 10–11; compares employee, manager, and both departments.
SELECT e.EmpName AS EmpName,
       m.EmpName AS ManagerName,
       d1.DeptName AS EmployeeDepartment,
       d2.DeptName AS ManagerDepartment
FROM Employee e
INNER JOIN Employee m ON e.ManagerID = m.EmpID
INNER JOIN Department d1 ON e.DeptID = d1.DeptID
INNER JOIN Department d2 ON m.DeptID = d2.DeptID
WHERE e.DeptID <> m.DeptID;

-- Task B4: 3-table JOIN — related to Section 11; Employee → Assignment → Project.
SELECT e.EmpName, p.ProjectName, a.HoursPerWeek
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
ORDER BY e.EmpName;

-- Task B5: 4-table JOIN — related to Section 11; Employee → Assignment → Project → Department.
SELECT e.EmpName, p.ProjectName, d.DeptName
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
INNER JOIN Department d ON p.DeptID = d.DeptID
ORDER BY e.EmpName;

-- Task B6: Multi-table JOIN + filter — related to Section 11 and Lab #1 filters; finds employees on one project.
SELECT e.EmpName, a.HoursPerWeek
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Mobile App';

-- Task B7: LEFT JOIN + filter — related to Section 7 and Lab #1 filters; keeps Lahore employees even without assignments.
SELECT e.EmpName, p.ProjectName, a.HoursPerWeek
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
LEFT JOIN Project p ON a.ProjectID = p.ProjectID
WHERE e.City = 'Lahore';

-- Task B8: Multi-table JOIN + comparison — related to Section 11; compares employee and project departments.
SELECT DISTINCT e.EmpName
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
WHERE e.DeptID <> p.DeptID;

-- Task B9: LEFT JOIN + date condition — related to Section 8; keeps departments with no 2024 project.
SELECT d.DeptID, d.DeptName, p.ProjectName
FROM Department d
LEFT JOIN Project p
    ON d.DeptID = p.DeptID
   AND p.StartDate >= '2024-01-01'
   AND p.StartDate < '2025-01-01'
ORDER BY d.DeptID, p.ProjectName;

-- Task B10: LEFT JOIN + SUM + GROUP BY — related to Section 11; totals weekly hours and keeps employees with zero hours.
SELECT e.EmpID, e.EmpName,
       COALESCE(SUM(a.HoursPerWeek), 0) AS TotalHoursPerWeek
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
GROUP BY e.EmpID, e.EmpName
ORDER BY e.EmpID;

-- ============================================================
-- ASSESSMENT - LIBRARY DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS library_lab;
USE library_lab;

DROP TABLE IF EXISTS Loan;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Author;

CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(60) NOT NULL,
    Country VARCHAR(30)
);

CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(80) NOT NULL,
    Genre VARCHAR(30),
    Price DECIMAL(8,2),
    AuthorID INT,
    PublishedYear INT,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(60) NOT NULL,
    City VARCHAR(30),
    JoinDate DATE
);

CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

INSERT INTO Author VALUES
(1, 'Jane Austen', 'UK'),
(2, 'Chinua Achebe', 'Nigeria'),
(3, 'Haruki Murakami', 'Japan'),
(4, 'Bapsi Sidhwa', 'Pakistan'),
(5, 'Mohsin Hamid', 'Pakistan'),
(6, 'Anonymous Writer', NULL);

INSERT INTO Book VALUES
(101, 'Pride and Prejudice', 'Fiction', 850.00, 1, 1813),
(102, 'Emma', 'Fiction', 900.00, 1, 1815),
(103, 'Things Fall Apart', 'Fiction', 1100.00, 2, 1958),
(104, 'Norwegian Wood', 'Fiction', 1500.00, 3, 1987),
(105, 'Kafka on the Shore', 'Fiction', 1700.00, 3, 2002),
(106, 'Ice-Candy-Man', 'Fiction', 1200.00, 4, 1988),
(107, 'The Reluctant Fundamentalist', 'Fiction', 1300.00, 5, 2007),
(108, 'Exit West', 'Fiction', 1450.00, 5, 2017),
(109, 'Mystery Title', 'Mystery', 950.00, NULL, 2020);

INSERT INTO Member VALUES
(201, 'Ahmad Raza', 'Lahore', '2023-01-15'),
(202, 'Sara Imran', 'Karachi', '2023-03-20'),
(203, 'Bilal Khan', 'Lahore', '2024-02-10'),
(204, 'Fatima Ali', 'Islamabad', '2022-09-05'),
(205, 'Hira Yousaf', NULL, '2024-05-01');

INSERT INTO Loan VALUES
(1, 201, 101, '2024-03-01', '2024-03-15'),
(2, 201, 104, '2024-04-10', NULL),
(3, 202, 103, '2024-02-20', '2024-03-05'),
(4, 202, 107, '2024-05-01', NULL),
(5, 203, 105, '2024-04-25', '2024-05-15'),
(6, 204, 102, '2024-01-10', '2024-01-30'),
(7, 204, 108, '2024-06-01', NULL);

-- ------------------------------------------------------------
-- ASSESSMENT QUESTIONS
-- ------------------------------------------------------------

-- Q1: INNER JOIN — related to Section 6; matches each book with its author.
SELECT b.BookID, b.Title, a.AuthorName, a.Country
FROM Book b
INNER JOIN Author a ON b.AuthorID = a.AuthorID;

-- Q2: LEFT JOIN — related to Section 7; keeps authors even when they have no books.
SELECT a.AuthorID, a.AuthorName, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
ORDER BY a.AuthorID, b.Title;

-- Q3: ANTI-JOIN — related to Section 7; LEFT JOIN + IS NULL finds members with no loans.
SELECT m.MemberID, m.MemberName
FROM Member m
LEFT JOIN Loan l ON m.MemberID = l.MemberID
WHERE l.MemberID IS NULL;

-- Q4: 3-table JOIN — related to Section 11; connects Loan, Member, Book, and Author data.
SELECT l.LoanID, m.MemberName, b.Title, a.AuthorName
FROM Loan l
INNER JOIN Member m ON l.MemberID = m.MemberID
INNER JOIN Book b ON l.BookID = b.BookID
INNER JOIN Author a ON b.AuthorID = a.AuthorID;

-- Q5: Multi-table JOIN + WHERE — related to Section 11 and Lab #1 filters; finds currently borrowed books.
SELECT b.Title, m.MemberName, m.City
FROM Loan l
INNER JOIN Member m ON l.MemberID = m.MemberID
INNER JOIN Book b ON l.BookID = b.BookID
WHERE l.ReturnDate IS NULL;

-- Q6: LEFT JOIN + WHERE — related to Section 7 and Lab #1 filters; finds Pakistani authors and their books.
SELECT a.AuthorName, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
WHERE a.Country = 'Pakistan';

-- Q7: LEFT JOIN chain — related to Section 11; keeps books even when they have never been borrowed.
SELECT b.BookID, b.Title, m.MemberName
FROM Book b
LEFT JOIN Loan l ON b.BookID = l.BookID
LEFT JOIN Member m ON l.MemberID = m.MemberID
ORDER BY b.BookID, m.MemberName;

-- Q8: Multi-step ANTI-JOIN — related to Sections 7 and 11; finds authors whose books have no loans.
SELECT DISTINCT a.AuthorID, a.AuthorName
FROM Author a
INNER JOIN Book b ON a.AuthorID = b.AuthorID
LEFT JOIN Loan l ON b.BookID = l.BookID
WHERE l.LoanID IS NULL;

-- Q9: FULL OUTER JOIN — directly related to Section 9; uses LEFT JOIN + RIGHT JOIN + UNION in MySQL.
SELECT a.AuthorID, a.AuthorName, b.BookID, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
UNION
SELECT a.AuthorID, a.AuthorName, b.BookID, b.Title
FROM Author a
RIGHT JOIN Book b ON a.AuthorID = b.AuthorID;

-- Q10: 4-way JOIN + filter — related to Section 11 and Lab #1 filters; finds members borrowing books by Pakistani authors.
SELECT m.MemberName, b.Title AS BookTitle, a.AuthorName
FROM Member m
INNER JOIN Loan l ON m.MemberID = l.MemberID
INNER JOIN Book b ON l.BookID = b.BookID
INNER JOIN Author a ON b.AuthorID = a.AuthorID
WHERE a.Country = 'Pakistan';

-- END OF LAB 9
